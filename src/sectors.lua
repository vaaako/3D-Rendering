-- TEMPORARY --
local NUM_SECT = (#loadSectors / 6) - 1 -- -1 to fit on index 0
-- local NUM_SECT = #LevelMan.sectors / 6

-- [!] This would be a struct (sectors[30])
sectors = {} -- Object built of walls

-- Load sectors and walls --
local v1, v2 = 1, 1 -- [!] Since Lua table index starts with 1 replace '1' with '0'
for s = 0, NUM_SECT do -- Create all sectors
	-- [!] Instead of this, make it like -> sectors[s].ws = ... / sectors[s].we = ... and etc
	
	sectors[s] = {
		-- Wall number, start and end
		ws = loadSectors[v1 + 0], -- Wall start
		we = loadSectors[v1 + 1], -- Wall end

		-- Height of bottom and top
		z1 = loadSectors[v1 + 2], -- Sector bottom height
		z2 = loadSectors[v1 + 3] - loadSectors[v1 + 2], -- Sector top height

		-- Center position
		-- x = 0,
		-- y = 0,

		d = 0, -- Add y distances to sort drawing order

		-- Bottom and top color
		c1 = loadSectors[v1 + 4], -- Bottom color
		c2 = loadSectors[v1 + 5], -- Top Color

		surf = {}, -- To hold points for surface / [!] int surf[WIDTH]
		surface = nil -- Is there a surface to draw
	}

	-- [!] Remove "- 1"
	v1 = v1 + 6 -- Advance to next

	-- Make sectors wall
	for w = sectors[s].ws, sectors[s].we - 1 do
		walls[w] = {
			-- Bottom line point 1
			x1 = loadWalls[v2 + 0], -- Bottom x1
			y1 = loadWalls[v2 + 1], -- Bottom y1

			-- Bottom line point 2
			x2 = loadWalls[v2 + 2],  -- Top x2
			y2 = loadWalls[v2 + 3],  -- Top y2 line point 2

			c = loadWalls[v2 + 4] -- Color
		}

		v2 = v2 + 5 -- Advance to next
	end
end
-- TEMPORARY --






-- Help to decide each order to draw the sectors
local function distance(x1, y1, x2, y2) -- Simple distance formula
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end



-- Clip line
-- Change the intersection value (between wall) either to 0 or 1
-- [F!] Function variables (da, db, d etc)
function sectors.clipBehindPlayer(x1, y1, z1, x2, y2, z2) -- [!] x1, y1, z1 as pointers
	local da = y1 -- Distance plane -> point a
	local db = y2 -- Distance plane -> point b

	local d = da - db
	if d == 0 then
		d = 1
	end

	local s = da / d -- Intersection factor (Between 0 and 1)

	-- Differences to get the cut point
	x1 = x1 + s * (x2 - x1)
	y1 = y1 + s * (y2 - y1)

	-- [!] y1 == 0
	if y1 < 1 then 
		y1 = 1 -- Prevent divide by zero (going behind camera)
	end
	z1 = z1 + s * (z2 - z1)

	return x1, y1, z1
end

-- [F!] CS, SN
function sectors.makeWorld(x1, y1, x2, y2, sector)
	-- [!] Remove radians convertion
	local CS, SN = MATH_COS[player.a], MATH_SIN[player.a]


	-- World X position
	local wx = {
		[0] = x1 * CS - y1 * SN,
		[1] = x2 * CS - y2 * SN,
	}
	-- Top line has the same X
	wx[2] = wx[0]
	wx[3] = wx[1]


	-- World Y position (depth)
	local wy = {
		[0] = y1 * CS + x1 * SN,
		[1] = y2 * CS + x2 * SN
	}

	-- Top line has the same Y
	wy[2] = wy[0]
	wy[3] = wy[1]

	-- World Z height
	local wz = {
		[0] = sector.z1 - player.z + ((player.l * wy[0]) / 32), -- To look up and down
		[1] = sector.z1 - player.z + ((player.l * wy[1]) / 32) -- 32 = Lower the intensity of loop up and down
	}
	-- Top line Z
	wz[2] = wz[0] + sector.z2
	wz[3] = wz[1] + sector.z2

	return wx, wy, wz
end


function sectors.getSuface(sector)
	-- Just draw surface if visible
	if player.z < sector.z1 then -- Bottom surface
		-- If player is bellow that sectors Z value, draw bottom surface
		return 1
	elseif player.z > sector.z2 then -- Top surface
		return 2
	else
		-- If no surface is visible, don't draw none
		return 0 -- No surface
	end
end

function sectors.canDrawBack(sector)
	return player.z < sector.z1 or player.z > sector.z2
end


function sectors.draw()
	-- Order sectors by distance (to not clip)
	--[[
		This is the wrong way of doing this, since all will be rendering at the same time
		(except what is behind player since there is statement below preventing this)
		I need to render only what is visible
	]]
	-- bubblesort(sectors, sectors.NUM_SECT)
	quicksort(sectors, 0, NUM_SECT)


	-- [!] Remove "- 1" on each for-loop declaration
	for s = 0, NUM_SECT do -- Each sector
		local sector = sectors[s]
		sector.d = 0 -- Clear distance
		sector.surface = sectors.getSuface(sector)

		for loop = 0, 1 do -- [!] 0 -> 2 (this is because of the way lua loops works)
			for w = sector.ws, sector.we - 1 do -- Each wall of that sector
				local wall = walls[w]


				-- Offset bottom 2 points by player
				local x1 = wall.x1 - player.x
				local y1 = wall.y1 + player.y -- [Y!] '-'

				local x2 = wall.x2 - player.x
				local y2 = wall.y2 + player.y -- [Y!] '-'

				-- Swap variables draws the wall back / Show walls from behind, it is necessary for top and bottom surface
				if loop == 0 and sectors.canDrawBack(sector) then -- Arg #2 -> Prevent from drawing all the time
					x1, x2 = x2, x1
					y1, y2 = y2, y1
				end

				local wx, wy, wz = sectors.makeWorld(x1, y1, x2, y2, sector)

			    -- Store the distance from the camera to the wall
				sector.d = sector.d + distance(0,0, (wx[0] + wx[1]) / 2, (wy[0] + wy[1]) / 2) -- w = x1, x2, y1, y2

				-- If sector is distance is higher than MAX_DISTANCE, don't draw
				-- [!] This is not ready yet
				-- if sector.d > 800 then
				-- 	goto continue
				-- end


				-- Don't draw walls behind player
				-- [!] Change all below to "< 1" (for some reason in Love2D a smaller value clips and bugs)
				if wy[0] < 1 and wy[1] < 1 then
					goto continue
				end

				-- Point 1 behing player, clip
				if wy[0] < 1 then
					wx[0], wy[0], wz[0] = sectors.clipBehindPlayer(wx[0], wy[0], wz[0],  wx[1], wy[1], wz[1]) -- Bottom line
					wx[2], wy[2], wz[2] = sectors.clipBehindPlayer(wx[2], wy[2], wz[2],  wx[3], wy[3], wz[3]) -- Top line
				end

				-- Point 2 behing player, clip
				if wy[1] < 1 then
					wx[1], wy[1], wz[1] = sectors.clipBehindPlayer(wx[1], wy[1], wz[1],  wx[0], wy[0], wz[0]) -- Bottom line
					wx[3], wy[3], wz[3] = sectors.clipBehindPlayer(wx[3], wy[3], wz[3],  wx[2], wy[2], wz[2]) -- Top line
				end

				-- Screen X and Screen Y position
				-- [Y!] (remove "HEIGHT -" on 'Y')
				for i = 0, 3 do
					local invWy = 200 / wy[i]
					wx[i] = wx[i] * invWy + W2
					-- wy[i] = HEI200 / wy[i]GHT - (wz[i] * invWy + H2)
					wy[i] = wz[i] * invWy + H2
				end


				-- Draw points
				walls.draw(wx[0], wx[1], wy[0], wy[1], wy[2], wy[3], wall.c, sector)

				::continue::
			end

			-- Find average sector distance
			sector.d = sector.d / (sector.we - sector.ws)

			-- Flip to negative to draw surface
			sector.surface = sector.surface * -1 -- To draw next loop (see walls.lua)
		end
	end
end
