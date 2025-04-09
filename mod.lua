love.window.setTitle("DpWM")
function Mod:init()
    love.window.setTitle("DpWM")
    self.extra_windows = {}
    self.v_desktop = Desktop()
    self.v_desktop_window = WM.desktop:spawnWindow(Window(self.v_desktop), 100, 100)
    self.v_desktop:setSize(1000,1000)
    for i=1,10 do
        local canvas = love.graphics.newCanvas(320,240)
        local window = self.v_desktop:spawnWindow(Window(CanvasContainer(canvas)), (16 * (i+1)), (16 * (i+1)))
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
