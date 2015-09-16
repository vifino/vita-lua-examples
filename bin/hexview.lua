-- HexView
-- Usage: hexview file
local args = {...}
local file = args[1] -- Set the first argument as the file name.

local fh
if string.find(file, "^/") then -- Check if it is a physfs-mounted file or a full path
	fh = physfs.open(file)
else
	fh = io.open(file, "r")
end

-- Generate output
local lines = {} -- buffer containing each line of output
local hexstr = "" -- temporary string, to be added to lines

local bytes = 16 -- Bytes per row

local function genhex(byte) -- Function for formatting the number to a hex value which length is evenly devidable by 2.
	local hex = string.format("%X", byte or 0)
	if (#hex % 2) == 0 then
		return hex
	else
		return "0"..hex
	end
end

local count = 0 -- number of hex "sets" already added to hexstr.
local tmpvals = {} -- the temporary hex "sets".

while true do
	local char = fh:read(1) -- read a char
	if char == nil and #tmpvals == 0 then -- if the character is nil and there are no temporary values, exit the loop
		break
	else
		local byte = char and string.byte(char) or 0 -- get the character as a numeric byte value.
		count = count + 1 -- increase the number of temporary sets
		if #tmpvals == 16 then -- if there are 16 sets, write the line.
			hexstr = hexstr .. " |"
			for i=1,16 do
				local h = tmpvals[i]
				if h < 20 or h > 0x7e then -- check if the character is invisible/not displayable and write a "." instead, otherwise add the character normally
					hexstr = hexstr .. "."
				else
					hexstr = hexstr .. string.char(h)
				end
			end
			tmpvals = {} -- clear the temporary set table, we already processed it.
			count = 0 -- reset the counter
			table.insert(lines, hexstr .. "|\n") -- add a newline and a slight bit of formatting
			hexstr = "" -- also clear out the temporary hex sting
		else
			if count == 9 then -- write a seperator in the middle
				hexstr = hexstr .. " "
			end
			hexstr = hexstr .. genhex(byte) -- add the set to the string
			table.insert(tmpvals, byte) -- add it to the temporary set table
		end
	end
end
fh:close() -- close the file handle
if hexstr ~= "" then -- if it hasn't been cleared out already, add the temporary string to the output table
	table.insert(lines, hexstr)
end

if ui then -- if it is running on vita-lua, display it in the pager, otherwise just print the result.
	ui.pager(lines, file, false)
else
	for k, v in pairs(lines) do
		print(v)
	end
end
