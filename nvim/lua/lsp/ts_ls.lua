-- [nfnl] Compiled from fnl/lsp/ts_ls.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("lspconfig")
local ts_ls = _local_2_["ts_ls"]
local function setup(opts)
  if (1 == vim.fn.executable("typescript-language-server")) then
    return ts_ls.setup(opts)
  else
    return nil
  end
end
return {setup = setup}
