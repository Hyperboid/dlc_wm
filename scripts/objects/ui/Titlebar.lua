---@class Titlebar: Component
local Titlebar, super = Class(Component)

---@param window
function Titlebar:init(window)
    super.init(self, FillSizing(), FixedSizing(34))
    self.window = window
    self:setPadding(6,2)
end

function Titlebar:draw()
    Draw.setColor(COLORS.white)
    love.graphics.rectangle("fill", 0,0,self.width, self.height)
    Draw.setColor(COLORS.black)
    love.graphics.print(self.window:getTitle(), 6, 2)
    super.draw(self)
end

return Titlebar