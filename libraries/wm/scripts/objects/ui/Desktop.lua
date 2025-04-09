---@class Desktop: Object
---@overload fun(): Desktop
local Desktop, super = Class(Object)

function Desktop:init(x,y)
    super.init(self, x, y)
end

function Desktop:update()
    super.update(self)
    if self.parent:includes(Stage) then
        self.height = love.graphics.getHeight() - 50
        self.width = love.graphics.getWidth()
    end
    if Input.mousePressed(1) then
        self:focusWindow(self:getHoveredWindow())
    end
end

function Desktop:drawWallpaper()
    if WM.wallpaper then
        love.graphics.push()
        local w,h = WM.wallpaper:getDimensions()
        love.graphics.draw(WM.wallpaper, 0,0,0, love.graphics.getWidth()/w, love.graphics.getHeight()/h)
        love.graphics.pop()
    end
end

---@generic T: Window
---@param window T
---@return T window
function Desktop:spawnWindow(window, x,y)
    window:setParent(self)
    if x or y then
        window:setPosition(x,y)
    end
    self:focusWindow(window)
    return window
end

function Desktop:focusWindow(window)
    self.focused_window = window
    if not window then return end
    window.layer = 10000
    self:sortChildren()
    window.layer = 0
end

function Desktop:draw()
    self:drawWallpaper()
    super.draw(self)
end

---@param parent Object
---@param child Object
---@return boolean
local function is_parented_to(parent, child)
    if parent == child.parent then return true
    elseif child.parent then return is_parented_to(parent, child.parent)
    else return false end
end

function Desktop:getHoveredWindow(x,y)
    if not x or not y then
        local xa, ya = love.mouse.getPosition()
        x = x or xa
        y = y or ya
    end
    for i = #self.children, 1, -1 do
        local window = self.children[i]
        local mx, my = x,y
        mx,my = window:getFullTransform():inverseTransformPoint(x,y)
        if window ~= WM.game_window then
            -- TODO: Find out why game window doesn't need this
        end
        if mx >= 0 and my >= 0 and mx <= window.width and my <= window.height then
            return window
        end
    end
end

---@param object Object
---@param x number
---@param y number
function Desktop:isHovering(object, x,y)
    if not x or not y then
        local xa, ya = love.mouse.getPosition()
        x = x or xa
        y = y or ya
    end
    if not is_parented_to(self:getHoveredWindow(x,y), object) then return false end

    x,y = object:getFullTransform():inverseTransformPoint(x,y)
    
    return x >= 0 and y >= 0 and x <= object.width and y <= object.height
end


return Desktop