Registry.registerGlobal("CURRENT_WINDOW", false)

function Mod:getGameScale()
    return self.game_window.scale_x
end

function Mod:postInit()
    -- Need to set this late so that the overworld camera doesn't get messed up
    -- (It's okay if the battle camera does)
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    SCREEN_WIDTH, SCREEN_HEIGHT = SCREEN_WIDTH, SCREEN_HEIGHT
end
love.window.setTitle("DpWM")
function Mod:init()
    love.window.setTitle("DpWM")
    print("Loaded "..self.info.name.."!")
    self.stage = Stage(0,0, love.graphics.getDimensions())
    self.game_window = CanvasContainer(SCREEN_CANVAS)
    self.stage:addChild(self.game_window)
    Utils.hook(Input, "getMousePosition", function(orig, x, y, relative)
        x = x or love.mouse.getX()
        y = y or love.mouse.getY()
        if CURRENT_WINDOW then
            local off_x, off_y = CURRENT_WINDOW:getScreenPos()
            -- off_x, off_y = off_x * 2, off_y * 2
            return ((x-off_x)/self:getGameScale()),((y - off_y)/self:getGameScale())
        end
        local off_x, off_y = Kristal.getSideOffsets()
        local floor = math.floor
        if relative then
            floor = Utils.round
            off_x, off_y = 0, 0
        end
        return floor((x - off_x) / Kristal.getGameScale()),
               floor((y - off_y) / Kristal.getGameScale())
    end)
    Utils.hook(DebugSystem, "getStage", function (orig, dbg, ...)
        if DEBUG_RENDER then
        return self.stage end
        return orig(dbg,...)
    end)
end

function Mod:postUpdate()
    ---@type Object|false
    CURRENT_WINDOW = false
    self.stage:update()
    -- SCREEN_WIDTH, SCREEN_HEIGHT = 640, 480
    CURRENT_WINDOW = self.game_window
end

function Mod:drawScreen(canvas)
    if not self.stage then return end -- TODO: Fix it so it doesn't call this while loading
    love.graphics.push()
    -- love.graphics.scale(self:getGameScale())
    -- Draw.draw(canvas)
    CURRENT_WINDOW = false
    self.stage:draw()
    CURRENT_WINDOW = self.game_window
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