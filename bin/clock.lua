-- Clock! For all of you time freaks!
-- Not actually working, os.time() is not exported yet.

font = font or vita2d.load_font() -- load the font if not already loaded.
local size = 60 -- font size
local color = colors.white -- start out with white text
local colortable = {} -- table with all the colors except black!
for k, v in pairs(colors) do
	if v ~= colors.black then -- if the color is anything other than black..
		table.insert(colortable, v) -- add color to colortable
	end
end

-- Fixed variables.
local vita_w = 960 -- vita screen width
local vita_h = 544 -- vita screen height

-- Start drawing.
while true do
	local pad = input.peek() -- get the pad

	if not (pad:l_trigger() or pad:r_trigger()) then -- if the left trigger or right trigger are pressed, don't sleep and run this loop at 60fps, so inputs get registered more easily/better.
		os.sleep(0.5)
	end

	vita2d.start_drawing() -- start drawing section
	vita2d.clear_screen() -- clear the screen

	local timestr = os.date() -- get the time, duh.

	-- MATH!!!
	local text_w, text_h = font:text_size(size, timestr) -- get the text height and width..
	local center_w = vita_w/2 - text_w/2 -- and use it to determine the position..
	local center_h = vita_h/2 - text_h -- to draw the string at, so it is centered.

	-- Draw the clock.
	font:draw_text(center_w, center_h, color, size, timestr) -- draw the string at the position calculated before

	vita2d.end_drawing() -- end drawing
	vita2d.swap_buffers() -- swap the buffers, so stuff gets displayed

	-- Wait for input...
	if pad:cross() then -- change color -- if cross is pressed..
		color = colortable[math.random(#colortable)] -- change the color to a random one.
	elseif pad:circle() then -- exit if circle is pressed
		break
	end
end
