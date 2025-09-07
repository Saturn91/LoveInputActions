# Love input actions
This repository holds library code for an action based input system. So that instead of checking for specific keys to be pressed you can check if the action "jump" is pressed. An action can be triggered by multiple keys.

# import into project
You can either load in the folder `src` directly into your love2d project or use this repo as a git submodule

## use as a git submodule
1. `git submodule add https://github.com/Saturn91/LoveInputActions.git libs/inputActions`
2. in order to allow relative imports use this handy code:

```lua
local packages = {
  "libs/inputActions",
}

local current = love.filesystem.getRequirePath and love.filesystem.getRequirePath() or "?.lua;"
love.filesystem.setRequirePath(table.concat(packages, ";") .. ";" .. current)
```

# Setup in code

The bellow code shows the initial setup

```lua
-- main.lua
InputAction = require("libs.inputActions/inputActions")

local inputConfig = {
    InputAction.new("btn1", ["space"]),
    InputAction.new("btn2", ["lctrl"]),
}

function love.load()
    InputAction.init(inputConfig)
end

function love.update(dt)
    InputAction.update()
    
    if InputAction.isJustReleased("btn1") then
        print("just released")
    end

    if InputAction.isJustPressed("btn1") then
        print("just pressed")
    end

    if InputAction.isPressed("btn1") then
        print("pressed")
    end
end
```