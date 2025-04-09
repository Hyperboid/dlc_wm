---@class Desktop: Object
local Desktop, super = Class(Object)

function Desktop:init(x,y)
    super.init(self, x, y)
end

function Desktop:update()
    super.update(self)
    self.height = love.graphics.getHeight() - 50
    self.width = love.graphics.getWidth()
end

function Desktop:draw()
    if WM.wallpaper then
        love.graphics.push()
        local w,h = WM.wallpaper:getDimensions()
        love.graphics.draw(WM.wallpaper, 0,0,0, love.graphics.getWidth()/w, love.graphics.getHeight()/h)
        love.graphics.pop()
    end
    love.graphics.setPointSize(10)
    love.graphics.points(love.mouse.getPosition())
    super.draw(self)
end

return Desktop