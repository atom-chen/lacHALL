-- 审核模式和内网测试游戏配置
return {
    -- 审核模式配置
    review_cfg = {
        mini = {main = {}, add = {}},
        mj = {main = {32, 225, 229, 57, 212, 200, 190, 126}, add = {}},
        pk = {main = {1, 29, 52}, add = {}},
    },

    -- 默认配置
    default_cfg = {
        mini = {main = {}, add = {}},
        mj = {main = {32, 225}, add = {}},
        pk = {main = {1, 29, 52, 25, 3, 257, 258}, add = {}},
    },
}
