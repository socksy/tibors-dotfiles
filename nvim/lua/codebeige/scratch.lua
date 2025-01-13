-- [nfnl] Compiled from fnl/codebeige/scratch.fnl by https://github.com/Olical/nfnl, do not edit.
local function find_buffer(name)
  local buffer = nil
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if buffer then break end
    local _1_, _2_ = pcall(vim.api.nvim_buf_get_var, b, "scratch_buffer_name")
    if ((_1_ == true) and (_2_ == name)) then
      buffer = b
    else
    end
  end
  return buffer
end
local function create_buffer(name, filetype)
  local tmp_9_auto = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(tmp_9_auto, ("[" .. name .. "]"))
  vim.api.nvim_buf_set_var(tmp_9_auto, "scratch_buffer_name", name)
  vim.api.nvim_buf_set_option(tmp_9_auto, "filetype", filetype)
  return tmp_9_auto
end
local function delete_buffer(buffer)
  return vim.api.nvim_buf_delete(buffer, {force = true})
end
local function new_window(buffer, _4_)
  local count = _4_["count"]
  local mods = _4_["mods"]
  vim.cmd.split({mods = mods})
  if (0 < count) then
    if mods.vertical then
      vim.api.nvim_win_set_width(0, count)
    else
      vim.api.nvim_win_set_height(0, count)
    end
  else
  end
  vim.api.nvim_win_set_buf(0, buffer)
  local _7_, _8_ = pcall(vim.api.nvim_buf_get_var, buffer, "scratch_buffer_view")
  if ((_7_ == true) and (nil ~= _8_)) then
    local view = _8_
    return vim.fn.winrestview(view)
  else
    return nil
  end
end
local function save_layout(buffer, window)
  return vim.api.nvim_buf_set_var(buffer, "scratch_buffer_view", vim.api.nvim_win_call(window, vim.fn.winsaveview))
end
local function close_windows(windows)
  for _, w in ipairs(windows) do
    vim.api.nvim_win_close(w, true)
  end
  return nil
end
local function toggle_window(name, _10_)
  local count = _10_["count"]
  local filetype = _10_["filetype"]
  local mods = _10_["mods"]
  local purge_3f = _10_["purge?"]
  local buffer = find_buffer(name)
  local _let_11_ = vim.fn.win_findbuf(buffer)
  local window = _let_11_[1]
  local windows = _let_11_
  if (buffer and purge_3f) then
    delete_buffer(buffer)
  else
  end
  if not window then
    local buffer0
    local _13_
    if not purge_3f then
      _13_ = buffer
    else
      _13_ = nil
    end
    buffer0 = (_13_ or create_buffer(name, filetype))
    return new_window(buffer0, {count = count, mods = mods})
  else
    if not purge_3f then
      save_layout(buffer, window)
      return close_windows(windows)
    else
      return nil
    end
  end
end
local function init()
  local function _19_(_17_)
    local bang = _17_["bang"]
    local count = _17_["count"]
    local _arg_18_ = _17_["fargs"]
    local name = _arg_18_[1]
    local filetype = _arg_18_[2]
    local more = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_arg_18_, 3)
    local mods = _17_["smods"]
    assert(vim.tbl_isempty(more), "Too many arguments for command: Scratch")
    local name0 = (name or "scratch")
    return toggle_window(name0, {count = count, filetype = (filetype or vim.filetype.match({filename = name0}) or vim.api.nvim_buf_get_option(0, "filetype") or "text"), mods = mods, ["purge?"] = bang})
  end
  return vim.api.nvim_create_user_command("Scratch", _19_, {bang = true, count = 0, nargs = "*"})
end
return {init = init}
