---@class Window: Component
---@field desktop Desktop
---@overload fun(contents,x?,y?):Window
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
    self.debug_select = false
end

function Window:getTitle()
    ---@diagnostic disable-next-line: undefined-field
    if self.contents.getTitle then return self.contents:getTitle() end
    return self.title
end

---@param parent Desktop|Window
function Window:onAdd(parent)
    if parent:includes(Desktop) then
        self.desktop = parent
    elseif parent.desktop then
        self.desktop = parent.desktop
    end
end

function Window:close()
    ---@diagnostic disable-next-line: undefined-field
    if self.contents.onClose and self.contents:onClose() then return end
    self:remove()
end

function Window:draw()
    Draw.setColor(COLORS.black)
    love.graphics.setLineWidth(8)
    love.graphics.rectangle("line", -2,-2,self.width+4,self.height+4)
    Draw.setColor({self.titlebar:getDrawColor()})
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", -2,-2,self.width+4,self.height+4)
    super.draw(self)
end

function Window:isWindowFocused()
    return self.desktop and self.desktop.focused_window == self
end

return Window