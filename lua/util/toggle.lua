local M = {}

-- Transform bool to string
local function bool2str(bool)
  return bool and 'on' or 'off'
end

-- Toggle conceal
function M.toggle_conceal()
  local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
end

-- Toggle Treesitter Highlight
function M.toggle_ts_hightlight()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end

--- Toggle background="dark"|"light"
function M.toggle_background()
  vim.o.background = vim.o.background == 'light' and 'dark' or 'light'
  -- vim.notify(string.format('background=%s', vim.o.background))
end

--- Toggle showtabline=2|0
function M.toggle_tabline()
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0
  vim.notify(string.format('tabline %s', bool2str(vim.opt.showtabline:get() == 2)))
end

--- Toggle laststatus=3|2|0
function M.toggle_statusline()
  local laststatus = vim.opt.laststatus:get()
  local status
  if laststatus == 0 then
    vim.opt.laststatus = 2
    status = 'local'
  elseif laststatus == 2 then
    vim.opt.laststatus = 3
    status = 'global'
  elseif laststatus == 3 then
    vim.opt.laststatus = 0
    status = 'off'
  end
  vim.notify(string.format('statusline %s', status))
end

--- Toggle signcolumn="auto"|"no"
function M.toggle_signcolumn()
  if vim.wo.signcolumn == 'no' then
    vim.wo.signcolumn = 'yes'
  elseif vim.wo.signcolumn == 'yes' then
    vim.wo.signcolumn = 'auto'
  else
    vim.wo.signcolumn = 'no'
  end
  vim.notify(string.format('signcolumn=%s', vim.wo.signcolumn))
end

local last_active_foldcolumn
--- Toggle foldcolumn=0|1
function M.toggle_foldcolumn()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= '0' then
    last_active_foldcolumn = curr_foldcolumn
  end
  vim.wo.foldcolumn = curr_foldcolumn == '0' and (last_active_foldcolumn or '1') or '0'
  vim.notify(string.format('foldcolumn=%s', vim.wo.foldcolumn))
end

--- Change the number display modes
function M.toggle_line_number()
  local number = vim.wo.number -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  vim.notify(string.format('number %s, relativenumber %s', bool2str(vim.wo.number), bool2str(vim.wo.relativenumber)))
end

local diagnostics_enabled = true
-- Toggle diagnostics enabled
function M.toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  if diagnostics_enabled then
    vim.diagnostic.enable()
    vim.notify 'Enabled diagnostics'
  else
    vim.diagnostic.disable()
    vim.notify 'Disabled diagnostics'
  end
end

---@param buf? number
---@param value? boolean
-- Toggle inlay_hint enabled
function M.toggle_inlay_hints(buf, value)
  local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
  if type(ih) == 'function' then
    ih(buf, value)
  elseif type(ih) == 'table' and ih.enable then
    if value == nil then
      value = not ih.is_enabled(buf)
    end
    ih.enable(buf, value)
  end
end

return M
