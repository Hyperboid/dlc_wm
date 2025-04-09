---@class CanvasContainer: Object
---@overload fun(canvas, x?, y?) : CanvasContainer
local CanvasContainer, super = Class(Object)

---@param canvas love.Canvas
function CanvasContainer:init(canvas, x,y)
    super.init(self, x, y)
    self.canvas = canvas
    self:setSize(canvas:getDimensions())
    self.game_screen = (canvas == SCREEN_CANVAS)
end

function CanvasContainer:draw()
    super.draw(self)
    Draw.draw(self.canvas)
end

return CanvasContainer