-- nvim-bufdel
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local cmd, fn, vim = vim.cmd, vim.fn, vim

-------------------- FUNCTIONS -----------------------------
local function switch_buffer(cur_buf, next_buf)
  local cur_win = fn.winnr()
  for _, winid in ipairs(fn.getbufinfo(cur_buf)[1].windows) do
    cmd(string.format('%d wincmd w', fn.win_id2win(winid)))
    cmd(string.format('buffer %d', next_buf))
  end
  cmd(string.format('%d wincmd w', cur_win))
end

local function delete_buffer(force)
  local buflisted = fn.getbufinfo({buflisted = 1})
  local cur_bufnr, next_buf = fn.bufnr()
  if #buflisted < 2 then
    cmd 'confirm qall'
    return
  end
  for i = 0, fn.bufnr('$') - 1 do
    local buf = (cur_buf + i) % fn.bufnr('$') + 1
    if fn.buflisted(buf) == 1 then
      next_buf = buf
      break
    end
  end
  switch_buffer(cur_buf, next_buf)
  if fn.getbufvar(cur_bufnr, '&buftype') == 'terminal' then
    cmd('bd! #')
  else
    cmd('silent! confirm bd #')
  end
  if fn.buflisted(buf) == 1 then
    switch_buffer(next_buf, cur_buf)
  end
end

------------------------------------------------------------
return {
  delete_buffer = delete_buffer,
}
