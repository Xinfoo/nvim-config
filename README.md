# Neovim Config

> 注意：这是我的个人 Neovim 配置，不是面向所有人的通用发行版。其中包含一些带有个人环境假设的设置，尤其是
> `lua/config/proxy.lua` 里的本机代理配置。如果你的代理地址不是 `http://127.0.0.1:7897`，或者你不需要代理，
> 请先修改或禁用它，再进行插件安装。

一份偏日常开发使用的 Neovim 配置。整体思路是保持轻量、清晰、可继续扩展：用
`lazy.nvim` 管理插件，围绕文件检索、项目浏览、Git、LSP、补全和诊断搭出一个顺手的编辑环境。

## 特性

- 基于 `lazy.nvim` 的插件管理，首次启动会自动安装插件管理器；插件通过 `event` / `cmd` / `keys` 懒加载。
- 使用 `tokyonight.nvim` 作为默认主题，`alpha-nvim` 提供启动页。
- `lualine.nvim` 状态栏和 `bufferline.nvim` 标签页增强。
- `neo-tree.nvim` 文件树，适合快速浏览项目结构。
- `telescope.nvim` 提供文件查找、全文搜索、Buffer、帮助文档、最近文件、命令和快捷键检索。
- `nvim-treesitter`（main 分支）提供语法高亮，共安装 24 个 parser，包含 C/C++、Lua、CMake 等常用语言。
- `mason.nvim` + `mason-lspconfig.nvim` 管理 LSP：`lua_ls`、`clangd`、`jdtls`、`bashls`、`neocmake`（CMake）。
- `blink.cmp` 提供 LSP、路径、片段和 Buffer 补全。
- `trouble.nvim` 提供诊断、符号、LSP 引用以及 quickfix/loclist 列表。
- `gitsigns.nvim` 显示 Git 行级变更，`diffview.nvim` 查看差异与文件历史，`lazygit.nvim` 提供 Git TUI。
- `toggleterm.nvim` 提供浮动终端。
- `mini.pairs` 自动配对括号和引号，`mini.surround` 使用默认快捷键添加、删除、替换和查找包围符号。
- `which-key.nvim` 提供按键提示，`<leader>?` 可查看当前 Buffer 的快捷键。
- 包含 Neovide 的 GUI 字体、透明度和主题配置。

## 环境依赖

建议先安装下面这些工具：

- Neovim **0.12 或更高**（`nvim-treesitter` 使用 main 分支 API，不再兼容旧版）
- Git
- ripgrep、fd（Telescope 的全文搜索与文件查找）
- wl-clipboard（系统剪贴板，配合 `clipboard=unnamedplus`）
- Node.js / npm（部分 Mason 安装的 LSP 依赖）
- `tree-sitter-cli` 0.26.1 或更高（需要来自包管理器或 cargo，不要用 npm 版本）
- make 和 C 编译器，用于编译 treesitter parser 以及 `telescope-fzf-native.nvim`
- Nerd Font，可选但推荐，用于正常显示图标
- Lua 5.1 / LuaRocks，可选，只有用到依赖 LuaRocks 的工具时才需要

如果发行版仓库里的 Neovim 版本低于 0.12，或者没有 `tree-sitter-cli`，可以用 AppImage、源码安装 Neovim，
并用 `cargo install tree-sitter-cli` 安装 CLI。

### Arch Linux

```sh
sudo pacman -S neovim git ripgrep fd wl-clipboard npm base-devel tree-sitter-cli
```

### Ubuntu / Debian

```sh
sudo apt update
sudo apt install neovim git ripgrep fd-find wl-clipboard nodejs npm build-essential
```

Debian/Ubuntu 的 `fd` 命令通常叫 `fdfind`。如果 Telescope 找不到 `fd`，可以手动创建一个用户级软链接：

```sh
mkdir -p ~/.local/bin
ln -s "$(command -v fdfind)" ~/.local/bin/fd
```

### Fedora / RHEL

```sh
sudo dnf install neovim git ripgrep fd-find wl-clipboard nodejs npm make gcc gcc-c++
```

RHEL 系发行版如果默认仓库里缺少较新的 Neovim 或部分工具，可能需要先启用 EPEL、COPR 或使用官方 AppImage/源码安装。

如果使用 Java LSP，系统里还需要可用的 JDK。

## 安装

先备份已有配置：

```sh
mv ~/.config/nvim ~/.config/nvim.bak
```

然后把本仓库克隆到 Neovim 配置目录：

```sh
git clone <this-repo-url> ~/.config/nvim
```

启动 Neovim：

```sh
nvim
```

第一次启动时，`lazy.nvim` 会自动拉取插件；`nvim-treesitter` 会按配置自动安装 parser（需要可用的
`tree-sitter-cli`）。Mason 会确保安装这些 LSP：

- `lua_ls`
- `clangd`
- `jdtls`
- `bashls`
- `neocmake`（CMake LSP，Mason 包名为 `neocmakelsp`）

## 快捷键

Leader 键是空格，Local Leader 是反斜杠 `\`。

### 基础操作

| 快捷键 | 功能 |
| --- | --- |
| `<leader>w` | 保存当前文件 |
| `<leader>q` | 关闭当前窗口 |
| `<leader>Q` | 退出 Neovim |
| `<leader>h` | 清除搜索高亮 |
| `<leader>?` | 查看当前 Buffer 的快捷键（which-key） |

### 窗口与 Buffer

| 快捷键 | 功能 |
| --- | --- |
| `<C-h>` | 切换到左侧窗口 |
| `<C-j>` | 切换到下方窗口 |
| `<C-k>` | 切换到上方窗口 |
| `<C-l>` | 切换到右侧窗口 |
| `<leader>sv` | 垂直分屏 |
| `<leader>sh` | 水平分屏 |
| `<S-l>` | 切换到下一个 Buffer |
| `<S-h>` | 切换到上一个 Buffer |
| `<leader>bd` | 关闭当前 Buffer |
| `<leader>bp` | 使用 Bufferline 选择 Buffer |

### 文件树

| 快捷键 | 功能 |
| --- | --- |
| `<leader>e` | 打开或关闭 Neo-tree，并定位到当前文件 |

### Telescope

| 快捷键 | 功能 |
| --- | --- |
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 |
| `<leader>fb` | 查看 Buffer |
| `<leader>fh` | 查看帮助文档 |
| `<leader>fr` | 查看最近文件 |
| `<leader>fs` | 在当前文件内搜索 |
| `<leader>fc` | 查找命令 |
| `<leader>fk` | 查找快捷键 |

### Git

| 快捷键 | 功能 |
| --- | --- |
| `<leader>gs` | 暂存当前或选中的 Git hunk |
| `<leader>gr` | 撤销当前或选中的 Git hunk |
| `<leader>gp` | 预览当前 Git hunk |
| `<leader>gb` | 查看当前行 Git blame |
| `<leader>gl` | 打开 LazyGit |
| `<leader>gd` | 打开 Git 差异视图 |
| `<leader>gh` | 查看当前文件 Git 历史 |
| `<leader>gq` | 关闭 Git 差异视图 |
| `]g` | 跳到下一个 Git hunk |
| `[g` | 跳到上一个 Git hunk |

### LSP 与诊断

| 快捷键 | 功能 |
| --- | --- |
| `gd` | 跳转到定义 |
| `gr` | 查看引用 |
| `gi` | 跳转到实现 |
| `gt` | 跳转到类型定义 |
| `K` | 显示悬浮文档 |
| `<leader>rn` | 重命名符号 |
| `<leader>ca` | 代码操作（普通 / 可视模式） |
| `<leader>ld` | 显示当前行诊断 |
| `<leader>ll` | 在 Telescope 中查看全部诊断 |
| `]d` | 跳到下一个诊断 |
| `[d` | 跳到上一个诊断 |

### 诊断与列表（Trouble）

Trouble 使用官方默认键位，列表打开后可以继续用 `?` 查看列表内可用的操作。

| 快捷键 | 功能 |
| --- | --- |
| `<leader>xx` | 全部诊断 |
| `<leader>xX` | 当前 Buffer 诊断 |
| `<leader>cs` | 符号列表 |
| `<leader>cl` | LSP 定义与引用 |
| `<leader>xL` | Location List |
| `<leader>xQ` | Quickfix 列表 |

### 包围符号（mini.surround）

保留插件默认键位，以下快捷键均不需要 Leader。首次按键时会自动加载插件。

| 快捷键 | 模式 | 功能 |
| --- | --- | --- |
| `sa` | 普通、可视 | 添加包围符号 |
| `sd` | 普通 | 删除包围符号 |
| `sr` | 普通 | 替换包围符号 |
| `sf` / `sF` | 普通 | 向右 / 向左查找包围符号 |
| `sh` | 普通 | 高亮包围符号 |

常用示例：

- `saiw)`：给当前单词加上圆括号，例如 `word` → `(word)`。
- 选中文本后按 `sa)`：给选区加上圆括号。
- `sd)`：删除圆括号。
- `sr)"`：将圆括号替换为双引号。

这些映射以 `s` 开头，使用原生 `s` 命令时可能需要等待后续按键。
懒加载触发键放在 `lua/plugins/mini-surround.lua`，实际映射由插件默认配置创建。

### 终端与可视模式

| 快捷键 | 功能 |
| --- | --- |
| `<C-\>` | 打开或关闭浮动终端 |
| `<Esc>` | 在终端中退出插入模式 |
| `J` | 在可视模式中向下移动选中行 |
| `K` | 在可视模式中向上移动选中行 |

## 目录结构

```text
.
├── init.lua                 # 入口与基础选项（行号、缩进、搜索等）
├── lua
│   ├── config
│   │   ├── lazy.lua         # lazy.nvim 启动与插件加载
│   │   ├── settings.lua     # 插件配置（主题、状态栏、启动页、bufferline）
│   │   ├── keymaps.lua      # 通用快捷键
│   │   ├── neovide.lua      # Neovide GUI 配置
│   │   └── proxy.lua        # 插件下载代理配置
│   └── plugins              # 插件声明，一个插件一个文件
└── README.md
```

## 注意事项

`lua/config/proxy.lua` 默认设置了本机代理：

```lua
local proxy_url = "http://127.0.0.1:7897"
```

如果你不使用这个代理，或者端口不一致，请修改该文件，或在 `init.lua` 中注释掉：

```lua
require("config.proxy")
```

否则首次下载插件时可能会连接失败。

另外两点：

- `lazy-lock.json` 已被 `.gitignore` 忽略，插件版本不锁定。升级方便，但不同机器上装到的版本可能不同，
  排查问题前建议先确认插件版本是否一致。
- 首次打开 CMake 文件时，`neocmakelsp` 会在后台扫描系统中的 CMake 模块目录来生成内置索引，期间单核
  占用较高、持续数秒属于正常现象；初始化完成后 CPU 会回到 0，不影响编辑。如果你机器上的 CMake 包
  特别多，这个时间会相应变长。

## 自定义

- 基础编辑选项（行号、缩进、搜索、剪贴板等）在 `init.lua`。
- 插件初始化配置集中在 `lua/config/settings.lua`（主题、状态栏、启动页、bufferline）。
- 通用快捷键统一放在 `lua/config/keymaps.lua`；需要借用插件自身默认键位来触发懒加载的（如
  `mini-surround`），在对应插件文件中声明。
- 插件声明放在 `lua/plugins/`，新增插件时建议单独建一个 Lua 文件，用 `event` / `cmd` / `keys` 控制加载时机。

## License

本项目使用 MIT License，详见 [LICENSE](./LICENSE)。
