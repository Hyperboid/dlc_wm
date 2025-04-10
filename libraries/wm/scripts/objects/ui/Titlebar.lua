---@class Titlebar: Component
local Titlebar, super = Class(Component)

---@param window Window
function Titlebar:init(window)
    super.init(self, FillSizing(), FixedSizing(42))
    self.window = window
    self:setPadding(6,2)
    self.drag_start_x, self.drag_start_y = Input.getMousePosition()
    self.dragging = false
    self.close_button = Assets.getTexture("wm/x")
    self.close_button:setFilter("linear", "nearest")
end

function Titlebar:draw()
    love.graphics.rectangle("fill", 0,0,self.width, self.height)
    love.graphics.setFont(Assets.getFont("main"))
    local icon = self.window:getIcon()
    love.graphics.push()
    love.graphics.translate(6,(self.height-34)/2)

    if self.window.closable then
        Draw.setColor(Utils.hexToRgb("#670b20"))
    else
        Draw.setColor(Utils.hexToRgb("#808080"))
    end
    Draw.draw(self.close_button, self.width-(34+6),0, 0, 32/self.close_button:getWidth(), 32/self.close_button:getHeight())
    Draw.setColor(COLORS.white)

    if icon then
        Draw.draw(icon, 0,0,0, 32/icon:getWidth(), 32/icon:getHeight())
        love.graphics.translate(40,0)
    end
    Draw.setColor(COLORS.black)
    love.graphics.print(self.window:getTitle(), 0, 0)
    love.graphics.pop()
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

function Titlebar:mouseHovered(x,y)
    if not x or not y then
        local xa, ya = Input.getMousePosition()
        x = x or xa
        y = y or ya
    end
    x,y = self:getFullTransform():inverseTransformPoint(x,y)
    return x >= 0 and y >= 0 and x <= self.width and y <= self.height
end


function Titlebar:updateDragging(mx,my)
    self.window:setPosition(mx - self.drag_start_x, my - self.drag_start_y)
    self.window.y = math.min(math.max(self.window.y, 0), SCREEN_HEIGHT-34)
end

function Titlebar:update()
    super.update(self)
    local mx, my = Input.getMousePosition()
    if self.dragging then
        self:updateDragging(self.window.desktop:getFullTransform():inverseTransformPoint(mx,my))
    end
    if Input.mousePressed(1) then
        if self.window.desktop:isHovering(self, mx,my) then
            self.drag_start_x, self.drag_start_y = self.window:getFullTransform():inverseTransformPoint(mx, my)
            self.dragging = true
        end
    end
    if Input.mouseReleased(1) then
        self.dragging = false
    end
end

return Titlebar