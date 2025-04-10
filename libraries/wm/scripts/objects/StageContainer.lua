---@class StageContainer: Object
---@overload fun(canvas, x?, y?) : StageContainer
local StageContainer, super = Class(Object)

---@param stage Stage
function StageContainer:init(stage, x,y)
    super.init(self, x, y)
    self.contained_stage = stage
    self:setSize(stage:getScaledSize())
    if self.width == 0 or self.height == 0 then
        self:setSize(640,480)
    end
    self.game_screen = (stage == Game.stage)
end

function StageContainer:drawMask()
    love.graphics.rectangle("fill", 0,0,self.width, self.height)
end

function StageContainer:draw()
    local w_contents = CURRENT_WINDOW_CONTENTS
    local w, h = SCREEN_WIDTH, SCREEN_HEIGHT
    SCREEN_WIDTH, SCREEN_HEIGHT = self:getSize()
    CURRENT_WINDOW_CONTENTS = self
    local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    super.draw(self)
    self.contained_stage:draw()
    Draw.popCanvas()
    Draw.draw(canvas)
    SCREEN_WIDTH, SCREEN_HEIGHT = w,h
    CURRENT_WINDOW_CONTENTS = w_contents
end

return StageContainer