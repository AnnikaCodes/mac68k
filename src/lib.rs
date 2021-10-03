#![feature(
    no_core, lang_items, intrinsics, unboxed_closures, type_ascription, extern_types,
    untagged_unions, decl_macro, rustc_attrs, transparent_unions, auto_traits,
    thread_local,
)]
#![no_std]
#![no_core]
#![no_main]

mod core;

extern {
    fn __asmSysError();
}

#[no_mangle] // don't mangle the name of this function
pub extern "C" fn rust_entry() {
    unsafe {
        __asmSysError();
    }
    loop {}
}
