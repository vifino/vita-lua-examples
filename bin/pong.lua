local timer = {}
timer.timers = {}

function timer.create(t, f)
  local tab = {}
  tab.needed = t * 60 -- per frame
  tab.func = f 
  tab.time = 0
  timer.timers[tab] = tab
  return tab
end

function timer.update()
  local to_remove = {}

  for k,v in pairs(timer.timers) do
    v.time = v.time + 1
    if v.time >= v.needed then
      v.func()
      table.insert(to_remove, v)
    end
  end

  for k,v in pairs(to_remove) do
    timer.timers[v] = nil
  end
end

local paddle1 = { x = 32, y = 256} -- paddles are 8x64
local paddle2 = { x = 928, y = 256} 
local p1_score = 0
local p2_score = 0
local ball = { x = 472, y = 264 } -- ball is 16x16
local ballspeed = 3
local ball_v = { x = ballspeed, y = ballspeed } -- pixels per frame!
local paddlespeed = 5
local font = vita2d.load_font()

local running = false
timer.create(2, function() running = true end)

function aabb(a, b, a_w, a_h, b_w, b_h)
  return a.x < b.x+b_w and
         a.x+a_w > b.x and
         a.y < b.y+b_h and
         a.y+a_h > b.y
end

while true do
  vita2d.start_drawing()
    vita2d.clear_screen()
    vita2d.draw_rectangle(ball.x, ball.y, 16, 16, colors.white)
    vita2d.draw_rectangle(paddle1.x, paddle1.y, 8, 64, colors.white)
    vita2d.draw_rectangle(paddle2.x, paddle2.y, 8, 64, colors.white)
    font:draw_text(240, 0, colors.white, 40, tostring(p1_score))
    font:draw_text(720, 0, colors.white, 40, tostring(p2_score))
  vita2d.end_drawing()
  vita2d.swap_buffers()

  local pad = input.peek()

  if pad:up() then
    paddle1.y = paddle1.y - paddlespeed
  end

  if pad:down() then
    paddle1.y = paddle1.y + paddlespeed
  end

  if pad:triangle() then
    paddle2.y = paddle2.y - paddlespeed
  end
  
  if pad:cross() then
    paddle2.y = paddle2.y + paddlespeed
  end
  
  if pad:start() then
    break
  end

  if aabb(paddle1, ball, 8, 64, 16, 16) or aabb(paddle2, ball, 8, 64, 16, 16) then
    ball_v.x = -ball_v.x
  end
 
  if running then
    ball.x = ball.x + ball_v.x
    ball.y = ball.y + ball_v.y
  end

  if ball.y < 0 or ball.y > (544 - 16) then
    ball_v.y = -ball_v.y
    ball.y = ball.y + ball_v.y
  end

  if ball.x < 0 or ball.x > (960 - 16) then
    if ball.x < 0 then
      ball_v.x = ballspeed
      p2_score = p2_score + 1
    else
      ball_v.x = -ballspeed
      p1_score = p1_score + 1
    end

    ball = { x = 472, y = 264 }
    running = false
    timer.create(2, function() running = true end)
  end

  timer.update()
end
