---@type table<string, fun(cutscene:WorldCutscene)>
local _talk = {
    main = function (cutscene)
        cutscene:text("* Your voice echoes aimlessly.")
    end
}

return _talk