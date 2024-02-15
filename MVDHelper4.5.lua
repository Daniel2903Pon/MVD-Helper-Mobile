script_name("MVD Helper Mobile")
script_version("4.5")
script_author("@Sashe4ka_ReZoN")

local imgui = require 'mimgui'
local ffi = require 'ffi'
local inicfg = require("inicfg")
local faicons = require('fAwesome6')
local sampev = require('lib.samp.events')
function isMonetLoader() return MONET_VERSION ~= nil end

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new


sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ńęđčďň óńďĺříî çŕăđóçčëń˙", 0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ŕâňîđű:t.me/Sashe4ka_ReZoN",0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}×ňîáű ďîńěîňđĺňü ęîěěŕíäű,ââĺäčňĺ /mvd and /mvds ",0x8B00FF)

local renderWindow = new.bool()
local sizeX, sizeY = getScreenResolution()
local id = imgui.new.int(0)
local otherorg = imgui.new.char(255)
local zk = new.bool()
local autogun = new.bool()
local tab = 1
local patrul = new.bool()
local partner = imgui.new.char(255)
local chatrp = new.bool()
local arr = os.date("*t")
local poziv = imgui.new.char(255)
local pozivn = imgui.new.bool()
local suppWindow = imgui.new.bool()
windowTwo = imgui.new.bool()
setUkWindow = imgui.new.bool()
addUkWindow = imgui.new.bool()
local newUkInput = imgui.new.char(255)
local newUkUr = imgui.new.int(0)
local car = faicons('CAR')
local list = faicons('list')
local info = faicons('info')
local settings = faicons('gear')
local radio = faicons('user')
local pen = faicons('pen')
local sliders = faicons('sliders')
local userSecret = faicons('user-secret')
leaderPanel = imgui.new.bool()
local spawn = true
local mainIni = inicfg.load({
    Accent = {
        accent = '[Óęđŕčíńęčé ŕęöĺíň]: ',
        autoAccent = false
    },
    Info = {
        org = 'Âű íĺ ńîńňîčňĺ â ĎÄ',
        dl = 'Âű íĺ ńîńňîčňĺ â ĎÄ',
        rang_n = 0
    },
    theme = {
        themeta = 0
    }
}, "mvdhelper.ini")
local file = io.open("smartUk.json", "r") -- Îňęđűâŕĺě ôŕéë â đĺćčěĺ ÷ňĺíč˙
a = file:read("*a") -- ×čňŕĺě ôŕéë, ňŕě ó íŕń ňŕáëčöŕ
file:close() -- Çŕęđűâŕĺě
tableUk = decodeJson(a) -- ×čňŕĺě íŕřó JSON-Ňŕáëčöó



local statsCheck = false

local AutoAccentBool = new.bool(mainIni.Accent.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org = u8'Âű íĺ ńîńňîčňĺ â ĎÄ'
local org_g = u8'Âű íĺ ńîńňîčňĺ â ĎÄ'
local ccity = u8'Âű íĺ ńîńňîčňĺ â ĎÄ'
local org_tag = u8'Âű íĺ ńîńňîčňĺ â ĎÄ'
local dol = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
local dl = u8'Âű íĺ ńîńňîčňĺ â ĎÄ'
local rang_n = 0
local colorList = {u8'Ńňŕíäŕđňíŕ˙', u8'Ęđŕńíŕ˙', u8'Çĺë¸íŕ˙',u8'Ńčí˙˙', u8'Ôčîëĺňîâŕ˙'} -- ńîçäŕ¸ě ňŕáëčöó ń íŕçâŕíč˙ěč ňĺě
local colorListNumber = new.int(mainIni.theme.themeta) -- ńîçäŕ¸ě áóôĺđ ăäĺ áóäĺň őđŕíčňń˙ íîěĺđ âűáđŕííîé ňĺěű
local colorListBuffer = new['const char*'][#colorList](colorList) -- ńîçäŕ¸ě áóôĺđ äë˙ ńďčńęŕ
local nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
local autoScrinArest = new.bool()

local sliderBuf = new.int() -- áóôĺđ äë˙ ňĺńňîâîăî ńëŕéäĺđŕ
theme = {
    {
        change = function()
            imgui.SwitchContext()
            --==[ STYLE ]==--
            imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
            imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
            imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
            imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
            imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
            imgui.GetStyle().IndentSpacing = 0
            imgui.GetStyle().ScrollbarSize = 10
            imgui.GetStyle().GrabMinSize = 10

            --==[ BORDER ]==--
            imgui.GetStyle().WindowBorderSize = 1
            imgui.GetStyle().ChildBorderSize = 1
            imgui.GetStyle().PopupBorderSize = 1
            imgui.GetStyle().FrameBorderSize = 1
            imgui.GetStyle().TabBorderSize = 1

            --==[ ROUNDING ]==--
            imgui.GetStyle().WindowRounding = 5
            imgui.GetStyle().ChildRounding = 5
            imgui.GetStyle().FrameRounding = 5
            imgui.GetStyle().PopupRounding = 5
            imgui.GetStyle().ScrollbarRounding = 5
            imgui.GetStyle().GrabRounding = 5
            imgui.GetStyle().TabRounding = 5

            --==[ ALIGN ]==--
            imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
            imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
            imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
            
            --==[ COLORS ]==--
            imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
            imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
            imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
            imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
            imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
            imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.98, 0.26, 0.26, 0.40)
            imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.98, 0.06, 0.06, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.98, 0.26, 0.26, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.10, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
        end
    },
    {
        change = function()
            local ImVec4 = imgui.ImVec4
            imgui.SwitchContext()
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
            imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
            imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
            imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
            imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
            imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)local search = imgui.new.char[256]() -- ńîçäŕ¸ě áóôĺđ äë˙ ďîčńęŕ
            imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
            imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
            imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
            imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
            imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
            imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
            imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
            imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
            imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.06, 0.53, 0.98, 0.70)
            imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(0.10, 0.10, 0.10, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.06, 0.53, 0.98, 0.70)
            imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
            imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
            imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
            imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
            imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
        end
    },
    {
    	change = function()
    		imgui.SwitchContext()
			local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	colors[clr.WindowBg]			  = ImVec4(0.14, 0.12, 0.16, 1.00);
	colors[clr.ChildBg]		 			= ImVec4(0.30, 0.20, 0.39, 0.10);
	colors[clr.PopupBg]			   = ImVec4(0.30, 0.20, 0.39, 0.80);
	colors[clr.Border]				= ImVec4(0.89, 0.85, 0.92, 0.30);
	colors[clr.BorderShadow]		  = ImVec4(0.00, 0.00, 0.00, 0.00);
	colors[clr.FrameBg]			   = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.FrameBgHovered]		= ImVec4(0.41, 0.19, 0.63, 0.68);
	colors[clr.FrameBgActive]		 = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBg]			   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBgCollapsed]	  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TitleBgActive]		 = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.MenuBarBg]			 = ImVec4(0.30, 0.20, 0.39, 0.57);
	colors[clr.ScrollbarBg]		   = ImVec4(0.30, 0.20, 0.39, 1.00);
	colors[clr.ScrollbarGrab]		 = ImVec4(0.41, 0.19, 0.63, 0.31);
	colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.CheckMark]			 = ImVec4(0.56, 0.61, 1.00, 1.00);
	colors[clr.SliderGrab]			= ImVec4(0.41, 0.19, 0.63, 0.24);
	colors[clr.SliderGrabActive]	  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.Button]				= ImVec4(0.41, 0.19, 0.63, 0.44);
	colors[clr.ButtonHovered]		 = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.ButtonActive]		  = ImVec4(0.64, 0.33, 0.94, 1.00);
	colors[clr.Separator]			  = colors[clr.Border]
	colors[clr.SeparatorHovered]	   = ImVec4(0.41, 0.19, 0.63, 0.78)
	colors[clr.SeparatorActive]		= ImVec4(0.41, 0.19, 0.63, 1.00)
	colors[clr.Header]				= ImVec4(0.41, 0.19, 0.63, 0.76);
	colors[clr.HeaderHovered]		 = ImVec4(0.41, 0.19, 0.63, 0.86);
	colors[clr.HeaderActive]		  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.ResizeGrip]			= ImVec4(0.41, 0.19, 0.63, 0.20);
	colors[clr.ResizeGripHovered]	 = ImVec4(0.41, 0.19, 0.63, 0.78);
	colors[clr.ResizeGripActive]	  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotLines]			 = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotLinesHovered]	  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.PlotHistogram]		 = ImVec4(0.89, 0.85, 0.92, 0.63);
	colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
	colors[clr.TextSelectedBg]		= ImVec4(0.41, 0.19, 0.63, 0.43);
    	end
	}
    
}

imgui.OnFrame(
    function() return renderWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1700, 700), imgui.Cond.FirstUseEver)
        imgui.Begin(thisScript().name .. " " .. thisScript().version .. " ", renderWindow)
        imgui.SetCursorPosY(50)
        imgui.Text(u8'MVD Helper 4.5 \n äë˙ Arizona Mobile', imgui.SetCursorPosX(50))
        if imgui.Button(settings .. u8' Íŕńňđîéęč', imgui.ImVec2(280, 50)) then 
            tab = 1
        elseif imgui.Button(list .. u8' Îńíîâíîĺ', imgui.ImVec2(280, 50)) then
            tab = 2

        elseif imgui.Button(radio .. u8' Đŕöč˙ äĺďîđňŕěĺíňŕ', imgui.ImVec2(280, 50)) then
            tab = 3

        elseif imgui.Button(userSecret .. u8' Äë˙ ŃŃ', imgui.ImVec2(280, 50)) then
            tab = 4

        elseif imgui.Button(pen .. u8' Řďŕđăŕëęč', imgui.ImVec2(280, 50)) then
            tab = 5

        elseif imgui.Button(sliders .. u8' Äîďîëíčňĺëüíî', imgui.ImVec2(280, 50)) then
            tab = 6
            
        elseif imgui.Button(info .. u8' Číôŕ', imgui.ImVec2(280, 50)) then
            tab = 7
        end
        imgui.SetCursorPos(imgui.ImVec2(300, 50))
        if imgui.BeginChild('Name##'..tab, imgui.ImVec2(), true) then -- [Äë˙ äĺęîđŕ] Ńîçäŕ¸ě ÷ŕéëä â ęîňîđűé ďîěĺńňčě ńîäĺđćčěîĺ
            -- == [Îńíîâíîĺ] Ńîäĺđćčěîĺ âęëŕäîę == --
            if tab == 1 then -- ĺńëč çíŕ÷ĺíčĺ tab == 1
                imgui.Text(u8'Âŕř íčę: '.. nickname)
                imgui.Text(u8'Âŕřŕ îđăŕíčçŕöč˙: '.. mainIni.Info.org)
                imgui.Text(u8'Âŕřŕ äîëćíîńňü: '.. mainIni.Info.dl)
                if imgui.Combo(u8'Ňĺěű',colorListNumber,colorListBuffer, #colorList) then -- ńîçäŕ¸ě ęîěáî äë˙ âűáîđŕ ňĺěű
                    themeta = theme[colorListNumber[0]+1].change() -- ěĺí˙ĺě íŕ âűáđŕííóţ ňĺěó
                    mainIni.theme.themeta = colorListNumber[0]
                    inicfg.save(mainIni, 'mvdhelper.ini')
                end
                if imgui.Button(u8'ÓĘ') then
                    setUkWindow[0] = not setUkWindow[0]
                end
            elseif tab == 2 then -- ĺńëč çíŕ÷ĺíčĺ tab == 2
                imgui.InputInt(u8 'ID čăđîęŕ ń ęîňîđűě áóäĺňĺ âçŕčěîäĺéńňâîâŕňü', id, 10)
                if imgui.Button(u8 'Ďđčâĺňńňâčĺ') then
                    lua_thread.create(function()
                        sampSendChat("Äîáđîăî âđĺěĺíč ńóňîę, ˙ Ť" .. nickname .. "ť Ť" ..  u8:decode(mainIni.Info.dl) .."ť.")
                        wait(1500)
                        sampSendChat("/do Óäîńňîâĺđĺíčĺ â đóęŕő.")
                        wait(1500)
                        sampSendChat("/me ďîęŕçŕë ńâî¸ óäîńňîâĺđĺíčĺ ÷ĺëîâĺęó íŕ ďđîňčâ")
                        wait(1500)
                        sampSendChat("/do Ť" .. nickname .. "ť.")
                        wait(1500)
                        sampSendChat("/do Ť" .. u8:decode(mainIni.Info.dl) .. "ť " .. mainIni.Info.org .. ".")
                        wait(1500)
                        sampSendChat("Ďđĺäú˙âčňĺ âŕřč äîęóěĺíňű, ŕ čěĺííî ďŕńďîđň. Íĺ áĺńďîęîéňĺńü, ýňî âńĺăî ëčřü ďđîâĺđęŕ.")
                    end)
                end
                if imgui.Button(u8 'Íŕéňč čăđîęŕ') then
                    lua_thread.create(function()
                        sampSendChat("/do ĘĎĘ â ëĺâîě ęŕđěŕíĺ.")
                        wait(1500)
                        sampSendChat("/me äîńňŕë ëĺâîé đóęîé ĘĎĘ čç ęŕđěŕíŕ")
                        wait(1500)
                        sampSendChat("/do ĘĎĘ â ëĺâîé đóęĺ.")
                        wait(1500)
                        sampSendChat("/me âęëţ÷čë ĘĎĘ č çŕřĺë â áŕçó äŕííűő Ďîëčöčč")
                        wait(1500)
                        sampSendChat("/me îňęđűë äĺëî íîěĺđ " .. id[0] .. " ďđĺńňóďíčęŕ")
                        wait(1500)
                        sampSendChat("/do Äŕííűĺ ďđĺńňóďíčęŕ ďîëó÷ĺíű.")
                        wait(1500)
                        sampSendChat("/me ďîäęëţ÷čëń˙ ę ęŕěĺđŕě ńëĺćĺíč˙ řňŕňŕ")
                        wait(1500)
                        sampSendChat("/do Íŕ íŕâčăŕňîđĺ ďî˙âčëń˙ ěŕđřđóň.")
                        wait(1500)
                        sampSendChat("/pursuit " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ŕđĺńň') then
                    lua_thread.create(function()
                        sampSendChat("/me âç˙ë đó÷ęó čç ęŕđěŕíŕ đóáŕřęč, çŕňĺě îňęđűë áŕđäŕ÷îę č âç˙ë îňňóäŕ áëŕíę ďđîňîęîëŕ")
                        wait(1500)
                        sampSendChat("/do Áëŕíę ďđîňîęîëŕ č đó÷ęŕ â đóęŕő.")
                        wait(1500)
                        sampSendChat("/me çŕďîëí˙ĺň îďčńŕíčĺ âíĺříîńňč íŕđóřčňĺë˙")
                        wait(1500)
                        sampSendChat("/me çŕďîëí˙ĺň őŕđŕęňĺđčńňčęó î íŕđóřčňĺëĺ")
                        wait(1500)
                        sampSendChat("/me çŕďîëí˙ĺň äŕííűĺ î íŕđóřĺíčč")
                        wait(1500)
                        sampSendChat("/me ďđîńňŕâčë äŕňó č ďîäďčńü")
                        wait(1500)
                        sampSendChat("/me ďîëîćčë đó÷ęó â ęŕđěŕí đóáŕřęč")
                        wait(1500)
                        sampSendChat("/do Đó÷ęŕ â ęŕđěŕíĺ đóáŕřęč.")
                        wait(1500)
                        sampSendChat("/me ďĺđĺäŕë áëŕíę ńîńňŕâëĺííîăî ďđîňîęîëŕ â ó÷ŕńňîę")
                        wait(1500)
                        sampSendChat("/me ďĺđĺäŕë ďđĺńňóďíčęŕ â Óďđŕâëĺíčĺ Ďîëčöčč ďîä ńňđŕćó")
                        wait(1500)
                        sampSendChat("/arrest")
                        sampAddChatMessage("Âńňŕíüňĺ íŕ ÷ĺęďîčíň", -1)
                    end)
                end
                if imgui.Button(u8 'Íŕäĺňü íŕđó÷íčęč') then
                    lua_thread.create(function()
                        sampSendChat("/do Íŕđó÷íčęč âčń˙ň íŕ ďî˙ńĺ.")
                        wait(1500)
                        sampSendChat("/me ńí˙ë ń äĺđćŕňĺë˙ íŕđó÷íčęč")
                        wait(1500)
                        sampSendChat("/do Íŕđó÷íčęč â đóęŕő.")
                        wait(1500)
                        sampSendChat(
                            "/me đĺçęčě äâčćĺíčĺě îáĺčő đóę, íŕäĺë íŕđó÷íčęč íŕ ďđĺńňóďíčęŕ")
                        wait(1500)
                        sampSendChat("/do Ďđĺńňóďíčę ńęîâŕí.")
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ńí˙ňü íŕđó÷íčęč') then
                    lua_thread.create(function()
                        sampSendChat("/do Ęëţ÷ îň íŕđó÷íčęîâ â ęŕđěŕíĺ.")
                        wait(1500)
                        sampSendChat(
                            "/me äâčćĺíčĺě ďđŕâîé đóęč äîńňŕë čç ęŕđěŕíŕ ęëţ÷ č îňęđűë íŕđó÷íčęč")
                        wait(1500)
                        sampSendChat("/do Ďđĺńňóďíčę đŕńęîâŕí.")
                        wait(1500)
                        sampSendChat("/uncuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Âĺńňč çŕ ńîáîé') then
                    lua_thread.create(function()
                        sampSendChat("/me çŕëîěčë ďđŕâóţ đóęó íŕđóřčňĺëţ")
                        wait(1500)
                        sampSendChat("/me âĺäĺň íŕđóřčňĺë˙ çŕ ńîáîé")
                        wait(1500)
                        sampSendChat("/gotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ďĺđĺńňŕňü âĺńňč çŕ ńîáîé') then
                    lua_thread.create(function()
                        sampSendChat("/me îňďóńňčë ďđŕâóţ đóęó ďđĺńňóďíčęŕ")
                        wait(1500)
                        sampSendChat("/do Ďđĺńňóďíčę ńâîáîäĺí.")
                        wait(1500)
                        sampSendChat("/ungotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Â ěŕřčíó(ŕâňîěŕňč÷ĺńęč íŕ 3-ĺ ěĺńňî)') then
                    lua_thread.create(function()
                        sampSendChat("/do Äâĺđč â ěŕřčíĺ çŕęđűňű.")
                        wait(1500)
                        sampSendChat("/me îňęđűë çŕäíţţ äâĺđü â ěŕřčíĺ")
                        wait(1500)
                        sampSendChat("/me ďîńŕäčë ďđĺńňóďíčęŕ â ěŕřčíó")
                        wait(1500)
                        sampSendChat("/me çŕáëîęčđîâŕë äâĺđč")
                        wait(1500)
                        sampSendChat("/do Äâĺđč çŕáëîęčđîâŕíű.")
                        wait(1500)
                        sampSendChat("/incar " .. id[0] .. "3")
                    end)
                end
                if imgui.Button(u8 'Îáűńę') then
                    lua_thread.create(function()
                        sampSendChat("/me íűđíóâ đóęŕěč â ęŕđěŕíű, âűň˙íóë îňňóäŕ áĺëűĺ ďĺđ÷ŕňęč č íŕň˙íóë čő íŕ đóęč")
                        wait(1500)
                        sampSendChat("/do Ďĺđ÷ŕňęč íŕäĺňű.")
                        wait(1500)
                        sampSendChat("/me ďđîâîäčň đóęŕěč ďî âĺđőíĺé ÷ŕńňč ňĺëŕ")
                        wait(1500)
                        sampSendChat("/me ďđîâĺđ˙ĺň ęŕđěŕíű/me ďđîâîäčň đóęŕěč ďî íîăŕě")
                        wait(1500)
                        sampSendChat("/frisk " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ěĺăŕôîí') then
                    lua_thread.create(function()
                        sampSendChat("/do Ěĺăŕôîí â áŕđäŕ÷ęĺ.")
                        wait(1500)
                        sampSendChat("/me äîńňŕë ěĺăŕôîí ń áŕđäŕ÷ęŕ ďîńëĺ ÷ĺăî âęëţ÷čë ĺăî")
                        wait(1500)
                        sampSendChat("/m Âîäčňĺëü ŕâňî, îńňŕíîâčňĺńü č çŕăëóřčňĺ äâčăŕňĺëü, äĺđćčňĺ đóęč íŕ đóëĺ.")
                    end)
                end
                if imgui.Button(u8 'Âűňŕůčňü čç ŕâňî') then
                    lua_thread.create(function()
                        sampSendChat("/me ńí˙â äóáčíęó ń ďî˙ńíîăî äĺđćŕňĺë˙ đŕçáčë ńňĺęëî â ňđŕíńďîđňĺ")
                        wait(1500)
                        sampSendChat("/do Ńňĺęëî đŕçáčňî.")
                        wait(1500)
                        sampSendChat("/me ńőâŕňčâ çŕ ďëĺ÷č ÷ĺëîâĺęŕ óäŕđčë ĺăî ďîńëĺ ÷ĺăî íŕäĺë íŕđó÷íčęč")
                        wait(1500)
                        sampSendChat("/pull " .. id[0])
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Âűäŕ÷ŕ đîçűńęŕ') then
                    windowTwo[0] = not windowTwo[0]
                end
                
            elseif tab == 3 then -- ĺńëč çíŕ÷ĺíčĺ tab == 3
                imgui.InputText(u8 'Ôđŕęöč˙ ń ęîňîđîé áóäĺňĺ âçŕčěîäĺéńňâîâŕňü', otherorg, 255)
                otherdeporg = u8:decode(ffi.string(otherorg))
                imgui.Checkbox(u8 'Çŕęđűňűé ęŕíŕë', zk)
                if imgui.Button(u8 'Âűçîâ íŕ ńâ˙çü') then
                    if zk[0] then
                        sampSendChat("/d [" .. mainIni.Info.org .. "] z.k [" .. otherdeporg .. "] Íŕ ńâ˙çü!")
                    else
                        sampSendChat("/d [" .. mainIni.Info.org .. "] to [" .. otherdeporg .. "] Íŕ ńâ˙çü!")
                    end
                end
                if imgui.Button(u8 'Îňęŕň') then
                    sampSendChat("/d [" .. mainIni.Info.org .. "] to [ALL] Čçâčíčňĺ, đŕöč˙ óďŕëŕ.")
                end
            elseif tab == 4 then
                if imgui.CollapsingHeader(u8'Áčíäĺđ') then
                    if imgui.CollapsingHeader(u8'Ëĺęöčč') then
                        if imgui.Button(u8'Ŕđĺńň č çŕäĺđćŕíčĺ') then
                            lua_thread.create(function()
                                sampSendChat("Çäđŕâńňâóéňĺ óâŕćŕĺěűĺ ńîňđóäíčęč íŕřĺăî äĺďŕđňŕěĺíňŕ!")
                                wait(1500)
                                sampSendChat("Ńĺé÷ŕń áóäĺň ďđîâĺäĺíŕ ëĺęöč˙ íŕ ňĺěó ŕđĺńň č çŕäĺđćŕíčĺ ďđĺńňóďíčęîâ.")
                                wait(1500)
                                sampSendChat("Äë˙ íŕ÷ŕëŕ îáú˙ńíţ đŕçëč÷čĺ ěĺćäó çŕäĺđćŕíčĺě č ŕđĺńňîě.")
                                wait(1500)
                                sampSendChat("Çŕäĺđćŕíčĺ - ýňî ęđŕňęîâđĺěĺííîĺ ëčřĺíčĺ ńâîáîäű ëčöŕ, ďîäîçđĺâŕĺěîăî â ńîâĺđřĺíčč ďđĺńňóďëĺíč˙.")
                                wait(1500)
                                sampSendChat("Â ńâîţ î÷ĺđĺäü, ŕđĺńň - ýňî âčä óăîëîâíîăî íŕęŕçŕíč˙, çŕęëţ÷ŕţůĺăîń˙ â ńîäĺđćŕíčč ńîâĺđřčâřĺăî ďđĺńňóďëĺíčĺ..")
                                wait(1500)
                                sampSendChat("..č îńóćä¸ííîăî ďî ďđčăîâîđó ńóäŕ â óńëîâč˙ő ńňđîăîé čçîë˙öčč îň îáůĺńňâŕ.")
                                wait(1500)
                                sampSendChat("Âŕě đŕçđĺřĺíî çŕäĺđćčâŕňü ëčöŕ íŕ ďĺđčîä 48 ÷ŕńîâ ń ěîěĺíňŕ čő çŕäĺđćŕíč˙.")
                                wait(1500)
                                sampSendChat("Ĺńëč â ňĺ÷ĺíčĺ 48 ÷ŕńîâ âű íĺ ďđĺäú˙âčňĺ äîęŕçŕňĺëüńňâŕ âčíű, âű îá˙çŕíű îňďóńňčňü ăđŕćäŕíčíŕ.")
                                wait(1500)
                                sampSendChat("Îáđŕňčňĺ âíčěŕíčĺ, ăđŕćäŕíčí ěîćĺň ďîäŕňü íŕ âŕń čńę çŕ íĺçŕęîííîĺ çŕäĺđćŕíčĺ.")
                                wait(1500)
                                sampSendChat("Âî âđĺě˙ çŕäĺđćŕíč˙ âű îá˙çŕíű ďđîâĺńňč ďĺđâč÷íűé îáűńę íŕ ěĺńňĺ çŕäĺđćŕíč˙ č âňîđč÷íűé ó ęŕďîňŕ ńâîĺăî ŕâňîěîáčë˙.")
                                wait(1500)
                                sampSendChat("Âńĺ íŕéäĺííűĺ âĺůč ďîëîćčňü â 'ZIP-lock', čëč â ęîíňĺéíĺđ äë˙ âĺů. äîęîâ, Âńĺ ëč÷íűĺ âĺůč ďđĺńňóďíčęŕ ęëŕäóňń˙ â ěĺřîę äë˙ ëč÷íűő âĺůĺé çŕäĺđćŕííîăî")
                                wait(1500)
                                sampSendChat("Íŕ ýňîě äŕííŕ˙ ëĺęöč˙ ďîäőîäčň ę ęîíöó. Ó ęîăî-ňî čěĺţňń˙ âîďđîńű?")
                            end)
                        end
                        if imgui.Button("Ńóááîđäčíŕöč˙") then
                            lua_thread.create(function()
                                sampSendChat(" Óâŕćŕĺěűĺ ńîňđóäíčęč Ďîëčöĺéńęîăî Äĺďŕđňŕěĺíňŕ!")
                                wait(1500)
                                sampSendChat(" Ďđčâĺňńňâóţ âŕń íŕ ëĺęöčč î ńóáîđäčíŕöčč") 
                                wait(1500)
                                sampSendChat(" Äë˙ íŕ÷ŕëŕ đŕńńęŕćó, ÷ňî ňŕęîĺ ńóáîđäčíŕöč˙") 
                                wait(1500)
                                sampSendChat(" Ńóáîđäčíŕöč˙ - ďđŕâčëŕ ďîä÷číĺíč˙ ěëŕäřčő ďî çâŕíčţ ę ńňŕđřčě ďî çâŕíčţ, óâŕćĺíčĺ, îňíîřĺíčĺ ę íčě") 
                                wait(1500)
                                sampSendChat(" Ňî ĺńňü ěëŕäřčĺ ńîňđóäíčęč äîëćíű âűďîëí˙ňü ďđčęŕçű íŕ÷ŕëüńňâŕ") 
                                wait(1500)
                                sampSendChat(" Ęňî îńëóřŕĺňń˙  ďîëó÷čň âűăîâîđ, ńďĺđâŕ óńňíűé") 
                                wait(1500)
                                sampSendChat(" Âű äîëćíű ń óâŕćĺíčĺě îňíîńčňń˙ ę íŕ÷ŕëüńňâó íŕ 'Âű'") 
                                wait(1500)
                                sampSendChat(" Íĺ íŕđóřŕéňĺ ďđŕâčëŕ č íĺ íŕđóřŕéňĺ ńóáîđäčíŕöčţ äŕáű íĺ ďîëó÷čňü íŕęŕçŕíčĺ") 
                                wait(1500)
                                sampSendChat(" Ëĺęöč˙ îęîí÷ĺíŕ ńďŕńčáî çŕ âíčěŕíčĺ!") 
                            end)
                        end
                        if imgui.Button(u8"Ńóááîđäčíŕöč˙") then
                            lua_thread.create(function()
                                sampSendChat(" Óâŕćŕĺěűĺ ńîňđóäíčęč Ďîëčöĺéńęîăî Äĺďŕđňŕěĺíňŕ!")
                                wait(1500)
                                sampSendChat(" Ďđčâĺňńňâóţ âŕń íŕ ëĺęöčč î ńóáîđäčíŕöčč") 
                                wait(1500)
                                sampSendChat(" Äë˙ íŕ÷ŕëŕ đŕńńęŕćó, ÷ňî ňŕęîĺ ńóáîđäčíŕöč˙") 
                                wait(1500)
                                sampSendChat(" Ńóáîđäčíŕöč˙ - ďđŕâčëŕ ďîä÷číĺíč˙ ěëŕäřčő ďî çâŕíčţ ę ńňŕđřčě ďî çâŕíčţ, óâŕćĺíčĺ, îňíîřĺíčĺ ę íčě") 
                                wait(1500)
                                sampSendChat(" Ňî ĺńňü ěëŕäřčĺ ńîňđóäíčęč äîëćíű âűďîëí˙ňü ďđčęŕçű íŕ÷ŕëüńňâŕ") 
                                wait(1500)
                                sampSendChat(" Ęňî îńëóřŕĺňń˙  ďîëó÷čň âűăîâîđ, ńďĺđâŕ óńňíűé") 
                                wait(1500)
                                sampSendChat(" Âű äîëćíű ń óâŕćĺíčĺě îňíîńčňń˙ ę íŕ÷ŕëüńňâó íŕ 'Âű'") 
                                wait(1500)
                                sampSendChat(" Íĺ íŕđóřŕéňĺ ďđŕâčëŕ č íĺ íŕđóřŕéňĺ ńóáîđäčíŕöčţ äŕáű íĺ ďîëó÷čňü íŕęŕçŕíčĺ") 
                                wait(1500)
                                sampSendChat(" Ëĺęöč˙ îęîí÷ĺíŕ ńďŕńčáî çŕ âíčěŕíčĺ!") 
                            end)
                        end
                        if imgui.Button(u8"Ďđŕâčëŕ ďîâĺäĺíč˙ â ńňđîţ.") then
                            lua_thread.create(function()
                                sampSendChat(" Óâŕćŕĺěűĺ ńîňđóäíčęč Ďîëčöĺéńęîăî Äĺďŕđňŕěĺíňŕ!") 
                                wait(1500)
                                sampSendChat(" Ďđčâĺňńňâóţ âŕń íŕ ëĺęöčč ďđŕâčëŕ ďîâĺäĺíč˙ â ńňđîţ") 
                                wait(1500)
                                sampSendChat(" /b Çŕďđĺůĺíű đŕçăîâîđű â ëţáűĺ ÷ŕňű (in ic, /r, /n, /fam, /sms,)") 
                                wait(1500)
                                sampSendChat(" Çŕďđĺůĺíî ďîëüçîâŕňüń˙ ěîáčëüíűěč ňĺëĺôîíŕěč") 
                                wait(1500)
                                sampSendChat(" Çŕďđĺůĺíî äîńňŕâŕňü îđóćčĺ") 
                                wait(1500)
                                sampSendChat(" Çŕďđĺůĺíî îňęđűâŕňü îăîíü áĺç ďđčęŕçŕ") 
                                wait(1500)
                                sampSendChat(" /b Çŕďđĺůĺíî óőîäčňü â AFK áîëĺĺ ÷ĺě íŕ 30 ńĺęóíä") 
                                wait(1500)
                                sampSendChat(" Çŕďđĺůĺíî ńŕěîâîëüíî ďîęčäŕňü ńňđîé íĺ ďđĺäóďđĺäčâ îá ýňîě ńňŕđřčé ńîńňŕâ") 
                                wait(1500)
                                sampSendChat(" /b Çŕďđĺůĺíű ëţáűĺ äâčćĺíč˙ â ńňđîţ (/anim) Čńęëţ÷ĺíčĺ: ńň. ńîńňŕâ") 
                                wait(1500)
                                sampSendChat(" /b Çŕďđĺůĺíî čńďîëüçîâŕíčĺ ńčăŕđĺň [/smoke â ńňđîţ]")
                            end)
                        end
                        if imgui.Button(u8'Äîďđîń') then
                            lua_thread.create(function()
                                sampSendChat(" Çäđŕâńňâóéňĺ óâŕćŕĺěűĺ ńîňđóäíčęč äĺďŕđňŕěĺíňŕ ńĺăîäí˙, ˙ ďđîâĺäó ëĺęöčţ íŕ ňĺěó Äîďđîń ďîäîçđĺâŕĺěîăî.") 
                                wait(1500)
                                sampSendChat(" Ńîňđóäíčę ĎÄ îá˙çŕí ńíŕ÷ŕëŕ ďîďđčâĺňńňâîâŕňü, ďđĺäńňŕâčňüń˙;") 
                                wait(1500)
                                sampSendChat(" Ńîňđóäíčę ĎÄ îá˙çŕí ďîďđîńčňü äîęóěĺíňű âűçâŕííîăî, ńďđîńčňü, ăäĺ đŕáîňŕĺň, çâŕíčĺ, äîëćíîńňü, ěĺńňî ćčňĺëüńňâŕ;") 
                                wait(1500)
                                sampSendChat(" Ńîňđóäíčę ĎÄ îá˙çŕí ńďđîńčňü, ÷ňî îí äĺëŕë (íŕçâŕňü ďđîěĺćóňîę âđĺěĺíč, ăäĺ îí ÷ňî-ňî íŕđóřčë, ďî ęîňîđîěó îí áűë âűçâŕí);") 
                                wait(1500)
                                sampSendChat(" Ĺńëč ďîäîçđĺâŕĺěűé áűë çŕäĺđćŕí çŕ đîçűńę, ńňŕđŕéňĺńü óçíŕňü çŕ ÷ňî îí ďîëó÷čë đîçűńę;") 
                                wait(1500)
                                sampSendChat(" Â ęîíöĺ äîďđîńŕ ďîëčöĺéńęčé âűíîńčň âĺđäčęň âűçâŕííîěó.")
                                wait(1500)
                                sampSendChat(" Ďđč îăëŕřĺíčč âĺđäčęňŕ, íĺîáőîäčěî ďđĺäĺëüíî ňî÷íî îăëŕńčňü âčíó äîďđŕřčâŕĺěîăî (Đŕńńęŕçŕňü ĺěó ďđč÷číó, çŕ ÷ňî îí áóäĺň ďîńŕćĺí);") 
                                wait(1500)
                                sampSendChat(" Ďđč âűíĺńĺíčč âĺđäčęňŕ, íĺ ńňîčň çŕáűâŕňü î îň˙ă÷ŕţůčő č ńě˙ă÷ŕţůčő ôŕęňîđŕő (Đŕńęŕ˙íčĺ, ŕäĺęâŕňíîĺ ďîâĺäĺíčĺ, ďđčçíŕíčĺ âčíű čëč ëîćü, íĺŕäĺęâŕňíîĺ ďîâĺäĺíčĺ, ďđîâîęŕöčč, ďđĺäńňŕâëĺíčĺ ďîëĺçíîé číôîđěŕöčč č ňîěó ďîäîáíîĺ).")
                                wait(1500)
                                sampSendChat(" Íŕ ýňîě ëĺęöč˙ ďîäîřëŕ ę ęîíöó, ĺńëč ó ęîăî-ňî ĺńňü âîďđîńű, îňâĺ÷ó íŕ ëţáîé ďî äŕííîé ëĺęöčč (Ĺńëč çŕäŕëč âîďđîń, ňî íóćíî îňâĺňčňü íŕ íĺăî)") 
                            end)
                        end
                        if imgui.Button(u8"Ďđŕâčëŕ ďîâĺäĺíč˙ äî č âî âđĺě˙ îáëŕâű íŕ íŕđęîďđčňîí.") then
                            lua_thread.create(function()
                                sampSendChat(" Äîáđűé äĺíü, ńĺé÷ŕń ˙ ďđîâĺäó âŕě ëĺęöčţ íŕ ňĺěó Ďđŕâčëŕ ďîâĺäĺíč˙ äî č âî âđĺě˙ îáëŕâű íŕ íŕđęîďđčňîí") 
                                wait(1500)
                                sampSendChat(" Â ńňđîţ, ďĺđĺä îáëŕâîé, âű äîëćíű âíčěŕňĺëüíî ńëóřŕňü ňî, ÷ňî ăîâîđ˙ň âŕě Ŕăĺíňű") 
                                wait(1500)
                                sampSendChat(" Óáĺäčňĺëüíŕ˙ ďđîńüáŕ, çŕđŕíĺĺ óáĺäčňüń˙, ÷ňî ďđč ńĺáĺ ó âŕń čěĺţňń˙ áŕëŕęëŕâű") 
                                wait(1500)
                                sampSendChat(" Ďî ďóňč ę íŕđęîďđčňîíó, ďîäúĺçćŕ˙ ę îďŕńíîěó đŕéîíó, âńĺ îá˙çŕíű čő îäĺňü") 
                                wait(1500)
                                sampSendChat(" Ďđčĺőŕâ íŕ ňĺđđčňîđčţ ďđčňîíŕ, íóćíî ďîńňŕâčňü îöĺďëĺíčĺ ňŕę, ÷ňîáű çŕăîđîäčňü âńĺ âîçěîćíűĺ ďóňč ę ńîçđĺâŕţůčě ęóńňŕě Ęîíîďëč") 
                                wait(1500)
                                sampSendChat(" Î÷ĺíü âŕćíűě çŕěĺ÷ŕíčĺě ˙âë˙ĺňń˙ ňî, ÷ňî íčęîěó, ęđîěĺ ŕăĺíňîâ, çŕďđĺůĺíî ďîäőîäčňü ę ęóńňŕě, ŕ ňĺě áîëĺĺ čő ńîáčđŕňü") 
                                wait(1500)
                                sampSendChat(" Íŕđóřĺíčĺ äŕííîăî ďóíęňŕ ńňđîăî íŕęŕçűâŕĺňń˙, âďëîňü äî óâîëüíĺíčĺ") 
                                wait(1500)
                                sampSendChat(" Ňŕę ćĺ ďđčĺőŕâ íŕ ěĺńňî, ěű íĺ óńňđŕčâŕĺě ďŕëüáó ďî âńĺě, ęîăî âčäčě") 
                                wait(1500)
                                sampSendChat(" Îňęđűâŕňü îăîíü ďî ďîńňîđîííĺěó đŕçđĺřŕĺňń˙ ňîëüęî â ňîě ńëó÷ŕĺ, ĺńëč îí íŕöĺëčëń˙ íŕ âŕń îđóćčĺě, íŕ÷ŕë ŕňŕęîâŕňü âŕń čëč ńîáčđŕňü ńîçđĺâřčĺ ęóńňű") 
                                wait(1500)
                                sampSendChat(" Ęŕę ňîëüęî ńďĺö. îďĺđŕöč˙ çŕęŕí÷čâŕĺňń˙, âńĺ îöĺďëĺíčĺ óáčđŕĺňń˙") 
                                wait(1500)
                                sampSendChat(" Íŕ ýňîě ëĺęöč˙ îęîí÷ĺíŕ, âńĺě ńďŕńčáî") 
                            end)
                        end
                        if imgui.Button(u8"Ďđŕâčëî ěčđŕíäű.") then
                            lua_thread.create(function()
                                sampSendChat("Ďđŕâčëî Ěčđŕíäű  ţđčäč÷ĺńęîĺ ňđĺáîâŕíčĺ â ŃŘŔ") 
                                wait(1500)
                                sampSendChat("Ńîăëŕńíî ęîňîđîěó âî âđĺě˙ çŕäĺđćŕíč˙ çŕäĺđćčâŕĺěűé äîëćĺí áűňü óâĺäîěëĺí î ńâîčő ďđŕâŕő.") 
                                wait(1500)
                                sampSendChat("Ýňî ďđŕâčëî çŕ÷čňűâŕţňń˙ çŕäĺđćŕííîěó, ŕ ÷čňŕĺň ĺ¸ ęňî ńŕě çŕäĺđćŕë ĺăî.") 
                                wait(1500)
                                sampSendChat("Ýňî ôđŕçŕ ăîâîđčňń˙, ęîăäŕ âű íŕäĺëč íŕ çŕäĺđćŕííîăî íŕđó÷íčęč.") 
                                wait(1500)
                                sampSendChat("Öčňčđóţ ńŕěó ôđŕçó:") 
                                wait(1500)
                                sampSendChat("- Âű čěĺĺňĺ ďđŕâî őđŕíčňü ěîë÷ŕíčĺ.") 
                                wait(1500)
                                sampSendChat("- Âń¸, ÷ňî âű ńęŕćĺňĺ, ěîćĺň č áóäĺň čńďîëüçîâŕíî ďđîňčâ âŕń â ńóäĺ.") 
                                wait(1500)
                                sampSendChat("- Âŕř ŕäâîęŕň ěîćĺň ďđčńóňńňâîâŕňü ďđč äîďđîńĺ.") 
                                wait(1500)
                                sampSendChat("- Ĺńëč âű íĺ ěîćĺňĺ îďëŕňčňü óńëóăč ŕäâîęŕňŕ, îí áóäĺň ďđĺäîńňŕâëĺí âŕě ăîńóäŕđńňâîě.") 
                                wait(1500)
                                sampSendChat("- Âű ďîíčěŕĺňĺ ńâîč ďđŕâŕ?")
                            end)
                        end
                        if imgui.Button(u8"Ďĺđâŕ˙ Ďîěîůü.") then
                            lua_thread.create(function()
                                sampSendChat("Äë˙ íŕ÷ŕëŕ îďđĺäĺëčěń˙ ÷ňî ń ďîńňđŕäŕâřčě") 
                                wait(1500)
                                sampSendChat("Ĺńëč, ó ďîńňđŕäŕâřĺăî ęđîâîňĺ÷ĺíčĺ, ňî íĺîáőîäčěî îńňŕíîâčňü ďîňîę ęđîâč ćăóňîě") 
                                wait(1500)
                                sampSendChat("Ĺńëč đŕíĺíčĺ íĺáîëüřîĺ äîńňŕňî÷íî äîńňŕňü íŕáîđ ďĺđâîé ďîěîůč č ďĺđĺâ˙çŕňü đŕíó áčíňîě") 
                                wait(1500)
                                sampSendChat("Ĺńëč â đŕíĺ ďóë˙, č đŕíŕ íĺ ăëóáîęŕ˙, Âű äîëćíű âűçâŕňü ńęîđóţ ëčáî âűňŕůčňü ĺĺ ńęŕëüďĺëĺě, ńęŕëüďĺëü ňŕęćĺ íŕőîäčňń˙ â ŕďňĺ÷ęĺ ďĺđâîé ďîěîůč") 
                                wait(1500)
                                sampSendChat("Ĺńëč ÷ĺëîâĺę áĺç ńîçíŕíč˙ âŕě íóćíî ... ") 
                                wait(1500)
                                sampSendChat(" ... äîńňŕňü čç íŕáîđ ďĺđâîé ďîěîůč âŕňó č ńďčđň, çŕňĺě íŕěî÷čňü âŕňó ńďčđňîě ... ") 
                                wait(1500)
                                sampSendChat(" ... č ďđîâĺńňč âŕňęîé ńî ńďčđňîě îęîëî íîńŕ ďîńňđŕäŕâřĺăî, â ýňîě ńëó÷ŕĺ, îí äîëćĺí î÷íóňüń˙") 
                                wait(1500)
                                sampSendChat("Íŕ ýňîě ëĺęöč˙ îęîí÷ĺíŕ. Ó ęîăî-ňî ĺńňü âîďđîńű ďî äŕííîé ëĺęöčč?") wait(1500)
                            end)
                        end
                    end
                end
                if rang_n > 8 then
                    if imgui.Button(u8'Ďŕíĺëü ëčäĺđŕ/çŕěĺńňčňĺë˙') then
                        leaderPanel[0] = not leaderPanel[0]
                    end
                end
            elseif tab == 5 then 
                if imgui.CollapsingHeader(u8 'ÓĘ') then
                    for i = 1, #tableUk["Text"] do
                        imgui.Text(u8(tableUk["Text"][i] .. ' Óđîâĺíü đîçűńęŕ: ' .. tableUk["Text"][i]))
                    end
                end
                if imgui.CollapsingHeader(u8 'Ňĺí-ęîäű') then
                    imgui.Text(u8"10-1 - Âńňđĺ÷ŕ âńĺő îôčöĺđîâ íŕ äĺćóđńňâĺ (óęŕçűâŕ˙ ëîęŕöčţ č ęîä).")
                    imgui.Text(u8"10-2 - Âűřĺë â ďŕňđóëü.")
                    imgui.Text(u8"10-2R: Çŕęîí÷čë ďŕňđóëü.")
                    imgui.Text(u8"10-3 - Đŕäčîěîë÷ŕíčĺ (óęŕçűâŕ˙ äëčňĺëüíîńňü).")
                    imgui.Text(u8"10-4 - Ďđčí˙ňî.")
                    imgui.Text(u8"10-5 - Ďîâňîđčňĺ.")
                    imgui.Text(u8"10-6 - Íĺ ďđčí˙ňî/íĺâĺđíî/íĺň.")
                    imgui.Text(u8"10-7 - Îćčäŕéňĺ.")
                    imgui.Text(u8"10-8 - Íĺäîńňóďĺí.")
                    imgui.Text(u8"10-14 - Çŕďđîń ňđŕíńďîđňčđîâęč (óęŕçűâŕ˙ ëîęŕöčţ č öĺëü ňđŕíńďîđňčđîâęč).")
                    imgui.Text(u8"10-15 - Ďîäîçđĺâŕĺěűĺ ŕđĺńňîâŕíű (óęŕçűâŕ˙ ęîëč÷ĺńňâî ďîäîçđĺâŕĺěűő č ëîęŕöčţ).")
                    imgui.Text(u8"10-18 - Ňđĺáóĺňń˙ ďîääĺđćęŕ äîďîëíčňĺëüíűő ţíčňîâ.")
                    imgui.Text(u8"10-20 - Ëîęŕöč˙.")
                    imgui.Text(u8"10-21 - Îďčńŕíčĺ ńčňóŕöčč.")
                    imgui.Text(u8"10-22 - Íŕďđŕâë˙ţńü â ....")
                    imgui.Text(u8"10-27 - Ńěĺíŕ ěŕđęčđîâęč ďŕňđóë˙ (óęŕçűâŕ˙ ńňŕđóţ ěŕđęčđîâęó č íîâóţ).")
                    imgui.Text(u8"10-30 - Äîđîćíî-ňđŕíńďîđňíîĺ ďđîčńřĺńňâčĺ.")
                    imgui.Text(u8"10-40 - Áîëüřîĺ ńęîďëĺíčĺ ëţäĺé (áîëĺĺ 4).")
                    imgui.Text(u8"10-41 - Íĺëĺăŕëüíŕ˙ ŕęňčâíîńňü.")
                    imgui.Text(u8"10-46 - Ďđîâîćó îáűńę.")
                    imgui.Text(u8"10-55 - Îáű÷íűé Ňđŕôôčę Ńňîď.")
                    imgui.Text(u8"10-57 VICTOR - Ďîăîí˙ çŕ ŕâňîěîáčëĺě (óęŕçűâŕ˙ ěîäĺëü ŕâňî, öâĺň ŕâňî, ęîëč÷ĺńňâî ÷ĺëîâĺę âíóňđč, ëîęŕöčţ, íŕďđŕâëĺíčĺ äâčćĺíč˙).")
                    imgui.Text(u8"10-57 FOXTROT - Ďĺřŕ˙ ďîăîí˙ (óęŕçűâŕ˙ âíĺříîńňü ďîäîçđĺâŕĺěîăî, îđóćčĺ (ďđč íŕëč÷čč číôîđěŕöčč î âîîđóćĺíčč), ëîęŕöč˙, íŕďđŕâëĺíčĺ äâčćĺíč˙).")
                    imgui.Text(u8"10-60 - Číôîđěŕöč˙ îá ŕâňîěîáčëĺ (óęŕçűâŕ˙ ěîäĺëü ŕâňî, öâĺň, ęîëč÷ĺńňâî ÷ĺëîâĺę âíóňđč).")
                    imgui.Text(u8"10-61 - Číôîđěŕöč˙ î ďĺřĺě ďîäîçđĺâŕĺěîě (óęŕçűâŕ˙ đŕńó, îäĺćäó).")
                    imgui.Text(u8"10-66 - Ňđŕôôčę Ńňîď ďîâűřĺíîăî đčńęŕ.")
                    imgui.Text(u8"10-70 - Çŕďđîń ďîääĺđćęč (â îňëč÷čč îň 10-18 íĺîáőîäčěî óęŕçŕňü ęîëč÷ĺńňâî ţíčňîâ č ęîä).")
                    imgui.Text(u8"10-71 - Çŕďđîń ěĺäčöčíńęîé ďîääĺđćęč.")
                    imgui.Text(u8"10-99 - Ńčňóŕöč˙ óđĺăóëčđîâŕíŕ.")
                    imgui.Text(u8"10-100 - Íŕđóřĺíčĺ ţđčńäčęöčč ")
                end
                if imgui.CollapsingHeader(u8 'Ěŕđęčđîâęč ďŕňđóëĺé') then
                    imgui.CenterText('Ěŕđęčđîâęč ďŕňđóëüíűő ŕâňîěîáčëĺé')
                    imgui.Text(u8"* ADAM (A) - ěŕđęčđîâęŕ ďŕňđóë˙ ń äâóě˙ îôčöĺđŕěč íŕ ęđóçĺđ")
                    imgui.Text(u8"* LINCOLN (L) - ěŕđęčđîâęč ďŕňđóë˙ ń îäíčě îôčöĺđîě íŕ ęđóçĺđ")
                    imgui.Text(u8"* LINCOLN 10/20/30/40/50/60 - ěŕđęčđîâęŕ ńóďĺđâŕéçĺđŕ")
                    imgui.CenterText('Ěŕđęčđîâęč äđóăčő ňđŕíńďîđňíűő ńđĺäńňâ')
                    imgui.Text(u8"* MARY (M) - ěŕđęčđîâęŕ ěîňîöčęëĺňíîăî ďŕňđóë˙")
                    imgui.Text(u8"* AIR (AIR) - ěŕđęčđîâęŕ ţíčňŕ Air Support Division")
                    imgui.Text(u8"* AIR-100 - ěŕđęčđîâęŕ ńóďĺđâŕéçĺđŕ Air Support Division")
                    imgui.Text(u8"* AIR-10 - ěŕđęčđîâęŕ ńďŕńŕňĺëüíîăî ţíčňŕ Air Support Division")
                    imgui.Text(u8"* EDWARD (E) - ěŕđęčđîâęŕ Tow Unit")  
                end

            elseif tab == 6 then 
                imgui.Checkbox(u8 'Ŕâňî îňűăđîâęŕ îđóćč˙', autogun)
                if autogun[0] then
                    lua_thread.create(function()
                        while true do
                            wait(0)
                            if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
                                local gun = getCurrentCharWeapon(PLAYER_PED)
                                if gun == 3 then
                                    sampSendChat("/me äîńňŕë äóáčíęó ń ďî˙ńíîăî äĺđćŕňĺë˙")
                                elseif gun == 16 then
                                    sampSendChat("/me âç˙ë ń ďî˙ńŕ ăđŕíŕňó")
                                elseif gun == 17 then
                                    sampSendChat("/me âç˙ë ăđŕíŕňó ńëĺçîňî÷čâîăî ăŕçŕ ń ďî˙ńŕ")
                                elseif gun == 23 then
                                    sampSendChat("/me äîńňŕë ňŕéçĺđ ń ęîáóđű, óáđŕë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 22 then
                                    sampSendChat("/me äîńňŕë ďčńňîëĺň Colt-45, ńí˙ë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 24 then
                                    sampSendChat("/me äîńňŕë Desert Eagle ń ęîáóđű, óáđŕë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 25 then
                                    sampSendChat("/me äîńňŕë ÷ĺőîë ńî ńďčíű, âç˙ë äđîáîâčę č óáđŕë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 26 then
                                    sampSendChat("/me đĺçęčě äâčćĺíčĺě îáîčő đóę, ńí˙ë âîĺííűé đţęçŕę ń ďëĺ÷ č äîńňŕë Îáđĺçű")
                                elseif gun == 27 then
                                    sampSendChat("/me äîńňŕë äđîáîâčę Spas, ńí˙ë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 28 then
                                    sampSendChat("/me đĺçęčě äâčćĺíčĺě îáîčő đóę, ńí˙ë âîĺííűé đţęçŕę ń ďëĺ÷ č äîńňŕë ÓÇČ")
                                elseif gun == 29 then
                                    sampSendChat("/me äîńňŕë ÷ĺőîë ńî ńďčíű, âç˙ë ĚĎ5 č óáđŕë ďđĺäîőđŕíčňĺëü")
                                elseif gun == 30 then
                                    sampSendChat("/me äîńňŕë ęŕđŕáčí AK-47 ńî ńďčíű")
                                elseif gun == 31 then
                                    sampSendChat("/me äîńňŕë ęŕđŕáčí Ě4 ńî ńďčíű")
                                elseif gun == 32 then
                                    sampSendChat("/me đĺçęčě äâčćĺíčĺě îáîčő đóę, ńí˙ë âîĺííűé đţęçŕę ń ďëĺ÷ č äîńňŕë TEC-9")
                                elseif gun == 33 then
                                    sampSendChat("/me äîńňŕë âčíňîâęó áĺç ďđčöĺëŕ čç âîĺííîé ńóěęč")
                                elseif gun == 34 then
                                    sampSendChat("/me äîńňŕë Ńíŕéďĺđńęóţ âčíňîâęó ń âîĺííîé ńóěęč")
                                elseif gun == 43 then
                                    sampSendChat("/me äîńňŕë ôîňîęŕěĺđó čç đţęçŕęŕ")
                                elseif gun == 0 then
                                    sampSendChat("/me ďîńňŕâčë ďđĺäîőđŕíčňĺëü, óáđŕë îđóćčĺ")
                                end
                                lastgun = gun
                            end
                        end
                    end)
                end
                imgui.Checkbox(u8'Ŕâňî-äîęëŕä ďŕňđóë˙ ęŕćäűĺ 10 ěčíóň(âęëţ÷ŕňü ďđč íŕ÷ŕëĺ)/]. Âńĺăî 30 ěčíóň', patrul)
                imgui.InputText(u8'Íčę âŕřĺăî íŕďŕđíčęŕ(íŕ ŕíăëčńęîě)', partner, 255)
                partnerNick = u8:decode(ffi.string(partner))
                imgui.Checkbox(u8'Ďîçűâíîé ďđč äîęëŕäŕő', pozivn)
                imgui.InputText(u8'Âŕř ďîçűâíîé', poziv, 255)
                pozivnoi = u8:decode(ffi.string(poziv))
                if patrul[0] and pozivn[0] then
                    poziv[0] = false
                    patrul[0] = false
                    lua_thread.create(function()
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Âűőîćó â ďŕňđóëü. Íŕďŕđíčę - " .. partnerNick .. ". Äîńňóďĺí.")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Ďđîäîëćŕţ ďŕňđóëü ń " .. partnerNick .. ". Ńîńňî˙íčĺ ńňŕáčëüíîĺ. Äîńňóďĺí")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Ďđîäîëćŕţ ďŕňđóëü ń " .. partnerNick .. ". Ńîńňî˙íčĺ ńňŕáčëüíîĺ. Äîńňóďĺí")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Çŕęŕí÷čâŕţ ďŕňđóëü ń " .. partnerNick .. ".")
                    end)
                elseif patrul[0] then
                    lua_thread.create(function()
                        patrul[0] = false
                        sampSendChat("/r " .. nickname .. ". Âűőîćó â ďŕňđóëü. Íŕďŕđíčę - " .. partnerNick .. ". Äîńňóďĺí.")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. ". Ďđîäîëćŕţ ďŕňđóëü ń " .. partnerNick .. ". Ńîńňî˙íčĺ ńňŕáčëüíîĺ. Äîńňóďĺí")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. ". Ďđîäîëćŕţ ďŕňđóëü ń " .. partnerNick .. ". Ńîńňî˙íčĺ ńňŕáčëüíîĺ. Äîńňóďĺí")
                        wait(600000)
                        sampSendChat("/r " .. nickname .. ". Çŕęŕí÷čâŕţ ďŕňđóëü ń " .. partnerNick .. ".")
                    end)

                end
                imgui.Checkbox(u8'Ŕâňî ŕęöĺíň', AutoAccentBool)
                if AutoAccentBool[0] then
                    AutoAccentCheck = true
                    mainIni.Accent.autoAccent = true
                    inicfg.save(mainIni, "mvdhelper.ini")
                else 
                    mainIni.Accent.autoAccent = false
                    inicfg.save(mainIni, "mvdhelper.ini")
                end 
                imgui.InputText(u8'Ŕęöĺíň', AutoAccentInput, 255)
                AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
                mainIni.Accent.accent = AutoAccentText
                inicfg.save(mainIni, "mvdhelper.ini")
                if imgui.Button(u8'Âńďîěîăŕňĺëüíîĺ îęîřęî') then
                	suppWindow[0] = not suppWindow [0]
                	
				end
            elseif tab == 7 then 
                imgui.Text(u8'Âĺđńč˙: 4.5')
                imgui.Text(u8'Đŕçđŕáîň÷čę: @Sashe4ka_ReZoN')
                imgui.Text(u8'ŇĂ ęŕíŕë: @lua_arz')
                imgui.Text(u8'Ďîääĺđćŕňü: https://qiwi.com/n/SASHE4KAREZON')
                imgui.Text(u8'Îáíîâëĺíčĺ 4.1 - Čçěĺíĺíčĺ číňĺđôĺéńŕ, äîáŕâëĺíčĺ âęëŕäîę "Číôî" č "Äë˙ ŃŃ". Äîáŕâëĺí ŕâňî ŕęöĺíň. Ôčęń áŕăîâ.')
                imgui.Text(u8'Îáíîâëĺíčĺ 4.2 - Ôčęń ŕâňî îďđĺäĺëĺíč˙. Äîńňóď ę ďŕíĺëčč ŃŃ ń ëţáîăî đŕíăŕ(Ďŕíĺëü ëčäĺđŕ ňŕęćĺ îńňŕĺňń˙ îň 9 đŕíăŕ).')
                imgui.Text(u8'Îáíîâëĺíčĺ 4.3 - Ôčęń ďđčâĺňńňâč˙. Äîáŕâëĺííî ÔÁĐ â ńďčńîę îđăŕíčçŕöčé')
                imgui.Text(u8'Îáíîâëĺíčĺ 4.4 - Äîáŕâčëč ëĺęöčč,Ďŕíĺëü ëčäĺđŕ(â đŕçđŕáîňęĺ)')
                imgui.Text(u8'Îáíîâëĺíčĺ 4.5 - Ňĺďĺđü ěîćíî ďîńňŕâčňü ńâîé ÓĘ. Äîáŕâëĺíŕ ôčîëĺňîâŕ˙ ňĺěŕ. Îáíîâëĺí /mvds')
            end
            -- == [Îńíîâíîĺ] Ńîäĺđćčěîĺ âęëŕäîę çŕęîí÷čëîńü == --
            imgui.EndChild()
            imgui.End()
        end
    end
)

function main()
    if statsCheck == false then
    end
    sampRegisterChatCommand('mvd', openwindow)
    sampRegisterChatCommand("showpass", cmd_showpass)
    sampRegisterChatCommand("showlic", cmd_showlic)
    sampRegisterChatCommand("showskill", cmd_showskill)
    sampRegisterChatCommand("showmc", cmd_showmc)
    sampRegisterChatCommand("pull", cmd_pull)
    sampRegisterChatCommand("invite", cmd_invite)
    sampRegisterChatCommand("uninvite", cmd_uninvite)
    sampRegisterChatCommand("cuff",cmd_cuff)
    sampRegisterChatCommand("uncuff",cmd_uncuff)
    sampRegisterChatCommand("gotome",cmd_gotome)
    sampRegisterChatCommand("ungotome",cmd_ungotome)
    sampRegisterChatCommand("frisk", cmd_frisk)
    sampRegisterChatCommand("showbadge", cmd_showbadge)
    sampRegisterChatCommand("tencodes",cmd_tencodes)
    sampRegisterChatCommand("marks",cmd_marks)
    sampRegisterChatCommand("sitcodes",cmd_sitcodes)
    sampRegisterChatCommand("mask", cmd_mask)
    sampRegisterChatCommand("arm", cmd_arm)
    sampRegisterChatCommand("drug", cmd_drug) 
    sampRegisterChatCommand("asu", cmd_asu) 
    sampRegisterChatCommand("arrest", cmd_arrest) 
    sampRegisterChatCommand("stop", cmd_stop) 
    sampRegisterChatCommand("giverank",cmd_giverank) 
    sampRegisterChatCommand("unmask",cmd_unmask) 
    sampRegisterChatCommand("miranda",cmd_miranda) 
    sampRegisterChatCommand("bodyon",cmd_bodyon) 
    sampRegisterChatCommand("bodyoff",cmd_bodyoff) 
    sampRegisterChatCommand("ticket",cmd_ticket)
    sampRegisterChatCommand("pursuit",cmd_pursuit)
    sampRegisterChatCommand("drugtestno",cmd_drugtestno)
    sampRegisterChatCommand("drugtestyes",cmd_drugtestyes)
    sampRegisterChatCommand("vzatka",cmd_vzatka)
    sampRegisterChatCommand("bomb",cmd_bomb)
    sampRegisterChatCommand("probiv",cmd_probiv)
    sampRegisterChatCommand("dismiss",cmd_dismiss)
    sampRegisterChatCommand("demoute",cmd_demoute)
    sampRegisterChatCommand("cure",cmd_cure)
    sampRegisterChatCommand("zsu",cmd_zsu)
    sampRegisterChatCommand("find",cmd_find)
    sampRegisterChatCommand("incar",cmd_incar)
    sampRegisterChatCommand("eject",cmd_eject)
    sampRegisterChatCommand("pog",cmd_pog)
    sampRegisterChatCommand("pas",cmd_pas)
    sampRegisterChatCommand("clear",cmd_clear)
    sampRegisterChatCommand("take",cmd_take)
    sampRegisterChatCommand("time",cmd_time)
    sampRegisterChatCommand("gcuff",cmd_gcuff)
    sampRegisterChatCommand("fbi.pravda", cmd_pravda_fbi)
    sampRegisterChatCommand("fbi.secret", cmd_secret_fbi)
    sampRegisterChatCommand("finger.p", cmd_finger_person)
    sampRegisterChatCommand("podmoga", cmd_warn)
    sampRegisterChatCommand("mvds",cmd_mvds)
    sampRegisterChatCommand("stop", cmd_stop)
    sampRegisterChatCommand("grim", cmd_grim)
    sampRegisterChatCommand("eks", cmd_eks)
end

function sampev.onSendSpawn()
	if spawn and isMonetLoader() then
		spawn = false
		sampSendChat('/stats')
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ńęđčďň óńďĺříî çŕăđóçčëń˙", 0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ŕâňîđű:t.me/Sashe4ka_ReZoN",0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}×ňîáű ďîńěîňđĺňü ęîěěŕíäű,ââĺäčňĺ /mvd and /mvds ",0x8B00FF)
        nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 235 and title == "{BFBBBA}Îńíîâíŕ˙ ńňŕňčńňčęŕ" then
        statsCheck = true
        if string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "Ďîëčöč˙ ËÂ" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "Ďîëčöč˙ ËŃ" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "Ďîëčöč˙ ŃÔ" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "RCPD" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "RCSD"  or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "Îáëŕńňíŕ˙ ďîëčöč˙" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "ÔÁĐ" or string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]") == "FBI" then
            org = string.match(text, "Îđăŕíčçŕöč˙: {B83434}%[(%D+)%]")
            if org ~= 'Íĺ čěĺĺňń˙' then dol = string.match(text, "Äîëćíîńňü: {B83434}(%D+)%(%d+%)") end
            dl = u8(dol)
            if org == 'Ďîëčöč˙ ËÂ' then org_g = u8'LVPD'; ccity = u8'Ëŕń-Âĺíňóđŕń'; org_tag = 'LVPD' end
            if org == 'Ďîëčöč˙ ËŃ' then org_g = u8'LSPD'; ccity = u8'Ëîń-Ńŕíňîń'; org_tag = 'LSPD' end
            if org == 'Ďîëčöč˙ ŃÔ' then org_g = u8'SFPD'; ccity = u8'Ńŕí-Ôčĺđđî'; org_tag = 'SFPD' end
            if org == 'ÔÁĐ' then org_g = u8'FBI'; ccity = u8'Ńŕí-Ôčĺđđî'; org_tag = 'FBI' end
            if org == 'FBI' then org_g = u8'FBI'; ccity = u8'Ńŕí-Ôčĺđđî'; org_tag = 'FBI' end
            if org == 'RCSD' or org == 'Îáëŕńňíŕ˙ ďîëčöč˙' then org_g = u8'RCSD'; ccity = u8'Red Country'; org_tag = 'RCSD' end
            if org == 'RCPD' or org == 'Îáëŕńňíŕ˙ ďîëčöč˙' then org_g = u8'RCPD'; ccity = u8'Red Country'; org_tag = 'RCPD' end
            if org == '[Íĺ čěĺĺňń˙]' then
                org = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
                org_g = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
                ccity = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
                org_tag = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
                dol = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
                dl = 'Âű íĺ ńîńňîčňĺ â ĎÄ'
            else
                rang_n = tonumber(string.match(text, "Äîëćíîńňü: {B83434}%D+%((%d+)%)"))   
            end      
            mainIni.Info.org = org_g
            mainIni.Info.rang_n = rang_n
            mainIni.Info.dl = dl
            inicfg.save(mainIni,'mvdhelper.ini')
        end
    end
end

function openwindow()
    renderWindow[0] = not renderWindow[0]
end

function decor()
    -- == Äĺęîđ ÷ŕńňü == --
    imgui.SwitchContext()
    local ImVec4 = imgui.ImVec4
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1
    imgui.GetStyle().WindowRounding = 8
    imgui.GetStyle().ChildRounding = 8
    imgui.GetStyle().FrameRounding = 8
    imgui.GetStyle().PopupRounding = 8
    imgui.GetStyle().ScrollbarRounding = 8
    imgui.GetStyle().GrabRounding = 8
    imgui.GetStyle().TabRounding = 8
end

imgui.OnInitialize(function()
    decor() -- ďđčěĺí˙ĺě äĺęîđ ÷ŕńňü
    theme[colorListNumber[0]+1].change() -- ďđčěĺí˙ĺě öâĺňîâóţ ÷ŕńňü
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 20, config, iconRanges) -- solid - ňčď čęîíîę, ňŕę ćĺ ĺńňü thin, regular, light č duotone
end)

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function cmd_showpass(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/showpass [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîńňŕë ďŕďęó ń äîęóěĺíňŕěč")
            wait(1500)
            sampSendChat("/do Ďŕďęŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë ďŕńďîđň")
            wait(1500)
            sampSendChat("/do Ďŕńďîđň â đóęĺ.")
            wait(1500)
            sampSendChat("/me ďĺđĺäŕë ďŕńďîđň ÷ĺëîâĺęó íŕ ďđîňčâ")
            wait(1500)
            sampSendChat("/showpass " .. id .. " ")
        end)
    end
end

function cmd_showbadge(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/showbadge [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me čç âíóňđĺííĺăî ęŕđěŕíŕ äîńňŕë óäîńňîâĺđĺíčĺ")  
            wait(1500) 
            sampSendChat("/me îňęđűë äîęóěĺíň â đŕçâ¸đíóňîě âčäĺ, ďîęŕçŕë ńîäĺđćčěîĺ ÷ĺëîâĺęó íŕďđîňčâ") 
            wait(1500) 
            sampSendChat("/do Íčćĺ íŕőîäčňń˙ ďĺ÷ŕňü ďđŕâčňĺëüńňâŕ č ďîäďčńü.")
            wait(1500)
            sampSendChat("/me çŕęđűë äîęóěĺíň , óáđŕë ĺăî îáđŕňíî â ęŕđěŕí")
            wait(1500)
            sampSendChat ("/showbadge "..id.." ")
        end)
    end
end

function cmd_showlic(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/showlic [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîńňŕë ďŕďęó ń äîęóěĺíňŕěč")
            wait(1500)
            sampSendChat("/do Ďŕďęŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë ëčöĺíçčč")
            wait(1500)
            sampSendChat("/do Ëčöĺíçčč â đóęĺ.")
            wait(1500)
            sampSendChat("/me ďĺđĺäŕë ëčöĺíçčč ÷ĺëîâĺęó íŕ ďđîňčâ")
            wait(1500)
            sampSendChat("/showlic " .. id .. " ")
        end)
    end
end

function cmd_mvds(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ęîěŕíäű MVD HELPER 4.5", "/showlic -  Ďîęŕçűâŕĺň âŕřč ëčöĺíçčč\n/showpass - Ďîęŕçűâŕĺň âŕř ďŕńďîđň\n/showmc - Ďîęŕçűâŕĺň âŕřó Ěĺä. Ęŕđňó\n/showskill - Ďîęŕçűâŕĺň âŕřč íŕâűęč îđóćč˙\n/showbadge - Ďîęŕçŕňü âŕřĺ óäîńňîâĺđĺíčĺ ÷ĺëîâĺęó\n/pull - Âűęčäűâŕĺň ÷ŕëîâĺęŕ čç ŕâňî č îăëóřŕĺň\n/uninvite - Óâîëčňü ÷ĺëîâĺęŕ čç îđăŕíčçŕöčč\n/invite - Ďđčí˙ňü ÷ĺëîâĺęŕ â îđăŕíčçŕöčţ\n/cuff - Íŕäĺňü íŕđó÷íčęč\n/uncuff - Ńí˙ňü íŕđó÷íčęč\n/frisk - Îáűńęŕňü ÷ĺëîâĺęŕ\n/mask - Íŕäĺňü ěŕńęó\n/arm - Ńí˙ňü/Íŕäĺňü áđîíčćĺëĺň\n/asu - Âűäŕňü đîçűńę\n/drug - Čńďîëüçîâŕňü íŕđęîňčęč\n/arrest - Ěĺňęŕ äë˙ ŕđĺńňŕ ÷ĺëîâĺęŕ\n/stop - 10-55 Ňđŕôôčę-Ńňîď\n/giverank - Âűäŕňü đŕíă ÷ĺëîâĺęó\n/unmask - Ńí˙ňü ěŕńęó ń ďđĺńňóďíčęŕ\n/miranda - Çŕ÷čňŕňü ďđŕâŕ\n/bodyon - Âęëţ÷čňü Áîäč-Ęŕěĺđó\n/bodyoff - Âűęëţ÷čňü Áîäč-Ęŕěĺđó\n/ticket - Âűďčńŕňü řňđŕô\n/pursuit - Âĺńňč ďđĺńëĺäîâŕíčĺ çŕ čăđîęîě\n/drugtestno - Ňĺńň íŕ íŕđęîňčęč ( Îňđčöŕňĺëüíűé )\n/drugtestyes - Ňĺńň íŕ íŕđęîňčęč ( Ďîëîćčňĺëüíűé )\n/vzatka - Đď Âç˙ňęŕ\n/bomb - Đŕçěčíčđîâŕíčĺ áîěáű\n/dismiss - Óâîëčňü ÷ĺëîâĺęŕ čç îđăŕíčçŕöčč ( 6 ÔÁĐ )\n/demoute - Óâîëčňü ÷ĺëîâĺęŕ čç îđăŕíčçŕöčč ( 9 ÔÁĐ )\n/cure - Âűëĺ÷čňü äđóăŕ ęîňîđîăî ďîëîćčëč\n/find - Îňűăđîâęŕ ďîčńęŕ ďđĺńňóďíčęŕ\n/incar - Ďîńŕäčňü ďđĺńňóďíčęŕ â ěŕřčíó\n/tencodes - Ňĺí Ęîäű\n/marks - Ěŕđęč Ŕâňî\n/sitcodes - Ńčňóŕöčîííűĺ Ęîäű\n/zsu - Çŕďđîń â đîçűńę\n/mask - Íŕäĺňü ěŕńęó\n/take - Çŕáđŕňü çŕďđĺů¸íűĺ âĺůč\n/gcuff - cuff + gotome\n/fbi.secret - äîęóěĺíň î íĺđŕçăëŕřĺíčč äĺ˙ňĺëüíîńňč ÔÁĐ\n/fbi.pravda - Äîęóěĺíň î ďđŕâäčâîńňč ńëîâ íŕ äîďđîńĺ\n/finger.p - Ńí˙ňčĺ îňďĺ÷ŕňęîâ ďŕëüöĺâ ÷ĺëîâĺęŕ\n/podmoga - Âűçîâ ďîäěîăč â /r\n/grim - Íŕíĺńĺíčĺ ăđčěŕ\n/eks - Ýęńďĺđňčçŕ îđóćčĺ\nŔâňîđ:t.me/Sashe4ka_ReZoN", "Çŕęđűňü", "Exit", 0)
        end)
        end
        

function cmd_showskill(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/showskill [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîńňŕë ďŕďęó ń äîęóěĺíňŕěč")
            wait(1500)
            sampSendChat("/do Ďŕďęŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë âűďčńęó ń ňčđŕ")
            wait(1500)
            sampSendChat("/do Âűďčńęŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me ďĺđĺäŕë âűďčńęó ÷ĺëîâĺęó íŕ ďđîňčâ")
            wait(1500)
            sampSendChat("/showskill " .. id .. " ")
        end)
    end
end

function cmd_showmc(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/showmc [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîńňŕë ďŕďęó ń äîęóěĺíňŕěč")
            wait(1500)
            sampSendChat("/do Ďŕďęŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë ěĺä. ęŕđňó")
            wait(1500)
            sampSendChat("/do Ěĺä. ęŕđňŕ â đóęĺ.")
            wait(1500)
            sampSendChat("/me ďĺđĺäŕë ěĺä. ęŕđňó ÷ĺëîâ îâĺęó íŕ ďđîňčâ")
            wait(1500)
            sampSendChat("/showmc " .. id .. " ")
        end)
    end
end

function cmd_pull(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/pull [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/pull " .. id .. " ")
            wait(1500)
            sampSendChat("/me ńőâŕňčë äóáčíęó ń ďî˙ńŕ, đĺçęčě âçěŕőîě ĺĺ č íŕ÷ŕë áčňü ďî îęíó âîäčňĺë˙")
            wait(1500)
            sampSendChat("/me đŕçáčâ ńňĺęëî, îňęđűë äâĺđü čçíóňđč č ńőâŕňčë âîäčňĺë˙ çŕ îäĺćäó ...")
            wait(1500)
            sampSendChat("/me ... ďîńëĺ ÷ĺăî, âűáđîńčë ďîäîçđĺâŕĺěîăî íŕ ŕńôŕëüň č çŕëîěŕë ĺăî đóęč")

        end)
    end
end

function cmd_invite(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/invite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Ďîä ńňîéęîé íŕőîäčňń˙ đţęçŕę.")
            wait(1500)
            sampSendChat("/do Ôîđěŕ â đţęçŕęĺ...")
            wait(1500)
            sampSendChat("/me ńóíóë đóęó â đţęçŕę, ďîńëĺ ÷ĺăî âç˙ë ôîđěó č áĺéäćčę â đóęč")
            wait(1500)
            sampSendChat("/me ďĺđĺäŕ¸ň ôîđěó č áĺéäćčę")
            wait(1500)
            sampSendChat("/todo Čäčňĺ ďĺđĺîäĺíüňĺńü*óęŕçűâŕ˙ ďŕëüöĺě íŕ äâĺđü đŕçäĺâŕëęč")
            wait(1500)
            sampSendChat("/invite " .. id .. " ")
        end)
    end
end

function cmd_uninvite(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/uninvite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat ("/do Íŕ ďî˙ńĺ çŕôčęńčđîâŕí ęîćŕíűé đĺěĺíü ń ăđŕâčđîâęîé Police.")
            wait(1500)
            sampSendChat ("/do Íŕ đĺěíĺ çŕęđĺďëĺíî ďĺđĺíîńíîĺ ĘĎĘ ń áŕçîé äŕííűő")
            wait(1500)
            sampSendChat ("/me äâčćĺíčĺě ďđŕâîé đóęč, ŕęęóđŕňíî ńí˙ë ĘĎĘ ń ďî˙ńŕ")
            wait(1500)
            sampSendChat ("/do Îôčöĺđő äĺđćčň ĘĎĘ â đóęŕő.")
            wait(1500)
            sampSendChat("/me äâčćĺíčĺě ďđŕâîé đóęč, íŕćŕë íŕ ęíîďęó âęëţ÷ĺíč˙ ĘĎĘ")
            wait(1500)
            sampSendChat ("/me çŕřĺë áŕçó äŕííűő ńîňđóäíčęîâ")
            wait(1500)
            sampSendChat ("/me íŕćŕë íŕ ęíîďęó óâîëčňü ńîňđóäíčęŕ")
            wait(1500)
            sampSendChat ("/do ĘĎĘ: Çŕďîëíčňĺ číôîđěŕöčţ î ńîňđóäíčęĺ.")
            wait(1500)
            sampSendChat ("/me áĺăëűě äâčćĺíčĺě đóę, çŕďîëíčë číôîđěŕöčţ î ńîňđóäíčęĺ, ďîńëĺ ÷ĺăî íŕćŕë ęíîďęó óâîëčňü ńîňđóäíčęŕ")
            wait(1500)
            sampSendChat ("/do ĘĎĘ: Ńîňđóäíčę óńďĺříî óâîëĺí čç áŕçű äŕííűő.")
            wait(1500)
            sampSendChat("/uninvite " .. id .. " ")
        end)
    end
end

function cmd_cuff(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/cuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Íŕđó÷íčęč âčń˙ň íŕ ďî˙ńĺ.")
            wait(1500)
            sampSendChat("/me ńí˙ë ń äĺđćŕňĺë˙ íŕđó÷íčęč")
            wait(1500)
            sampSendChat("/do Íŕđó÷íčęč â đóęŕő.")
            wait(1500)
            sampSendChat("/me đĺçęčě äâčćĺíčĺě îáĺčő đóę, íŕäĺë íŕđó÷íčęč íŕ ďđĺńňóďíčęŕ")
            wait(1500)
            sampSendChat("/do Ďđĺńňóďíčę ńęîâŕí.")
            wait(1500)
            sampSendChat("/cuff "..id.." ")
         end)
      end
   end

function cmd_uncuff(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/uncuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Ęëţ÷ îň íŕđó÷íčęîâ â ęŕđěŕíĺ.")
            wait(1500)
            sampSendChat("/me äâčćĺíčĺě ďđŕâîé đóęč äîńňŕë čç ęŕđěŕíŕ ęëţ÷ č îňęđűë íŕđó÷íčęč")
            wait(1500)
            sampSendChat("/do Ďđĺńňóďíčę đŕńęîâŕí.")
            wait(1500)
            sampSendChat("/uncuff "..id.." ")
        end)
     end
  end

function cmd_gotome(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/gotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me çŕëîěčë ďđŕâóţ đóęó íŕđóřčňĺëţ")
            wait(1500)
            sampSendChat("/me âĺäĺň íŕđóřčňĺë˙ çŕ ńîáîé")
            wait(1500)
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_ungotome(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/ungotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me îňďóńňčë ďđŕâóţ đóęó ďđĺńňóďíčęŕ")
            wait(1500)
            sampSendChat("/do Ďđĺńňóďíčę ńâîáîäĺí.")
            wait(1500)
            sampSendChat("/ungotome "..id.." ")
        end)
     end
  end

function cmd_gcuff(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/gcuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Íŕđó÷íčęč âčń˙ň íŕ ďî˙ńĺ.") 
            wait(1500) 
            sampSendChat("/me ńí˙ë ń äĺđćŕňĺë˙ íŕđó÷íčęč") 
            wait(1500) 
            sampSendChat("/do Íŕđó÷íčęč â đóęŕő.") 
            wait(1500) 
            sampSendChat("/me đĺçęčě äâčćĺíčĺě îáĺčő đóę, íŕäĺë íŕđó÷íčęč íŕ ďđĺńňóďíčęŕ") 
            wait(1500) 
            sampSendChat("/do Ďđĺńňóďíčę ńęîâŕí.") 
            wait(1500) 
            sampSendChat("/cuff "..id.." ")
            wait(1500)
            sampSendChat("/me çŕëîěčë ďđŕâóţ đóęó íŕđóřčňĺëţ") 
            wait(1500) 
            sampSendChat("/me âĺäĺň íŕđóřčňĺë˙ çŕ ńîáîé") 
            wait(1500) 
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_frisk(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/frisk [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me íŕäĺâ đĺçčíîâűĺ ďĺđ÷ŕňęč, íŕ÷ŕë ďđîůóďűâŕňü ăđŕćäŕíčíŕ ďî âńĺěó ňĺëó ...")
            wait(1500)
            sampSendChat("/do Ďĺđ÷ŕňęč íŕäĺňű.")
            wait(1500)
            sampSendChat("/me ďđîâîäčň đóęŕěč ďî âĺđőíĺé ÷ŕńňč ňĺëŕ")
            wait(1500)
            sampSendChat("/me ... çŕ ňĺě íŕ÷ŕë ňůŕňĺëüíî îáűńęčâŕňü ăđŕćäŕíčíŕ, âűęëŕäűâŕ˙ âń¸ äë˙ čçó÷ĺíč˙")
            wait(1500)
            sampSendChat("/frisk " .. id .. " ")
        end)
    end
end


function cmd_pursuit(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/pursuit [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do ĘĎĘ â ëĺâîě ęŕđěŕíĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë ĘĎĘ čç ëĺâîăî ęŕđěŕíŕ")
            wait(1500)
            sampSendChat("/me âęëţ÷čë ĘĎĘ č çŕřĺë â áŕçó äŕííűő Ďîëčöčč")
            wait(1500)
            sampSendChat("/me îňęđűë äĺëî ń äŕííűěč ďđĺńňóďíčęŕ")
            wait(1500)
            sampSendChat("/do Äŕííűĺ ďđĺńňóďíčęŕ ďîëó÷ĺíű.")
            wait(1500)
            sampSendChat("/me ďîäęëţ÷čëń˙ ę ęŕěĺđŕě ńëĺćĺíč˙ řňŕňŕ")
            wait(1500)
            sampSendChat("/pursuit " .. id .. " ")
        end)
    end
end

function cmd_arm(id)

        lua_thread.create(function()
            sampSendChat("/armour")
            wait(1500)
            sampSendChat("/me ńěĺíčë ďëŕńňčíű â áđîíčćĺëĺňĺ")
        end)
    end


function cmd_mask()
lua_thread.create(function()
            sampSendChat("/mask")
            wait(1500)
            sampSendChat("/me íŕäĺë íŕ đóęč ďĺđ÷ŕňęč, íŕäĺë áŕëŕęëŕâó íŕ ëčöî")
        end)
    end

function cmd_drug(id)
    if id == "" then
         sampAddChatMessage("Ââĺäč ęîë-âî íŕđęî [1-3]: {FFFFFF}/usedrugs [1-3].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîńňŕë čç ęŕđěŕíŕ ęîíôĺňęó đîřĺí")
            wait(1500)
            sampSendChat("/do Ńí˙ë ôŕíňčę, ńúĺë ĺĺ.")
            sampSendChat("/usedrugs "..id.." ")
        end)
    end
   end

function cmd_asu(arg)
lua_thread.create(function()
    local arg1, arg2, arg3 = arg:match('(.+) (.+) (.+)')		
    if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
        sampSendChat('/su '..arg1..' '..arg2..' '..arg3..'')
		wait(1000)
		sampSendChat("/me ńí˙ë đŕöčţ ń ăđóäíîăî äĺđćŕňĺë˙ č ńîîáůčë äčńďĺň÷ĺđó î íŕđóřčňĺëĺ")
   wait(1000)
   sampSendChat("/do Ńďóńň˙ ďîëěčíóňű ďîëó÷čë îňâĺň îň äčńďĺň÷ĺđŕ.")
   wait(1000)
   sampSendChat("/todo 10-4, Ęîíĺö ńâ˙çč.*ďîâĺńčâ đŕöčţ íŕ ăđóäíîé äĺđćŕňĺëü")
    else
		sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/asu [ID] [Ęîë-âî đîçűńęŕ] [Ďđč÷číŕ].", 0x318CE7FF -1)
		end
	end)
end


function cmd_arrest(id)
    if id == "" then
         sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/arrest [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me íŕćŕâ íŕ ňŕíăĺňó, ńîîáůčë äčńďĺň÷ĺđó î ďđîâĺçĺííîě ďđĺńňóďíčęč ...")
            wait(1500)
            sampSendChat("/me çŕďđîńčë îôčöĺđîâ äë˙ ńîďđîâîćäĺíč˙")
            wait(1500)
            sampSendChat("/do Äĺďŕđňŕěĺíň: Ďđčí˙ňî, îćčäŕéňĺ äâóő îôčöĺđîâ.")
            wait(1500)
            sampSendChat("/do Čç ó÷ŕńňęŕ âűőîä˙ň 2 îôčöĺđŕ, ďîńëĺ çŕáčđŕţň ďđĺńňóďíčęŕ.")
            sampSendChat("/arrest "..id.." ")
        end)
    end
   end

function cmd_stop(id)
        lua_thread.create(function()
            sampSendChat("/do Ěĺăŕôîí íŕőîäčňń˙ â áŕđäŕ÷ęĺ.")
            wait(1500)
            sampSendChat("/me äîńňŕë ěĺăŕôîí čç áŕđäŕ÷ęŕ, ďîäíĺń ĺăî ę đňó č íŕ÷ŕë ăîâîđčňü")
            wait(1500)
            sampSendChat("/m Âîäčňĺëü ňđŕíńďîđňíîăî ńđĺäńňâŕ, ďđčćěčňĺńü ę îáî÷číĺ č çŕăëóřčňĺ äâčăŕňĺëü...")
            wait(1500)
            sampSendChat("/m ...đóęč äĺđćčňĺ íŕ đóëĺ. Â ńëó÷ŕĺ íĺďîä÷číĺíč˙, ďî âŕě áóäĺň îňęđűň îăîíü")
            wait(1500)
            sampSendChat("/me çŕęîí÷čë ăîâîđčňü č óáđŕë ěĺăŕôîí â áŕđäŕ÷îę")
        end)
    end

function cmd_giverank(arg)
    lua_thread.create(function()
        local arg1, arg2 = arg:match('(.+) (.+)')  
        if arg1 ~= nil and arg2 ~= nil then
            sampSendChat('/giverank '..arg1..' '..arg2..'')
            wait(1500)
            sampSendChat("/do Â đóęŕő íŕőîäčňń˙ ďŕďęŕ ń áëŕíęŕěč.") 
            wait(1500) 
            sampSendChat("/do Ďŕďęŕ îňęđűňŕ č â íĺé íŕőîäčňń˙ áëŕíę î ďîâűřĺíčč ęâŕëčôčęŕöčč.") 
            wait(1500) 
            sampSendChat("/me ëîâęčě äâčćĺíčĺě đóęč äîńňŕĺň áëŕíę, č ďĺđĺäŕ¸ň ĺăî ÷ĺëîâĺęó") 
            wait(1500) 
            sampSendChat("/do Đó÷ęŕ íŕőîäčňń˙ â ăđóäíîě ęŕđěŕíĺ.") 
            wait(1500) 
            sampSendChat("/me áűńňđűě äâčćĺíčĺě đóęč äîńňŕĺň đó÷ęó č ňŕęćĺ ďĺđĺäŕ¸ň ÷ĺëîâĺęó") 
            wait(1500) 
            sampSendChat("/do Îçíŕęîěüňĺńü ń áëŕíęîě č âíčçó ďîńňŕâüňĺ ďîäďčńü.*çŕęđűâŕ˙ ďŕďęó ń áëŕíęŕěč") 
            wait(1500)
        else
            sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:{FFFFFF}/giverank [ID] [Đŕíă 1-9].",0x318CE7FF -1)
        end
    end)
end
 
function cmd_unmask(id)
    if id == nil or id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/unmask [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function() 
            sampSendChat("/me äĺđćŕ ďîäîçđĺâŕĺěîăî, ëĺâîé đóęîé íŕńčëüíî ńäčđŕĺň ěŕńęó ń ÷ĺëîâĺęŕ")
            wait(1500)
            sampSendChat("/unmask "..id.." ")
        end)
    end
end

function cmd_miranda()
lua_thread.create(function()
            sampSendChat("Âű čěĺĺňĺ ďđŕâî őđŕíčňü ěîë÷ŕíčĺ.")
            wait(1500)
            sampSendChat(" Âń¸, ÷ňî âű ńęŕćĺňĺ, ěű ěîćĺě č áóäĺě čńďîëüçîâŕňü ďđîňčâ âŕń â ńóäĺ.")
            wait(1500)
            sampSendChat(" Âű čěĺĺňĺ ďđŕâî íŕ ŕäâîęŕňŕ č íŕ îäčí ňĺëĺôîííűé çâîíîę.")
            wait(1500)
            sampSendChat(" Ĺńëč ó âŕń íĺň ŕäâîęŕňŕ, ăîńóäŕđńňâî ďđĺäîńňŕâčň âŕě ŕäâîęŕňŕ, óâčäĺňü ęîňîđîăî âű ńěîćĺňĺ â çŕëĺ ńóäŕ.")
            wait(1500)
            sampSendChat(" Âŕě ďîí˙ňíű âŕřč ďđŕâŕ?")
        end)
     end

function cmd_bodyon()

        lua_thread.create(function()
            sampSendChat("/do Íŕ ăđóäč  âĺńčň ęŕěĺđŕ AXON BODY 3.")
            wait(1500)
            sampSendChat("/me ëĺăęčě äâčćĺíčĺě đóęč ďđîň˙íóëń˙ ę ńĺíńîđó č íŕćŕë îäčí đŕç äë˙ ŕęňčâŕöčč")
            wait(1500)
            sampSendChat("/do Áîäč ęŕěĺđŕ čçäŕëŕ çâóę č âęëţ÷čëŕńü.")
        end)
     end

function cmd_bodyoff()

lua_thread.create(function()
            sampSendChat("/do Íŕ ăđóäč  âĺńčň ęŕěĺđŕ AXON BODY 3.")
            wait(1500)
            sampSendChat("/me ëĺăęčě äâčćĺíčĺě đóęč ďđîň˙íóëń˙ ę ńĺíńîđó č íŕćŕë îäčí đŕç äë˙ äĺŕęňčâŕöčč")
            wait(1500)
            sampSendChat("/do Áîäč ęŕěĺđŕ čçäŕëŕ çâóę č âűęëţ÷čëŕńü")
        end)
     end


function cmd_ticket(arg) 
    lua_thread.create(function() 
        local id, prichina, price = arg:match('(%d+)%s(%d+)%s(.)')
        if id ~= nil and prichina ~= nil and price ~= nil then
                sampSendChat("/me äîńňŕâ íĺáîëüřîé ňĺđěčíŕë, ďđčńîĺäčíčë ĺăî ę ĘĎĘ č ďîęŕçŕë ďđč¸ěíčę äë˙ ęŕđňű") 
                wait(1500) 
                sampSendChat("/todo Âńňŕâüňĺ ńíŕ÷ŕëŕ âîäčňĺëüńęóţ, çŕňĺě ęđĺäčňíóţ ęŕđňó â ďđč¸ěíčę!*äĺđćŕ ňĺđěčíŕë") 
                wait(1500)
                sampSendChat('/ticket '..id..' '..prichina..'  '..price..' ')
        else 
      sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/ticket [ID] [Ńóěěŕ] [Ďđč÷číŕ].", 0x318CE7FF)
      end 
     end)
    end

function cmd_pursuit(id)
    if id == "" then
         sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/pursuit [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
            sampSendChat("/me ďîëîćčâ đóęč íŕ ęëŕâčŕňóđó áîđňîâîăî ęîěďüţňĺđŕ, íŕ÷ŕë ďîčńę ďî áŕçĺ äŕííűő ďî čěĺíč")
            wait(1500)
            sampSendChat("/me íŕéä˙ čě˙, ďđîâĺđčë íîěĺđ ňĺëĺôîíŕ č âęëţ÷čë îňńëĺćčâŕíč˙ ďî ĂĎŃ")
            wait(1500)
            sampSendChat("/pursuit "..id.." ")
        end)
     end
  end

function cmd_drugtestno()
lua_thread.create(function()
            sampSendChat("/me äîńňŕë čç ďîäńóěęŕ íŕáîđ Drug-test")
            wait(1500)
            sampSendChat("/me âç˙ë čç íŕáîđŕ ďđîáčđęó ń ýňčëîâűě ńďčđňîě")
            wait(1500)
            sampSendChat("/me íŕńűďŕë â ďđîáčđęó íŕéäĺíîĺ âĺůĺńňâî")
            wait(1500)
            sampSendChat ("/me äîáŕâčë â ďđîáčđęó ňĺńň Čěóíî-Őđîě-10")
            wait(1700)
            sampSendChat("/me đĺçęčěč äâčćĺíč˙ěč âçáŕëňűâŕĺň ďđîáčđęó")
            wait(1700)
            sampSendChat("/do Ňĺńň äŕë îňđčöŕňĺëüíűé đĺçóëüňŕň, âĺůĺńňâî íĺ ˙âë˙ĺňń˙ íŕđęîňčęîě. ")
        end)
     end


function cmd_drugtestyes()
lua_thread.create(function()
            sampSendChat("/me äîńňŕë čç ďîäńóěęŕ íŕáîđ Drug-test")
            wait(1500)
            sampSendChat("/me âç˙ë čç íŕáîđŕ ďđîáčđęó ń ýňčëîâűě ńďčđňîě")
            wait(1500)
            sampSendChat("/me íŕńűďŕë â ďđîáčđęó íŕéäĺíîĺ âĺůĺńňâî")
            wait(1500)
            sampSendChat ("/me äîáŕâčë â ďđîáčđęó ňĺńň Čěóíî-Őđîě-10")
            wait(1700)
            sampSendChat("/me đĺçęčěč äâčćĺíč˙ěč âçáŕëňűâŕĺň ďđîáčđęó")
            wait(1700)
            sampSendChat("/do Ňĺńň äŕë ďîëîćčňĺëüíűé đĺçóëüňŕň, âĺůĺńňâî ˙âë˙ĺňń˙ íŕđęîňčęîě.")
        end)
     end

function cmd_vzatka()

lua_thread.create(function()
         sampSendChat("/me ńěîňđčň íŕ çŕäĺđćŕííîăî, äîńňŕ¸ň ń áŕđäŕ÷ęŕ đó÷ęó č ëčńňî÷ĺę.")
         wait(1500)
         sampSendChat("/me ďčřĺň íŕ ëčńňî÷ęĺ ńóěěó ń řĺńňüţ íóë˙ěč, ęčäŕĺň íŕ çŕäíĺĺ ńčäĺíüĺ.")
         wait(1500)
         sampSendChat("/do Íŕ ëčńňî÷ęĺ íĺáđĺćíî č ęîđ˙âî áűëî íŕďčńŕíî: 3.000.000$.")
      end)
   end


function cmd_bomb()
lua_thread.create(function()

         sampSendChat("/do Ďĺđĺä ÷ĺëîâĺęîě íŕőîäčňń˙ áîěáŕ, íŕ áîěáĺ çŕâĺäĺí ňŕéěĺđ.")
         wait(1500)
         sampSendChat("/do Íŕ áđîíĺćčëĺňĺ çŕęđĺďëĺíŕ íĺáîëüřŕ˙ ńóěęŕ ńŕď¸đŕ.")
         wait(1500)
         sampSendChat("/me îňęđűâ ńóěęó ďîň˙íóëń˙ çŕ ńďĺöčŕëüíűě ĘĎĘ äë˙ đŕçěčíčđîâŕíč˙ áîěá")
         wait(1500)
         sampSendChat("/me äîńňŕë ĘĎĘ čç ńóěęč âęëţ÷čë ĺăî, ńôîňîăđŕôčđîâŕë íŕ íĺăî áîěáó č ňŕéěĺđ, ...")
         wait(1500)
         sampSendChat("/me ... ďîńëĺ ńâ˙çŕâřčńü ń äčńďĺň÷ĺđîě ďĺđĺńëŕë ńäĺëŕííűĺ ńíčěęč")
         wait(1500)
         sampSendChat("/do [Äčńďĺň÷ĺđ]: - Ěű ďîëó÷čëč ńíčěęč, ňčď áîěáű PR-256, îăëŕřŕţ ďîđ˙äîę äĺéńňâčé.")
         wait(1500)
         sampSendChat("/do [Äčńďĺň÷ĺđ]: - Ę äŕííîěó ňčďó áîěáű ěîćíî ďîäęëţ÷čňüń˙ ďî ńĺňč, äĺéńňâóéňĺ.")
         wait(1500)
         sampSendChat("/me íŕćŕë â ĘĎĘ ęíîďęó search for the nearest device, ďîńëĺ ÷ĺăî ĘĎĘ íŕ÷ŕë ďîčńę")
         wait(1500)
         sampSendChat("/do ĘĎĘ âűäŕë óńňđîéńňâî INNPR-256NNI.")
         wait(1500)
         sampSendChat("/me ďîäęëţ÷čëń˙ ę óńňđîéńňâó, ďîńëĺ äîëîćčë îá ýňîě äčńďĺň÷ĺđó")
         wait(1500)
         sampSendChat("/do [Äčńďĺň÷ĺđ]: - Äŕ, âű ďîäęëţ÷čëčńü, ňĺďĺđü ââĺäčňĺ ęîä 1-0-5-J-J-Q-G-2-2.")
         wait(1500)
         sampSendChat("/me íŕ÷ŕë ââîäčňü ęîä íŕçâŕííűé äčńďĺň÷ĺđîě")
         wait(1500)
         sampSendChat("/do Ňŕéěĺđ íŕ áîěáĺ îńňŕíîâčëń˙.")
         wait(1500)
         sampSendChat("/todo Ďîëó÷čëîńü.*ăîâîđ˙ ďî đŕöčč ń äčńďĺň÷ĺđîě")
         wait(1500)
         sampSendChat("/do [Äčńďĺň÷ĺđ]: - Âŕřŕ ěčńńč˙ çŕâĺđřĺíŕ, âĺçčňĺ áîěáó â Îôčń, ęîíĺö ńâ˙çč.")
      end)
   end


function cmd_probiv()
lua_thread.create(function()

         sampSendChat("/do Íŕ ďî˙ńĺ âčńčň ëč÷íűé ĘĎĘ ńîňđóäíčęŕ.")
         wait(1500)
         sampSendChat("/me ńí˙ë ń ďî˙ńŕ ĘĎĘ , íŕ÷ŕë ďđîáčâŕňü ÷ĺëîâĺęŕ...")
         wait(1500)
         sampSendChat("/me ... ďî ĺăî ëčöó, ID-ęŕđňĺ , áĺéäćčęó č ćĺňîíó")
         wait(1500)
         sampSendChat("/do Íŕ ýęđŕíĺ ĘĎĘ âűńâĺňčëŕńü âń˙ číôîđěŕöč˙ î ÷ĺëîâĺęĺ.")
      end)
   end

function cmd_dismiss(arg) 
lua_thread.create(function() 
    local arg1, arg2 = arg:match('(.+) (.+)')   
    if arg1 ~= nil and arg2 ~= nil then 
   sampSendChat('/dismiss '..arg1..' '..arg2..'') 
   wait(1500) 
   sampSendChat("/do Â ďđŕâîě ęŕđěŕíĺ áđţę íŕőîäčňń˙ ĘĎĘ.")
   wait (1500)
   sampSendChat("/me äîńňŕë ĘĎĘ čç ďđŕâîăî ęŕđěŕíŕ, çŕňĺě íŕ÷ŕë ďđîáčâŕňü ďî áŕçĺ äŕííűő ńîňđóäíčęŕ ÷ĺđĺç ëčöî, ID ęŕđňó č ćĺňîí")
   wait(1500)
   sampSendChat("/do Íŕ ýęđŕíĺ ĘĎĘ ďî˙âčëŕńü ďîëíŕ˙ číôîđěŕöč˙ î ńîňđóäíčęĺ.")
   wait(1500)
   sampSendChat("/me íŕćŕë íŕ ęíîďęó Óâîëčňü čç Ăîń. Îđăŕíčçŕöčč")
   wait(1500)
   sampSendChat ("/do Ńîňđóäíčę áűë óäŕëĺí čç ńďčńęŕ 'Ăîń. Ńîňđóäíčęč'.")
   wait(1500)
   sampSendChat("/me óáđŕë ĘĎĘ îáđŕňíî â ďđŕâűé ęŕđěŕí") 
    else 
  sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:{FFFFFF} /dismiss [ID] [Ďđč÷číŕ].",0x318CE7FF -1) 
  end 
 end) 
end

function cmd_demoute(arg) 
lua_thread.create(function() 
    local arg1, arg2 = arg:match('(.+) (.+)')   
    if arg1 ~= nil and arg2 ~= nil then 
        sampSendChat('/demoute '..arg1..' '..arg2..'') 
  wait(1500) 
        sampSendChat("/do ĘĎĘ ëĺćčň â íŕăđóäíîě ęŕđěŕíĺ.") 
         wait(1500) 
         sampSendChat("/me íűđíóë đóęîé â ďđŕâűé ęŕđěŕí, ďîńëĺ ÷ĺăî äîńňŕë ĘĎĘ") 
         wait(1500) 
         sampSendChat("/me îňęđűë â ĘĎĘ áŕçó äŕííűő ńîňđóäíčęîâ Ăîńńóäŕđńňâĺííűő ńňđóęňóđ, ďîńëĺ ÷ĺăî íŕćŕë íŕ ęíîďęó Demoute") 
         wait(1500) 
         sampSendChat("/do Ńîňđóäíčę óńďĺříî óäŕëĺí čç áŕçű äŕííűő ăîńńóäŕđńňâĺííűő ńňđóęňóđ")
    else 
  sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:{FFFFFF} /demoute [ID] [Ďđč÷číŕ].",0x318CE7FF -1) 
  end 
 end) 
end

function cmd_cure(id)
    if id == "" then   
             sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/cure [ID].", 0x318CE7FF)
    else
        lua_thread.create(function() 
             sampSendChat("/todo ×ňî-ňî ĺěó âîîáůĺ ďëîőî*ńíčěŕ˙ ěĺäčöčíńęóţ ńóěęó ń ďëĺ÷ŕ")
             wait(1500)
             sampSendChat("/me ńňŕâčň ěĺäčöčíńęóţ ńóěęó âîçëĺ ďîńňđŕäŕâřĺăî")
             wait(1500)
             sampSendChat("/do Ěĺä.ńóěęŕ íŕ çĺěëĺ.")
             wait(1500)
             sampSendChat("/me íŕęëîí˙ĺňń˙ íŕä ňĺëîě, çŕňĺě ďđîůóďűâŕĺň ďóëüń íŕ ńîííîé ŕđňĺđčč")
             wait(1500)
             sampSendChat("/do Ďóëüń Îňńóňńňâóĺň.")
             wait(1500)
             sampSendChat("/me íŕ÷číŕĺň íĺďđ˙ěîé ěŕńńŕć ńĺđäöŕ, âđĺě˙ îň âđĺěĺíč ďđîâĺđ˙˙ ďóëüń")
             wait(1500)
             sampSendChat("/do Ńďóńň˙ íĺńęîëüęî ěčíóň ńĺđäöĺ ďŕöčĺíňŕ íŕ÷ŕëîńü áčňüń˙.")
             wait(1500)
             sampSendChat("/cure "..id.." ")
         end)
      end
   end


function cmd_find(id)
    if id == "" then
         sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/find [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/do ĘĎĘ â ëĺâîě ęŕđěŕíĺ.")
         wait(1500)
         sampSendChat("/me äîńňŕë ëĺâîé đóęîé ĘĎĘ čç ęŕđěŕíŕ")
         wait(1500)
         sampSendChat("/do ĘĎĘ â ëĺâîé đóęĺ.")
         wait(1500)
         sampSendChat("/me âęëţ÷čë ĘĎĘ č çŕřĺë â áŕçó äŕííűő Ďîëčöčč")
         wait(1500)
         sampSendChat("/me îňęđűë äĺëî ń äŕííűěč ďđĺńňóďíčęŕ")
         wait(1500)
         sampSendChat("/do Äŕííűĺ ďđĺńňóďíčęŕ ďîëó÷ĺíű.")
         wait(1500)
         sampSendChat("/me ďîäęëţ÷čëń˙ ę ęŕěĺđŕě ńëĺćĺíč˙ řňŕňŕ")
         wait(1500)
         sampSendChat ("/do Íŕ íŕâčăŕňîđĺ ďî˙âčëń˙ ěŕđřđóň.")
         wait(1500)
         sampSendChat("/find "..id.." ")
      end)
   end
end

function cmd_zsu(arg)
lua_thread.create(function()
    local arg1, arg2, arg3 = arg:match('(.+) (.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
        sampSendChat('/r Çŕďđŕřčâŕţ îáü˙âëĺíčĺ â đîçűńę äĺëî N-'..arg1..'.')
		wait(2500)
		sampSendChat('/r Ďî ďđč÷číĺ - ' ..arg3..'. '..arg2..' Ńňĺďĺíü.')
    else
		sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/zsu [ID] [Ęîë-âî đîçűńęŕ] [Ďđč÷číŕ].",0x318CE7FF -1)
		end
	end)
end

function cmd_incar(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')  
    if arg1 ~= nil and arg2 ~= nil then
        sampSendChat('/incar '..arg1..' '..arg2..'')
  wait(1500)
  sampSendChat('/me îňęđűë çŕäíţţ äâĺđü â ěŕřčíĺ')
  wait(1500)
  sampSendChat('/me ďîńŕäčë ďđĺńňóďíčęŕ â ěŕřčíó')
  wait(1500)
  sampSendChat('/me çŕáëîęčđîâŕë äâĺđč')
    else
  sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:{FFFFFF}/incar [ID] [Ěĺńňî 1-4].",0x318CE7FF -1)
  end
 end)
end

function cmd_eject(id)
    if id == "" then
        sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ:: {FFFFFF}/eject [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me îňęđűë äâĺđü ŕâňî, ďîńëĺ âűáđîńčë ÷ĺëîâĺęŕ čç ŕâňî")
            wait(1500)
            sampSendChat("/eject "..id.." ")
            wait(1500)
            sampSendChat("/me çŕęđűë äâĺđü ŕâňî")
      end)
   end
end

function cmd_pog(id)
    if id == "" then
         sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/pog [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/m Âîäčňĺëü, îńňŕíîâčňĺ ňđŕíńďîđňíîĺ ńđĺäńňâî, çŕăëóřčňĺ äâčăŕňĺëü...")
         wait(1500)
         sampSendChat("/m Číŕ÷ĺ ˙ îňęđîţ îăîíü ďî âŕřĺěó ňđŕíńďîđňó!")
      end)
   end
end

function cmd_tencodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ńďčńîę ŕęňčâíűő ňĺí-ęîäîâ", "10-1 - Âńňđĺ÷ŕ âńĺő îôčöĺđîâ íŕ äĺćóđńňâĺ (âęëţ÷ŕ˙ ëîęŕöčţ č ęîä).\n10-3 - Đŕäčîěîë÷ŕíčĺ (äë˙ ńđî÷íűő ńîîáůĺíčé).\n10-4 - Ďđčí˙ňî.\n10-5 - Ďîâňîđčňĺ ďîńëĺäíĺĺ ńîîáůĺíčĺ.\n10-6 - Íĺ ďđčí˙ňî/íĺâĺđíî/íĺň.\n10-7 - Îćčäŕéňĺ.\n10-8 - Â íŕńňî˙ůĺĺ âđĺě˙ çŕí˙ň/íĺ äîńňóďĺí.\n10-14 - Çŕďđîń ňđŕíńďîđňčđîâęč (âęëţ÷ŕ˙ ëîęŕöčţ č öĺëü ňđŕíńďîđňčđîâęč).\n10-15 - Ďîäîçđĺâŕĺěűĺ ŕđĺńňîâŕíű (âęëţ÷ŕ˙ ęîë-âî ďîäîçđĺâŕĺěűő, ëîęŕöčţ).\n10-18 - Ňđĺáóĺňń˙ ďîääĺđćęŕ äîďîëíčňĺëüíűő ţíčňîâ.\n10-20 - Ëîęŕöč˙.\n10-21 - Ńîîáůĺíčĺ î ńňŕňóńĺ č ěĺńňîíŕőîćäĺíčč, îďčńŕíčĺ ńčňóŕöčč.\n10-22 - Íŕďđŕâë˙éňĺńü â 'ëîęŕöč˙' (îáđŕůĺíčĺ ę ęîíęđĺňíîěó îôčöĺđó).\n10-27 - Ěĺí˙ţ ěŕđęčđîâęó ďŕňđóë˙ (âęëţ÷ŕ˙ ńňŕđóţ č íîâóţ ěŕđęčđîâęó).\n10-46 - Ďđîâîćó îáűńę.\n10-55 - Ňđŕôôčę ńňîď.\n10-66 - Îńňŕíîâęŕ ďîâűřĺííîăî đčńęŕ (ĺńëč čçâĺńňíî, ÷ňî ďîäîçđĺâŕĺěűé â ŕâňî âîîđóćĺí/ńîâĺđřčë ďđĺńňóďëĺíčĺ. Ĺńëč îńňŕíîâęŕ ďđîčçîřëŕ ďîńëĺ ďîăîíč).\n10-88 - Ňĺđŕęň/×Ń.\n10-99 - Ńčňóŕöč˙ óđĺăóëčđîâŕíŕ\n10-100 Âđĺěĺííî íĺäîńňóďĺí äë˙ âűçîâîâ\nŔâňîđ:t.me/Sashe4ka_ReZoN", "Çŕęđűňü", "Exit", 0)
        end)
        end

function cmd_marks(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ěŕđęčđîâęč íŕ ŕâňî", "ADAM [A] Ěŕđęčđîâęŕ ţíčňŕ, ńîńňî˙ůĺăî čç äâóő îôčöĺđîâ.\nLINCOLN [L] Ěŕđęčđîâęŕ ţíčňŕ, ńîńňî˙ůĺăî čç îäíîăî îôčöĺđŕ.\nAIR [AIR] Ěŕđęčđîâęŕ âîçäóříîăî ţíčňŕ, â ńîńňŕâĺ äâóő îôčöĺđîâ\nAir Support Division [ASD] Ěŕđęčđîâęŕ ţíčňŕ âîçäóříîé ďîääĺđćęč.\nMARY [M] Ěŕđęčđîâęŕ ěîňî-ďŕňđóë˙.\nHENRY [H] Ěŕđęčđîâęŕ âűńîęî - ńęîđîńňíîăî ţíčňŕ, ńîńňî˙ůĺăî čç îäíîăî čëč äâóő îôčöĺđ.\nCHARLIE [C] Ěŕđęčđîâęŕ ăđóďďű çŕőâŕňŕ.\nROBERT [R] Ěŕđęčđîâęŕ îňäĺëŕ äĺňĺęňčâîâ.\nSUPERVISOR [SV] Ěŕđęčđîâęŕ đóęîâîä˙ůĺăî ńîńňŕâŕ (STAFF).\nDavid [D] Ěŕđęčđîâęŕ ńďĺö.îňäĺëŕ\nĘŕćäűé îôčöĺđ ďđč âűőîäĺ â ďŕňđóëü, îá˙çŕí ďîńňŕâčňü ěŕđęčđîâęó íŕ ńâîé ęđóçĺđ (/vdesc)\nŔâňîđ:t.me/Sashe4ka_ReZoN", "Çŕęđűňü", "Exit", 0)
         end)
         end

function cmd_sitcodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ńčňóŕöčîííűĺ ęîäű", "CODE 0 - Îôčöĺđ đŕíĺí.\nCODE 1 - Îôčöĺđ â áĺäńňâĺííîě ďîëîćĺíčč.\nCODE 2 - Îáű÷íűé âűçîâ ń íčçęčě ďđčîđčňĺňîě. Áĺç âęëţ÷ĺíč˙ ńčđĺí č ńďĺö.ńčăíŕëîâ, ńîáëţäŕ˙ ĎÄÄ.\nCODE 2 HIGH - Ďđčîđčňĺňíűé âűçîâ. Âń¸ ňŕę ćĺ áĺç âęëţ÷ĺíč˙ ńčđĺí č ńďĺö.ńčăíŕëîâ, ńîáëţäŕ˙ ĎÄÄ.\nCODE 3 - Ńđî÷íűé âűçîâ. Čńďîëüçîâŕíčĺ ńčđĺí č ńďĺö.ńčăíŕëîâ, čăíîđčđîâŕíčĺ íĺęîňîđűő ďóíęňîâ ĎÄÄ.\nCODE 4 - Ďîěîůü íĺ ňđĺáóĺňń˙.\nCODE 4 ADAM - Ďîěîůü íĺ ňđĺáóĺňń˙ â äŕííűé ěîěĺíň âđĺěĺíč. Îôčöĺđű íŕőîä˙ůčĺń˙ ďî áëčçîńňč äîëćíű áűňü ăîňîâű îęŕçŕňü ďîěîůü.\nCODE 7 - Ďĺđĺđűâ íŕ îáĺä.\nCODE 30 - Ńđŕáŕňűâŕíčĺ 'ňčőîé' ńčăíŕëčçŕöčč íŕ ěĺńňĺ ďđîčńřĺńňâč˙.\nCODE 30 RINGER - Ńđŕáŕňűâŕíčĺ 'ăđîěęîé' ńčăíŕëčçŕöčč íŕ ěĺńňĺ ďđîčńřĺńňâč˙.\nCODE 37 - Îáíŕđóćĺíčĺ óăíŕííîăî ňđŕíńďîđňíîăî ńđĺäńňâŕ. Íĺîáőîäčěî óęŕçŕňü íîěĺđ, îďčńŕíčĺ ŕâňîěîáčë˙, íŕďđŕâëĺíčĺ äâčćĺíč˙.\nŔâňîđ:t.me/Sashe4ka_ReZoN", "Çŕęđűňü", "Exit", 0)
         end)
         end

function cmd_pas(arg)
 lua_thread.create(function()
  if tonumber(arg) == nil then
  sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ : {FFFFFF}/pas [ID].", 0x318CE7FF -1)
  else
  id = arg
  sampSendChat('Çäđŕâńňâóéňĺ, íŕäĺţńü âŕń íĺ áĺńďîęîţ.')
  wait(1500)
  sampSendChat('/do Ńëĺâŕ íŕ ăđóäč ćĺňîí ďîëčöĺéńęîăî, ńďđŕâŕ - čěĺííŕ˙ íŕřčâęŕ ń ôŕěčëčĺé.')
  wait(1500)
  sampSendChat('/showbadge '..id) 
  wait(1500)
  sampSendChat('Ďđîřó ďđĺäü˙âčňü äîęóěĺíň óäîńňîâĺđ˙ţůčé âŕřó ëč÷íîńňü.')
  end
 end)
end

function cmd_clear(arg)
  if tonumber(arg) == nil then
   sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF} /clear [ID].", 0x318CE7FF -1)  
  else
  lua_thread.create(function()
  id = arg
  sampSendChat("/me íŕćŕâ íŕ ňŕíăĺíňó, ńîîáůčë äčńďĺň÷ĺđó čě˙ ÷ĺëîâĺęŕ, ęîňîđűé áîëĺĺ íĺ ÷čńëčëń˙ â đîçűńęĺ")
  wait(1500)
  sampSendChat('/clear '..id)
  end)
 end
end

function cmd_take(id)
    if id == "" then   
             sampAddChatMessage("Ââĺäč ŕéäč čăđîęŕ: {FFFFFF}/take [ID].", 0x318CE7FF)
    else
        lua_thread.create(function() 
             sampSendChat("/do Íŕ đóęŕő îďĺđŕňčâíčęŕ íŕäĺňű đĺçčíîâűĺ ďĺđ÷ŕňęč.")
             wait(1500)
             sampSendChat("/me ďîńëĺ îáűńęŕ čçú˙ë çŕďđĺů¸ííűĺ âĺůč")
             wait(1500)
             sampSendChat("/do Ďŕęĺňčę äë˙ óëčę â ęŕđěŕíĺ.")
             wait(1500)
             sampSendChat("/me äîńňŕë ďŕęĺňčę äë˙ óëčę, ďîńëĺ ÷ĺăî ďîëîćčë ňóäŕ çŕďđĺů¸ííűĺ âĺůč")
             wait(1500)
             sampSendChat("/me ďîëîćčë ďŕęĺň ń óëčęŕěč â ęŕđěŕřĺę")
             wait(1500)
             sampSendChat("/do Ďŕęĺň ń óëčęŕěč â ęŕđěŕíĺ.")
             wait(1500)
             sampSendChat("/take "..id.." ")
         end)
      end
   end

function cmd_time()
        lua_thread.create(function()
		sampSendChat("/me ďîäí˙ë đóęó č ďîńěîňđĺë íŕ ÷ŕńű áđĺíäŕ  Rolex")
		wait(1500)
		sampSendChat("/time")
		sampSendChat('/do Íŕ ÷ŕńŕő '..os.date('%H:%M:%S'))
        end)

    end

function cmd_pravda_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do Â äîďđîńíîé ńňî˙ë řęŕô÷čę, îí áűë çŕęđűň íŕ ýëĺęňđîííűé çŕěîę.")
		wait(1500)
		sampSendChat("/me ďîäîřĺë ę řęŕô÷čęó, íŕáđŕë ęîä, îňęđűâ řęŕô÷čę âç˙ë îň ňóäŕ íĺ ďđîçđŕ÷íóţ ÷ĺđíóţ ďŕďęó.")
		wait(1500)
		sampSendChat("/me ďîäîřĺë ę ńňîëó, ďîëîćčë ďŕďęó íŕ íĺăî, îňęđűâ ĺĺ âç˙ë ăîňîâűé ëčńň ôîđěŕňŕ A4 ńî řňŕěďŕěč.")
		wait(1500)
		sampSendChat("/me ďîëîćčë ďĺđĺä çŕäĺđćŕííűě, ďîëîćčë đ˙äîě đó÷ęó.")
		wait(1500)
		sampSendChat("/do Đ˙äîě ëĺćŕë îáđŕçĺö.")
		wait(1500)
		sampSendChat("/do Â îáđŕçöĺ íŕďčńŕíî: 'ß Čě˙/Ôŕěčëč˙/Äŕňŕ đîćäĺíč˙' ")
		wait(1500)
		sampSendChat("/do 'ß íĺńó ďîëíóţ îňâĺňńňâĺííîńňü çŕ číôîđěŕöčţ ęîňîđóţ ˙ ďđîčçíĺń ďđč äîďđîńĺ")
		wait(1500)
		sampSendChat("/do â ńëó÷ŕĺ íĺďîäňâĺđćäĺíč˙ ěîčő ńëîâ ˙ ăîňîâ íĺńňč óăîëîâíóţ îňâĺňńňâĺííîńňü.' ")
		wait(1500)
		sampSendChat("Çŕďîëí˙ĺřü íŕ ÷čńňîě ęŕę ďî îáđŕçöó, íčćĺ ńňŕâčřü ďîäďčńü č äŕňó.")
	end)
end

function cmd_secret_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do Íŕ ńňîëĺ ëĺćčň äîęóěĺíň: \"Äîęóěĺíň î íĺđŕçăëŕřĺíčč äĺ˙ňĺëüíîńňč ÔÁĐ\"")
		wait(1500)
		sampSendChat("/do Đ˙äîě ń äîęóěĺíňîě ŕęęóđŕňíî đŕńďîëîćĺíŕ đó÷ęŕ ń çîëîňîé ăđŕâčđîâęîé \"ÔÁĐ\"")
		wait(1500)
		sampSendChat("/do Â äîęóěĺíňĺ íŕďčńŕíî: \"ß, (Čě˙ / Ôŕěčëč˙), ęë˙íóńü äĺđćŕňü âňŕéíĺ ňî, ...")
		wait(1500)
		sampSendChat("/do ... ÷ňî âčäĺë, âčćó, č áóäó âčäĺňü\"")
		wait(1500)
		sampSendChat("/do Íčćĺ íŕďčńŕíî: \"Ăîňîâ íĺńňč ďîëíóţ îňâĺňńňâĺííîńňü, č â ńëó÷ŕĺ ńâîĺăî íĺďîâčíîâĺíč˙, ...")
		wait(1500)
		sampSendChat("/do ... ăîňîâ áűňü ŕđĺńňîâŕííűě č îňńňđŕíĺííűě îň äîëćíîńňč, ďđč íŕëč÷čč ňŕęîâîé\"")
		wait(1500)
		sampSendChat("/do Ĺůĺ íčćĺ íŕďčńŕíî: \"Äŕňŕ: ; Ďîäďčńü: \"")
	end)
end

function cmd_finger_person(id)
	lua_thread.create(function ()
		sampSendChat("/do Çŕ ńďčíîé ŕăĺíňŕ íŕőîäčňń˙ íĺáîëüřŕ˙ ńďĺö. ńóěęŕ.")
		wait(1500)
		sampSendChat("/me ńí˙ë ńďĺö. ńóěęó ńî ńďčíű, ďîńëĺ ďîëîćčë ĺ¸ íŕ đîâíóţ ďîâĺđőíîńňü")
		wait(1500)
		sampSendChat("/do Â ńďĺö. ńóěęĺ čěĺĺňń˙: ďóäđŕ č ęčńňî÷ęŕ äë˙ ĺ¸ íŕíĺńĺíč˙, ńďĺö. ďë¸íęŕ.")
		wait(1500)
		sampSendChat("/me âç˙ë áŕíî÷ęó ń ďóäđîé, îňęđűâ ĺ¸ ŕęęóđŕňíî íŕíîńčň ďóäđó íŕ ďŕëüöű ÷ĺëîâĺęŕ íŕďđîňčâ")
		wait(1500)
		sampSendChat("/do Ďŕëüöű ÷ĺëîâĺęŕ íŕďđîňčâ ďîęđűňű ďóäđîé.")
		wait(1500)
		sampSendChat("/me äîńňŕë čç ńďĺö. ńóěęč ńďĺöčŕëüíóţ ďë¸íęó, çŕňĺě ďđčęëĺčâŕĺň ĺ¸ íŕ ďŕëüöű ÷ĺëîâĺęó")
		wait(1500)
		sampSendChat("/do Îňďĺ÷ŕňîę ôčęńčđóĺňń˙ íŕ ďë¸íęĺ.")
		wait(1500)
		sampSendChat("/me ŕęęóđŕňíî ńí˙â ďë¸íęó ń ďŕëüöĺâ ÷ĺëîâĺęŕ, ďîěĺůŕĺň ĺĺ â ńďĺö. ďŕęĺňčę")
		wait(1500)
		sampSendChat("/do Â ńďĺö. ďŕęĺňčęĺ íŕőîäčňń˙ ďë¸íęŕ ń ďŕëüöĺâ ÷ĺëîâĺęŕ.")
		wait(1500)
		sampSendChat("/me ďîëîćčë ńďĺö. ďŕęĺňčę â çŕäíčé ęŕđěŕí áđţę, áĺđ¸ň â đóęč áŕíî÷ęó ń ďóäđîé ...")
		wait(1500)
		sampSendChat("/me ... č ęčńňî÷ęó, óáčđŕĺň čő â ńďĺö. ńóěęó, ďîńëĺ çŕęđűâŕĺň ĺ¸")
		wait(1500)
		sampSendChat("/do Ńďĺö. ďŕęĺňčę ëĺćčň â çŕäíĺě ęŕđěŕíĺ áđţę, ńďĺö. ńóěęŕ çŕęđűňŕ.")
	end)
end

function cmd_warn()
	lua_thread.create(function ()
		sampSendChat("/r  Ěíĺ ňđĺáóĺňń˙ ďîäěîăŕ. Íŕéäčňĺ ěĺí˙ ďî ćó÷ęó  ")
	end)
end

function cmd_grim()
    lua_thread.create(function ()
    sampSendChat("/do Â řęŕô÷čęĺ ńňîčň íŕáîđ äë˙ ďđîôĺńńčîíŕëüíîăî ăđčěŕ.")
    wait(1500)
    sampSendChat("/me îňęđűë řęŕô÷čę č äîńňŕâ čç íĺăî íŕáîđ äë˙ ăđčěŕ, ďîńňŕâčë ĺăî íŕ řęŕô÷čę č îňęđűë")
    wait(1500)
    sampSendChat("/do Íŕáîđ äë˙ ăđčěŕ îňęđűň.")
    wait(1500)
    sampSendChat("/do Íŕä řęŕô÷čęîě âĺńčň çĺđęŕëî.")
    wait(1500)
    sampSendChat("/me đŕńńěŕňđčâŕ˙ íŕáîđ, âç˙ë áîëüřóţ ęčńňü č îęóíóâ ĺ¸ â ň¸ěíűé öâĺň, íŕ÷ŕë íŕíîńčňü ĺăî íŕ ëčöî, ńěîňđ˙ â çĺđęŕëî")
    wait(1500)
    sampSendChat("/me âç˙â ňîíęóţ ęčńňî÷ęó, îęóíóë ĺ¸ â đóě˙í č íŕ÷ŕë íŕíîńčňü íŕ ëčöî")
   wait(1500)
   sampSendChat("/me íŕđčńîâŕâ íŕ ëčöĺ ńęóëű, îęóíóë ęčńňî÷ęó â ň¸ěíóţ ňĺíü č íŕí¸ń čő íŕ ëčöî")
   wait(1500)
   sampSendChat("/me âç˙ë ęčńňü č îęóíóâ ĺ¸ â ň¸ěíóţ ďóäđó č íŕí¸ń ĺ¸ íŕ ëčöî")
   wait(1500)
   sampSendChat("/me ďîëîćčë ęčńňč â îňńĺę äë˙ číńňđóěĺíňîâ č çŕęđűë íŕáîđ")
   wait(1500)
   sampSendChat("/me óáđŕë íŕáîđ â řęŕô÷čę č çŕęđűë ĺăî")
   wait(1500)
   sampSendChat("/do Íŕ ëčöĺ íŕíĺń¸í ăđčě.")
       end)
end

function cmd_eks()
    lua_thread.create(function ()
    sampSendChat ("/do Â ęŕđěŕíĺ ďčäćŕęŕ ëĺćŕň đĺçčíîâűĺ ďĺđ÷ŕňęč.")
wait(1500)
sampSendChat ("/me ďđŕâîé đóęîé äîńňŕë čç ęŕđěŕíŕ ďĺđ÷ŕňęč č íŕäĺë čő íŕ ęčńňč đóę")
wait(1500)
sampSendChat("/do Íŕ ńňîëĺ ëĺćčň îđóćčĺ, ďîëîńęŕ č ëčńň áĺëîé áóěŕăč, äâĺ ńňîéęč ń ďđîáčđęŕěč.")
wait(1500)
sampSendChat("/me îńěîňđĺë îđóćčĺ č ŕęęóđŕňíî đŕçîáđŕë ĺăî íŕ îňäĺëüíűĺ ÷ŕńňč")
wait(1500)
sampSendChat("/me âç˙ë â đóęč çŕňâîđ č ďîëîńęó áóěŕăč, ďîěĺńňčë ďîëîńęó â çŕäíčé ńđĺç ďŕňđîííčęŕ")
wait(1500)
sampSendChat("/me óáđŕë ďîëîńęó áóěŕăč čç çŕňâîđŕ")
wait(1500)
sampSendChat("/do Íŕ ďîëîńęĺ áóěŕăč îńňŕëčńü ńëĺäű íŕăŕđŕ îň íĺ ńăîđĺâřĺăî ďîđîőŕ.")
wait(1500)
sampSendChat("/me âűňđ˙őíóë ÷ŕńňčöű ń ďîëîńęč íŕ ëčńň áóěŕăč")
wait(1500)
sampSendChat("/me âç˙ë ďđîáčđęó ńî ńňîéęč č ďĺđĺńűďŕë ńîäĺđćčěîĺ ń ëčńňŕ â ďđîáčđęó")
wait(1500)
sampSendChat("/me çŕęđűë ďđîáčđęó č ďîńňŕâčë íŕ äđóăóţ ńňîéęó")
wait(1500)
sampSendChat("/me âç˙ë â đóęč ęđűřęó ńňâîëüíîé ęîđîáęč č ďđîńěîňđĺë ńĺđčéíűé íîěĺđ îđóćč˙")
wait(1500)
sampSendChat("/me âęëţ÷čë ęîěďüţňĺđ č îňęđűë áŕçó äŕííűő, â ďîčńęîâóţ ńňđîęó ââ¸ë íîěĺđ îđóćč˙")
wait(1500)
sampSendChat("/do Íŕ ýęđŕíĺ âűńâĺňčëŕńü číôîđěŕöč˙ îá îđóćčč č âëŕäĺëüöĺ.")
wait(1500)
sampSendChat("/me ďîëîćčë ęđűřęó ńňâîëüíîé ęîđîáęč îáđŕňíî íŕ ńňîë")
wait(1500)
sampSendChat("/me ńîáđŕë îđóćčĺ â öĺëîĺ, äîńňŕë čç ˙ůčęŕ ďđîçđŕ÷íűé ńďĺö.ďŕęĺň č ďîěĺńňčë â íĺăî îđóćčĺ")
wait(1500)
sampSendChat("/me âç˙ë ńî ńňîëŕ ôëîěŕńňĺđ č ďîěĺňčë čě ńďĺö.ďŕęĺň, óáđŕë ôëîěŕńňĺđ â ˙ůčę č çŕęđűë ĺăî")
       end)
end

local secondFrame = imgui.OnFrame(
    function() return windowTwo[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Âűäŕ÷ŕ đîçűńęŕ", windowTwo)
        imgui.InputInt(u8 'ID čăđîęŕ ń ęîňîđűě áóäĺňĺ âçŕčěîäĺéńňâîâŕňü', id,10)
        for i = 1, #tableUk["Text"] do
            if imgui.Button(u8(tableUk["Text"][i] .. ' Óđîâĺíü đîçűńęŕ: ' .. tableUk["Ur"][i])) then
                lua_thread.create(function()
                    sampSendChat("/do Đŕöč˙ âčńčň íŕ áđîíĺćĺëĺňĺ.")
                    wait(1500)
                    sampSendChat("/me ńîđâŕâ ń ăđóäíîăî äĺđćŕňĺë˙ đŕöčţ, ńîîáůčë äŕííűĺ î ńŕďĺęňĺ")
                    wait(1500)
                    sampSendChat("/su " .. id[0] .. " " .. tableUk["Ur"][i] .. " " .. tableUk["Text"][i])
                    wait(1500)
                    sampSendChat("/do Ńďóńň˙ âđĺě˙ äčńďĺň÷ĺđ îáú˙âčë ńŕďĺęňŕ â ôĺäĺđŕëüíűé đîçűńę.")
                end)
            end
        end
        imgui.End()
    end
)

local thirdFrame = imgui.OnFrame(
    function() return leaderPanel[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Ďŕíĺëü ëčäĺđŕ/çŕěĺńňčňĺë˙", leaderPanel)
        imgui.InputInt(u8'ID čăđîęŕ ń ęîňîđűě őîňčňĺ âçŕčěîäĺéńňâîâŕňü', id, 10)
        if imgui.Button(u8'Óâîëčňü ńîňđóäíčęŕ') then
            lua_thread.create(function ()
                sampSendChat("/do ĘĎĘ âĺńčň íŕ ďî˙ńĺ.")
                wait(1500)
                sampSendChat("/me ńí˙ë ĘĎĘ ń ďî˙ńŕ č çŕřĺë â ďđîăđŕěěó óďđŕâëĺíč˙")
                wait(1500)
                sampSendChat("/me íŕřĺë â ńďčńęĺ ńîňđóäíčęŕ č íŕćŕë íŕ ęíîďęó Óâîëčňü")
                wait(1500)
                sampSendChat("/do Íŕ ĘĎĘ âűńâĺňčëŕńü íŕäďčńü 'Ńîňđóäíčę óńďĺříî óâîëĺí!'")
                wait(1500)
                sampSendChat("/me âűęëţ÷čë ĘĎĘ č ďîâĺńčë îáđŕňíî íŕ ďî˙ń")
                wait(1500)
                sampSendChat("Íó ÷ňî ć, âű óâîëĺííű. Îńňŕâüňĺ ďîăîíű â ěîĺě ęŕáčíĺňĺ.")
                wait(1500)
                sampSendChat("/uninvite".. id[0])
            end)
        end

        if imgui.Button(u8'Ďđčí˙ňü ăđŕćäŕíčíŕ') then
            lua_thread.create(function ()
                sampSendChat("/do ĘĎĘ âĺńčň íŕ ďî˙ńĺ.")
                wait(1500)
                sampSendChat("/me ńí˙ë ĘĎĘ ń ďî˙ńŕ č çŕřĺë â ďđîăđŕěěó óďđŕâëĺíč˙")
                wait(1500)
                sampSendChat("/me çŕřĺë â ňŕáëčöó č ââĺë äŕííűĺ î íîâîě ńîňđóäíčęĺ")
                wait(1500)
                sampSendChat("/do Íŕ ĘĎĘ âűńâĺňčëŕńü íŕäďčńü: 'Ńîňđóäíčę óńďĺříî äîáŕâëĺí! Ďîćĺëŕéňĺ ĺěó őîđîřĺé ńëóćáű :)'")
                wait(1500)
                sampSendChat("/me âűęëţ÷čë ĘĎĘ č ďîâĺńčë îáđŕňíî íŕ ďî˙ń")
                wait(1500)
                sampSendChat("Ďîçäđîâë˙ţ, âű ďđčí˙ňű! Ôîđěó âîçüěĺňĺ â đŕçäĺâŕëęĺ.")
                wait(1500)
                sampSendChat("/invite".. id[0])
            end)
        end

        if imgui.Button(u8'Âűäŕňü âűăîâîđ ńîňđóäíčęó') then
            lua_thread.create(function ()
                sampSendChat("/do ĘĎĘ âĺńčň íŕ ďî˙ńĺ.")
                wait(1500)
                sampSendChat("/me ńí˙ë ĘĎĘ ń ďî˙ńŕ č çŕřĺë â ďđîăđŕěěó óďđŕâëĺíč˙")
                wait(1500)
                sampSendChat("/me íŕřĺë â ńďčńęĺ ńîňđóäíčęŕ č íŕćŕë íŕ ęíîďęó Âűäŕňü âűăîâîđ")
                wait(1500)
                sampSendChat("/do Íŕ ĘĎĘ âűńâĺňčëŕńü íŕäďčńü: 'Âűăîâîđ âűäŕí!'")
                wait(1500)
                sampSendChat("/me âűęëţ÷čë ĘĎĘ č ďîâĺńčë îáđŕňíî íŕ ďî˙ń")
                wait(1500)
                sampSendChat("Íó ÷ňî ć, âűăîâîđ âűäŕí. Îňđŕáŕňűâŕéňĺ.")
                wait(1500)
                sampSendChat("/fwarn".. id[0])
            end)
        end

        if imgui.Button(u8'Ńí˙ňü âűăîâîđ ńîňđóäíčęó') then
            lua_thread.create(function ()
                sampSendChat("/do ĘĎĘ âĺńčň íŕ ďî˙ńĺ.")
                wait(1500)
                sampSendChat("/me ńí˙ë ĘĎĘ ń ďî˙ńŕ č çŕřĺë â ďđîăđŕěěó óďđŕâëĺíč˙")
                wait(1500)
                sampSendChat("/me íŕřĺë â ńďčńęĺ ńîňđóäíčęŕ č íŕćŕë íŕ ęíîďęó Ńí˙ňü âűăîâîđ")
                wait(1500)
                sampSendChat("/do Íŕ ĘĎĘ âűńâĺňčëŕńü íŕäďčńü: 'Âűăîâîđ ńí˙ň!'")
                wait(1500)
                sampSendChat("/me âűęëţ÷čë ĘĎĘ č ďîâĺńčë îáđŕňíî íŕ ďî˙ń")
                wait(1500)
                sampSendChat("Íó ÷ňî ć, îňđŕáîňŕëč.")
                wait(1500)
                sampSendChat("/unfwarn" .. id[0])
            end)
        end
        imgui.End()
    end
)

local setUkFrame = imgui.OnFrame(
    function() return setUkWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 700), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Íŕńňđîéęŕ óěíîăî đîçűńęŕ", setUkWindow)
            if imgui.BeginChild('Name', imgui.ImVec2(700, 500), true) then
                for i = 1, #tableUk["Text"] do 
                    imgui.Text(u8(tableUk["Text"][i] .. ' Óđîâĺíü đîçűńęŕ: ' .. tableUk["Ur"][i]))
                    Uk = #tableUk["Text"]
                end
                imgui.EndChild()
            end
            if imgui.Button(u8'Äîáŕâčňü', imgui.ImVec2(500, 36)) then
                addUkWindow[0] = not addUkWindow[0]
            end
            if imgui.Button(u8'Óäŕëčňü', imgui.ImVec2(500, 36)) then
                Uk = #tableUk["Text"]
            	table.remove(tableUk.Text, #tableUk.Text)
                table.remove(tableUk.Ur, #tableUk.Ur)
            	encodedTable = encodeJson(tableUk)
                local file = io.open("smartUk.json", "w")
                file:write(encodedTable)
                file:flush()
                file:close()
                
                
				
            end
        imgui.End()
    end
)

local addUkFrame = imgui.OnFrame(
    function() return addUkWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Íŕńňđîéęŕ óěíîăî đîçűńęŕ", addUkWindow)
            imgui.InputText(u8'Ňĺęńň ńňŕňüč(ń íîěĺđîě.)', newUkInput, 255)
            newUkName = u8:decode(ffi.string(newUkInput))
            imgui.InputInt(u8'Óđîâĺíü đîçűńęŕ(ňîëüęî öčôđŕ)', newUkUr, 10)
            if imgui.Button(u8'Ńîőđŕíčňü') then
            	Uk = #tableUk["Text"]
            	tableUk["Text"][Uk+1] = newUkName
            	tableUk["Ur"][Uk+1] = newUkUr[0]
            	encodedTable = encodeJson(tableUk)
                local file = io.open("smartUk.json", "w")
                file:write(encodedTable)
                file:flush()
                file:close()
            end
        imgui.End()
    end
)

function calculateZone(x, y, z)
    local streets = {
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Ăŕđńč˙", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Řĺéäč-Ęýáčí", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"Ăđóçîâîĺ äĺďî Ëŕń-Âĺíňóđŕńŕ", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Áëýęôčëä", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Ňĺěďë", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Ńňŕíöč˙ ŤŢíčňčť", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"Ăđóçîâîĺ äĺďî Ëŕń-Âĺíňóđŕńŕ", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Ëîń-Ôëîđĺń", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Ęŕçčíî ŤĚîđńęŕ˙ çâĺçäŕť", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Őčěçŕâîä Čńňĺđ-Áýé", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Äĺëîâîé đŕéîí", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Âîńňî÷íŕ˙ Ýńďŕëŕíäŕ", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Ńňŕíöč˙ ŤĚŕđęĺňť", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Ńňŕíöč˙ ŤËčíäĺíť", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Ďĺđĺńĺ÷ĺíčĺ Ěîíňăîěĺđč", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Ěîńň ŤÔđĺäĺđčęť", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Ńňŕíöč˙ ŤÉĺëëîó-Áĺëëť", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Äĺëîâîé đŕéîí", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Äćĺôôĺđńîí", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Ěŕëőîëëŕíä", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Äćĺôôĺđńîí", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Çŕďŕäŕíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Äćĺôôĺđńîí", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Đîäĺî", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Ńňŕíöč˙ ŤĘđýíáĺđđčť", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Äĺëîâîé đŕéîí", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Çŕďŕäíűé Đýäńýíäń", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Ěŕëĺíüęŕ˙ Ěĺęńčęŕ", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Áëýęôčëä", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Áĺęîí-Őčëë", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Đîäĺî", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Đč÷ěŕí", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Äĺëîâîé đŕéîí", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"Ńňđčď", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Äĺëîâîé đŕéîí", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Áëýęôčëä", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Ęîíôĺđĺíö Öĺíňđ", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Ěîíňăîěĺđč", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Äîëčíŕ Ôîńňĺđ", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"×ŕńîâí˙ Áëýęôčëä", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Ěŕëőîëëŕíä", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Ďîëĺ äë˙ ăîëüôŕ ŤÉĺëëîó-Áĺëëť", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"Ńňđčď", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Äćĺôôĺđńîí", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Ěŕëőîëëŕíä", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Ŕëüäĺŕ-Ěŕëüâŕäŕ", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Ëŕń-Ęîëčíŕń", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Ëŕń-Ęîëčíŕń", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Đč÷ěŕí", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"Ăđóçîâîĺ äĺďî Ëŕń-Âĺíňóđŕńŕ", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Óčëëîóôčëä", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Ňĺěďë", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Ěŕëĺíüęŕ˙ Ěĺęńčęŕ", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Ęâčíń", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Ŕýđîďîđň Ëŕń-Âĺíňóđŕń", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Đč÷ěŕí", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Ňĺěďë", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Âîńňî÷íŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Óčëëîóôčëä", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Ëŕń-Ęîëčíŕń", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Âîńňî÷íŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Đîäĺî", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Ëŕń-Áđóőŕń", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Âîńňî÷íŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Đîäĺî", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Âŕéíâóä", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Đîäĺî", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Äĺëîâîé đŕéîí", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Đîäĺî", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Äćĺôôĺđńîí", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Őýěďňîí-Áŕđíń", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Ňĺěďë", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Ěîńň ŤĘčíęĺéäť", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Ďë˙ć ŤÂĺđîíŕť", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Ěŕëőîëëŕíä", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Đîäĺî", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Ěŕëőîëëŕíä", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Ěŕëőîëëŕíä", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Ţćíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Ŕéäëâóä", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Îęĺŕíńęčĺ äîęč", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Ňĺěďë", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Ăëĺí Ďŕđę", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Ěîńň ŤĚŕđňčíť", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"Ńňđčď", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Óčëëîóôčëä", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Ěŕđčíŕ", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Ŕýđîďîđň Ëŕń-Âĺíňóđŕń", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Ŕéäëâóä", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Âîńňî÷íŕ˙ Ýńďŕëŕíäŕ", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Äĺëîâîé đŕéîí", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"Ěîńň ŤĚŕęîť", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Đîäĺî", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Ďëîůŕäü ŤĎĺđřčíăť", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Ěŕëőîëëŕíä", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Ěîńň ŤĂŕíňť", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Ëŕń-Ęîëčíŕń", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Ěŕëőîëëŕíä", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Đîäĺî", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Đîęŕ-Ýńęŕëŕíňĺ", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Đîäĺî", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Ěŕđęĺň", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Ëŕń-Ęîëčíŕń", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Ěŕëőîëëŕíä", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"Ęčíăń", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Âîńňî÷íűé Đýäńýíäń", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Äĺëîâîé đŕéîí", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Ęîíôĺđĺíö Öĺíňđ", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Đč÷ěŕí", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Îóřĺí-Ôëýňń", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Ęîëëĺäć Ăđčíăëŕńń", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Ăëĺí Ďŕđę", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"Ăđóçîâîĺ äĺďî Ëŕń-Âĺíňóđŕńŕ", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Đĺăüţëŕđ-Ňîě", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Ďë˙ć ŤÂĺđîíŕť", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Äâîđĺö Ęŕëčăóëű", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Ŕéäëâóä", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Ďčëčăđčě", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Ŕéäëâóä", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Ęâčíń", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Äĺëîâîé đŕéîí", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Ěŕđčíŕ", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Đč÷ěŕí", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Âŕéíâóä", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Đîäĺî", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Čńňĺđńęčé Ňîííĺëü", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Đîäĺî", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Âîńňî÷íűé Đýäńýíäń", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"Ęŕçčíî ŤĘŕđěŕí ęëîóíŕť", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Ŕéäëâóä", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Ěîíňăîěĺđč", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Óčëëîóôčëä", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Ňĺěďë", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Ďđčęë-Ďŕéí", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Ěîńň ŤĂŕđâĺđť", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Ěîńň ŤĂŕđâĺđť", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Ěîńň ŤĘčíęĺéäť", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Ěîńň ŤĘčíęĺéäť", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Ďë˙ć ŤÂĺđîíŕť", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Îáńĺđâŕňîđč˙ ŤÇĺë¸íűé óň¸ńť", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Âŕéíâóä", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Âŕéíâóä", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Ěŕđęĺň", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Çŕďŕäíűé Đîęřîđ", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"Âîńňî÷íűé ďë˙ć", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Ěîńň ŤÔŕëëîóť", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Óčëëîóôčëä", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"×ŕéíŕňŕóí", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"Ýëü-Ęŕńňčëüî-äĺëü-Äü˙áëî", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Îęĺŕíńęčĺ äîęč", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Őčěçŕâîä Čńňĺđ-Áýé", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"Ęŕçčíî ŤÂčçŕćť", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Îóřĺí-Ôëýňń", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Đč÷ěŕí", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Íĺôň˙íîé ęîěďëĺęń ŤÇĺëĺíűé îŕçčńť", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Đč÷ěŕí", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Ęŕçčíî ŤĚîđńęŕ˙ çâĺçäŕť", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"Âîńňî÷íűé ďë˙ć", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Äćĺôôĺđńîí", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Äĺëîâîé đŕéîí", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Äĺëîâîé đŕéîí", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Ěîńň ŤĂŕđâĺđť", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Ţćíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Ęîëëĺäć ŤĂđčíăëŕńńť", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Ëŕń-Ęîëčíŕń", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Ěŕëőîëëŕíä", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Îęĺŕíńęčĺ äîęč", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"Âîńňî÷íűé Ëîń-Ńŕíňîń", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Ăŕíňîí", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Óčëëîóôčëä", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Ńĺâĺđíŕ˙ Ýńďëŕíŕäŕ", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"Ęŕçčíî ŤŐŕé-Đîëëĺđť", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Îęĺŕíńęčĺ äîęč", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Ěîňĺëü ŤĎîńëĺäíčé öĺíňť", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Áýéńŕéíä-Ěŕđčíŕ", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"Ęčíăń", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"Ýëü-Ęîđîíŕ", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"×ŕńîâí˙ Áëýęôčëä", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"ŤĐîçîâűé ëĺáĺäüť", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Çŕďŕäŕíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Ëîń-Ôëîđĺń", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"Ęŕçčíî ŤÂčçŕćť", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Ďđčęë-Ďŕéí", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Ďë˙ć ŤÂĺđîíŕť", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Đîáŕäŕ", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Ëčíäĺí-Ńŕéä", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Îęĺŕíńęčĺ äîęč", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Óčëëîóôčëä", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"Ęčíăń", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Ęîěěĺđ÷ĺńęčé đŕéîí", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Ěŕëőîëëŕíä", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Ěŕđčíŕ", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Áýňňĺđč-Ďîéíň", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"Ęŕçčíî Ť4 Äđŕęîíŕť", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Áëýęôčëä", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Ńĺâĺđíŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Ďîëĺ äë˙ ăîëüôŕ ŤÉĺëëîó-Áĺëëť", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Ŕéäëâóä", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Çŕďŕäíűé Đýäńýíäń", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Äîýđňč", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Ôĺđěŕ Őčëëňîď", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Ëŕń-Áŕđđŕíęŕń", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Ęŕçčíî ŤĎčđŕňű â ěóćńęčő řňŕíŕőť", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"Ńčňč Őîëë", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Çŕăîđîäíűé ęëóá ŤŔâčńďŕť", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"Ńňđčď", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Őŕřáĺđč", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Óŕéňâóä-Čńňĺéňń", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Âîäîőđŕíčëčůĺ Řĺđěŕíŕ", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"Ýëü-Ęîđîíŕ", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Äĺëîâîé đŕéîí", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Äîëčíŕ Ôîńňĺđ", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Ëŕń-Ďŕ˙ńŕäŕń", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Äîëčíŕ Îęóëüňŕäî", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Ďĺđĺńĺ÷ĺíčĺ Áëýęôčëä", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Ăŕíňîí", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Âîńňî÷íűé Đýäńýíäń", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Âîńňî÷íŕ˙ Ýńďŕëŕíäŕ", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Äâîđĺö Ęŕëčăóëű", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Ęŕçčíî ŤĐî˙ëüť", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Đč÷ěŕí", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Ęŕçčíî ŤĚîđńęŕ˙ çâĺçäŕť", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Ěŕëőîëëŕíä", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Äĺëîâîé đŕéîí", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Őŕíęč-Ďŕíęč-Ďîéíň", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"Âîĺííűé ńęëŕä ňîďëčâŕ Ę.Ŕ.Ń.Ń.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Ŕâňîńňđŕäŕ ŤĂŕđđč-Ăîëäť", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Ňîííĺëü Áýéńŕéä", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Îęĺŕíńęčĺ äîęč", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Đč÷ěŕí", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Ďđîěńęëŕä čěĺíč Đýíäîëüôŕ", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"Âîńňî÷íűé ďë˙ć", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Ôëčíň-Óîňĺđ", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Áëóáĺđđč", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Ńňŕíöč˙ ŤËčíäĺíť", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Ăëĺí Ďŕđę", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Äĺëîâîé đŕéîí", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Çŕďŕäíűé Đýäńýíäń", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Đč÷ěŕí", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Ěîńň ŤĂŕíňť", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Áŕđ ŤProbe Innť", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Ďĺđĺńĺ÷ĺíčĺ Ôëčíň", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Ëŕń-Ęîëčíŕń", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Ńîáĺëë-Đĺéë-ßđäń", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"Čçóěđóäíűé îńňđîâ", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"Ýëü-Ęŕńňčëüî-äĺëü-Äü˙áëî", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Ńŕíňŕ-Ôëîđŕ", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Ďëŕé˙-äĺëü-Ńĺâčëü", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Ěŕđęĺň", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Ęâčíń", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Ďĺđĺńĺ÷ĺíčĺ Ďčëńîí", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Ńďčíčáĺä", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Ďčëčăđčě", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Áëýęôčëä", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"ŤÁîëüřîĺ óőîť", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Äčëëčěîđ", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"Ýëü-Ęĺáđŕäîń", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Ńĺâĺđíŕ˙ Ýńďëŕíŕäŕ", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Đűáŕöęŕ˙ ëŕăóíŕ", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Ěŕëőîëëŕíä", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"Âîńňî÷íűé ďë˙ć", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"Ńŕí-Ŕíäđĺŕń Ńŕóíä", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Ňĺíčńňűĺ đó÷üč", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Ěŕđęĺň", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Çŕďŕäíűé Đîęřîđ", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Ďđčęë-Ďŕéí", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"ŤÁóőňŕ Ďŕńőčť", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Ëčôč-Őîëëîó", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"Ăđóçîâîĺ äĺďî Ëŕń-Âĺíňóđŕńŕ", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Ďđčęë-Ďŕéí", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Áëóáĺđđč", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"Ýëü-Ęŕńňčëüî-äĺëü-Äü˙áëî", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Äĺëîâîé đŕéîí", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Âîńňî÷íűé Đîęřîđ", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"Çŕëčâ Ńŕí-Ôčĺđđî", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Ďŕđŕäčçî", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"Ęŕçčíî ŤÍîńîę âĺđáëţäŕť", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Îëä-Âĺíňóđŕń-Ńňđčď", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Äćŕíčďĺđ-Őčëë", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Äćŕíčďĺđ-Őîëëîó", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Đîęŕ-Ýńęŕëŕíňĺ", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Âîńňî÷íŕ˙ ŕâňîńňđŕäŕ Äćóëčóń", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Ďë˙ć ŤÂĺđîíŕť", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Äîëčíŕ Ôîńňĺđ", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Ŕđęî-äĺëü-Îýńňĺ", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"ŤÓďŕâřĺĺ äĺđĺâîť", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"Ôĺđěŕ", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"Äŕěáŕ Řĺđěŕíŕ", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Ńĺâĺđíŕ˙ Ýńďëŕíŕäŕ", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Ôčíŕíńîâűé đŕéîí", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Ăŕđńč˙", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Ěîíňăîěĺđč", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Ęđčę", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Ďë˙ć ŤŃŕíňŕ-Ěŕđč˙ť", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Ďĺđĺńĺ÷ĺíčĺ Ěŕëőîëëŕíä", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Ýéíäćĺë-Ďŕéí", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Â¸đäŕíň-Ěĺäîóń", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Îęňŕí-Ńďđčíăń", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Ęŕçčíî Ęŕě-ý-Ëîň", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Çŕďŕäíűé Đýäńýíäń", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Ďë˙ć ŤŃŕíňŕ-Ěŕđč˙ť", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Îáńĺđâŕňîđč˙ ŤÇĺë¸íűé óň¸ń", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Ŕýđîďîđň Ëŕń-Âĺíňóđŕń", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Îęđóă Ôëčíň", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Îáńĺđâŕňîđč˙ ŤÇĺë¸íűé óň¸ń", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Ďŕëîěčíî Ęđčę", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Îęĺŕíńęčĺ äîęč", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Óŕéňâóä-Čńňĺéňń", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Ęŕëňîí-Őŕéňń", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"ŤÁóőňŕ Ďŕńőčť", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Çŕëčâ Ëîń-Ńŕíňîń", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Äîýđňč", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Ăîđŕ ×čëčŕä", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Ôîđň-Ęŕđńîí", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Äîëčíŕ Ôîńňĺđ", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Îóřĺí-Ôëýňń", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Ôĺđí-Đčäć", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Áýéńŕéä", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Ŕýđîďîđň Ëŕń-Âĺíňóđŕń", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Ďîěĺńňüĺ Áëóáĺđđč", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Ďýëčńĺéäń", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"Íîđň-Đîę", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Ęŕđüĺđ ŤŐŕíňĺđť", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Ëîń-Ńŕíňîń", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Ěčńńčîíĺđ-Őčëë", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"Çŕëčâ Ńŕí-Ôčĺđđî", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Çŕďđĺňíŕ˙ Çîíŕ", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Ăîđŕ Ť×čëčŕäť", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Ăîđŕ Ť×čëčŕäť", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Ěĺćäóíŕđîäíűé ŕýđîďîđň Čńňĺđ-Áýé", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"Ďŕíîďňčęóě", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Ňĺíčńňűĺ đó÷üč", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Áýę-î-Áĺéîíä", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Ăîđŕ Ť×čëčŕäť", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Ňüĺđđŕ Đîáŕäŕ", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Îęđóă Ôëčíň", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Óýňńňîóí", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Ďóńňűííűé îęđóă", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Ňüĺđđŕ Đîáŕäŕ", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"Ńŕí Ôčĺđđî", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Ëŕń Âĺíňóđŕń", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Ňóěŕííűé îęđóă", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Ëîń Ńŕíňîń", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Ďđčăîđîä'
end

local suppWindowFrame = imgui.OnFrame(
    function() return suppWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Âńďîěîăŕňĺëüíîĺ îęîřęî", suppWindow, imgui.WindowFlags.NoTitleBar)
            
			imgui.Text(u8'Âđĺě˙: '..os.date('%H:%M:%S'))
            imgui.Text(u8'Ěĺń˙ö: '..os.date('%B'))
			imgui.Text(u8'Ďîëíŕ˙ äŕňŕ: '..arr.day..'.'.. arr.month..'.'..arr.year)
        	local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
			imgui.Text(u8'Đŕéîí:' .. u8(calculateZone(positionX, positionY, positionZ)))
			local p_city = getCityPlayerIsIn(PLAYER_PED)
			if p_city == 1 then pCity = u8'Ëîń - Ńŕíňîń' end
			if p_city == 2 then pCity = u8'Ńŕí - Ôčĺđđî' end
			if p_city == 3 then pCity = u8'Ëŕń - Âĺíňóđŕń' end
			if getActiveInterior() ~= 0 then pCity = u8'Âű íŕőîäčňĺńü â číňĺđüĺđĺ!' end
			imgui.Text(u8'Ăîđîä: ' .. pCity)
		imgui.End()
    end
)

function cmd_stop(id)
	if id == nil then
		sampAddChatMessage("[ERROR] Ââĺäčňĺ ID," -1)
	else
		local nickNameStop = sampGetPlayerNickname(id)
		lua_thread.create(function()
			sampSendChat("/do Ěĺăŕôîí â áŕđäŕ÷ęĺ.")
			wait(1500)
			sampSendChat("/me äîńňŕë ěĺăŕôîí ń áŕđäŕ÷ęŕ ďîńëĺ ÷ĺăî âęëţ÷čë ĺăî")
			wait(1500)
			sampSendChat("/b /m Ăđŕćäŕíčí " .. nickNameStop .. " ďđčćěčňĺńü ę îáî÷číĺ!")
		end)
	end
end
