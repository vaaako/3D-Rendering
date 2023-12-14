require "conf"

require "src/glob" -- Global Variables
require "src/texman" -- Texture Manager
require "src/level" -- Level Manager

require "src/player"
require "src/walls"
require "src/sectors"

--[[
-= WARNINGS =-
Since I want this to be portable this are some warnings of changes you might need to
do on porting to another framework/language

OBS.: Where Y is originally '+' it changes to '-'
- Since OpenGL and Love2D 'Y coords' are inverted (for some reason)
	+ I added a "Y!" warning to where I changed the Y followed by "original operator"
	+ In fact this just changes the order of drawing sectors and movement
- Almost all variables are Integer, except the ones with [F!]
	+ This is important to know because there are some operations that if uses float will cause bugs
- General warnings on converting to OpenGL are prefixed with [!] followed by the "what do in OpenGL"
--]]

local keysPressed = {}

function love.load()

end

function love.update(dt)
	-- player:update(dt)

	for key, _ in pairs(keysPressed) do
		player:move(key, dt)
	end
end

function love.draw()
	love.graphics.clear(0.3, 0.3, 0.3)


	sectors.draw()

	-- Print with shadow (this is not using many CPU and Memory so I can do that)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("FPS: " .. love.timer.getFPS() .. "\nX:" .. player.x .. "\nY:" .. player.y .. "\nZ:" .. player.z .. "\nA:" .. player.a .. "\nL: " .. player.l, 12, 12)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("FPS: " .. love.timer.getFPS() .. "\nX:" .. player.x .. "\nY:" .. player.y .. "\nZ:" .. player.z .. "\nA:" .. player.a .. "\nL: " .. player.l, 10, 10)


	-- love.graphics.setColor(1, 1, 0)
	-- love.graphics.rectangle("fill", 10, 10, 60, 60)
end



function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
		love.window.close()
		love.event.quit()
	end

	keysPressed[key] = true
end

function love.keyreleased(key, scancode)
	keysPressed[key] = nil
end

function love.resize(w, h)
	-- Maintain the aspect ratio
	WIDTH = w
	HEIGHT = h
	W2 = WIDTH / 2
	H2 = HEIGHT / 2
end

