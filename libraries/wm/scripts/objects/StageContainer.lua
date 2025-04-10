---@class StageContainer: Object
---@overload fun(canvas, x?, y?) : StageContainer
local StageContainer, super = Class(Object)

---@param stage Stage
function StageContainer:init(stage, x,y)
    super.init(self, x, y)
    stage = stage or Stage(0,0,640,480)
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

function StageContainer:update()
    local w_contents = CURRENT_WINDOW_CONTENTS
    local w, h = SCREEN_WIDTH, SCREEN_HEIGHT
    SCREEN_WIDTH, SCREEN_HEIGHT = self:getSize()
    CURRENT_WINDOW_CONTENTS = self
    super.update(self)
    self.contained_stage:update()

    -- TODO: fix this shit
    if self.parent:isWindowFocused() then
        for key, value in pairs(Input.key_pressed) do
            if self.contained_stage.children[#self.contained_stage.children].onKeyPressed then
                if value then
                    self.contained_stage.children[#self.contained_stage.children]:onKeyPressed(key)
                end
            end
        end
    end

    SCREEN_WIDTH, SCREEN_HEIGHT = w,h
    CURRENT_WINDOW_CONTENTS = w_contents
end

return StageContainer