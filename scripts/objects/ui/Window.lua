---@class Window: Component
local Window, super = Class(Component)

---@param contents Object
---@param x number
---@param y number
function Window:init(contents, x,y)
    super.init(self, FitSizing(), FitSizing())
    self:setPosition(x,y)
    self:setLayout(VerticalLayout())
    self.titlebar = self:addChild(Titlebar(self))
    self.contents = self:addChild(contents)
    self.title = "???"
end

function Window:getTitle()
    ---@diagnostic disable-next-line: undefined-field
    if self.contents.getTitle then return self.contents:getTitle() end
    return self.title
end

function Window:close()
    ---@diagnostic disable-next-line: undefined-field
    if self.contents.onClose and self.contents:onClose() then return end
    self:remove()
end

function Window:getDebugRectangle()
    local rect = super.getDebugRectangle(self)
    if self.contents.game_screen then
        return {rect[1] - (self.x/self.scale_x), rect[2] - (self.y/self.scale_y), rect[3], rect[4]}
    end
    return rect
end

return Window