---@class Titlebar: Component
local Titlebar, super = Class(Component)

---@param window
function Titlebar:init(window)
    super.init(self, FillSizing(), FixedSizing(34))
    self.window = window
    self:setPadding(6,2)
    self.drag_start_x, self.drag_start_y = Input.getMousePosition()
    self.dragging = false
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
        self:updateDragging(mx,my)
    end
    if Input.mousePressed(1) then
        if self:mouseHovered(mx,my) and true then
            self.drag_start_x, self.drag_start_y = self.window:getFullTransform():inverseTransformPoint(mx, my)
            self.dragging = true
        end
    end
    if Input.mouseReleased(1) then
        self.dragging = false
    end
end

return Titlebar