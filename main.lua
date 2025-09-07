-- main.lua
-- Test for LoveInputActions library

InputAction = require("inputActions")

local inputConfig = {
    InputAction.new("btn1", {"space"}),
    InputAction.new("btn2", {"lctrl"}),
}

function love.load()
    InputAction.init(inputConfig)
end

function love.update(dt)
    InputAction.update()
    if InputAction.isJustReleased("btn1") then
        print("just released btn1")
    end
    if InputAction.isJustPressed("btn1") then
        print("just pressed btn1")
    end
    if InputAction.isPressed("btn1") then
        print("pressed btn1")
    end
end

function love.draw()
    love.graphics.print("Press SPACE for btn1, LCTRL for btn2", 10, 10)
    if InputAction.isPressed("btn1") then
        love.graphics.print("btn1 pressed", 10, 30)
    end
    if InputAction.isPressed("btn2") then
        love.graphics.print("btn2 pressed", 10, 50)
    end
end
