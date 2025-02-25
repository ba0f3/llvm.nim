## ===-- llvm-c/ErrorHandling.h - Error Handling C Interface -------*- C -*-===*\
## |*                                                                            *|
## |*                     The LLVM Compiler Infrastructure                       *|
## |*                                                                            *|
## |* This file is distributed under the University of Illinois Open Source      *|
## |* License. See LICENSE.TXT for details.                                      *|
## |*                                                                            *|
## |*===----------------------------------------------------------------------===*|
## |*                                                                            *|
## |* This file defines the C interface to LLVM's error handling mechanism.      *|
## |*                                                                            *|
## \*===----------------------------------------------------------------------===

type
  FatalErrorHandler* = proc (reason: cstring)

## *
##  Install a fatal error handler. By default, if LLVM detects a fatal error, it
##  will call exit(1). This may not be appropriate in many contexts. For example,
##  doing exit(1) will bypass many crash reporting/tracing system tools. This
##  function allows you to install a callback that will be invoked prior to the
##  call to exit(1).
##

proc InstallFatalErrorHandler*(handler: FatalErrorHandler)  {.llvmc.}
## *
##  Reset the fatal error handler. This resets LLVM's fatal error handling
##  behavior to the default.
##

proc ResetFatalErrorHandler*()  {.llvmc.}
## *
##  Enable LLVM's built-in stack trace code. This intercepts the OS's crash
##  signals and prints which component of LLVM you were in at the time if the
##  crash.
##

proc EnablePrettyStackTrace*()  {.llvmc.}