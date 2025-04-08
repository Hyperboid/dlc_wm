Registry.registerGlobal("CURRENT_WINDOW_CONTENTS", false)

function Mod:getGameScale()
    return self.game_window.scale_x * self.game_window_contents.scale_x
end

function Mod:postInit()
    Game.stage:addChild(Callback{draw = function() love.graphics.clear() end}):setLayer(-10)
end

love.window.setTitle("DpWM")
function Mod:init()
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    love.window.setTitle("DpWM")
    print("Loaded "..self.info.name.."!")
    self.stage = Stage(0,0, love.graphics.getDimensions())
    self.game_window_contents = CanvasContainer(SCREEN_CANVAS)
    self.game_window_contents.debug_select = false
    -- TODO: Allow resizing window without console commands
    if love.graphics.getHeight() > 960 then
        self.game_window_contents:setScale(2)
    elseif love.graphics.getHeight() < 540 then
        self.game_window_contents:setScale(0.5)
    end
    self.game_window = Window(self.game_window_contents, 32,32)
    self.game_window.focused = true
    self.stage:addChild(self.game_window)
    Utils.hook(Input, "getMousePosition", function(orig, x, y, relative)
        x = x or love.mouse.getX()
        y = y or love.mouse.getY()
        if CURRENT_WINDOW_CONTENTS then
            local off_x, off_y = CURRENT_WINDOW_CONTENTS:getScreenPos()
            return ((x-off_x)/self:getGameScale()),((y - off_y)/self:getGameScale())
        end
        do return x,y end
    end)
    Utils.hook(DebugSystem, "getStage", function (orig, dbg, ...)
        if DEBUG_RENDER then
        return self.stage end
        return orig(dbg,...)
    end)
    Utils.hook(World, "init", function (orig, self, ...)
        orig(self,...)
        ---@cast self World
        self.camera.width = 640
        self.camera.height = 480
    end)
    pcall(function ()
        local names = love.filesystem.getDirectoryItems("wallpapers")
        self.wallpaper = love.graphics.newImage("wallpapers/"..Utils.pick(names))
        -- Linear for downscaling, nearest for upscaling.
        -- TODO: Make this configurable
        self.wallpaper:setFilter("linear", "nearest")
    end)
end

function Mod:postUpdate()
    ---@type Object|false
    CURRENT_WINDOW_CONTENTS = false
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    self.stage:update()
    SCREEN_WIDTH, SCREEN_HEIGHT = 640, 480
    CURRENT_WINDOW_CONTENTS = self.game_window_contents
    Kristal.showCursor()
end

function Mod:drawScreen(canvas)
    if not self.stage then return end -- TODO: Fix it so it doesn't call this while loading
    love.graphics.push()
    CURRENT_WINDOW_CONTENTS = false
    if self.wallpaper then
        love.graphics.push()
        local w,h = self.wallpaper:getDimensions()
        love.graphics.draw(self.wallpaper, 0,0,0, love.graphics.getWidth()/w, love.graphics.getHeight()/h)
        love.graphics.pop()
    end
    self.stage:draw()
    CURRENT_WINDOW_CONTENTS = self.game_window_contents
    love.graphics.pop()
    if (not Kristal.Config["systemCursor"]) and (Kristal.Config["alwaysShowCursor"] or MOUSE_VISIBLE) and love.window then
        if Input.usingGamepad() then
            Draw.setColor(0, 0, 0, 0.5)
            love.graphics.circle("fill", Input.gamepad_cursor_x, Input.gamepad_cursor_y, Input.gamepad_cursor_size)
            Draw.setColor(1, 1, 1, 1)
            love.graphics.circle("line", Input.gamepad_cursor_x, Input.gamepad_cursor_y, Input.gamepad_cursor_size)
        elseif MOUSE_SPRITE and love.window.hasMouseFocus() then
            Draw.draw(MOUSE_SPRITE, love.mouse.getX(),
                      love.mouse.getY(), 0, 2, 2)
        end
    end
    return true
end

function Mod:onKeyPressed(key)
    return not self.game_window:isWindowFocused()
end