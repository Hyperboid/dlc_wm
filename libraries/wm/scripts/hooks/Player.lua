---@class Player : Player
local Player, super = Class("Player")

function Player:isMovementEnabled()
    if not super.isMovementEnabled(self) then return false end
    if self.stage == Game.stage then
        return WM.game_window:isWindowFocused()
    elseif WM.desktop.focused_window then
        return (self.stage == WM.desktop.focused_window.contents.contained_stage)
    end
    return false -- Not focusing ANY window
end

return Player