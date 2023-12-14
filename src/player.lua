local PLAYER_SENS = 2
-- local PLAYER_SENS = 0.08
local PLAYER_SPEED = 20
local PLAYER_FLY_SPEED = 80

player = {
	x = 70,
	y = 110, -- Y! (-110)
	z = 20,
	a = 0, -- Angle
	l = 0 -- Look up/down
}

-- function player:update(dt)
-- end

function wrapAngle(angle)
	return (angle % 360 + 360) % 360
end

function player:move(key, dt)
	-- Turn LEFT and RIGHT
	if key == "a" then
		self.a = self.a - PLAYER_SENS
		self.a = wrapAngle(self.a - PLAYER_SENS)

		-- Make turn
		-- if self.a < 0 then
		-- 	self.a = self.a + 360
		-- end
	elseif key == "d" then
		self.a = self.a + PLAYER_SENS
		self.a = wrapAngle(self.a + PLAYER_SENS)

		-- if self.a > 359 then
		-- 	self.a = self.a - 360
		-- end
	end

	-- Calculate direction
	-- [!] Don't convert to radians
	local dx = (MATH_SIN[self.a] * 10) * PLAYER_SPEED
	local dy = (MATH_COS[self.a] * 10) * PLAYER_SPEED

	-- Move UP and DOWN
	if key == "w" then
		self.x = self.x + dx * dt
		self.y = self.y - dy * dt -- [Y!] +
	elseif key == "s" then
		self.x = self.x - dx * dt
		self.y = self.y + dy * dt -- [Y!] -
	end


	-- Move LEFT and RIGHT
	if key == "left" then
		self.x = self.x - dy * dt
		self.y = self.y - dx * dt -- [Y!] +
	elseif key == "right" then
		self.x = self.x + dy * dt
		self.y = self.y + dx * dt -- [Y!] -
	end


	-- MOVE HEAD --
	if key == "j" then
		self.l = self.l - (PLAYER_SPEED * 2) * dt
	elseif key == "l" then
		self.l = self.l + (PLAYER_SPEED * 2) * dt
	end

	-- FLY --
	if key == "i" then
		self.z = self.z - PLAYER_FLY_SPEED * dt
	elseif key == "k" then
		self.z = self.z + PLAYER_FLY_SPEED * dt
	end

	if key == "z" then
		self.z = 20
		self.l = 0
	end
end
