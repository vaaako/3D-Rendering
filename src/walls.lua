-- TEMPORARY --
-- [!] This would be a struct (walls[30])
local NUM_WALL = #loadWalls / 5
walls = {}


-- Test only
local TEXTURE = TexMan:new('resources/textures/1.png')

-- TEMPORARY --


local function setColorWithShadow(color, distance)
	distance = math.max(255, distance) -- Remove this if you want a brighter light
	love.graphics.setColor(color[1] / distance, color[2] / distance, color[3] / distance)
end


local function setColor(color)
	love.graphics.setColor(color[1] / 255, color[2] / 255, color[3] / 255)
end





-- Draw Vertical lines
-- [!] All variables here would be integer (that's why math.floor some)
function walls.draw(x1, x2, b1, b2, t1, t2, color, sector)
	-- Difference in distance
	local dyb = b2 - b1 -- Y distance of bottom line
	local dyt = t2 - t1 -- Y distance of top line
	local dx  = x2 - x1 -- X distancce
	if dx == 0 then -- Prevent divide by zero
		dx = 1
	end

	local xs = x1 -- Initial x1 start position


	-- CLIP X
	-- Clip LEFT
	x1 = math.max(1, x1)
	x2 = math.max(1, x2)

	-- Clip RIGHT
	x1 = math.min(WIDTH - 1, x1)
	x2 = math.min(WIDTH - 1, x2)

	-- love.graphics.rectangle("fill", x1, b1, x2 - x1, t1 - b1)

	-- Draw X verticle lines
	for x = math.floor(x1), math.floor(x2) do
		-- The Y start and end point
		local y1 = dyb * (x - xs + 0.5) / dx + b1-- Y Bottom point
		local y2 = dyt * (x - xs + 0.5) / dx + t1-- Y top point

		-- Draw wall top and bottom segments
		-- love.graphics.points(x, y1)
		-- love.graphics.points(x, y2)

		-- [!] This would be the "right" way
		-- [!] If using this method the texture would have to be draw pixel by pixel (like below) and get each pixel color to draw the full texture
		-- for y = y1, y2 do
		-- 	love.graphics.points(x, y)
		-- end

		-- Clip Y
		y1 = math.max(1, y1)
		y2 = math.max(1, y2)

		-- Clip TOP
		-- [Y!] max?
		y1 = math.min(HEIGHT - 1, y1)
		y2 = math.min(HEIGHT - 1, y2)


		-- Surface
		if sector.surface == 1 then -- Store bottom points to draw in next loop
			sector.surf[x] = math.floor(y1)
			goto continue
		elseif sector.surface == 2 then -- Store top points
			sector.surf[x] = math.floor(y2)
			goto continue
		elseif sector.surface == -1 then -- Bottom
			setColor(sector.c1) -- Get top color
			-- love.graphics.line(x, sector.surf[x], x, y1)

			local surfX = sector.surf[x]
			love.graphics.rectangle("fill", x, surfX, 1, y1 - surfX)
		elseif sector.surface == -2 then -- Top
			setColor(sector.c2) -- Get bottom color

			-- love.graphics.line(x, y2, x, sector.surf[x])

			local surfX = sector.surf[x]
			love.graphics.rectangle("fill", x, y2, 1, surfX - y2)
		end

		-- Normal
		setColorWithShadow(color, sector.d)
		-- setColor(color)


		-- love.graphics.rectangle("fill", x, y1, 1, y2 - y1)
		-- love.graphics.line(x, y1, x, y2)

		-- This bellow can be used for billboarding --
		-- local width = x2 - x1
		-- local height = y2 - y1

		-- local scaleX = width / TEXTURE:getWidth()
		-- local scaleY = height / TEXTURE:getHeight()

		-- love.graphics.draw(TEXTURE, x1, y1, 0, scaleX, scaleY)



		-- WALL TEXTURE --
		-- Not perfect but works
		local quad = TEXTURE:getQuadFromLoop(x, x1, y1, x2, y2)

		-- Just render texture when inside render distance
		-- Not ready yet
		if sector.d < 800 * 5 then
			love.graphics.draw(TEXTURE:getImage(), quad[1], x, y1, 0, quad[2], quad[3])
		end

		-- love.graphics.draw(TEXTURE, quad, x, y1, 0, scaleX, scaleY)
		-- WALL TEXTURE --



		::continue::
	end
end
