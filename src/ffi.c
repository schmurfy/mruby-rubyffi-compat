#include "mruby.h"
#include "mruby/value.h"

static mrb_value longsize(mrb_state *mrb, mrb_value self)
{
  uint8_t size = (uint8_t)sizeof(long);
  return mrb_fixnum_value(size);
}




/* ruby calls this to load the extension */
void mrb_mruby_rubyffi_compat_gem_init(mrb_state *mrb)
{
  struct RClass *mod = mrb_define_module(mrb, "FFI");
  mrb_define_class_method(mrb, mod, "longsize", longsize, ARGS_NONE());
}

void mrb_mruby_rubyffi_compat_gem_final(mrb_state *mrb)
{
  
}
