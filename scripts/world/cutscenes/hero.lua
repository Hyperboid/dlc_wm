---@type table<string, fun(cutscene:WorldCutscene)>
-- <Protatanist>.do_your_thing?!?!!? LIKE-
local hero = {
    do_your_thing = function (cutscene)
        cutscene.world.player.visible = false
        local fakeplr = Character(cutscene.world.player.actor)
        cutscene:after(function ()
            fakeplr:remove()
            cutscene.world.player.visible = true
        end)
        Mod.stage:addChild(fakeplr)
        fakeplr:setScale(Mod.game_window_contents.scale_x * 2, Mod.game_window_contents.scale_y * 2)
        local x,y = cutscene.world.player:getScreenPos()
        fakeplr:setPosition(Mod.game_window_contents:getScreenPos())
        fakeplr.x = fakeplr.x + (x * Mod.game_window_contents.scale_x)
        fakeplr.y = fakeplr.y + (y * Mod.game_window_contents.scale_y)
        cutscene:walkToSpeed(fakeplr, fakeplr.x, love.graphics.getHeight() + fakeplr:getScaledHeight(),  2 * Mod.game_window_contents.scale_y)
        cutscene:wait(4)
        cutscene:text("* Wait what the hell?", "shock", "susie")
    end
}

return hero