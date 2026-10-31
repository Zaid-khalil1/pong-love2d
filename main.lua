
-- Pong Game - LÖVE2D
-- Task 1 + Task 2

local windowWidth = 800
local windowHeight = 500

local player1 = {}
local player2 = {}
local ball = {}

-- Task 1: Window and paddles
function love.load()
	love.window.setMode(windowWidth, windowHeight)
	love.window.setTitle("Pong Game")

	-- Left paddle
	player1 = {
		x = 30,
		y = 200,
		width = 15,
		height = 100,
		speed = 300
	}

	-- Right paddle
	player2 = {
		x = 755,
		y = 200,
		width = 15,
		height = 100,
		speed = 300
	}

	-- Task 2: Ball
	ball = {
		x = windowWidth / 2 - 10,
		y = windowHeight / 2 - 10,
		width = 20,
		height = 20,
		dx = 250,
		dy = 180
	}
end

-- AABB rectangle collision
function checkCollision(a, b)
	return a.x < b.x + b.width
	and a.x + a.width > b.x
	and a.y < b.y + b.height
	and a.y + a.height > b.y
end

-- Reset ball to center
function resetBall()
	ball.x = windowWidth / 2 - ball.width / 2
	ball.y = windowHeight / 2 - ball.height / 2

	ball.dx = -ball.dx

	if ball.dx > 0 then
		ball.dx = 250
	else
		ball.dx = -250
	end

	ball.dy = 180
end

function love.update(dt)

-- Task 1: Move left paddle
	if love.keyboard.isDown("w") then
		player1.y = player1.y - player1.speed * dt
	end

	if love.keyboard.isDown("s") then
		player1.y = player1.y + player1.speed * dt
	end

	-- Move right paddle
	if love.keyboard.isDown("up") then
		player2.y = player2.y - player2.speed * dt
	end

	if love.keyboard.isDown("down") then
		player2.y = player2.y + player2.speed * dt
	end

	-- Keep paddles inside window
	player1.y = math.max(0,
		math.min(player1.y, windowHeight - player1.height))

	player2.y = math.max(0,
		math.min(player2.y, windowHeight - player2.height))

	-- Task 2: Move ball using delta time
	ball.x = ball.x + ball.dx * dt
	ball.y = ball.y + ball.dy * dt

	-- Bounce from top wall
	if ball.y <= 0 then
		ball.y = 0
		ball.dy = math.abs(ball.dy)
	end

	-- Bounce from bottom wall
	if ball.y + ball.height >= windowHeight then
		ball.y = windowHeight - ball.height
		ball.dy = -math.abs(ball.dy)
	end

	-- Collision with left paddle
	if ball.dx < 0 and checkCollision(ball, player1) then
		ball.x = player1.x + player1.width

		-- Own feature: increase ball speed by 5%
		ball.dx = math.abs(ball.dx) * 1.05
	end

	-- Collision with right paddle
	if ball.dx > 0 and checkCollision(ball, player2) then
		ball.x = player2.x - ball.width

		-- Own feature: increase ball speed by 5%
		ball.dx = -math.abs(ball.dx) * 1.05
	end

	-- Reset ball if it leaves the screen
	if ball.x + ball.width < 0
	or ball.x > windowWidth then
		resetBall()
	end
end

function love.draw()

-- Dark background
	love.graphics.clear(0.08, 0.08, 0.12)

	-- Left paddle (green)
	love.graphics.setColor(0.2, 0.9, 0.5)
	love.graphics.rectangle(
		"fill",
		player1.x,
		player1.y,
		player1.width,
		player1.height
	)

	-- Right paddle (blue)
	love.graphics.setColor(0.2, 0.6, 1)
	love.graphics.rectangle(
		"fill",
		player2.x,
		player2.y,
		player2.width,
		player2.height
	)

	-- Ball (white)
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle(
		"fill",
		ball.x,
		ball.y,
		ball.width,
		ball.height
	)

	-- Center dashed line
	love.graphics.setColor(0.4, 0.4, 0.4)

	for y = 0, windowHeight, 30 do
		love.graphics.rectangle(
			"fill",
			windowWidth / 2 - 2,
			y,
			4,
			15
		)
	end

	-- Controls text
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Player 1: W / S", 30, 15)
	love.graphics.print("Player 2: UP / DOWN", 610, 15)
end