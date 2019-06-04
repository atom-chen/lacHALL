-- Author: lee
-- Date: 2017-06-30 19:12:42
local M = {}

function M:cleanup()

end

function M:pullLottoData(lottoType, callback)
    gg.Dapi:NewLotterLoad(lottoType, function(cb)
        cb = checktable(cb)
        if cb.status == 0 then
            self.surplus = cb.count
            local totalCnt = checkint(cb.total)
            local awardTb = cb.data
            local showMsg = tostring(cb.show_msg)
            local rateTb = cb.probability
            local expendTb = cb.expend
            callback(awardTb, totalCnt, showMsg, rateTb, self.surplus, nil, expendTb)
        else
            local errMsg = cb.msg or "抽奖数据获取失败，请关闭页面重试"
            callback(nil, nil, nil, nil, nil, errMsg)
        end
	end)
end

function M:doLottery(lottoType, expendProp, expendCnt, callback)
	if not self.surplus or checkint(self.surplus) > 0 then
        gg.Dapi:NewLotterIndex(lottoType, expendProp, expendCnt, function(cb)
            if checktable(cb).status == 0 and self.surplus and self.surplus > 0 then
                self.surplus = self.surplus - 1
            end
            callback(cb, tostring(cb.show_msg), self.surplus)
        end)
    else
        callback({status = -2, msg = "本日抽奖次数已用完,请明日再来。"}, self.surplus)
    end
end

return M
