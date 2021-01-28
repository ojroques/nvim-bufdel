-- nvim-bufdel
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local cmd, fn, vim = vim.cmd, vim.fn, vim

-------------------- FUNCTIONS -----------------------------
local function switch_buffer(windows, buf)
  local cur_win = fn.winnr()
  for _, winid in ipairs(windows) do
    cmd(string.format('%d wincmd w', fn.win_id2win(winid)))
    cmd(string.format('buffer %d', buf))
  end
  cmd(string.format('%d wincmd w', cur_win))
end

local function get_next(buf)
  for i = 0, fn.bufnr('$') - 1 do
    local next = (buf + i) % fn.bufnr('$') + 1
    if fn.buflisted(next) == 1 then
      return next
    end
  end
end

local function delete_buffer(bufexpr, force)
  if #fn.getbufinfo({buflisted = 1}) < 2 then
    if force then
      cmd('qall!')
    else
      cmd('confirm qall')
    end
    return
  end
  local cur_buf = type(bufexpr) == 'number' and bufexpr or fn.bufnr(bufexpr)
  local next_buf = get_next(cur_buf)
  local windows = fn.getbufinfo(cur_buf)[1].windows
  switch_buffer(windows, next_buf)
  if force or fn.getbufvar(cur_buf, '&buftype') == 'terminal' then
    cmd(string.format('bd! %d', cur_buf))
  else
    cmd(string.format('silent! confirm bd %d', cur_buf))
  end
  if fn.buflisted(cur_buf) == 1 then
    switch_buffer(windows, cur_buf)
  end
end

------------------------------------------------------------
return {
  delete_buffer = delete_buffer,
}
