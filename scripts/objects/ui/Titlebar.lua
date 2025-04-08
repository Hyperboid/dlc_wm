---@class Titlebar: Component
local Titlebar, super = Class(Component)

---@param window
function Titlebar:init(window)
    super.init(self, FillSizing(), FixedSizing(34))
    self.window = window
    self:setPadding(6,2)
    self.last_mouse_x, self.last_mouse_y = Input.getMousePosition()
end

function Titlebar:draw()
    love.graphics.rectangle("fill", 0,0,self.width, self.height)
    Draw.setColor(COLORS.black)
    love.graphics.setFont(Assets.getFont("main"))
    love.graphics.print(self.window:getTitle(), 6, 2)
    super.draw(self)
end

function Titlebar:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    if self.window:isWindowFocused() then
        return r, g, b, a
    else
        return r*.8, g*.8, b*.8, a
    end
end

function Titlebar:update()
    super.update(self)
    local mx, my = Input.getMousePosition()
    if Input.mouseDown(1) then
        if true then
            local dx, dy = mx - self.last_mouse_x, my - self.last_mouse_y
            self.window:move(dx, dy)
        end
    end
    self.last_mouse_x, self.last_mouse_y = mx, my
end

return Titlebar