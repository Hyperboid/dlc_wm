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

function CanvasContainer:getDebugRectangle()
    local rect = super.getDebugRectangle(self)
    if self.game_screen then
        return {rect[1] - (self.x/self.scale_x), rect[2] - (self.y/self.scale_y), rect[3], rect[4]}
    end
    return rect
end

return CanvasContainer