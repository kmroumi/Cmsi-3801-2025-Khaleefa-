local M = {}


function M.first_then_apply(seq, predicate, f)
  for i = 1, #seq do
    local s = seq[i]
    if predicate(s) then
      return f(s)
    end
  end
  return nil
end

function M.powers_generator(base, limit)
  local co = coroutine.create(function()
    local value = 1
    while value <= limit do
      coroutine.yield(value)
      value = value * base
    end
  end)
  return co
end

function M.meaningful_line_count(filename)
  local fh, err = io.open(filename, "r")
  if not fh then error(err) end
  local count = 0
  for line in fh:lines() do
    local left = line:gsub("^%s+", "")
    if left ~= "" and left:sub(1,1) ~= "#" and not left:match("^%s*$") then
      count = count + 1
    end
  end
  fh:close()
  return count
end

function M.say(word)
  local words = {}
  if word == nil then return "" end
  table.insert(words, tostring(word))
  local function inner(next_word)
    if next_word == nil then
      return table.concat(words, " ")
    end
    table.insert(words, tostring(next_word))
    return inner
  end
  return inner
end

local Quaternion = {}
Quaternion.__index = Quaternion

local function is_zero(x) return math.abs(x) < 1e-12 end
local function is_int(x) return math.abs(x - math.floor(x)) < 1e-12 end
local function numstr(x)
  if is_int(x) then
    return string.format("%.1f", x) 
  else
    return tostring(x)
  end
end

function Quaternion.new(a, b, c, d)
  local q = { a = a or 0.0, b = b or 0.0, c = c or 0.0, d = d or 0.0 }
  return setmetatable(q, Quaternion)
end

function Quaternion:coefficients()
  return { self.a, self.b, self.c, self.d }
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion.__add(u, v)
  return Quaternion.new(u.a + v.a, u.b + v.b, u.c + v.c, u.d + v.d)
end

function Quaternion.__mul(u, v)
  local a1,b1,c1,d1 = u.a,u.b,u.c,u.d
  local a2,b2,c2,d2 = v.a,v.b,v.c,v.d
  return Quaternion.new(
    a1*a2 - b1*b2 - c1*c2 - d1*d2,
    a1*b2 + b1*a2 + c1*d2 - d1*c2,
    a1*c2 - b1*d2 + c1*a2 + d1*b2,
    a1*d2 + b1*c2 - c1*b2 + d1*a2
  )
end

function Quaternion.__eq(u, v)
  return u.a == v.a and u.b == v.b and u.c == v.c and u.d == v.d
end

function Quaternion.__tostring(q)
  local parts = {}

  if not is_zero(q.a) then
    table.insert(parts, numstr(q.a))
  end

  local function add_term(coef, sym)
    if is_zero(coef) then return end
    local negative = coef < 0
    local absval = negative and -coef or coef
    local term = (math.abs(absval - 1.0) < 1e-12) and sym or (numstr(absval) .. sym)
    if #parts == 0 then
      table.insert(parts, negative and ("-" .. term) or term)
    else
      table.insert(parts, (negative and "-" or "+") .. term)
    end
  end

  add_term(q.b, "i")
  add_term(q.c, "j")
  add_term(q.d, "k")

  if #parts == 0 then return "0" end
  return table.concat(parts, "")
end

M.Quaternion = Quaternion


_G.first_then_apply      = M.first_then_apply
_G.powers_generator      = M.powers_generator
_G.meaningful_line_count = M.meaningful_line_count
_G.say                   = M.say
_G.Quaternion            = Quaternion

return M
