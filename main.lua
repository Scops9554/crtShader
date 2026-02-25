function love.load()
	love.window.setFullscreen(true)
	screenWidth, screenHeight = love.graphics.getDimensions()
	love.graphics.setDefaultFilter("nearest", "nearest")

	image = love.graphics.newImage("images/P22.png")

	scale = 0.5
	w, h = image:getDimensions()
	w, h = w * scale, h * scale

	canvas = love.graphics.newCanvas()

	downsize = 4

	shader = love.graphics.newShader("CRT2.glsl")
	shader:send("numColours", 48)
	-- shader:send("texelSize", { 1 / w, 1 / h }) -- for animal well shader
end

function love.draw()
	local shrink = scale / downsize

	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.draw(
		image,
		(screenWidth - w) / (downsize * 2),
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
