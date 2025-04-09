love.window.setTitle("DpWM")
function Mod:init()
    love.window.setTitle("DpWM")
    self.j_canvas = love.graphics.newCanvas(320,240)
    self.j_window = WM.desktop:spawnWindow(Window(CanvasContainer(self.j_canvas)), WM.game_window.x + WM.game_window.width + 32, 32)
    self.j_window.contents:setScale(WM.game_window.contents:getScale())
    self.j_window.contents.getTitle = function() return "Another Program" end
    Draw.pushCanvas(self.j_canvas)
    love.graphics.clear(0,1,0,1)
    Draw.popCanvas()
    WM.desktop:focusWindow(WM.game_window)
end
