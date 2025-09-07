-- inputActions.lua
-- Action-based input system for Love2D

local InputAction = {}
InputAction.__index = InputAction

local actions = {}


local keyState = {}
local justPressed = {}
local justReleased = {}

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
end

function InputAction.update()
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

return InputAction
