love.window.setTitle("DpWM")
function Mod:init()
    love.window.setTitle("DpWM")
    self.extra_windows = {}
    for i=1,10 do
        local canvas = love.graphics.newCanvas(320,240)
        local window = WM.desktop:spawnWindow(Window(CanvasContainer(canvas)), WM.game_window.x + WM.game_window.width + (16 * (i+1)), (16 * (i+1)))
        window.contents:setScale(WM.game_window.contents:getScale())
        local col_name = Utils.pick(Utils.getKeys(COLORS))
        window.contents.getTitle = function() return col_name end
        table.insert(self.extra_windows, window)
        Draw.pushCanvas(canvas)
        love.graphics.clear(COLORS[col_name])
        Draw.popCanvas()
    end
    WM.desktop:focusWindow(WM.game_window)
end
