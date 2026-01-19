-- inputActions.lua
-- Action-based input system for Love2D

local InputAction = {}
InputAction.__index = InputAction

local actions = {}


local keyState = {}
local justPressed = {}
local justReleased = {}

local mouseState = {}
local mouseJustPressed = {}
local mouseJustReleased = {}

local lastPressedKey = nil
local lastKeyTimer = 0
local KEY_RESET_TIME = 0.3  -- seconds

local function arrayToSet(arr)
    local set = {}
    for _, v in ipairs(arr) do set[v] = true end
    return set
end

function InputAction.new(name, keys)
    local self = setmetatable({}, InputAction)
    self.name = name
    self.keys = keys or {}
    return self
end

function InputAction.init(config)
    actions = {}
    for _, action in ipairs(config) do
        actions[action.name] = arrayToSet(action.keys)
    end
    keyState = {}
    justPressed = {}
    justReleased = {}
    mouseState = {}
    mouseJustPressed = {}
    mouseJustReleased = {}
end

function InputAction.update(dt)
    for action, keys in pairs(actions) do
        local pressed = false
        for key in pairs(keys) do
            if love.keyboard.isDown(key) then
                pressed = true
                break
            end
        end
        if pressed and not keyState[action] then
            justPressed[action] = true
        else
            justPressed[action] = false
        end
        if not pressed and keyState[action] then
            justReleased[action] = true
        else
            justReleased[action] = false
        end
        keyState[action] = pressed
    end
    
    -- Update last key timer
    if lastKeyTimer > 0 then
        lastKeyTimer = lastKeyTimer - dt
        if lastKeyTimer <= 0 then
            lastPressedKey = nil
        end
    end
    
    -- Update mouse buttons
    for button = 1, 3 do
        local pressed = love.mouse.isDown(button)
        local action = "mouse" .. button
        if pressed and not mouseState[action] then
            mouseJustPressed[action] = true
        else
            mouseJustPressed[action] = false
        end
        if not pressed and mouseState[action] then
            mouseJustReleased[action] = true
        else
            mouseJustReleased[action] = false
        end
        mouseState[action] = pressed
    end
end

function InputAction.isPressed(action)
    return keyState[action] or false
end

function InputAction.isJustPressed(action)
    return justPressed[action] or false
end

function InputAction.isJustReleased(action)
    return justReleased[action] or false
end

function InputAction.isMousePressed(button)
    return mouseState["mouse" .. button] or false
end

function InputAction.isMouseJustPressed(button)
    return mouseJustPressed["mouse" .. button] or false
end

function InputAction.isMouseJustReleased(button)
    return mouseJustReleased["mouse" .. button] or false
end

function love.keypressed(key, _scancode, isrepeat)
    if not isrepeat then 
        lastPressedKey = key
        lastKeyTimer = KEY_RESET_TIME
    end
end

function InputAction.getLastPressedKey()
    return lastPressedKey
end

return InputAction
