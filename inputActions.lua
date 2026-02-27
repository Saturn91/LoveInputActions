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

local individualKeyState = {}
local individualKeyJustPressed = {}
local individualKeyJustReleased = {}

local repeatTimers = {}

local lastPressedKey = nil
local lastKeyTimer = 0
local KEY_RESET_TIME = 0.3  -- seconds

function InputAction.new(name, keys)
    local self = setmetatable({}, InputAction)
    self.name = name
    self.keys = keys or {}
    return self
end

function InputAction.init(config)
    actions = {}
    for _, action in ipairs(config) do
        actions[action.name] = action.keys
    end
    keyState = {}
    justPressed = {}
    justReleased = {}
    mouseState = {}
    mouseJustPressed = {}
    mouseJustReleased = {}
    individualKeyState = {}
    individualKeyJustPressed = {}
    individualKeyJustReleased = {}
    repeatTimers = {}
end

function InputAction.update(dt)
    for action, keys in pairs(actions) do
        local pressed = false
        for _, key_or_combo in ipairs(keys) do
            local combo_pressed = true
            if type(key_or_combo) == "string" then
                combo_pressed = love.keyboard.isDown(key_or_combo)
            elseif type(key_or_combo) == "table" then
                for _, k in ipairs(key_or_combo) do
                    if not love.keyboard.isDown(k) then
                        combo_pressed = false
                        break
                    end
                end
            end
            if combo_pressed then
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
    
    -- Update repeat timers
    for action, _ in pairs(actions) do
        if keyState[action] then
            if not repeatTimers[action] then
                repeatTimers[action] = 0
            end
            repeatTimers[action] = repeatTimers[action] + dt
        else
            repeatTimers[action] = nil
        end
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
    
    -- Reset individual key just pressed/released states for next frame
    individualKeyJustPressed = {}
    individualKeyJustReleased = {}
end
end

function InputAction.isPressed(action)
    return keyState[action] or false
end

function InputAction.isJustPressed(action, repeatMs)
    if not repeatMs then
        return justPressed[action] or false
    end
    if not keyState[action] then
        return false
    end
    local interval = repeatMs / 1000
    if repeatTimers[action] and repeatTimers[action] >= interval then
        repeatTimers[action] = repeatTimers[action] - interval
        return true
    end
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
        
        -- Track individual key presses
        if not individualKeyState[key] then
            individualKeyJustPressed[key] = true
        end
        individualKeyState[key] = true
    end
end

function love.keyreleased(key)
    individualKeyState[key] = false
    individualKeyJustReleased[key] = true
end

function love.mousereleased(x, y, button)
    local action = "mouse" .. button
    mouseState[action] = false
    mouseJustReleased[action] = true
end

function InputAction.isKeyPressed(key)
    return individualKeyState[key] or false
end

function InputAction.isKeyJustPressed(key)
    return individualKeyJustPressed[key] or false
end

function InputAction.isKeyJustReleased(key)
    return individualKeyJustReleased[key] or false
end
