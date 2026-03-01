-- main.lua
-- Test for LoveInputActions library

InputAction = require("inputActions")

local inputConfig = {
    InputAction.new("btn1", {"space", "j"}),
    InputAction.new("btn2", {"lctrl"}),
    InputAction.new("copy", {{"lctrl", "c"}}),
    InputAction.new("paste", {{"lctrl", "v"}}),
}

function love.load()
    InputAction.init(inputConfig)
end

function love.update(dt)
    InputAction.update(dt)
    if InputAction.isJustReleased("btn1") then
        print("just released btn1")
    end
    -- Repeat mechanic: returns true every 150ms while btn1 is held
    if InputAction.isJustPressed("btn1", 150) then
        print("just pressed btn1")
    end

    if InputAction.isJustPressed("copy") then
        print("copy action triggered")
    end

    if InputAction.isJustPressed("paste") then
        print("paste action triggered")
    end

    if InputAction.getLastPressedKey() then
        print("Last pressed key: " .. InputAction.getLastPressedKey())
    end

    if InputAction.isKeyJustPressed("a") then
        print("Key 'a' was just pressed")
    end

    if InputAction.isMouseJustPressed("mouse1") then
        print("Left mouse button just pressed")
    end

    if InputAction.isMouseJustReleased("mouse1") then
        print("Left mouse button just released")
    end

    if InputAction.isMouseJustPressed("mouse2") then
        print("Right mouse button just pressed")
    end

    if InputAction.isMouseJustReleased("mouse2") then
        print("Right mouse button just released")
    end

    InputAction.clearJustPressed()
end

function love.draw()
    love.graphics.print("Press SPACE for btn1, LCTRL for btn2, LCTRL+C for copy, LCTRL+V for paste", 10, 10)
    if InputAction.isPressed("btn1") then
        love.graphics.print("btn1 pressed", 10, 30)
    end
    if InputAction.isPressed("btn2") then
        love.graphics.print("btn2 pressed", 10, 50)
    end
    if InputAction.isPressed("copy") then
        love.graphics.print("copy pressed", 10, 70)
    end
    if InputAction.isPressed("paste") then
        love.graphics.print("paste pressed", 10, 90)
    end
end
