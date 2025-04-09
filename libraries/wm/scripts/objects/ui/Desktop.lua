---@class Desktop: Object
---@overload fun(): Desktop
local Desktop, super = Class(Object)

function Desktop:init(x,y)
    super.init(self, x, y)
end

function Desktop:update()
    super.update(self)
    self.height = love.graphics.getHeight() - 50
    self.width = love.graphics.getWidth()
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
function Desktop:spawnWindow(window)
    window:setParent(self)
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

return Desktop