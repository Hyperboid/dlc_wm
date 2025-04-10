love.window.setTitle("DpWM")
function Mod:init()
    love.window.setTitle("DpWM")
    self.extra_windows = {}
    for i=1,10 do
        local canvas = love.graphics.newCanvas(320,240)
        local window = WM.desktop:spawnWindow(Window(CanvasContainer(canvas)), WM.game_window.x + WM.game_window.width + (16 * (i+1)), (16 * (i+1)))
        window.contents:setScale(WM.game_window.contents:getScale())
        local col_name = Utils.pick(Utils.getKeys(COLORS))
        window.title = col_name
        table.insert(self.extra_windows, window)
        Draw.pushCanvas(canvas)
        love.graphics.clear(COLORS[col_name])
        Draw.popCanvas()
    end
    WM.desktop:focusWindow(WM.game_window)
end

function Mod:preDraw()
    if pcall(function () assert(Game.world.map.data.properties.transparent) end) then
        love.graphics.clear()
    end
end


function Mod:onDPMbStart()
    local sw, sh = love.graphics.getDimensions()
    WM.game_window:slideTo((sw/2) - (WM.game_window:getScaledWidth()/2), (sh/2) - (WM.game_window:getScaledHeight()/2), .5, "out-quad")
    WM.game_window_contents.getTitle = function() return "" end
    WM.game_window_contents.getIcon = function() end
    self.prev_wallpaper = WM.wallpaper
    -- TODO: Unhardcode scale values
    self.wm_zoom = WM.stage.timer:tween(100, WM.desktop, {scale_x = 5, scale_y = 5})
    WM.wallpaper = nil
end

function Mod:onDPMbEnd()
    WM.wallpaper = self.prev_wallpaper
    self.prev_wallpaper = nil
    WM.game_window_contents.getTitle = nil
    WM.game_window_contents.getIcon = nil
    WM.stage.timer:cancel(self.wm_zoom)
    self.wm_zoom = nil
    WM.desktop:setScale(1)
end
