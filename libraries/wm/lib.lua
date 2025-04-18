assert(KRISTAL_EVENT.drawScreen, "drawScreen Kristal event not detected! This library only works in Dark Place right now.")

Registry.registerGlobal("CURRENT_WINDOW_CONTENTS", false)
local lib = {}
Registry.registerGlobal("WM", lib)
WM = lib

function lib:getGameScale()
    return self.game_window.scale_x * self.game_window_contents.scale_x
end

function lib:init()
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    self.stage = Stage(0,0, love.graphics.getDimensions())
    self.desktop = Desktop()
    self.game_window_contents = CanvasContainer(SCREEN_CANVAS)
    self.game_window_contents.debug_select = false
    -- TODO: Allow resizing window without console commands
    if love.graphics.getHeight() > 960 then
        self.game_window_contents:setScale(2)
    elseif love.graphics.getHeight() <= 540 then
        self.game_window_contents:setScale(0.5)
    end
    self.game_window = Window(self.game_window_contents, 32,32)

    if Kristal.funny_titles then
        local funnytitle_rand = love.math.random(#Kristal.funny_titles)
        local funnytitle = Kristal.funny_titles[funnytitle_rand] or "Depa Runts"
        local funnyicon = Assets.getTexture("kristal/icons/icon_"..tostring(funnytitle_rand)) or Kristal.icon
        self.game_window.title = funnytitle
        self.game_window.icon = funnyicon
    end
    self.game_window.focused = true
    self.desktop:spawnWindow(self.game_window)
    self.stage:addChild(self.desktop)
    Utils.hook(Input, "getMousePosition", function(orig, x, y, relative)
        if not self.enabled then return orig(x,y,relative) end
        x = x or love.mouse.getX()
        y = y or love.mouse.getY()
        if CURRENT_WINDOW_CONTENTS then
            local off_x, off_y = CURRENT_WINDOW_CONTENTS:getScreenPos()
            return ((x-off_x)/self:getGameScale()),((y - off_y)/self:getGameScale())
        end
        do return x,y end
    end)
    Utils.hook(DebugSystem, "getStage", function (orig, dbg, ...)
        if DEBUG_RENDER then return self.stage end
        return orig(dbg,...)
    end)
    Utils.hook(World, "init", function (orig, self, ...)
        orig(self,...)
        ---@cast self World
        self.camera.width = 640
        self.camera.height = 480
    end)
    SCREEN_WIDTH, SCREEN_HEIGHT = 640,480
    pcall(function ()
        local names = love.filesystem.getDirectoryItems("wallpapers")
        self.wallpaper = love.graphics.newImage("wallpapers/"..Utils.pick(names))
        -- Linear for downscaling, nearest for upscaling.
        -- TODO: Make this configurable
        self.wallpaper:setFilter("linear", "nearest")
    end)
    self.enabled = true
end

function lib:postUpdate()
    if not self.enabled then return end
    ---@type Object|false
    CURRENT_WINDOW_CONTENTS = false
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    Kristal.callEvent("preUpdateScreen")
    self.stage:update()
    Kristal.callEvent("postUpdateScreen")
    SCREEN_WIDTH, SCREEN_HEIGHT = 640, 480
    CURRENT_WINDOW_CONTENTS = self.game_window_contents
    Kristal.showCursor()
end

function lib:drawScreen(canvas)
    if not self.enabled then return end
    love.graphics.push()
    CURRENT_WINDOW_CONTENTS = false
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    Kristal.callEvent("preDrawScreen")
    self.stage:draw()
    Kristal.Overlay:draw()
    Kristal.callEvent("postDrawScreen")
    SCREEN_WIDTH, SCREEN_HEIGHT = 640, 480
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

function lib:onKeyPressed(key)
    if not self.enabled then return end
    return not self.game_window:isWindowFocused()
end

return lib