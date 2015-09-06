-- Clock! For all of you time freaks!
-- Not actually working, os.time() is broken.

font = font or vita2d.load_font()
local size = 60
local color = colors.white
local colortable = {}
for k, v in pairs(colors) do
	if v ~= colors.black then
		table.insert(colortable, v)
	end
end

-- Fixed variables.
local vita_w = 960
local vita_h = 544

--local old_pad = input.peek()
-- Start drawing.
while true do
	local pad = input.peek()

	if not (pad:l_trigger() or pad:r_trigger()) then
		os.sleep(0.5)
	end

	vita2d.start_drawing()
	vita2d.clear_screen()

	local timestr = os.date()

	-- MATH!!!
	local text_w, text_h = font:text_size(size, timestr)
	local center_w = vita_w/2 - text_w/2
	local center_h = vita_h/2 - text_h

	-- Draw the clock.
	font:draw_text(center_w, center_h, color, size, timestr)

	vita2d.end_drawing()
	vita2d.swap_buffers()

	-- Wait for input...
	if pad:cross() then -- change color
		color = colortable[math.random(#colortable)]
	elseif pad:circle() then
		break
	end

	--old_pad = pad
end
