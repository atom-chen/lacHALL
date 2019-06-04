--
-- Author: Your Name
-- Date: 2016-09-19 17:57:54
--

local M = display
local director=cc.Director:getInstance()

function M.pushScene(scene)
   director:pushScene(scene)
end
