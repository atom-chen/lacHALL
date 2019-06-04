
-- Author: zhaoxinyu
-- Date: 2016-11-06 13:15:20
-- Describe：上传头像界面

local UploadAvatar = class("UploadAvatar", cc.load("ViewPop"))

UploadAvatar.RESOURCE_FILENAME = "ui/person_info/upload_avatar_node.lua"
UploadAvatar.RESOURCE_BINDING = {
	["Panel_close"]         = { ["varname"] = "Panel_close" ,["events"]={{event="click",method="onClickClose"}} },                                   -- 背景
	["btn_photograph"]   = { ["varname"] = "btn_photograph" ,["events"]={{event="click",method="onClickPhotograph"}} },                  -- 拍照
	["btn_album"]        = { ["varname"] = "btn_album" ,["events"]={{event="click",method="onClickAlbum"}} },                                 -- 相册
	-- ["btn_wx"]           = { ["varname"] = "btn_wx" ,["events"]={{event="click",method="onClickWx"}} },  --微信同步



}

function UploadAvatar:onCreate( ... )

end
--[[
* @brief 关闭点击事件
]]
function UploadAvatar:onClickClose( sender )

	self:removeSelf()
end

local function douploadimg_(selmethod,allowedit)	

	device.callImagePicker(selmethod,function(imgfullpath) 		

		gg.InvokeFuncNextFrame( function()

			if imgfullpath and string.len(imgfullpath)>0 then
				printf("uploadfile :"..imgfullpath)
				GameApp:dispatchEvent(gg.Event.SHOW_LOADING,"正在上传头像，请稍后...")
				gg.Dapi:UploadAvatar(imgfullpath,function (result)
					print( result.msg )
					GameApp:dispatchEvent(gg.Event.SHOW_LOADING)
					GameApp:dispatchEvent(gg.Event.SHOW_TOAST,tostring(result.msg))
				end)
			else
				printf("cancel select image----")
			end
			printf("UploadAvatar:onClickPhotograph-----")
		 end) 

	end,allowedit)
end 

--[[
* @brief 拍照点击事件
]]
function UploadAvatar:onClickPhotograph( sender )
	self:removeSelf()
	douploadimg_("camera",true)
 
end

--[[
* @brief 相册点击事件
]]
function UploadAvatar:onClickAlbum( sender )
	self:removeSelf()
	douploadimg_("library",true)
end

--[[
* @brief 微信同步点击事件
]]
function UploadAvatar:onClickWx( sender )
	self:removeSelf()
end


return UploadAvatar