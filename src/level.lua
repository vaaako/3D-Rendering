-- TEMPORARY --
loadSectors = { 
	-- wall start, wall end, z1 height, z2 height, bottom color, top color
	0,  4, 0, 40, {   0, 255,   0 }, {   0, 160,   0 }, -- sector 1
	4,  8, 0, 40, {   0, 255, 255 }, {   0, 160, 160 }, -- sector 2
	8, 12, 0, 40, { 160, 100,   0 }, { 110,  50,   0 }, -- sector 3
	12,16, 0, 40, { 255, 255,   0 }, { 160, 160,   0 }, -- sector 4

	16, 20, 0, 40, {  0, 255,   0 }, {   0, 160,   0 }, -- sector test
}

loadWalls = {
	-- World locations
	-- x1,y1, x2,y2, color
	0,  0, 32, 0, { 255, 255, 0 },
	32, 0, 32,32, { 160, 160, 0 },
	32,32,  0,32, { 255, 255, 0 },
	 0,32,  0, 0, { 160, 160, 0 },

	64, 0, 96, 0, { 0, 255, 0 },
	96, 0, 96,32, { 0, 160, 0 },
	96,32, 64,32, { 0, 255, 0 },
	64,32, 64, 0, { 0, 160, 0 },

	64,64, 96, 64, { 0, 255, 255 },
	96,64, 96, 96, { 0, 160, 160 },
	96,96, 64, 96, { 0, 255, 255 },
	64,96, 64, 64, { 0, 160, 160 },

	 0,64, 32, 64, { 160, 100, 0 },
	32,64, 32, 96, { 110 , 50, 0 },
	32,96,  0, 96, { 160, 100, 0 },
	 0,96,  0, 64, { 110 , 50, 0 },

	-- TEST 1
	256, 192, 320, 192, { 160, 100, 0 },
	320, 192, 320, 288, { 110 , 50, 0 },
	320, 288, 256, 288, { 160, 100, 0 },
	256, 288, 256, 192, { 110 , 50, 0 },
}
-- TEMPORARY --


-- Get all lines form a file
local function linesFrom(file)
	local lines = {}
	for line in io.lines(file) do
		table.insert(lines, line)
	end

	return lines
end

-- Split and insert to the table
local function splitTo(tab, input)
	for number in input:gmatch("%S+") do
		-- [!] TEMPORARY [!] --
		-- [!] This is temporary to choose the colors just until I change the level editor
		local n = tonumber(number)
		if n == 0 or n == 1 then
			math.randomseed(os.time())
			n = math.random(100, 255)
		end
		-- [!] TEMPORARY [!] --

		-- table.insert(tab, tonumber(number))
		table.insert(tab, n)
	end
end

local function getLines(tab, n, lines)
	-- Remove first line to get next number of lines
	table.remove(lines, 1) -- This is the line of "Number of X"

	local str = ""
	for _ = 1, n  do
		-- table.insert(tab, table.remove(lines, 1))
		str = str .. table.remove(lines, 1) .. " "
	end

	return str
end



LevelMan = {
	sectors = {},
	walls = {},

	path = "",
	lines = {},

	new = function(self, path)
		self.path = path
		self.lines = linesFrom(self.path)
		return self
	end,

	--[[
		First line of the file is the "Number of sectors"
		Then get all lines (getLines) and put on a single string

		This single string is passed to "splitTo", so it splits the string
		of number in items to insert to the table
	]]
	-- function levelMan:loadLevel(self, sectors, walls, file)
	loadLevel = function (self)
		splitTo(self.sectors, getLines(self.sectors, tonumber(self.lines[1]), self.lines))
		splitTo(self.walls, getLines(self.walls, tonumber(self.lines[1]), self.lines))

		-- The remaining line is the player's position
		-- print("Player's position: " .. self.lines[2]) -- x, y, z, a, l
	end
}