script_name("MVD Helper Mobile")
script_version("4.8")
script_author("@Sashe4ka_ReZoN")

local http = require("socket.http")
local ltn12 = require("ltn12")
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


sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Скрипт успешно загрузиаался", 0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Авторы:t.me/Sashe4ka_ReZoN",0x8B00FF)
sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Чтобы посмотреть комманды,введите /mvd and /mvds ",0x8B00FF)

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
  print("Проверка наличия обновлений...")
  local currentVersionFile = io.open(scriptPath, "r")
  local currentVersion = currentVersionFile:read("*a")
  currentVersionFile:close()

  local response = http.request(scriptUrl)
  if response and response ~= currentVersion then
    -- Обновляем скрипт
    sampAddChatMessage("Доступна новая версия скрипта! Обновление...", -1)
    local success = downloadFile(scriptUrl, scriptPath)
    if success then
      sampAddChatMessage("Скрипт успешно обновлен.", -1)
    else
      sampAddChatMessage("Не удалось обновить скрипт.", -1)
    end
  else
    sampAddChatMessage("Скрипт уже является последней версией.", -1)
  end
end
local scriptUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper4.8test.lua"
local scriptPath = "MVDHelper4.8test.lua"

local mainIni = inicfg.load({
    Accent = {
        accent = '[Молдавский акцент]: ',
        autoAccent = false
    },
    Info = {
        org = 'Вы не состоите в ПД',
        dl = 'Вы не состоите в ПД',
        rang_n = 0
    },
    theme = {
        themeta = 0
    }
}, "mvdhelper.ini")
local file = io.open("smartUk.json", "r") -- Открываем файл в режиме чтения
a = file:read("*a") -- Читаем файл, там у нас таблица
file:close() -- Закрываем
tableUk = decodeJson(a) -- Читаем нашу JSON-Таблицу

local statsCheck = false

local AutoAccentBool = new.bool(mainIni.Accent.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org = u8'Вы не состоите в ПД'
local org_g = u8'Вы не состоите в ПД'
local ccity = u8'Вы не состоите в ПД'
local org_tag = u8'Вы не состоите в ПД'
local dol = 'Вы не состоите в ПД'
local dl = u8'Вы не состоите в ПД'
local rang_n = 0
local colorList = {u8'Стандартная', u8'Красная', u8'Зелёная',u8'Синяя', u8'Фиолетовая'} -- создаём таблицу с названиями тем
local colorListNumber = new.int(mainIni.theme.themeta) -- создаём буфер где будет хранится номер выбранной темы
local colorListBuffer = new['const char*'][#colorList](colorList) -- создаём буфер для списка
local nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
local autoScrinArest = new.bool()

local sliderBuf = new.int() -- буфер для тестового слайдера
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
            imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)local search = imgui.new.char[256]() -- создаём буфер для поиска
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
        imgui.Text(u8'MVD Helper 4.8 \n для Arizona Mobile', imgui.SetCursorPosX(50))
        if imgui.Button(settings .. u8' Настройки', imgui.ImVec2(280, 50)) then
            tab = 1
        elseif imgui.Button(list .. u8' Основное', imgui.ImVec2(280, 50)) then
            tab = 2

        elseif imgui.Button(radio .. u8' Рация депортамента', imgui.ImVec2(280, 50)) then
            tab = 3

        elseif imgui.Button(userSecret .. u8' Для СС', imgui.ImVec2(280, 50)) then
            tab = 4

        elseif imgui.Button(pen .. u8' Шпаргалки', imgui.ImVec2(280, 50)) then
            tab = 5

        elseif imgui.Button(sliders .. u8' Дополнительно', imgui.ImVec2(280, 50)) then
            tab = 6

        elseif imgui.Button(info .. u8' Инфа', imgui.ImVec2(280, 50)) then
            tab = 7
        end
        imgui.SetCursorPos(imgui.ImVec2(300, 50))
        if imgui.BeginChild('Name##'..tab, imgui.ImVec2(), true) then -- [Для декора] Создаём чайлд в который поместим содержимое
            -- == [Основное] Содержимое вкладок == --
            if tab == 1 then -- если значение tab == 1
                imgui.Text(u8'Ваш ник: '.. nickname)
                imgui.Text(u8'Ваша организация: '.. mainIni.Info.org)
                imgui.Text(u8'Ваша должность: '.. mainIni.Info.dl)
                if imgui.Combo(u8'Темы',colorListNumber,colorListBuffer, #colorList) then -- создаём комбо для выбора темы
                    themeta = theme[colorListNumber[0]+1].change() -- меняем на выбранную тему
                    mainIni.theme.themeta = colorListNumber[0]
                    inicfg.save(mainIni, 'mvdhelper.ini')
                end
                if imgui.Button(u8'УК') then
                    setUkWindow[0] = not setUkWindow[0]
                end
            elseif tab == 2 then -- если значение tab == 2
                imgui.InputInt(u8 'ID игрока с которым будете взаимодействовать', id, 10)
                if imgui.Button(u8 'Приветствие') then
                    lua_thread.create(function()
                        sampSendChat("Доброго времени суток, я «" .. nickname .. "» «" ..  u8:decode(mainIni.Info.dl) .."».")
                        wait(1500)
                        sampSendChat("/do Удостоверение в руках.")
                        wait(1500)
                        sampSendChat("/me показал своё удостоверение человеку на против")
                        wait(1500)
                        sampSendChat("/do «" .. nickname .. "».")
                        wait(1500)
                        sampSendChat("/do «" .. u8:decode(mainIni.Info.dl) .. "» " .. mainIni.Info.org .. ".")
                        wait(1500)
                        sampSendChat("Предъявите ваши документы, а именно паспорт. Не беспокойтесь, это всего лишь проверка.")
                    end)
                end
                if imgui.Button(u8 'Найти игрока') then
                    lua_thread.create(function()
                        sampSendChat("/do КПК в левом кармане.")
                        wait(1500)
                        sampSendChat("/me достал левой рукой КПК из кармана")
                        wait(1500)
                        sampSendChat("/do КПК в левой руке.")
                        wait(1500)
                        sampSendChat("/me включил КПК и зашел в базу данных Полиции")
                        wait(1500)
                        sampSendChat("/me открыл дело номер " .. id[0] .. " преступника")
                        wait(1500)
                        sampSendChat("/do Данные преступника получены.")
                        wait(1500)
                        sampSendChat("/me подключился к камерам слежения штата")
                        wait(1500)
                        sampSendChat("/do На навигаторе появился маршрут.")
                        wait(1500)
                        sampSendChat("/pursuit " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Арест') then
                    lua_thread.create(function()
                        sampSendChat("/me взял ручку из кармана рубашки, затем открыл бардачок и взял оттуда бланк протокола")
                        wait(1500)
                        sampSendChat("/do Бланк протокола и ручка в руках.")
                        wait(1500)
                        sampSendChat("/me заполняет описание внешности нарушителя")
                        wait(1500)
                        sampSendChat("/me заполняет характеристику о нарушителе")
                        wait(1500)
                        sampSendChat("/me заполняет данные о нарушении")
                        wait(1500)
                        sampSendChat("/me проставил дату и подпись")
                        wait(1500)
                        sampSendChat("/me положил ручку в карман рубашки")
                        wait(1500)
                        sampSendChat("/do Ручка в кармане рубашки.")
                        wait(1500)
                        sampSendChat("/me передал бланк составленного протокола в участок")
                        wait(1500)
                        sampSendChat("/me передал преступника в Управление Полиции под стражу")
                        wait(1500)
                        sampSendChat("/arrest")
                        sampAddChatMessage("Встаньте на чекпоинт",0x8B00FF)
                    end)
                end
                if imgui.Button(u8 'Надеть наручники') then
                    lua_thread.create(function()
                        sampSendChat("/do Наручники висят на поясе.")
                        wait(1500)
                        sampSendChat("/me снял с держателя наручники")
                        wait(1500)
                        sampSendChat("/do Наручники в руках.")
                        wait(1500)
                        sampSendChat("/me резким движением обеих рук, надел наручники на преступника")
                        wait(1500)
                        sampSendChat("/do Преступник скован.")
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Снять наручники') then
                    lua_thread.create(function()
                        sampSendChat("/do Ключ от наручников в кармане.")
                        wait(1500)
                        sampSendChat("/me движением правой руки достал из кармана ключ и открыл наручники")
                        wait(1500)
                        sampSendChat("/do Преступник раскован.")
                        wait(1500)
                        sampSendChat("/uncuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Вести за собой') then
                    lua_thread.create(function()
                        ampSendsChat("/me заломил правую руку нарушителю")
                        wait(1500)
                        sampSendChat("/me ведет нарушителя за собой")
                        wait(1500)
                        sampSendChat("/gotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Перестать вести за собой') then
                    lua_thread.create(function()
                        sampSendChat("/me отпустил правую руку преступника")
                        wait(1500)
                        sampSendChat("/do Преступник свободен.")
                        wait(1500)
                        sampSendChat("/ungotome " .. id[0])
                    end)
                end
                if imgui.Button(u8 'В машину(автоматически на 3-е место)') then
                    lua_thread.create(function()
                        sampSendChat("/do Двери в машине закрыты.")
                        wait(1500)
                        sampSendChat("/me открыл заднюю дверь в машине")
                        wait(1500)
                        sampSendChat("/me посадил преступника в машину")
                        wait(1500)
                        sampSendChat("/me заблокировал двери")
                        wait(1500)
                        sampSendChat("/do Двери заблокированы.")
                        wait(1500)
                        sampSendChat("/incar " .. id[0] .. "3")
                    end)
                end
                if imgui.Button(u8 'Обыск') then
                    lua_thread.create(function()
                        sampSendChat("/me нырнув руками в карманы, вытянул оттуда белые перчатки и натянул их на руки")
                        wait(1500)
                        sampSendChat("/do Перчатки надеты.")
                        wait(1500)
                        sampSendChat("/me проводит руками по верхней части тела")
                        wait(1500)
                        sampSendChat("/me проверяет карманы/me проводит руками по ногам")
                        wait(1500)
                        sampSendChat("/frisk " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Мегафон') then
                    lua_thread.create(function()
                        sampSendChat("/do Мегафон в бардачке.")
                        wait(1500)
                        sampSendChat("/me достал мегафон с бардачка после чего включил его")
                        wait(1500)
                        sampSendChat("/m Водитель авто, остановитесь и заглушите двигатель, держите руки на руле.")
                    end)
                end
                if imgui.Button(u8 'Вытащить из авто') then
                    lua_thread.create(function()
                        sampSendChat("/me сняв дубинку с поясного держателя разбил стекло в транспорте")
                        wait(1500)
                        sampSendChat("/do Стекло разбито.")
                        wait(1500)
                        sampSendChat("/me схватив за плечи человека ударил его после чего надел наручники")
                        wait(1500)
                        sampSendChat("/pull " .. id[0])
                        wait(1500)
                        sampSendChat("/cuff " .. id[0])
                    end)
                end
                if imgui.Button(u8 'Выдача розыска') then
                    windowTwo[0] = not windowTwo[0]
                end

            elseif tab == 3 then -- если значение tab == 3
                imgui.InputText(u8 'Фракция с которой будете взаимодействовать', otherorg, 255)
                otherdeporg = u8:decode(ffi.string(otherorg))
                imgui.Checkbox(u8 'Закрытый канал', zk)
                if imgui.Button(u8 'Вызов на связь') then
                    if zk[0] then
                        sampSendChat("/d [" .. mainIni.Info.org .. "] з.к [" .. otherdeporg .. "] На связь!")
                    else
                        sampSendChat("/d [" .. mainIni.Info.org .. "] 91.8 [" .. otherdeporg .. "] На связь!")
                    end
                end
                if imgui.Button(u8 'Откат') then
                    sampSendChat("/d [" .. mainIni.Info.org .. "] 91.8 [Информация] Тех. Неполадки!")
                end
            elseif tab == 4 then
                if imgui.CollapsingHeader(u8'Биндер') then
                    if imgui.CollapsingHeader(u8'Лекции') then
                        if imgui.Button(u8'Арест и задержание') then
                            lua_thread.create(function()
                                sampSendChat("Здравствуйте уважаемые сотрудники нашего департамента!")
                                wait(1500)
                                sampSendChat("Сейчас будет проведена лекция на тему арест и задержание преступников.")
                                wait(1500)
                                sampSendChat("Для начала объясню различие между задержанием и арестом.")
                                wait(1500)
                                sampSendChat("Задержание - это кратковременное лишение свободы лица, подозреваемого в совершении преступления.")
                                wait(1500)
                                sampSendChat("В свою очередь, арест - это вид уголовного наказания, заключающегося в содержании совершившего преступление..")
                                wait(1500)
                                sampSendChat("..и осуждённого по приговору суда в условиях строгой изоляции от общества.")
                                wait(1500)
                                sampSendChat("Вам разрешено задерживать лица на период 48 часов с момента их задержания.")
                                wait(1500)
                                sampSendChat("Если в течение 48 часов вы не предъявите доказательства вины, вы обязаны отпустить гражданина.")
                                wait(1500)
                                sampSendChat("Обратите внимание, гражданин может подать на вас иск за незаконное задержание.")
                                wait(1500)
                                sampSendChat("Во время задержания вы обязаны провести первичный обыск на месте задержания и вторичный у капота своего автомобиля.")
                                wait(1500)
                                sampSendChat("Все найденные вещи положить в 'ZIP-lock', или в контейнер для вещ. доков, Все личные вещи преступника кладутся в мешок для личных вещей задержанного")
                                wait(1500)
                                sampSendChat("На этом данная лекция подходит к концу. У кого-то имеются вопросы?")
                            end)
                        end
                        if imgui.Button("Суббординация") then
                            lua_thread.create(function()
                                sampSendChat(" Уважаемые сотрудники Полицейского Департамента!")
                                wait(1500)
                                sampSendChat(" Приветствую вас на лекции о субординации")
                                wait(1500)
                                sampSendChat(" Для начала расскажу, что такое субординация")
                                wait(1500)
                                sampSendChat(" Субординация - правила подчинения младших по званию к старшим по званию, уважение, отношение к ним")
                                wait(1500)
                                sampSendChat(" То есть младшие сотрудники должны выполнять приказы начальства")
                                wait(1500)
                                sampSendChat(" Кто ослушается  получит выговор, сперва устный")
                                wait(1500)
                                sampSendChat(" Вы должны с уважением относится к начальству на 'Вы'")
                                wait(1500)
                                sampSendChat(" Не нарушайте правила и не нарушайте субординацию дабы не получить наказание")
                                wait(1500)
                                sampSendChat(" Лекция окончена спасибо за внимание!")
                            end)
                        end
                        if imgui.Button(u8"Суббординация") then
                            lua_thread.create(function()
                                sampSendChat(" Уважаемые сотрудники Полицейского Департамента!")
                                wait(1500)
                                sampSendChat(" Приветствую вас на лекции о субординации")
                                wait(1500)
                                sampSendChat(" Для начала расскажу, что такое субординация")
                                wait(1500)
                                sampSendChat(" Субординация - правила подчинения младших по званию к старшим по званию, уважение, отношение к ним")
                                wait(1500)
                                sampSendChat(" То есть младшие сотрудники должны выполнять приказы начальства")
                                wait(1500)
                                sampSendChat(" Кто ослушается  получит выговор, сперва устный")
                                wait(1500)
                                sampSendChat(" Вы должны с уважением относится к начальству на 'Вы'")
                                wait(1500)
                                sampSendChat(" Не нарушайте правила и не нарушайте субординацию дабы не получить наказание")
                                wait(1500)
                                sampSendChat(" Лекция окончена спасибо за внимание!")
                            end)
                        end
                        if imgui.Button(u8"Правила поведения в строю.") then
                            lua_thread.create(function()
                                sampSendChat(" Уважаемые сотрудники Полицейского Департамента!")
                                wait(1500)
                                sampSendChat(" Приветствую вас на лекции правила поведения в строю")
                                wait(1500)
                                sampSendChat(" /b Запрещены разговоры в любые чаты (in ic, /r, /n, /fam, /sms,)")
                                wait(1500)
                                sampSendChat(" Запрещено пользоваться мобильными телефонами")
                                wait(1500)
                                sampSendChat(" Запрещено доставать оружие")
                                wait(1500)
                                sampSendChat(" Запрещено открывать огонь без приказа")
                                wait(1500)
                                sampSendChat(" /b Запрещено уходить в AFK более чем на 30 секунд")
                                wait(1500)
                                sampSendChat(" Запрещено самовольно покидать строй не предупредив об этом старший состав")
                                wait(1500)
                                sampSendChat(" /b Запрещены любые движения в строю (/anim) Исключение: ст. состав")
                                wait(1500)
                                sampSendChat(" /b Запрещено использование сигарет [/smoke в строю]")
                            end)
                        end
                        if imgui.Button(u8'Допрос') then
                            lua_thread.create(function()
                                sampSendChat(" Здравствуйте уважаемые сотрудники департамента сегодня, я проведу лекцию на тему Допрос подозреваемого.")
                                wait(1500)
                                sampSendChat(" Сотрудник ПД обязан сначала поприветствовать, представиться;")
                                wait(1500)
                                sampSendChat(" Сотрудник ПД обязан попросить документы вызванного, спросить, где работает, звание, должность, место жительства;")
                                wait(1500)
                                sampSendChat(" Сотрудник ПД обязан спросить, что он делал (назвать промежуток времени, где он что-то нарушил, по которому он был вызван);")
                                wait(1500)
                                sampSendChat(" Если подозреваемый был задержан за розыск, старайтесь узнать за что он получил розыск;")
                                wait(1500)
                                sampSendChat(" В конце допроса полицейский выносит вердикт вызванному.")
                                wait(1500)
                                sampSendChat(" При оглашении вердикта, необходимо предельно точно огласить вину допрашиваемого (Рассказать ему причину, за что он будет посажен);")
                                wait(1500)
                                sampSendChat(" При вынесении вердикта, не стоит забывать о отягчающих и смягчающих факторах (Раскаяние, адекватное поведение, признание вины или ложь, неадекватное поведение, провокации, представление полезной информации и тому подобное).")
                                wait(1500)
                                sampSendChat(" На этом лекция подошла к концу, если у кого-то есть вопросы, отвечу на любой по данной лекции (Если задали вопрос, то нужно ответить на него)")
                            end)
                        end
                        if imgui.Button(u8"Правила поведения до и во время облавы на наркопритон.") then
                            lua_thread.create(function()
                                sampSendChat(" Добрый день, сейчас я проведу вам лекцию на тему Правила поведения до и во время облавы на наркопритон")
                                wait(1500)
                                sampSendChat(" В строю, перед облавой, вы должны внимательно слушать то, что говорят вам Агенты")
                                wait(1500)
                                sampSendChat(" Убедительная просьба, заранее убедиться, что при себе у вас имеются балаклавы")
                                wait(1500)
                                sampSendChat(" По пути к наркопритону, подъезжая к опасному району, все обязаны их одеть")
                                wait(1500)
                                sampSendChat(" Приехав на территорию притона, нужно поставить оцепление так, чтобы загородить все возможные пути к созревающим кустам Конопли")
                                wait(1500)
                                sampSendChat(" Очень важным замечанием является то, что никому, кроме агентов, запрещено подходить к кустам, а тем более их собирать")
                                wait(1500)
                                sampSendChat(" Нарушение данного пункта строго наказывается, вплоть до увольнение")
                                wait(1500)
                                sampSendChat(" Так же приехав на место, мы не устраиваем пальбу по всем, кого видим")
                                wait(1500)
                                sampSendChat(" Открывать огонь по постороннему разрешается только в том случае, если он нацелился на вас оружием, начал атаковать вас или собирать созревшие кусты")
                                wait(1500)
                                sampSendChat(" Как только спец. операция заканчивается, все оцепление убирается")
                                wait(1500)
                                sampSendChat(" На этом лекция окончена, всем спасибо")
                            end)
                        end
                        if imgui.Button(u8"Правило миранды.") then
                            lua_thread.create(function()
                                sampSendChat("Правило Миранды — юридическое требование в США")
                                wait(1500)
                                sampSendChat("Согласно которому во время задержания задерживаемый должен быть уведомлен о своих правах.")
                                wait(1500)
                                sampSendChat("Это правило зачитываются задержанному, а читает её кто сам задержал его.")
                                wait(1500)
                                sampSendChat("Это фраза говорится, когда вы надели на задержанного наручники.")
                                wait(1500)
                                sampSendChat("Цитирую саму фразу:")
                                wait(1500)
                                sampSendChat("- Вы имеете право хранить молчание.")
                                wait(1500)
                                sampSendChat("- Всё, что вы скажете, может и будет использовано против вас в суде.")
                                wait(1500)
                                sampSendChat("- Ваш адвокат может присутствовать при допросе.")
                                wait(1500)
                                sampSendChat("- Если вы не можете оплатить услуги адвоката, он будет предоставлен вам государством.")
                                wait(1500)
                                sampSendChat("- Вы понимаете свои права?")
                            end)
                        end
                        if imgui.Button(u8"Первая Помощь.") then
                            lua_thread.create(function()
                                sampSendChat("Для начала определимся что с пострадавшим")
                                wait(1500)
                                sampSendChat("Если, у пострадавшего кровотечение, то необходимо остановить поток крови жгутом")
                                wait(1500)
                                sampSendChat("Если ранение небольшое достаточно достать набор первой помощи и перевязать рану бинтом")
                                wait(1500)
                                sampSendChat("Если в ране пуля, и рана не глубокая, Вы должны вызвать скорую либо вытащить ее скальпелем, скальпель также находится в аптечке первой помощи")
                                wait(1500)
                                sampSendChat("Если человек без сознания вам нужно ... ")
                                wait(1500)
                                sampSendChat(" ... достать из набор первой помощи вату и спирт, затем намочить вату спиртом ... ")
                                wait(1500)
                                sampSendChat(" ... и провести ваткой со спиртом около носа пострадавшего, в этом случае, он должен очнуться")
                                wait(1500)
                                sampSendChat("На этом лекция окончена. У кого-то есть вопросы по данной лекции?") wait(1500)
                            end)
                        end
                    end
                end
                if rang_n > 8 then
                    if imgui.Button(u8'Панель лидера/заместителя') then
                        leaderPanel[0] = not leaderPanel[0]
                    end
                end
            elseif tab == 5 then
                if imgui.CollapsingHeader(u8 'УК') then
                    for i = 1, #tableUk["Text"] do
                        imgui.Text(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Text"][i]))
                    end
                end
                if imgui.CollapsingHeader(u8 'Тен-коды') then
                    imgui.Text(u8"10-1 - Встреча всех офицеров на дежурстве (указывая локацию и код).")
                    imgui.Text(u8"10-2 - Вышел в патруль.")
                    imgui.Text(u8"10-2R: Закончил патруль.")
                    imgui.Text(u8"10-3 - Радиомолчание (указывая длительность).")
                    imgui.Text(u8"10-4 - Принято.")
                    imgui.Text(u8"10-5 - Повторите.")
                    imgui.Text(u8"10-6 - Не принято/неверно/нет.")
                    imgui.Text(u8"10-7 - Ожидайте.")
                    imgui.Text(u8"10-8 - Недоступен.")
                    imgui.Text(u8"10-14 - Запрос транспортировки (указывая локацию и цель транспортировки).")
                    imgui.Text(u8"10-15 - Подозреваемые арестованы (указывая количество подозреваемых и локацию).")
                    imgui.Text(u8"10-18 - Требуется поддержка дополнительных юнитов.")
                    imgui.Text(u8"10-20 - Локация.")
                    imgui.Text(u8"10-21 - Описание ситуации.")
                    imgui.Text(u8"10-22 - Направляюсь в ....")
                    imgui.Text(u8"10-27 - Смена маркировки патруля (указывая старую маркировку и новую).")
                    imgui.Text(u8"10-30 - Дорожно-транспортное происшествие.")
                    imgui.Text(u8"10-40 - Большое скопление людей (более 4).")
                    imgui.Text(u8"10-41 - Нелегальная активность.")
                    imgui.Text(u8"10-46 - Провожу обыск.")
                    imgui.Text(u8"10-55 - Обычный Траффик Стоп.")
                    imgui.Text(u8"10-57 VICTOR - Погоня за автомобилем (указывая модель авто, цвет авто, количество человек внутри, локацию, направление движения).")
                    imgui.Text(u8"10-57 FOXTROT - Пешая погоня (указывая внешность подозреваемого, оружие (при наличии информации о вооружении), локация, направление движения).")
                    imgui.Text(u8"10-60 - Информация об автомобиле (указывая модель авто, цвет, количество человек внутри).")
                    imgui.Text(u8"10-61 - Информация о пешем подозреваемом (указывая расу, одежду).")
                    imgui.Text(u8"10-66 - Траффик Стоп повышеного риска.")
                    imgui.Text(u8"10-70 - Запрос поддержки (в отличии от 10-18 необходимо указать количество юнитов и код).")
                    imgui.Text(u8"10-71 - Запрос медицинской поддержки.")
                    imgui.Text(u8"10-99 - Ситуация урегулирована.")
                    imgui.Text(u8"10-100 - Нарушение юрисдикции ")
                end
                if imgui.CollapsingHeader(u8 'Маркировки патрулей') then
                    imgui.CenterText('Маркировки патрульных автомобилей')
                    imgui.Text(u8"* ADAM (A) - маркировка патруля с двумя офицерами на крузер")
                    imgui.Text(u8"* LINCOLN (L) - маркировки патруля с одним офицером на крузер")
                    imgui.Text(u8"* LINCOLN 10/20/30/40/50/60 - маркировка супервайзера")
                    imgui.CenterText('Маркировки других транспортных средств')
                    imgui.Text(u8"* MARY (M) - маркировка мотоциклетного патруля")
                    imgui.Text(u8"* AIR (AIR) - маркировка юнита Air Support Division")
                    imgui.Text(u8"* AIR-100 - маркировка супервайзера Air Support Division")
                    imgui.Text(u8"* AIR-10 - маркировка спасательного юнита Air Support Division")
                    imgui.Text(u8"* EDWARD (E) - маркировка Tow Unit")
                end

            elseif tab == 6 then
                imgui.Checkbox(u8 'Авто отыгровка оружия', autogun)
                if autogun[0] then
                    lua_thread.create(function()
                        while true do
                            wait(0)
                            if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
                                local gun = getCurrentCharWeapon(PLAYER_PED)
                                if gun == 3 then
                                    sampSendChat("/me достал дубинку с поясного держателя")
                                elseif gun == 16 then
                                    sampSendChat("/me взял с пояса гранату")
                                elseif gun == 17 then
                                    sampSendChat("/me взял гранату слезоточивого газа с пояса")
                                elseif gun == 23 then
                                    sampSendChat("/me достал тайзер с кобуры, убрал предохранитель")
                                elseif gun == 22 then
                                    sampSendChat("/me достал пистолет Colt-45, снял предохранитель")
                                elseif gun == 24 then
                                    sampSendChat("/me достал Desert Eagle с кобуры, убрал предохранитель")
                                elseif gun == 25 then
                                    sampSendChat("/me достал чехол со спины, взял дробовик и убрал предохранитель")
                                elseif gun == 26 then
                                    sampSendChat("/me резким движением обоих рук, снял военный рюкзак с плеч и достал Обрезы")
                                elseif gun == 27 then
                                    sampSendChat("/me достал дробовик Spas, снял предохранитель")
                                elseif gun == 28 then
                                    sampSendChat("/me резким движением обоих рук, снял военный рюкзак с плеч и достал УЗИ")
                                elseif gun == 29 then
                                    sampSendChat("/me достал чехол со спины, взял МП5 и убрал предохранитель")
                                elseif gun == 30 then
                                    sampSendChat("/me достал карабин AK-47 со спины")
                                elseif gun == 31 then
                                    sampSendChat("/me достал карабин М4 со спины")
                                elseif gun == 32 then
                                    sampSendChat("/me резким движением обоих рук, снял военный рюкзак с плеч и достал TEC-9")
                                elseif gun == 33 then
                                    sampSendChat("/me достал винтовку без прицела из военной сумки")
                                elseif gun == 34 then
                                    sampSendChat("/me достал Снайперскую винтовку с военной сумки")
                                elseif gun == 43 then
                                    sampSendChat("/me достал фотокамеру из рюкзака")
                                elseif gun == 0 then
                                    sampSendChat("/me поставил предохранитель, убрал оружие")
                                end
                                lastgun = gun
                            end
                        end
                    end)
                end
                imgui.Checkbox(u8'Авто-доклад патруля каждые 10 минут(включать при начале)/]. Всего 30 минут', patrul)
                imgui.InputText(u8'Ник вашего напарника(на англиском)', partner, 255)
                partnerNick = u8:decode(ffi.string(partner))
                imgui.Checkbox(u8'Позывной при докладах', pozivn)
                imgui.InputText(u8'Ваш позывной', poziv, 255)
                pozivnoi = u8:decode(ffi.string(poziv))
                if patrul[0] and pozivn[0] then
                    poziv[0] = false
                    patrul[0] = false
                    lua_thread.create(function()
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Выхожу в патруль. Напарник - " .. partnerNick .. ". Доступен.")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Продолжаю патруль с " .. partnerNick .. ". Состояние стабильное. Доступен")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Продолжаю патруль с " .. partnerNick .. ". Состояние стабильное. Доступен")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. " [" .. pozivnoi .. "]. Заканчиваю патруль с " .. partnerNick .. ".")
                    end)
                elseif patrul[0] then
                    lua_thread.create(function()
                        patrul[0] = false
                        sampSendChat("/r " .. nickname .. ". Выхожу в патруль. Напарник - " .. partnerNick .. ". Доступен.")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Продолжаю патруль с " .. partnerNick .. ". Состояние стабильное. Доступен")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Продолжаю патруль с " .. partnerNick .. ". Состояние стабильное. Доступен")
                        wait(599999)
                        sampSendChat("/r " .. nickname .. ". Заканчиваю патруль с " .. partnerNick .. ".")
                    end)

                end
                imgui.Checkbox(u8'Авто-Акцент', AutoAccentBool)
                if AutoAccentBool[0] then
                    AutoAccentCheck = true
                    mainIni.Accent.autoAccent = true
                    inicfg.save(mainIni, "mvdhelper.ini")
                else
                    mainIni.Accent.autoAccent = false
                    inicfg.save(mainIni, "mvdhelper.ini")
                end
                imgui.InputText(u8'Акцент', AutoAccentInput, 255)
                AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
                mainIni.Accent.accent = AutoAccentText
                inicfg.save(mainIni, "mvdhelper.ini")
                if imgui.Button(u8'Вспомогательное окошко') then
                	suppWindow[0] = not suppWindow [0]

				end
            elseif tab == 7 then
                imgui.Text(u8'Версия: 4.8')
                imgui.Text(u8'Разработчик: @Sashe4ka_ReZoN')
                imgui.Text(u8'ТГ канал: @lua_arz')
                imgui.Text(u8'Поддержать: https://qiwi.com/n/SASHE4KAREZON')
                imgui.Text(u8'Спонсоры: @Negt,@King_Rostislavia,@sidrusha,@Timur77998')
                imgui.Text(u8'Сделано При поддержке Arzfun Mobile(бесплатная админка) @ArizonaMobileFun')
                imgui.Text(u8'Обновление 4.1 - Изменение интерфейса, добавление вкладок "Инфо" и "Для СС". Добавлен авто акцент. Фикс багов.')
                imgui.Text(u8'Обновление 4.2 - Фикс авто определения. Доступ к панелии СС с любого ранга(Панель лидера также остается от 9 ранга).')
                imgui.Text(u8'Обновление 4.3 - Фикс приветствия. Добавленно ФБР в список организаций')
                imgui.Text(u8'Обновление 4.4 - Добавили лекции,Панель лидера(в разработке)')
                imgui.Text(u8'Обновление 4.5 - Теперь можно поставить свой УК. Добавлена фиолетовая тема. Обновлен /mvds')
                imgui.Text(u8'Обновление 4.6 - Фикс багов,Изменены некоторые отыгровки')
                imgui.Text(u8'Обновление 4.7 - Добавлена Команда /traf пофикшены баги,авто акцент и измененны некоторые отыгровки')
                imgui.Text(u8'Обновление 4.8 - Писюн патсохи')
                if imgui.Button(u8'Обновить') then
            		updateScript(scriptUrl, scriptPath)
            	end
            end
            -- == [Основное] Содержимое вкладок закончилось == --
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
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Скрипт успешно загрузился", 0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Авторы:t.me/Sashe4ka_ReZoN",0x8B00FF)
        sampAddChatMessage("[Sashe4ka Police Helper]: {FFFFFF}Чтобы посмотреть комманды,введите /mvd и /mvds ",0x8B00FF)
        nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
    end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if dialogId == 235 and title == "{BFBBBA}Основная статистика" then
        statsCheck = true
        if string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция ЛВ" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция ЛС" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция СФ" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "SFa" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "LSa" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "RCSD"  or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Областная полиция" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "ФБР" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "FBI" then
            org = string.match(text, "Организация: {B83434}%[(%D+)%]")
            if org ~= 'Не имеется' then dol = string.match(text, "Должность: {B83434}(%D+)%(%d+%)") end
            dl = u8(dol)
            if org == 'Полиция ЛВ' then org_g = u8'LVPD'; ccity = u8'Лас-Вентурас'; org_tag = 'LVPD' end
            if org == 'Полиция ЛС' then org_g = u8'LSPD'; ccity = u8'Лос-Сантос'; org_tag = 'LSPD' end
            if org == 'Полиция СФ' then org_g = u8'SFPD'; ccity = u8'Сан-Фиерро'; org_tag = 'SFPD' end
            if org == 'ФБР' then org_g = u8'FBI'; ccity = u8'Сан-Фиерро'; org_tag = 'FBI' end
            if org == 'FBI' then org_g = u8'FBI'; ccity = u8'Сан-Фиерро'; org_tag = 'FBI' end
            if org == 'RCSD' or org == 'Областная полиция' then org_g = u8'RCSD'; ccity = u8'Red Country'; org_tag = 'RCSD' end
            if org == 'LSa' or org == 'Армия Лос Сантос' then org_g = u8'LSa'; ccity = u8'Лос Сантос'; org_tag = 'LSa' end
            if org == 'SFa' or org == 'Армия Сан Фиерро' then org_g = u8'SFa'; ccity = u8'Сан Фиерро'; org_tag = 'SFa' end
            if org == '[Не имеется]' then
                org = 'Вы не состоите в ПД'
                org_g = 'Вы не состоите в ПД'
                ccity = 'Вы не состоите в ПД'
                org_tag = 'Вы не состоите в ПД'
                dol = 'Вы не состоите в ПД'
                dl = 'Вы не состоите в ПД'
            else
                rang_n = tonumber(string.match(text, "Должность: {B83434}%D+%((%d+)%)"))
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
    -- == Декор часть == --
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
    decor() -- применяем декор часть
    theme[colorListNumber[0]+1].change() -- применяем цветовую часть
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 20, config, iconRanges) -- solid - тип иконок, так же есть thin, regular, light и duotone
end)

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(u8(text))
end

function cmd_showpass(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/showpass [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me достал папку с документами")
            wait(1500)
            sampSendChat("/do Папка в руке.")
            wait(1500)
            sampSendChat("/me достал паспорт")
            wait(1500)
            sampSendChat("/do Паспорт в руке.")
            wait(1500)
            sampSendChat("/me передал паспорт человеку на против")
            wait(1500)
            sampSendChat("/showpass " .. id .. " ")
        end)
    end
end

function cmd_showbadge(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/showbadge [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me из внутреннего кармана достал удостоверение")
            wait(1500)
            sampSendChat("/me открыл документ в развёрнутом виде, показал содержимое человеку напротив")
            wait(1500)
            sampSendChat("/do Ниже находится печать правительства и подпись.")
            wait(1500)
            sampSendChat("/me закрыл документ , убрал его обратно в карман")
            wait(1500)
            sampSendChat ("/showbadge "..id.." ")
        end)
    end
end

function cmd_showlic(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/showlic [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me достал папку с документами")
            wait(1500)
            sampSendChat("/do Папка в руке.")
            wait(1500)
            sampSendChat("/me достал лицензии")
            wait(1500)
            sampSendChat("/do Лицензии в руке.")
            wait(1500)
            sampSendChat("/me передал лицензии человеку на против")
            wait(1500)
            sampSendChat("/showlic " .. id .. " ")
        end)
    end
end

function cmd_mvds(id)
        lua_thread.create(function()
        sampShowDialog(1,"Команды MVD HELPER 4.7", "/showlic -  Показывает ваши лицензии\n/showpass - Показывает ваш паспорт\n/showmc - Показывает вашу Мед. Карту\n/showskill - Показывает ваши навыки оружия\n/showbadge - Показать ваше удостоверение человеку\n/pull - Выкидывает чаловека из авто и оглушает\n/uninvite - Уволить человека из организации\n/invite - Принять человека в организацию\n/cuff - Надеть наручники\n/uncuff - Снять наручники\n/frisk - Обыскать человека\n/mask - Надеть маску\n/arm - Снять/Надеть бронижелет\n/asu - Выдать розыск\n/drug - Использовать наркотики\n/arrest - Метка для ареста человека\n/stop - 10-55 Траффик-Стоп\n/giverank - Выдать ранг человеку\n/unmask - Снять маску с преступника\n/miranda - Зачитать права\n/bodyon - Включить Боди-Камеру\n/bodyoff - Выключить Боди-Камеру\n/ticket - Выписать штраф\n/pursuit - Вести преследование за игроком\n/drugtestno - Тест на наркотики ( Отрицательный )\n/drugtestyes - Тест на наркотики ( Положительный )\n/vzatka - Рп Взятка\n/bomb - Разминирование бомбы\n/dismiss - Уволить человека из организации ( 6 ФБР )\n/demoute - Уволить человека из организации ( 9 ФБР )\n/cure - Вылечить друга которого положили\n/find - Отыгровка поиска преступника\n/incar - Посадить преступника в машину\n/tencodes - Тен Коды\n/marks - Марки Авто\n/sitcodes - Ситуационные Коды\n/zsu - Запрос в розыск\n/mask - Надеть маску\n/take - Забрать запрещёные вещи\n/gcuff - cuff + gotome\n/fbi.secret - документ о неразглашении деятельности ФБР\n/fbi.pravda - Документ о правдивости слов на допросе\n/finger.p - Снятие отпечатков пальцев человека\n/podmoga - Вызов подмоги в /r\n/traf - Погоня 10-55\n/grim - Нанесение грима\n/eks - Экспертиза оружие\n/traf - не помню\nАвтор:t.me/Sashe4ka_ReZoN", "Закрыть", "Exit", 0)
        end)
        end


function cmd_showskill(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/showskill [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me достал папку с документами")
            wait(1500)
            sampSendChat("/do Папка в руке.")
            wait(1500)
            sampSendChat("/me достал выписку с тира")
            wait(1500)
            sampSendChat("/do Выписка в руке.")
            wait(1500)
            sampSendChat("/me передал выписку человеку на против")
            wait(1500)
            sampSendChat("/showskill " .. id .. " ")
        end)
    end
end

function cmd_showmc(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/showmc [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me достал папку с документами")
            wait(1500)
            sampSendChat("/do Папка в руке.")
            wait(1500)
            sampSendChat("/me достал мед. карту")
            wait(1500)
            sampSendChat("/do Мед. карта в руке.")
            wait(1500)
            sampSendChat("/me передал мед. карту человеку на против")
            wait(1500)
            sampSendChat("/showmc " .. id .. " ")
        end)
    end
end

function cmd_pull(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/pull [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/pull " .. id .. " ")
            wait(1500)
            sampSendChat("/me схватил дубинку с пояса, резким взмахом ее и начал бить по окну водителя")
            wait(1500)
            sampSendChat("/me разбив стекло, открыл дверь изнутри и схватил водителя за одежду ...")
            wait(1500)
            sampSendChat("/me ... после чего, выбросил подозреваемого на асфальт и заломал его руки")

        end)
    end
end

function cmd_invite(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/invite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Под стойкой находится рюкзак.")
            wait(1500)
            sampSendChat("/do Форма в рюкзаке...")
            wait(1500)
            sampSendChat("/me сунул руку в рюкзак, после чего взял форму и бейджик в руки")
            wait(1500)
            sampSendChat("/me передаёт форму и бейджик")
            wait(1500)
            sampSendChat("/todo Идите переоденьтесь*указывая пальцем на дверь раздевалки")
            wait(1500)
            sampSendChat("/invite " .. id .. " ")
        end)
    end
end

function cmd_uninvite(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/uninvite [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat ("/do На поясе закреплен КПК.")
            wait(1500)
            sampSendChat("/me снимает КПК с пояса и нажатием кнопки включает его.")
            wait(1500)
            sampSendChat ("/me заходит в базу сотрудников и выбирает нужного, после чего нажимает на кнопку *Уволить*.")
            wait(1500)
            sampSendChat ("/me выключает КПК и вешает обратно на пояс.")
            wait(1500)
            sampSendChat("/uninvite " .. id .. " ")
        end)
    end
end

function cmd_cuff(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/cuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Наручники висят на поясе.")
            wait(1500)
            sampSendChat("/me снял с держателя наручники")
            wait(1500)
            sampSendChat("/do Наручники в руках.")
            wait(1500)
            sampSendChat("/me резким движением обеих рук, надел наручники на преступника")
            wait(1500)
            sampSendChat("/do Преступник скован.")
            wait(1500)
            sampSendChat("/cuff "..id.." ")
         end)
      end
   end

function cmd_uncuff(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/uncuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Ключ от наручников в кармане.")
            wait(1500)
            sampSendChat("/me движением правой руки достал из кармана ключ и открыл наручники")
            wait(1500)
            sampSendChat("/do Преступник раскован.")
            wait(1500)
            sampSendChat("/uncuff "..id.." ")
        end)
     end
  end

function cmd_gotome(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/gotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me заломил правую руку нарушителю")
            wait(1500)
            sampSendChat("/me ведет нарушителя за собой")
            wait(1500)
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_ungotome(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/ungotome [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me отпустил правую руку преступника")
            wait(1500)
            sampSendChat("/do Преступник свободен.")
            wait(1500)
            sampSendChat("/ungotome "..id.." ")
        end)
     end
  end

function cmd_gcuff(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/gcuff [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do Наручники висят на поясе.")
            wait(1500)
            sampSendChat("/me снял с держателя наручники")
            wait(1500)
            sampSendChat("/do Наручники в руках.")
            wait(1500)
            sampSendChat("/me резким движением обеих рук, надел наручники на преступника")
            wait(1500)
            sampSendChat("/do Преступник скован.")
            wait(1500)
            sampSendChat("/cuff "..id.." ")
            wait(1500)
            sampSendChat("/me заломил правую руку нарушителю")
            wait(1500)
            sampSendChat("/me ведет нарушителя за собой")
            wait(1500)
            sampSendChat("/gotome "..id.." ")
        end)
     end
  end

function cmd_frisk(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/frisk [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me надев резиновые перчатки, начал прощупывать гражданина по всему телу ...")
            wait(1500)
            sampSendChat("/do Перчатки надеты.")
            wait(1500)
            sampSendChat("/me проводит руками по верхней части тела")
            wait(1500)
            sampSendChat("/me ... за тем начал тщательно обыскивать гражданина, выкладывая всё для изучения")
            wait(1500)
            sampSendChat("/frisk " .. id .. " ")
        end)
    end
end


function cmd_pursuit(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/pursuit [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/do КПК в левом кармане.")
            wait(1500)
            sampSendChat("/me достал КПК из левого кармана")
            wait(1500)
            sampSendChat("/me включил КПК и зашел в базу данных Полиции")
            wait(1500)
            sampSendChat("/me открыл дело с данными преступника")
            wait(1500)
            sampSendChat("/do Данные преступника получены.")
            wait(1500)
            sampSendChat("/me подключился к камерам слежения штата")
            wait(1500)
            sampSendChat("/pursuit " .. id .. " ")
        end)
    end
end

function cmd_arm(id)
        lua_thread.create(function()
            sampSendChat("/armour")
            wait(1500)
            sampSendChat("/me сменил пластины в бронижелете")
        end)
    end

    function cmd_agenda(id)
        if id == "" then
            sampAddChatMessage("Введи айди игрока:: {FFFFFF}/agenda [ID].",0x318CE7FF -1)
        else
            lua_thread.create(function()
                sampSendChat("/do В нагрудном кармане лежат бланки повесток.")
                wait(1500)
                sampSendChat("/me перекладывает паспорт в левую руку")
                wait(1500)
                sampSendChat("/me вытягивает из нагрудного кармана один бланк, разворачивает его и начинает заполнять")
                wait(1500)
                sampSendChat("/me переписывает все данные из паспорта, после чего ставит подпись")
                wait(1500)
                sampSendChat("/todo Вот, распишитесь*передавая бумаги человеку напротив")
                wait(1500)
                sampSendChat("/agenda " .. id .. " ")
            end)
        end
    end

function cmd_mask()
lua_thread.create(function()
            sampSendChat("/mask")
            wait(1500)
            sampSendChat("/me надел на руки перчатки, надел балаклаву на лицо")
        end)
    end

function cmd_drug(id)
    if id == "" then
         sampAddChatMessage("Введи кол-во нарко [1-3]: {FFFFFF}/usedrugs [1-3].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me достал из кармана конфетку рошен")
            wait(1200)
            sampSendChat("/do Снял фантик, съел ее.")
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
		sampSendChat("/me снял рацию с грудного держателя и сообщил диспетчеру о нарушителе")
        wait(1000)
        sampSendChat("/do Спустя полминуты получил ответ от диспетчера.")
        wait(1000)
        sampSendChat("/todo 10-4, Конец связи.*повесив рацию на грудной держатель")
    else
		sampAddChatMessage("Введи айди игрока: {FFFFFF}/asu [ID] [Кол-во розыска] [Причина].", 0x318CE7FF -1)
		end
	end)
end


function cmd_arrest(id)
    if id == "" then
         sampAddChatMessage("Введи айди игрока:: {FFFFFF}/arrest [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me нажав на тангету, сообщил диспетчеру о провезенном преступники ...")
            wait(1500)
            sampSendChat("/me запросил офицеров для сопровождения")
            wait(1500)
            sampSendChat("/do Департамент: Принято, ожидайте двух офицеров.")
            wait(1500)
            sampSendChat("/do Из участка выходят 2 офицера, после забирают преступника.")
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
            sampSendChat("/do На поясе закреплен КПК.")
            wait(1500)
            sampSendChat("/me снимает КПК с пояса и нажатием кнопки включает его")
            wait(1500)
            sampSendChat("/me заходит в базу сотрудников и вводит изменения, после чего вешает КПК обратно на пояс")
            wait(1500)
            sampSendChat("/todo Новая форма в шкафчике*улыбаясь взглянув в сторону двери")
            wait(1500)
        else
            sampAddChatMessage("Введи айди игрока:{FFFFFF}/giverank [ID] [Ранг 1-9].",0x318CE7FF -1)
        end
    end)
end

function cmd_unmask(id)
    if id == nil or id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/unmask [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me держа подозреваемого, левой рукой насильно сдирает маску с человека")
            wait(1500)
            sampSendChat("/unmask "..id.." ")
        end)
    end
end

function cmd_miranda()
lua_thread.create(function()
            sampSendChat("Вы имеете право хранить молчание.")
            wait(1500)
            sampSendChat("Всё, что вы скажете, мы можем и будем использовать против вас в суде.")
            wait(1500)
            sampSendChat("Вы имеете право на адвоката и на один телефонный звонок.")
            wait(1500)
            sampSendChat("Если у вас нет адвоката, государство предоставит вам адвоката, увидеть которого вы сможете в зале суда.")
            wait(1500)
            sampSendChat("Вам понятны ваши права?")
        end)
     end

function cmd_bodyon()

        lua_thread.create(function()
            sampSendChat("/do На груди  весит камера AXON BODY 3.")
            wait(1500)
            sampSendChat("/me легким движением руки протянулся к сенсору и нажал один раз для активации")
            wait(1500)
            sampSendChat("/do Боди камера издала звук и включилась.")
        end)
     end

function cmd_bodyoff()

lua_thread.create(function()
            sampSendChat("/do На груди  весит камера AXON BODY 3.")
            wait(1500)
            sampSendChat("/me легким движением руки протянулся к сенсору и нажал один раз для деактивации")
            wait(1500)
            sampSendChat("/do Боди камера издала звук и выключилась")
        end)
     end


function cmd_ticket(arg)
    lua_thread.create(function()
        local id, prichina, price = arg:match('(%d+)%s(%d+)%s(.)')
        if id ~= nil and prichina ~= nil and price ~= nil then
                sampSendChat("/me достав небольшой терминал, присоединил его к КПК и показал приёмник для карты")
                wait(1500)
                sampSendChat("/todo Вставьте сначала водительскую, затем кредитную карту в приёмник!*держа терминал")
                wait(1500)
                sampSendChat('/ticket '..id..' '..prichina..'  '..price..' ')
         else
      sampAddChatMessage("Введи айди игрока: {FFFFFF}/ticket [ID] [Сумма] [Причина].", 0x318CE7FF)
      end
     end)
    end

function cmd_pursuit(id)
    if id == "" then
         sampAddChatMessage("Введи айди игрока: {FFFFFF}/pursuit [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
            sampSendChat("/me положив руки на клавиатуру бортового компьютера, начал поиск по базе данных по имени")
            wait(1500)
            sampSendChat("/me найдя имя, проверил номер телефона и включил отслеживания по ГПС")
            wait(1500)
            sampSendChat("/pursuit "..id.." ")
        end)
     end
  end

function cmd_drugtestno()
lua_thread.create(function()
            sampSendChat("/me достал из подсумка набор Drug-test")
            wait(1500)
            sampSendChat("/me взял из набора пробирку с этиловым спиртом")
            wait(1500)
            sampSendChat("/me насыпал в пробирку найденое вещество")
            wait(1500)
            sampSendChat ("/me добавил в пробирку тест Имуно-Хром-10")
            wait(1700)
            sampSendChat("/me резкими движениями взбалтывает пробирку")
            wait(1700)
            sampSendChat("/do Тест дал отрицательный результат, вещество не является наркотиком.")
        end)
     end


function cmd_drugtestyes()
lua_thread.create(function()
            sampSendChat("/me достал из подсумка набор Drug-test")
            wait(1500)
            sampSendChat("/me взял из набора пробирку с этиловым спиртом")
            wait(1500)
            sampSendChat("/me насыпал в пробирку найденое вещество")
            wait(1500)
            sampSendChat ("/me добавил в пробирку тест Имуно-Хром-10")
            wait(1700)
            sampSendChat("/me резкими движениями взбалтывает пробирку")
            wait(1700)
            sampSendChat("/do Тест дал положительный результат, вещество является наркотиком.")
        end)
     end

function cmd_vzatka()
lua_thread.create(function()
         sampSendChat("/me смотрит на задержанного, достаёт с бардачка ручку и листочек.")
         wait(1500)
         sampSendChat("/me пишет на листочке сумму с шестью нулями, кидает на заднее сиденье.")
         wait(1500)
         sampSendChat("/do На листочке небрежно и коряво было написано: 5.000.000$.")
      end)
   end


function cmd_bomb()
lua_thread.create(function()
         sampSendChat("/do Перед человеком находится бомба, на бомбе заведен таймер.")
         wait(1500)
         sampSendChat("/do На бронежилете закреплена небольшая сумка сапёра.")
         wait(1500)
         sampSendChat("/me открыв сумку потянулся за специальным КПК для разминирования бомб")
         wait(1500)
         sampSendChat("/me достал КПК из сумки включил его, сфотографировал на него бомбу и таймер, ...")
         wait(1500)
         sampSendChat("/me ... после связавшись с диспетчером переслал сделанные снимки")
         wait(1500)
         sampSendChat("/do [Диспетчер]: - Мы получили снимки, тип бомбы PR-256, оглашаю порядок действий.")
         wait(1500)
         sampSendChat("/do [Диспетчер]: - К данному типу бомбы можно подключиться по сети, действуйте.")
         wait(1500)
         sampSendChat("/me нажал в КПК кнопку search for the nearest device, после чего КПК начал поиск")
         wait(1500)
         sampSendChat("/do КПК выдал устройство INNPR-256NNI.")
         wait(1500)
         sampSendChat("/me подключился к устройству, после доложил об этом диспетчеру")
         wait(1500)
         sampSendChat("/do [Диспетчер]: - Да, вы подключились, теперь введите код 1-0-5-J-J-Q-G-2-2.")
         wait(1500)
         sampSendChat("/me начал вводить код названный диспетчером")
         wait(1500)
         sampSendChat("/do Таймер на бомбе остановился.")
         wait(1500)
         sampSendChat("/todo Получилось.*говоря по рации с диспетчером")
         wait(1500)
         sampSendChat("/do [Диспетчер]: - Ваша миссия завершена, везите бомбу в Офис, конец связи.")
      end)
   end


function cmd_probiv()
lua_thread.create(function()
         sampSendChat("/do На поясе висит личный КПК сотрудника.")
         wait(1500)
         sampSendChat("/me снял с пояса КПК , начал пробивать человека...")
         wait(1500)
         sampSendChat("/me ... по его лицу, ID-карте , бейджику и жетону")
         wait(1500)
         sampSendChat("/do На экране КПК высветилась вся информация о человеке.")
      end)
   end

function cmd_dismiss(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
   sampSendChat('/dismiss '..arg1..' '..arg2..'')
   wait(1500)
   sampSendChat("/do В правом кармане брюк находится КПК.")
   wait (1500)
   sampSendChat("/me достал КПК из правого кармана, затем начал пробивать по базе данных сотрудника через лицо, ID карту и жетон")
   wait(1500)
   sampSendChat("/do На экране КПК появилась полная информация о сотруднике.")
   wait(1500)
   sampSendChat("/me нажал на кнопку Уволить из Гос. Организации")
   wait(1500)
   sampSendChat ("/do Сотрудник был удален из списка 'Гос. Сотрудники'.")
   wait(1500)
   sampSendChat("/me убрал КПК обратно в правый карман")
    else
  sampAddChatMessage("Введи айди игрока:{FFFFFF} /dismiss [ID] [Причина].",0x318CE7FF -1)
  end
 end)
end

function cmd_demoute(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
        sampSendChat('/demoute '..arg1..' '..arg2..'')
         wait(1500)
        sampSendChat("/do КПК лежит в нагрудном кармане.")
         wait(1500)
         sampSendChat("/me нырнул рукой в правый карман, после чего достал КПК")
         wait(1500)
         sampSendChat("/me открыл в КПК базу данных сотрудников Госсударственных структур, после чего нажал на кнопку Demoute")
         wait(1500)
         sampSendChat("/do Сотрудник успешно удален из базы данных госсударственных структур")
    else
  sampAddChatMessage("Введи айди игрока:{FFFFFF} /demoute [ID] [Причина].",0x318CE7FF -1)
  end
 end)
end

function cmd_cure(id)
    if id == "" then
             sampAddChatMessage("Введи айди игрока: {FFFFFF}/cure [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
             sampSendChat("/do В специальном подсумке на форме лежат: стерильные шприцы и ампула с адреналином.")
             wait(1200)
             sampSendChat("/me достал стерильный шприц с ампулой, аккуратно приоткрыл ампулу с адреналином")
             wait(1200)
             sampSendChat("/me набрал содержимое ампулы в шприц")
             wait(1200)
             sampSendChat("/me закатал рукав пострадавшего, после чего ввёл адреналин через шприц в вену, вдавив поршень")
             wait(1200)
             sampSendChat("/do Адреналин проник в организм пострадавшего.")
             wait(1200)
             sampSendChat("/me убрал использованный шприц в специальный подсумок")
             wait(1200)
             sampSendChat("/cure "..id.." ")
         end)
      end
   end


function cmd_find(id)
    if id == "" then
         sampAddChatMessage("Введи айди игрока: {FFFFFF}/find [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/do КПК в левом кармане.")
         wait(1500)
         sampSendChat("/me достал левой рукой КПК из кармана")
         wait(1500)
         sampSendChat("/do КПК в левой руке.")
         wait(1500)
         sampSendChat("/me включил КПК и зашел в базу данных Полиции")
         wait(1500)
         sampSendChat("/me открыл дело с данными преступника")
         wait(1500)
         sampSendChat("/do Данные преступника получены.")
         wait(1500)
         sampSendChat("/me подключился к камерам слежения штата")
         wait(1500)
         sampSendChat ("/do На навигаторе появился маршрут.")
         wait(1500)
         sampSendChat("/find "..id.." ")
      end)
   end
end

function cmd_zsu(arg)
lua_thread.create(function()
    local arg1, arg2, arg3 = arg:match('(.+) (.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
        sampSendChat('/r Запрашиваю обьявление в розыск дело N-'..arg1..'.')
		wait(2500)
		sampSendChat('/r По причине - ' ..arg3..'. '..arg2..' Степень.')
    else
		sampAddChatMessage("Введи айди игрока: {FFFFFF}/zsu [ID] [Кол-во розыска] [Причина].",0x318CE7FF -1)
		end
	end)
end

function cmd_incar(arg)
lua_thread.create(function()
    local arg1, arg2 = arg:match('(.+) (.+)')
    if arg1 ~= nil and arg2 ~= nil then
        sampSendChat('/incar '..arg1..' '..arg2..'')
        wait(1500)
        sampSendChat('/do Двери в машине закрыты.')
        wait(1500)
  sampSendChat('/me открыл заднюю дверь в машине')
  wait(1500)
  sampSendChat('/me посадил преступника в машину')
  wait(1500)
  sampSendChat('/me заблокировал двери')
  wait(1500)
  sampSendChat('/do Двери заблокированы.')
   else
  sampAddChatMessage("Введи айди игрока:{FFFFFF}/incar [ID] [Место 1-4].",0x318CE7FF -1)
  end
 end)
end

function cmd_stop(id)
    lua_thread.create(function()
        sampSendChat("/do Мегафон в бардачке.")
        wait(1500)
        sampSendChat("/me достал мегафон с бардачка после чего включил его")
        wait(1500)
        sampSendChat("/m Гражданин прижмитесь к обочине!")
    end)
end

function cmd_eject(id)
    if id == "" then
        sampAddChatMessage("Введи айди игрока:: {FFFFFF}/eject [ID].",0x318CE7FF -1)
    else
        lua_thread.create(function()
            sampSendChat("/me открыл дверь авто, после выбросил человека из авто")
            wait(1500)
            sampSendChat("/eject "..id.." ")
            wait(1500)
            sampSendChat("/me закрыл дверь авто")
      end)
   end
end

function cmd_pog(id)
    if id == "" then
         sampAddChatMessage("Введи айди игрока: {FFFFFF}/pog [ID].", 0x318CE7FF - 1)
    else
        lua_thread.create(function()
         sampSendChat("/m Водитель, остановите транспортное средство, заглушите двигатель...")
         wait(1500)
         sampSendChat("/m Иначе я открою огонь по вашему транспорту!")
      end)
   end
end

function cmd_tencodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Список активных тен-кодов MVD HELPER 4.7", "10-1 - Встреча всех офицеров на дежурстве (включая локацию и код).\n10-3 - Радиомолчание (для срочных сообщений).\n10-4 - Принято.\n10-5 - Повторите последнее сообщение.\n10-6 - Не принято/неверно/нет.\n10-7 - Ожидайте.\n10-8 - В настоящее время занят/не доступен.\n10-14 - Запрос транспортировки (включая локацию и цель транспортировки).\n10-15 - Подозреваемые арестованы (включая кол-во подозреваемых, локацию).\n10-18 - Требуется поддержка дополнительных юнитов.\n10-20 - Локация.\n10-21 - Сообщение о статусе и местонахождении, описание ситуации.\n10-22 - Направляйтесь в 'локация' (обращение к конкретному офицеру).\n10-27 - Меняю маркировку патруля (включая старую и новую маркировку).\n10-46 - Провожу обыск.\n10-55 - Траффик стоп.\n10-66 - Остановка повышенного риска (если известно, что подозреваемый в авто вооружен/совершил преступление. Если остановка произошла после погони).\n10-88 - Теракт/ЧС.\n10-99 - Ситуация урегулирована\n10-100 Временно недоступен для вызовов\nАвтор:t.me/Sashe4ka_ReZoN", "Закрыть", "Exit", 0)
        end)
        end

function cmd_marks(id)
        lua_thread.create(function()
        sampShowDialog(1,"Маркировки на авто MVD HELPER 4.7", "ADAM [A] Маркировка юнита, состоящего из двух офицеров.\nLINCOLN [L] Маркировка юнита, состоящего из одного офицера.\nAIR [AIR] Маркировка воздушного юнита, в составе двух офицеров\nAir Support Division [ASD] Маркировка юнита воздушной поддержки.\nMARY [M] Маркировка мото-патруля.\nHENRY [H] Маркировка высоко - скоростного юнита, состоящего из одного или двух офицер.\nCHARLIE [C] Маркировка группы захвата.\nROBERT [R] Маркировка отдела детективов.\nSUPERVISOR [SV] Маркировка руководящего состава (STAFF).\nDavid [D] Маркировка спец.отдела\nКаждый офицер при выходе в патруль, обязан поставить маркировку на свой крузер (/vdesc)\nАвтор:t.me/Sashe4ka_ReZoN", "Закрыть", "Exit", 0)
         end)
         end

function cmd_sitcodes(id)
        lua_thread.create(function()
        sampShowDialog(1,"Ситуационные коды MVD HELPER 4.7", "CODE 0 - Офицер ранен.\nCODE 1 - Офицер в бедственном положении.\nCODE 2 - Обычный вызов с низким приоритетом. Без включения сирен и спец.сигналов, соблюдая ПДД.\nCODE 2 HIGH - Приоритетный вызов. Всё так же без включения сирен и спец.сигналов, соблюдая ПДД.\nCODE 3 - Срочный вызов. Использование сирен и спец.сигналов, игнорирование некоторых пунктов ПДД.\nCODE 4 - Помощь не требуется.\nCODE 4 ADAM - Помощь не требуется в данный момент времени. Офицеры находящиеся по близости должны быть готовы оказать помощь.\nCODE 7 - Перерыв на обед.\nCODE 30 - Срабатывание 'тихой' сигнализации на месте происшествия.\nCODE 30 RINGER - Срабатывание 'громкой' сигнализации на месте происшествия.\nCODE 37 - Обнаружение угнанного транспортного средства. Необходимо указать номер, описание автомобиля, направление движения.\nАвтор:t.me/Sashe4ka_ReZoN", "Закрыть", "Exit", 0)
         end)
         end

function cmd_pas(arg)
 lua_thread.create(function()
  if tonumber(arg) == nil then
  sampAddChatMessage("Введи айди игрока : {FFFFFF}/pas [ID].", 0x318CE7FF -1)
  else
  id = arg
  sampSendChat('Здравствуйте, надеюсь вас не беспокою.')
  wait(1500)
  sampSendChat('/do Слева на груди жетон полицейского, справа - именная нашивка с фамилией.')
  wait(1500)
  sampSendChat('/showbadge '..id)
  wait(1500)
  sampSendChat('Прошу предьявить документ удостоверяющий вашу личность.')
  end
 end)
end

function cmd_clear(arg)
  if tonumber(arg) == nil then
   sampAddChatMessage("Введи айди игрока: {FFFFFF} /clear [ID].", 0x318CE7FF -1)
  else
  lua_thread.create(function()
  id = arg
  sampSendChat("/me нажав на тангенту, сообщил диспетчеру имя человека, который более не числился в розыске")
  wait(1500)
  sampSendChat('/clear '..id)
  end)
 end
end

function cmd_take(id)
    if id == "" then
             sampAddChatMessage("Введи айди игрока: {FFFFFF}/take [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
             sampSendChat("/do На руках оперативника надеты резиновые перчатки.")
             wait(1500)
             sampSendChat("/me после обыска изъял запрещённые вещи")
             wait(1500)
             sampSendChat("/do Пакетик для улик в кармане.")
             wait(1500)
             sampSendChat("/me достал пакетик для улик, после чего положил туда запрещённые вещи")
             wait(1500)
             sampSendChat("/me положил пакет с уликами в кармашек")
             wait(1500)
             sampSendChat("/do Пакет с уликами в кармане.")
             wait(1500)
             sampSendChat("/take "..id.." ")
         end)
      end
   end

function cmd_pravda_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do В допросной стоял шкафчик, он был закрыт на электронный замок.")
		wait(1500)
		sampSendChat("/me подошел к шкафчику, набрал код, открыв шкафчик взял от туда не прозрачную черную папку.")
		wait(1500)
		sampSendChat("/me подошел к столу, положил папку на него, открыв ее взял готовый лист формата A4 со штампами.")
		wait(1500)
		sampSendChat("/me положил перед задержанным, положил рядом ручку.")
		wait(1500)
		sampSendChat("/do Рядом лежал образец.")
		wait(1500)
		sampSendChat("/do В образце написано: 'Я Имя/Фамилия/Дата рождения' ")
		wait(1500)
		sampSendChat("/do 'Я несу полную ответственность за информацию которую я произнес при допросе…")
		wait(1500)
		sampSendChat("/do …в случае неподтверждения моих слов я готов нести уголовную ответственность.' ")
		wait(1500)
		sampSendChat("Заполняешь на чистом как по образцу, ниже ставишь подпись и дату.")
	end)
end

function cmd_secret_fbi(id)
	lua_thread.create(function ()
		sampSendChat("/do На столе лежит документ: \"Документ о неразглашении деятельности ФБР\"")
		wait(1500)
		sampSendChat("/do Рядом с документом аккуратно расположена ручка с золотой гравировкой \"ФБР\"")
		wait(1500)
		sampSendChat("/do В документе написано: \"Я, (Имя / Фамилия), клянусь держать втайне то, ...")
		wait(1500)
		sampSendChat("/do ... что видел, вижу, и буду видеть\"")
		wait(1500)
		sampSendChat("/do Ниже написано: \"Готов нести полную ответственность, и в случае своего неповиновения, ...")
		wait(1500)
		sampSendChat("/do ... готов быть арестованным и отстраненным от должности, при наличии таковой\"")
		wait(1500)
		sampSendChat("/do Еще ниже написано: \"Дата: ; Подпись: \"")
	end)
end

function cmd_traf(id)
    if id == "" then
             sampAddChatMessage("Введи айди игрока: {FFFFFF}/traf [ID].", 0x318CE7FF)
    else
        lua_thread.create(function()
            sampSendChat("/do Мегафон в бардачке.")
            wait(1200)
            sampSendChat("/me достаёт мегафон с бардачка после чего включает его")
            wait(1200)
            sampSendChat("/m Водитель авто остановитесь на обочине и заглушите двигатель, держите руки на руле.")
            wait(1200)
            sampSendChat("/me убирает мегафон в бардачок")
        end)
    end
end

function cmd_time()
    lua_thread.create(function()
    sampSendChat("/me поднял руку и посмотрел на часы бренда  Rolex")
    wait(1500)
    sampSendChat("/time")
    sampSendChat('/do На часах '..os.date('%H:%M:%S'))
    end)
end

function cmd_finger_person(id)
	lua_thread.create(function ()
		sampSendChat("/do За спиной агента находится небольшая спец. сумка.")
		wait(1500)
		sampSendChat("/me снял спец. сумку со спины, после положил её на ровную поверхность")
		wait(1500)
		sampSendChat("/do В спец. сумке имеется: пудра и кисточка для её нанесения, спец. плёнка.")
		wait(1500)
		sampSendChat("/me взял баночку с пудрой, открыв её аккуратно наносит пудру на пальцы человека напротив")
		wait(1500)
		sampSendChat("/do Пальцы человека напротив покрыты пудрой.")
		wait(1500)
		sampSendChat("/me достал из спец. сумки специальную плёнку, затем приклеивает её на пальцы человеку")
		wait(1500)
		sampSendChat("/do Отпечаток фиксируется на плёнке.")
		wait(1500)
		sampSendChat("/me аккуратно сняв плёнку с пальцев человека, помещает ее в спец. пакетик")
		wait(1500)
		sampSendChat("/do В спец. пакетике находится плёнка с пальцев человека.")
		wait(1500)
		sampSendChat("/me положил спец. пакетик в задний карман брюк, берёт в руки баночку с пудрой ...")
		wait(1500)
		sampSendChat("/me ... и кисточку, убирает их в спец. сумку, после закрывает её")
		wait(1500)
		sampSendChat("/do Спец. пакетик лежит в заднем кармане брюк, спец. сумка закрыта.")
	end)
end

function cmd_warn()
	lua_thread.create(function ()
		sampSendChat("/r  Мне требуется подмога. Найдите меня по жучку  ")
	end)
end

function cmd_grim()
    lua_thread.create(function ()
    sampSendChat("/do В шкафчике стоит набор для профессионального грима.")
    wait(1500)
    sampSendChat("/me открыл шкафчик и достав из него набор для грима, поставил его на шкафчик и открыл")
    wait(1500)
    sampSendChat("/do Набор для грима открыт.")
    wait(1500)
    sampSendChat("/do Над шкафчиком весит зеркало.")
    wait(1500)
    sampSendChat("/me рассматривая набор, взял большую кисть и окунув её в тёмный цвет, начал наносить его на лицо, смотря в зеркало")
    wait(1500)
    sampSendChat("/me взяв тонкую кисточку, окунул её в румян и начал наносить на лицо")
   wait(1500)
   sampSendChat("/me нарисовав на лице скулы, окунул кисточку в тёмную тень и нанёс их на лицо")
   wait(1500)
   sampSendChat("/me взял кисть и окунув её в тёмную пудру и нанёс её на лицо")
   wait(1500)
   sampSendChat("/me положил кисти в отсек для инструментов и закрыл набор")
   wait(1500)
   sampSendChat("/me убрал набор в шкафчик и закрыл его")
   wait(1500)
   sampSendChat("/do На лице нанесён грим.")
       end)
end

function cmd_eks()
    lua_thread.create(function ()
    sampSendChat ("/do В кармане пиджака лежат резиновые перчатки.")
wait(1500)
sampSendChat ("/me правой рукой достал из кармана перчатки и надел их на кисти рук")
wait(1500)
sampSendChat("/do На столе лежит оружие, полоска и лист белой бумаги, две стойки с пробирками.")
wait(1500)
sampSendChat("/me осмотрел оружие и аккуратно разобрал его на отдельные части")
wait(1500)
sampSendChat("/me взял в руки затвор и полоску бумаги, поместил полоску в задний срез патронника")
wait(1500)
sampSendChat("/me убрал полоску бумаги из затвора")
wait(1500)
sampSendChat("/do На полоске бумаги остались следы нагара от не сгоревшего пороха.")
wait(1500)
sampSendChat("/me вытряхнул частицы с полоски на лист бумаги")
wait(1500)
sampSendChat("/me взял пробирку со стойки и пересыпал содержимое с листа в пробирку")
wait(1500)
sampSendChat("/me закрыл пробирку и поставил на другую стойку")
wait(1500)
sampSendChat("/me взял в руки крышку ствольной коробки и просмотрел серийный номер оружия")
wait(1500)
sampSendChat("/me включил компьютер и открыл базу данных, в поисковую строку ввёл номер оружия")
wait(1500)
sampSendChat("/do На экране высветилась информация об оружии и владельце.")
wait(1500)
sampSendChat("/me положил крышку ствольной коробки обратно на стол")
wait(1500)
sampSendChat("/me собрал оружие в целое, достал из ящика прозрачный спец.пакет и поместил в него оружие")
wait(1500)
sampSendChat("/me взял со стола фломастер и пометил им спец.пакет, убрал фломастер в ящик и закрыл его")
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
        imgui.Begin(u8"Выдача розыска", windowTwo)
        imgui.InputInt(u8 'ID игрока с которым будете взаимодействовать', id,10)
        for i = 1, #tableUk["Text"] do
            if imgui.Button(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i])) then
                lua_thread.create(function()
                    sampSendChat("/do Рация висит на бронежелете.")
                    wait(1500)
                    sampSendChat("/me сорвав с грудного держателя рацию, сообщил данные о сапекте")
                    wait(1500)
                    sampSendChat("/su " .. id[0] .. " " .. tableUk["Ur"][i] .. " " .. tableUk["Text"][i])
                    wait(1500)
                    sampSendChat("/do Спустя время диспетчер объявил сапекта в федеральный розыск.")
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
        imgui.Begin(u8"Панель лидера/заместителя", leaderPanel)
        imgui.InputInt(u8'ID игрока с которым хотите взаимодействовать', id, 10)
        if imgui.Button(u8'Уволить сотрудника') then
            lua_thread.create(function ()
                sampSendChat("/do КПК весит на поясе.")
                wait(1500)
                sampSendChat("/me снял КПК с пояса и зашел в программу управления")
                wait(1500)
                sampSendChat("/me нашел в списке сотрудника и нажал на кнопку Уволить")
                wait(1500)
                sampSendChat("/do На КПК высветилась надпись 'Сотрудник успешно уволен!'")
                wait(1500)
                sampSendChat("/me выключил КПК и повесил обратно на пояс")
                wait(1500)
                sampSendChat("Ну что ж, вы уволенны. Оставьте погоны в моем кабинете.")
                wait(1500)
                sampSendChat("/uninvite".. id[0])
            end)
        end

        if imgui.Button(u8'Принять гражданина') then
            lua_thread.create(function ()
                sampSendChat("/do КПК весит на поясе.")
                wait(1500)
                sampSendChat("/me снял КПК с пояса и зашел в программу управления")
                wait(1500)
                sampSendChat("/me зашел в таблицу и ввел данные о новом сотруднике")
                wait(1500)
                sampSendChat("/do На КПК высветилась надпись: 'Сотрудник успешно добавлен! Пожелайте ему хорошей службы :)'")
                wait(1500)
                sampSendChat("/me выключил КПК и повесил обратно на пояс")
                wait(1500)
                sampSendChat("Поздровляю, вы приняты! Форму возьмете в раздевалке.")
                wait(1500)
                sampSendChat("/invite".. id[0])
            end)
        end

        if imgui.Button(u8'Выдать выговор сотруднику') then
            lua_thread.create(function ()
                sampSendChat("/do КПК весит на поясе.")
                wait(1500)
                sampSendChat("/me снял КПК с пояса и зашел в программу управления")
                wait(1500)
                sampSendChat("/me нашел в списке сотрудника и нажал на кнопку Выдать выговор")
                wait(1500)
                sampSendChat("/do На КПК высветилась надпись: 'Выговор выдан!'")
                wait(1500)
                sampSendChat("/me выключил КПК и повесил обратно на пояс")
                wait(1500)
                sampSendChat("Ну что ж, выговор выдан. Отрабатывайте.")
                wait(1500)
                sampSendChat("/fwarn".. id[0])
            end)
        end

        if imgui.Button(u8'Снять выговор сотруднику') then
            lua_thread.create(function ()
                sampSendChat("/do КПК весит на поясе.")
                wait(1500)
                sampSendChat("/me снял КПК с пояса и зашел в программу управления")
                wait(1500)
                sampSendChat("/me нашел в списке сотрудника и нажал на кнопку Снять выговор")
                wait(1500)
                sampSendChat("/do На КПК высветилась надпись: 'Выговор снят!'")
                wait(1500)
                sampSendChat("/me выключил КПК и повесил обратно на пояс")
                wait(1500)
                sampSendChat("Ну что ж, отработали.")
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
        imgui.Begin(u8"Настройка умного розыска", setUkWindow)
            if imgui.BeginChild('Name', imgui.ImVec2(700, 500), true) then
                for i = 1, #tableUk["Text"] do
                    imgui.Text(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i]))
                    Uk = #tableUk["Text"]
                end
                imgui.EndChild()
            end
            if imgui.Button(u8'Добавить', imgui.ImVec2(500, 36)) then
                addUkWindow[0] = not addUkWindow[0]
            end
            if imgui.Button(u8'Удалить', imgui.ImVec2(500, 36)) then
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
        imgui.Begin(u8"Настройка умного розыска", addUkWindow)
            imgui.InputText(u8'Текст статьи(с номером.)', newUkInput, 255)
            newUkName = u8:decode(ffi.string(newUkInput))
            imgui.InputInt(u8'Уровень розыска(только цифра)', newUkUr, 10)
            if imgui.Button(u8'Сохранить') then
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
        {"Загородный клуб «Ависпа»", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Международный аэропорт Истер-Бэй", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Загородный клуб «Ависпа»", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Международный аэропорт Истер-Бэй", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Гарсия", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Шейди-Кэбин", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"Восточный Лос-Сантос", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"Грузовое депо Лас-Вентураса", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Пересечение Блэкфилд", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Загородный клуб «Ависпа»", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Темпл", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Станция «Юнити»", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"Грузовое депо Лас-Вентураса", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Лос-Флорес", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Казино «Морская звезда»", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Химзавод Истер-Бэй", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Деловой район", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Восточная Эспаланда", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Станция «Маркет»", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Станция «Линден»", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Пересечение Монтгомери", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Мост «Фредерик»", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Станция «Йеллоу-Белл»", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Деловой район", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Джефферсон", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Малхолланд", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Загородный клуб «Ависпа»", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Джефферсон", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Западаная автострада Джулиус", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Джефферсон", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Северная автострада Джулиус", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Родео", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Станция «Крэнберри»", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Деловой район", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Западный Рэдсэндс", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Маленькая Мексика", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Пересечение Блэкфилд", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Международный аэропорт Лос-Сантос", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Бекон-Хилл", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Родео", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Ричман", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Деловой район", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"Стрип", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Деловой район", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Пересечение Блэкфилд", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Конференц Центр", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Монтгомери", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Долина Фостер", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"Часовня Блэкфилд", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Международный аэропорт Лос-Сантос", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Малхолланд", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Поле для гольфа «Йеллоу-Белл»", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"Стрип", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Джефферсон", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Малхолланд", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Альдеа-Мальвада", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Лас-Колинас", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Лас-Колинас", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Ричман", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"Грузовое депо Лас-Вентураса", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Северная автострада Джулиус", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Уиллоуфилд", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Северная автострада Джулиус", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Темпл", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Маленькая Мексика", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Квинс", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Аэропорт Лас-Вентурас", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Ричман", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Темпл", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"Восточный Лос-Сантос", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Восточная автострада Джулиус", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Уиллоуфилд", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Лас-Колинас", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Восточная автострада Джулиус", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Родео", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Лас-Брухас", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Восточная автострада Джулиус", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Родео", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Вайнвуд", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Родео", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Северная автострада Джулиус", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Деловой район", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Родео", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Джефферсон", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Хэмптон-Барнс", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Темпл", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Мост «Кинкейд»", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Пляж «Верона»", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Коммерческий район", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Малхолланд", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Родео", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Малхолланд", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Малхолланд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Южная автострада Джулиус", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Айдлвуд", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Океанские доки", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Коммерческий район", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Северная автострада Джулиус", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Темпл", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Глен Парк", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Международный аэропорт Истер-Бэй", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Мост «Мартин»", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"Стрип", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Уиллоуфилд", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Марина", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Аэропорт Лас-Вентурас", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Айдлвуд", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Восточная Эспаланда", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Деловой район", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"Мост «Мако»", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Родео", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Площадь «Першинг»", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Малхолланд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Мост «Гант»", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Лас-Колинас", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Малхолланд", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Северная автострада Джулиус", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Коммерческий район", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Родео", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Рока-Эскаланте", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Родео", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Маркет", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Лас-Колинас", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Малхолланд", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"Кингс", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Восточный Рэдсэндс", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Деловой район", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Конференц Центр", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Ричман", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Оушен-Флэтс", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Колледж Грингласс", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Глен Парк", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"Грузовое депо Лас-Вентураса", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Регьюлар-Том", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Пляж «Верона»", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"Восточный Лос-Сантос", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Дворец Калигулы", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Айдлвуд", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Пилигрим", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Айдлвуд", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Квинс", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Деловой район", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Коммерческий район", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"Восточный Лос-Сантос", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Марина", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Ричман", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Вайнвуд", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"Восточный Лос-Сантос", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Родео", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Истерский Тоннель", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Родео", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Восточный Рэдсэндс", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"Казино «Карман клоуна»", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Айдлвуд", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Пересечение Монтгомери", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Уиллоуфилд", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Темпл", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Прикл-Пайн", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Международный аэропорт Лос-Сантос", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Мост «Гарвер»", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Мост «Гарвер»", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Мост «Кинкейд»", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Мост «Кинкейд»", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Пляж «Верона»", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Обсерватория «Зелёный утёс»", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Вайнвуд", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Вайнвуд", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Коммерческий район", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Маркет", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Западный Рокшор", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Северная автострада Джулиус", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"Восточный пляж", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Мост «Фаллоу»", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Уиллоуфилд", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"Чайнатаун", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"Эль-Кастильо-дель-Дьябло", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Океанские доки", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Химзавод Истер-Бэй", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"Казино «Визаж»", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Оушен-Флэтс", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Ричман", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Нефтяной комплекс «Зеленый оазис»", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Ричман", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Казино «Морская звезда»", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"Восточный пляж", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Джефферсон", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Деловой район", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Деловой район", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Мост «Гарвер»", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Южная автострада Джулиус", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"Восточный Лос-Сантос", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Колледж «Грингласс»", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Лас-Колинас", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Малхолланд", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Океанские доки", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"Восточный Лос-Сантос", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Гантон", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Загородный клуб «Ависпа»", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Уиллоуфилд", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Северная Эспланада", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"Казино «Хай-Роллер»", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Океанские доки", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Мотель «Последний цент»", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Бэйсайнд-Марина", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"Кингс", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"Эль-Корона", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"Часовня Блэкфилд", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"«Розовый лебедь»", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Западаная автострада Джулиус", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Лос-Флорес", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"Казино «Визаж»", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Прикл-Пайн", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Пляж «Верона»", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Пересечение Робада", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Линден-Сайд", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Океанские доки", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Уиллоуфилд", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"Кингс", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Коммерческий район", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Малхолланд", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Марина", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Бэттери-Пойнт", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"Казино «4 Дракона»", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Блэкфилд", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Северная автострада Джулиус", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Поле для гольфа «Йеллоу-Белл»", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Айдлвуд", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Западный Рэдсэндс", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Доэрти", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Ферма Хиллтоп", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Лас-Барранкас", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Казино «Пираты в мужских штанах»", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"Сити Холл", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Загородный клуб «Ависпа»", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"Стрип", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Хашбери", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Международный аэропорт Лос-Сантос", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Уайтвуд-Истейтс", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Водохранилище Шермана", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"Эль-Корона", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Деловой район", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Долина Фостер", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Лас-Паясадас", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Долина Окультадо", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Пересечение Блэкфилд", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Гантон", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Международный аэропорт Истер-Бэй", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Восточный Рэдсэндс", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Восточная Эспаланда", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Дворец Калигулы", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Казино «Рояль»", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Ричман", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Казино «Морская звезда»", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Малхолланд", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Деловой район", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Ханки-Панки-Пойнт", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"Военный склад топлива К.А.С.С.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Автострада «Гарри-Голд»", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Тоннель Бэйсайд", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Океанские доки", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Ричман", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Промсклад имени Рэндольфа", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"Восточный пляж", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Флинт-Уотер", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Блуберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Станция «Линден»", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Глен Парк", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Деловой район", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Западный Рэдсэндс", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Ричман", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Мост «Гант»", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Бар «Probe Inn»", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Пересечение Флинт", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Лас-Колинас", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Собелл-Рейл-Ярдс", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"Изумрудный остров", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"Эль-Кастильо-дель-Дьябло", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Санта-Флора", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Плайя-дель-Севиль", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Маркет", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Квинс", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Пересечение Пилсон", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Спинибед", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Пилигрим", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Блэкфилд", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"«Большое ухо»", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Диллимор", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"Эль-Кебрадос", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Северная Эспланада", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Международный аэропорт Истер-Бэй", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Рыбацкая лагуна", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Малхолланд", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"Восточный пляж", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"Сан-Андреас Саунд", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Тенистые ручьи", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Маркет", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Западный Рокшор", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Прикл-Пайн", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"«Бухта Пасхи»", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Лифи-Холлоу", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"Грузовое депо Лас-Вентураса", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Прикл-Пайн", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Блуберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"Эль-Кастильо-дель-Дьябло", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Деловой район", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Восточный Рокшор", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"Залив Сан-Фиерро", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Парадизо", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"Казино «Носок верблюда»", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Олд-Вентурас-Стрип", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Джанипер-Хилл", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Джанипер-Холлоу", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Рока-Эскаланте", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Восточная автострада Джулиус", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Пляж «Верона»", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Долина Фостер", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Арко-дель-Оэсте", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"«Упавшее дерево»", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"Ферма", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"Дамба Шермана", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Северная Эспланада", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Финансовый район", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Гарсия", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Монтгомери", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Крик", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Международный аэропорт Лос-Сантос", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Пляж «Санта-Мария»", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Пересечение Малхолланд", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Эйнджел-Пайн", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Вёрдант-Медоус", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Октан-Спрингс", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Казино Кам-э-Лот", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Западный Рэдсэндс", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Пляж «Санта-Мария»", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Обсерватория «Зелёный утёс", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Аэропорт Лас-Вентурас", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Округ Флинт", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Обсерватория «Зелёный утёс", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Паломино Крик", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Океанские доки", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Международный аэропорт Истер-Бэй", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Уайтвуд-Истейтс", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Калтон-Хайтс", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"«Бухта Пасхи»", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Залив Лос-Сантос", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Доэрти", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Гора Чилиад", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Форт-Карсон", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Долина Фостер", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Оушен-Флэтс", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Ферн-Ридж", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Бэйсайд", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Аэропорт Лас-Вентурас", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Поместье Блуберри", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Пэлисейдс", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"Норт-Рок", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Карьер «Хантер»", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Международный аэропорт Лос-Сантос", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Миссионер-Хилл", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"Залив Сан-Фиерро", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Запретная Зона", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Гора «Чилиад»", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Гора «Чилиад»", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Международный аэропорт Истер-Бэй", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"Паноптикум", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Тенистые ручьи", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Бэк-о-Бейонд", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Гора «Чилиад»", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Тьерра Робада", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Округ Флинт", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Уэтстоун", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Пустынный округ", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Тьерра Робада", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"Сан Фиерро", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Лас Вентурас", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Туманный округ", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Лос Сантос", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Пригород'
end

local suppWindowFrame = imgui.OnFrame(
    function() return suppWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Вспомогательное окошко", suppWindow, imgui.WindowFlags.NoTitleBar)

			imgui.Text(u8'Время: '..os.date('%H:%M:%S'))
            imgui.Text(u8'Месяц: '..os.date('%B'))
			imgui.Text(u8'Полная дата: '..arr.day..'.'.. arr.month..'.'..arr.year)
        	local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
			imgui.Text(u8'Район:' .. u8(calculateZone(positionX, positionY, positionZ)))
			local p_city = getCityPlayerIsIn(PLAYER_PED)
			if p_city == 1 then pCity = u8'Лос - Сантос' end
			if p_city == 2 then pCity = u8'Сан - Фиерро' end
			if p_city == 3 then pCity = u8'Лас - Вентурас' end
			if getActiveInterior() ~= 0 then pCity = u8'Вы находитесь в интерьере!' end
			imgui.Text(u8'Город: ' .. pCity)
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
