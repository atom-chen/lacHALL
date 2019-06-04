
-- Author: zhaoxinyu
-- Date: 2016-09-12 15:25:20
-- Describe：道具定义

-- name：道具名称
-- des：道具描述
-- source：道具来源
-- icon：道具图标路径
-- ui：道具对应的UI文件路径
-- event：按钮对应的事件，UI控件必须放到img_bg节点下，按钮Tag从1000开始（包含1000），按照顺序和event事件对应。
-- unit：描述道具个数的单位，不配置默认为个。
-- proportion：个数换算比例，0.1表示10 等于 1个 ， 0.5表示 2 个等于 1 个
-- reviewshow：审核是否显示，不配置审核显示
-- zeroshow：0数量显示
-- sort：排序（越大越优先）
-- develop：功能尚未完成，敬请期待

-- 命令功能
-- //OpenHF：打开话费兑换界面
-- EVENT_HB_EXCH：为消息通知，注册对应的配置消息即可出发点击事件

return {

    [PROP_ID_LOTTERY] = { name = "礼品券" , -- 2018.03.12 元宝 改为 礼品券
                           des = "可以兑换实物奖品，还可以参与抽奖。" ,
                        source = "礼品券只能通过完成游戏任务获得，\n不参与游戏结算。" ,
                          icon = "common/prop/img_prop_yuanbao.png" ,
                        icon_s = "hall/common/prop_lpq_s.png",
                        icon_l = "hall/store/img_icon_16.png",
                            ui = "ui/bag/prop_ui/hbk_info_node.lua" ,
                         event = { "//OpenExchange:兑换", "//OpenYBCJ:抽奖" } ,
                          sort = 99 ,
                    reviewshow = false ,
                      zeroshow = true },

    [PROP_ID_ROOM_CARD] = { name = "房间卡" ,
                           des = "朋友场开房间使用，邀请好友同桌\n游戏" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/img_prop_roomcard.png" ,
                            ui = "ui/bag/prop_ui/room_card_info_node.lua" ,
                         event = { "//OpenMall:购买" } ,
                          unit = "张" ,
                          sort = 89 ,
                      zeroshow = true    } ,

 [PROP_ID_PHONE_CARD] = { name = "话费券" ,
                           des = "累计到一定金额后，即可兑换。\n还可以参与抽奖。" ,
                        source = "任务中获得" ,
                          icon = "common/prop/ing_prop_huafei_ka.png" ,
                        icon_s = "hall/common/prop_hfq_s.png",
                        icon_l = "hall/store/img_icon_251.png",
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenHF:兑换话费" } ,
                          unit = "元" ,
                          sort = 79 ,
                    proportion = 0.01 ,
                    reviewshow = false ,
                    zeroshow = true },

        [PROP_ID_261] = { name = "红包券" ,
                           des = "累计到一定金额后，可领取到您的微\n信。还可以兑换豆豆或参与抽奖。" ,
                        source = "任务中获得" ,
                          icon = "common/prop/imt_prop_redcard_pt.png" ,
                        icon_s = "hall/common/prop_hbq_s.png",
                        icon_l = "hall/store/img_icon_261.png",
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenHB:领取到微信" } ,
                          unit = "元" ,
                          sort = 78 ,
                    proportion = 0.01 ,
                    reviewshow = true ,
                    zeroshow = true },

        [PROP_ID_263] = { name = "即时话费券" ,
                           des = "可随时兑换话费，无需累计金额" ,
                        source = "购买礼包获得" ,
                          icon = "common/prop/cellcard_js.png" ,
                        icon_s = "hall/common/prop_jshfq_s.png",
                        icon_l = "hall/store/img_icon_263.png",
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenJSHF:兑换话费" } ,
                          unit = "元" ,
                          sort = 69 ,
                    proportion = 0.01 ,
                    reviewshow = false ,
                    zeroshow = false },

        [PROP_ID_262] = { name = "即时红包(随时领取)" ,
                           des = "可随时领取到您的微信" ,
                        source = "任务中获得" ,
                          icon = "common/prop/Redcard_js.png" ,
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenJSHB:领取到微信" } ,
                          unit = "元" ,
                          sort = 68 ,
                    proportion = 0.01 ,
                    reviewshow = false ,
                    zeroshow = false },

    -- 2018.03.12 新增道具 begin
    [PROP_ID_JIPAI] = { name = "记牌器" ,
                         des = "在三人斗地主中开启记牌功能，使\n用后开启计时。",
                      source = "可通过【商城】购买获得" ,
                        icon = "common/prop/img_prop_jipai.png" ,
                          ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                       event = { "//OpenMall:购买", "//UserJiPaiAllProp:使用" } ,
                        unit = "天" ,
                        sort = 60 ,
                    zeroshow = false },

[PROP_ID_HAIDILAOYUE] = { name = "海底捞月卡" ,
                           des = "在麻将游戏中使用海底捞月功能。" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/img_prop_haidi.png" ,
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenMall:购买" } ,
                          unit = "张" ,
                          sort = 59 ,
                      zeroshow = false },

    [PROP_ID_GAIMING] = { name = "改名卡" ,
                           des = "修改昵称（微信用户不能使用）。" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/img_prop_gaiming.png" ,
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenMall:购买" } ,
                          unit = "张" ,
                          sort = 58 ,
                      zeroshow = false },

     [PROP_ID_CANSAI] = { name = "参赛券" ,
                           des = "可以用于斗地主比赛报名，不同\n场次需要数量不同。" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/img_prop_match.png" ,
                        icon_s = "hall/common/prop_csq_s.png",
                        icon_l = "hall/store/img_icon_404.png",
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenMall:购买" } ,
                          unit = "张" ,
                          sort = 57 ,
                      zeroshow = false },

   [PROP_ID_LEITAIKA] = { name = "荣誉卡" ,
                           des = "使用后获得10荣誉分和10排位分。" ,
                        source = "可通过购买【VIP特权礼包】获得" ,
                          icon = "common/prop/img_prop_leitai.png" ,
                            ui = "ui/bag/prop_ui/hbk_info_node.lua" ,
                         event = { "//UseProp:使用", "//UseAllProp:使用全部" },
                          unit = "张" ,
                          sort = 56 ,
                      zeroshow = false },
  -- 2018.03.12 新增道具 end

  -- 2018-07-10 新增翻倍卡道具
   [PROP_ID_FANBEIKA] = { name = "翻倍卡" ,
                           des = "在游戏中赢得豆豆翻倍。" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/img_prop_fanbei.png" ,
                        icon_s = "hall/common/prop_fbk_s.png",
                        icon_l = "hall/store/img_icon_406.png",
                            ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                         event = { "//OpenMall:购买" },
                          unit = "张" ,
                          sort = 55 ,
                      zeroshow = true,
                       develop = true },

  -- 2018-09-19 新增录制资格券道具
 [PROP_ID_TV_TICKETS] = { name = "录制资格券" ,
                           des = "有概率获得电视台录制邀请。" ,
                        source = "参加电视赛有机会获得" ,
                          icon = "common/prop/img_prop_407.png" ,
                          unit = "张" ,
                          sort = 54 ,
                      zeroshow = false },                     

[PROP_ID_LOTTERY_CARD] = { name = "抽奖卡" ,
                           des = "消耗抽奖卡参与每日抽奖" ,
                        source = "通过完成游戏局数任务获得" ,
                          icon = "common/prop/img_prop_lotterycard.png" ,
                          ui = "ui/bag/prop_ui/hf_info_node.lua" ,
                          event = { "//OpenCJ:抽奖" } ,
                          unit = "张" ,
                      zeroshow = false    } ,

   [PROP_ID_LIAN_PEN] = { name = "脸盆" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_1.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

    [PROP_ID_CHUI_ZI] = { name = "锤子" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_2.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

    [PROP_ID_FAN_QIE] = { name = "番茄" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_3.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

     [PROP_ID_MAO_BI] = { name = "毛笔" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_11.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

   [PROP_ID_ZUI_CHUN] = { name = "嘴唇" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_16.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

         [PROP_ID_XO] = { name = "人头马" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_10.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

     [PROP_ID_PEN_QI] = { name = "喷漆" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_15.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

[PROP_ID_KOU_XIANG_TANG] = { name = "匹萨" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_12.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

      [PROP_ID_QIANG] = { name = "枪" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_13.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

   [PROP_ID_HONG_BAO] = { name = "招财纳福" ,
                           des = "魔法道具,可在游戏中使用" ,
                        source = "可通过【商城】购买获得" ,
                          icon = "common/prop/item_8.png" ,
                          unit = "个" ,
                      zeroshow = false    } ,

      [PROP_ID_MONEY] = { name = BEAN_NAME ,
                          icon = "common/prop/jindou_1.png" , } ,
    [PROP_ID_XZMONEY] = { name = "钻石" ,
                          icon = "common/prop/zuanshi_1.png" , } ,

}
