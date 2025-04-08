Registry.registerGlobal("CURRENT_WINDOW_CONTENTS", false)

function Mod:getGameScale()
    return self.game_window.scale_x * self.game_window_contents.scale_x
end

love.window.setTitle("DpWM")
function Mod:init()
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    SCREEN_WIDTH, SCREEN_HEIGHT = SCREEN_WIDTH, SCREEN_HEIGHT
    love.window.setTitle("DpWM")
    print("Loaded "..self.info.name.."!")
    self.stage = Stage(0,0, love.graphics.getDimensions())
    self.game_window_contents = CanvasContainer(SCREEN_CANVAS)
    self.game_window_contents.debug_select = false
    self.game_window = Window(self.game_window_contents)
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
end

function Mod:postUpdate()
    ---@type Object|false
    CURRENT_WINDOW_CONTENTS = false
    self.stage:update()
    CURRENT_WINDOW_CONTENTS = self.game_window_contents
end

function Mod:drawScreen(canvas)
    if not self.stage then return end -- TODO: Fix it so it doesn't call this while loading
    love.graphics.push()
    CURRENT_WINDOW_CONTENTS = false
    self.stage:draw()
    CURRENT_WINDOW_CONTENTS = self.game_window_contents
    love.graphics.pop()
    if (not Kristal.Config["systemCursor"]) and (Kristal.Config["alwaysShowCursor"] or MOUSE_VISIBLE or true) and love.window then
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