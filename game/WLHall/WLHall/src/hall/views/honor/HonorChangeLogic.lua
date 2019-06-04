local HonorChangeView = require("hall.views.honor.HonorChangeView")

local M = {}

--[[
    * 描述：荣誉值变化（升降段，升降星）动画展示
    * 参数：curPrestige 当前荣誉值
    * 参数：oldPrestige 原来的荣誉值
    * 参数：showReduce 是否显示降级动画 默认为false
--]]
function M:showHonorChangeView(curPrestige, oldPrestige, showReduce)
	assert(curPrestige)
	assert(oldPrestige)
    showReduce = showReduce or false
    local canShow = M:_canShowView(curPrestige, oldPrestige, showReduce)
    if not canShow  then
        return nil
    end
    local view = M:_showView(curPrestige, oldPrestige)
    local oldgrade = gg.GetHonorGradeAndLevel(oldPrestige)
    local newgrade = gg.GetHonorGradeAndLevel(curPrestige)
    if newgrade > oldgrade and newgrade > 1 and gg.UserData:CanGetCurGradeHonoAward(newgrade) then
        -- 2018-07-24 界面弹出就直接请求领取接口
        M:_getReward(newgrade, oldgrade)
        -- 添加移除展示，弹出奖励提示界面
        view:setRemoveCallback(function()
            M:_showRewardView(newgrade)
        end)
    end

    return view
end

--------------------------- 华丽分割线 ---------------------------
function M:_getReward(newgrade, oldgrade)
    gg.Dapi:TaskAward(93, newgrade-1, oldgrade-1, function(data)
        if data.status == 0 then
            printf("领取奖励成功")
            --领取后设置为1
            gg.UserData:SetCurGradeHonoAward(newgrade, oldgrade)
        else
            printf("已领取任务奖励 ")
        end
    end)
end

function M:_showRewardView(newgrade)
    gg.HonorHelper:getHonorRewardCfg(function(rewardData)
        if rewardData[newgrade-1] and newgrade > 1 then
            GameApp:DoShell(nil, "GetRewardView://", rewardData[newgrade - 1])
        end
    end)
end

function M:_canShowView(curPrestige, oldPrestige, showReduce)
     --荣誉分降低或没改变不显示
    if curPrestige <= oldPrestige then
	    return false
    end

    local curLevel = gg.GetHonorLevel(curPrestige)
    local oldLevel = gg.GetHonorLevel(oldPrestige)
    --未升级不显示
    if curLevel == oldLevel then
        return false
    end

    --原来的荣誉值已经达到大师满级不显示
    if math.ceil(oldLevel/5) >= 6 and oldLevel%5 == 0 then
        return false
    end

    return true
end

function M:_showView(curPrestige, oldPrestige)
    local grade, star = gg.GetHonorGradeAndLevel(oldPrestige)
    local view = HonorChangeView:create(grade, star)
    	:addTo(GameApp:getRunningScene())
    --升星过程不能关闭
    view:setCanClose(false)

    local oldLevel = gg.GetHonorLevel(oldPrestige)
    local curLevel = gg.GetHonorLevel(curPrestige)
    local level = oldLevel+1
    local shengduan = false
    local function callback()
        if not shengduan and grade >= 6 and level%5 == 0 then
            --达到大师满级结束
            view:showShareBtn(function()
                gg.HonorHelper:doHonorShare()
            end)
            view:setCanClose(true)
            return
        end

    	if not shengduan and level%5 == 0 then
    		--满5颗星后升断
    		shengduan = true
            grade = grade + 1
    	    view:playShengDuanAni(grade, callback)
    	else
    		--能否升星
    		if level >= curLevel then
    			--不能升星就结束,动画全部结束后显示分享按钮并可关闭
    			view:showShareBtn(function()
    			    gg.HonorHelper:doHonorShare()
    			end)
    			view:setCanClose(true)
    	    	return
    		end
    		--升星
			shengduan = false
    		level = level + 1
    		local star = level % 5
    		if star == 0 then
    		    star = 5
    		end
    		view:playShengXingAni(star, callback)
    	end
    end
    --升星动画
    view:playShengXingAni(star+1, callback)

    return view
end

return M
