---@class Player : Player
local Player, super = Class("Player")

function Player:isMovementEnabled()
    return super.isMovementEnabled(self) and Mod.game_window:isWindowFocused()
end

return Player