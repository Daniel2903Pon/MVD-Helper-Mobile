script_name("MVD Helper Mobile")
script_version("4.8")
script_author("@Sashe4ka_ReZoN @daniel29032012")

local http = require("socket.http")
local ltn12 = require("ltn12")
local imgui = require 'mimgui'
local ffi = require 'ffi'
local inicfg = require("inicfg")
local monet = require('MoonMonet')
local faicons = require('fAwesome6')
local sampev = require('lib.samp.events')
function isMonetLoader() return MONET_VERSION ~= nil end

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new


sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ñêðèïò óñïåøíî çàãðóçèëñÿ", 0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Àâòîðû:t.me/Sashe4ka_ReZoN and t.me/daniel29032012",0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}×òîáû ïîñìîòðåòü êîììàíäû,ââåäèòå /mvd and /mvds ",0x8B00FF)

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

local function downloadFile(url, path)

  local response = {}
  local _, status_code, _ = http.request{
    url = url,
    method = "GET",
    sink = ltn12.sink.file(io.open(path, "w")),
    headers = {
      ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0;Win64) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36",

    },
  }

  if status_code == 200 then
    return true
  else
    return false
  end
end

local function updateScript(scriptUrl, scriptPath)
  print("Ïðîâåðêà íàëè÷èÿ îáíîâëåíèé...")
  local currentVersionFile = io.open(scriptPath, "r")
  local currentVersion = currentVersionFile:read("*a")
  currentVersionFile:close()

  local response = http.request(scriptUrl)
  if response and response ~= currentVersion then
    -- Îáíîâëÿåì ñêðèïò
    sampAddChatMessage("Äîñòóïíà íîâàÿ âåðñèÿ ñêðèïòà! Îáíîâëåíèå...", -1)
    local success = downloadFile(scriptUrl, scriptPath)
    if success then
      sampAddChatMessage("Ñêðèïò óñïåøíî îáíîâëåí.", -1)
    else
      sampAddChatMessage("Íå óäàëîñü îáíîâèòü ñêðèïò.", -1)
    end
  else
    sampAddChatMessage("Ñêðèïò óæå ÿâëÿåòñÿ ïîñëåäíåé âåðñèåé.", -1)
  end
end
local scriptUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper.lua"
local scriptPath = "MVDHelper.lua"

local mainIni = inicfg.load({
    Accent = {
        accent = '[Ìîëäàâñêèé àêöåíò]: ',
        autoAccent = false
    },
    Info = {
        org = 'Âû íå ñîñòîèòå â ÏÄ',
        dl = 'Âû íå ñîñòîèòå â ÏÄ',
        rang_n = 0
    },
    theme = {
        themeta = "blue",
        selected = 0,
        moonmonet = 759410733
    }
}, "mvdhelper.ini")
local file = io.open("smartUk.json", "r") -- Îòêðûâàåì ôàéë â ðåæèìå ÷òåíèÿ
a = file:read("*a") -- ×èòàåì ôàéë, òàì ó íàñ òàáëèöà
file:close() -- Çàêðûâàåì
tableUk = decodeJson(a) -- ×èòàåì íàøó JSON-Òàáëèöó

local statsCheck = false

local AutoAccentBool = new.bool(mainIni.Accent.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org = u8'Âû íå ñîñòîèòå â ÏÄ'
local org_g = u8'Âû íå ñîñòîèòå â ÏÄ'
local ccity = u8'Âû íå ñîñòîèòå â ÏÄ'
local org_tag = u8'Âû íå ñîñòîèòå â ÏÄ'
local dol = 'Âû íå ñîñòîèòå â ÏÄ'
local dl = u8'Âû íå ñîñòîèòå â ÏÄ'
local rang_n = 0
local selected_theme = imgui.new.int(mainIni.theme.selected)
local theme_a = {u8'Ñòàíäàðòíàÿ', u8'Êðàñíàÿ', u8'Çåë¸íàÿ',u8'Ñèíÿÿ', u8'Ôèîëåòîâàÿ', 'MoonMonet'}
local theme_t = {u8'standart', u8'red', u8'green', u8'blue', 'purple', 'moonmonet'}
local items = imgui.new['const char*'][#theme_a](theme_a)
local nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
local autoScrinArest = new.bool()

local sliderBuf = new.int() -- áóôåð äëÿ òåñòîâîãî ñëàéäåðà

local function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end
local function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
local function ARGBtoRGB(color)
    return bit.band(color, 0xFFFFFF)
end
function rgb2hex(r, g, b)
    local hex = string.format("#%02X%02X%02X", r, g, b)
    return hex
end
function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha)
        self.a = alpha
        return self
    end
    function ret:as_u32()
        return join_argb(self.a, self.b, self.g, self.r)
    end
    function ret:as_vec4()
        return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
    end
    function ret:as_argb()
        return join_argb(self.a, self.r, self.g, self.b)
    end
    function ret:as_rgba()
        return join_argb(self.r, self.g, self.b, self.a)
    end
    function ret:as_chat()
        return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
    end
    return ret
end

function standarttheme()
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

function redtheme()
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

function greentheme()
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

function bluetheme()
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
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
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

function purpletheme()
    local ImVec4 = imgui.ImVec4
    imgui.GetStyle().FramePadding = imgui.ImVec2(3.5, 3.5)
    imgui.GetStyle().FrameRounding = 3
    imgui.GetStyle().ChildRounding = 2
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().WindowRounding = 2
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5.0, 4.0)
    imgui.GetStyle().ScrollbarSize = 13.0
    imgui.GetStyle().ScrollbarRounding = 0
    imgui.GetStyle().GrabMinSize = 8.0
    imgui.GetStyle().GrabRounding = 1.0
    imgui.GetStyle().WindowPadding = imgui.ImVec2(4.0, 4.0)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)

    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.14, 0.12, 0.16, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.30, 0.20, 0.39, 0.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.05, 0.05, 0.10, 0.90)
    imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.89, 0.85, 0.92, 0.30)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.30, 0.20, 0.39, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.68)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.45)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.41, 0.19, 0.63, 0.35)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.30, 0.20, 0.39, 0.57)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.30, 0.20, 0.39, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.31)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.56, 0.61, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.41, 0.19, 0.63, 0.24)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.41, 0.19, 0.63, 0.44)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.64, 0.33, 0.94, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.41, 0.19, 0.63, 0.76)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.86)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.41, 0.19, 0.63, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 0.78)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.89, 0.85, 0.92, 0.63)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.41, 0.19, 0.63, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.41, 0.19, 0.63, 0.43)
end

function apply_monet()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local generated_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
	colors[clr.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4()
	colors[clr.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4()
	colors[clr.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	colors[clr.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	colors[clr.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	colors[clr.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	colors[clr.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	colors[clr.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60):as_vec4()
	colors[clr.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x70):as_vec4()
	colors[clr.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x50):as_vec4()
	colors[clr.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	colors[clr.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0x7f):as_vec4()
	colors[clr.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	colors[clr.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91):as_vec4()
	colors[clr.ScrollbarBg] = imgui.ImVec4(0,0,0,0)
	colors[clr.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x85):as_vec4()
	colors[clr.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	colors[clr.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	colors[clr.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	colors[clr.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x80):as_vec4()
	colors[clr.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	colors[clr.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	colors[clr.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	colors[clr.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	colors[clr.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	colors[clr.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	colors[clr.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	colors[clr.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	colors[clr.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xb3):as_vec4()
	colors[clr.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	colors[clr.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	colors[clr.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	colors[clr.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x26):as_vec4()
end

function apply_n_t()
    if mainIni.theme.theme == 'standart' then
    	standarttheme()
	elseif mainIni.theme.theme == 'red' then
        redtheme()
	elseif mainIni.theme.theme == 'green' then
		greentheme()
	elseif mainIni.theme.theme == 'blue' then
    	bluetheme()
	elseif mainIni.theme.theme == 'purple' then
    	purpletheme()
	elseif mainIni.theme.theme == 'moonmonet' then
		gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    	local a, r, g, b = explode_argb(gen_color.accent1.color_300)
		curcolor = '{'..rgb2hex(r, g, b)..'}'
    	curcolor1 = '0x'..('%X'):format(gen_color.accent1.color_300)
        apply_monet()
	end
end

imgui.OnFrame(
    function() return renderWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1700, 700), imgui.Cond.FirstUseEver)
        imgui.Begin(thisScript().name .. " " .. thisScript().version .. " ", renderWindow)
        apply_n_t()
        imgui.SetCursorPosY(50)
        imgui.Text(u8'MVD Helper 4.8 \n äëÿ Arizona Mobile', imgui.SetCursorPosX(50))
        if imgui.Button(settings .. u8' Íàñòðîéêè', imgui.ImVec2(280, 50)) then
            tab = 1
        elseif imgui.Button(list .. u8' Îñíîâíîå', imgui.ImVec2(280, 50)) then
            tab = 2

        elseif imgui.Button(radio .. u8' Ðàöèÿ äåïîðòàìåíòà', imgui.ImVec2(280, 50)) then
            tab = 3

        elseif imgui.Button(userSecret .. u8' Äëÿ ÑÑ', imgui.ImVec2(280, 50)) then
            tab = 4

        elseif imgui.Button(pen .. u8' Øïàðãàëêè', imgui.ImVec2(280, 50)) then
            tab = 5

        elseif imgui.Button(sliders .. u8' Äîïîëíèòåëüíî', imgui.ImVec2(280, 50)) then
            tab = 6

        elseif imgui.Button(info .. u8' Èíôà', imgui.ImVec2(280, 50)) then
            tab = 7
        end
        imgui.SetCursorPos(imgui.ImVec2(300, 50))
        if imgui.BeginChild('Name##'..tab, imgui.ImVec2(), true) then -- [Äëÿ äåêîðà] Ñîçäà¸ì ÷àéëä â êîòîðûé ïîìåñòèì ñîäåðæèìîå
            -- == [Îñíîâíîå] Ñîäåðæèìîå âêëàäîê == --
            if tab == 1 then -- åñëè çíà÷åíèå tab == 1
                imgui.Text(u8'Âàø íèê: '.. nickname)
                imgui.Text(u8'Âàøà îðãàíèçàöèÿ: '.. mainIni.Info.org)
                imgui.Text(u8'Âàøà äîëæíîñòü: '.. mainIni.Info.dl)
                if imgui.Combo(u8'Òåìû', selected_theme, items, #theme_a) then
                	themeta = theme_t[selected_theme[0]+1]
	            	mainIni.theme.theme = themeta
	            	mainIni.theme.selected = selected_theme[0]
		            inicfg.save(mainIni, 'mvdhelper.ini')
	            end
            	imgui.Text('Öâåò MoonMonet  -')
				imgui.SameLine()
        		if imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
                    r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
	                argb = join_argb(0, r, g, b)
                    mainIni.theme.moonmonet = argb
                    inicfg.save(mainIni, 'mvdhelper.ini')
			    	apply_n_t()
		    	end
                if imgui.Button(u8'ÓÊ') then
                    setUkWindow[0] = not setUkWindow[0]
                end
            elseif tab == 2 then -- åñëè çíà÷åíèå tab == 2
                imgui.InputInt(u8 'ID èãðîêà ñ êîòîðûì áóäåòå âçàèìîäåéñòâîâàòü', id, 10)
                if imgui.Button(u8 'Ïðèâåòñòâèå') then
                    lua_thread.create(function()
                        sampSendChat("Äîáðîãî âðåìåíè ñóòîê, ÿ «" .. nickname .. "» «" ..  u8:decode(mainIni.Info.dl) .."».")
                        wait(1500)
                        sampSendChat("/do Óäîñòîâåðåíèå â ðóêàõ.")
                        wait(1500)
                        sampSendChat("/me ïîêàçàë ñâî¸ óäîñòîâåðåíèå ÷åëîâåêó íà ïðîòèâ")
                        wait(1500)
                        sampSendChat("/do «" .. nickname .. "».")
                        wait(1500)
                        sampSendChat("/do «" .. u8:decode(mainIni.Info.dl) .. "» " .. mainIni.Info.org .. ".")
                        wait(1500)
                        sampSendChat("Ïðåäúÿâèòå âàøè äîêóìåíòû, à èìåííî ïàñïîðò. Íå áåñïîêîéòåñü, ýòî âñåãî ëèøü ïðîâåðêà.")
                    end)
                end
                if imgui.Button(u8 'Íàéòè èãðîêà') then
                    lua_thread.create(function()
                        sampSendChat("/do ÊÏÊ â ëåâîì êàðìàíå.")
                        wait(1500)
                        sampSendChat("/me äîñòàë ëåâîé ðóêîé ÊÏÊ èç êàðìàíà")
                        wait(1500)
                        sampSendChat("/do ÊÏÊ â ëåâîé ðóêå.")
                        wait(1500)
                        sampSendChat("/me âêëþ÷èë ÊÏÊ è çàøåë â áàçó äàííûõ Ïîëèöèè")
                        wait(1500)
                        sampSendChat("/me îòêðûë äåëî íîìåð " .. id[0] .. " ïðåñòóïíèêà")
                        wait(1500)
                        sampSendChat("/do Äàííûå ïðåñòóïíèêà ïîëó÷åíû.")
                        wait(1500)
                        sampSendChat("/me ïîäêëþ÷èëñÿ ê êàìåðàì ñëåæåíèÿ øòàòà")
                        wait(1500)
                        sampSendChat("/do Íà íàâèãàòîðå ïîÿâèëñÿ ìàðøðóò.")
                        wait(1500)
                        sampSendChat("/pursuit " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Àðåñò') then
                    lua_thread.create(function()
                        sampSendChat("/me âçÿë ðó÷êó èç êàðìàíà ðóáàøêè, çàòåì îòêðûë áàðäà÷îê è âçÿë îòòóäà áëàíê ïðîòîêîëà")
                        wait(1500)
                        sampSendChat("/do Áëàíê ïðîòîêîëà è ðó÷êà â ðóêàõ.")
                        wait(1500)
                        sampSendChat("/me çàïîëíÿåò îïèñàíèå âíåøíîñòè íàðóøèòåëÿ")
                        wait(1500)
                        sampSendChat("/me çàïîëíÿåò õàðàêòåðèñòèêó î íàðóøèòåëå")
                        wait(1500)
                        sampSendChat("/me çàïîëíÿåò äàííûå î íàðóøåíèè")
                        wait(1500)
                        sampSendChat("/me ïðîñòàâèë äàòó è ïîäïèñü")
                        wait(1500)
                        sampSendChat("/me ïîëîæèë ðó÷êó â êàðìàí ðóáàøêè")
                        wait(1500)
                        sampSendChat("/do Ðó÷êà â êàðìàíå ðóáàøêè.")
                        wait(1500)
                        sampSendChat("/me ïåðåäàë áëàíê ñîñòàâëåííîãî ïðîòîêîëà â ó÷àñòîê")
                        wait(1500)
                        sampSendChat("/me ïåðåäàë ïðåñòóïíèêà â Óïðàâëåíèå Ïîëèöèè ïîä ñòðàæó")
                        wait(1500)
                        sampSendChat("/arrest")
                        sampAddChatMessage("Âñòàíüòå íà ÷åêïîèíò",0x8B00FF)
                    end)
                end
                if imgui.Button(u8 'Íàäåòü íàðó÷íèêè') then
                    lua_thread.create(function()
                        sampSendChat("/do Íàðó÷íèêè âèñÿò íà ïîÿñå.")
                        wait(1500)
                        sampSendChat("/me ñíÿë ñ äåðæàòåëÿ íàðó÷íèêè")
                        wait(1500)
                        sampSendChat("/do Íàðó÷íèêè â ðóêàõ.")
                        wait(1500)
                        sampSendChat("/me ðåçêèì äâèæåíèåì îáåèõ ðóê, íàäåë íàðó÷íèêè íà ïðåñòóïíèêà")
                        wait(1500)
                        sampSendChat("/do Ïðåñòóïíèê ñêîâàí.")
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ñíÿòü íàðó÷íèêè') then
                    lua_thread.create(function()
                        sampSendChat("/do Êëþ÷ îò íàðó÷íèêîâ â êàðìàíå.")
                        wait(1500)
                        sampSendChat("/me äâèæåíèåì ïðàâîé ðóêè äîñòàë èç êàðìàíà êëþ÷ è îòêðûë íàðó÷íèêè")
                        wait(1500)
                        sampSendChat("/do Ïðåñòóïíèê ðàñêîâàí.")
                        wait(1500)
                        sampSendChat("/uncuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Âåñòè çà ñîáîé') then
                    lua_thread.create(function()
                        ampSendsChat("/me çàëîìèë ïðàâóþ ðóêó íàðóøèòåëþ")
                        wait(1500)
                        sampSendChat("/me âåäåò íàðóøèòåëÿ çà ñîáîé")
                        wait(1500)
                        sampSendChat("/gotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ïåðåñòàòü âåñòè çà ñîáîé') then
                    lua_thread.create(function()
                        sampSendChat("/me îòïóñòèë ïðàâóþ ðóêó ïðåñòóïíèêà")
                        wait(1500)
                        sampSendChat("/do Ïðåñòóïíèê ñâîáîäåí.")
                        wait(1500)
                        sampSendChat("/ungotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Â ìàøèíó(àâòîìàòè÷åñêè íà 3-å ìåñòî)') then
                    lua_thread.create(function()
                        sampSendChat("/do Äâåðè â ìàøèíå çàêðûòû.")
                        wait(1500)
                        sampSendChat("/me îòêðûë çàäíþþ äâåðü â ìàøèíå")
                        wait(1500)
                        sampSendChat("/me ïîñàäèë ïðåñòóïíèêà â ìàøèíó")
                        wait(1500)
                        sampSendChat("/me çàáëîêèðîâàë äâåðè")
                        wait(1500)
                        sampSendChat("/do Äâåðè çàáëîêèðîâàíû.")
                        wait(1500)
                        sampSendChat("/incar " .. id[0] .. "3")
                    end)
                end
                if imgui.Button(u8 'Îáûñê') then
                    lua_thread.create(function()
                        sampSendChat("/me íûðíóâ ðóêàìè â êàðìàíû, âûòÿíóë îòòóäà áåëûå ïåð÷àòêè è íàòÿíóë èõ íà ðóêè")
                        wait(1500)
                        sampSendChat("/do Ïåð÷àòêè íàäåòû.")
                        wait(1500)
                        sampSendChat("/me ïðîâîäèò ðóêàìè ïî âåðõíåé ÷àñòè òåëà")
                        wait(1500)
                        sampSendChat("/me ïðîâåðÿåò êàðìàíû/me ïðîâîäèò ðóêàìè ïî íîãàì")
                        wait(1500)
                        sampSendChat("/frisk " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Ìåãàôîí') then
                    lua_thread.create(function()
                        sampSendChat("/do Ìåãàôîí â áàðäà÷êå.")
                        wait(1500)
                        sampSendChat("/me äîñòàë ìåãàôîí ñ áàðäà÷êà ïîñëå ÷åãî âêëþ÷èë åãî")
                        wait(1500)
                        sampSendChat("/m Âîäèòåëü àâòî, îñòàíîâèòåñü è çàãëóøèòå äâèãàòåëü, äåðæèòå ðóêè íà ðóëå.")
                    end)
                end
                if imgui.Button(u8 'Âûòàùèòü èç àâòî') then
                    lua_thread.create(function()
                        sampSendChat("/me ñíÿâ äóáèíêó ñ ïîÿñíîãî äåðæàòåëÿ ðàçáèë ñòåêëî â òðàíñïîðòå")
                        wait(1500)
                        sampSendChat("/do Ñòåêëî ðàçáèòî.")
                        wait(1500)
                        sampSendChat("/me ñõâàòèâ çà ïëå÷è ÷åëîâåêà óäàðèë åãî ïîñëå ÷åãî íàäåë íàðó÷íèêè")
                        wait(1500)
                        sampSendChat("/pull " .. id[0])
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Âûäà÷à ðîçûñêà') then
                    windowTwo[0] = not windowTwo[0]
                end

            elseif tab == 3 then -- åñëè çíà÷åíèå tab == 3
                imgui.InputText(u8 'Ôðàêöèÿ ñ êîòîðîé áóäåòå âçàèìîäåéñòâîâàòü', otherorg, 255)
                otherdeporg = u8:decode(ffi.string(otherorg))
                imgui.Checkbox(u8 'Çàêðûòûé êàíàë', zk)
                if imgui.Button(u8 'Âûçîâ íà ñâÿçü') then
                    if zk[0] then
                        sampSendChat("/d [" .. mainIni.Info.org .. "] ç.ê [" .. otherdeporg .. "] Íà ñâÿçü!")
                    else
                        sampSendChat("/d [" .. mainIni.Info.org .. "] 91.8 [" .. otherdeporg .. "] Íà ñâÿçü!")
                    end
                end
                if imgui.Button(u8 'Îòêàò') then
                    sampSendChat("/d [" .. mainIni.Info.org .. "] 91.8 [Èíôîðìàöèÿ] Òåõ. Íåïîëàäêè!")
                end
            elseif tab == 4 then
                if imgui.CollapsingHeader(u8'Áèíäåð') then
                    if imgui.CollapsingHeader(u8'Ëåêöèè') then
                        if imgui.Button(u8'Àðåñò è çàäåðæàíèå') then
                            lua_thread.create(function()
                                sampSendChat("Çäðàâñòâóéòå óâàæàåìûå ñîòðóäíèêè íàøåãî äåïàðòàìåíòà!")
                                wait(1500)
                                sampSendChat("Ñåé÷àñ áóäåò ïðîâåäåíà ëåêöèÿ íà òåìó àðåñò è çàäåðæàíèå ïðåñòóïíèêîâ.")
                                wait(1500)
                                sampSendChat("Äëÿ íà÷àëà îáúÿñíþ ðàçëè÷èå ìåæäó çàäåðæàíèåì è àðåñòîì.")
                                wait(1500)
                                sampSendChat("Çàäåðæàíèå - ýòî êðàòêîâðåìåííîå ëèøåíèå ñâîáîäû ëèöà, ïîäîçðåâàåìîãî â ñîâåðøåíèè ïðåñòóïëåíèÿ.")
                                wait(1500)
                                sampSendChat("Â ñâîþ î÷åðåäü, àðåñò - ýòî âèä óãîëîâíîãî íàêàçàíèÿ, çàêëþ÷àþùåãîñÿ â ñîäåðæàíèè ñîâåðøèâøåãî ïðåñòóïëåíèå..")
                                wait(1500)
                                sampSendChat("..è îñóæä¸ííîãî ïî ïðèãîâîðó ñóäà â óñëîâèÿõ ñòðîãîé èçîëÿöèè îò îáùåñòâà.")
                                wait(1500)
                                sampSendChat("Âàì ðàçðåøåíî çàäåðæèâàòü ëèöà íà ïåðèîä 48 ÷àñîâ ñ ìîìåíòà èõ çàäåðæàíèÿ.")
                                wait(1500)
                                sampSendChat("Åñëè â òå÷åíèå 48 ÷àñîâ âû íå ïðåäúÿâèòå äîêàçàòåëüñòâà âèíû, âû îáÿçàíû îòïóñòèòü ãðàæäàíèíà.")
                                wait(1500)
                                sampSendChat("Îáðàòèòå âíèìàíèå, ãðàæäàíèí ìîæåò ïîäàòü íà âàñ èñê çà íåçàêîííîå çàäåðæàíèå.")
                                wait(1500)
                                sampSendChat("Âî âðåìÿ çàäåðæàíèÿ âû îáÿçàíû ïðîâåñòè ïåðâè÷íûé îáûñê íà ìåñòå çàäåðæàíèÿ è âòîðè÷íûé ó êàïîòà ñâîåãî àâòîìîáèëÿ.")
                                wait(1500)
                                sampSendChat("Âñå íàéäåííûå âåùè ïîëîæèòü â 'ZIP-lock', èëè â êîíòåéíåð äëÿ âåù. äîêîâ, Âñå ëè÷íûå âåùè ïðåñòóïíèêà êëàäóòñÿ â ìåøîê äëÿ ëè÷íûõ âåùåé çàäåðæàííîãî")
                                wait(1500)
                                sampSendChat("Íà ýòîì äàííàÿ ëåêöèÿ ïîäõîäèò ê êîíöó. Ó êîãî-òî èìåþòñÿ âîïðîñû?")
                            end)
                        end
                        if imgui.Button("Ñóááîðäèíàöèÿ") then
                            lua_thread.create(function()
                                sampSendChat(" Óâàæàåìûå ñîòðóäíèêè Ïîëèöåéñêîãî Äåïàðòàìåíòà!")
                                wait(1500)
                                sampSendChat(" Ïðèâåòñòâóþ âàñ íà ëåêöèè î ñóáîðäèíàöèè")
                                wait(1500)
                                sampSendChat(" Äëÿ íà÷àëà ðàññêàæó, ÷òî òàêîå ñóáîðäèíàöèÿ")
                                wait(1500)
                                sampSendChat(" Ñóáîðäèíàöèÿ - ïðàâèëà ïîä÷èíåíèÿ ìëàäøèõ ïî çâàíèþ ê ñòàðøèì ïî çâàíèþ, óâàæåíèå, îòíîøåíèå ê íèì")
                                wait(1500)
                                sampSendChat(" Òî åñòü ìëàäøèå ñîòðóäíèêè äîëæíû âûïîëíÿòü ïðèêàçû íà÷àëüñòâà")
                                wait(1500)
                                sampSendChat(" Êòî îñëóøàåòñÿ  ïîëó÷èò âûãîâîð, ñïåðâà óñòíûé")
                                wait(1500)
                                sampSendChat(" Âû äîëæíû ñ óâàæåíèåì îòíîñèòñÿ ê íà÷àëüñòâó íà 'Âû'")
                                wait(1500)
                                sampSendChat(" Íå íàðóøàéòå ïðàâèëà è íå íàðóøàéòå ñóáîðäèíàöèþ äàáû íå ïîëó÷èòü íàêàçàíèå")
                                wait(1500)
                                sampSendChat(" Ëåêöèÿ îêîí÷åíà ñïàñèáî çà âíèìàíèå!")
                            end)
                        end
                        if imgui.Button(u8"Ñóááîðäèíàöèÿ") then
                            lua_thread.create(function()
                                sampSendChat(" Óâàæàåìûå ñîòðóäíèêè Ïîëèöåéñêîãî Äåïàðòàìåíòà!")
                                wait(1500)
                                sampSendChat(" Ïðèâåòñòâóþ âàñ íà ëåêöèè î ñóáîðäèíàöèè")
                                wait(1500)
                                sampSendChat(" Äëÿ íà÷àëà ðàññêàæó, ÷òî òàêîå ñóáîðäèíàöèÿ")
                                wait(1500)
                                sampSendChat(" Ñóáîðäèíàöèÿ - ïðàâèëà ïîä÷èíåíèÿ ìëàäøèõ ïî çâàíèþ ê ñòàðøèì ïî çâàíèþ, óâàæåíèå, îòíîøåíèå ê íèì")
                                wait(1500)
                                sampSendChat(" Òî åñòü ìëàäøèå ñîòðóäíèêè äîëæíû âûïîëíÿòü ïðèêàçû íà÷àëüñòâà")
                                wait(1500)
                                sampSendChat(" Êòî îñëóøàåòñÿ  ïîëó÷èò âûãîâîð, ñïåðâà óñòíûé")
                                wait(1500)
                                sampSendChat(" Âû äîëæíû ñ óâàæåíèåì îòíîñèòñÿ ê íà÷àëüñòâó íà 'Âû'")
                                wait(1500)
                                sampSendChat(" Íå íàðóøàéòå ïðàâèëà è íå íàðóøàéòå ñóáîðäèíàöèþ äàáû íå ïîëó÷èòü íàêàçàíèå")
                                wait(1500)
                                sampSendChat(" Ëåêöèÿ îêîí÷åíà ñïàñèáî çà âíèìàíèå!")
                            end)
                        end
                        if imgui.Button(u8"Ïðàâèëà ïîâåäåíèÿ â ñòðîþ.") then
                            lua_thread.create(function()
                                sampSendChat(" Óâàæàåìûå ñîòðóäíèêè Ïîëèöåéñêîãî Äåïàðòàìåíòà!")
                                wait(1500)
                                sampSendChat(" Ïðèâåòñòâóþ âàñ íà ëåêöèè ïðàâèëà ïîâåäåíèÿ â ñòðîþ")
                                wait(1500)
                                sampSendChat(" /b Çàïðåùåíû ðàçãîâîðû â ëþáûå ÷àòû (in ic, /r, /n, /fam, /sms,)")
                                wait(1500)
                                sampSendChat(" Çàïðåùåíî ïîëüçîâàòüñÿ ìîáèëüíûìè òåëåôîíàìè")
                                wait(1500)
                                sampSendChat(" Çàïðåùåíî äîñòàâàòü îðóæèå")
                                wait(1500)
                                sampSendChat(" Çàïðåùåíî îòêðûâàòü îãîíü áåç ïðèêàçà")
                                wait(1500)
                                sampSendChat(" /b Çàïðåùåíî óõîäèòü â AFK áîëåå ÷åì íà 30 ñåêóíä")
                                wait(1500)
                                sampSendChat(" Çàïðåùåíî ñàìîâîëüíî ïîêèäàòü ñòðîé íå ïðåäóïðåäèâ îá ýòîì ñòàðøèé ñîñòàâ")
                                wait(1500)
                                sampSendChat(" /b Çàïðåùåíû ëþáûå äâèæåíèÿ â ñòðîþ (/anim) Èñêëþ÷åíèå: ñò. ñîñòàâ")
                                wait(1500)
                                sampSendChat(" /b Çàïðåùåíî èñïîëüçîâàíèå ñèãàðåò [/smoke â ñòðîþ]")
                            end)
                        end
                        if imgui.Button(u8'Äîïðîñ') then
                            lua_thread.create(function()
                                sampSendChat(" Çäðàâñòâóéòå óâàæàåìûå ñîòðóäíèêè äåïàðòàìåíòà ñåãîäíÿ, ÿ ïðîâåäó ëåêöèþ íà òåìó Äîïðîñ ïîäîçðåâàåìîãî.")
                                wait(1500)
                                sampSendChat(" Ñîòðóäíèê ÏÄ îáÿçàí ñíà÷àëà ïîïðèâåòñòâîâàòü, ïðåäñòàâèòüñÿ;")
                                wait(1500)
                                sampSendChat(" Ñîòðóäíèê ÏÄ îáÿçàí ïîïðîñèòü äîêóìåíòû âûçâàííîãî, ñïðîñèòü, ãäå ðàáîòàåò, çâàíèå, äîëæíîñòü, ìåñòî æèòåëüñòâà;")
                                wait(1500)
                                sampSendChat(" Ñîòðóäíèê ÏÄ îáÿçàí ñïðîñèòü, ÷òî îí äåëàë (íàçâàòü ïðîìåæóòîê âðåìåíè, ãäå îí ÷òî-òî íàðóøèë, ïî êîòîðîìó îí áûë âûçâàí);")
                                wait(1500)
                                sampSendChat(" Åñëè ïîäîçðåâàåìûé áûë çàäåðæàí çà ðîçûñê, ñòàðàéòåñü óçíàòü çà ÷òî îí ïîëó÷èë ðîçûñê;")
                                wait(1500)
                                sampSendChat(" Â êîíöå äîïðîñà ïîëèöåéñêèé âûíîñèò âåðäèêò âûçâàííîìó.")
                                wait(1500)
                                sampSendChat(" Ïðè îãëàøåíèè âåðäèêòà, íåîáõîäèìî ïðåäåëüíî òî÷íî îãëàñèòü âèíó äîïðàøèâàåìîãî (Ðàññêàçàòü åìó ïðè÷èíó, çà ÷òî îí áóäåò ïîñàæåí);")
                                wait(1500)
                                sampSendChat(" Ïðè âûíåñåíèè âåðäèêòà, íå ñòîèò çàáûâàòü î îòÿã÷àþùèõ è ñìÿã÷àþùèõ ôàêòîðàõ (Ðàñêàÿíèå, àäåêâàòíîå ïîâåäåíèå, ïðèçíàíèå âèíû èëè ëîæü, íåàäåêâàòíîå ïîâåäåíèå, ïðîâîêàöèè, ïðåäñòàâëåíèå ïîëåçíîé èíôîðìàöèè è òîìó ïîäîáíîå).")
                                wait(1500)
                                sampSendChat(" Íà ýòîì ëåêöèÿ ïîäîøëà ê êîíöó, åñëè ó êîãî-òî åñòü âîïðîñû, îòâå÷ó íà ëþáîé ïî äàííîé ëåêöèè (Åñëè çàäàëè âîïðîñ, òî íóæíî îòâåòèòü íà íåãî)")
                            end)
                        end
                        if imgui.Button(u8"Ïðàâèëà ïîâåäåíèÿ äî è âî âðåìÿ îáëàâû íà íàðêîïðèòîí.") then
                            lua_thread.create(function()
                                sampSendChat(" Äîáðûé äåíü, ñåé÷àñ ÿ ïðîâåäó âàì ëåêöèþ íà òåìó Ïðàâèëà ïîâåäåíèÿ äî è âî âðåìÿ îáëàâû íà íàðêîïðèòîí")
                                wait(1500)
                                sampSendChat(" Â ñòðîþ, ïåðåä îáëàâîé, âû äîëæíû âíèìàòåëüíî ñëóøàòü òî, ÷òî ãîâîðÿò âàì Àãåíòû")
                                wait(1500)
                                sampSendChat(" Óáåäèòåëüíàÿ ïðîñüáà, çàðàíåå óáåäèòüñÿ, ÷òî ïðè ñåáå ó âàñ èìåþòñÿ áàëàêëàâû")
                                wait(1500)
                                sampSendChat(" Ïî ïóòè ê íàðêîïðèòîíó, ïîäúåçæàÿ ê îïàñíîìó ðàéîíó, âñå îáÿçàíû èõ îäåòü")
                                wait(1500)
                                sampSendChat(" Ïðèåõàâ íà òåððèòîðèþ ïðèòîíà, íóæíî ïîñòàâèòü îöåïëåíèå òàê, ÷òîáû çàãîðîäèòü âñå âîçìîæíûå ïóòè ê ñîçðåâàþùèì êóñòàì Êîíîïëè")
                                wait(1500)
                                sampSendChat(" Î÷åíü âàæíûì çàìå÷àíèåì ÿâëÿåòñÿ òî, ÷òî íèêîìó, êðîìå àãåíòîâ, çàïðåùåíî ïîäõîäèòü ê êóñòàì, à òåì áîëåå èõ ñîáèðàòü")
                                wait(1500)
                                sampSendChat(" Íàðóøåíèå äàííîãî ïóíêòà ñòðîãî íàêàçûâàåòñÿ, âïëîòü äî óâîëüíåíèå")
                                wait(1500)
                                sampSendChat(" Òàê æå ïðèåõàâ íà ìåñòî, ìû íå óñòðàèâàåì ïàëüáó ïî âñåì, êîãî âèäèì")
                                wait(1500)
                                sampSendChat(" Îòêðûâàòü îãîíü ïî ïîñòîðîííåìó ðàçðåøàåòñÿ òîëüêî â òîì ñëó÷àå, åñëè îí íàöåëèëñÿ íà âàñ îðóæèåì, íà÷àë àòàêîâàòü âàñ èëè ñîáèðàòü ñîçðåâøèå êóñòû")
                                wait(1500)
                                sampSendChat(" Êàê òîëüêî ñïåö. îïåðàöèÿ çàêàí÷èâàåòñÿ, âñå îöåïëåíèå óáèðàåòñÿ")
                                wait(1500)
                                sampSendChat(" Íà ýòîì ëåêöèÿ îêîí÷åíà, âñåì ñïàñèáî")
                            end)
                        end
                        if imgui.Button(u8"Ïðàâèëî ìèðàíäû.") then
                            lua_thread.create(function()
                                sampSendChat("Ïðàâèëî Ìèðàíäû  þðèäè÷åñêîå òðåáîâàíèå â ÑØÀ")
                                wait(1500)
                                sampSendChat("Ñîãëàñíî êîòîðîìó âî âðåìÿ çàäåðæàíèÿ çàäåðæèâàåìûé äîëæåí áûòü óâåäîìëåí î ñâîèõ ïðàâàõ.")
                                wait(1500)
                                sampSendChat("Ýòî ïðàâèëî çà÷èòûâàþòñÿ çàäåðæàííîìó, à ÷èòàåò å¸ êòî ñàì çàäåðæàë åãî.")
                                wait(1500)
                                sampSendChat("Ýòî ôðàçà ãîâîðèòñÿ, êîãäà âû íàäåëè íà çàäåðæàííîãî íàðó÷íèêè.")
                                wait(1500)
                                sampSendChat("Öèòèðóþ ñàìó ôðàçó:")
                                wait(1500)
                                sampSendChat("- Âû èìååòå ïðàâî õðàíèòü ìîë÷àíèå.")
                                wait(1500)
                                sampSendChat("- Âñ¸, ÷òî âû ñêàæåòå, ìîæåò è áóäåò èñïîëüçîâàíî ïðîòèâ âàñ â ñóäå.")
                                wait(1500)
                                sampSendChat("- Âàø àäâîêàò ìîæåò ïðèñóòñòâîâàòü ïðè äîïðîñå.")
                                wait(1500)
                                sampSendChat("- Åñëè âû íå ìîæåòå îïëàòèòü óñëóãè àäâîêàòà, îí áóäåò ïðåäîñòàâëåí âàì ãîñóäàðñòâîì.")
                                wait(1500)
                                sampSendChat("- Âû ïîíèìàåòå ñâîè ïðàâà?")
                            end)
                        end
                        if imgui.Button(u8"Ïåðâàÿ Ïîìîùü.") then
                            lua_thread.create(function()
                                sampSendChat("Äëÿ íà÷àëà îïðåäåëèìñÿ ÷òî ñ ïîñòðàäàâøèì")
                                wait(1500)
                                sampSendChat("Åñëè, ó ïîñòðàäàâøåãî êðîâîòå÷åíèå, òî íåîáõîäèìî îñòàíîâèòü ïîòîê êðîâè æãóòîì")
                                wait(1500)
                                sampSendChat("Åñëè ðàíåíèå íåáîëüøîå äîñòàòî÷íî äîñòàòü íàáîð ïåðâîé ïîìîùè è ïåðåâÿçàòü ðàíó áèíòîì")
                                wait(1500)
                                sampSendChat("Åñëè â ðàíå ïóëÿ, è ðàíà íå ãëóáîêàÿ, Âû äîëæíû âûçâàòü ñêîðóþ ëèáî âûòàùèòü åå ñêàëüïåëåì, ñêàëüïåëü òàêæå íàõîäèòñÿ â àïòå÷êå ïåðâîé ïîìîùè")
                                wait(1500)
                                sampSendChat("Åñëè ÷åëîâåê áåç ñîçíàíèÿ âàì íóæíî ... ")
                                wait(1500)
                                sampSendChat(" ... äîñòàòü èç íàáîð ïåðâîé ïîìîùè âàòó è ñïèðò, çàòåì íàìî÷èòü âàòó ñïèðòîì ... ")
                                wait(1500)
                                sampSendChat(" ... è ïðîâåñòè âàòêîé ñî ñïèðòîì îêîëî íîñà ïîñòðàäàâøåãî, â ýòîì ñëó÷àå, îí äîëæåí î÷íóòüñÿ")
                                wait(1500)
                                sampSendChat("Íà ýòîì ëåêöèÿ îêîí÷åíà. Ó êîãî-òî åñòü âîïðîñû ïî äàííîé ëåêöèè?") wait(1500)
                            end)
                        end
                    end
                end
                if rang_n > 8 then
                    if imgui.Button(u8'Ïàíåëü ëèäåðà/çàìåñòèòåëÿ') then
                        leaderPanel[0] = not leaderPanel[0]
                    end
                end
            elseif tab == 5 then
                if imgui.CollapsingHeader(u8 'ÓÊ') then
                    for i = 1, #tableUk["Text"] do
                        imgui.Text(u8(tableUk["Text"][i] .. ' Óðîâåíü ðîçûñêà: ' .. tableUk["Text"][i]))
                    end
                end
                if imgui.CollapsingHeader(u8 'Òåí-êîäû') then
                    imgui.Text(u8"10-1 - Âñòðå÷à âñåõ îôèöåðîâ íà äåæóðñòâå (óêàçûâàÿ ëîêàöèþ è êîä).")
                    imgui.Text(u8"10-2 - Âûøåë â ïàòðóëü.")
                    imgui.Text(u8"10-2R: Çàêîí÷èë ïàòðóëü.")
                    imgui.Text(u8"10-3 - Ðàäèîìîë÷àíèå (óêàçûâàÿ äëèòåëüíîñòü).")
                    imgui.Text(u8"10-4 - Ïðèíÿòî.")
                    imgui.Text(u8"10-5 - Ïîâòîðèòå.")
                    imgui.Text(u8"10-6 - Íå ïðèíÿòî/íåâåðíî/íåò.")
                    imgui.Text(u8"10-7 - Îæèäàéòå.")
                    imgui.Text(u8"10-8 - Íåäîñòóïåí.")
                    imgui.Text(u8"10-14 - Çàïðîñ òðàíñïîðòèðîâêè (óêàçûâàÿ ëîêàöèþ è öåëü òðàíñïîðòèðîâêè).")
                    imgui.Text(u8"10-15 - Ïîäîçðåâàåìûå àðåñòîâàíû (óêàçûâàÿ êîëè÷åñòâî ïîäîçðåâàåìûõ è ëîêàöèþ).")
                    imgui.Text(u8"10-18 - Òðåáóåòñÿ ïîääåðæêà äîïîëíèòåëüíûõ þíèòîâ.")
                    imgui.Text(u8"10-20 - Ëîêàöèÿ.")
                    imgui.Text(u8"10-21 - Îïèñàíèå ñèòóàöèè.")
                    imgui.Text(u8"10-22 - Íàïðàâëÿþñü â ....")
                    imgui.Text(u8"10-27 - Ñìåíà ìàðêèðîâêè ïàòðóëÿ (óêàçûâàÿ ñòàðóþ ìàðêèðîâêó è íîâóþ).")
                    imgui.Text(u8"10-30 - Äîðîæíî-òðàíñïîðòíîå ïðîèñøåñòâèå.")
                    imgui.Text(u8"10-40 - Áîëüøîå ñêîïëåíèå ëþäåé (áîëåå 4).")
                    imgui.Text(u8"10-41 - Íåëåãàëüíàÿ àêòèâíîñòü.")
                    imgui.Text(u8"10-46 - Ïðîâîæó îáûñê.")
                    imgui.Text(u8"10-55 - Îáû÷íûé Òðàôôèê Ñòîï.")
                    imgui.Text(u8"10-57 VICTOR - Ïîãîíÿ çà àâòîìîáèëåì (óêàçûâàÿ ìîäåëü àâòî, öâåò àâòî, êîëè÷åñòâî ÷åëîâåê âíóòðè, ëîêàöèþ, íàïðàâëåíèå äâèæåíèÿ).")
                    imgui.Text(u8"10-57 FOXTROT - Ïåøàÿ ïîãîíÿ (óêàçûâàÿ âíåøíîñòü ïîäîçðåâàåìîãî, îðóæèå (ïðè íàëè÷èè èíôîðìàöèè î âîîðóæåíèè), ëîêàöèÿ, íàïðàâëåíèå äâèæåíèÿ).")
                    imgui.Text(u8"10-60 - Èíôîðìàöèÿ îá àâòîìîáèëå (óêàçûâàÿ ìîäåëü àâòî, öâåò, êîëè÷åñòâî ÷åëîâåê âíóòðè).")
                    imgui.Text(u8"10-61 - Èíôîðìàöèÿ î ïåøåì ïîäîçðåâàåìîì (óêàçûâàÿ ðàñó, îäåæäó).")
                    imgui.Text(u8"10-66 - Òðàôôèê Ñòîï ïîâûøåíîãî ðèñêà.")
                    imgui.Text(u8"10-70 - Çàïðîñ ïîääåðæêè (â îòëè÷èè îò 10-18 íåîáõîäèìî óêàçàòü êîëè÷åñòâî þíèòîâ è êîä).")
                    imgui.Text(u8"10-71 - Çàïðîñ ìåäèöèíñêîé ïîääåðæêè.")
                    imgui.Text(u8"10-99 - Ñèòóàöèÿ óðåãóëèðîâàíà.")
                    imgui.Text(u8"10-100 - Íàðóøåíèå þðèñäèêöèè ")
                end
                if imgui.CollapsingHeader(u8 'Ìàðêèðîâêè ïàòðóëåé') then
                    imgui.CenterText('Ìàðêèðîâêè ïàòðóëüíûõ àâòîìîáèëåé')
                    imgui.Text(u8"* ADAM (A) - ìàðêèðîâêà ïàòðóëÿ ñ äâóìÿ îôèöåðàìè íà êðóçåð")
                    imgui.Text(u8"* LINCOLN (L) - ìàðêèðîâêè ïàòðóëÿ ñ îäíèì îôèöåðîì íà êðóçåð")
                    imgui.Text(u8"* LINCOLN 10/20/30/40/50/60 - ìàðêèðîâêà ñóïåðâàéçåðà")
                    imgui.CenterText('Ìàðêèðîâêè äðóãèõ òðàíñïîðòíûõ ñðåäñòâ')
                    imgui.Text(u8"* MARY (M) - ìàðêèðîâêà ìîòîöèêëåòíîãî ïàòðóëÿ")
                    imgui.Text(u8"* AIR (AIR) - ìàðêèðîâêà þíèòà Air Support Division")
                    imgui.Text(u8"* AIR-100 - ìàðêèðîâêà ñóïåðâàéçåðà Air Support Division")
                    imgui.Text(u8"* AIR-10 - ìàðêèðîâêà ñïàñàòåëüíîãî þíèòà Air Support Division")
                    imgui.Text(u8"* EDWARD (E) - ìàðêèðîâêà Tow Unit")
                end

            elseif tab == 6 then
                imgui.Checkbox(u8 'Àâòî îòûãðîâêà îðóæèÿ', autogun)
                if autogun[0] then
                    lua_thread.create(function()
                        while true do
                            wait(0)
                            if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
                                local gun = getCurrentCharWeapon(PLAYER_PED)
                                if gun == 3 then
                                    sampSendChat("/me äîñòàë äóáèíêó ñ ïîÿñíîãî äåðæàòåëÿ")
                                elseif gun == 16 then
                                    sampSendChat("/me âçÿë ñ ïîÿñà ãðàíàòó")
                                elseif gun == 17 then
                                    sampSendChat("/me âçÿë ãðàíàòó ñëåçîòî÷èâîãî ãàçà ñ ïîÿñà")
                                elseif gun == 23 then
                                    sampSendChat("/me äîñòàë òàéçåð ñ êîáóðû, óáðàë ïðåäîõðàíèòåëü")
                                elseif gun == 22 then
                                    sampSendChat("/me äîñòàë ïèñòîëåò Colt-45, ñíÿë ïðåäîõðàíèòåëü")
                                elseif gun == 24 then
                                    sampSendChat("/me äîñòàë Desert Eagle ñ êîáóðû, óáðàë ïðåäîõðàíèòåëü")
                                elseif gun == 25 then
                                    sampSendChat("/me äîñòàë ÷åõîë ñî ñïèíû, âçÿë äðîáîâèê è óáðàë ïðåäîõðàíèòåëü")
                                elseif gun == 26 then
                                    sampSendChat("/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë Îáðåçû")
                                elseif gun == 27 then
                                    sampSendChat("/me äîñòàë äðîáîâèê Spas, ñíÿë ïðåäîõðàíèòåëü")
                                elseif gun == 28 then
                                    sampSendChat("/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë ÓÇÈ")
                                elseif gun == 29 then
                                    sampSendChat("/me äîñòàë ÷åõîë ñî ñïèíû, âçÿë ÌÏ5 è óáðàë ïðåäîõðàíèòåëü")
                                elseif gun == 30 then
                                    sampSendChat("/me äîñòàë êàðàáèí AK-47 ñî ñïèíû")
                                elseif gun == 31 then
                                    sampSendChat("/me äîñòàë êàðàáèí Ì4 ñî ñïèíû")
                                elseif gun == 32 then
                                    sampSendChat("/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë TEC-9")
                                elseif gun == 33 then
                                    sampSendChat("/me äîñòàë âèíòîâêó áåç ïðèöåëà èç âîåííîé ñóìêè")
                                elseif gun == 34 then
                                    sampSendChat("/me äîñòàë Ñíàéïåðñêóþ âèíòîâêó ñ âîåííîé ñóìêè")
                                elseif gun == 43 then
                                    sampSendChat("/me äîñòàë ôîòîêàìåðó èç ðþêçàêà")
                                elseif gun == 0 then
                                    sampSendChat("/me ïîñòàâèë ïðåäîõðàíèòåëü, óáðàë îðóæèå")
                                end
                                lastgun = gun
                            end
                        end
                    end)
                end
                imgui.Checkbox(u8'Àâòî-äîêëàä ïàòðóëÿ êàæäûå 10 ìèíóò(âêëþ÷àòü ïðè íà÷àëå)/]. Âñåãî 30 ìèíóò', patrul)
                imgui.InputText(u8'Íèê âàøåãî íàïàðíèêà(íà àíãëèñêîì)', partner, 255)
                partnerNick = u8:decode(ffi.string(partner))
                imgui.Checkbox(u8'Ïîçûâíîé ïðè äîêëàäàõ', pozivn)
                imgui.InputText(u8'Âàø ïîçûâíîé', poziv, 255)
                pozivnoi = u8:decode(ffi.string(poziv))
                if patrul[0] and pozivn[0] then
                    poziv[0] = false
                    patrul[0] = false
                    lua_thread.create(function()
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Âûõîæó â ïàòðóëü. Íàïàðíèê - " .. partnerNick .. ". Äîñòóïåí.")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Ïðîäîëæàþ ïàòðóëü ñ " .. partnerNick .. ". Ñîñòîÿíèå ñòàáèëüíîå. Äîñòóïåí")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Ïðîäîëæàþ ïàòðóëü ñ " .. partnerNick .. ". Ñîñòîÿíèå ñòàáèëüíîå. Äîñòóïåí")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Çàêàí÷èâàþ ïàòðóëü ñ " .. partnerNick .. ".")
                    end)
                elseif patrul[0] then
                    lua_thread.create(function()
                        patrul[0] = false
                        sampSendChat("/r " .. nickname .. ". Âûõîæó â ïàòðóëü. Íàïàðíèê - " .. partnerNick .. ". Äîñòóïåí.")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Ïðîäîëæàþ ïàòðóëü ñ " .. partnerNick .. ". Ñîñòîÿíèå ñòàáèëüíîå. Äîñòóïåí")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Ïðîäîëæàþ ïàòðóëü ñ " .. partnerNick .. ". Ñîñòîÿíèå ñòàáèëüíîå. Äîñòóïåí")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Çàêàí÷èâàþ ïàòðóëü ñ " .. partnerNick .. ".")
                    end)

                end
                imgui.Checkbox(u8'Àâòî-Àêöåíò', AutoAccentBool)
                if AutoAccentBool[0] then
                    AutoAccentCheck = true
                    mainIni.Accent.autoAccent = true
                    inicfg.save(mainIni, "mvdhelper.ini")
                else
                    mainIni.Accent.autoAccent = false
                    inicfg.save(mainIni, "mvdhelper.ini")
                end
                imgui.InputText(u8'Àêöåíò', AutoAccentInput, 255)
                AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
                mainIni.Accent.accent = AutoAccentText
                inicfg.save(mainIni, "mvdhelper.ini")
                if imgui.Button(u8'Âñïîìîãàòåëüíîå îêîøêî') then
                	suppWindow[0] = not suppWindow [0]

				end
            elseif tab == 7 then
                imgui.Text(u8'Âåðñèÿ: 4.8')
                imgui.Text(u8'Ðàçðàáîò÷èê: @Sashe4ka_ReZoN and @daniel29032012')
                imgui.Text(u8'ÒÃ êàíàë: @lua_arz')
                imgui.Text(u8'Ïîääåðæàòü: https://qiwi.com/n/SASHE4KAREZON')
                imgui.Text(u8'Ñïîíñîðû: @Negt,@King_Rostislavia,@sidrusha,@Timur77998')
                imgui.Text(u8'Ñäåëàíî Ïðè ïîääåðæêå Arzfun Mobile(áåñïëàòíàÿ àäìèíêà) @ArizonaMobileFun')
                imgui.Text(u8'Ìóíìîíåò çäåëàí ñ ïîìîùüþ @UxyOy')
                imgui.Text(u8'Îáíîâëåíèå 4.1 - Èçìåíåíèå èíòåðôåéñà, äîáàâëåíèå âêëàäîê "Èíôî" è "Äëÿ ÑÑ". Äîáàâëåí àâòî àêöåíò. Ôèêñ áàãîâ.')
                imgui.Text(u8'Îáíîâëåíèå 4.2 - Ôèêñ àâòî îïðåäåëåíèÿ. Äîñòóï ê ïàíåëèè ÑÑ ñ ëþáîãî ðàíãà(Ïàíåëü ëèäåðà òàêæå îñòàåòñÿ îò 9 ðàíãà).')
                imgui.Text(u8'Îáíîâëåíèå 4.3 - Ôèêñ ïðèâåòñòâèÿ. Äîáàâëåííî ÔÁÐ â ñïèñîê îðãàíèçàöèé')
                imgui.Text(u8'Îáíîâëåíèå 4.4 - Äîáàâèëè ëåêöèè,Ïàíåëü ëèäåðà(â ðàçðàáîòêå)')
                imgui.Text(u8'Îáíîâëåíèå 4.5 - Òåïåðü ìîæíî ïîñòàâèòü ñâîé ÓÊ. Äîáàâëåíà ôèîëåòîâàÿ òåìà. Îáíîâëåí /mvds')
                imgui.Text(u8'Îáíîâëåíèå 4.6 - Ôèêñ áàãîâ,Èçìåíåíû íåêîòîðûå îòûãðîâêè')
                imgui.Text(u8'Îáíîâëåíèå 4.7 - Äîáàâëåíà Êîìàíäà /traf ïîôèêøåíû áàãè,àâòî àêöåíò è èçìåíåííû íåêîòîðûå îòûãðîâêè')
                imgui.Text(u8'Îáíîâëåíèå 4.8 - Ìóíìîíåò,àâòî îáíîâà')
                if imgui.Button(u8'Îáíîâèòü') then
            		updateScript(scriptUrl, scriptPath)
            	end
            end
            -- == [Îñíîâíîå] Ñîäåðæèìîå âêëàäîê çàêîí÷èëîñü == --
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
    sampRegisterChatCommand("gcuff",cmd_gcuff)
    sampRegisterChatCommand("fbi.pravda", cmd_pravda_fbi)
    sampRegisterChatCommand("fbi.secret", cmd_secret_fbi)
    sampRegisterChatCommand("finger.p", cmd_finger_person)
    sampRegisterChatCommand("podmoga", cmd_warn)
    sampRegisterChatCommand("mvds",cmd_mvds)
    sampRegisterChatCommand("stop", cmd_stop)
    sampRegisterChatCommand("grim", cmd_grim)
    sampRegisterChatCommand("eks", cmd_eks)
    sampRegisterChatCommand("traf", cmd_traf)
    sampRegisterChatCommand("agenda", cmd_agenda)
    sampRegisterChatCommand("time",cmd_time)
end

function sampev.onSendSpawn()
	if spawn and isMonetLoader() then
		spawn = false
		sampSendChat('/stats')
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Ñêðèïò óñïåøíî çàãðóçèëñÿ", 0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Àâòîðû:t.me/Sashe4ka_ReZoN and t.me/daniel29032012",0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}×òîáû ïîñìîòðåòü êîììàíäû,ââåäèòå /mvd è /mvds ",0x8B00FF)
        nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 235 and title == "{BFBBBA}Îñíîâíàÿ ñòàòèñòèêà" then
        statsCheck = true
        if string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ËÂ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ËÑ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ÑÔ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "SFa" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "LSa" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "RCSD"  or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Îáëàñòíàÿ ïîëèöèÿ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "ÔÁÐ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "FBI" then
            org = string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]")
            if org ~= 'Íå èìååòñÿ' then dol = string.match(text, "Äîëæíîñòü: {B83434}(%D+)%(%d+%)") end
            dl = u8(dol)
            if org == 'Ïîëèöèÿ ËÂ' then org_g = u8'LVPD'; ccity = u8'Ëàñ-Âåíòóðàñ'; org_tag = 'LVPD' end
            if org == 'Ïîëèöèÿ ËÑ' then org_g = u8'LSPD'; ccity = u8'Ëîñ-Ñàíòîñ'; org_tag = 'LSPD' end
            if org == 'Ïîëèöèÿ ÑÔ' then org_g = u8'SFPD'; ccity = u8'Ñàí-Ôèåððî'; org_tag = 'SFPD' end
            if org == 'ÔÁÐ' then org_g = u8'FBI'; ccity = u8'Ñàí-Ôèåððî'; org_tag = 'FBI' end
            if org == 'FBI' then org_g = u8'FBI'; ccity = u8'Ñàí-Ôèåððî'; org_tag = 'FBI' end
            if org == 'RCSD' or org == 'Îáëàñòíàÿ ïîëèöèÿ' then org_g = u8'RCSD'; ccity = u8'Red Country'; org_tag = 'RCSD' end
            if org == 'LSa' or org == 'Àðìèÿ Ëîñ Ñàíòîñ' then org_g = u8'LSa'; ccity = u8'Ëîñ Ñàíòîñ'; org_tag = 'LSa' end
            if org == 'SFa' or org == 'Àðìèÿ Ñàí Ôèåððî' then org_g = u8'SFa'; ccity = u8'Ñàí Ôèåððî'; org_tag = 'SFa' end
            if org == '[Íå èìååòñÿ]' then
                org = 'Âû íå ñîñòîèòå â ÏÄ'
                org_g = 'Âû íå ñîñòîèòå â ÏÄ'
                ccity = 'Âû íå ñîñòîèòå â ÏÄ'
                org_tag = 'Âû íå ñîñòîèòå â ÏÄ'
                dol = 'Âû íå ñîñòîèòå â ÏÄ'
                dl = 'Âû íå ñîñòîèòå â ÏÄ'
            else
                rang_n = tonumber(string.match(text, "Äîëæíîñòü: {B83434}%D+%((%d+)%)"))
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
    -- == Äåêîð ÷àñòü == --
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
    decor() -- ïðèìåíÿåì äåêîð ÷àñòü
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 20, config, iconRanges) -- solid - òèï èêîíîê, òàê æå åñòü thin, regular, light è duotone
	local tmp = imgui.ColorConvertU32ToFloat4(mainIni.theme['moonmonet'])
	gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
	mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
	apply_n_t()
end)

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function cmd_showpass(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/showpass [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîñòàë ïàïêó ñ äîêóìåíòàìè")
            wait(1500)
            sampSendChat("/do Ïàïêà â ðóêå.")
            wait(1500)
            sampSendChat("/me äîñòàë ïàñïîðò")
            wait(1500)
            sampSendChat("/do Ïàñïîðò â ðóêå.")
            wait(1500)
            sampSendChat("/me ïåðåäàë ïàñïîðò ÷åëîâåêó íà ïðîòèâ")
            wait(1500)
            sampSendChat("/showpass " .. id .. " ")
        end)
    end
end

function cmd_showbadge(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/showbadge [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me èç âíóòðåííåãî êàðìàíà äîñòàë óäîñòîâåðåíèå")
            wait(1500)
            sampSendChat("/me îòêðûë äîêóìåíò â ðàçâ¸ðíóòîì âèäå, ïîêàçàë ñîäåðæèìîå ÷åëîâåêó íàïðîòèâ")
            wait(1500)
            sampSendChat("/do Íèæå íàõîäèòñÿ ïå÷àòü ïðàâèòåëüñòâà è ïîäïèñü.")
            wait(1500)
            sampSendChat("/me çàêðûë äîêóìåíò , óáðàë åãî îáðàòíî â êàðìàí")
            wait(1500)
            sampSendChat ("/showbadge "..id.." ")
        end)
    end
end

function cmd_showlic(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/showlic [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîñòàë ïàïêó ñ äîêóìåíòàìè")
            wait(1500)
            sampSendChat("/do Ïàïêà â ðóêå.")
            wait(1500)
            sampSendChat("/me äîñòàë ëèöåíçèè")
            wait(1500)
            sampSendChat("/do Ëèöåíçèè â ðóêå.")
            wait(1500)
            sampSendChat("/me ïåðåäàë ëèöåíçèè ÷åëîâåêó íà ïðîòèâ")
            wait(1500)
            sampSendChat("/showlic " .. id .. " ")
        end)
    end
end

function cmd_mvds(id)
        lua_thread.create(function()
        sampShowDialog(1,"Êîìàíäû MVD HELPER 4.7", "/showlic -  Ïîêàçûâàåò âàøè ëèöåíçèè\n/showpass - Ïîêàçûâàåò âàø ïàñïîðò\n/showmc - Ïîêàçûâàåò âàøó Ìåä. Êàðòó\n/showskill - Ïîêàçûâàåò âàøè íàâûêè îðóæèÿ\n/showbadge - Ïîêàçàòü âàøå óäîñòîâåðåíèå ÷åëîâåêó\n/pull - Âûêèäûâàåò ÷àëîâåêà èç àâòî è îãëóøàåò\n/uninvite - Óâîëèòü ÷åëîâåêà èç îðãàíèçàöèè\n/invite - Ïðèíÿòü ÷åëîâåêà â îðãàíèçàöèþ\n/cuff - Íàäåòü íàðó÷íèêè\n/uncuff - Ñíÿòü íàðó÷íèêè\n/frisk - Îáûñêàòü ÷åëîâåêà\n/mask - Íàäåòü ìàñêó\n/arm - Ñíÿòü/Íàäåòü áðîíèæåëåò\n/asu - Âûäàòü ðîçûñê\n/drug - Èñïîëüçîâàòü íàðêîòèêè\n/arrest - Ìåòêà äëÿ àðåñòà ÷åëîâåêà\n/stop - 10-55 Òðàôôèê-Ñòîï\n/giverank - Âûäàòü ðàíã ÷åëîâåêó\n/unmask - Ñíÿòü ìàñêó ñ ïðåñòóïíèêà\n/miranda - Çà÷èòàòü ïðàâà\n/bodyon - Âêëþ÷èòü Áîäè-Êàìåðó\n/bodyoff - Âûêëþ÷èòü Áîäè-Êàìåðó\n/ticket - Âûïèñàòü øòðàô\n/pursuit - Âåñòè ïðåñëåäîâàíèå çà èãðîêîì\n/drugtestno - Òåñò íà íàðêîòèêè ( Îòðèöàòåëüíûé )\n/drugtestyes - Òåñò íà íàðêîòèêè ( Ïîëîæèòåëüíûé )\n/vzatka - Ðï Âçÿòêà\n/bomb - Ðàçìèíèðîâàíèå áîìáû\n/dismiss - Óâîëèòü ÷åëîâåêà èç îðãàíèçàöèè ( 6 ÔÁÐ )\n/demoute - Óâîëèòü ÷åëîâåêà èç îðãàíèçàöèè ( 9 ÔÁÐ )\n/cure - Âûëå÷èòü äðóãà êîòîðîãî ïîëîæèëè\n/find - Îòûãðîâêà ïîèñêà ïðåñòóïíèêà\n/incar - Ïîñàäèòü ïðåñòóïíèêà â ìàøèíó\n/tencodes - Òåí Êîäû\n/marks - Ìàðêè Àâòî\n/sitcodes - Ñèòóàöèîííûå Êîäû\n/zsu - Çàïðîñ â ðîçûñê\n/mask - Íàäåòü ìàñêó\n/take - Çàáðàòü çàïðåù¸íûå âåùè\n/gcuff - cuff + gotome\n/fbi.secret - äîêóìåíò î íåðàçãëàøåíèè äåÿòåëüíîñòè ÔÁÐ\n/fbi.pravda - Äîêóìåíò î ïðàâäèâîñòè ñëîâ íà äîïðîñå\n/finger.p - Ñíÿòèå îòïå÷àòêîâ ïàëüöåâ ÷åëîâåêà\n/podmoga - Âûçîâ ïîäìîãè â /r\n/traf - Ïîãîíÿ 10-55\n/grim - Íàíåñåíèå ãðèìà\n/eks - Ýêñïåðòèçà îðóæèå\n/traf - íå ïîìíþ\nÀâòîð:t.me/Sashe4ka_ReZoN and t.me/daniel29032012", "Çàêðûòü", "Exit", 0)
        end)
        end


function cmd_showskill(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/showskill [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîñòàë ïàïêó ñ äîêóìåíòàìè")
            wait(1500)
            sampSendChat("/do Ïàïêà â ðóêå.")
            wait(1500)
            sampSendChat("/me äîñòàë âûïèñêó ñ òèðà")
            wait(1500)
            sampSendChat("/do Âûïèñêà â ðóêå.")
            wait(1500)
            sampSendChat("/me ïåðåäàë âûïèñêó ÷åëîâåêó íà ïðîòèâ")
            wait(1500)
            sampSendChat("/showskill " .. id .. " ")
        end)
    end
end

function cmd_showmc(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/showmc [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîñòàë ïàïêó ñ äîêóìåíòàìè")
            wait(1500)
            sampSendChat("/do Ïàïêà â ðóêå.")
            wait(1500)
            sampSendChat("/me äîñòàë ìåä. êàðòó")
            wait(1500)
            sampSendChat("/do Ìåä. êàðòà â ðóêå.")
            wait(1500)
            sampSendChat("/me ïåðåäàë ìåä. êàðòó ÷åëîâåêó íà ïðîòèâ")
            wait(1500)
            sampSendChat("/showmc " .. id .. " ")
        end)
    end
end

function cmd_pull(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/pull [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/pull " .. id .. " ")
            wait(1500)
            sampSendChat("/me ñõâàòèë äóáèíêó ñ ïîÿñà, ðåçêèì âçìàõîì åå è íà÷àë áèòü ïî îêíó âîäèòåëÿ")
            wait(1500)
            sampSendChat("/me ðàçáèâ ñòåêëî, îòêðûë äâåðü èçíóòðè è ñõâàòèë âîäèòåëÿ çà îäåæäó ...")
            wait(1500)
            sampSendChat("/me ... ïîñëå ÷åãî, âûáðîñèë ïîäîçðåâàåìîãî íà àñôàëüò è çàëîìàë åãî ðóêè")

        end)
    end
end

function cmd_invite(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/invite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Ïîä ñòîéêîé íàõîäèòñÿ ðþêçàê.")
            wait(1500)
            sampSendChat("/do Ôîðìà â ðþêçàêå...")
            wait(1500)
            sampSendChat("/me ñóíóë ðóêó â ðþêçàê, ïîñëå ÷åãî âçÿë ôîðìó è áåéäæèê â ðóêè")
            wait(1500)
            sampSendChat("/me ïåðåäà¸ò ôîðìó è áåéäæèê")
            wait(1500)
            sampSendChat("/todo Èäèòå ïåðåîäåíüòåñü*óêàçûâàÿ ïàëüöåì íà äâåðü ðàçäåâàëêè")
            wait(1500)
            sampSendChat("/invite " .. id .. " ")
        end)
    end
end

function cmd_uninvite(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/uninvite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat ("/do Íà ïîÿñå çàêðåïëåí ÊÏÊ.")
            wait(1500)
            sampSendChat("/me ñíèìàåò ÊÏÊ ñ ïîÿñà è íàæàòèåì êíîïêè âêëþ÷àåò åãî.")
            wait(1500)
            sampSendChat ("/me çàõîäèò â áàçó ñîòðóäíèêîâ è âûáèðàåò íóæíîãî, ïîñëå ÷åãî íàæèìàåò íà êíîïêó *Óâîëèòü*.")
            wait(1500)
            sampSendChat ("/me âûêëþ÷àåò ÊÏÊ è âåøàåò îáðàòíî íà ïîÿñ.")
            wait(1500)
            sampSendChat("/uninvite " .. id .. " ")
        end)
    end
end

function cmd_cuff(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/cuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Íàðó÷íèêè âèñÿò íà ïîÿñå.")
            wait(1500)
            sampSendChat("/me ñíÿë ñ äåðæàòåëÿ íàðó÷íèêè")
            wait(1500)
            sampSendChat("/do Íàðó÷íèêè â ðóêàõ.")
            wait(1500)
            sampSendChat("/me ðåçêèì äâèæåíèåì îáåèõ ðóê, íàäåë íàðó÷íèêè íà ïðåñòóïíèêà")
            wait(1500)
            sampSendChat("/do Ïðåñòóïíèê ñêîâàí.")
            wait(1500)
            sampSendChat("/cuff "..id.." ")
         end)
      end
   end

function cmd_uncuff(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/uncuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Êëþ÷ îò íàðó÷íèêîâ â êàðìàíå.")
            wait(1500)
            sampSendChat("/me äâèæåíèåì ïðàâîé ðóêè äîñòàë èç êàðìàíà êëþ÷ è îòêðûë íàðó÷íèêè")
            wait(1500)
            sampSendChat("/do Ïðåñòóïíèê ðàñêîâàí.")
            wait(1500)
            sampSendChat("/uncuff "..id.." ")
        end)
     end
  end

function cmd_gotome(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/gotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me çàëîìèë ïðàâóþ ðóêó íàðóøèòåëþ")
            wait(1500)
            sampSendChat("/me âåäåò íàðóøèòåëÿ çà ñîáîé")
            wait(1500)
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_ungotome(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/ungotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me îòïóñòèë ïðàâóþ ðóêó ïðåñòóïíèêà")
            wait(1500)
            sampSendChat("/do Ïðåñòóïíèê ñâîáîäåí.")
            wait(1500)
            sampSendChat("/ungotome "..id.." ")
        end)
     end
  end

function cmd_gcuff(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/gcuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Íàðó÷íèêè âèñÿò íà ïîÿñå.")
            wait(1500)
            sampSendChat("/me ñíÿë ñ äåðæàòåëÿ íàðó÷íèêè")
            wait(1500)
            sampSendChat("/do Íàðó÷íèêè â ðóêàõ.")
            wait(1500)
            sampSendChat("/me ðåçêèì äâèæåíèåì îáåèõ ðóê, íàäåë íàðó÷íèêè íà ïðåñòóïíèêà")
            wait(1500)
            sampSendChat("/do Ïðåñòóïíèê ñêîâàí.")
            wait(1500)
            sampSendChat("/cuff "..id.." ")
            wait(1500)
            sampSendChat("/me çàëîìèë ïðàâóþ ðóêó íàðóøèòåëþ")
            wait(1500)
            sampSendChat("/me âåäåò íàðóøèòåëÿ çà ñîáîé")
            wait(1500)
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_frisk(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/frisk [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me íàäåâ ðåçèíîâûå ïåð÷àòêè, íà÷àë ïðîùóïûâàòü ãðàæäàíèíà ïî âñåìó òåëó ...")
            wait(1500)
            sampSendChat("/do Ïåð÷àòêè íàäåòû.")
            wait(1500)
            sampSendChat("/me ïðîâîäèò ðóêàìè ïî âåðõíåé ÷àñòè òåëà")
            wait(1500)
            sampSendChat("/me ... çà òåì íà÷àë òùàòåëüíî îáûñêèâàòü ãðàæäàíèíà, âûêëàäûâàÿ âñ¸ äëÿ èçó÷åíèÿ")
            wait(1500)
            sampSendChat("/frisk " .. id .. " ")
        end)
    end
end


function cmd_pursuit(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/pursuit [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do ÊÏÊ â ëåâîì êàðìàíå.")
            wait(1500)
            sampSendChat("/me äîñòàë ÊÏÊ èç ëåâîãî êàðìàíà")
            wait(1500)
            sampSendChat("/me âêëþ÷èë ÊÏÊ è çàøåë â áàçó äàííûõ Ïîëèöèè")
            wait(1500)
            sampSendChat("/me îòêðûë äåëî ñ äàííûìè ïðåñòóïíèêà")
            wait(1500)
            sampSendChat("/do Äàííûå ïðåñòóïíèêà ïîëó÷åíû.")
            wait(1500)
            sampSendChat("/me ïîäêëþ÷èëñÿ ê êàìåðàì ñëåæåíèÿ øòàòà")
            wait(1500)
            sampSendChat("/pursuit " .. id .. " ")
        end)
    end
end

function cmd_arm(id)
        lua_thread.create(function()
            sampSendChat("/armour")
            wait(1500)
            sampSendChat("/me ñìåíèë ïëàñòèíû â áðîíèæåëåòå")
        end)
    end

    function cmd_agenda(id)
        if id == "" then
            sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/agenda [ID].",0x318CE7FF -1)
        else
            lua_thread.create(function()
                sampSendChat("/do Â íàãðóäíîì êàðìàíå ëåæàò áëàíêè ïîâåñòîê.")
                wait(1500)
                sampSendChat("/me ïåðåêëàäûâàåò ïàñïîðò â ëåâóþ ðóêó")
                wait(1500)
                sampSendChat("/me âûòÿãèâàåò èç íàãðóäíîãî êàðìàíà îäèí áëàíê, ðàçâîðà÷èâàåò åãî è íà÷èíàåò çàïîëíÿòü")
                wait(1500)
                sampSendChat("/me ïåðåïèñûâàåò âñå äàííûå èç ïàñïîðòà, ïîñëå ÷åãî ñòàâèò ïîäïèñü")
                wait(1500)
                sampSendChat("/todo Âîò, ðàñïèøèòåñü*ïåðåäàâàÿ áóìàãè ÷åëîâåêó íàïðîòèâ")
                wait(1500)
                sampSendChat("/agenda " .. id .. " ")
            end)
        end
    end

function cmd_mask()
lua_thread.create(function()
            sampSendChat("/mask")
            wait(1500)
            sampSendChat("/me íàäåë íà ðóêè ïåð÷àòêè, íàäåë áàëàêëàâó íà ëèöî")
        end)
    end

function cmd_drug(id)
    if id == "" then
         sampAddChatMessage("Ââåäè êîë-âî íàðêî [1-3]: {FFFFFF}/usedrugs [1-3].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äîñòàë èç êàðìàíà êîíôåòêó ðîøåí")
            wait(1200)
            sampSendChat("/do Ñíÿë ôàíòèê, ñúåë åå.")
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
		sampSendChat("/me ñíÿë ðàöèþ ñ ãðóäíîãî äåðæàòåëÿ è ñîîáùèë äèñïåò÷åðó î íàðóøèòåëå")
        wait(1000)
        sampSendChat("/do Ñïóñòÿ ïîëìèíóòû ïîëó÷èë îòâåò îò äèñïåò÷åðà.")
        wait(1000)
        sampSendChat("/todo 10-4, Êîíåö ñâÿçè.*ïîâåñèâ ðàöèþ íà ãðóäíîé äåðæàòåëü")
    else
		sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/asu [ID] [Êîë-âî ðîçûñêà] [Ïðè÷èíà].", 0x318CE7FF -1)
		end
	end)
end


function cmd_arrest(id)
    if id == "" then
         sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/arrest [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me íàæàâ íà òàíãåòó, ñîîáùèë äèñïåò÷åðó î ïðîâåçåííîì ïðåñòóïíèêè ...")
            wait(1500)
            sampSendChat("/me çàïðîñèë îôèöåðîâ äëÿ ñîïðîâîæäåíèÿ")
            wait(1500)
            sampSendChat("/do Äåïàðòàìåíò: Ïðèíÿòî, îæèäàéòå äâóõ îôèöåðîâ.")
            wait(1500)
            sampSendChat("/do Èç ó÷àñòêà âûõîäÿò 2 îôèöåðà, ïîñëå çàáèðàþò ïðåñòóïíèêà.")
            sampSendChat("/arrest "..id.." ")
        end)
    end
   end

function cmd_giverank(arg)
    lua_thread.create(function()
        local arg1, arg2 = arg:match('(.+) (.+)')
        if arg1 ~= nil and arg2 ~= nil then
            sampSendChat('/giverank '..arg1..' '..arg2..'')
            wait(1500)
            sampSendChat("/do Íà ïîÿñå çàêðåïëåí ÊÏÊ.")
            wait(1500)
            sampSendChat("/me ñíèìàåò ÊÏÊ ñ ïîÿñà è íàæàòèåì êíîïêè âêëþ÷àåò åãî")
            wait(1500)
            sampSendChat("/me çàõîäèò â áàçó ñîòðóäíèêîâ è ââîäèò èçìåíåíèÿ, ïîñëå ÷åãî âåøàåò ÊÏÊ îáðàòíî íà ïîÿñ")
            wait(1500)
            sampSendChat("/todo Íîâàÿ ôîðìà â øêàô÷èêå*óëûáàÿñü âçãëÿíóâ â ñòîðîíó äâåðè")
            wait(1500)
        else
            sampAddChatMessage("Ââåäè àéäè èãðîêà:{FFFFFF}/giverank [ID] [Ðàíã 1-9].",0x318CE7FF -1)
        end
    end)
end

function cmd_unmask(id)
    if id == nil or id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/unmask [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me äåðæà ïîäîçðåâàåìîãî, ëåâîé ðóêîé íàñèëüíî ñäèðàåò ìàñêó ñ ÷åëîâåêà")
            wait(1500)
            sampSendChat("/unmask "..id.." ")
        end)
    end
end

function cmd_miranda()
lua_thread.create(function()
            sampSendChat("Âû èìååòå ïðàâî õðàíèòü ìîë÷àíèå.")
            wait(1500)
            sampSendChat("Âñ¸, ÷òî âû ñêàæåòå, ìû ìîæåì è áóäåì èñïîëüçîâàòü ïðîòèâ âàñ â ñóäå.")
            wait(1500)
            sampSendChat("Âû èìååòå ïðàâî íà àäâîêàòà è íà îäèí òåëåôîííûé çâîíîê.")
            wait(1500)
            sampSendChat("Åñëè ó âàñ íåò àäâîêàòà, ãîñóäàðñòâî ïðåäîñòàâèò âàì àäâîêàòà, óâèäåòü êîòîðîãî âû ñìîæåòå â çàëå ñóäà.")
            wait(1500)
            sampSendChat("Âàì ïîíÿòíû âàøè ïðàâà?")
        end)
     end

function cmd_bodyon()

        lua_thread.create(function()
            sampSendChat("/do Íà ãðóäè  âåñèò êàìåðà AXON BODY 3.")
            wait(1500)
            sampSendChat("/me ëåãêèì äâèæåíèåì ðóêè ïðîòÿíóëñÿ ê ñåíñîðó è íàæàë îäèí ðàç äëÿ àêòèâàöèè")
            wait(1500)
            sampSendChat("/do Áîäè êàìåðà èçäàëà çâóê è âêëþ÷èëàñü.")
        end)
     end

function cmd_bodyoff()

lua_thread.create(function()
            sampSendChat("/do Íà ãðóäè  âåñèò êàìåðà AXON BODY 3.")
            wait(1500)
            sampSendChat("/me ëåãêèì äâèæåíèåì ðóêè ïðîòÿíóëñÿ ê ñåíñîðó è íàæàë îäèí ðàç äëÿ äåàêòèâàöèè")
            wait(1500)
            sampSendChat("/do Áîäè êàìåðà èçäàëà çâóê è âûêëþ÷èëàñü")
        end)
     end


function cmd_ticket(arg)
    lua_thread.create(function()
        local id, prichina, price = arg:match('(%d+)%s(%d+)%s(.)')
        if id ~= nil and prichina ~= nil and price ~= nil then
                sampSendChat("/me äîñòàâ íåáîëüøîé òåðìèíàë, ïðèñîåäèíèë åãî ê ÊÏÊ è ïîêàçàë ïðè¸ìíèê äëÿ êàðòû")
                wait(1500)
                sampSendChat("/todo Âñòàâüòå ñíà÷àëà âîäèòåëüñêóþ, çàòåì êðåäèòíóþ êàðòó â ïðè¸ìíèê!*äåðæà òåðìèíàë")
                wait(1500)
                sampSendChat('/ticket '..id..' '..prichina..'  '..price..' ')
         else
      sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/ticket [ID] [Ñóììà] [Ïðè÷èíà].", 0x318CE7FF)
      end
     end)
    end

function cmd_pursuit(id)
    if id == "" then
         sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/pursuit [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
            sampSendChat("/me ïîëîæèâ ðóêè íà êëàâèàòóðó áîðòîâîãî êîìïüþòåðà, íà÷àë ïîèñê ïî áàçå äàííûõ ïî èìåíè")
            wait(1500)
            sampSendChat("/me íàéäÿ èìÿ, ïðîâåðèë íîìåð òåëåôîíà è âêëþ÷èë îòñëåæèâàíèÿ ïî ÃÏÑ")
            wait(1500)
            sampSendChat("/pursuit "..id.." ")
        end)
     end
  end

function cmd_drugtestno()
lua_thread.create(function()
            sampSendChat("/me äîñòàë èç ïîäñóìêà íàáîð Drug-test")
            wait(1500)
            sampSendChat("/me âçÿë èç íàáîðà ïðîáèðêó ñ ýòèëîâûì ñïèðòîì")
            wait(1500)
            sampSendChat("/me íàñûïàë â ïðîáèðêó íàéäåíîå âåùåñòâî")
            wait(1500)
            sampSendChat ("/me äîáàâèë â ïðîáèðêó òåñò Èìóíî-Õðîì-10")
            wait(1700)
            sampSendChat("/me ðåçêèìè äâèæåíèÿìè âçáàëòûâàåò ïðîáèðêó")
            wait(1700)
            sampSendChat("/do Òåñò äàë îòðèöàòåëüíûé ðåçóëüòàò, âåùåñòâî íå ÿâëÿåòñÿ íàðêîòèêîì.")
        end)
     end


function cmd_drugtestyes()
lua_thread.create(function()
            sampSendChat("/me äîñòàë èç ïîäñóìêà íàáîð Drug-test")
            wait(1500)
            sampSendChat("/me âçÿë èç íàáîðà ïðîáèðêó ñ ýòèëîâûì ñïèðòîì")
            wait(1500)
            sampSendChat("/me íàñûïàë â ïðîáèðêó íàéäåíîå âåùåñòâî")
            wait(1500)
            sampSendChat ("/me äîáàâèë â ïðîáèðêó òåñò Èìóíî-Õðîì-10")
            wait(1700)
            sampSendChat("/me ðåçêèìè äâèæåíèÿìè âçáàëòûâàåò ïðîáèðêó")
            wait(1700)
            sampSendChat("/do Òåñò äàë ïîëîæèòåëüíûé ðåçóëüòàò, âåùåñòâî ÿâëÿåòñÿ íàðêîòèêîì.")
        end)
     end

function cmd_vzatka()
lua_thread.create(function()
         sampSendChat("/me ñìîòðèò íà çàäåðæàííîãî, äîñòà¸ò ñ áàðäà÷êà ðó÷êó è ëèñòî÷åê.")
         wait(1500)
         sampSendChat("/me ïèøåò íà ëèñòî÷êå ñóììó ñ øåñòüþ íóëÿìè, êèäàåò íà çàäíåå ñèäåíüå.")
         wait(1500)
         sampSendChat("/do Íà ëèñòî÷êå íåáðåæíî è êîðÿâî áûëî íàïèñàíî: 5.000.000$.")
      end)
   end


function cmd_bomb()
lua_thread.create(function()
         sampSendChat("/do Ïåðåä ÷åëîâåêîì íàõîäèòñÿ áîìáà, íà áîìáå çàâåäåí òàéìåð.")
         wait(1500)
         sampSendChat("/do Íà áðîíåæèëåòå çàêðåïëåíà íåáîëüøàÿ ñóìêà ñàï¸ðà.")
         wait(1500)
         sampSendChat("/me îòêðûâ ñóìêó ïîòÿíóëñÿ çà ñïåöèàëüíûì ÊÏÊ äëÿ ðàçìèíèðîâàíèÿ áîìá")
         wait(1500)
         sampSendChat("/me äîñòàë ÊÏÊ èç ñóìêè âêëþ÷èë åãî, ñôîòîãðàôèðîâàë íà íåãî áîìáó è òàéìåð, ...")
         wait(1500)
         sampSendChat("/me ... ïîñëå ñâÿçàâøèñü ñ äèñïåò÷åðîì ïåðåñëàë ñäåëàííûå ñíèìêè")
         wait(1500)
         sampSendChat("/do [Äèñïåò÷åð]: - Ìû ïîëó÷èëè ñíèìêè, òèï áîìáû PR-256, îãëàøàþ ïîðÿäîê äåéñòâèé.")
         wait(1500)
         sampSendChat("/do [Äèñïåò÷åð]: - Ê äàííîìó òèïó áîìáû ìîæíî ïîäêëþ÷èòüñÿ ïî ñåòè, äåéñòâóéòå.")
         wait(1500)
         sampSendChat("/me íàæàë â ÊÏÊ êíîïêó search for the nearest device, ïîñëå ÷åãî ÊÏÊ íà÷àë ïîèñê")
         wait(1500)
         sampSendChat("/do ÊÏÊ âûäàë óñòðîéñòâî INNPR-256NNI.")
         wait(1500)
         sampSendChat("/me ïîäêëþ÷èëñÿ ê óñòðîéñòâó, ïîñëå äîëîæèë îá ýòîì äèñïåò÷åðó")
         wait(1500)
         sampSendChat("/do [Äèñïåò÷åð]: - Äà, âû ïîäêëþ÷èëèñü, òåïåðü ââåäèòå êîä 1-0-5-J-J-Q-G-2-2.")
         wait(1500)
         sampSendChat("/me íà÷àë ââîäèòü êîä íàçâàííûé äèñïåò÷åðîì")
         wait(1500)
         sampSendChat("/do Òàéìåð íà áîìáå îñòàíîâèëñÿ.")
         wait(1500)
         sampSendChat("/todo Ïîëó÷èëîñü.*ãîâîðÿ ïî ðàöèè ñ äèñïåò÷åðîì")
         wait(1500)
         sampSendChat("/do [Äèñïåò÷åð]: - Âàøà ìèññèÿ çàâåðøåíà, âåçèòå áîìáó â Îôèñ, êîíåö ñâÿçè.")
      end)
   end


function cmd_probiv()
lua_thread.create(function()
         sampSendChat("/do Íà ïîÿñå âèñèò ëè÷íûé ÊÏÊ ñîòðóäíèêà.")
         wait(1500)
         sampSendChat("/me ñíÿë ñ ïîÿñà ÊÏÊ , íà÷àë ïðîáèâàòü ÷åëîâåêà...")
         wait(1500)
         sampSendChat("/me ... ïî åãî ëèöó, ID-êàðòå , áåéäæèêó è æåòîíó")
         wait(1500)
         sampSendChat("/do Íà ýêðàíå ÊÏÊ âûñâåòèëàñü âñÿ èíôîðìàöèÿ î ÷åëîâåêå.")
      end)
   end

function cmd_dismiss(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
   sampSendChat('/dismiss '..arg1..' '..arg2..'')
   wait(1500)
   sampSendChat("/do Â ïðàâîì êàðìàíå áðþê íàõîäèòñÿ ÊÏÊ.")
   wait (1500)
   sampSendChat("/me äîñòàë ÊÏÊ èç ïðàâîãî êàðìàíà, çàòåì íà÷àë ïðîáèâàòü ïî áàçå äàííûõ ñîòðóäíèêà ÷åðåç ëèöî, ID êàðòó è æåòîí")
   wait(1500)
   sampSendChat("/do Íà ýêðàíå ÊÏÊ ïîÿâèëàñü ïîëíàÿ èíôîðìàöèÿ î ñîòðóäíèêå.")
   wait(1500)
   sampSendChat("/me íàæàë íà êíîïêó Óâîëèòü èç Ãîñ. Îðãàíèçàöèè")
   wait(1500)
   sampSendChat ("/do Ñîòðóäíèê áûë óäàëåí èç ñïèñêà 'Ãîñ. Ñîòðóäíèêè'.")
   wait(1500)
   sampSendChat("/me óáðàë ÊÏÊ îáðàòíî â ïðàâûé êàðìàí")
    else
  sampAddChatMessage("Ââåäè àéäè èãðîêà:{FFFFFF} /dismiss [ID] [Ïðè÷èíà].",0x318CE7FF -1)
  end
 end)
end

function cmd_demoute(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
        sampSendChat('/demoute '..arg1..' '..arg2..'')
         wait(1500)
        sampSendChat("/do ÊÏÊ ëåæèò â íàãðóäíîì êàðìàíå.")
         wait(1500)
         sampSendChat("/me íûðíóë ðóêîé â ïðàâûé êàðìàí, ïîñëå ÷åãî äîñòàë ÊÏÊ")
         wait(1500)
         sampSendChat("/me îòêðûë â ÊÏÊ áàçó äàííûõ ñîòðóäíèêîâ Ãîññóäàðñòâåííûõ ñòðóêòóð, ïîñëå ÷åãî íàæàë íà êíîïêó Demoute")
         wait(1500)
         sampSendChat("/do Ñîòðóäíèê óñïåøíî óäàëåí èç áàçû äàííûõ ãîññóäàðñòâåííûõ ñòðóêòóð")
    else
  sampAddChatMessage("Ââåäè àéäè èãðîêà:{FFFFFF} /demoute [ID] [Ïðè÷èíà].",0x318CE7FF -1)
  end
 end)
end

function cmd_cure(id)
    if id == "" then
             sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/cure [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
             sampSendChat("/do Â ñïåöèàëüíîì ïîäñóìêå íà ôîðìå ëåæàò: ñòåðèëüíûå øïðèöû è àìïóëà ñ àäðåíàëèíîì.")
             wait(1200)
             sampSendChat("/me äîñòàë ñòåðèëüíûé øïðèö ñ àìïóëîé, àêêóðàòíî ïðèîòêðûë àìïóëó ñ àäðåíàëèíîì")
             wait(1200)
             sampSendChat("/me íàáðàë ñîäåðæèìîå àìïóëû â øïðèö")
             wait(1200)
             sampSendChat("/me çàêàòàë ðóêàâ ïîñòðàäàâøåãî, ïîñëå ÷åãî ââ¸ë àäðåíàëèí ÷åðåç øïðèö â âåíó, âäàâèâ ïîðøåíü")
             wait(1200)
             sampSendChat("/do Àäðåíàëèí ïðîíèê â îðãàíèçì ïîñòðàäàâøåãî.")
             wait(1200)
             sampSendChat("/me óáðàë èñïîëüçîâàííûé øïðèö â ñïåöèàëüíûé ïîäñóìîê")
             wait(1200)
             sampSendChat("/cure "..id.." ")
         end)
      end
   end


function cmd_find(id)
    if id == "" then
         sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/find [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/do ÊÏÊ â ëåâîì êàðìàíå.")
         wait(1500)
         sampSendChat("/me äîñòàë ëåâîé ðóêîé ÊÏÊ èç êàðìàíà")
         wait(1500)
         sampSendChat("/do ÊÏÊ â ëåâîé ðóêå.")
         wait(1500)
         sampSendChat("/me âêëþ÷èë ÊÏÊ è çàøåë â áàçó äàííûõ Ïîëèöèè")
         wait(1500)
         sampSendChat("/me îòêðûë äåëî ñ äàííûìè ïðåñòóïíèêà")
         wait(1500)
         sampSendChat("/do Äàííûå ïðåñòóïíèêà ïîëó÷åíû.")
         wait(1500)
         sampSendChat("/me ïîäêëþ÷èëñÿ ê êàìåðàì ñëåæåíèÿ øòàòà")
         wait(1500)
         sampSendChat ("/do Íà íàâèãàòîðå ïîÿâèëñÿ ìàðøðóò.")
         wait(1500)
         sampSendChat("/find "..id.." ")
      end)
   end
end

function cmd_zsu(arg)
lua_thread.create(function()
    local arg1, arg2, arg3 = arg:match('(.+) (.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
        sampSendChat('/r Çàïðàøèâàþ îáüÿâëåíèå â ðîçûñê äåëî N-'..arg1..'.')
		wait(2500)
		sampSendChat('/r Ïî ïðè÷èíå - ' ..arg3..'. '..arg2..' Ñòåïåíü.')
    else
		sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/zsu [ID] [Êîë-âî ðîçûñêà] [Ïðè÷èíà].",0x318CE7FF -1)
		end
	end)
end

function cmd_incar(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
        sampSendChat('/incar '..arg1..' '..arg2..'')
        wait(1500)
        sampSendChat('/do Äâåðè â ìàøèíå çàêðûòû.')
        wait(1500)
  sampSendChat('/me îòêðûë çàäíþþ äâåðü â ìàøèíå')
  wait(1500)
  sampSendChat('/me ïîñàäèë ïðåñòóïíèêà â ìàøèíó')
  wait(1500)
  sampSendChat('/me çàáëîêèðîâàë äâåðè')
  wait(1500)
  sampSendChat('/do Äâåðè çàáëîêèðîâàíû.')
   else
  sampAddChatMessage("Ââåäè àéäè èãðîêà:{FFFFFF}/incar [ID] [Ìåñòî 1-4].",0x318CE7FF -1)
  end
 end)
end

function cmd_stop(id)
    lua_thread.create(function()
        sampSendChat("/do Ìåãàôîí â áàðäà÷êå.")
        wait(1500)
        sampSendChat("/me äîñòàë ìåãàôîí ñ áàðäà÷êà ïîñëå ÷åãî âêëþ÷èë åãî")
        wait(1500)
        sampSendChat("/m Ãðàæäàíèí ïðèæìèòåñü ê îáî÷èíå!")
    end)
end

function cmd_eject(id)
    if id == "" then
        sampAddChatMessage("Ââåäè àéäè èãðîêà:: {FFFFFF}/eject [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me îòêðûë äâåðü àâòî, ïîñëå âûáðîñèë ÷åëîâåêà èç àâòî")
            wait(1500)
            sampSendChat("/eject "..id.." ")
            wait(1500)
            sampSendChat("/me çàêðûë äâåðü àâòî")
      end)
   end
end

function cmd_pog(id)
    if id == "" then
         sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/pog [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/m Âîäèòåëü, îñòàíîâèòå òðàíñïîðòíîå ñðåäñòâî, çàãëóøèòå äâèãàòåëü...")
         wait(1500)
         sampSendChat("/m Èíà÷å ÿ îòêðîþ îãîíü ïî âàøåìó òðàíñïîðòó!")
      end)
   end
end

function cmd_tencodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ñïèñîê àêòèâíûõ òåí-êîäîâ MVD HELPER 4.7", "10-1 - Âñòðå÷à âñåõ îôèöåðîâ íà äåæóðñòâå (âêëþ÷àÿ ëîêàöèþ è êîä).\n10-3 - Ðàäèîìîë÷àíèå (äëÿ ñðî÷íûõ ñîîáùåíèé).\n10-4 - Ïðèíÿòî.\n10-5 - Ïîâòîðèòå ïîñëåäíåå ñîîáùåíèå.\n10-6 - Íå ïðèíÿòî/íåâåðíî/íåò.\n10-7 - Îæèäàéòå.\n10-8 - Â íàñòîÿùåå âðåìÿ çàíÿò/íå äîñòóïåí.\n10-14 - Çàïðîñ òðàíñïîðòèðîâêè (âêëþ÷àÿ ëîêàöèþ è öåëü òðàíñïîðòèðîâêè).\n10-15 - Ïîäîçðåâàåìûå àðåñòîâàíû (âêëþ÷àÿ êîë-âî ïîäîçðåâàåìûõ, ëîêàöèþ).\n10-18 - Òðåáóåòñÿ ïîääåðæêà äîïîëíèòåëüíûõ þíèòîâ.\n10-20 - Ëîêàöèÿ.\n10-21 - Ñîîáùåíèå î ñòàòóñå è ìåñòîíàõîæäåíèè, îïèñàíèå ñèòóàöèè.\n10-22 - Íàïðàâëÿéòåñü â 'ëîêàöèÿ' (îáðàùåíèå ê êîíêðåòíîìó îôèöåðó).\n10-27 - Ìåíÿþ ìàðêèðîâêó ïàòðóëÿ (âêëþ÷àÿ ñòàðóþ è íîâóþ ìàðêèðîâêó).\n10-46 - Ïðîâîæó îáûñê.\n10-55 - Òðàôôèê ñòîï.\n10-66 - Îñòàíîâêà ïîâûøåííîãî ðèñêà (åñëè èçâåñòíî, ÷òî ïîäîçðåâàåìûé â àâòî âîîðóæåí/ñîâåðøèë ïðåñòóïëåíèå. Åñëè îñòàíîâêà ïðîèçîøëà ïîñëå ïîãîíè).\n10-88 - Òåðàêò/×Ñ.\n10-99 - Ñèòóàöèÿ óðåãóëèðîâàíà\n10-100 Âðåìåííî íåäîñòóïåí äëÿ âûçîâîâ\nÀâòîð:t.me/Sashe4ka_ReZoN and t.me/daniel29032012", "Çàêðûòü", "Exit", 0)
        end)
        end

function cmd_marks(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ìàðêèðîâêè íà àâòî MVD HELPER 4.7", "ADAM [A] Ìàðêèðîâêà þíèòà, ñîñòîÿùåãî èç äâóõ îôèöåðîâ.\nLINCOLN [L] Ìàðêèðîâêà þíèòà, ñîñòîÿùåãî èç îäíîãî îôèöåðà.\nAIR [AIR] Ìàðêèðîâêà âîçäóøíîãî þíèòà, â ñîñòàâå äâóõ îôèöåðîâ\nAir Support Division [ASD] Ìàðêèðîâêà þíèòà âîçäóøíîé ïîääåðæêè.\nMARY [M] Ìàðêèðîâêà ìîòî-ïàòðóëÿ.\nHENRY [H] Ìàðêèðîâêà âûñîêî - ñêîðîñòíîãî þíèòà, ñîñòîÿùåãî èç îäíîãî èëè äâóõ îôèöåð.\nCHARLIE [C] Ìàðêèðîâêà ãðóïïû çàõâàòà.\nROBERT [R] Ìàðêèðîâêà îòäåëà äåòåêòèâîâ.\nSUPERVISOR [SV] Ìàðêèðîâêà ðóêîâîäÿùåãî ñîñòàâà (STAFF).\nDavid [D] Ìàðêèðîâêà ñïåö.îòäåëà\nÊàæäûé îôèöåð ïðè âûõîäå â ïàòðóëü, îáÿçàí ïîñòàâèòü ìàðêèðîâêó íà ñâîé êðóçåð (/vdesc)\nÀâòîð:t.me/Sashe4ka_ReZoN and t.me/daniel29032012", "Çàêðûòü", "Exit", 0)
         end)
         end

function cmd_sitcodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ñèòóàöèîííûå êîäû MVD HELPER 4.7", "CODE 0 - Îôèöåð ðàíåí.\nCODE 1 - Îôèöåð â áåäñòâåííîì ïîëîæåíèè.\nCODE 2 - Îáû÷íûé âûçîâ ñ íèçêèì ïðèîðèòåòîì. Áåç âêëþ÷åíèÿ ñèðåí è ñïåö.ñèãíàëîâ, ñîáëþäàÿ ÏÄÄ.\nCODE 2 HIGH - Ïðèîðèòåòíûé âûçîâ. Âñ¸ òàê æå áåç âêëþ÷åíèÿ ñèðåí è ñïåö.ñèãíàëîâ, ñîáëþäàÿ ÏÄÄ.\nCODE 3 - Ñðî÷íûé âûçîâ. Èñïîëüçîâàíèå ñèðåí è ñïåö.ñèãíàëîâ, èãíîðèðîâàíèå íåêîòîðûõ ïóíêòîâ ÏÄÄ.\nCODE 4 - Ïîìîùü íå òðåáóåòñÿ.\nCODE 4 ADAM - Ïîìîùü íå òðåáóåòñÿ â äàííûé ìîìåíò âðåìåíè. Îôèöåðû íàõîäÿùèåñÿ ïî áëèçîñòè äîëæíû áûòü ãîòîâû îêàçàòü ïîìîùü.\nCODE 7 - Ïåðåðûâ íà îáåä.\nCODE 30 - Ñðàáàòûâàíèå 'òèõîé' ñèãíàëèçàöèè íà ìåñòå ïðîèñøåñòâèÿ.\nCODE 30 RINGER - Ñðàáàòûâàíèå 'ãðîìêîé' ñèãíàëèçàöèè íà ìåñòå ïðîèñøåñòâèÿ.\nCODE 37 - Îáíàðóæåíèå óãíàííîãî òðàíñïîðòíîãî ñðåäñòâà. Íåîáõîäèìî óêàçàòü íîìåð, îïèñàíèå àâòîìîáèëÿ, íàïðàâëåíèå äâèæåíèÿ.\nÀâòîð:t.me/Sashe4ka_ReZoN and t.me/daniel29032012", "Çàêðûòü", "Exit", 0)
         end)
         end

function cmd_pas(arg)
 lua_thread.create(function()
  if tonumber(arg) == nil then
  sampAddChatMessage("Ââåäè àéäè èãðîêà : {FFFFFF}/pas [ID].", 0x318CE7FF -1)
  else
  id = arg
  sampSendChat('Çäðàâñòâóéòå, íàäåþñü âàñ íå áåñïîêîþ.')
  wait(1500)
  sampSendChat('/do Ñëåâà íà ãðóäè æåòîí ïîëèöåéñêîãî, ñïðàâà - èìåííàÿ íàøèâêà ñ ôàìèëèåé.')
  wait(1500)
  sampSendChat('/showbadge '..id)
  wait(1500)
  sampSendChat('Ïðîøó ïðåäüÿâèòü äîêóìåíò óäîñòîâåðÿþùèé âàøó ëè÷íîñòü.')
  end
 end)
end

function cmd_clear(arg)
  if tonumber(arg) == nil then
   sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF} /clear [ID].", 0x318CE7FF -1)
  else
  lua_thread.create(function()
  id = arg
  sampSendChat("/me íàæàâ íà òàíãåíòó, ñîîáùèë äèñïåò÷åðó èìÿ ÷åëîâåêà, êîòîðûé áîëåå íå ÷èñëèëñÿ â ðîçûñêå")
  wait(1500)
  sampSendChat('/clear '..id)
  end)
 end
end

function cmd_take(id)
    if id == "" then
             sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/take [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
             sampSendChat("/do Íà ðóêàõ îïåðàòèâíèêà íàäåòû ðåçèíîâûå ïåð÷àòêè.")
             wait(1500)
             sampSendChat("/me ïîñëå îáûñêà èçúÿë çàïðåù¸ííûå âåùè")
             wait(1500)
             sampSendChat("/do Ïàêåòèê äëÿ óëèê â êàðìàíå.")
             wait(1500)
             sampSendChat("/me äîñòàë ïàêåòèê äëÿ óëèê, ïîñëå ÷åãî ïîëîæèë òóäà çàïðåù¸ííûå âåùè")
             wait(1500)
             sampSendChat("/me ïîëîæèë ïàêåò ñ óëèêàìè â êàðìàøåê")
             wait(1500)
             sampSendChat("/do Ïàêåò ñ óëèêàìè â êàðìàíå.")
             wait(1500)
             sampSendChat("/take "..id.." ")
         end)
      end
   end

function cmd_pravda_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do Â äîïðîñíîé ñòîÿë øêàô÷èê, îí áûë çàêðûò íà ýëåêòðîííûé çàìîê.")
		wait(1500)
		sampSendChat("/me ïîäîøåë ê øêàô÷èêó, íàáðàë êîä, îòêðûâ øêàô÷èê âçÿë îò òóäà íå ïðîçðà÷íóþ ÷åðíóþ ïàïêó.")
		wait(1500)
		sampSendChat("/me ïîäîøåë ê ñòîëó, ïîëîæèë ïàïêó íà íåãî, îòêðûâ åå âçÿë ãîòîâûé ëèñò ôîðìàòà A4 ñî øòàìïàìè.")
		wait(1500)
		sampSendChat("/me ïîëîæèë ïåðåä çàäåðæàííûì, ïîëîæèë ðÿäîì ðó÷êó.")
		wait(1500)
		sampSendChat("/do Ðÿäîì ëåæàë îáðàçåö.")
		wait(1500)
		sampSendChat("/do Â îáðàçöå íàïèñàíî: 'ß Èìÿ/Ôàìèëèÿ/Äàòà ðîæäåíèÿ' ")
		wait(1500)
		sampSendChat("/do 'ß íåñó ïîëíóþ îòâåòñòâåííîñòü çà èíôîðìàöèþ êîòîðóþ ÿ ïðîèçíåñ ïðè äîïðîñå")
		wait(1500)
		sampSendChat("/do â ñëó÷àå íåïîäòâåðæäåíèÿ ìîèõ ñëîâ ÿ ãîòîâ íåñòè óãîëîâíóþ îòâåòñòâåííîñòü.' ")
		wait(1500)
		sampSendChat("Çàïîëíÿåøü íà ÷èñòîì êàê ïî îáðàçöó, íèæå ñòàâèøü ïîäïèñü è äàòó.")
	end)
end

function cmd_secret_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do Íà ñòîëå ëåæèò äîêóìåíò: \"Äîêóìåíò î íåðàçãëàøåíèè äåÿòåëüíîñòè ÔÁÐ\"")
		wait(1500)
		sampSendChat("/do Ðÿäîì ñ äîêóìåíòîì àêêóðàòíî ðàñïîëîæåíà ðó÷êà ñ çîëîòîé ãðàâèðîâêîé \"ÔÁÐ\"")
		wait(1500)
		sampSendChat("/do Â äîêóìåíòå íàïèñàíî: \"ß, (Èìÿ / Ôàìèëèÿ), êëÿíóñü äåðæàòü âòàéíå òî, ...")
		wait(1500)
		sampSendChat("/do ... ÷òî âèäåë, âèæó, è áóäó âèäåòü\"")
		wait(1500)
		sampSendChat("/do Íèæå íàïèñàíî: \"Ãîòîâ íåñòè ïîëíóþ îòâåòñòâåííîñòü, è â ñëó÷àå ñâîåãî íåïîâèíîâåíèÿ, ...")
		wait(1500)
		sampSendChat("/do ... ãîòîâ áûòü àðåñòîâàííûì è îòñòðàíåííûì îò äîëæíîñòè, ïðè íàëè÷èè òàêîâîé\"")
		wait(1500)
		sampSendChat("/do Åùå íèæå íàïèñàíî: \"Äàòà: ; Ïîäïèñü: \"")
	end)
end

function cmd_traf(id)
    if id == "" then
             sampAddChatMessage("Ââåäè àéäè èãðîêà: {FFFFFF}/traf [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
            sampSendChat("/do Ìåãàôîí â áàðäà÷êå.")
            wait(1200)
            sampSendChat("/me äîñòà¸ò ìåãàôîí ñ áàðäà÷êà ïîñëå ÷åãî âêëþ÷àåò åãî")
            wait(1200)
            sampSendChat("/m Âîäèòåëü àâòî îñòàíîâèòåñü íà îáî÷èíå è çàãëóøèòå äâèãàòåëü, äåðæèòå ðóêè íà ðóëå.")
            wait(1200)
            sampSendChat("/me óáèðàåò ìåãàôîí â áàðäà÷îê")
        end)
    end
end

function cmd_time()
    lua_thread.create(function()
    sampSendChat("/me ïîäíÿë ðóêó è ïîñìîòðåë íà ÷àñû áðåíäà  Rolex")
    wait(1500)
    sampSendChat("/time")
    sampSendChat('/do Íà ÷àñàõ '..os.date('%H:%M:%S'))
    end)
end

function cmd_finger_person(id)
	lua_thread.create(function ()
		sampSendChat("/do Çà ñïèíîé àãåíòà íàõîäèòñÿ íåáîëüøàÿ ñïåö. ñóìêà.")
		wait(1500)
		sampSendChat("/me ñíÿë ñïåö. ñóìêó ñî ñïèíû, ïîñëå ïîëîæèë å¸ íà ðîâíóþ ïîâåðõíîñòü")
		wait(1500)
		sampSendChat("/do Â ñïåö. ñóìêå èìååòñÿ: ïóäðà è êèñòî÷êà äëÿ å¸ íàíåñåíèÿ, ñïåö. ïë¸íêà.")
		wait(1500)
		sampSendChat("/me âçÿë áàíî÷êó ñ ïóäðîé, îòêðûâ å¸ àêêóðàòíî íàíîñèò ïóäðó íà ïàëüöû ÷åëîâåêà íàïðîòèâ")
		wait(1500)
		sampSendChat("/do Ïàëüöû ÷åëîâåêà íàïðîòèâ ïîêðûòû ïóäðîé.")
		wait(1500)
		sampSendChat("/me äîñòàë èç ñïåö. ñóìêè ñïåöèàëüíóþ ïë¸íêó, çàòåì ïðèêëåèâàåò å¸ íà ïàëüöû ÷åëîâåêó")
		wait(1500)
		sampSendChat("/do Îòïå÷àòîê ôèêñèðóåòñÿ íà ïë¸íêå.")
		wait(1500)
		sampSendChat("/me àêêóðàòíî ñíÿâ ïë¸íêó ñ ïàëüöåâ ÷åëîâåêà, ïîìåùàåò åå â ñïåö. ïàêåòèê")
		wait(1500)
		sampSendChat("/do Â ñïåö. ïàêåòèêå íàõîäèòñÿ ïë¸íêà ñ ïàëüöåâ ÷åëîâåêà.")
		wait(1500)
		sampSendChat("/me ïîëîæèë ñïåö. ïàêåòèê â çàäíèé êàðìàí áðþê, áåð¸ò â ðóêè áàíî÷êó ñ ïóäðîé ...")
		wait(1500)
		sampSendChat("/me ... è êèñòî÷êó, óáèðàåò èõ â ñïåö. ñóìêó, ïîñëå çàêðûâàåò å¸")
		wait(1500)
		sampSendChat("/do Ñïåö. ïàêåòèê ëåæèò â çàäíåì êàðìàíå áðþê, ñïåö. ñóìêà çàêðûòà.")
	end)
end

function cmd_warn()
	lua_thread.create(function ()
		sampSendChat("/r  Ìíå òðåáóåòñÿ ïîäìîãà. Íàéäèòå ìåíÿ ïî æó÷êó  ")
	end)
end

function cmd_grim()
    lua_thread.create(function ()
    sampSendChat("/do Â øêàô÷èêå ñòîèò íàáîð äëÿ ïðîôåññèîíàëüíîãî ãðèìà.")
    wait(1500)
    sampSendChat("/me îòêðûë øêàô÷èê è äîñòàâ èç íåãî íàáîð äëÿ ãðèìà, ïîñòàâèë åãî íà øêàô÷èê è îòêðûë")
    wait(1500)
    sampSendChat("/do Íàáîð äëÿ ãðèìà îòêðûò.")
    wait(1500)
    sampSendChat("/do Íàä øêàô÷èêîì âåñèò çåðêàëî.")
    wait(1500)
    sampSendChat("/me ðàññìàòðèâàÿ íàáîð, âçÿë áîëüøóþ êèñòü è îêóíóâ å¸ â ò¸ìíûé öâåò, íà÷àë íàíîñèòü åãî íà ëèöî, ñìîòðÿ â çåðêàëî")
    wait(1500)
    sampSendChat("/me âçÿâ òîíêóþ êèñòî÷êó, îêóíóë å¸ â ðóìÿí è íà÷àë íàíîñèòü íà ëèöî")
   wait(1500)
   sampSendChat("/me íàðèñîâàâ íà ëèöå ñêóëû, îêóíóë êèñòî÷êó â ò¸ìíóþ òåíü è íàí¸ñ èõ íà ëèöî")
   wait(1500)
   sampSendChat("/me âçÿë êèñòü è îêóíóâ å¸ â ò¸ìíóþ ïóäðó è íàí¸ñ å¸ íà ëèöî")
   wait(1500)
   sampSendChat("/me ïîëîæèë êèñòè â îòñåê äëÿ èíñòðóìåíòîâ è çàêðûë íàáîð")
   wait(1500)
   sampSendChat("/me óáðàë íàáîð â øêàô÷èê è çàêðûë åãî")
   wait(1500)
   sampSendChat("/do Íà ëèöå íàíåñ¸í ãðèì.")
       end)
end

function cmd_eks()
    lua_thread.create(function ()
    sampSendChat ("/do Â êàðìàíå ïèäæàêà ëåæàò ðåçèíîâûå ïåð÷àòêè.")
wait(1500)
sampSendChat ("/me ïðàâîé ðóêîé äîñòàë èç êàðìàíà ïåð÷àòêè è íàäåë èõ íà êèñòè ðóê")
wait(1500)
sampSendChat("/do Íà ñòîëå ëåæèò îðóæèå, ïîëîñêà è ëèñò áåëîé áóìàãè, äâå ñòîéêè ñ ïðîáèðêàìè.")
wait(1500)
sampSendChat("/me îñìîòðåë îðóæèå è àêêóðàòíî ðàçîáðàë åãî íà îòäåëüíûå ÷àñòè")
wait(1500)
sampSendChat("/me âçÿë â ðóêè çàòâîð è ïîëîñêó áóìàãè, ïîìåñòèë ïîëîñêó â çàäíèé ñðåç ïàòðîííèêà")
wait(1500)
sampSendChat("/me óáðàë ïîëîñêó áóìàãè èç çàòâîðà")
wait(1500)
sampSendChat("/do Íà ïîëîñêå áóìàãè îñòàëèñü ñëåäû íàãàðà îò íå ñãîðåâøåãî ïîðîõà.")
wait(1500)
sampSendChat("/me âûòðÿõíóë ÷àñòèöû ñ ïîëîñêè íà ëèñò áóìàãè")
wait(1500)
sampSendChat("/me âçÿë ïðîáèðêó ñî ñòîéêè è ïåðåñûïàë ñîäåðæèìîå ñ ëèñòà â ïðîáèðêó")
wait(1500)
sampSendChat("/me çàêðûë ïðîáèðêó è ïîñòàâèë íà äðóãóþ ñòîéêó")
wait(1500)
sampSendChat("/me âçÿë â ðóêè êðûøêó ñòâîëüíîé êîðîáêè è ïðîñìîòðåë ñåðèéíûé íîìåð îðóæèÿ")
wait(1500)
sampSendChat("/me âêëþ÷èë êîìïüþòåð è îòêðûë áàçó äàííûõ, â ïîèñêîâóþ ñòðîêó ââ¸ë íîìåð îðóæèÿ")
wait(1500)
sampSendChat("/do Íà ýêðàíå âûñâåòèëàñü èíôîðìàöèÿ îá îðóæèè è âëàäåëüöå.")
wait(1500)
sampSendChat("/me ïîëîæèë êðûøêó ñòâîëüíîé êîðîáêè îáðàòíî íà ñòîë")
wait(1500)
sampSendChat("/me ñîáðàë îðóæèå â öåëîå, äîñòàë èç ÿùèêà ïðîçðà÷íûé ñïåö.ïàêåò è ïîìåñòèë â íåãî îðóæèå")
wait(1500)
sampSendChat("/me âçÿë ñî ñòîëà ôëîìàñòåð è ïîìåòèë èì ñïåö.ïàêåò, óáðàë ôëîìàñòåð â ÿùèê è çàêðûë åãî")
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
        imgui.Begin(u8"Âûäà÷à ðîçûñêà", windowTwo)
        imgui.InputInt(u8 'ID èãðîêà ñ êîòîðûì áóäåòå âçàèìîäåéñòâîâàòü', id,10)
        for i = 1, #tableUk["Text"] do
            if imgui.Button(u8(tableUk["Text"][i] .. ' Óðîâåíü ðîçûñêà: ' .. tableUk["Ur"][i])) then
                lua_thread.create(function()
                    sampSendChat("/do Ðàöèÿ âèñèò íà áðîíåæåëåòå.")
                    wait(1500)
                    sampSendChat("/me ñîðâàâ ñ ãðóäíîãî äåðæàòåëÿ ðàöèþ, ñîîáùèë äàííûå î ñàïåêòå")
                    wait(1500)
                    sampSendChat("/su " .. id[0] .. " " .. tableUk["Ur"][i] .. " " .. tableUk["Text"][i])
                    wait(1500)
                    sampSendChat("/do Ñïóñòÿ âðåìÿ äèñïåò÷åð îáúÿâèë ñàïåêòà â ôåäåðàëüíûé ðîçûñê.")
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
        imgui.Begin(u8"Ïàíåëü ëèäåðà/çàìåñòèòåëÿ", leaderPanel)
        imgui.InputInt(u8'ID èãðîêà ñ êîòîðûì õîòèòå âçàèìîäåéñòâîâàòü', id, 10)
        if imgui.Button(u8'Óâîëèòü ñîòðóäíèêà') then
            lua_thread.create(function ()
                sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                wait(1500)
                sampSendChat("/me ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                wait(1500)
                sampSendChat("/me íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Óâîëèòü")
                wait(1500)
                sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü 'Ñîòðóäíèê óñïåøíî óâîëåí!'")
                wait(1500)
                sampSendChat("/me âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                wait(1500)
                sampSendChat("Íó ÷òî æ, âû óâîëåííû. Îñòàâüòå ïîãîíû â ìîåì êàáèíåòå.")
                wait(1500)
                sampSendChat("/uninvite".. id[0])
            end)
        end

        if imgui.Button(u8'Ïðèíÿòü ãðàæäàíèíà') then
            lua_thread.create(function ()
                sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                wait(1500)
                sampSendChat("/me ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                wait(1500)
                sampSendChat("/me çàøåë â òàáëèöó è ââåë äàííûå î íîâîì ñîòðóäíèêå")
                wait(1500)
                sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Ñîòðóäíèê óñïåøíî äîáàâëåí! Ïîæåëàéòå åìó õîðîøåé ñëóæáû :)'")
                wait(1500)
                sampSendChat("/me âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                wait(1500)
                sampSendChat("Ïîçäðîâëÿþ, âû ïðèíÿòû! Ôîðìó âîçüìåòå â ðàçäåâàëêå.")
                wait(1500)
                sampSendChat("/invite".. id[0])
            end)
        end

        if imgui.Button(u8'Âûäàòü âûãîâîð ñîòðóäíèêó') then
            lua_thread.create(function ()
                sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                wait(1500)
                sampSendChat("/me ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                wait(1500)
                sampSendChat("/me íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Âûäàòü âûãîâîð")
                wait(1500)
                sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Âûãîâîð âûäàí!'")
                wait(1500)
                sampSendChat("/me âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                wait(1500)
                sampSendChat("Íó ÷òî æ, âûãîâîð âûäàí. Îòðàáàòûâàéòå.")
                wait(1500)
                sampSendChat("/fwarn".. id[0])
            end)
        end

        if imgui.Button(u8'Ñíÿòü âûãîâîð ñîòðóäíèêó') then
            lua_thread.create(function ()
                sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                wait(1500)
                sampSendChat("/me ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                wait(1500)
                sampSendChat("/me íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Ñíÿòü âûãîâîð")
                wait(1500)
                sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Âûãîâîð ñíÿò!'")
                wait(1500)
                sampSendChat("/me âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                wait(1500)
                sampSendChat("Íó ÷òî æ, îòðàáîòàëè.")
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
        imgui.Begin(u8"Íàñòðîéêà óìíîãî ðîçûñêà", setUkWindow)
            if imgui.BeginChild('Name', imgui.ImVec2(700, 500), true) then
                for i = 1, #tableUk["Text"] do
                    imgui.Text(u8(tableUk["Text"][i] .. ' Óðîâåíü ðîçûñêà: ' .. tableUk["Ur"][i]))
                    Uk = #tableUk["Text"]
                end
                imgui.EndChild()
            end
            if imgui.Button(u8'Äîáàâèòü', imgui.ImVec2(500, 36)) then
                addUkWindow[0] = not addUkWindow[0]
            end
            if imgui.Button(u8'Óäàëèòü', imgui.ImVec2(500, 36)) then
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
        imgui.Begin(u8"Íàñòðîéêà óìíîãî ðîçûñêà", addUkWindow)
            imgui.InputText(u8'Òåêñò ñòàòüè(ñ íîìåðîì.)', newUkInput, 255)
            newUkName = u8:decode(ffi.string(newUkInput))
            imgui.InputInt(u8'Óðîâåíü ðîçûñêà(òîëüêî öèôðà)', newUkUr, 10)
            if imgui.Button(u8'Ñîõðàíèòü') then
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
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Ãàðñèÿ", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Øåéäè-Êýáèí", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Ïåðåñå÷åíèå Áëýêôèëä", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Òåìïë", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Ñòàíöèÿ «Þíèòè»", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Ëîñ-Ôëîðåñ", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Êàçèíî «Ìîðñêàÿ çâåçäà»", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Õèìçàâîä Èñòåð-Áýé", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Äåëîâîé ðàéîí", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Âîñòî÷íàÿ Ýñïàëàíäà", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Ñòàíöèÿ «Ìàðêåò»", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Ñòàíöèÿ «Ëèíäåí»", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Ïåðåñå÷åíèå Ìîíòãîìåðè", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Ìîñò «Ôðåäåðèê»", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Ñòàíöèÿ «Éåëëîó-Áåëë»", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Äåëîâîé ðàéîí", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Äæåôôåðñîí", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Ìàëõîëëàíä", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Äæåôôåðñîí", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Çàïàäàíàÿ àâòîñòðàäà Äæóëèóñ", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Äæåôôåðñîí", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Ðîäåî", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Ñòàíöèÿ «Êðýíáåððè»", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Äåëîâîé ðàéîí", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Çàïàäíûé Ðýäñýíäñ", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Ìàëåíüêàÿ Ìåêñèêà", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Ïåðåñå÷åíèå Áëýêôèëä", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Áåêîí-Õèëë", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Ðîäåî", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Ðè÷ìàí", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Äåëîâîé ðàéîí", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"Ñòðèï", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Äåëîâîé ðàéîí", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Ïåðåñå÷åíèå Áëýêôèëä", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Êîíôåðåíö Öåíòð", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Ìîíòãîìåðè", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Äîëèíà Ôîñòåð", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"×àñîâíÿ Áëýêôèëä", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Ìàëõîëëàíä", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Ïîëå äëÿ ãîëüôà «Éåëëîó-Áåëë»", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"Ñòðèï", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Äæåôôåðñîí", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Ìàëõîëëàíä", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Àëüäåà-Ìàëüâàäà", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Ëàñ-Êîëèíàñ", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Ëàñ-Êîëèíàñ", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Ðè÷ìàí", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Óèëëîóôèëä", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Òåìïë", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Ìàëåíüêàÿ Ìåêñèêà", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Êâèíñ", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Àýðîïîðò Ëàñ-Âåíòóðàñ", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Ðè÷ìàí", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Òåìïë", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Óèëëîóôèëä", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Ëàñ-Êîëèíàñ", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Ðîäåî", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Ëàñ-Áðóõàñ", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Ðîäåî", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Âàéíâóä", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Ðîäåî", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Äåëîâîé ðàéîí", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Ðîäåî", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Äæåôôåðñîí", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Õýìïòîí-Áàðíñ", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Òåìïë", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Ìîñò «Êèíêåéä»", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Ïëÿæ «Âåðîíà»", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Êîììåð÷åñêèé ðàéîí", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Ìàëõîëëàíä", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Ðîäåî", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Ìàëõîëëàíä", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Ìàëõîëëàíä", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Þæíàÿ àâòîñòðàäà Äæóëèóñ", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Àéäëâóä", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Îêåàíñêèå äîêè", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Êîììåð÷åñêèé ðàéîí", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Òåìïë", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Ãëåí Ïàðê", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Ìîñò «Ìàðòèí»", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"Ñòðèï", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Óèëëîóôèëä", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Ìàðèíà", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Àýðîïîðò Ëàñ-Âåíòóðàñ", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Àéäëâóä", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Âîñòî÷íàÿ Ýñïàëàíäà", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Äåëîâîé ðàéîí", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"Ìîñò «Ìàêî»", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Ðîäåî", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Ïëîùàäü «Ïåðøèíã»", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Ìàëõîëëàíä", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Ìîñò «Ãàíò»", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Ëàñ-Êîëèíàñ", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Ìàëõîëëàíä", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Êîììåð÷åñêèé ðàéîí", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Ðîäåî", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Ðîêà-Ýñêàëàíòå", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Ðîäåî", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Ìàðêåò", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Ëàñ-Êîëèíàñ", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Ìàëõîëëàíä", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"Êèíãñ", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Âîñòî÷íûé Ðýäñýíäñ", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Äåëîâîé ðàéîí", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Êîíôåðåíö Öåíòð", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Ðè÷ìàí", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Îóøåí-Ôëýòñ", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Êîëëåäæ Ãðèíãëàññ", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Ãëåí Ïàðê", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Ðåãüþëàð-Òîì", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Ïëÿæ «Âåðîíà»", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Äâîðåö Êàëèãóëû", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Àéäëâóä", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Ïèëèãðèì", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Àéäëâóä", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Êâèíñ", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Äåëîâîé ðàéîí", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Êîììåð÷åñêèé ðàéîí", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Ìàðèíà", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Ðè÷ìàí", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Âàéíâóä", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Ðîäåî", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Èñòåðñêèé Òîííåëü", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Ðîäåî", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"Êàçèíî «Êàðìàí êëîóíà»", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Àéäëâóä", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Ïåðåñå÷åíèå Ìîíòãîìåðè", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Óèëëîóôèëä", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Òåìïë", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Ïðèêë-Ïàéí", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Ìîñò «Ãàðâåð»", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Ìîñò «Ãàðâåð»", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Ìîñò «Êèíêåéä»", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Ìîñò «Êèíêåéä»", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Ïëÿæ «Âåðîíà»", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ»", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Âàéíâóä", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Âàéíâóä", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Êîììåð÷åñêèé ðàéîí", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Ìàðêåò", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Çàïàäíûé Ðîêøîð", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"Âîñòî÷íûé ïëÿæ", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Ìîñò «Ôàëëîó»", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Óèëëîóôèëä", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"×àéíàòàóí", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Îêåàíñêèå äîêè", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Õèìçàâîä Èñòåð-Áýé", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"Êàçèíî «Âèçàæ»", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Îóøåí-Ôëýòñ", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Ðè÷ìàí", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Íåôòÿíîé êîìïëåêñ «Çåëåíûé îàçèñ»", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Ðè÷ìàí", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Êàçèíî «Ìîðñêàÿ çâåçäà»", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"Âîñòî÷íûé ïëÿæ", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Äæåôôåðñîí", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Äåëîâîé ðàéîí", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Äåëîâîé ðàéîí", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Ìîñò «Ãàðâåð»", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Þæíàÿ àâòîñòðàäà Äæóëèóñ", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Êîëëåäæ «Ãðèíãëàññ»", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Ëàñ-Êîëèíàñ", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Ìàëõîëëàíä", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Îêåàíñêèå äîêè", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Ãàíòîí", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Óèëëîóôèëä", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Ñåâåðíàÿ Ýñïëàíàäà", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"Êàçèíî «Õàé-Ðîëëåð»", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Îêåàíñêèå äîêè", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Ìîòåëü «Ïîñëåäíèé öåíò»", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Áýéñàéíä-Ìàðèíà", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"Êèíãñ", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"Ýëü-Êîðîíà", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"×àñîâíÿ Áëýêôèëä", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"«Ðîçîâûé ëåáåäü»", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Çàïàäàíàÿ àâòîñòðàäà Äæóëèóñ", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Ëîñ-Ôëîðåñ", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"Êàçèíî «Âèçàæ»", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Ïðèêë-Ïàéí", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Ïëÿæ «Âåðîíà»", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Ïåðåñå÷åíèå Ðîáàäà", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Ëèíäåí-Ñàéä", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Îêåàíñêèå äîêè", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Óèëëîóôèëä", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"Êèíãñ", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Êîììåð÷åñêèé ðàéîí", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Ìàëõîëëàíä", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Ìàðèíà", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Áýòòåðè-Ïîéíò", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"Êàçèíî «4 Äðàêîíà»", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Áëýêôèëä", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Ïîëå äëÿ ãîëüôà «Éåëëîó-Áåëë»", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Àéäëâóä", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Çàïàäíûé Ðýäñýíäñ", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Äîýðòè", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Ôåðìà Õèëëòîï", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Ëàñ-Áàððàíêàñ", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Êàçèíî «Ïèðàòû â ìóæñêèõ øòàíàõ»", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"Ñèòè Õîëë", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Çàãîðîäíûé êëóá «Àâèñïà»", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"Ñòðèï", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Õàøáåðè", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Óàéòâóä-Èñòåéòñ", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Âîäîõðàíèëèùå Øåðìàíà", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"Ýëü-Êîðîíà", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Äåëîâîé ðàéîí", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Äîëèíà Ôîñòåð", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Ëàñ-Ïàÿñàäàñ", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Äîëèíà Îêóëüòàäî", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Ïåðåñå÷åíèå Áëýêôèëä", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Ãàíòîí", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Âîñòî÷íàÿ Ýñïàëàíäà", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Äâîðåö Êàëèãóëû", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Êàçèíî «Ðîÿëü»", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Ðè÷ìàí", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Êàçèíî «Ìîðñêàÿ çâåçäà»", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Ìàëõîëëàíä", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Äåëîâîé ðàéîí", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Õàíêè-Ïàíêè-Ïîéíò", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"Âîåííûé ñêëàä òîïëèâà Ê.À.Ñ.Ñ.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Àâòîñòðàäà «Ãàððè-Ãîëä»", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Òîííåëü Áýéñàéä", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Îêåàíñêèå äîêè", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Ðè÷ìàí", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Ïðîìñêëàä èìåíè Ðýíäîëüôà", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"Âîñòî÷íûé ïëÿæ", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Ôëèíò-Óîòåð", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Áëóáåððè", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Ñòàíöèÿ «Ëèíäåí»", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Ãëåí Ïàðê", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Äåëîâîé ðàéîí", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Çàïàäíûé Ðýäñýíäñ", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Ðè÷ìàí", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Ìîñò «Ãàíò»", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Áàð «Probe Inn»", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Ïåðåñå÷åíèå Ôëèíò", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Ëàñ-Êîëèíàñ", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Ñîáåëë-Ðåéë-ßðäñ", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"Èçóìðóäíûé îñòðîâ", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Ñàíòà-Ôëîðà", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Ïëàéÿ-äåëü-Ñåâèëü", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Ìàðêåò", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Êâèíñ", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Ïåðåñå÷åíèå Ïèëñîí", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Ñïèíèáåä", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Ïèëèãðèì", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Áëýêôèëä", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"«Áîëüøîå óõî»", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Äèëëèìîð", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"Ýëü-Êåáðàäîñ", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Ñåâåðíàÿ Ýñïëàíàäà", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Ðûáàöêàÿ ëàãóíà", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Ìàëõîëëàíä", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"Âîñòî÷íûé ïëÿæ", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"Ñàí-Àíäðåàñ Ñàóíä", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Òåíèñòûå ðó÷üè", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Ìàðêåò", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Çàïàäíûé Ðîêøîð", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Ïðèêë-Ïàéí", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"«Áóõòà Ïàñõè»", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Ëèôè-Õîëëîó", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Ïðèêë-Ïàéí", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Áëóáåððè", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Äåëîâîé ðàéîí", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Âîñòî÷íûé Ðîêøîð", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"Çàëèâ Ñàí-Ôèåððî", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Ïàðàäèçî", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"Êàçèíî «Íîñîê âåðáëþäà»", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Îëä-Âåíòóðàñ-Ñòðèï", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Äæàíèïåð-Õèëë", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Äæàíèïåð-Õîëëîó", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Ðîêà-Ýñêàëàíòå", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Ïëÿæ «Âåðîíà»", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Äîëèíà Ôîñòåð", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Àðêî-äåëü-Îýñòå", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"«Óïàâøåå äåðåâî»", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"Ôåðìà", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"Äàìáà Øåðìàíà", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Ñåâåðíàÿ Ýñïëàíàäà", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Ôèíàíñîâûé ðàéîí", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Ãàðñèÿ", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Ìîíòãîìåðè", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Êðèê", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Ïëÿæ «Ñàíòà-Ìàðèÿ»", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Ïåðåñå÷åíèå Ìàëõîëëàíä", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Ýéíäæåë-Ïàéí", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Â¸ðäàíò-Ìåäîóñ", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Îêòàí-Ñïðèíãñ", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Êàçèíî Êàì-ý-Ëîò", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Çàïàäíûé Ðýäñýíäñ", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Ïëÿæ «Ñàíòà-Ìàðèÿ»", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Àýðîïîðò Ëàñ-Âåíòóðàñ", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Îêðóã Ôëèíò", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Ïàëîìèíî Êðèê", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Îêåàíñêèå äîêè", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Óàéòâóä-Èñòåéòñ", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Êàëòîí-Õàéòñ", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"«Áóõòà Ïàñõè»", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Çàëèâ Ëîñ-Ñàíòîñ", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Äîýðòè", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Ãîðà ×èëèàä", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Ôîðò-Êàðñîí", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Äîëèíà Ôîñòåð", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Îóøåí-Ôëýòñ", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Ôåðí-Ðèäæ", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Áýéñàéä", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Àýðîïîðò Ëàñ-Âåíòóðàñ", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Ïîìåñòüå Áëóáåððè", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Ïýëèñåéäñ", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"Íîðò-Ðîê", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Êàðüåð «Õàíòåð»", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Ìèññèîíåð-Õèëë", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"Çàëèâ Ñàí-Ôèåððî", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Çàïðåòíàÿ Çîíà", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Ãîðà «×èëèàä»", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Ãîðà «×èëèàä»", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"Ïàíîïòèêóì", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Òåíèñòûå ðó÷üè", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Áýê-î-Áåéîíä", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Ãîðà «×èëèàä»", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Òüåððà Ðîáàäà", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Îêðóã Ôëèíò", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Óýòñòîóí", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Ïóñòûííûé îêðóã", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Òüåððà Ðîáàäà", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"Ñàí Ôèåððî", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Ëàñ Âåíòóðàñ", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Òóìàííûé îêðóã", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Ëîñ Ñàíòîñ", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Ïðèãîðîä'
end

local suppWindowFrame = imgui.OnFrame(
    function() return suppWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Âñïîìîãàòåëüíîå îêîøêî", suppWindow, imgui.WindowFlags.NoTitleBar)

			imgui.Text(u8'Âðåìÿ: '..os.date('%H:%M:%S'))
            imgui.Text(u8'Ìåñÿö: '..os.date('%B'))
			imgui.Text(u8'Ïîëíàÿ äàòà: '..arr.day..'.'.. arr.month..'.'..arr.year)
        	local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
			imgui.Text(u8'Ðàéîí:' .. u8(calculateZone(positionX, positionY, positionZ)))
			local p_city = getCityPlayerIsIn(PLAYER_PED)
			if p_city == 1 then pCity = u8'Ëîñ - Ñàíòîñ' end
			if p_city == 2 then pCity = u8'Ñàí - Ôèåððî' end
			if p_city == 3 then pCity = u8'Ëàñ - Âåíòóðàñ' end
			if getActiveInterior() ~= 0 then pCity = u8'Âû íàõîäèòåñü â èíòåðüåðå!' end
			imgui.Text(u8'Ãîðîä: ' .. pCity)
		imgui.End()
    end
)

function sampev.onSendChat(cmd)
  if  mainIni.Accent.autoAccent then
    if cmd == ')' or cmd == '(' or cmd ==  '))' or cmd == '((' or cmd == 'xD' or cmd == ':D' or cmd == ':d' or cmd == 'XD' then
      return{cmd}
    end
    return{mainIni.Accent.accent .. ' ' .. cmd}
  end
end
