-- nvim-bufdel
-- By Olivier Roques
-- github.com/ojroques

-------------------- OPTIONS -------------------------------
local options = {
  next = 'tabs',  -- how to retrieve the next buffer
  quit = true,    -- exit when last buffer is deleted
}

-------------------- PRIVATE -------------------------------
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
  local alternate = vim.fn.bufnr('#')
  if options.next == 'alternate' and vim.fn.buflisted(alternate) == 1 then
    return alternate
  end
  local buffers, buf_index = {}, 1
  for i, bufinfo in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
    if buf == bufinfo.bufnr then
      buf_index = i
    end
    table.insert(buffers, bufinfo.bufnr)
  end
  if options.next == 'tabs' and buf_index == #buffers and #buffers > 1 then
    return buffers[#buffers - 1]
  end
  return buffers[buf_index % #buffers + 1]
end

-- Delete a buffer, ignoring changes if 'force' is set
local function delete_buffer(buf, force)
  if vim.fn.buflisted(buf) == 0 then  -- exit if buffer number is invalid
    return
  end
  -- retrieve buffer and delete it while preserving window layout
  local next_buf = get_next_buf(buf)
  local windows = vim.fn.getbufinfo(buf)[1].windows
  switch_buffer(windows, next_buf)
  -- force deletion of terminal buffers
  if force or vim.fn.getbufvar(buf, '&buftype') == 'terminal' then
    vim.cmd(string.format('bd! %d', buf))
  else
    vim.cmd(string.format('silent! confirm bd %d', buf))
  end
  -- revert buffer switches if deletion was cancelled
  if vim.fn.buflisted(buf) == 1 then
    switch_buffer(windows, buf)
  end
end

-------------------- PUBLIC --------------------------------
-- Delete given buffer, ignoring changes if 'force' is set
local function delete_buffer_expr(bufexpr, force)
  if #vim.fn.getbufinfo({buflisted = 1}) < 2 then
    if options.quit then
      -- exit when there is only one buffer left
      if force then
        vim.cmd('qall!')
      else
        vim.cmd('confirm qall')
      end
      return
    end
    -- don't exit and create a new empty buffer
    vim.cmd('enew')
    vim.cmd('bp')
  end
  if not bufexpr then  -- return current buffer when 'bufexpr' is nil
    delete_buffer(vim.fn.bufnr(), force)
  end
  if tonumber(bufexpr) then
    delete_buffer(tonumber(bufexpr), force)
  end
  bufexpr = string.gsub(bufexpr, [[^['"]+]], '')  -- escape any start quote
  bufexpr = string.gsub(bufexpr, [[['"]+$]], '')  -- escape any end quote
  delete_buffer(vim.fn.bufnr(bufexpr), force)
end

-- Delete all buffers except current, ignoring changes if 'force' is set
local function delete_buffer_others(force)
  for _, bufinfo in ipairs(vim.fn.getbufinfo({buflisted = 1})) do
    if bufinfo.bufnr ~= vim.fn.bufnr() then
      delete_buffer(bufinfo.bufnr, force)
    end
  end
end

local function setup(user_options)
  if user_options then
    options = vim.tbl_extend('force', options, user_options)
  end
end

return {
  delete_buffer_expr = delete_buffer_expr,
  delete_buffer_others = delete_buffer_others,
  setup = setup,
}
