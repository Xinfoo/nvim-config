return {
    "nvim-mini/mini.surround",
    version = false,
    -- 保留插件默认键位；这里只声明懒加载触发键，实际映射由 setup 创建。
    -- sa 支持普通和可视模式，其余为普通模式；无需 Leader。
    keys = {
        { "sa", mode = { "n", "x" }, desc = "添加包围符号" },
        { "sd", desc = "删除包围符号" },
        { "sf", desc = "向右查找包围符号" },
        { "sF", desc = "向左查找包围符号" },
        { "sh", desc = "高亮包围符号" },
        { "sr", desc = "替换包围符号" },
    },
    opts = {},
}
