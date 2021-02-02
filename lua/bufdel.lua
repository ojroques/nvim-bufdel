-- nvim-bufdel
-- By Olivier Roques
-- github.com/ojroques

-- Options
local opts = {next = 'cycle'}  -- how to retrieve the next buffer

-- Switch to buffer 'buf' on each window from list 'windows'
local function switch_buffer(windows, buf)
  local cur_win = vim.fn.winnr()
  for _, winid in ipairs(windows) do
    vim.cmd(string.format('%d wincmd w', vim.fn.win_id2win(winid)))
    vim.cmd(string.format('buffer %d', buf))
  end
  vim.cmd(string.format('%d wincmd w', cur_win))  -- return to original window
end

-- Select the first buffer with a number greater than given buffer
local function get_next_buf(buf)
  local next = vim.fn.bufnr('#')
  if opts.next == 'alternate' and vim.fn.buflisted(next) == 1 then
    return next
  end
  for i = 0, vim.fn.bufnr('$') - 1 do
    next = (buf + i) % vim.fn.bufnr('$') + 1  -- will loop back to 1
    if vim.fn.buflisted(next) == 1 then
      return next
    end
  end
end

-- Retrieve the buffer associated to the given name or number
local function get_buf(bufexpr)
  if not bufexpr then  -- return current buffer when 'bufexpr' is nil
    return vim.fn.bufnr()
  end
  if tonumber(bufexpr) then
    return tonumber(bufexpr)
  end
  bufexpr = string.gsub(bufexpr, [[^['"]+]], '')  -- escape any start quote
  bufexpr = string.gsub(bufexpr, [[['"]+$]], '')  -- escape any end quote
  return vim.fn.bufnr(bufexpr)
end

-- Delete given buffer, ignoring changes if 'force' is set
local function delete_buffer(bufexpr, force)
  -- exit neovim when there is only one buffer left
  if #vim.fn.getbufinfo({buflisted = 1}) < 2 then
    if force then
      vim.cmd('qall!')
    else
      vim.cmd('confirm qall')
    end
    return
  end
  local buf = get_buf(bufexpr)
  if vim.fn.buflisted(buf) == 0 then  -- exit if buffer number is invalid
    return
  end
  local next_buf = get_next_buf(buf)
  local windows = vim.fn.getbufinfo(buf)[1].windows
  switch_buffer(windows, next_buf)
  -- force deletion of terminal buffers to avoid the prompt
  if force or vim.fn.getbufvar(buf, '&buftype') == 'terminal' then
    vim.cmd(string.format('bd! %d', buf))
  else
    vim.cmd(string.format('silent! confirm bd %d', buf))
  end
  -- revert buffer switches if user has canceled deletion
  if vim.fn.buflisted(buf) == 1 then
    switch_buffer(windows, buf)
  end
end

local function setup(user_opts)
  opts = vim.tbl_extend('keep', user_opts, opts)
end

return {
  delete_buffer = delete_buffer,
  setup = setup,
}
