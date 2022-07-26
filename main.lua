local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local coroutine = _tl_compat and _tl_compat.coroutine or coroutine; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local inspect = require("inspect")
local getTime = love.timer.getTime
local resume = coroutine.resume
local gr = love.graphics
local font = gr.newFont("dejavusansmono.ttf", 70)

love.window.setMode(1920, 1080)

local Matrix = {}






local function matrix_draw(
   m,
   x, y,
   active)


   x = x or 0
   y = y or 0
   local x0, y0 = x, y
   local bracket_width = 7
   local bracket_height = #m * font:getHeight()
   local mat_width = 0.




   gr.line(x0, y0, x0 + bracket_width, y0)

   gr.line(x0, y0 + bracket_height, x0 + bracket_width, y0 + bracket_height)

   gr.line(x0, y0, x0, y0 + bracket_height)

   local ColoredText = {}



   local colored_text = {}

   local function draw_colored_line(X, Y)
      for _, v in ipairs(colored_text) do
         gr.setColor(v.color)
         gr.print(v.s, X, Y)
         X = X + font:getWidth(v.s)
      end
   end

   for col, j in ipairs(m) do
      local line = ""
      colored_text = {}
      for row, i in ipairs(j) do
         local color
         if active and active[2] == col and active[1] == row then
            color = { 0, 1, 0, 1 }

         else
            color = { 1, 1, 1, 1 }
         end
         table.insert(colored_text, {
            s = tostring(i),
            color = color,
         })
         if row ~= #j then
            line = line .. tostring(i) .. ","
            table.insert(colored_text, {
               s = ",",
               color = { 1, 0, 0, 1 },
            })
         else
            line = line .. tostring(i)
         end
      end
      if #line > mat_width then
         mat_width = #line
      end

      draw_colored_line(x, y)
      y = y + font:getHeight()
   end

















   mat_width = font:getWidth(string.rep("a", mat_width))
   x0 = x0 + mat_width




   gr.line(x0, y0, x0 - bracket_width, y0)

   gr.line(x0, y0 + bracket_height, x0 - bracket_width, y0 + bracket_height)

   gr.line(x0, y0, x0, y0 + bracket_height)

   return mat_width + 10
end

local m1 = {
   { 0, 0, 0 },
   { 0, 1, 0 },
   { 1, 1, 1 },
}

local m2 = {
   { 0, 0, 0, 20 },
   { 0, 1, 0, 40 },
   { 1, 1, 1, -3.14 },
}

local m3 = {
   { 1, 2 },
}

local m4 = {
   { 1, 2 },
   { 3, 4 },
}

local m5 = {
   { 1, 2 },
   { 3, 4 },
   { 5, 6 },
}

local m5 = {
   { 1, 2, 0, -1, 0, -1, -2, -3, 4 },
   { 3, 4, 0, -1, 0, -1, -2, 0, 4 },
   { 5, 6, 0, -1, 0, -1, -2, 0, 4 },
   { 3, 4, 0, -1, 0, -1, -2, -3, 4 },
   { 3, 4, 0, -1, 0, -1, -2, -3, 4 },
   { 3, 4, 0, -1, 0, -1, -2, -3, 4 },
}

local function matrix_transpose(m)
   local res = {}
   local columns = #m[1]
   local rows = #m

   for _ = 1, columns do
      table.insert(res, {})
      for j = 1, rows do
         res[#res][j] = 1 / 0
      end
   end

   coroutine.yield(res)
   print('step')

   for i = 1, #res do
      for j = 1, #res[1] do
         res[i][j] = m[j][i]
         coroutine.yield(res, { i, j })
         print('innner step')
      end
   end

   return res
end

local matrix_transpose_coro = coroutine.create(matrix_transpose)
local last_time = getTime()
local wait_time = 0.
local wait_time_real = 1.5
local mat
local indices

love.draw = function()
   gr.setFont(font)
   local x0, y0 = 10., 10.
   local m = m5
   local width = matrix_draw(m, x0, y0, indices)

   x0 = x0 + width



   local now = getTime()
   local ok
   local new_mat
   if now - last_time > wait_time then
      last_time = now
      wait_time = wait_time_real
      ok, new_mat, indices = resume(matrix_transpose_coro, m)


      if ok then
         mat = new_mat
      end

   end
   if mat then
      local reverse_indices
      if indices then
         reverse_indices = { indices[2], indices[1] }
      end
      matrix_draw(mat, x0, y0, reverse_indices)
   end

end

love.update = function(_)
   if love.keyboard.isDown("escape") then
      love.event.quit();
   end
end
