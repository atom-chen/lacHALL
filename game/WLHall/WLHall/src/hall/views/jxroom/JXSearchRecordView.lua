
-- Author:Cai
-- Date:2018-08-27
-- Descrlibe:查看他人战绩

local viewBase = import("..room/RecordInputLayer")
local M = class("JXSearchRecordView", viewBase)

M.RESOURCE_FILENAME = "ui/recordstatistics/jx_search_record_view.lua"
M.RESOURCE_BINDING = {
    ["lay_touch"] = {["varname"] = "lay_touch"},
    ["search_bg"] = {["varname"] = "search_bg"},
    ["tf_bg"]     = {["varname"] = "tf_bg"    },
    ["btn_search"]= {["varname"] = "btn_search", ["events"] = {{["event"] = "click", ["method"] = "onClickSearch"}}},
}

return M