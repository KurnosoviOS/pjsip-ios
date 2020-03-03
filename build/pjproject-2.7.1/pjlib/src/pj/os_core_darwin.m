/* $Id: os_core_darwin.m 3670 2011-07-20 03:00:48Z ming $ */
/*
 * Copyright (C) 2011-2011 Teluu Inc. (http://www.teluu.com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
#include <pj/os.h>
#include "TargetConditionals.h"

#if TARGET_OS_IPHONE

PJ_DEF(int) pj_run_app(pj_main_func_ptr main_func, int argc, char *argv[],
                       unsigned flags)
{
    return (*main_func)(argc, argv);
}

#else

#include <pthread.h>
#include <AppKit/AppKit.h>
#include <CoreFoundation/CFRunLoop.h>
#include <Foundation/Foundation.h>

#define THIS_FILE   "os_core_darwin.m"

typedef struct run_app_t {
    pj_main_func_ptr  main_func;
    int               argc;
    char            **argv;
    int               retval;
} run_app_t;

@interface DeadThread: NSObject { ;; }
+ (void)enterMultiThreadedMode;
+ (void)emptyThreadMethod:(id)obj;
@end

@implementation DeadThread
+ (void)enterMultiThreadedMode
{
    [NSThread detachNewThreadSelector:@selector(emptyThreadMethod:)
              toTarget:[DeadThread class] withObject:nil];
}

+ (void)emptyThreadMethod:(id)obj { ; }
@end

static void* main_thread(void *data)
{
    run_app_t *param = (run_app_t *)data;

    param->retval = (*param->main_func)(param->argc, param->argv);
    CFRunLoopStop(CFRunLoopGetMain());

    return NULL;
}

/*
 * pj_run_app()
 * This function has to be called from the main thread. The purpose of
 * this function is to initialize the application's memory pool, event
 * loop management, and multi-threading environment.
 */
PJ_DEF(int) pj_run_app(pj_main_func_ptr main_func, int argc, char *argv[],
                       unsigned flags)
{
    pthread_t thread;
    run_app_t param;
    NSAutoreleasePool *pool;

    pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];
    [DeadThread enterMultiThreadedMode];

    param.argc = argc;
    param.argv = (char **)argv;
    param.main_func = main_func;
    if (pthread_create(&thread, NULL, &main_thread, &param) == 0) {
        CFRunLoopRun();
    }

    PJ_UNUSED_ARG(pool);

    return param.retval;
}

#endif

#if defined(PJ_HAS_SEMAPHORE_H) && PJ_HAS_SEMAPHORE_H != 0
#  include <semaphore.h>

#include <pj/assert.h>
#include <pj/pool.h>
#include <pj/log.h>
#include <pj/rand.h>
#include <pj/string.h>
#include <pj/guid.h>
#include <pj/except.h>
#include <pj/errno.h>

///////////////////////////////////////////////////////////////////////////////
#if defined(PJ_HAS_SEMAPHORE) && PJ_HAS_SEMAPHORE != 0

struct pj_sem_t
{
    //sem_t           *sem;
    dispatch_semaphore_t darwinSem;
    char        obj_name[PJ_MAX_OBJ_NAME];
};

PJ_DEF(pj_status_t) pj_sem_create( pj_pool_t *pool,
                   const char *name,
                   unsigned initial,
                   unsigned max,
                   pj_sem_t **ptr_sem)
{
    pj_sem_t *sem;

    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(pool != NULL && ptr_sem != NULL, PJ_EINVAL);

    sem = PJ_POOL_ALLOC_T(pool, pj_sem_t);
    PJ_ASSERT_RETURN(sem, PJ_ENOMEM);

    /* MacOS X doesn't support anonymous semaphore */
    {
    char sem_name[PJ_GUID_MAX_LENGTH+1];

    pj_str_t nam;

    /* We should use SEM_NAME_LEN, but this doesn't seem to be
     * declared anywhere? The value here is just from trial and error
     * to get the longest name supported.
     */
#    define MAX_SEM_NAME_LEN    23

    /* Create a unique name for the semaphore. */
    if (PJ_GUID_STRING_LENGTH <= MAX_SEM_NAME_LEN) {
        nam.ptr = sem_name;
        pj_generate_unique_string(&nam);
        sem_name[nam.slen] = '\0';
    } else {
        pj_create_random_string(sem_name, MAX_SEM_NAME_LEN);
        sem_name[MAX_SEM_NAME_LEN] = '\0';
    }

    /* Create semaphore */
  PJ_LOG(4,(THIS_FILE, "<--test-->sem_open %s; initial:%d", sem_name, initial));
        sem->darwinSem = dispatch_semaphore_create(initial);
    }

    /* Set name. */
    if (!name) {
    name = "sem%p";
    }
    if (strchr(name, '%')) {
    pj_ansi_snprintf(sem->obj_name, PJ_MAX_OBJ_NAME, name, sem);
    } else {
    strncpy(sem->obj_name, name, PJ_MAX_OBJ_NAME);
    sem->obj_name[PJ_MAX_OBJ_NAME-1] = '\0';
    }

    PJ_LOG(6, (sem->obj_name, "Semaphore created"));

    *ptr_sem = sem;
    return PJ_SUCCESS;
}

/*
 * pj_sem_wait()
 */
PJ_DEF(pj_status_t) pj_sem_wait(pj_sem_t *sem)
{
    long result;

    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sem, PJ_EINVAL);

    PJ_LOG(6, (sem->obj_name, "Semaphore: thread %s is waiting",
                  pj_thread_this()->obj_name));

    result = dispatch_semaphore_wait(sem->darwinSem, DISPATCH_TIME_FOREVER);

    if (result == 0) {
    PJ_LOG(6, (sem->obj_name, "Semaphore acquired by thread %s",
                  pj_thread_this()->obj_name));
    } else {
    PJ_LOG(6, (sem->obj_name, "Semaphore: thread %s FAILED to acquire",
                  pj_thread_this()->obj_name));
    }

    if (result == 0)
    return PJ_SUCCESS;
    else
    return PJ_RETURN_OS_ERROR(-1);
}

/*
 * pj_sem_trywait()
 */
PJ_DEF(pj_status_t) pj_sem_trywait(pj_sem_t *sem)
{
    long result;

    PJ_CHECK_STACK();
    PJ_ASSERT_RETURN(sem, PJ_EINVAL);

    result = dispatch_semaphore_wait(sem->darwinSem, DISPATCH_TIME_NOW);

    if (result == 0) {
    PJ_LOG(6, (sem->obj_name, "Semaphore acquired by thread %s",
                  pj_thread_this()->obj_name));
    }
    if (result == 0)
    return PJ_SUCCESS;
    else
    return PJ_RETURN_OS_ERROR(-1);
}

/*
 * pj_sem_post()
 */
PJ_DEF(pj_status_t) pj_sem_post(pj_sem_t *sem)
{
#if PJ_HAS_THREADS
    long result;
    PJ_LOG(6, (sem->obj_name, "Semaphore released by thread %s",
                  pj_thread_this()->obj_name));
    result = dispatch_semaphore_signal(sem->darwinSem);

    if (result == 0)
    return PJ_SUCCESS;
    else
    return PJ_RETURN_OS_ERROR(-1);
#else
    pj_assert( sem == (pj_sem_t*) 1);
    return PJ_SUCCESS;
#endif
}

/*
 * pj_sem_destroy()
 */
PJ_DEF(pj_status_t) pj_sem_destroy(pj_sem_t *sem)
{
    return PJ_SUCCESS;
}

#endif    /* PJ_HAS_SEMAPHORE */


#endif
