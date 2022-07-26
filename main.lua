local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local math = _tl_compat and _tl_compat.math or math; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local ceil = math.ceil
local gr = love.graphics
local font = gr.newFont(70)

love.window.setMode(1920, 1080)

local Matrix = {}





local function matrix_draw(m, x, y)
   x = x or 0
   y = y or 0
   local x0, y0 = x, y
   local bracket_width = 7
   local bracket_height = #m * font:getHeight()
   local mat_width = 0.




   gr.line(x0, y0, x0 + bracket_width, y0)

   gr.line(x0, y0 + bracket_height, x0 + bracket_width, y0 + bracket_height)

   gr.line(x0, y0, x0, y0 + bracket_height)

   for _, j in ipairs(m) do
      local line = ""
      for k, i in ipairs(j) do
         if k ~= #j then
            line = line .. tostring(i) .. ","
         else
            line = line .. tostring(i)
         end
      end
      if #line > mat_width then
         mat_width = #line
      end
      gr.print(line, x, y)
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

local function matrix_transpose(m)
   local res = {}
   local columns = #m[1]
   local rows = #m










   for i = 1, columns do
      table.insert(res, {})
      for j = 1, rows do
         res[#res][j] = 0
      end
   end

   for i = 1, #res do
      for j = 1, #res[1] do





         res[i][j] = m[j][i]
      end
   end


   return res
end

love.draw = function()
   gr.setFont(font)
   local x0, y0 = 10., 10.
   local m = m5
   local width = matrix_draw(m, x0, y0)
   local m_T = matrix_transpose(m)
   x0 = x0 + width
   matrix_draw(m_T, x0, y0)
end

love.update = function(_)
   if love.keyboard.isDown("escape") then
      love.event.quit();
   end
end
