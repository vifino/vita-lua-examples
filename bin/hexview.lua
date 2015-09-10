-- HexView
-- Usage: hexview file
local args = {...}
local file = args[1]

local fh
if string.find(file, "^/") then -- physfs file
	fh = physfs.open(file)
else
	fh = io.open(file, "r")
end

-- Generate output
local lines = {}
local hexstr = ""

local bytes = 16 -- Bytes per row

local function genhex(byte)
	local hex = string.format("%X", byte or 0)
	if (#hex % 2) == 0 then
		return hex
	else
		return "0"..hex
	end
end

local count = 0
local tmpvals = {}

while true do
	local char = fh:read(1)
	if char == nil and #tmpvals == 0 then
		break
	else
		local byte = char and string.byte(char) or 0
		count = count + 1
		if #tmpvals == 16 then
			hexstr = hexstr .. " |"
			for i=1,16 do
				local h = tmpvals[i]
				if h < 20 or h > 0x7e then
					hexstr = hexstr .. "."
				else
					hexstr = hexstr .. string.char(h)
				end
			end
			tmpvals = {}
			count = 0
			table.insert(lines, hexstr .. "|\n")
			hexstr = ""
		else
			if count == 9 then
				hexstr = hexstr .. " "
			end
			hexstr = hexstr .. genhex(byte)
			table.insert(tmpvals, byte)
		end
	end
end
fh:close()
if hexstr ~= "" then
	table.insert(lines, hexstr)
end

if ui then
	ui.pager(lines, file, false)
else
	for k, v in pairs(lines) do
		print(v)
	end
end
