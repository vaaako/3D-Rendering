RES = 1

PIXEL_SCALE = 4
WIDTH = 160 * PIXEL_SCALE -- 640
HEIGHT = 120 * PIXEL_SCALE -- 480
W2 = WIDTH / 2
H2 = HEIGHT / 2
FOV = 200

function love.conf(t)
	t.window.title = "Untitled"
	t.window.width = WIDTH
	t.window.height = HEIGHT

	t.window.minwidth = WIDTH
	t.window.minheight = HEIGHT

	t.window.centered = true
	t.window.borderless = false
	t.window.resizable = true -- !
	t.window.fullscreen = false

	-- t.window.highdpi = false
	-- love.graphics.setPointSize(PIXEL_SCALE)
end