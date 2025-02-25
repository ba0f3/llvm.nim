## ===-- llvm-c/lto.h - LTO Public C Interface ---------------------*- C -*-===*\
## |*                                                                            *|
## |*                     The LLVM Compiler Infrastructure                       *|
## |*                                                                            *|
## |* This file is distributed under the University of Illinois Open Source      *|
## |* License. See LICENSE.TXT for details.                                      *|
## |*                                                                            *|
## |*===----------------------------------------------------------------------===*|
## |*                                                                            *|
## |* This header provides public interface to an abstract link time optimization*|
## |* library.  LLVM provides an implementation of this interface for use with   *|
## |* llvm bitcode files.                                                        *|
## |*                                                                            *|
## \*===----------------------------------------------------------------------===

when not defined(__cplusplus):
  when not defined(msc_Ver):
    type
      LtoBoolT* = bool
  else:
    ##  MSVC in particular does not have anything like _Bool or bool in C, but we can
    ##    at least make sure the type is the same size.  The implementation side will
    ##    use C++ bool.
    type
      LtoBoolT* = cuchar
else:
  type
    LtoBoolT* = bool
## *
##  @defgroup LLVMCLTO LTO
##  @ingroup LLVMC
##
##  @{
##

const
  LTO_API_VERSION* = 21

## *
##  \since prior to LTO_API_VERSION=3
##

type
  LtoSymbolAttributes* {.size: sizeof(cint).} = enum
    LTO_SYMBOL_ALIGNMENT_MASK = 0x0000001F, ##  log2 of alignment
    LTO_SYMBOL_PERMISSIONS_RODATA = 0x00000080,
    LTO_SYMBOL_PERMISSIONS_CODE = 0x000000A0,
    LTO_SYMBOL_PERMISSIONS_DATA = 0x000000C0,
    LTO_SYMBOL_PERMISSIONS_MASK = 0x000000E0,
    LTO_SYMBOL_DEFINITION_REGULAR = 0x00000100,
    LTO_SYMBOL_DEFINITION_TENTATIVE = 0x00000200,
    LTO_SYMBOL_DEFINITION_WEAK = 0x00000300,
    LTO_SYMBOL_DEFINITION_UNDEFINED = 0x00000400,
    LTO_SYMBOL_DEFINITION_WEAKUNDEF = 0x00000500,
    LTO_SYMBOL_DEFINITION_MASK = 0x00000700,
    LTO_SYMBOL_SCOPE_INTERNAL = 0x00000800, LTO_SYMBOL_SCOPE_HIDDEN = 0x00001000,
    LTO_SYMBOL_SCOPE_DEFAULT = 0x00001800, LTO_SYMBOL_SCOPE_PROTECTED = 0x00002000,
    LTO_SYMBOL_SCOPE_DEFAULT_CAN_BE_HIDDEN = 0x00002800,
    LTO_SYMBOL_SCOPE_MASK = 0x00003800, LTO_SYMBOL_COMDAT = 0x00004000,
    LTO_SYMBOL_ALIAS = 0x00008000


## *
##  \since prior to LTO_API_VERSION=3
##

type
  LtoDebugModel* {.size: sizeof(cint).} = enum
    LTO_DEBUG_MODEL_NONE = 0, LTO_DEBUG_MODEL_DWARF = 1


## *
##  \since prior to LTO_API_VERSION=3
##

type
  LtoCodegenModel* {.size: sizeof(cint).} = enum
    LTO_CODEGEN_PIC_MODEL_STATIC = 0, LTO_CODEGEN_PIC_MODEL_DYNAMIC = 1,
    LTO_CODEGEN_PIC_MODEL_DYNAMIC_NO_PIC = 2, LTO_CODEGEN_PIC_MODEL_DEFAULT = 3


## * opaque reference to a loaded object module

type
  LtoModuleT* = ptr OpaqueLTOModule

## * opaque reference to a code generator

type
  LtoCodeGenT* = ptr OpaqueLTOCodeGenerator

## * opaque reference to a thin code generator

type
  ThinltoCodeGenT* = ptr OpaqueThinLTOCodeGenerator

## *
##  Returns a printable string.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoGetVersion*(): cstring {.llvmc, importc: "lto_get_version".}
## *
##  Returns the last error string or NULL if last operation was successful.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoGetErrorMessage*(): cstring {.llvmc, importc: "lto_get_error_message",
                                   dynlib: LLVMLib.}
## *
##  Checks if a file is a loadable object file.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleIsObjectFile*(path: cstring): LtoBoolT {.
    llvmc, importc: "lto_module_is_object_file".}
## *
##  Checks if a file is a loadable object compiled for requested target.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleIsObjectFileForTarget*(path: cstring; targetTriplePrefix: cstring): LtoBoolT {.
    llvmc, importc: "lto_module_is_object_file_for_target".}
## *
##  Return true if \p Buffer contains a bitcode file with ObjC code (category
##  or class) in it.
##
##  \since LTO_API_VERSION=20
##

proc ltoModuleHasObjcCategory*(mem: pointer; length: csize): LtoBoolT {.
    llvmc, importc: "lto_module_has_objc_category".}
## *
##  Checks if a buffer is a loadable object file.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleIsObjectFileInMemory*(mem: pointer; length: csize): LtoBoolT {.
    llvmc, importc: "lto_module_is_object_file_in_memory".}
## *
##  Checks if a buffer is a loadable object compiled for requested target.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleIsObjectFileInMemoryForTarget*(mem: pointer; length: csize;
    targetTriplePrefix: cstring): LtoBoolT {.
    llvmc, importc: "lto_module_is_object_file_in_memory_for_target".}
## *
##  Loads an object file from disk.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleCreate*(path: cstring): LtoModuleT {.llvmc, importc: "lto_module_create",
    dynlib: LLVMLib.}
## *
##  Loads an object file from memory.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleCreateFromMemory*(mem: pointer; length: csize): LtoModuleT {.
    llvmc, importc: "lto_module_create_from_memory".}
## *
##  Loads an object file from memory with an extra path argument.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=9
##

proc ltoModuleCreateFromMemoryWithPath*(mem: pointer; length: csize; path: cstring): LtoModuleT {.
    llvmc, importc: "lto_module_create_from_memory_with_path".}
## *
##  \brief Loads an object file in its own context.
##
##  Loads an object file in its own LLVMContext.  This function call is
##  thread-safe.  However, modules created this way should not be merged into an
##  lto_code_gen_t using \a lto_codegen_add_module().
##
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=11
##

proc ltoModuleCreateInLocalContext*(mem: pointer; length: csize; path: cstring): LtoModuleT {.
    llvmc, importc: "lto_module_create_in_local_context".}
## *
##  \brief Loads an object file in the codegen context.
##
##  Loads an object file into the same context as \c cg.  The module is safe to
##  add using \a lto_codegen_add_module().
##
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=11
##

proc ltoModuleCreateInCodegenContext*(mem: pointer; length: csize; path: cstring;
                                     cg: LtoCodeGenT): LtoModuleT {.
    llvmc, importc: "lto_module_create_in_codegen_context".}
## *
##  Loads an object file from disk. The seek point of fd is not preserved.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=5
##

proc ltoModuleCreateFromFd*(fd: cint; path: cstring; fileSize: csize): LtoModuleT {.
    llvmc, importc: "lto_module_create_from_fd".}
## *
##  Loads an object file from disk. The seek point of fd is not preserved.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=5
##

proc ltoModuleCreateFromFdAtOffset*(fd: cint; path: cstring; fileSize: csize;
                                   mapSize: csize; offset: OffT): LtoModuleT {.
    llvmc, importc: "lto_module_create_from_fd_at_offset".}
## *
##  Frees all memory internally allocated by the module.
##  Upon return the lto_module_t is no longer valid.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleDispose*(`mod`: LtoModuleT) {.llvmc, importc: "lto_module_dispose",
    dynlib: LLVMLib.}
## *
##  Returns triple string which the object module was compiled under.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleGetTargetTriple*(`mod`: LtoModuleT): cstring {.
    llvmc, importc: "lto_module_get_target_triple".}
## *
##  Sets triple string with which the object will be codegened.
##
##  \since LTO_API_VERSION=4
##

proc ltoModuleSetTargetTriple*(`mod`: LtoModuleT; triple: cstring) {.
    llvmc, importc: "lto_module_set_target_triple".}
## *
##  Returns the number of symbols in the object module.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleGetNumSymbols*(`mod`: LtoModuleT): cuint {.
    llvmc, importc: "lto_module_get_num_symbols".}
## *
##  Returns the name of the ith symbol in the object module.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleGetSymbolName*(`mod`: LtoModuleT; index: cuint): cstring {.
    llvmc, importc: "lto_module_get_symbol_name".}
## *
##  Returns the attributes of the ith symbol in the object module.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoModuleGetSymbolAttribute*(`mod`: LtoModuleT; index: cuint): LtoSymbolAttributes {.
    llvmc, importc: "lto_module_get_symbol_attribute".}
## *
##  Returns the module's linker options.
##
##  The linker options may consist of multiple flags. It is the linker's
##  responsibility to split the flags using a platform-specific mechanism.
##
##  \since LTO_API_VERSION=16
##

proc ltoModuleGetLinkeropts*(`mod`: LtoModuleT): cstring {.
    llvmc, importc: "lto_module_get_linkeropts".}


## If targeting mach-o on darwin, this function gets the CPU type and subtype that will end up being encoded in the mach-o header
proc ltoModuleGetMachoCputype*(`mod`: LtoModuleT, outCputype: ptr cuint, outCpusubtype: ptr cuint): LtoBoolT {.
    llvmc, importc: "lto_module_get_linkeropts".}
## *
##  Diagnostic severity.
##
##  \since LTO_API_VERSION=7
##

type
  LtoCodegenDiagnosticSeverityT* {.size: sizeof(cint).} = enum
    LTO_DS_ERROR = 0, LTO_DS_WARNING = 1, LTO_DS_NOTE = 2, LTO_DS_REMARK = 3 ##  Added in LTO_API_VERSION=10.


## *
##  Diagnostic handler type.
##  \p severity defines the severity.
##  \p diag is the actual diagnostic.
##  The diagnostic is not prefixed by any of severity keyword, e.g., 'error: '.
##  \p ctxt is used to pass the context set with the diagnostic handler.
##
##  \since LTO_API_VERSION=7
##

type
  LtoDiagnosticHandlerT* = proc (severity: LtoCodegenDiagnosticSeverityT;
                              diag: cstring; ctxt: pointer)

## *
##  Set a diagnostic handler and the related context (void *).
##  This is more general than lto_get_error_message, as the diagnostic handler
##  can be called at anytime within lto.
##
##  \since LTO_API_VERSION=7
##

proc ltoCodegenSetDiagnosticHandler*(a2: LtoCodeGenT; a3: LtoDiagnosticHandlerT;
                                    a4: pointer) {.
    llvmc, importc: "lto_codegen_set_diagnostic_handler".}
## *
##  Instantiates a code generator.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##  All modules added using \a lto_codegen_add_module() must have been created
##  in the same context as the codegen.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenCreate*(): LtoCodeGenT {.llvmc, importc: "lto_codegen_create",
                                     dynlib: LLVMLib.}
## *
##  \brief Instantiate a code generator in its own context.
##
##  Instantiates a code generator in its own context.  Modules added via \a
##  lto_codegen_add_module() must have all been created in the same context,
##  using \a lto_module_create_in_codegen_context().
##
##  \since LTO_API_VERSION=11
##

proc ltoCodegenCreateInLocalContext*(): LtoCodeGenT {.
    llvmc, importc: "lto_codegen_create_in_local_context".}
## *
##  Frees all code generator and all memory it internally allocated.
##  Upon return the lto_code_gen_t is no longer valid.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenDispose*(a2: LtoCodeGenT) {.llvmc, importc: "lto_codegen_dispose",
                                        dynlib: LLVMLib.}
## *
##  Add an object module to the set of modules for which code will be generated.
##  Returns true on error (check lto_get_error_message() for details).
##
##  \c cg and \c mod must both be in the same context.  See \a
##  lto_codegen_create_in_local_context() and \a
##  lto_module_create_in_codegen_context().
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenAddModule*(cg: LtoCodeGenT; `mod`: LtoModuleT): LtoBoolT {.
    llvmc, importc: "lto_codegen_add_module".}
## *
##  Sets the object module for code generation. This will transfer the ownership
##  of the module to the code generator.
##
##  \c cg and \c mod must both be in the same context.
##
##  \since LTO_API_VERSION=13
##

proc ltoCodegenSetModule*(cg: LtoCodeGenT; `mod`: LtoModuleT) {.
    llvmc, importc: "lto_codegen_set_module".}
## *
##  Sets if debug info should be generated.
##  Returns true on error (check lto_get_error_message() for details).
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenSetDebugModel*(cg: LtoCodeGenT; a3: LtoDebugModel): LtoBoolT {.
    llvmc, importc: "lto_codegen_set_debug_model".}
## *
##  Sets which PIC code model to generated.
##  Returns true on error (check lto_get_error_message() for details).
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenSetPicModel*(cg: LtoCodeGenT; a3: LtoCodegenModel): LtoBoolT {.
    llvmc, importc: "lto_codegen_set_pic_model".}
## *
##  Sets the cpu to generate code for.
##
##  \since LTO_API_VERSION=4
##

proc ltoCodegenSetCpu*(cg: LtoCodeGenT; cpu: cstring) {.
    llvmc, importc: "lto_codegen_set_cpu".}
## *
##  Sets the location of the assembler tool to run. If not set, libLTO
##  will use gcc to invoke the assembler.
##
##  \since LTO_API_VERSION=3
##

proc ltoCodegenSetAssemblerPath*(cg: LtoCodeGenT; path: cstring) {.
    llvmc, importc: "lto_codegen_set_assembler_path".}
## *
##  Sets extra arguments that libLTO should pass to the assembler.
##
##  \since LTO_API_VERSION=4
##

proc ltoCodegenSetAssemblerArgs*(cg: LtoCodeGenT; args: cstringArray; nargs: cint) {.
    llvmc, importc: "lto_codegen_set_assembler_args".}
## *
##  Adds to a list of all global symbols that must exist in the final generated
##  code. If a function is not listed there, it might be inlined into every usage
##  and optimized away.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenAddMustPreserveSymbol*(cg: LtoCodeGenT; symbol: cstring) {.
    llvmc, importc: "lto_codegen_add_must_preserve_symbol".}
## *
##  Writes a new object file at the specified path that contains the
##  merged contents of all modules added so far.
##  Returns true on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=5
##

proc ltoCodegenWriteMergedModules*(cg: LtoCodeGenT; path: cstring): LtoBoolT {.
    llvmc, importc: "lto_codegen_write_merged_modules".}
## *
##  Generates code for all added modules into one native object file.
##  This calls lto_codegen_optimize then lto_codegen_compile_optimized.
##
##  On success returns a pointer to a generated mach-o/ELF buffer and
##  length set to the buffer size.  The buffer is owned by the
##  lto_code_gen_t and will be freed when lto_codegen_dispose()
##  is called, or lto_codegen_compile() is called again.
##  On failure, returns NULL (check lto_get_error_message() for details).
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenCompile*(cg: LtoCodeGenT; length: ptr csize): pointer {.
    llvmc, importc: "lto_codegen_compile".}
## *
##  Generates code for all added modules into one native object file.
##  This calls lto_codegen_optimize then lto_codegen_compile_optimized (instead
##  of returning a generated mach-o/ELF buffer, it writes to a file).
##
##  The name of the file is written to name. Returns true on error.
##
##  \since LTO_API_VERSION=5
##

proc ltoCodegenCompileToFile*(cg: LtoCodeGenT; name: cstringArray): LtoBoolT {.
    llvmc, importc: "lto_codegen_compile_to_file".}
## *
##  Runs optimization for the merged module. Returns true on error.
##
##  \since LTO_API_VERSION=12
##

proc ltoCodegenOptimize*(cg: LtoCodeGenT): LtoBoolT {.
    llvmc, importc: "lto_codegen_optimize".}
## *
##  Generates code for the optimized merged module into one native object file.
##  It will not run any IR optimizations on the merged module.
##
##  On success returns a pointer to a generated mach-o/ELF buffer and length set
##  to the buffer size.  The buffer is owned by the lto_code_gen_t and will be
##  freed when lto_codegen_dispose() is called, or
##  lto_codegen_compile_optimized() is called again. On failure, returns NULL
##  (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=12
##

proc ltoCodegenCompileOptimized*(cg: LtoCodeGenT; length: ptr csize): pointer {.
    llvmc, importc: "lto_codegen_compile_optimized".}
## *
##  Returns the runtime API version.
##
##  \since LTO_API_VERSION=12
##

proc ltoApiVersion*(): cuint {.llvmc, importc: "lto_api_version".}
## *
##  Sets options to help debug codegen bugs.
##
##  \since prior to LTO_API_VERSION=3
##

proc ltoCodegenDebugOptions*(cg: LtoCodeGenT; a3: cstring) {.
    llvmc, importc: "lto_codegen_debug_options".}
## *
##  Initializes LLVM disassemblers.
##  FIXME: This doesn't really belong here.
##
##  \since LTO_API_VERSION=5
##

proc ltoInitializeDisassembler*() {.llvmc, importc: "lto_initialize_disassembler",
                                  dynlib: LLVMLib.}
## *
##  Sets if we should run internalize pass during optimization and code
##  generation.
##
##  \since LTO_API_VERSION=14
##

proc ltoCodegenSetShouldInternalize*(cg: LtoCodeGenT; shouldInternalize: LtoBoolT) {.
    llvmc, importc: "lto_codegen_set_should_internalize".}
## *
##  \brief Set whether to embed uselists in bitcode.
##
##  Sets whether \a lto_codegen_write_merged_modules() should embed uselists in
##  output bitcode.  This should be turned on for all -save-temps output.
##
##  \since LTO_API_VERSION=15
##

proc ltoCodegenSetShouldEmbedUselists*(cg: LtoCodeGenT;
                                      shouldEmbedUselists: LtoBoolT) {.
    llvmc, importc: "lto_codegen_set_should_embed_uselists".}

## Creates an LTO input file from a buffer
proc ltoInputCreate*(buffer: cstring, bufferSize: csize_t, path: cstring): LtoInputT {.
    llvmc, importc: "lto_input_create".}

## Frees all memory internally allocated by the LTO input file
proc ltoInputDispose*(input: LtoInputT) {.llvmc, importc: "lto_input_dispose".}

## Returns the number of dependent library specifiers for the given LTO input file
proc ltoInputGetNumDependentLibraries*(input: LtoInputT): cuint {.llvmc, importc: "lto_input_get_num_dependent_libraries".}

## Returns the ith dependent library specifier for the given LTO input file
proc ltoInputGetDependentLibrary*(input: LtoInputT, index: csize_t, size: ptr csize_t): cstring {.llvmc, importc: "lto_input_get_dependent_library".}

## Returns the list of libcall symbols that can be generated by LTO that might not be visible from the symbol table of bitcode files
proc ltoRuntimeLibSymbolsList*(size: ptr csize_t): cstringArray {.llvmc, importc: "lto_runtime_lib_symbols_list".}


## *
##  @} // endgoup LLVMCLTO
##  @defgroup LLVMCTLTO ThinLTO
##  @ingroup LLVMC
##
##  @{
##
## *
##  Type to wrap a single object returned by ThinLTO.
##
##  \since LTO_API_VERSION=18
##

type
  LTOObjectBuffer* {.bycopy.} = object
    buffer*: cstring
    size*: csize


## *
##  Instantiates a ThinLTO code generator.
##  Returns NULL on error (check lto_get_error_message() for details).
##
##
##  The ThinLTOCodeGenerator is not intended to be reuse for multiple
##  compilation: the model is that the client adds modules to the generator and
##  ask to perform the ThinLTO optimizations / codegen, and finally destroys the
##  codegenerator.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCreateCodegen*(): ThinltoCodeGenT {.llvmc, importc: "thinlto_create_codegen",
    dynlib: LLVMLib.}
## *
##  Frees the generator and all memory it internally allocated.
##  Upon return the thinlto_code_gen_t is no longer valid.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenDispose*(cg: ThinltoCodeGenT) {.
    llvmc, importc: "thinlto_codegen_dispose".}
## *
##  Add a module to a ThinLTO code generator. Identifier has to be unique among
##  all the modules in a code generator. The data buffer stays owned by the
##  client, and is expected to be available for the entire lifetime of the
##  thinlto_code_gen_t it is added to.
##
##  On failure, returns NULL (check lto_get_error_message() for details).
##
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenAddModule*(cg: ThinltoCodeGenT; identifier: cstring;
                             data: cstring; length: cint) {.
    llvmc, importc: "thinlto_codegen_add_module".}
## *
##  Optimize and codegen all the modules added to the codegenerator using
##  ThinLTO. Resulting objects are accessible using thinlto_module_get_object().
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenProcess*(cg: ThinltoCodeGenT) {.
    llvmc, importc: "thinlto_codegen_process".}
## *
##  Returns the number of object files produced by the ThinLTO CodeGenerator.
##
##  It usually matches the number of input files, but this is not a guarantee of
##  the API and may change in future implementation, so the client should not
##  assume it.
##
##  \since LTO_API_VERSION=18
##

proc thinltoModuleGetNumObjects*(cg: ThinltoCodeGenT): cuint {.
    llvmc, importc: "thinlto_module_get_num_objects".}
## *
##  Returns a reference to the ith object file produced by the ThinLTO
##  CodeGenerator.
##
##  Client should use \p thinlto_module_get_num_objects() to get the number of
##  available objects.
##
##  \since LTO_API_VERSION=18
##

proc thinltoModuleGetObject*(cg: ThinltoCodeGenT; index: cuint): LTOObjectBuffer {.
    llvmc, importc: "thinlto_module_get_object".}
## *
##  Returns the number of object files produced by the ThinLTO CodeGenerator.
##
##  It usually matches the number of input files, but this is not a guarantee of
##  the API and may change in future implementation, so the client should not
##  assume it.
##
##  \since LTO_API_VERSION=21
##

proc thinltoModuleGetNumObjectFiles*(cg: ThinltoCodeGenT): cuint {.
    llvmc, importc: "thinlto_module_get_num_object_files".}
## *
##  Returns the path to the ith object file produced by the ThinLTO
##  CodeGenerator.
##
##  Client should use \p thinlto_module_get_num_object_files() to get the number
##  of available objects.
##
##  \since LTO_API_VERSION=21
##

proc thinltoModuleGetObjectFile*(cg: ThinltoCodeGenT; index: cuint): cstring {.
    llvmc, importc: "thinlto_module_get_object_file".}
## *
##  Sets which PIC code model to generate.
##  Returns true on error (check lto_get_error_message() for details).
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetPicModel*(cg: ThinltoCodeGenT; a3: LtoCodegenModel): LtoBoolT {.
    llvmc, importc: "thinlto_codegen_set_pic_model".}
## *
##  Sets the path to a directory to use as a storage for temporary bitcode files.
##  The intention is to make the bitcode files available for debugging at various
##  stage of the pipeline.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetSavetempsDir*(cg: ThinltoCodeGenT; saveTempsDir: cstring) {.
    llvmc, importc: "thinlto_codegen_set_savetemps_dir".}
## *
##  Set the path to a directory where to save generated object files. This
##  path can be used by a linker to request on-disk files instead of in-memory
##  buffers. When set, results are available through
##  thinlto_module_get_object_file() instead of thinlto_module_get_object().
##
##  \since LTO_API_VERSION=21
##

proc thinltoSetGeneratedObjectsDir*(cg: ThinltoCodeGenT; saveTempsDir: cstring) {.
    llvmc, importc: "thinlto_set_generated_objects_dir".}
## *
##  Sets the cpu to generate code for.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetCpu*(cg: ThinltoCodeGenT; cpu: cstring) {.
    llvmc, importc: "thinlto_codegen_set_cpu".}
## *
##  Disable CodeGen, only run the stages till codegen and stop. The output will
##  be bitcode.
##
##  \since LTO_API_VERSION=19
##

proc thinltoCodegenDisableCodegen*(cg: ThinltoCodeGenT; disable: LtoBoolT) {.
    llvmc, importc: "thinlto_codegen_disable_codegen".}
## *
##  Perform CodeGen only: disable all other stages.
##
##  \since LTO_API_VERSION=19
##

proc thinltoCodegenSetCodegenOnly*(cg: ThinltoCodeGenT; codegenOnly: LtoBoolT) {.
    llvmc, importc: "thinlto_codegen_set_codegen_only".}
## *
##  Parse -mllvm style debug options.
##
##  \since LTO_API_VERSION=18
##

proc thinltoDebugOptions*(options: cstringArray; number: cint) {.
    llvmc, importc: "thinlto_debug_options".}
## *
##  Test if a module has support for ThinLTO linking.
##
##  \since LTO_API_VERSION=18
##

proc ltoModuleIsThinlto*(`mod`: LtoModuleT): LtoBoolT {.
    llvmc, importc: "lto_module_is_thinlto".}
## *
##  Adds a symbol to the list of global symbols that must exist in the final
##  generated code. If a function is not listed there, it might be inlined into
##  every usage and optimized away. For every single module, the functions
##  referenced from code outside of the ThinLTO modules need to be added here.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenAddMustPreserveSymbol*(cg: ThinltoCodeGenT; name: cstring;
    length: cint) {.llvmc, importc: "thinlto_codegen_add_must_preserve_symbol",
                  dynlib: LLVMLib.}
## *
##  Adds a symbol to the list of global symbols that are cross-referenced between
##  ThinLTO files. If the ThinLTO CodeGenerator can ensure that every
##  references from a ThinLTO module to this symbol is optimized away, then
##  the symbol can be discarded.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenAddCrossReferencedSymbol*(cg: ThinltoCodeGenT; name: cstring;
    length: cint) {.llvmc, importc: "thinlto_codegen_add_cross_referenced_symbol",
                  dynlib: LLVMLib.}
## *
##  @} // endgoup LLVMCTLTO
##  @defgroup LLVMCTLTO_CACHING ThinLTO Cache Control
##  @ingroup LLVMCTLTO
##
##  These entry points control the ThinLTO cache. The cache is intended to
##  support incremental build, and thus needs to be persistent accross build.
##  The client enabled the cache by supplying a path to an existing directory.
##  The code generator will use this to store objects files that may be reused
##  during a subsequent build.
##  To avoid filling the disk space, a few knobs are provided:
##   - The pruning interval limit the frequency at which the garbage collector
##     will try to scan the cache directory to prune it from expired entries.
##     Setting to -1 disable the pruning (default).
##   - The pruning expiration time indicates to the garbage collector how old an
##     entry needs to be to be removed.
##   - Finally, the garbage collector can be instructed to prune the cache till
##     the occupied space goes below a threshold.
##  @{
##
## *
##  Sets the path to a directory to use as a cache storage for incremental build.
##  Setting this activates caching.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetCacheDir*(cg: ThinltoCodeGenT; cacheDir: cstring) {.
    llvmc, importc: "thinlto_codegen_set_cache_dir".}
## *
##  Sets the cache pruning interval (in seconds). A negative value disable the
##  pruning. An unspecified default value will be applied, and a value of 0 will
##  be ignored.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetCachePruningInterval*(cg: ThinltoCodeGenT; interval: cint) {.
    llvmc, importc: "thinlto_codegen_set_cache_pruning_interval".}
## *
##  Sets the maximum cache size that can be persistent across build, in terms of
##  percentage of the available space on the the disk. Set to 100 to indicate
##  no limit, 50 to indicate that the cache size will not be left over half the
##  available space. A value over 100 will be reduced to 100, a value of 0 will
##  be ignored. An unspecified default value will be applied.
##
##  The formula looks like:
##   AvailableSpace = FreeSpace + ExistingCacheSize
##   NewCacheSize = AvailableSpace * P/100
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetFinalCacheSizeRelativeToAvailableSpace*(
    cg: ThinltoCodeGenT; percentage: cuint) {.llvmc, importc: "thinlto_codegen_set_final_cache_size_relative_to_available_space",
    dynlib: LLVMLib.}
## *
##  Sets the expiration (in seconds) for an entry in the cache. An unspecified
##  default value will be applied. A value of 0 will be ignored.
##
##  \since LTO_API_VERSION=18
##

proc thinltoCodegenSetCacheEntryExpiration*(cg: ThinltoCodeGenT; expiration: cuint) {.
    llvmc, importc: "thinlto_codegen_set_cache_entry_expiration".}
## *
##  @} // endgroup LLVMCTLTO_CACHING
##
