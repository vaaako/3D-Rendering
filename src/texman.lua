TexMan = {
	path = nil,
	image = nil,
	width = 0,
	height = 0,


	new = function(self, path)
		-- setmetatable({}, self)
		-- self.__index = self

		self.path = path
		self.image = love.graphics.newImage(path)

		self.image:setMipmapFilter()
		self.image:setFilter("nearest", "nearest")

		self.width  = self.image:getWidth()
		self.height = self.image:getHeight()

		return self
	end,

	getWidth = function(self)
		return self.width
	end,

	getHeight = function(self)
		return self.height
	end,

	getImage = function(self)
		return self.image
	end,

	getTextureDimensions = function(x1, y1, x2, y2)
		return x2 - x1, y2 - y1
	end,

	getTextureScales = function(self, width, height)
		return width / self.width, height / self.height
	end,

	getQuadFromLoop = function(self, x, x1, y1, x2, y2)
		local width = x2 - x1
		local height = y2 - y1

		local scaleX = width / self.width
		local scaleY = height / self.height

		-- Quad coordinates based on the current wall segment
		local quadX = (x - x1) / width * self.width
		local quadY = -100
		-- local quadWidth = 2 / width * self.width
		local quadWidth = 1 / scaleX
		local quadHeight = self.height

		return {
			love.graphics.newQuad(quadX, quadY, quadWidth, quadHeight, self.width, self.height),
			scaleX,
			scaleY
		}
	end

}

