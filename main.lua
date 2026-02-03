function love.load()
	love.window.setFullscreen(true)
	screenWidth, screenHeight = love.graphics.getDimensions()
	love.graphics.setDefaultFilter("nearest", "nearest")

	image = love.graphics.newImage("images/I.png")

  scale = 0.5
	w, h = image:getDimensions()
	w, h = w * scale, h * scale

	canvas = love.graphics.newCanvas()

	shader = love.graphics.newShader("CRT2.glsl")
	shader:send("numColours", 256)
end

function love.draw()
	local downsize = 4
  local shrink = scale / downsize

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.draw(
		image,
		(screenWidth  - w) / (downsize * 2),
	  (screenHeight - h) / (downsize * 2),
		0,
		shrink,
		shrink
	)
	love.graphics.setCanvas()

	love.graphics.setShader(shader)
	love.graphics.draw(canvas, 0, 0, 0, downsize, downsize)
	love.graphics.setShader()
	love.graphics.setCanvas()
end
