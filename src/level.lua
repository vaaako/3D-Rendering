--[[
	[!] I will not be convering this file so much, but is pretty basic
	Just reading the code below you can get it
	- Read the level file
	- Get the sectors and walls info
	- Pass to the original array (in this case I'm making another one, but in other language you might want to use the original one)
		+ Like it was done with "loadSectors" and "loadWalls", the "value assigment" part ("loadLevel" here)
		+ You can check for next number until the end of the file (like is done here and can be done in C) or read line by line and split the values
]]


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








LevelMan = {
	-- [!] This two below would be a struct (sectors[30] and walls[30])
	sectors = {},
	walls = {},

	NUM_SECT = 0,
	NUM_WALL = 0,

	path = "",


	new = function(self, path)
		self.path = path
		return self
	end,


	loadLevel = function (self)
		local file = io.open(self.path, "r")
		if file == nil then
			print("Error: opening " .. file)
			os.exit(1)
		end

		-- Get next number (first number wich is the number of sectors)
		self.NUM_SECT = tonumber(file:read("*n")) -- *n -> Get next number

		if self.NUM_SECT == nil then
			print("Error: level file content is incorrect [" .. self.path .. "]")
			os.exit(1)
		end

		print("NUM_SECT", self.NUM_SECT)
		-- [!] Remove -1 from each for loop (I made this so the loop runs the right amount)
		for s = 0, self.NUM_SECT - 1 do
			-- print("RUN!")

			-- [!] Instead of this, make it like -> sectors[s].ws = ...; sectors[s].we = ...; and etc
			level.sectors[s] = {
				-- Wall number, start and end
				ws = tonumber(file:read("*n")), -- Wall start
				we = tonumber(file:read("*n")), -- Wall end

				-- Height of bottom and top
				z1 = tonumber(file:read("*n")), -- Sector bottom height
				z2 = tonumber(file:read("*n")), -- Sector top height

				d = 0, -- Add y distances to sort drawing order

				-- Surfaces
				st = tonumber(file:read("*n")), -- Surface texture
				sc = tonumber(file:read("*n")), -- Surface scale

				-- TEMPORARY --
				-- Bottom and top color
				c1 = { math.random(1, 255), math.random(1, 255), math.random(255) }, -- Bottom color
				c2 = { math.random(1, 255), math.random(1, 255), math.random(255) }, -- Top Color
				-- TEMPORARY -- 

				surf = {}, -- To hold points for surface / [!] int surf[WIDTH]
				surface = nil -- Is there a surface to draw
			}

			local sector = level.sectors[s]
			print(sector.ws, sector.we, sector.z1, sector.z2, sector.c1, sector.c2)
		end

		-- [!] Remove -1
		self.NUM_WALL = tonumber(file:read("*n"))
		for w = 0, self.NUM_WALL - 1 do -- Number of walls
			level.walls[w] = {
				-- Bottom line point 1
				x1 = tonumber(file:read("*n")), -- Bottom x1
				y1 = tonumber(file:read("*n")), -- Bottom y1

				-- Bottom line point 2
				x2 = tonumber(file:read("*n")), -- Top x2
				y2 = tonumber(file:read("*n")), -- Top x1

				-- Textures
				wt = tonumber(file:read("*n")), -- Wwall texture
				u = tonumber(file:read("*n")), -- Texture U (X)
				v = tonumber(file:read("*n")), -- Texture V (Y)

				shade = tonumber(file:read("*n")), -- Shade (shadow)

				-- TEMPORARY --
				c = { math.random(1, 255), math.random(1, 255), math.random(255) }
				-- TEMPORARY --
			}

			local wall = level.walls[w]
			print(w, "Wall", wall.x1, wall.y1, wall.x2, wall.y2, wall.c)
		end



		-- The remaining line is the player's position
		-- print("Player's position: " .. self.lines[2]) -- x, y, z, a, l
	end	
}