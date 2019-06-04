--配置规则根据地区码 省市 标识拆分  例：吉林省
--表里面配置 最多9个推送游戏或合集  如合集加name标识 name为合集名字 合集内游戏数量无限制
-- 特殊id  0 赢话费 -1 添加游戏
--group 合集类别 1 扑克类  2 麻将类

local config =  {
	{ name = "斗地主合集" ,   { "ceshi" , "doun" , "tdak", "padk", "dbpy" } },  										-- ddzs 赢话费 、ddzh 斗地主 、 erdz 二人斗地主
    { name = "扑克馆", 		  { "xlch" , "ermj" } },						    			-- padk 跑得快
    { name = "麻将馆", 		  { "2dig" , "3dig" , "guiy" , "zymj" , "xlch","ccmj","shxi" } },					 	-- 2dig 二丁拐
    { name = "大厅主页" , 	  { "2dig" , "3dig" , "xlch" , "zymj" , "ccmj" } },			-- 3dig 三丁拐 、dzpk 德州扑克、zymj 遵义麻将、2dig 二丁拐、guiy 贵阳捉鸡  、doun 斗牛
    { name = "可添加的游戏" , {  } }
}														-- 包自定义添加游戏

return {
-- 北京市" id="11
	[11]={},
-- 天津市" id="12
	[12]={},
-- 河北省" id="13
	[13]={},
-- 山西省" id="14
	[14]={},
-- 内蒙古" id="15
	[15]={},
-- 黑龙江省" id="23
	[23]={},

    -- 哈尔滨市
    [2301]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "dzpk" , "doun" , "tdak", "padk", "dbpy", "sdyi" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjhb"} },
		{ name = "大厅主页" , 	  { "mjhb" , "sdyi" , "doun" , "dzpk" , "dbpy", "tdak" } },
		{ name = "可添加的游戏" , {  } }
	},
    -- 齐齐哈尔市
    [2302]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "dzpk" , "doun" , "tdak", "padk", "dbpy", "sdyi" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjhb", "mjqq" } },
		{ name = "大厅主页" , 	  { "mjqq" , "sdyi" , "doun" , "dzpk" , "dbpy", "tdak" } },
		{ name = "可添加的游戏" , {  } }
	},
    -- 大庆市
    [2306]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "dzpk" , "doun" , "tdak", "padk", "dbpy", "sdyi" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjhb", "mjdq"} },
		{ name = "大厅主页" , 	  { "mjdq" , "sdyi" , "doun" , "dzpk" , "dbpy", "tdak" } },
		{ name = "可添加的游戏" , {  } }
	},
    
	-- 辽宁 21
	[21] = {},
	-- 沈阳市
	[2101]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "scho" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjsy"} },
		{ name = "大厅主页" , 	  { "mjsy" , "scho" , "dbpy" , "doun" , "dzpk", "tdak" } },
		{ name = "可添加的游戏" , { "mjdl" , "mjas","mjtl","mjfs","mjbx","mjyk","mjjz","pjmj","mjly","mjdd","mjfx","mjcy","mjhl"} }
	},
	-- 大连市
	[2102]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjdl"} },
		{ name = "大厅主页" , 	  { "mjdl" , "dagz" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjas","mjtl","mjfs","mjbx","mjyk","mjjz","pjmj","mjly","mjdd","mjfx","mjcy","mjhl"} }
	},
	-- 鞍山市
	[2103]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjas",} },
		{ name = "大厅主页" , 	  { "mjas", "mjhc", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjfs","mjbx","mjyk","mjjz","pjmj","mjly","mjdd","mjfx","mjcy","mjhl"} }
	},

	-- 抚顺市
	[2104]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjfs"} },
		{ name = "大厅主页" , 	  { "mjfs", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjbx","mjyk","mjjz","pjmj","mjly","mjdd","mjfx","mjcy","mjhl"} }
	},

	-- 本溪市
	[2105]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjbx"} },
		{ name = "大厅主页" , 	  { "mjbx", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjyk","mjjz","pjmj","mjly","mjdd","mjfx","mjcy","mjhl"} }
	},

	-- 丹东市
	[2106]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjdd"} },
		{ name = "大厅主页" , 	  { "mjdd", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjyk","mjjz","pjmj","mjly","mjbx","mjfx","mjcy","mjhl"} }
	},

	-- 锦州市
	[2107]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjjz"} },
		{ name = "大厅主页" , 	  { "mjjz", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjyk","mjdd","pjmj","mjly","mjbx","mjfx","mjcy","mjhl"} }
	},

	-- 营口市
	[2108]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjyk"} },
		{ name = "大厅主页" , 	  { "mjyk", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjjz","mjdd","pjmj","mjly","mjbx","mjfx","mjcy","mjhl"} }
	},

	-- 阜新市
	[2109]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjfx"} },
		{ name = "大厅主页" , 	  { "mjfx", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjjz","mjdd","pjmj","mjly","mjbx","mjyk","mjcy","mjhl"} }
	},

	-- 辽阳市
	[2110]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjly"} },
		{ name = "大厅主页" , 	  { "mjly", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjjz","mjdd","pjmj","mjfx","mjbx","mjyk","mjcy","mjhl"} }
	},

	-- 盘锦市
	[2111]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "pjmj"} },
		{ name = "大厅主页" , 	  { "pjmj", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","mjtl","mjas","mjfs","mjjz","mjdd","mjly","mjfx","mjbx","mjyk","mjcy","mjhl"} }
	},

	-- 铁岭市
	[2112]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjtl"} },
		{ name = "大厅主页" , 	  { "mjtl", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","pjmj","mjas","mjfs","mjjz","mjdd","mjly","mjfx","mjbx","mjyk","mjcy","mjhl"} }
	},
	-- 朝阳市
	[2113]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjcy"} },
		{ name = "大厅主页" , 	  { "mjcy", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","pjmj","mjas","mjfs","mjjz","mjdd","mjly","mjfx","mjbx","mjyk","mjtl","mjhl"} }
	},

	-- 葫芦岛市
	[2114]={
		{ name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },
		{ name = "扑克馆", 		  { "ddzh" , "doun" , "tdak", "padk", "dbpy", "dagz" } },
		{ name = "麻将馆", 		  { "xlch" , "ermj", "mjhl"} },
		{ name = "大厅主页" , 	  { "mjhl", "padk" , "doun" , "dzpk" , "tdak" } },
		{ name = "可添加的游戏" , { "mjsy" , "mjdl","pjmj","mjas","mjfs","mjjz","mjdd","mjly","mjfx","mjbx","mjyk","mjtl","mjcy"} }
	},

-- 吉林省" id="22
    [2201]={

        { name = "斗地主合集" ,   { "ddzh" , "erdz" , "ddzs" } },  										-- ddzs 赢话费 、ddzh 斗地主 、 erdz 二人斗地主
        { name = "扑克馆", 		  { "padk" , "doun" , "dzpk" , "wake" } },								-- padk 跑得快
        { name = "麻将馆", 		  { "2dig" , "3dig" , "guiy" , "zymj" , "ncmj",  "xlch","mjzz","shxi"} },					 	-- 2dig 二丁拐
        { name = "大厅主页" , 	  { "2dig" , "3dig" , "symj" , "xlch" , "spmj", "ccmj" ,  "xlch" } },			-- 3dig 三丁拐 、dzpk 德州扑克、zymj 遵义麻将、2dig 二丁拐、guiy 贵阳捉鸡  、doun 斗牛
        { name = "可添加的游戏" , {  } }																-- 包自定义添加游戏
    },
    --长春市
    [5201]=config,
	[5202]=config,
	[5203]=config,
	[5204]=config,
	[5222]=config,
	[5223]=config,
	[5224]=config,
	[5226]=config,
	[5227]=config,
    [220112]={}, -- 双阳区 如果单独配置双阳区 则加区号代码
    [2202]={},--吉林市
    [2203]={},--四平市
    [2204]={},--辽源市
    [2205]={},--通化市
    [2206]={},--白山市
    [2207]={},--松原市
    [2208]={},--白城市
    [2224]={},--延边州
-- 辽宁省" id="21
	[21]={},
-- 上海市" id="31
	[31]={},
-- 江苏省" id="32
	[32]={},
-- 浙江省" id="33
	[33]={},
-- 安徽省" id="34
	[34]={},
-- 福建省" id="35
	[35]={},
-- 江西省" id="36
	[36]={},
-- 山东省" id="37
	[37]={},
-- 河南省" id="41
	[41]={},
-- 湖北省" id="42
	[42]={},

	-- 武汉
	[4201]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk" } },              				    --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" } },			   			--xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星
        { name = "大厅主页" , 	  { "whan","ka5x","xlch","gbmj","doun","dzpk" } }           --whan 武汉麻将 ka5x 卡五星 xlch 血流成河 gbmj 国标二人麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 黄石
	[4202]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk" } },              				    --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","hshi" } },			   	    --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 hshi 黄石麻将
        { name = "大厅主页" , 	  { "hshi","ka5x","xlch","gbmj","doun","dzpk" } }           --hshi 黄石麻将 ka5x 卡五星 xlch 血流成河 gbmj 国标二人麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 十堰
	[4203]={

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" } },              				   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" } },			   	           --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星
        { name = "大厅主页" , 	  { "ka5x","xlch" , "gbmj" , "doun", "dzpk","padk" } }         --ka5x 卡五星 xlch 血流成河 gbmj 国标二人麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },

    -- 宜昌
	[4205]={

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" } },              				   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" , "yich" } },			   	   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 yich 宜昌血流
        { name = "大厅主页" , 	  { "yich","ka5x" , "gbmj" , "doun", "dzpk","padk" } }         --yich 宜昌血流 xlch 血流成河 gbmj 国标二人麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },

    -- 襄阳
	[4206]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk" } },              				   	   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" } },			   	   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星
        { name = "大厅主页" , 	  { "ka5x","xlch","gbmj","doun","dzpk","padk" } }              --ka5x 卡五星 xlch 血流成河 gbmj 国标二人麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },

    -- 鄂州
	[4207]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk","5shk" } },              			   --dzpk 德州扑克 doun 牛牛 padk 跑得快 5shk 五十k
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","ezho" } },			   	   	   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 ezho 鄂州晃晃
        { name = "大厅主页" , 	  { "ezho","ka5x","xlch","5shk","doun","dzpk" } }              --ezho 鄂州晃晃 ka5x 卡五星 xlch 血流成河 5shk 五十k doun 牛牛 dzpk 德州扑克
    },

    -- 荆门
	[4208]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			   		   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","jmsk","jmen" } },			   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 jmsk 荆门双开 jmen 荆门晃晃
        { name = "大厅主页" , 	  { "jmsk","jmen","ka5x","xlch","doun","dzpk" } }              --jmsk 荆门双开 jmen 荆门晃晃 ka5x 卡五星 xlch 血流成河 doun 牛牛 dzpk 德州扑克
    },

    -- 孝感
	[4209]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			   		   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" } },			   			   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星
        { name = "大厅主页" , 	  { "ka5x","xlch","gbmj","doun","dzpk","padk" } }              --ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },

    -- 荆州
	[4210]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			   		   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","jzho" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 jzho 荆州晃晃
        { name = "大厅主页" , 	  { "jzho","ka5x","xlch","gbmj","doun","dzpk" } }              --jzho 荆州晃晃 ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 黄冈
	[4211]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			   		   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","hgan" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 hgan 黄冈麻将
        { name = "大厅主页" , 	  { "hgan","ka5x","xlch","gbmj","doun","dzpk" } }              --hgan 黄冈麻将 ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 咸宁
	[4212]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk","xndg" } },              			   --dzpk 德州扑克 doun 牛牛 padk 跑得快 xndg 咸宁打拱
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","xini" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 xini 咸宁晃晃
        { name = "大厅主页" , 	  { "xini","ka5x","xlch","xndg","doun","dzpk" } }              --xini 咸宁晃晃 ka5x 卡五星 xlch 血流成河 xndg 咸宁打拱 doun 牛牛 dzpk 德州扑克
    },

    -- 随州
	[4213]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			           --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x"} },			   		           --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星
        { name = "大厅主页" , 	  { "ka5x","xlch","gbmj","doun","dzpk","padk" } }              --ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },

    -- 恩施
	[4228]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },              			           --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","ensh"} },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 ensh 恩施麻将
        { name = "大厅主页" , 	  { "ensh","ka5x","xlch","gbmj","doun","dzpk" } }              --ensh 恩施麻将 ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 仙桃
	[429004]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk","xtqf" } },              			   --dzpk 德州扑克 doun 牛牛 padk 跑得快 xtqf 仙桃千分
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","xtao" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 xtao 仙桃赖晃
        { name = "大厅主页" , 	  { "xtao","ka5x","xlch","gbmj","doun","dzpk" } }              --xtao 仙桃赖晃 ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 潜江
	[429005]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk","qjqf" } },                           --dzpk 德州扑克 doun 牛牛 padk 跑得快 qjqf 潜江千分
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","qjhh" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 qjhh 潜江晃晃
        { name = "大厅主页" , 	  { "qjhh","ka5x","xlch","qjqf","doun","dzpk" } }              --qjhh 潜江晃晃 ka5x 卡五星 xlch 血流成河 qjqf 潜江千分 doun 牛牛 dzpk 德州扑克
    },

    -- 天门
	[429006]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk" } },                    	           --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x","tmhh" } },			   		   --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 tmhh 天门晃晃
        { name = "大厅主页" , 	  { "tmhh","ka5x","xlch","gbmj","doun","dzpk" } }              --tmhh 天门晃晃 ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克
    },

    -- 神农架
	[429021]={

        { name = "斗地主合集" ,   { "ddzh","erdz","ddzs" } },                                  --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk","doun","padk"} },                    	   		   --dzpk 德州扑克 doun 牛牛 padk 跑得快
        { name = "麻将馆", 		  { "xlch","gbmj","whan","ka5x" } },			   		       --xlch 血流成河 gbmj 国标麻将 whan 武汉麻将 ka5x 卡五星 tmhh 天门晃晃
        { name = "大厅主页" , 	  { "ka5x","xlch","gbmj","doun","dzpk","padk" } }              --ka5x 卡五星 xlch 血流成河 gbmj 国标麻将 doun 牛牛 dzpk 德州扑克 padk 跑得快
    },



-- 湖南省" id="43
	[43]={},
-- 广东省" id="44
	[44]={},
-- 广西省" id="45
	[45]={},
-- 海南省" id="46
	[46]={},
-- 重庆市" id="50
	[50]={},
-- 四川省" id="51
	[51]={},
-- 贵州省" id="52
	[52]={},
-- 云南省" id="53
	[53]={},
-- 西藏" id="54
	[54]={},
-- 陕西省" id="61
	--西安市
	[6101]={--shxi 陕西麻将 --> ???? 西安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--铜川市
	[6102]={--shxi 陕西麻将 --> ???? 西安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--宝鸡市
	[6103]={--shxi 陕西麻将 --> ???? 宝鸡麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","baoj","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "baoj" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--咸阳市
	[6104]={--shxi 陕西麻将 --> ???? 西安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--渭南市
	[6105]={--shxi 陕西麻将 --> ???? 渭南麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","wein","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "wein" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--延安市
	[6106]={--shxi 陕西麻将 --> ???? 划水麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","huas","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "huas" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--汉中市
	[6107]={--shxi 陕西麻将 --> ???? 西安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--榆林市
	[6108]={--shxi 陕西麻将 --> ???? 榆林麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","yuli","mjls","hozh","gzmj","ccmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "yuli" , "wake","hozh" , "padk" , "doun", "ccmj" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--安康市
	[6109]={--shxi 陕西麻将 --> ???? 西安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 ???? 两色麻将 ???? 推倒胡 ????锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },
	--商洛市
	[6110]={--shxi 陕西麻将 --> ???? 西+安麻将

        { name = "斗地主合集" ,   { "ddzh" , "erdz", "ddzs" } },                               --ddzh 斗地主 erdz 二人斗地主
        { name = "扑克馆", 		  { "dzpk" , "doun" , "padk" , "wake","sdai" } },             --dzpk 德州扑克 doun 牛牛 padk 跑得快 wake 陕西挖坑 ????三代
        { name = "麻将馆", 		  { "xlch","gbmj","shxi","mjls","hozh","gzmj"} },				           --xlch 血流成河 gbmj 国标麻将 shxi 陕西麻将 mjls 两色麻将 hozh 推倒胡 gzmj 锅子麻将
        { name = "大厅主页" , 	  { "shxi" , "wake","hozh" , "padk" , "doun", "xlch" } }     --shxi 陕西麻将 wake 陕西挖坑 ???? 推倒胡 padk 跑得快 doun 牛牛 xlch 血流成河

    },


-- GameName    ShortName
-- 渭南麻将    wein
-- 宝鸡麻将    baoj
-- 划水麻将    yana ?huas
-- 榆林麻将    yuli

-- 程序-蒋明宽 2017/4/18 16:02:10
-- GameName    ShortName
-- 两色麻将    mjls
-- 锅子麻将    gzmj
-- 红中麻将    hozh

-- 程序-蒋明宽 2017/4/18 16:02:59
-- GameName    ShortName
-- 血流成河    xlch









-- 甘肃省" id="62
	[62]={},
-- 青海省" id="63
	[63]={},
-- 宁夏" id="64
	[64]={},
-- 新疆" id="65
	[65]={},
-- 台湾" id="71
	[71]={},
-- 香港" id="81
	[81]={},
-- 澳门" id="82
	[82]={},
}
