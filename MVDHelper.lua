---@diagnostic disable: need-check-nil, lowercase-global

script_name("MVD Helper Mobile")

script_version("5.6")
script_authors("@Sashe4ka_ReZoN", "@daniel29032012", "@makson4ck2", "@osp_x")

--Áèáëèîòåêè
require('moonloader')
local copas            = require("copas")
local http             = require('copas.http')
local encoding         = require 'encoding'
local requests         = require('requests')
local imgui            = require('mimgui')
local inicfg           = require("inicfg")
local faicons          = require('fAwesome6')
local fa               = require('fAwesome6_solid')
local sampev           = require('lib.samp.events')
local ffi              = require('ffi')
local monet            = require("MoonMonet")
local effil            = require('effil')
local md5              = require("md5")
local memory           = require("memory")
local cjson            = require("cjson")
--Êîäèðîâêà
encoding.default       = 'CP1251'
local u8               = encoding.UTF8
local new              = imgui.new

--Îêíà
local copMenu          = imgui.new.bool(true)
local fastVzaimWindow  = imgui.new.bool(false)
local vzaimWindow      = imgui.new.bool(false)
local megafon          = imgui.new.bool(false)
local logsWin          = imgui.new.bool(false)
local patroolhelpmenu  = imgui.new.bool(false)
local window           = imgui.new.bool(false)
local vzWindow         = imgui.new.bool(false)
local updateWin        = imgui.new.bool(false)
local NoteWindow       = imgui.new.bool(false)
local showEditWindow   = imgui.new.bool(false)
local showAddNotePopup = imgui.new.bool(false)
local menuSizes        = imgui.new.bool(false)
local gunsWindow       = imgui.new.bool(false)
local suppWindow       = imgui.new.bool(false)
local windowTwo        = imgui.new.bool(false)
local setUkWindow      = imgui.new.bool(false)
local addUkWindow      = imgui.new.bool(false)
local importUkWindow   = imgui.new.bool(false)
local binderWindow     = imgui.new.bool(false)
local leaderPanel      = imgui.new.bool(false)

--Êîíôèã
local mainIni = inicfg.load({
    Accent = {
        accent = '[Ìîëäàâñêèé àêöåíò]: '
    },
    Info = {
        org = u8 'Âû íå ñîñòîèòå â ÏÄ',
        dl = u8 'Âû íå ñîñòîèòå â ÏÄ',
        rang_n = 0
    },
    theme = {
        themeta = "standart",
        selected = 0,
        moonmonet = 759410733
    },
    settings = {
        autoRpGun = false,
        poziv = false,
        autoAccent = false,
        standartBinds = true,
        Jone = false,
        ObuchalName = "Ìàñòóðáåê",
        button = false,
        copMenu = false
    },
    statTimers = {
        state = false,
        clock = true,
        sesOnline = true,
        sesAfk = true,
        sesFull = true,
        dayOnline = true,
        dayAfk = true,
        dayFull = true,
        weekOnline = true,
        weekAfk = true,
        weekFull = true,
        server = nil
    },
    onDay = {
        today = os.date("%a"),
        online = 0,
        afk = 0,
        full = 0
    },
    onWeek = {
        week = 1,
        online = 0,
        afk = 0,
        full = 0
    },
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    },
    pos = {
        x = 0,
        y = 0
    },
    style = {
        round = 5.0,
        colorW = 4279834905,
        colorT = 4286677377,
    },
    menuSettings = {
        x = 680,
        y = 550,
        tab = 160,
        copPos = 25,
        snegPos = 80,
        xpos = 59,
        vtpos = 8,
        ChildRoundind = 10
    }
}, "mvdhelper.ini")
inicfg.save(mainIni, 'mvdhelper.ini')

--Îñòàëüíûå ïåðåìåííûå
local button_megafon  = imgui.new.bool(mainIni.settings.button or false)
local AI_PAGE         = {}
local menu2           = 2
local ToU32           = imgui.ColorConvertFloat4ToU32
local u32             = imgui.ColorConvertFloat4ToU32
local page            = 8
local helper_path     = script.this.path
local MDS             = MONET_DPI_SCALE or 1
local str             = ffi.string
local isPatrolActive  = false
local FrameTime       = imgui.new.int(10000)
local MyGif           = nil
local tochkaMe        = imgui.new.bool(false)
local path            = getWorkingDirectory() .. "/config/Binder.json"
local joneV           = imgui.new.bool(mainIni.settings.Jone)
local id              = imgui.new.int(0)
local otherorg        = imgui.new.char[256]()
local inputComName    = imgui.new.char(255)
local inputComText    = imgui.new.char(255)
local arr             = os.date("*t")
local newUkInput      = imgui.new.char(255)
local newUkUr         = imgui.new.int(0)
local spawn           = true
local autogun         = new.bool(mainIni.settings.autoRpGun)
local selected_theme  = imgui.new.int(mainIni.theme.selected)
local theme_a         = { u8 'Ñòàíäàðòíàÿ', 'MoonMonet' }
local theme_t         = { u8 'standart', 'moonmonet' }
local items           = imgui.new['const char*'][#theme_a](theme_a)
local AutoAccentBool  = new.bool(mainIni.settings.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org             = u8 'Âû íå ñîñòîèòå â ÏÄ'
local org_g           = u8 'Âû íå ñîñòîèòå â ÏÄ'
local dol             = 'Âû íå ñîñòîèòå â ÏÄ'
local dl              = u8 'Âû íå ñîñòîèòå â ÏÄ'
local rang_n          = 0
local notes           = {}
local newNoteTitle    = imgui.new.char[256]()
local newNoteContent  = imgui.new.char[1024]()
local editNoteTitle   = imgui.new.char[256]()
local editNoteContent = imgui.new.char[1024]()
local showNoteWindows = {}
local showEditWindows = {}
local note_name       = nil
local note_text       = nil
local logs            = {}
local dephistory      = {}
local orgname         = imgui.new.char[255]()
local departsettings  = {
    myorgname = new.char[255](u8 'nil'),
    toorgname = new.char[255](),
    frequency = new.char[255](),
    myorgtext = new.char[255](),
}
local serversList     = {
    "phoenix", "mobile i", "mobile ii", "mobile iii", "tucson", "saintrose", "mesa", "red-rock",
    "prescott", "winslow", "payson", "gilbert", "casa-grande", "page", "sun-city", "wednesday",
    "yava", "faraway", "bumble bee", "christmas", "brainburg", "sedona"
}
local changingInfo    = false
local orga            = imgui.new.char[255](u8(mainIni.Info.org))
local dolzh           = imgui.new.char[255](u8(mainIni.Info.dl))
local xsize           = imgui.new.int(mainIni.menuSettings.x)
local ysize           = imgui.new.int(mainIni.menuSettings.y)
local tabsize         = imgui.new.int(mainIni.menuSettings.tab)
local copPos          = imgui.new.int(mainIni.menuSettings.copPos)
local snegPos         = imgui.new.int(mainIni.menuSettings.snegPos)
local xpos            = imgui.new.int(mainIni.menuSettings.xpos)
local vtpos           = imgui.new.int(mainIni.menuSettings.vtpos)
local childRounding   = imgui.new.int(mainIni.menuSettings.ChildRoundind)
local spawncar_bool   = false
local jsonFile        = getWorkingDirectory() .. "/MVDHelper/gunCommands.json"
local weapons         = {
    "Äóáèíêà",
    "Ãðàíàòà",
    "Ñëåçîòî÷èâûé ãàç",
    "Òàéçåð",
    "Colt-45",
    "Desert Eagle",
    "Äðîáîâèê",
    "Îáðåçû",
    "Spas",
    "ÓÇÈ",
    "ÌÏ5",
    "AK-47",
    "Ì4",
    "TEC-9",
    "Âèíòîâêà",
    "Ñíàéïåðñêàÿ âèíòîâêà",
    "Ôîòîêàìåðà",
    "Áåç îðóæèÿ"
}
local gunCommands     = {
    "/me äîñòàë äóáèíêó ñ ïîÿñíîãî äåðæàòåëÿ",
    "/me âçÿë ñ ïîÿñà ãðàíàòó",
    "/me âçÿë ãðàíàòó ñëåçîòî÷èâîãî ãàçà ñ ïîÿñà",
    "/me äîñòàë òàéçåð ñ êîáóðû, óáðàë ïðåäîõðàíèòåëü",
    "/me äîñòàë ïèñòîëåò Colt-45, ñíÿë ïðåäîõðàíèòåëü",
    "/me äîñòàë Desert Eagle ñ êîáóðû, óáðàë ïðåäîõðàíèòåëü",
    "/me äîñòàë ÷åõîë ñî ñïèíû, âçÿë äðîáîâèê è óáðàë ïðåäîõðàíèòåëü",
    "/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë Îáðåçû",
    "/me äîñòàë äðîáîâèê Spas, ñíÿë ïðåäîõðàíèòåëü",
    "/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë ÓÇÈ",
    "/me äîñòàë ÷åõîë ñî ñïèíû, âçÿë ÌÏ5 è óáðàë ïðåäîõðàíèòåëü",
    "/me äîñòàë êàðàáèí AK-47 ñî ñïèíû",
    "/me äîñòàë êàðàáèí Ì4 ñî ñïèíû",
    "/me ðåçêèì äâèæåíèåì îáîèõ ðóê, ñíÿë âîåííûé ðþêçàê ñ ïëå÷ è äîñòàë TEC-9",
    "/me äîñòàë âèíòîâêó áåç ïðèöåëà èç âîåííîé ñóìêè",
    "/me äîñòàë Ñíàéïåðñêóþ âèíòîâêó ñ âîåííîé ñóìêè",
    "/me äîñòàë ôîòîêàìåðó èç ðþêçàêà",
    "/me ïîñòàâèë ïðåäîõðàíèòåëü, óáðàë îðóæèå"
}
local newButtonText   = imgui.new.char[255]()
local newButtonCommand= imgui.new.char[2555]()

--MOONMONET
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function ARGBtoRGB(color)
    return bit.band(color, 0xFFFFFF)
end

function rgb2hex(r, g, b)
    local hex = string.format("#%02X%02X%02X", r, g, b)
    return hex
end

function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = { a = a, r = r, g = g, b = b }
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

function msg(text, color)
    if not color then
        gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    else
        gen_color = monet.buildColors(color, 1.0, true)
    end 
    local curcolor1 = '0x' .. ('%X'):format(gen_color.accent1.color_300)
    sampAddChatMessage("[MVD Helper]: {FFFFFF}" .. text, curcolor1)
end

function isMonetLoader() return MONET_VERSION ~= nil end

--Ñïèñîê ñåðâåðîâ
local servers = {
    ["80.66.82.162"] = { number = -1, name = "Mobile I" },
    ["80.66.82.148"] = { number = -2, name = "Mobile II" },
    ["80.66.82.136"] = { number = -3, name = "Mobile III" },
    ["185.169.134.44"] = { number = 4, name = "Chandler" },
    ["185.169.134.43"] = { number = 3, name = "Scottdale" },
    ["185.169.134.45"] = { number = 5, name = "Brainburg" },
    ["185.169.134.5"] = { number = 6, name = "Saint-Rose" },
    ["185.169.132.107"] = { number = 6, name = "Saint-Rose" },
    ["185.169.134.59"] = { number = 7, name = "Mesa" },
    ["185.169.134.61"] = { number = 8, name = "Red-Rock" },
    ["185.169.134.107"] = { number = 9, name = "Yuma" },
    ["185.169.134.109"] = { number = 10, name = "Surprise" },
    ["185.169.134.166"] = { number = 11, name = "Prescott" },
    ["185.169.134.171"] = { number = 12, name = "Glendale" },
    ["185.169.134.172"] = { number = 13, name = "Kingman" },
    ["185.169.134.173"] = { number = 14, name = "Winslow" },
    ["185.169.134.174"] = { number = 15, name = "Payson" },
    ["80.66.82.191"] = { number = 16, name = "Gilbert" },
    ["80.66.82.190"] = { number = 17, name = "Show Low" },
    ["80.66.82.188"] = { number = 18, name = "Casa-Grande" },
    ["80.66.82.168"] = { number = 19, name = "Page" },
    ["80.66.82.159"] = { number = 20, name = "Sun-City" },
    ["80.66.82.200"] = { number = 21, name = "Queen-Creek" },
    ["80.66.82.144"] = { number = 22, name = "Sedona" },
    ["80.66.82.132"] = { number = 23, name = "Holiday" },
    ["80.66.82.128"] = { number = 24, name = "Wednesday" },
    ["80.66.82.113"] = { number = 25, name = "Yava" },
    ["80.66.82.82"] = { number = 26, name = "Faraway" },
    ["80.66.82.87"] = { number = 27, name = "Bumble Bee" },
    ["80.66.82.54"] = { number = 28, name = "Christmas" },
    ["80.66.82.39"] = { number = 29, name = "Mirage" },
    ["80.66.82.33:7777"] = { number = 30, name = "Love" },
    ["185.169.134.3"] = { number = 1, name = "Phoenix" },
    ["185.169.132.105"] = { number = 1, name = "Phoenix" },
    ["185.169.134.4"] = { number = 2, name = "Tucson" },
    ["185.169.132.106"] = { number = 2, name = "Tucson" },
}

-- Ñìàðò Óê
local smartUkPath = getWorkingDirectory() .. "/smartUk.json"
local smartUkUrl = {
    ["mobile-i"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile1.json",
    ["mobile-ii"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile2.json",
    ["mobile-iii"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile%203.json",
    phoenix = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Phoenix.json",
    tucson = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Tucson.json",
    ["saint-rose"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Saint-Rose.json",
    mesa = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mesa.json",
    ["red-rock"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Red-Rock.json",
    prescott = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Prescott.json",
    winslow = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Winslow.json",
    payson = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Payson.json",
    gilbert = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Gilbert.json",
    ["casa-grande"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Casa-Grande.json",
    page = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Page.json",
    ["sun-city"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sun-City.json",
    wednesday = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Wednesday.json",
    yava = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Yava.json",
    faraway = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Faraway.json",
    ["bumble-bee"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Bumble%20Bee.json",
    christmas = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Christmas.json",
    brainburg = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Brainburg.json",
    sedona = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sedona.json"
}
local file = io.open(getWorkingDirectory() .. "/smartUk.json", "r") -- Îòêðûâàåì ôàéë â ðåæèìå ÷òåíèÿ
if not file then
    tableUk = { Ur = { 6 }, Text = { "Íàïàäåíèå íà ïîëèöåéñêîãî 14.4" } }
    file = io.open(getWorkingDirectory() .. "/smartUk.json", "w")
    file:write(encodeJson(tableUk))
    file:close()
else
    a = file:read("*a")
    file:close()
    tableUk = decodeJson(a)
end

function check_update()
    function readJsonFile(filePath)
        if not doesFileExist(filePath) then
            print("Îøèáêà: Ôàéë " .. filePath .. " íå ñóùåñòâóåò")
            return nil
        end
        local file = io.open(filePath, "r")
        local content = file:read("*a")
        file:close()
        local jsonData = decodeJson(content)
        if not jsonData then
            print("Îøèáêà: Íåâåðíûé ôîðìàò JSON â ôàéëå " .. filePath)
            return nil
        end
        return jsonData
    end

    msg('{ffffff}Íà÷èíàþ ïðîâåðêó íà íàëè÷èå îáíîâëåíèé...')
    local pathupdate = getWorkingDirectory() .. "/config/infoupdate.json"
    os.remove(pathupdate)
    local url = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/infoupdate.json"
    downloadFile(url, pathupdate)
    local updateInfo = readJsonFile(pathupdate)
    if updateInfo then
        local uVer = updateInfo.current_version
        local uText = updateInfo.update_info
        if thisScript().version ~= uVer then
            msg('{ffffff}Äîñòóïíî îáíîâëåíèå!')
            updateUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper.lua"
            version = uVer
            textnewupdate = uText
            updateWin[0] = true
        else
            msg('{ffffff}Îáíîâëåíèå íå íóæíî, ó âàñ àêòóàëüíàÿ âåðñèÿ!')
        end
    end
end

function checkValue(path)
    local file = io.open(path, "r")
    if file then
        local value = file:read("*all")
        file:close()
        return value
    else
        return nil
    end
end

function downloadFile(url, path)
    local response = requests.get(url)

    if response.status_code == 200 then
        local filepath = path
        os.remove(filepath)
        local f = assert(io.open(filepath, 'wb'))
        f:write(response.text)
        f:close()
    else
        print('Îøèáêà ñêà÷èâàíèÿ...')
    end
end

function downloadBinder()
    file = io.open(path, "w")
    file:close()
    file = io.open(path, "a+")
    downloadFile("https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/refs/heads/main/Binder.json",
        path)
    msg('Óñòàíàâëèâàåòñÿ ôàéë áèíäåðà, ïåðåçàãðóçêà')
    thisScript():reload()
end

--Áèíäåð óñïåøíî ñïèçæåíûé ó Áîãäàíà(îí ðàçðåøèë)
local settings = {}
local default_settings = {
    commands = {
        {},
    },
}
local configDirectory = getWorkingDirectory() .. "/config"

function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
        settings = default_settings
        downloadBinder()
        print('[Binder] Ôàéë ñ íàñòðîéêàìè íå íàéäåí, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
    else
        local file = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
            if #contents == 0 then
                settings = default_settings
                print('[Binder] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
            else
                local result, loaded = pcall(decodeJson, contents)
                if result then
                    settings = loaded
                    for category, _ in pairs(default_settings) do
                        if settings[category] == nil then
                            settings[category] = {}
                        end
                        for key, value in pairs(default_settings[category]) do
                            if settings[category][key] == nil then
                                settings[category][key] = value
                            end
                        end
                    end
                    print('[Binder] Íàñòðîéêè óñïåøíî çàãðóæåíû!')
                else
                    print('[Binder] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
                end
            end
        else
            settings = default_settings
            downloadBinder()
            print('[Binder] Íå óäàëîñü îòêðûòü ôàéë ñ íàñòðîéêàìè, èñïîëüçóþ ñòàíäàðòíûå íàñòðîéêè!')
        end
    end
end

function save_settings()
    local file, errstr = io.open(path, 'w')
    if file then
        local result, encoded = pcall(encodeJson, settings)
        file:write(result and encoded or "")
        file:close()
        return result
    else
        print('[Binder] Íå óäàëîñü ñîõðàíèòü íàñòðîéêè õåëïåðà, îøèáêà: ', errstr)
        return false
    end
end

load_settings()
function isMonetLoader() return MONET_VERSION ~= nil end

if MONET_DPI_SCALE == nil then MONET_DPI_SCALE = 1.0 end


local message_color = 0x00CCFF
local message_color_hex = '{00CCFF}'

local sizeX, sizeY = getScreenResolution()
local new = imgui.new
local MainWindow = new.bool()
local BinderWindow = new.bool()
local ComboTags = new.int()
local item_list = { u8 'Áåç àðãóìåíòà', u8 '{arg} - ïðèíèìàåò ÷òî óãîäíî, áóêâû/öèôðû/ñèìâîëû', u8 '{arg_id} - ïðèíèìàåò òîëüêî ID èãðîêà',
    u8 '{arg_id} {arg2} - ïðèíèìàåò 2 àðóãìåíòà: ID èãðîêà è âòîðîå ÷òî óãîäíî' }
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_cmd_bool = false
local change_cmd = ''
local change_description = ''
local change_text = ''
local change_arg = ''

local isActiveCommand = false

local tagReplacements = {
    my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
    my_ru_nick = function() return TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) end,
    get_time = function()
        return os.date("%H:%M:%S")
    end,
}
local binder_tags_text = [[
{my_id} - Âàø èãðîâîé ID
{my_nick} - Âàø èãðîâîé Nick
{my_ru_nick} - Âàøå Èìÿ è Ôàìèëèÿ óêàçàííûå â õåëïåðå

{get_time} - Ïîëó÷èòü òåêóùåå âðåìÿ

{get_nick({arg_id})} - ïîëó÷èòü Nick èãðîêà èç àðãóìåíòà ID èãðîêà
{get_rp_nick({arg_id})}  - ïîëó÷èòü Nick èãðîêà áåç ñèìâîëà _ èç àðãóìåíòà ID èãðîêà
{get_ru_nick({arg_id})}  - ïîëó÷èòü Nick èãðîêà íà êèðèëèöå èç àðãóìåíòà ID èãðîêà
]]


function registerCommandsFrom(array)
    for _, command in ipairs(array) do
        if command.enable and not command.deleted then
            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
        end
    end
end

function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
    sampRegisterChatCommand(chat_cmd, function(arg)
        if not isActiveCommand then
            local arg_check = false
            local modifiedText = cmd_text
            if cmd_arg == '{arg}' then
                if arg and arg ~= '' then
                    modifiedText = modifiedText:gsub('{arg}', arg or "")
                    arg_check = true
                else
                    msg('[Binder] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [àðãóìåíò]',
                        message_color)
                    play_error_sound()
                end
            elseif cmd_arg == '{arg_id}' then
                if isParamSampID(arg) then
                    arg = tonumber(arg)
                    modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
                    modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
                        sampGetPlayerNickname(arg):gsub('_', ' ') or "")
                    modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
                        TranslateNick(sampGetPlayerNickname(arg)) or "")
                    modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
                    arg_check = true
                else
                    msg('[Binder] {ffffff}Èñïîëüçóéòå ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà]',
                        message_color)
                    play_error_sound()
                end
            elseif cmd_arg == '{arg_id} {arg2}' then
                if arg and arg ~= '' then
                    local arg_id, arg2 = arg:match('(%d+) (.+)')
                    if isParamSampID(arg_id) and arg2 then
                        arg_id = tonumber(arg_id)
                        modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}',
                            sampGetPlayerNickname(arg_id) or "")
                        modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}',
                            sampGetPlayerNickname(arg_id):gsub('_', ' ') or "")
                        modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}',
                            TranslateNick(sampGetPlayerNickname(arg_id)) or "")
                        modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
                        modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
                        arg_check = true
                    else
                        msg(
                            '[Binder] {ffffff}Èñïîëüçóéòå ' ..
                            message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò]', message_color)
                        play_error_sound()
                    end
                else
                    msg(
                        '[Binder] {ffffff}Èñïîëüçóéòå ' ..
                        message_color_hex .. '/' .. chat_cmd .. ' [ID èãðîêà] [àðãóìåíò]',
                        message_color)
                    play_error_sound()
                end
            elseif cmd_arg == '' then
                arg_check = true
            end
            if arg_check then
                lua_thread.create(function()
                    isActiveCommand = true
                    local lines = {}
                    for line in string.gmatch(modifiedText, "[^&]+") do
                        table.insert(lines, line)
                    end
                    for _, line in ipairs(lines) do
                        if command_stop then
                            command_stop = false
                            isActiveCommand = false
                            msg('[Binder] {ffffff}Îòûãðîâêà êîìàíäû /' .. chat_cmd .. " óñïåøíî îñòàíîâëåíà!",
                                message_color)
                            return
                        end
                        for tag, replacement in pairs(tagReplacements) do
                            -- local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
                            -- if success then
                            -- 	line = result
                            -- end
                            line = line:gsub("{" .. tag .. "}", replacement())
                        end
                        sampSendChat(line)
                        wait(cmd_waiting * 1000)
                    end
                    isActiveCommand = false
                end)
            end
        else
            msg('[Binder] {ffffff}Äîæäèòåñü çàâåðøåíèÿ îòûãðîâêè ïðåäûäóùåé êîìàíäû!', message_color)
        end
    end)
end

function path_join(...)
    local path = ''
    local arg = { ... }
    for i = 1, #arg do
        path = path .. arg[i]
        if i ~= #arg then
            path = path .. '\\'
        end
    end
    return path
end

imgui.OnInitialize(function()
    MyGif = imgui.LoadFrames()
    decor() -- ïðèìåíÿåì äåêîð ÷àñòü
    apply_n_t()

    imgui.GetIO().IniFilename = nil
    if fsClock == nil then
        local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
        
        -- fsClock = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 43, _, glyph_ranges)
    end
    
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14 * MDS, config, iconRanges) -- solid - òèï èêîíîê, òàê æå åñòü thin, regular, light è duotone
    local tmp = imgui.ColorConvertU32ToFloat4(mainIni.theme['moonmonet'])
    gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)

    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    Menu = imgui.GetIO().Fonts:AddFontFromFileTTF("fonts/Inter.ttf", 42, _, glyph_ranges)
    imgui.GetStyle():ScaleAllSizes(MDS)
    big = imgui.GetIO().Fonts:AddFontFromFileTTF("fonts/Inter.ttf", 30, _, glyph_ranges)
end)

function downloadToFile(url, path, callback, progressInterval)
    callback = callback or function() end
    progressInterval = progressInterval or 0.1
    local progressChannel = effil.channel(0)

    local runner = effil.thread(function(url, path)
        local http = require("socket.http")
        local ltn = require("ltn12")

        local _, res, code, headers = pcall(http.request, {
            method = "HEAD",
            url = url,
        })

        local total_size = headers["content-length"] or 0

        local f = io.open(path, "w+b")
        if not f then
            return false, "failed to open file"
        end
        local success, res, status_code = pcall(http.request, {
            method = "GET",
            url = url,
            sink = function(chunk, err)
                local clock = os.clock()
                if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
                    progressChannel:push("downloading", f:seek("end"), total_size)
                    lastProgress = os.clock()
                elseif err then
                    progressChannel:push("error", err)
                end

                return ltn.sink.file(f)(chunk, err)
            end,
        })

        if not success then
            return false, res
        end

        if not res then
            return false, status_code
        end

        return true, total_size
    end)
    local thread = runner(url, path)

    local function checkStatus()
        local tstatus = thread:status()
        if tstatus == "failed" or tstatus == "completed" then
            local result, value = thread:get()

            if result then
                callback("finished", value)
            else
                callback("error", value)
            end

            return true
        end
    end

    lua_thread.create(function()
        if checkStatus() then
            return
        end

        while thread:status() == "running" do
            if progressChannel:size() > 0 then
                local type, pos, total_size = progressChannel:pop()
                callback(type, pos, total_size)
            end
            wait(0)
        end

        checkStatus()
    end)
end

function asyncHttpRequest(method, url, args, resolve, reject)
    local request_thread = effil.thread(function(method, url, args)
        local result, response = pcall(requests.request, method, url, effil.dump(args))
        if result then
            response.json, response.xml = nil, nil
            return true, response
        else
            return false, response
        end
    end)(method, url, args)
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end
    lua_thread.create(function()
        local runner = request_thread
        while true do
            local status, err = runner:status()
            if not err then
                if status == 'completed' then
                    local result, response = runner:get()
                    if result then
                        resolve(response)
                    else
                        reject(response)
                    end
                    return
                elseif status == 'canceled' then
                    return reject(status)
                end
            else
                return reject(err)
            end
            wait(0)
        end
    end)
end

-- Timer Online spasibo @osp_x
local cfg = mainIni
mcx = 0x0087FF
local sX, sY = getScreenResolution()
local tag = '{0087FF}TimerOnline: {FFFFFF}'
local to = new.bool(cfg.statTimers.state)
local nowTime = os.date("%H:%M:%S", os.time())
local settingsonline = new.bool(false)
local myOnline = new.bool(false)
local pos = false
local restart = false
local recon = false

local sesOnline = new.int(0)
local sesAfk = new.int(0)
local sesFull = new.int(0)
local dayFull = new.int(cfg.onDay.full)
local weekFull = new.int(cfg.onWeek.full)
local sRound = new.float(cfg.style.round)

local argbW = cfg.style.colorW
local argbT = cfg.style.colorT

local tmp = imgui.ColorConvertU32ToFloat4(cfg.style.colorW)
local colorW = new.float[4](tmp.x, tmp.y, tmp.z, tmp.w)

local tmp = imgui.ColorConvertU32ToFloat4(cfg.style.colorT)
local colorT = new.float[4](tmp.x, tmp.y, tmp.z, tmp.w)

local posX, posY = cfg.pos.x, cfg.pos.y
local Radio = {
    ['clock'] = cfg.statTimers.clock,
    ['sesOnline'] = cfg.statTimers.sesOnline,
    ['sesAfk'] = cfg.statTimers.sesAfk,
    ['sesFull'] = cfg.statTimers.sesFull,
    ['dayOnline'] = cfg.statTimers.dayOnline,
    ['dayAfk'] = cfg.statTimers.dayAfk,
    ['dayFull'] = cfg.statTimers.dayFull,
    ['weekOnline'] = cfg.statTimers.weekOnline,
    ['weekAfk'] = cfg.statTimers.weekAfk,
    ['weekFull'] = cfg.statTimers.weekFull
}

local tWeekdays = {
    [0] = 'Âîñêðåñåíüå',
    [1] = 'Ïîíåäåëüíèê',
    [2] = 'Âòîðíèê',
    [3] = 'Ñðåäà',
    [4] = '×åòâåðã',
    [5] = 'Ïÿòíèöà',
    [6] = 'Ñóááîòà'
}

imgui.OnFrame(function() return to[0] and not recon end,
    function()
        -- timer window >>
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(colorW[0], colorW[1], colorW[2], colorW[3]))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(colorT[0], colorT[1], colorT[2], colorT[3]))
        imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, sRound[0])
        imgui.SetNextWindowPos(imgui.ImVec2(posX, posY), imgui.Cond.FirstUseEver)
        local flags = imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize
        if not editpos then flags = flags + imgui.WindowFlags.NoMove end

        imgui.Begin(u8 '##timer', to, flags)
        local pos = imgui.GetWindowPos()

        if cfg.statTimers.clock then
            imgui.PushFont(fsClock)
            imgui.CenterTextColoredRGB(nowTime)
            imgui.PopFont()
            imgui.SetCursorPosY(30)
            imgui.CenterTextColoredRGB(getStrDate(os.time()))
            if cfg.statTimers.sesOnline or cfg.statTimers.sesAfk or cfg.statTimers.sesFull or cfg.statTimers.dayOnline or cfg.statTimers.dayAfk or cfg.statTimers.dayFull or cfg.statTimers.weekOnline or cfg.statTimers.weekAfk or cfg.statTimers.weekFull then
                imgui.Separator()
            end
        end

        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(5, 2))
        if not sampIsLocalPlayerSpawned() then
            --imgui.CenterTextColoredRGB("Ïîäêëþ÷åíèå: " .. get_clock(connectingTime))
        else
            if cfg.statTimers.sesOnline then imgui.CenterTextColoredRGB("Ñåññèÿ (÷èñòûé): " .. get_clock(sesOnline[0])) end
            if cfg.statTimers.sesAfk then imgui.CenterTextColoredRGB("AFK çà ñåññèþ: " .. get_clock(sesAfk[0])) end
            if cfg.statTimers.sesFull then imgui.CenterTextColoredRGB("Îíëàéí çà ñåññèþ: " .. get_clock(sesFull[0])) end
            if cfg.statTimers.dayOnline then
                imgui.CenterTextColoredRGB("Çà äåíü (÷èñòûé): " ..
                    get_clock(cfg.onDay.online))
            end
            if cfg.statTimers.dayAfk then imgui.CenterTextColoredRGB("ÀÔÊ çà äåíü: " .. get_clock(cfg.onDay.afk)) end
            if cfg.statTimers.dayFull then imgui.CenterTextColoredRGB("Îíëàéí çà äåíü: " .. get_clock(cfg.onDay.full)) end
            if cfg.statTimers.weekOnline then
                imgui.CenterTextColoredRGB("Çà íåäåëþ (÷èñòûé): " ..
                    get_clock(cfg.onWeek.online))
            end
            if cfg.statTimers.weekAfk then imgui.CenterTextColoredRGB("ÀÔÊ çà íåäåëþ: " .. get_clock(cfg.onWeek.afk)) end
            if cfg.statTimers.weekFull then imgui.CenterTextColoredRGB("Îíëàéí çà íåäåëþ: " .. get_clock(cfg.onWeek.full)) end
        end
        imgui.PopStyleVar()
        if editpos and imgui.Button(u8 "Çàêðåïèòü", imgui.ImVec2(-1, 35)) then
            editpos = false
            settingsonline[0] = true
            cfg.pos.x, cfg.pos.y = pos.x, pos.y
            inicfg.save(mainIni, 'mvdhelper.ini')
            msg('Ïîçèöèÿ îêíà ñîõðàíåíà!')
        end

        imgui.End()
        imgui.PopStyleVar()
        imgui.PopStyleColor(2)
    end)
imgui.OnFrame(function() return settingsonline[0] end,
    function()
        -- settings menu >>
        imgui.SetNextWindowSize(imgui.ImVec2(600 * MDS, 360 * MDS), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sX / 2, sY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8 '#Settings', settingsonline,
            imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
        imgui.PushFont(fsClock)
        imgui.CenterTextColoredRGB('Timer Online')
        imgui.PopFont()
        imgui.BeginChild('##RadioButtons', imgui.ImVec2(190 * MDS, 280 * MDS), true)

        if imgui.RadioButtonBool(u8 'Òåêóùåå äàòà è âðåìÿ', Radio['clock']) then
            Radio['clock'] = not Radio['clock']; cfg.statTimers.clock = Radio['clock']
        end
        if imgui.RadioButtonBool(u8 'Îíëàéí ñåññèþ', Radio['sesOnline']) then
            Radio['sesOnline'] = not Radio['sesOnline']; cfg.statTimers.sesOnline = Radio['sesOnline']
        end
        imgui.Hint('##1234', u8 'Áåç ó÷¸òà ÀÔÊ (×èñòûé îíëàéí)')
        if imgui.RadioButtonBool(u8 'AFK çà ñåññèþ', Radio['sesAfk']) then
            Radio['sesAfk'] = not Radio['sesAfk']; cfg.statTimers.sesAfk = Radio['sesAfk']
        end
        if imgui.RadioButtonBool(u8 'Îáùèé çà ñåññèþ', Radio['sesFull']) then
            Radio['sesFull'] = not Radio['sesFull']; cfg.statTimers.sesFull = Radio['sesFull']
        end
        if imgui.RadioButtonBool(u8 'Îíëàéí çà äåíü', Radio['dayOnline']) then
            Radio['dayOnline'] = not Radio['dayOnline']; cfg.statTimers.dayOnline = Radio['dayOnline']
        end
        imgui.Hint('##1233', u8 'Áåç ó÷¸òà ÀÔÊ (×èñòûé îíëàéí)')
        if imgui.RadioButtonBool(u8 'ÀÔÊ çà äåíü', Radio['dayAfk']) then
            Radio['dayAfk'] = not Radio['dayAfk']; cfg.statTimers.dayAfk = Radio['dayAfk']
        end
        if imgui.RadioButtonBool(u8 'Îáùèé çà äåíü', Radio['dayFull']) then
            Radio['dayFull'] = not Radio['dayFull']; cfg.statTimers.dayFull = Radio['dayFull']
        end
        if imgui.RadioButtonBool(u8 'Îíëàéí çà íåäåëþ', Radio['weekOnline']) then
            Radio['weekOnline'] = not Radio['weekOnline']; cfg.statTimers.weekOnline = Radio['weekOnline']
        end
        imgui.Hint('##123', u8 'Áåç ó÷¸òà ÀÔÊ (×èñòûé îíëàéí)')
        if imgui.RadioButtonBool(u8 'ÀÔÊ çà íåäåëþ', Radio['weekAfk']) then
            Radio['weekAfk'] = not Radio['weekAfk']; cfg.statTimers.weekAfk = Radio['weekAfk']
        end
        if imgui.RadioButtonBool(u8 'Îáùèé çà íåäåëþ', Radio['weekFull']) then
            Radio['weekFull'] = not Radio['weekFull']; cfg.statTimers.weekFull = Radio['weekFull']
        end
        imgui.EndChild()
        imgui.SameLine()
        imgui.BeginChild('##Customisation', imgui.ImVec2(-1, 280 * MDS), true)
        if imgui.Checkbox(u8('##State'), to) then
            cfg.statTimers.state = to[0]
            inicfg.save(mainIni, 'mvdhelper.ini')
        end
        imgui.SameLine()
        if to[0] then
            imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8 'Âêëþ÷åíî')
        else
            imgui.TextDisabled(u8 'Âûêëþ÷åíî')
        end
        if imgui.Button(u8 'Ìåñòîïîëîæåíèå', imgui.ImVec2(-1, 30 * MDS)) then
            editpos = true
            settingsonline[0] = false
            msg('Ïåðåìåùàéòå îêíî')
        end
        if cfg.statTimers.server == sampGetCurrentServerAddress() then
            if imgui.Button(u8(sampGetCurrentServerName()), imgui.ImVec2(-1, 30 * MDS)) then
                cfg.statTimers.server = nil
                msg('Òåïåðü ýòîò ñåðâåð íå ñ÷èòàåòñÿ îñíîâíûì!')
            end
        else
            if imgui.Button(u8 'Óñòàíîâèòü ýòîò ñåðâåð îñíîâíûì', imgui.ImVec2(-1, 30 * MDS)) then
                cfg.statTimers.server = sampGetCurrentServerAddress()
                msg('Òåïåðü îíëàéí áóäåò ñ÷èòàòüñÿ òîëüêî íà ýòîì ñåðâåðå!')
            end
            imgui.Hint('##1123', u8 'Ñêðèïò áóäåò çàïóñêàòüñÿ òîëüêî íà ýòîì ñåðâåðå!')
        end
        imgui.PushItemWidth(-1)
        if imgui.SliderFloat('##Round', sRound, 0.0, 10.0, u8 "Ñêðóãëåíèå êðà¸â: %.2f") then
            cfg.style.round = sRound[0]
        end
        imgui.PopItemWidth()

        if imgui.ColorEdit4(u8 '##Fon', colorW, imgui.ColorEditFlags.NoInputs) then
            argbW = imgui.ColorConvertFloat4ToU32(
                imgui.ImVec4(colorW[0], colorW[1], colorW[2], colorW[3])
            )
            cfg.style.colorW = argbW
        end
        imgui.SameLine()
        imgui.Text(u8 'Öâåò ôîíà')
        if imgui.ColorEdit4(u8 '##Texta', colorT, imgui.ColorEditFlags.NoInputs) then
            argbT = imgui.ColorConvertFloat4ToU32(
                imgui.ImVec4(colorT[0], colorT[1], colorT[2], colorT[3])
            )
            cfg.style.colorT = argbT
        end
        imgui.SameLine()
        imgui.Text(u8 'Öâåò òåêñòà')

        imgui.EndChild()
        if imgui.Button(u8 'Ñîõðàíèòü è çàêðûòü', imgui.ImVec2(-1, 30 * MDS)) then
            if inicfg.save(mainIni, 'mvdhelper.ini') then
                msg('Íàñòðîéêè ñîõðàíåíû!')
                settingsonline[0] = false
            end
        end
        imgui.End()
    end)
imgui.OnFrame(function() return myOnline[0] end,
    function()
        imgui.SetNextWindowSize(imgui.ImVec2(400 * MDS, 230 * MDS), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sX / 2, sY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8 '#WeekOnline', _,
            imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
        imgui.SetCursorPos(imgui.ImVec2(15 * MDS, 10 * MDS))
        imgui.PushFont(fsClock)
        imgui.CenterTextColoredRGB('Îíëàéí çà íåäåëþ')
        imgui.PopFont()
        imgui.CenterTextColoredRGB('{0087FF}Âñåãî îòûãðàíî: ' .. get_clock(cfg.onWeek.full))
        imgui.NewLine()
        for day = 1, 6 do -- ÏÍ -> ÑÁ
            imgui.Text(u8(tWeekdays[day])); imgui.SameLine(250 * MDS)
            imgui.Text(get_clock(cfg.myWeekOnline[day]))
        end
        --> ÂÑ
        imgui.Text(u8(tWeekdays[0])); imgui.SameLine(250 * MDS)
        imgui.Text(get_clock(cfg.myWeekOnline[0]))

        imgui.SetCursorPosX((imgui.GetWindowWidth() - 200 * MDS) / 2)
        if imgui.Button(u8 'Çàêðûòü', imgui.ImVec2(200 * MDS, 25 * MDS)) then myOnline[0] = false end
        imgui.End()
    end)

function sampev.onTogglePlayerSpectating(state) recon = state end -- åñëè âû àäìèí, òî â ðåêîíå ñêðèïò áóäåò îòêëþ÷àòü òàáëè÷êó, ñäåëàë ÷èñòî äëÿ ñåáÿ, åñëè íàäî - óäàëèòå

function time()
    startTime = os.time() -- "Òî÷êà îòñ÷¸òà"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampIsLocalPlayerSpawned() then                       -- Èãðîâîé ñòàòóñ ðàâåí "Ïîäêëþ÷¸í ê ñåðâåðó" (×òî áû îíëàéí ñ÷èòàëî òîëüêî, êîãäà, ìû ïîäêëþ÷åíû ê ñåðâåðó)
            sesOnline[0] = sesOnline[0] + 1                      -- Îíëàéí çà ñåññèþ áåç ó÷¸òà ÀÔÊ
            sesFull[0] = os.time() - startTime                   -- Îáùèé îíëàéí çà ñåññèþ
            sesAfk[0] = sesFull[0] - sesOnline[0]                -- ÀÔÊ çà ñåññèþ

            cfg.onDay.online = cfg.onDay.online + 1              -- Îíëàéí çà äåíü áåç ó÷¸òà ÀÔÊ
            cfg.onDay.full = dayFull[0] + sesFull[0]             -- Îáùèé îíëàéí çà äåíü
            cfg.onDay.afk = cfg.onDay.full - cfg.onDay.online    -- ÀÔÊ çà äåíü

            cfg.onWeek.online = cfg.onWeek.online + 1            -- Îíëàéí çà íåäåëþ áåç ó÷¸òà ÀÔÊ
            cfg.onWeek.full = weekFull[0] + sesFull[0]           -- Îáùèé îíëàéí çà íåäåëþ
            cfg.onWeek.afk = cfg.onWeek.full - cfg.onWeek.online -- ÀÔÊ çà íåäåëþ

            local today = tonumber(os.date('%w', os.time()))
            cfg.myWeekOnline[today] = cfg.onDay.full

            connectingTime = 0
        else
            connectingTime = connectingTime + 1 -- Âåðìÿ ïîäêëþ÷åíèÿ ê ñåðâåðó
            startTime = startTime + 1           -- Ñìåùåíèå íà÷àëà îòñ÷åòà òàéìåðîâ
        end
    end
end

function autoSave()
    while true do
        wait(60000) -- ñîõðàíåíèå êàæäûå 60 ñåêóíä
        inicfg.save(mainIni, "mvdhelper.ini")
    end
end

function number_week() -- ïîëó÷åíèå íîìåðà íåäåëè â ãîäó
    local current_time = os.date '*t'
    local start_year = os.time { year = current_time.year, day = 1, month = 1 }
    local week_day = (os.date('%w', start_year) - 1) % 7
    return math.ceil((current_time.yday + week_day) / 7)
end

function getStrDate(unixTime)
    local tMonths = { 'ÿíâàðÿ', 'ôåâðàëÿ', 'ìàðòà', 'àïðåëÿ', 'ìàÿ', 'èþíÿ', 'èþëÿ', 'àâãóñòà', 'ñåíòÿáðÿ', 'îêòÿáðÿ',
        'íîÿáðÿ', 'äåêàáðÿ' }
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400) .. 'ä ' or '') .. '%H:%M:%S', time + timezone_offset)
end

function imgui.CenterTextColoredRGB(text)
    text = u8(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local col = imgui.Col

    local designText = function(text__)
        local pos = imgui.GetCursorPos()
        if false then
            for i = 1, 1 --[[Ñòåïåíü òåíè]] do
                imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
            end
        end
        imgui.SetCursorPos(pos)
    end



    local text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')

    local color = colors[col.Text]
    local start = 1
    local a, b = text:find('{........}', start)

    while a do
        local t = text:sub(start, a - 1)
        if #t > 0 then
            designText(t)
            imgui.TextColored(color, t)
            imgui.SameLine(nil, 0)
        end

        local clr = text:sub(a + 1, b - 1)
        if clr:upper() == 'STANDART' then
            color = colors[col.Text]
        else
            clr = tonumber(clr, 16)
            if clr then
                local r = bit.band(bit.rshift(clr, 24), 0xFF)
                local g = bit.band(bit.rshift(clr, 16), 0xFF)
                local b = bit.band(bit.rshift(clr, 8), 0xFF)
                local a = bit.band(clr, 0xFF)
                color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
            end
        end

        start = b + 1
        a, b = text:find('{........}', start)
    end
    imgui.NewLine()
    if #text >= start then
        imgui.SameLine(nil, 0)
        designText(text:sub(start))
        imgui.TextColored(color, text:sub(start))
    end
end



imgui.ImageURL = {
    cache_dir = getWorkingDirectory() .. "/resource/cache",
    download_statuses = {
        INIT = 0,
        DOWNLOADING = 1,
        ERROR = 2,
        SAVED = 3,
        NOT_MODIFIED = 4,
        CACHE_ONLY = 5
    },
    pool = {}
}

function imgui.ImageURL:set_cache(url, image_data, headers)
    if not doesDirectoryExist(self.cache_dir) then
        createDirectory(self.cache_dir)
    end

    local path = ("%s/%s"):format(self.cache_dir, md5.sumhexa(url))
    local file, err = io.open(path, "wb")
    if not file then
        return nil
    end

    local data = { Data = tostring(image_data) }
    if headers["etag"] then
        data["Etag"] = headers["etag"]
    end
    if headers["last-modified"] then
        data["Last-Modified"] = headers["last-modified"]
    end

    file:write(encodeJson(data))
    file:close()
    return path
end

function imgui.ImageURL:get_cache(url)
    local path = ("%s/%s"):format(self.cache_dir, md5.sumhexa(url))
    if not doesFileExist(path) then
        return nil, nil
    end

    local image_data = nil
    local cached_headers = {}

    local file, err = io.open(path, "rb")
    if file then
        local cache = decodeJson(file:read("*a"))
        if type(cache) ~= "table" then
            return nil, nil
        end

        if cache["Data"] ~= nil then
            image_data = cache["Data"]
        end
        if cache["Last-Modified"] ~= nil then
            cached_headers["If-Modified-Since"] = cache["Last-Modified"]
        end
        if cache["Etag"] ~= nil then
            cached_headers["If-None-Match"] = cache["Etag"]
        end

        file:close()
    end
    return image_data, cached_headers
end

function imgui.ImageURL:download(url, preload_cache)
    local st = self.download_statuses
    self.pool[url] = {
        status = st.DOWNLOADING,
        image = nil,
        error = nil
    }
    local cached_image, cached_headers = imgui.ImageURL:get_cache(url)
    local img = self.pool[url]

    if preload_cache and cached_image ~= nil then
        img.image = imgui.CreateTextureFromFileInMemory(memory.strptr(cached_image), #cached_image)
    end

    asyncHttpRequest("GET", url, { headers = cached_headers },
        function(result)
            if result.status_code == 200 then
                img.image = imgui.CreateTextureFromFileInMemory(memory.strptr(result.text), #result.text)
                img.status = st.SAVED
                imgui.ImageURL:set_cache(url, result.text, result.headers)
            elseif result.status_code == 304 then
                img.image = img.image or imgui.CreateTextureFromFileInMemory(memory.strptr(cached_image), #cached_image)
                img.status = st.NOT_MODIFIED
            else
                img.status = img.image and st.CACHE_ONLY or st.ERROR
                img.error = ("Error #%s"):format(result.status_code)
            end
        end,
        function(error)
            img.status = img.image and st.CACHE_ONLY or st.ERROR
            img.error = error
        end
    )
end

function imgui.ImageURL:render(url, size, preload, ...)
    local st = self.download_statuses
    local img = self.pool[url]

    if img == nil then
        self.pool[url] = {
            status = st.INIT,
            error = nil,
            image = nil
        }
        img = self.pool[url]
    end

    if img.status == st.INIT then
        imgui.ImageURL:download(url, preload)
    end

    if img.image ~= nil then
        imgui.Image(img.image, size, ...)
    else
        imgui.Dummy(size)
    end
    return img.status, img.error
end

setmetatable(imgui.ImageURL, {
    __call = imgui.ImageURL.render
})
function loadLog()
    local file = io.open("log.json", "r")
    if file then
        local jsonData = file:read("*all")
        if jsonData ~= "" then
            logs = decodeJson(jsonData) or {}
            file:close()
        else
            saveLog()
        end
    else
        saveLog()
    end
end

function saveLog()
    local file = io.open("log.json", "w")
    if file then
        file:write(encodeJson(logs, { indent = true }))
        file:close()
    end
end

function addLogEntry(type, player, amount, duration)
    local entry = {
        time = os.date("%Y-%m-%d %H:%M:%S"),
        type = type,
        player = player,
        amount = amount,
        duration = duration
    }
    table.insert(logs, entry)
    saveLog()
end


function loadNotesFromFile()
    local file = io.open("notes.json", "r")
    if file then
        local jsonData = file:read("*all")
        notes = decodeJson(jsonData) or {}
        file:close()
    else
        saveNotesToFile()
    end
end

function saveNotesToFile()
    local file = io.open("notes.json", "w")
    if file then
        local jsonData = encodeJson(notes)
        file:write(jsonData)
        file:close()
    end
end

local MainWindow = imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.TERMINAL .. u8 " Binder by MTG MODS - Ãëàâíîå ìåíþ", MainWindow,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)

        if imgui.BeginChild('##1', imgui.ImVec2(700 * MONET_DPI_SCALE, 700 * MONET_DPI_SCALE), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "Êîìàíäà")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Îïèñàíèå")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Äåéñòâèå")
            imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/binder")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Îòêðûòü ãëàâíîå ìåíþ áèíäåðà")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Íåäîñòóïíî")
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/stop [Íåäîñòóïåí]")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Îñòàíîâèòü ëþáóþ îòûãðîâêó èç áèíäåðà [Íåäîñòóïåí]")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Íåäîñòóïíî")
            imgui.Columns(1)
            imgui.Separator()
            for index, command in ipairs(settings.commands) do
                if not command.deleted then
                    imgui.Columns(3)
                    if command.enable then
                        imgui.CenterColumnText('/' .. u8(command.cmd))
                        imgui.NextColumn()
                        imgui.CenterColumnText(u8(command.description))
                        imgui.NextColumn()
                    else
                        imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
                        imgui.NextColumn()
                        imgui.CenterColumnTextDisabled(u8(command.description))
                        imgui.NextColumn()
                    end
                    imgui.Text(' ')
                    imgui.SameLine()
                    if command.enable then
                        if imgui.SmallButton(fa.TOGGLE_ON .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            sampUnregisterChatCommand(command.cmd)
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Îòêëþ÷åíèå êîìàíäû /" .. command.cmd)
                        end
                    else
                        if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Âêëþ÷åíèå êîìàíäû /" .. command.cmd)
                        end
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. command.cmd) then
                        change_description = command.description
                        input_description = imgui.new.char[256](u8(change_description))
                        change_arg = command.arg
                        if command.arg == '' then
                            ComboTags[0] = 0
                        elseif command.arg == '{arg}' then
                            ComboTags[0] = 1
                        elseif command.arg == '{arg_id}' then
                            ComboTags[0] = 2
                        elseif command.arg == '{arg_id} {arg2}' then
                            ComboTags[0] = 3
                        end
                        change_cmd = command.cmd
                        input_cmd = imgui.new.char[256](u8(command.cmd))
                        change_text = command.text:gsub('&', '\n')
                        input_text = imgui.new.char[8192](u8(change_text))
                        change_waiting = command.waiting
                        waiting_slider = imgui.new.float(tonumber(command.waiting))
                        BinderWindow[0] = true
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Èçìåíåíèå êîìàíäû /" .. command.cmd)
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
                        imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd)
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Óäàëåíèå êîìàíäû /" .. command.cmd)
                    end
                    if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd, _, imgui.WindowFlags.NoResize) then
                        imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' .. u8(command.cmd) .. '?')
                        imgui.Separator()
                        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            command.enable = false
                            command.deleted = true
                            sampUnregisterChatCommand(command.cmd)
                            save_settings()
                            imgui.CloseCurrentPopup()
                        end
                        imgui.End()
                    end
                    imgui.Columns(1)
                    imgui.Separator()
                end
            end
            imgui.EndChild()
        end
        if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ êîìàíäó##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            local new_cmd = {
                cmd = '',
                description = 'Íîâàÿ êîìàíäà ñîçäàííàÿ âàìè',
                text = '',
                arg = '',
                enable = true,
                waiting =
                '1.200',
                deleted = false
            }
            table.insert(settings.commands, new_cmd)
            change_description = new_cmd.description
            input_description = imgui.new.char[256](u8(change_description))
            change_arg = new_cmd.arg
            ComboTags[0] = 0
            change_cmd = new_cmd.cmd
            input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
            change_text = new_cmd.text:gsub('&', '\n')
            input_text = imgui.new.char[8192](u8(change_text))
            change_waiting = 1.200
            waiting_slider = imgui.new.float(1.200)
            BinderWindow[0] = true
        end
        if imgui.Button(fa.HEADSET .. u8 ' Discord ñåðâåð MTG MODS (Ñâÿçü ñ àâòîðîì è òåõ.ïîääåðæêà)', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            openLink('https://discord.com/invite/qBPEYjfNhv')
        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.TERMINAL .. u8 " Binder by MTG MODS - Ðåäàêòèðîâàíèå êîìàíäû /" .. change_cmd, BinderWindow,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * MONET_DPI_SCALE, 361 * MONET_DPI_SCALE), true) then
            imgui.CenterText(fa.FILE_LINES .. u8 ' Îïèñàíèå êîìàíäû:')
            imgui.PushItemWidth(579 * MONET_DPI_SCALE)
            imgui.InputText("##input_description", input_description, 256)
            imgui.Separator()
            imgui.CenterText(fa.TERMINAL .. u8 ' Êîìàíäà äëÿ èñïîëüçîâàíèÿ â ÷àòå (áåç /):')
            imgui.PushItemWidth(579 * MONET_DPI_SCALE)
            imgui.InputText("##input_cmd", input_cmd, 256)
            imgui.Separator()
            imgui.CenterText(fa.CODE .. u8 ' Àðãóìåíòû êîòîðûå ïðèíèìàåò êîìàíäà:')
            imgui.Combo(u8 '', ComboTags, ImItems, #item_list)
            imgui.Separator()
            imgui.CenterText(fa.FILE_WORD .. u8 ' Òåêñòîâûé áèíä êîìàíäû:')
            imgui.InputTextMultiline("##text_multiple", input_text, 8192,
                imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
            imgui.EndChild()
        end
        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            BinderWindow[0] = false
        end
        imgui.SameLine()
        if imgui.Button(fa.CLOCK .. u8 ' Çàäåðæêà', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            imgui.OpenPopup(fa.CLOCK .. u8 ' Çàäåðæêà (â ñåêóíäàõ) ')
        end
        if imgui.BeginPopupModal(fa.CLOCK .. u8 ' Çàäåðæêà (â ñåêóíäàõ) ', _, imgui.WindowFlags.NoResize) then
            imgui.PushItemWidth(200 * MONET_DPI_SCALE)
            imgui.SliderFloat(u8 '##waiting', waiting_slider, 0.3, 5)
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Îòìåíà', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                waiting_slider = imgui.new.float(tonumber(change_waiting))
                imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
            if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.SameLine()
        if imgui.Button(fa.TAGS .. u8 ' Òýãè ', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            imgui.OpenPopup(fa.TAGS .. u8 ' Îñíîâíûå òýãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå')
        end
        if imgui.BeginPopupModal(fa.TAGS .. u8 ' Îñíîâíûå òýãè äëÿ èñïîëüçîâàíèÿ â áèíäåðå', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8(binder_tags_text))
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.SameLine()
        if imgui.Button(fa.FLOPPY_DISK .. u8 ' Ñîõðàíèòü', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
                imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Îøèáêà ñîõðàíåíèÿ êîìàíäû!')
            else
                local new_arg = ''
                if ComboTags[0] == 0 then
                    new_arg = ''
                elseif ComboTags[0] == 1 then
                    new_arg = '{arg}'
                elseif ComboTags[0] == 2 then
                    new_arg = '{arg_id}'
                elseif ComboTags[0] == 3 then
                    new_arg = '{arg_id} {arg2}'
                end
                local new_waiting = waiting_slider[0]
                local new_description = u8:decode(ffi.string(input_description))
                local new_command = u8:decode(ffi.string(input_cmd))
                local new_text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
                if binder_create_command_9_10 then
                    for _, command in ipairs(settings.commands_manage) do
                        if command.cmd == change_cmd and command.description == change_description and command.arg == change_arg and command.text:gsub('&', '\n') == change_text then
                            command.cmd = new_command
                            command.arg = new_arg
                            command.description = new_description
                            command.text = new_text
                            command.waiting = new_waiting
                            save_settings()
                            if command.arg == '' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg_id}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg_id} {arg2}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex ..
                                    '/' .. new_command .. ' [ID èãðîêà] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            end
                            sampUnregisterChatCommand(change_cmd)
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                            binder_create_command_9_10 = false
                            break
                        end
                    end
                else
                    for _, command in ipairs(settings.commands) do
                        if command.cmd == change_cmd and command.description == change_description and command.arg == change_arg and command.text:gsub('&', '\n') == change_text then
                            command.cmd = new_command
                            command.arg = new_arg
                            command.description = new_description
                            command.text = new_text
                            command.waiting = new_waiting
                            save_settings()
                            if command.arg == '' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg_id}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex .. '/' .. new_command .. ' [ID èãðîêà] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            elseif command.arg == '{arg_id} {arg2}' then
                                msg(
                                    '[Binder] {ffffff}Êîìàíäà ' ..
                                    message_color_hex ..
                                    '/' .. new_command .. ' [ID èãðîêà] [àðãóìåíò] {ffffff}óñïåøíî ñîõðàíåíà!',
                                    message_color)
                            end
                            sampUnregisterChatCommand(change_cmd)
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                            break
                        end
                    end
                end
                BinderWindow[0] = false
            end
        end
        if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Îøèáêà ñîõðàíåíèÿ êîìàíäû!', _, imgui.WindowFlags.AlwaysAutoResize) then
            if ffi.string(input_cmd):find('%W') then
                imgui.BulletText(u8 " Â êîìàíäå ìîæíî èñïîëüçîâàòü òîëüêî àíãë. áóêâû è/èëè öèôðû!")
            elseif ffi.string(input_cmd) == '' then
                imgui.BulletText(u8 " Êîìàíäà íå ìîæåò áûòü ïóñòàÿ!")
            end
            if ffi.string(input_description) == '' then
                imgui.BulletText(u8 " Îïèñàíèå êîìàíäû íå ìîæåò áûòü ïóñòîå!")
            end
            if ffi.string(input_text) == '' then
                imgui.BulletText(u8 " Áèíä êîìàíäû íå ìîæåò áûòü ïóñòîé!")
            end
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Çàêðûòü', imgui.ImVec2(300 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.End()
    end
)


function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextColoredRGB(text)
end

function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end

function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextColored(imgui_RGBA, text)
end

function imgui.CenterColumnInputText(text, v, size)
    if text:find('^(.+)##(.+)') then
        local text1, text2 = text:match('(.+)##(.+)')
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - (imgui.CalcTextSize(text1).x / 2) -
            (imgui.CalcTextSize(v).x / 2))
    elseif text:find('^##(.+)') then
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - (imgui.CalcTextSize(v).x / 2))
    else
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - (imgui.CalcTextSize(text).x / 2) -
            (imgui.CalcTextSize(v).x / 2))
    end

    if imgui.InputText(text, v, size) then
        return true
    else
        return false
    end
end

function imgui.CenterColumnButton(text)
    if text:find('(.+)##(.+)') then
        local text1, text2 = text:match('(.+)##(.+)')
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
    else
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    end

    if imgui.Button(text) then
        return true
    else
        return false
    end
end

function imgui.CenterColumnSmallButton(text)
    if text:find('(.+)##(.+)') then
        local text1, text2 = text:match('(.+)##(.+)')
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
    else
        imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    end

    if imgui.SmallButton(text) then
        return true
    else
        return false
    end
end

function imgui.CenterTextDisabled(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX(width / 2 - calc.x / 2)
    imgui.TextDisabled(text)
end

function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() -- øèðèíû êîíòåêñòà îêíî
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or
        width / count -
        ((space * (count - 1)) / count) -- âåðíåòñÿ ñðåäíèå øèðèíû ïî êîëè÷åñòâó
end

function openLink(link)
    if isMonetLoader() then
        local gta = ffi.load('GTASA')
        ffi.cdef [[
			void _Z12AND_OpenLinkPKc(const char* link);
		]]
        gta._Z12AND_OpenLinkPKc(link)
    else
        os.execute("explorer " .. link)
    end
end

function play_error_sound()
    if not isMonetLoader() and sampIsLocalPlayerSpawned() then
        addOneOffSound(getCharCoordinates(PLAYER_PED), 1149)
    end
end

local russian_characters = {
    [168] = '¨',
    [184] = '¸',
    [192] = 'À',
    [193] = 'Á',
    [194] = 'Â',
    [195] = 'Ã',
    [196] = 'Ä',
    [197] = 'Å',
    [198] = 'Æ',
    [199] = 'Ç',
    [200] = 'È',
    [201] = 'É',
    [202] = 'Ê',
    [203] = 'Ë',
    [204] = 'Ì',
    [205] = 'Í',
    [206] = 'Î',
    [207] = 'Ï',
    [208] = 'Ð',
    [209] = 'Ñ',
    [210] = 'Ò',
    [211] = 'Ó',
    [212] = 'Ô',
    [213] = 'Õ',
    [214] = 'Ö',
    [215] = '×',
    [216] = 'Ø',
    [217] = 'Ù',
    [218] = 'Ú',
    [219] = 'Û',
    [220] = 'Ü',
    [221] = 'Ý',
    [222] = 'Þ',
    [223] = 'ß',
    [224] = 'à',
    [225] = 'á',
    [226] = 'â',
    [227] = 'ã',
    [228] = 'ä',
    [229] = 'å',
    [230] = 'æ',
    [231] = 'ç',
    [232] = 'è',
    [233] = 'é',
    [234] = 'ê',
    [235] = 'ë',
    [236] = 'ì',
    [237] = 'í',
    [238] = 'î',
    [239] = 'ï',
    [240] = 'ð',
    [241] = 'ñ',
    [242] = 'ò',
    [243] = 'ó',
    [244] = 'ô',
    [245] = 'õ',
    [246] = 'ö',
    [247] = '÷',
    [248] = 'ø',
    [249] = 'ù',
    [250] = 'ú',
    [251] = 'û',
    [252] = 'ü',
    [253] = 'ý',
    [254] = 'þ',
    [255] = 'ÿ',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then           -- ¨
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then           -- ¸
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function TranslateNick(name)
    if name:match('%a+') then
        for k, v in pairs({ ['ph'] = 'ô', ['Ph'] = 'Ô', ['Ch'] = '×', ['ch'] = '÷', ['Th'] = 'Ò', ['th'] = 'ò', ['Sh'] = 'Ø', ['sh'] = 'ø', ['ea'] = 'è', ['Ae'] = 'Ý', ['ae'] = 'ý', ['size'] = 'ñàéç', ['Jj'] = 'Äæåéäæåé', ['Whi'] = 'Âàé', ['lack'] = 'ëýê', ['whi'] = 'âàé', ['Ck'] = 'Ê', ['ck'] = 'ê', ['Kh'] = 'Õ', ['kh'] = 'õ', ['hn'] = 'í', ['Hen'] = 'Ãåí', ['Zh'] = 'Æ', ['zh'] = 'æ', ['Yu'] = 'Þ', ['yu'] = 'þ', ['Yo'] = '¨', ['yo'] = '¸', ['Cz'] = 'Ö', ['cz'] = 'ö', ['ia'] = 'ÿ', ['ea'] = 'è', ['Ya'] = 'ß', ['ya'] = 'ÿ', ['ove'] = 'àâ', ['ay'] = 'ýé', ['rise'] = 'ðàéç', ['oo'] = 'ó', ['Oo'] = 'Ó', ['Ee'] = 'È', ['ee'] = 'è', ['Un'] = 'Àí', ['un'] = 'àí', ['Ci'] = 'Öè', ['ci'] = 'öè', ['yse'] = 'óç', ['cate'] = 'êåéò', ['eow'] = 'ÿó', ['rown'] = 'ðàóí', ['yev'] = 'óåâ', ['Babe'] = 'Áýéáè', ['Jason'] = 'Äæåéñîí', ['liy'] = 'ëèé', ['ane'] = 'åéí', ['ame'] = 'åéì' }) do
            name = name:gsub(k, v)
        end
        for k, v in pairs({ ['B'] = 'Á', ['Z'] = 'Ç', ['T'] = 'Ò', ['Y'] = 'É', ['P'] = 'Ï', ['J'] = 'Äæ', ['X'] = 'Êñ', ['G'] = 'Ã', ['V'] = 'Â', ['H'] = 'Õ', ['N'] = 'Í', ['E'] = 'Å', ['I'] = 'È', ['D'] = 'Ä', ['O'] = 'Î', ['K'] = 'Ê', ['F'] = 'Ô', ['y`'] = 'û', ['e`'] = 'ý', ['A'] = 'À', ['C'] = 'Ê', ['L'] = 'Ë', ['M'] = 'Ì', ['W'] = 'Â', ['Q'] = 'Ê', ['U'] = 'À', ['R'] = 'Ð', ['S'] = 'Ñ', ['zm'] = 'çüì', ['h'] = 'õ', ['q'] = 'ê', ['y'] = 'è', ['a'] = 'à', ['w'] = 'â', ['b'] = 'á', ['v'] = 'â', ['g'] = 'ã', ['d'] = 'ä', ['e'] = 'å', ['z'] = 'ç', ['i'] = 'è', ['j'] = 'æ', ['k'] = 'ê', ['l'] = 'ë', ['m'] = 'ì', ['n'] = 'í', ['o'] = 'î', ['p'] = 'ï', ['r'] = 'ð', ['s'] = 'ñ', ['t'] = 'ò', ['u'] = 'ó', ['f'] = 'ô', ['x'] = 'x', ['c'] = 'ê', ['``'] = 'ú', ['`'] = 'ü', ['_'] = ' ' }) do
            name = name:gsub(k, v)
        end
        return name
    end
    return name
end

function isParamSampID(id)
    id = tonumber(id)
    if id ~= nil and tostring(id):find('%d') and not tostring(id):find('%D') and string.len(id) >= 1 and string.len(id) <= 3 then
        if id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
            return true
        elseif sampIsPlayerConnected(id) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function imgui.ToggleButton(label, label_true, bool, a_speed)
    local p          = imgui.GetCursorScreenPos()
    local dl         = imgui.GetWindowDrawList()

    local bebrochka  = false

    local label      = label or ""                          -- Òåêñò false
    local label_true = label_true or ""                     -- Òåêñò true
    local h          = imgui.GetTextLineHeightWithSpacing() -- Âûñîòà êíîïêè
    local w          = h * 1.7                              -- Øèðèíà êíîïêè
    local r          = h / 2                                -- Ðàäèóñ êðóæêà
    local s          = a_speed or 0.2                       -- Ñêîðîñòü àíèìàöèè

    local x_begin    = bool[0] and 1.0 or 0.0
    local t_begin    = bool[0] and 0.0 or 1.0

    if LastTime == nil then
        LastTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end

    if imgui.InvisibleButton(label, imgui.ImVec2(w, h)) then
        bool[0] = not bool[0]
        LastTime[label] = os.clock()
        LastActive[label] = true
        bebrochka = true
    end

    if LastActive[label] then
        local time = os.clock() - LastTime[label]
    end

    local bg_color = imgui.ImVec4(x_begin * 0.13, x_begin * 0.9, x_begin * 0.13, imgui.IsItemHovered(0) and 0.7 or 0.9) -- Öâåò ïðÿìîóãîëüíèêà
    local t_color  = imgui.ImVec4(1, 1, 1, x_begin)                                                                     -- Öâåò òåêñòà ïðè false
    local t2_color = imgui.ImVec4(1, 1, 1, t_begin)                                                                     -- Öâåò òåêñòà ïðè true

    dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + w, p.y + h), imgui.GetColorU32Vec4(bg_color), r)
    dl:AddCircleFilled(imgui.ImVec2(p.x + r + x_begin * (w - r * 2), p.y + r),
        t_begin < 0.5 and x_begin * r or t_begin * r, imgui.GetColorU32Vec4(imgui.ImVec4(0.9, 0.9, 0.9, 1.0)), r + 5)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)),
        imgui.GetColorU32Vec4(t_color), label_true)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)),
        imgui.GetColorU32Vec4(t2_color), label)
    return bebrochka
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    while not sampIsLocalPlayerSpawned() do wait(100) end
    --nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"
    myId = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    buttons = readButtons()
    loadNotesFromFile()
    timerMain()
    check_update()
    loadCommands()
    loadButtons()
    loadLog()
    checkUser()
    sampRegisterChatCommand('mvd', function()
        window[0] = not window[0]
    end)
    sampRegisterChatCommand('spawncars', spcars)
    sampRegisterChatCommand('toset', function()
        settingsonline[0] = not settingsonline[0]
    end)
    sampRegisterChatCommand("su", cmd_su)
    sampRegisterChatCommand("stop",function()
            if isActiveCommand then
                command_stop = true
            else
                sampAddChatMessage(
                    '[Binder] {ffffff}Îøèáêà, ñåé÷àñ íåòó àêòèâíîé îòûãðîâêè!', message_color)
            end 
    end)
    registerCommandsFrom(settings.commands)
    msg("Ñêðèïò óñïåøíî çàãðóæåí! Telegram-êàíàë: @lua_arz. Ïðè ïîääåðæêå arzfun.com")
    if spawn then
        sampSendChat("/stats")
    end 
    
    while true do
        wait(0)
        if not fastVzaimWindow[0] and not vzaimWindow[0] then
            if #get_players_in_radius() >= 1 then
                vzWindow[0] = true
            else
                vzWindow[0] = false
            end
        end
    end
end
function timerMain()
    if cfg.statTimers.server ~= nil and cfg.statTimers.server ~= sampGetCurrentServerAddress() then
        msg('Âû çàøëè íà ñâîé íå îñíîâíîé ñåðâåð. Ñêðèïò îòêëþ÷¸í!')
        thisScript():unload()
    end
    if mainIni.settings.button then
        megafon[0] = true
    end
    if isPatrolActive then
        patrool_time = os.difftime(os.time(), patrool_start_time)
    end
    if not doesDirectoryExist(getWorkingDirectory() .. '/MVDHelper') then
        createDirectory(getWorkingDirectory() ..'/MVDHelper')
    end
    if cfg.onDay.today ~= os.date("%a") then
        cfg.onDay.today = os.date("%a")
        cfg.onDay.online = 0
        cfg.onDay.full = 0
        cfg.onDay.afk = 0
        dayFull[0] = 0
        inicfg.save(mainIni, 'mvdhelper.ini')
    end
    if cfg.onWeek.week ~= number_week() then
        cfg.onWeek.week = number_week()
        cfg.onWeek.online = 0
        cfg.onWeek.full = 0
        cfg.onWeek.afk = 0
        weekFull[0] = 0
        for _, v in pairs(cfg.myWeekOnline) do v = 0 end
        inicfg.save(mainIni, 'mvdhelper.ini')
    end

    lua_thread.create(time)
    lua_thread.create(autoSave)
end


function httpRequest(method, request, args, handler) -- lua-requests
    if not copas.running then
        copas.running = true
        lua_thread.create(function()
            wait(0)
            while not copas.finished() do
                local ok, err = copas.step(0)
                if ok == nil then error(err) end
                wait(0)
            end
            copas.running = false
        end)
    end
    -- do request
    if handler then
        return copas.addthread(function(m, r, a, h)
            copas.setErrorHandler(function(err) h(nil, err) end)
            h(requests.request(m, r, a))
        end, method, request, args, handler)
    else
        local results
        local thread = copas.addthread(function(m, r, a)
            copas.setErrorHandler(function(err) results = { nil, err } end)
            results = table.pack(requests.request(m, r, a))
        end, method, request, args)
        while coroutine.status(thread) ~= 'dead' do wait(0) end
        return table.unpack(results)
    end
end

function spcars(arg)
    if arg == "" then
        msg("Èñïîëüçóéòå: /spcars (5 - 120)", -1)
    else
        lua_thread.create(function()
            sampSendChat("/rb Óâàæàåìûå ñîòðóäíèêè, ÷åðåç " .. arg .. " ñåêóíä áóäåò ñïàâí âñåãî òðàíñïîðòà îðãàíèçàöèè!")
            wait(1000)
            sampSendChat("/rb Çàéìèòå ñâîé òðàíñïîðò, â ïðîòèâíîì ñëó÷àå îí ïðîïàäåò!")
            wait(arg * 1000)
            spawncar_bool = true
            sampSendChat("/lmenu")
        end)
    end
end

function cmd_su(p_id)
    if p_id == "" then
        msg("Ââåäè àéäè èãðîêà: {FFFFFF}/su [ID].", 0x318CE7FF - 1)
    else
        id = imgui.new.int(tonumber(p_id))
        windowTwo[0] = not windowTwo[0]
    end
end

local ObuchalName = new.char[255](u8(mainIni.settings.ObuchalName))
local pages = {
    { icon = faicons("HOUSE"), title = "  Ãëàâíàÿ", index = 8 },
    { icon = faicons("BOOK"), title = "  Áèíäåð", index = 2 },
    { icon = faicons("TOWER_BROADCAST"), title = "  Ãîñ. âîëíà ", index = 3 },
    { icon = faicons("RECTANGLE_LIST"), title = "  Çàìåòêè", index = 5 },
    { icon = faicons("CIRCLE_INFO"), title = "  Èíôî", index = 6 },
    { icon = faicons("GEAR"), title = "  Íàñòðîéêè", index = 1 },
}

imgui.OnFrame(function() return menuSizes[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 300), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Íàñòðîéêè îêíà', menuSizes)
    imgui.SliderInt(u8 "Øèðèíà îêíà", xsize, 200, 1000)
    imgui.SliderInt(u8 "Âûñîòà îêíà", ysize, 200, 1000)
    imgui.SliderInt(u8 "Øèðèíà òàá áàðà", tabsize, 100, 700)
    if copMenu[0] then
        imgui.SliderInt(u8 "Ïîëîæåíèå ñíåæèíêè â òàá áàðå", snegPos, 10, 500)
    else
        imgui.SliderInt(u8 "Ïîëîæåíèå êîïà â òàá áàðå", copPos, 10, 500)
    end
    imgui.SliderInt(u8 "Ïîëîæåíèå êðåñòèêà", xpos, 1, 1000)
    imgui.SliderInt(u8 "Ïîëîæåíèå îáâîäêè âûáðàííîãî òàáà", vtpos, 1, 15)
    imgui.SliderInt(u8 "Çàêðóãëåíèå îêíà è ÷àèëäîâ(íóæíî áóäåò ïåðåçàãðóçèòü ñêðèïò)", childRounding, 0, 25)


    --Òåìû
    if imgui.Combo(u8 'Òåìû', selected_theme, items, #theme_a) then
        themeta = theme_t[selected_theme[0] + 1]
        mainIni.theme.themeta = themeta
        mainIni.theme.selected = selected_theme[0]
        inicfg.save(mainIni, 'mvdhelper.ini')
        apply_n_t()
    end
    imgui.Text(u8 'Öâåò MoonMonet - ')
    imgui.SameLine()
    if imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
        r, g, b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
        argb = join_argb(0, r, g, b)
        mainIni.theme.moonmonet = argb
        inicfg.save(mainIni, 'mvdhelper.ini')
        apply_n_t()
    end
    --Êîíåö òåì
    mainIni.menuSettings.x = xsize[0]
    mainIni.menuSettings.y = ysize[0]
    mainIni.menuSettings.tab = tabsize[0]
    mainIni.menuSettings.snegPos = snegPos[0]
    mainIni.menuSettings.copPos = copPos[0]
    mainIni.menuSettings.xpos = xpos[0]
    mainIni.menuSettings.vtpos = vtpos[0]
    mainIni.menuSettings.ChildRoundind = childRounding[0]
    if imgui.Button(u8 "Ñîõðàíèòü") then
        inicfg.save(mainIni, "mvdhelper.ini")
    end
    imgui.End()
end)


imgui.OnFrame(function() return vzWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.3), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8 '', vzWindow,
        imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
    if imgui.Button(u8 "Âçàèìîäåéñòâèå") then
        if #get_players_in_radius() == 1 then
            id = imgui.new.int(get_players_in_radius()[1])
            fastVzaimWindow[0] = true
            vzWindow[0] = false
        elseif #get_players_in_radius() > 1 then
            vzaimWindow[0] = true
            vzWindow[0] = false
        end
    end
    imgui.End()
end)


imgui.OnFrame(function() return vzaimWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Âçàèìîäåéñòâèå', vzaimWindow)
    imgui.Text(u8 "Âûáåðèòå èãðîêà äëÿ âçàèìîäåéñòâèÿ")
    for i = 1, #get_players_in_radius() do
        if imgui.Button(u8(sampGetPlayerNickname(get_players_in_radius()[i]))) then
            id = imgui.new.int(get_players_in_radius()[i])
            fastVzaimWindow[0] = true
            vzaimWindow[0] = false
        end
    end
    imgui.End()
end)

imgui.OnFrame(function() return fastVzaimWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Âçàèìîäåéñòâèå ñ ' .. sampGetPlayerNickname(id[0]), fastVzaimWindow)
    if imgui.Button(u8 'Ïðèâåòñòâèå') then
        lua_thread.create(function()
            sampSendChat("Äîáðîãî âðåìåíè ñóòîê, ÿ «" .. nickname .. "» «" .. u8:decode(mainIni.Info.dl) .. "».")
            wait(1500)
            sampSendChat("/do Óäîñòîâåðåíèå â ðóêàõ.")
            wait(1500)
            sendMe(" ïîêàçàë ñâî¸ óäîñòîâåðåíèå ÷åëîâåêó íà ïðîòèâ")
            wait(1500)
            sampSendChat("/do «" .. nickname .. "».")
            wait(1500)
            sampSendChat("/do «" .. u8:decode(mainIni.Info.dl) .. "» " .. mainIni.Info.org .. ".")
            wait(1500)
            sampSendChat("Ïðåäúÿâèòå âàøè äîêóìåíòû, à èìåííî ïàñïîðò. Íå áåñïîêîéòåñü, ýòî âñåãî ëèøü ïðîâåðêà.")
            wait(1500)
            sampSendChat("/showbadge ")
        end)
    end
    if imgui.Button(u8 'Íàéòè èãðîêà') then
        lua_thread.create(function()
            sampSendChat("/do ÊÏÊ â ëåâîì êàðìàíå.")
            wait(1500)
            sendMe(" äîñòàë ëåâîé ðóêîé ÊÏÊ èç êàðìàíà")
            wait(1500)
            sampSendChat("/do ÊÏÊ â ëåâîé ðóêå.")
            wait(1500)
            sendMe(" âêëþ÷èë ÊÏÊ è çàøåë â áàçó äàííûõ Ïîëèöèè")
            wait(1500)
            sendMe(" îòêðûë äåëî íîìåð " .. id[0] .. " ïðåñòóïíèêà")
            wait(1500)
            sampSendChat("/do Äàííûå ïðåñòóïíèêà ïîëó÷åíû.")
            wait(1500)
            sendMe(" ïîäêëþ÷èëñÿ ê êàìåðàì ñëåæåíèÿ øòàòà")
            wait(1500)
            sampSendChat("/do Íà íàâèãàòîðå ïîÿâèëñÿ ìàðøðóò.")
            wait(1500)
            sampSendChat("/pursuit " .. id[0])
        end)
    end
    if imgui.Button(u8 'Àðåñò') then
        lua_thread.create(function()
            sendMe(" âçÿë ðó÷êó èç êàðìàíà ðóáàøêè, çàòåì îòêðûë áàðäà÷îê è âçÿë îòòóäà áëàíê ïðîòîêîëà")
            wait(1500)
            sampSendChat("/do Áëàíê ïðîòîêîëà è ðó÷êà â ðóêàõ.")
            wait(1500)
            sendMe(" çàïîëíÿåò îïèñàíèå âíåøíîñòè íàðóøèòåëÿ")
            wait(1500)
            sendMe(" çàïîëíÿåò õàðàêòåðèñòèêó î íàðóøèòåëå")
            wait(1500)
            sendMe(" çàïîëíÿåò äàííûå î íàðóøåíèè")
            wait(1500)
            sendMe(" ïðîñòàâèë äàòó è ïîäïèñü")
            wait(1500)
            sendMe(" ïîëîæèë ðó÷êó â êàðìàí ðóáàøêè")
            wait(1500)
            sampSendChat("/do Ðó÷êà â êàðìàíå ðóáàøêè.")
            wait(1500)
            sendMe(" ïåðåäàë áëàíê ñîñòàâëåííîãî ïðîòîêîëà â ó÷àñòîê")
            wait(1500)
            sendMe(" ïåðåäàë ïðåñòóïíèêà â Óïðàâëåíèå Ïîëèöèè ïîä ñòðàæó")
            wait(1500)
            sampSendChat("/arrest")
            msg("Âñòàíüòå íà ÷åêïîèíò", 0x8B00FF)
        end)
    end
    if imgui.Button(u8 'Íàäåòü íàðó÷íèêè') then
        lua_thread.create(function()
            sampSendChat("/do Íàðó÷íèêè âèñÿò íà ïîÿñå.")
            wait(1500)
            sendMe(" ñíÿë ñ äåðæàòåëÿ íàðó÷íèêè")
            wait(1500)
            sampSendChat("/do Íàðó÷íèêè â ðóêàõ.")
            wait(1500)
            sendMe(" ðåçêèì äâèæåíèåì îáåèõ ðóê, íàäåë íàðó÷íèêè íà ïðåñòóïíèêà")
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
            sendMe(" äâèæåíèåì ïðàâîé ðóêè äîñòàë èç êàðìàíà êëþ÷ è îòêðûë íàðó÷íèêè")
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
            sendMe(" âåäåò íàðóøèòåëÿ çà ñîáîé")
            wait(1500)
            sampSendChat("/gotome " .. id[0])
        end)
    end
    if imgui.Button(u8 'Ïåðåñòàòü âåñòè çà ñîáîé') then
        lua_thread.create(function()
            sendMe(" îòïóñòèë ïðàâóþ ðóêó ïðåñòóïíèêà")
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
            sendMe(" îòêðûë çàäíþþ äâåðü â ìàøèíå")
            wait(1500)
            sendMe(" ïîñàäèë ïðåñòóïíèêà â ìàøèíó")
            wait(1500)
            sendMe(" çàáëîêèðîâàë äâåðè")
            wait(1500)
            sampSendChat("/do Äâåðè çàáëîêèðîâàíû.")
            wait(1500)
            sampSendChat("/incar " .. id[0] .. "3")
        end)
    end
    if imgui.Button(u8 'Îáûñê') then
        lua_thread.create(function()
            sendMe(" íûðíóâ ðóêàìè â êàðìàíû, âûòÿíóë îòòóäà áåëûå ïåð÷àòêè è íàòÿíóë èõ íà ðóêè")
            wait(1500)
            sampSendChat("/do Ïåð÷àòêè íàäåòû.")
            wait(1500)
            sendMe(" ïðîâîäèò ðóêàìè ïî âåðõíåé ÷àñòè òåëà")
            wait(1500)
            sendMe(" ïðîâåðÿåò êàðìàíû")
            wait(1500)
            sendMe(" ïðîâîäèò ðóêàìè ïî íîãàì")
            wait(1500)
            sampSendChat("/frisk " .. id[0])
        end)
    end
    if imgui.Button(u8 'Ìåãàôîí') then
        lua_thread.create(function()
            sampSendChat("/do Ìåãàôîí â áàðäà÷êå.")
            wait(1500)
            sendMe(" äîñòàë ìåãàôîí ñ áàðäà÷êà ïîñëå ÷åãî âêëþ÷èë åãî")
            wait(1500)
            sampSendChat("/m Âîäèòåëü àâòî, îñòàíîâèòåñü è çàãëóøèòå äâèãàòåëü, äåðæèòå ðóêè íà ðóëå.")
        end)
    end
    if imgui.Button(u8 'Âûòàùèòü èç àâòî') then
        lua_thread.create(function()
            sendMe(" ñíÿâ äóáèíêó ñ ïîÿñíîãî äåðæàòåëÿ ðàçáèë ñòåêëî â òðàíñïîðòå")
            wait(1500)
            sampSendChat("/do Ñòåêëî ðàçáèòî.")
            wait(1500)
            sendMe(" ñõâàòèâ çà ïëå÷è ÷åëîâåêà óäàðèë åãî ïîñëå ÷åãî íàäåë íàðó÷íèêè")
            wait(1500)
            sampSendChat("/pull " .. id[0])
            wait(1500)
            sampSendChat("/cuff " .. id[0])
        end)
    end
    if imgui.Button(u8 'Âûäà÷à ðîçûñêà') then
        windowTwo[0] = not windowTwo[0]
    end
    imgui.End()
end)

function loadCommands()
    local file = io.open(jsonFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local decodedJson = decodeJson(content)
        if decodedJson then
            gunCommands = decodedJson
            print("Çàãðóæåíî èç ôàéëà:", gunCommands)
        else
          msg("Îøèáêà äåêîäèðîâàíèÿ JSON. Çàãðóæàþ ñòàíäàðòíûå.")
          saveCommands()
        end
    else
        msg("Íå óäàëîñü çàãðóçèòü JSON ôàéë ñ îòûãðîâêàìè îðóæèé. Çàãðóæàþ ñòàíäàðòíûå")
        saveCommands()
    end
end

function saveCommands()
    if not doesDirectoryExist(getWorkingDirectory() .. '/MVDHelper') then
        createDirectory(getWorkingDirectory() ..
            '/MVDHelper')
    end
    local file = io.open(jsonFile, "w")
    if file then
        file:write(encodeJson(gunCommands, { indent = true }))
        file:close()
    else
        msg("Íå óäàëîñü îòêðûòü ôàéë äëÿ çàïèñè!")
    end
end

loadCommands()
print("Òåêóùèå êîìàíäû:", gunCommands)

local selectedGun = nil

imgui.OnFrame(function() return gunsWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Èçìåíåíèå îòûãðîâîê îðóæèÿ', gunsWindow)
    imgui.Text(u8 "Âûáåðèòå îðóæèå")

    for i = 1, #weapons do
        if imgui.Button(u8(weapons[i])) then
            selectedGun = i

            local command = gunCommands[i]
            otInput = imgui.new.char[255](u8(command))
            msg("Âûáðàíî îðóæèå: " .. weapons[i] .. " Êîìàíäà: " .. command)
        end
        if selectedGun ~= nil and selectedGun ~= "" and selectedGun == i then
            imgui.SameLine()
            imgui.Text(u8("Âû âûáðàëè " .. weapons[selectedGun]))
            imgui.InputText(u8 "Îòûãðîâêà", otInput, 255)
            if imgui.Button(u8 "Ñîõðàíèòü", imgui.ImVec2(100, 50)) then
                gunCommands[selectedGun] = ffi.string(otInput)
                saveCommands()
                msg("Îòûãðîâêè ñîõðàíåíû")
            end
        end
    end

    imgui.End()
end)

local mainMenuFrame = imgui.OnFrame(function() return window[0] end, 
    function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(mainIni.menuSettings.x * MDS, mainIni.menuSettings.y), imgui.Cond.FirstUseEver)
    imgui.Begin('##Window', window,
        imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
    MainWindowPos = imgui.GetWindowPos()
    MainWindowSize = imgui.GetWindowSize()
    if menuSizes[0] then
        imgui.SetWindowSizeVec2(imgui.ImVec2(mainIni.menuSettings.x * MDS, mainIni.menuSettings.y))
    end
    imgui.BeginChild('tabs', imgui.ImVec2(mainIni.menuSettings.tab, -1), true)
    if copMenu[0] then
        p = imgui.GetCursorScreenPos()
        imgui.DrawFrames(MyGif, imgui.ImVec2(mainIni.menuSettings.tab - 60, 120), FrameTime[0])
    else
        imgui.SetCursorPosX(mainIni.menuSettings.copPos)
        -- imgui.ImageURL(
        --     "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/refs/heads/main/police.png",
        --     imgui.ImVec2(119, 141), true)
    end


    imgui.SetCursorPosY(170)
    imgui.Separator()
    for _, pageData in ipairs(pages) do
        imgui.SetCursorPosX(0)
        if imgui.PageButton(page == pageData.index, pageData.icon, u8(pageData.title), 173 * MDS - imgui.GetStyle().FramePadding.x * 2, 35 * MDS) then
            page = pageData.index
        end
    end
    imgui.CenterText("version " .. thisScript().version)
    imgui.EndChild()
    imgui.SameLine()
    -- imgui.SetCursorPosX(188*MDS)
    imgui.BeginChild('workspace', imgui.ImVec2(-1, -1), true)
    local size = imgui.GetWindowSize()
    local pos = imgui.GetWindowPos()


    local tabSize = 50

    imgui.SetCursorPos(imgui.ImVec2(size.x - mainIni.menuSettings.xpos, 5))
    if imgui.Button('X##..##Window::closebutton', imgui.ImVec2(50, 50)) then
        if window then
            window[0] = false
        end
    end

    -- imgui.SetCursorPosY(20)
    if page == 1 then -- åñëè çíà÷åíèå tab == 1
        if changingInfo then
            imgui.Text(u8 'Âàø íèê: ' .. nickname)
            imgui.Text(u8 'Âàøà îðãàíèçàöèÿ: ')
            imgui.SameLine()
            imgui.InputText("##îðãà", orga, 255)
            imgui.Text(u8 'Âàøà äîëæíîñòü: ')
            imgui.SameLine()
            imgui.InputText("##äîëæíîñòü", dolzh, 255)

            if imgui.Button(u8 "Ñîõðàíèòü äàííûå") then
                mainIni.Info.org = u8(u8:decode(ffi.string(orga)))
                mainIni.Info.dl = u8(u8:decode(ffi.string(dolzh)))
                inicfg.save(mainIni, "mvdhelper.ini")
                msg("Íàñòðîêè óñïåøíî ñîõðàíåíû!")
                changingInfo = false
            end
        else
            imgui.Text(u8 'Âàø íèê: ' .. nickname)
            imgui.Text(u8 'Âàøà îðãàíèçàöèÿ: ' .. mainIni.Info.org)
            imgui.Text(u8 'Âàøà äîëæíîñòü: ' .. mainIni.Info.dl)
            if imgui.Button(u8 "Èçìåíèòü äàííûå") then
                changingInfo = true
            end
        end
        if imgui.Button(u8 ' Íàñòðîèòü Óìíûé Ðîçûñê') then
            setUkWindow[0] = not setUkWindow[0]
        end
        imgui.ToggleButton(u8 'Àâòî îòûãðîâêà îðóæèÿ', u8 'Àâòî îòûãðîâêà îðóæèÿ', autogun)
        if autogun[0] then
            mainIni.settings.autoRpGun = true
            inicfg.save(mainIni, "mvdhelper.ini")
            lua_thread.create(function()
                while true do
                    wait(0)
                    if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
                        local gun = getCurrentCharWeapon(PLAYER_PED)
                        if gun == 3 then
                            sampSendChat(gunCommands[1])
                        elseif gun == 16 then
                            sampSendChat(gunCommands[2])
                        elseif gun == 17 then
                            sampSendChat(gunCommands[3])
                        elseif gun == 23 then
                            sampSendChat(gunCommands[4])
                        elseif gun == 22 then
                            sampSendChat(gunCommands[5])
                        elseif gun == 24 then
                            sampSendChat(gunCommands[6])
                        elseif gun == 25 then
                            sampSendChat(gunCommands[7])
                        elseif gun == 26 then
                            sampSendChat(gunCommands[8])
                        elseif gun == 27 then
                            sampSendChat(gunCommands[9])
                        elseif gun == 28 then
                            sampSendChat(gunCommands[10])
                        elseif gun == 29 then
                            sampSendChat(gunCommands[11])
                        elseif gun == 30 then
                            sampSendChat(gunCommands[12])
                        elseif gun == 31 then
                            sampSendChat(gunCommands[13])
                        elseif gun == 32 then
                            sampSendChat(gunCommands[14])
                        elseif gun == 33 then
                            sampSendChat(gunCommands[15])
                        elseif gun == 34 then
                            sampSendChat(gunCommands[16])
                        elseif gun == 43 then
                            sampSendChat(gunCommands[17])
                        elseif gun == 0 then
                            sampSendChat(gunCommands[18])
                        end
                        lastgun = gun
                    end
                end
            end)
        else
            mainIni.settings.autoRpGun = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.ToggleButton(u8 'Àâòî-Àêöåíò', u8 'Àâòî-Àêöåíò', AutoAccentBool)
        if AutoAccentBool[0] then
            AutoAccentCheck = true
            mainIni.settings.autoAccent = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.autoAccent = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        if imgui.ToggleButton(u8 'Îòîáðàæåíèå êíîïêè 10-55', u8 'Îòîáðàæåíèå êíîïêè 10-55', button_megafon) then
            mainIni.settings.button = button_megafon[0]
            megafon[0] = button_megafon[0]
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.InputText(u8 'Àêöåíò', AutoAccentInput, 255)
        AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
        mainIni.Accent.accent = AutoAccentText
        inicfg.save(mainIni, "mvdhelper.ini")

        imgui.ToggleButton(u8(mainIni.settings.ObuchalName) .. u8 ' ðàáîòàåò',
            u8(mainIni.settings.ObuchalName) .. u8 ' îòäûõàåò', joneV)
        if joneV[0] then
            mainIni.settings.Jone = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.Jone = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        if imgui.InputText(u8 "Èìÿ îáó÷àëüùèêà", ObuchalName, 255) then
            Obuchal = u8:decode(ffi.string(ObuchalName))
            mainIni.settings.ObuchalName = Obuchal
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.ToggleButton(u8 "Ïîëèöåéñêèé â ìåíþøêå", u8 "Ñíåæèíêà â ìåíþøêå", copMenu)
        if copMenu[0] then
            mainIni.settings.copMenu = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.copMenu = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        if imgui.Button(u8 "Íàñòðîéêè îêíà") then
            menuSizes[0] = not menuSizes[0]
        end
        if imgui.Button(u8 "Íàñòðîéêè îòûãðîâîê îðóæèé") then
            gunsWindow[0] = not gunsWindow[0]
        end
    elseif page == 8 then
        if imgui.Button(u8 'Ìåíþ ïàòðóëèðîâàíèÿ') then
            patroolhelpmenu[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Ïàíåëü ðóê-âà ôðàêöèè') then
            leaderPanel[0] = true
        end


        if imgui.Button(u8 'Ëîã øòðàôîâ, àððåñòîâ') then
            logsWin[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Ñ÷åò÷èê îíëàéíà') then
            settingsonline[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Âñïîìîãàòåëüíîå îêíî') then
            suppWindow[0] = not suppWindow[0]
        end
        if imgui.Button(u8 'Âûäà÷à ðîçûñêà') then
            windowTwo[0] = not windowTwo[0]
        end
        imgui.ToggleButton(u8 "Òî÷êà íà êîíöå /me ÍÅ ñòîèò", u8 "Òî÷êà íà êîíöå /me ñòîèò", tochkaMe)
    
    elseif page == 2 then -- Áèíäåð
        if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 303 * MONET_DPI_SCALE), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8"Êîìàíäà")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Îïèñàíèå")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Äåéñòâèå")
            imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/binder")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Îòêðûòü ãëàâíîå ìåíþ áèíäåðà")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Íåäîñòóïíî")
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/stop")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Îñòàíîâèòü ëþáóþ îòûãðîâêó èç áèíäåðà")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Íåäîñòóïíî")
            imgui.Columns(1)
            imgui.Separator()
            for index, command in ipairs(settings.commands) do
                if not command.deleted then
                    imgui.Columns(3)
                    if command.enable then
                        imgui.CenterColumnText('/' .. u8(command.cmd))
                        imgui.NextColumn()
                        imgui.CenterColumnText(u8(command.description))
                        imgui.NextColumn()
                    else
                        imgui.CenterColumnTextDisabled('/' .. u8(command.cmd))
                        imgui.NextColumn()
                        imgui.CenterColumnTextDisabled(u8(command.description))
                        imgui.NextColumn()
                    end
                    imgui.Text(' ')
                    imgui.SameLine()
                    if command.enable then
                        if imgui.SmallButton(fa.TOGGLE_ON .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            sampUnregisterChatCommand(command.cmd)
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Îòêëþ÷åíèå êîìàíäû /" .. command.cmd)
                        end
                    else
                        if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Âêëþ÷åíèå êîìàíäû /" .. command.cmd)
                        end
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. command.cmd) then
                        change_description = command.description
                        input_description = imgui.new.char[256](u8(change_description))
                        change_arg = command.arg
                        if command.arg == '' then
                            ComboTags[0] = 0
                        elseif command.arg == '{arg}' then
                            ComboTags[0] = 1
                        elseif command.arg == '{arg_id}' then
                            ComboTags[0] = 2
                        elseif command.arg == '{arg_id} {arg2}' then
                            ComboTags[0] = 3
                        end
                        change_cmd = command.cmd
                        input_cmd = imgui.new.char[256](u8(command.cmd))
                        change_text = command.text:gsub('&', '\n')
                        input_text = imgui.new.char[8192](u8(change_text))
                        change_waiting = command.waiting
                        waiting_slider = imgui.new.float(tonumber(command.waiting))
                        BinderWindow[0] = true
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Èçìåíåíèå êîìàíäû /" .. command.cmd)
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
                        imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd)
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Óäàëåíèå êîìàíäû /" .. command.cmd)
                    end
                    if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. command.cmd, _, imgui.WindowFlags.NoResize) then
                        imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó /' .. u8(command.cmd) .. '?')
                        imgui.Separator()
                        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            command.enable = false
                            command.deleted = true
                            sampUnregisterChatCommand(command.cmd)
                            save_settings()
                            imgui.CloseCurrentPopup()
                        end
                        imgui.End()
                    end
                    imgui.Columns(1)
                    imgui.Separator()
                end
            end
            imgui.EndChild()
        end
        if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Ñîçäàòü íîâóþ êîìàíäó##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            local new_cmd = {
                cmd = '',
                description = 'Íîâàÿ êîìàíäà ñîçäàííàÿ âàìè',
                text = '',
                arg = '',
                enable = true,
                waiting =
                '1.200',
                deleted = false
            }
            table.insert(settings.commands, new_cmd)
            change_description = new_cmd.description
            input_description = imgui.new.char[256](u8(change_description))
            change_arg = new_cmd.arg
            ComboTags[0] = 0
            change_cmd = new_cmd.cmd
            input_cmd = imgui.new.char[256](u8(new_cmd.cmd))
            change_text = new_cmd.text:gsub('&', '\n')
            input_text = imgui.new.char[8192](u8(change_text))
            change_waiting = 1.200
            waiting_slider = imgui.new.float(1.200)
            BinderWindow[0] = true
        end
        if imgui.BeginChild("buttons", imgui.ImVec2(589 * MONET_DPI_SCALE, 150), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8"Íàçâàíèå êíîïêè")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Òåêñò")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Äåéñòâèå")
            imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
            imgui.Columns(1)
            imgui.Separator()
            
            for name, command in pairs(buttons) do
                imgui.Columns(3)
                imgui.CenterColumnText(u8(name))
                imgui.NextColumn()
                imgui.CenterColumnText(u8(command[1]))
                imgui.NextColumn()
                imgui.Text(" ")
                imgui.SameLine()
                if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. name) then
                    newButtonText = imgui.new.char[255](u8(name))
                    newButtonCommand = imgui.new.char[255](u8(arrayToText(command)))
                    imgui.OpenPopup(fa.CIRCLE_PLUS .. u8 ' Èçìåíåíèå êíîïêè íà ýêðàíå')            
                end
                if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8 ' Èçìåíåíèå êíîïêè íà ýêðàíå', _, imgui.WindowFlags.NoResize) then
                    imgui.InputText(u8"Íàçâàíèå êíîïêè", newButtonText, 255)
                    imgui.InputTextMultiline(u8"Òåêñò", newButtonCommand, 2555)
                    if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                        deleteButton(name)
                        addNewButton(u8:decode(ffi.string(newButtonText)), u8:decode(ffi.string(newButtonCommand)))
                        imgui.CloseCurrentPopup()
                    end
                end
                imgui.SameLine()
                if imgui.SmallButton(fa.TRASH_CAN .. '##' .. name) then
                    imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. name)
                end
                if imgui.IsItemHovered() then
                    imgui.SetTooltip(u8 "Óäàëåíèå êíîïêè " .. name)
                end
                imgui.Columns(1)
                imgui.Separator()
                if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ïðåäóïðåæäåíèå ##' .. name, _, imgui.WindowFlags.NoResize) then
                    imgui.CenterText(u8 'Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êíîïêó ' .. u8(name) .. '?')
                    imgui.Separator()
                    if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Íåò, îòìåíèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(fa.TRASH_CAN .. u8 ' Äà, óäàëèòü', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                        deleteButton(name)
                    end
                    imgui.End()
                end
            end
            imgui.EndChild()
        end
            if imgui.Button(fa.CIRCLE_PLUS .. u8" Íîâàÿ êíîïêà") then
                imgui.OpenPopup(fa.CIRCLE_PLUS .. u8 ' Ñîçäàíèå íîâîé êíîïêè íà ýêðàíå')            
            end
            

    elseif page == 3 then -- Ðàöèÿ äåïîðòàìåíòà
        imgui.BeginChild('##depbuttons',
            imgui.ImVec2((imgui.GetWindowWidth() * 0.35) - imgui.GetStyle().FramePadding.x * 2, 0), true,
            imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
        imgui.TextColoredRGB(u8 'Òýã âàøåé îðãàíèçàöèè', 1)
        if imgui.InputText('##myorgnamedep', orgname, 255) then
            departsettings.myorgname = u8:decode(str(orgname))
        end
        imgui.TextColoredRGB(u8 'Òýã ñ êåì ñâÿçûâàåòåñü')
        imgui.InputText('##toorgnamedep', otherorg, 255)
        imgui.Separator()
        if imgui.Button(u8 'Ðàöèÿ óïàëà.') then
            if #str(departsettings.myorgname) > 0 then
                sampSendChat('/d [' .. (str(departsettings.myorgname)) .. '] - [Âñåì]: Ðàöèÿ óïàëà.')
            else
                msg('Ó Âàñ ÷òî-òî íå óêàçàíî.')
            end
        end
        imgui.Separator()
        imgui.TextColoredRGB(u8 '×àñòîòà (íå Îáÿçàòåëüíî)')
        imgui.PushItemWidth(200)
        imgui.InputText('##frequencydep', departsettings.frequency, 255)
        imgui.PopItemWidth()

        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginChild('##deptext', imgui.ImVec2(-1, -1), true, imgui.WindowFlags.NoScrollbar)
        imgui.TextColoredRGB(u8 'Èñòîðèÿ ñîîáùåíèé äåïàðòàìåíòà {808080}(?)')
        imgui.Hint('mytagfind depart',
            u8 'Åñëè â ÷àòå äåïàðòàìåíòà áóäåò òýã \'' ..
            (str(departsettings.myorgname)) .. u8 '\'\nâ ýòîò ñïèñîê äîáàâèòñÿ ýòî ñîîáùåíèå')
        imgui.Separator()
        imgui.BeginChild('##deptextlist',
            imgui.ImVec2(-1,
                imgui.GetWindowSize().y - 30 * MDS - imgui.GetStyle().FramePadding.y * 2 - imgui.GetCursorPosY()), false)
        for k, v in pairs(dephistory) do
            imgui.TextColoredRGB('{5975ff}' .. (u8(v)))
        end
        imgui.EndChild()
        imgui.SetNextItemWidth(imgui.GetWindowWidth() - 100 * MDS - imgui.GetStyle().FramePadding.x * 2)
        imgui.InputText('##myorgtextdep', departsettings.myorgtext, 255)
        imgui.SameLine()
        if imgui.Button(u8 'Îòïðàâèòü', imgui.ImVec2(0, 30 * MDS)) then
            if #str(departsettings.myorgname) > 0 then
                if #str(departsettings.frequency) == 0 then
                    sampSendChat(('/d [%s] - [%s] %s'):format(str(departsettings.myorgname),
                        u8:decode(str(otherorg)), u8:decode(str(departsettings.myorgtext))))
                else
                    sampSendChat(('/d [%s] - %s - [%s] %s'):format(str(departsettings.myorgname),
                        u8:decode(str(departsettings.frequency)), u8:decode(str(otherorg)),
                        u8:decode(str(departsettings.myorgtext))))
                end
                imgui.StrCopy(departsettings.myorgtext, '')
            else
                msg('Ó âàñ ÷òî-òî íå óêàçàíî!')
            end
        end
        imgui.EndChild()
    elseif page == 5 then -- Çàåìòêè
        allNotes()
        imgui.Separator()
        if imgui.Button(u8 "Äîáàâèòü íîâóþ çàìåòêó", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            imgui.StrCopy(newNoteTitle, "")
            imgui.StrCopy(newNoteContent, "")
            imgui.OpenPopup(u8 "Äîáàâèòü íîâóþ çàìåòêó")
            showAddNotePopup[0] = true
        end
        if imgui.BeginPopupModal(u8 "Ðåäàêòèðîâàòü çàìåòêó", showEditWindow, imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8 'Íàçâàíèå çàìåòêè')
            imgui.InputText(u8 "##nazvanie", editNoteTitle, 256)
            imgui.Text(u8 "Òåêñò çàìåòêè")
            imgui.InputTextMultiline(u8 "##2663737374", editNoteContent, 1024,
                imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
            if imgui.Button(u8 "Ñîõðàíèòü", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                notes[selectedNote].title = ffi.string(editNoteTitle)
                notes[selectedNote].content = ffi.string(editNoteContent)
                showEditWindow[0] = false
                imgui.CloseCurrentPopup()
                selectedNote = nil
                saveNotesToFile()
            end
            imgui.SameLine()
            if imgui.Button(u8 "Îòìåíèòü", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                showEditWindow[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.EndPopup()
        end
        if imgui.BeginPopupModal(u8 "Äîáàâèòü íîâóþ çàìåòêó", showAddNotePopup, imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8 'Íàçâàíèå íîâîé çàìåòêè')
            imgui.InputText(u8 "##nazvanie2", newNoteTitle, 256)
            imgui.Text(u8 'Òåêñò íîâîé çàìåòêè')
            imgui.InputTextMultiline(u8 "##123123123", newNoteContent, 1024, imgui.ImVec2(-1, 100))
            if imgui.Button(u8 "Ñîõðàíèòü", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                table.insert(notes, { title = ffi.string(newNoteTitle), content = ffi.string(newNoteContent) })
                imgui.StrCopy(newNoteTitle, "")
                imgui.StrCopy(newNoteContent, "")
                saveNotesToFile()
                showAddNotePopup[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
            if imgui.Button(u8 "Çàêðûòü", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                imgui.CloseCurrentPopup()
            end
            if imgui.Button(u8 "Óäàëèòü", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                imgui.StrCopy(newNoteTitle, "")
                imgui.StrCopy(newNoteContent, "")
                showAddNotePopup[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.EndPopup()
        end
    elseif page == 6 then -- Èíôîðìàöèÿ
        imgui.Text(u8 'Âåðñèÿ: ' .. thisScript().version)
        imgui.Text(u8 'Ðàçðàáîò÷èêè: https://t.me/Sashe4ka_ReZoN, https://t.me/daniel2903_pon, https://t.me/makson4ck2')
        imgui.Text(u8 'ÒÃ êàíàë: t.me/lua_arz')
        imgui.Text(u8 'Ïîääåðæàòü: Âðåìåííî íå äîñòóïíî')
        imgui.Text(u8 'Ñïîíñîðû: @Negt,@King_Rostislavia,@sidrusha,@Timur77998, @osp_x, @Theopka')
    
    end
    imgui.EndChild()
    imgui.End()
end)

function allNotes() 
    for i, note in ipairs(notes) do
        showNoteWindows[i] = false
        showEditWindows[i] = false
        imgui.Text(note.title)
        imgui.SameLine()
        if imgui.Button(u8 "Îòêðûòü##" .. i) then
            note_name = note.title
            note_text = note.content
            NoteWindow[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 "Ðåäàêòèðîâàòü##" .. i) then
            selectedNote = i
            imgui.StrCopy(editNoteTitle, note.title)
            imgui.StrCopy(editNoteContent, note.content)
            imgui.OpenPopup(u8 "Ðåäàêòèðîâàòü çàìåòêó")
            showEditWindow[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 "Óäàëèòü##" .. i) then
            table.remove(notes, i)
            saveNotesToFile()
        end
    end
end

imgui.OnFrame(
    function() return NoteWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(note_name, NoteWindow, imgui.WindowFlags.AlwaysAutoResize)
        imgui.Text(note_text:gsub('&', '\n'))
        imgui.Separator()
        if imgui.Button(u8 ' Çàêðûòü', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
            NoteWindow[0] = false
        end
        imgui.End()
    end
)
function DownloadUk()
    local serverLower = string.lower(server) -- Ïðèâîäèì èìÿ ñåðâåðà ê íèæíåìó ðåãèñòðó äëÿ åäèíîîáðàçèÿ

    local url = smartUkUrl[serverLower]

    if url then
        downloadFile(url, smartUkPath)
        msg(string.format("{FFFFFF} Óìíûé ðîçûñê íà %s óñïåøíî óñòàíîâëåí!", server), 0x8B00FF)
    else
        msg("{FFFFFF} Ê ñîæàëåíèþ, íà âàø ñåðâåð íå íàéäåí óìíûé ðîçûñê. Îí áóäåò äîáàâëåí â ñëåäóþùèõ îáíîâëåíèÿõ", 0x8B00FF)
    end
end

imgui.OnFrame(function() return logsWin[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(700, 200), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 "Ëîãè", logsWin)
    for _, log in ipairs(logs) do
        if log.type == "Øòðàô" then
            imgui.Text(u8(string.format(
                "Âðåìÿ: %s | Òèï: %s | Èãðîê: %s | Ñóììà: %s",
                log.time, log.type, log.player, log.amount
            )))
        else
            imgui.Text(u8(string.format(
                "Âðåìÿ: %s | Òèï: %s | Èãðîê: %s",
                log.time, log.type, log.player)))
        end
    end
    imgui.End()
end)
function sampev.onSendSpawn()
    if spawn and isMonetLoader() then
        spawn = false
        server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"
        sampSendChat('/stats')
        msg("{FFFFFF}MVDHelper óñïåøíî çàãðóæåí!", 0x8B00FF)
        msg("{FFFFFF}Êîìàíäà: /mvd", 0x8B00FF)
        nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
        if autogun[0] then
            lua_thread.create(function()
                while true do
                    wait(0)
                    if lastgun ~= getCurrentCharWeapon(PLAYER_PED) then
                        local gun = getCurrentCharWeapon(PLAYER_PED)
                        if gun == 3 then
                            sampSendChat(gunCommands[1])
                        elseif gun == 16 then
                            sampSendChat(gunCommands[2])
                        elseif gun == 17 then
                            sampSendChat(gunCommands[3])
                        elseif gun == 23 then
                            sampSendChat(gunCommands[4])
                        elseif gun == 22 then
                            sampSendChat(gunCommands[5])
                        elseif gun == 24 then
                            sampSendChat(gunCommands[6])
                        elseif gun == 25 then
                            sampSendChat(gunCommands[7])
                        elseif gun == 26 then
                            sampSendChat(gunCommands[8])
                        elseif gun == 27 then
                            sampSendChat(gunCommands[9])
                        elseif gun == 28 then
                            sampSendChat(gunCommands[10])
                        elseif gun == 29 then
                            sampSendChat(gunCommands[11])
                        elseif gun == 30 then
                            sampSendChat(gunCommands[12])
                        elseif gun == 31 then
                            sampSendChat(gunCommands[13])
                        elseif gun == 32 then
                            sampSendChat(gunCommands[14])
                        elseif gun == 33 then
                            sampSendChat(gunCommands[15])
                        elseif gun == 34 then
                            sampSendChat(gunCommands[16])
                        elseif gun == 43 then
                            sampSendChat(gunCommands[17])
                        elseif gun == 0 then
                            sampSendChat(gunCommands[18])
                        end
                        lastgun = gun
                    end
                end
            end)
        end
    end
end

imgui.OnFrame(
    function() return windowTwo[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Âûäà÷à ðîçûñêà", windowTwo)
        imgui.InputInt(u8 'ID èãðîêà ñ êîòîðûì áóäåòå âçàèìîäåéñòâîâàòü', id, 10)

        for i = 1, #tableUk["Text"] do
            if imgui.Button(u8(tableUk["Text"][i] .. ' Óðîâåíü ðîçûñêà: ' .. tableUk["Ur"][i])) then
                lua_thread.create(function()
                    sampSendChat("/do Ðàöèÿ âèñèò íà áðîíåæåëåòå.")
                    wait(1500)
                    sendMe(" ñîðâàâ ñ ãðóäíîãî äåðæàòåëÿ ðàöèþ, ñîîáùèë äàííûå î ñàïåêòå")
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

function sendMe(text)
    if tochkaMe[0] then
        sampSendChat("/me" .. text .. ".")
    else
        sampSendChat("/me" .. text)
    end
end

function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(u8(text)).x / 2)
    imgui.Text(text)
end

function imgui.CenterTextMain(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(u8(text)).x / 2 + mainIni.menuSettings.tab / 2)
    imgui.TextColoredRGB(text)
end

local namesobeska = imgui.new.char[256](u8 'Íåèçâåñòíî')
local rabotaet = false
local rabota = imgui.new.char[256]()
local let_v_shtate = false
local goda = imgui.new.char[256]()
local zakonoposlushen = false
local zakonka = imgui.new.int(0)
local narkozavisim = false
local narkozavisimost = imgui.new.char[256]()
local cherny_spisok = false
local voenik = false
local lic_na_avto = false
local chatsobes = {}
local sobesmessage = imgui.new.char[256]()
local select_id = imgui.new.int(1)
local sobes = {
    pass = u8 'Íå ïðîâåðåíî',
    mc = u8 'Íå ïðîâåðåíî',
    lic = u8 'Íå ïðîâåðåíî'
}
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if spawncar_bool and title:find('$') and text:find('Ñïàâí òðàíñïîðòà') then -- ñïàâí òðàíñïîðòà
        sampSendDialogResponse(dialogId, 2, 3, 0)
        spawncar_bool = false
        return false
    end
    
    if dialogId == 235 and title == "{BFBBBA}Îñíîâíàÿ ñòàòèñòèêà" then
        statsCheck = true
        if string.find(text, "Èìÿ:")then
            nickname = string.match(text, "Èìÿ: {B83434}%[(%D+)%]")
        end
        if string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ËÂ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ËÑ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Ïîëèöèÿ ÑÔ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "SFa" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "LSa" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "RCSD" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "Îáëàñòíàÿ ïîëèöèÿ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "ÔÁÐ" or string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]") == "FBI" then
            org = string.match(text, "Îðãàíèçàöèÿ: {B83434}%[(%D+)%]")
            if org ~= 'Íå èìååòñÿ' then dol = string.match(text, "Äîëæíîñòü: {B83434}(%D+)%(%d+%)") end
            dl = u8(dol)
            if org == 'Ïîëèöèÿ ËÂ' then
                org_g = u8 'LVPD'; ccity = u8 'Ëàñ-Âåíòóðàñ'; org_tag = 'LVPD'
            end
            if org == 'Ïîëèöèÿ ËÑ' then
                org_g = u8 'LSPD'; ccity = u8 'Ëîñ-Ñàíòîñ'; org_tag = 'LSPD'
            end
            if org == 'Ïîëèöèÿ ÑÔ' then
                org_g = u8 'SFPD'; ccity = u8 'Ñàí-Ôèåððî'; org_tag = 'SFPD'
            end
            if org == 'ÔÁÐ' then
                org_g = u8 'FBI'; ccity = u8 'Ñàí-Ôèåððî'; org_tag = 'FBI'
            end
            if org == 'FBI' then
                org_g = u8 'FBI'; ccity = u8 'Ñàí-Ôèåððî'; org_tag = 'FBI'
            end
            if org == 'RCSD' or org == 'Îáëàñòíàÿ ïîëèöèÿ' then
                org_g = u8 'RCSD'; ccity = u8 'Red Country'; org_tag = 'RCSD'
            end
            if org == 'LSa' or org == 'Àðìèÿ Ëîñ Ñàíòîñ' then
                org_g = u8 'LSa'; ccity = u8 'Ëîñ Ñàíòîñ'; org_tag = 'LSa'
            end
            if org == 'SFa' or org == 'Àðìèÿ Ñàí Ôèåððî' then
                org_g = u8 'SFa'; ccity = u8 'Ñàí Ôèåððî'; org_tag = 'SFa'
            end
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
            inicfg.save(mainIni, 'mvdhelper.ini')
        end
    end
end

local pages1 = {
    { icon = faicons("GEAR"), title = u8 "Ãëàâíîå", index = 1 },
    { icon = faicons("BOOK"), title = u8 "Ìåíþ ñîáåñ", index = 2 },
}
imgui.OnFrame(
    function() return leaderPanel[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(910 * MDS, 480 * MDS), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Ïàíåëü ðóêîâîäñòâà ôðàêöèåé", leaderPanel)
        imgui.BeginChild('tabs', imgui.ImVec2(173 * MDS, -1), true)
        imgui.CenterText(u8('MVD Helper v' .. thisScript().version))
        imgui.Separator()

        for _, pageData in ipairs(pages1) do
            imgui.SetCursorPosX(0)
            if imgui.PageButton(menu2 == pageData.index, pageData.icon, pageData.title, 173 * MDS - imgui.GetStyle().FramePadding.x * 2, 35 * MDS) then
                menu2 = pageData.index
            end
        end

        imgui.EndChild()
        imgui.SameLine()

        imgui.BeginChild('workspace', imgui.ImVec2(-1, -1), true)
        if menu2 == 1 then
            if imgui.CollapsingHeader(u8 'Ëåêöèè') then
                if imgui.Button(u8 'Àðåñò è çàäåðæàíèå') then
                    lua_thread.create(function()
                        sampSendChat("Çäðàâñòâóéòå óâàæàåìûå ñîòðóäíèêè íàøåãî äåïàðòàìåíòà!")
                        wait(1500)
                        sampSendChat("Ñåé÷àñ áóäåò ïðîâåäåíà ëåêöèÿ íà òåìó àðåñò è çàäåðæàíèå ïðåñòóïíèêîâ.")
                        wait(1500)
                        sampSendChat("Äëÿ íà÷àëà îáúÿñíþ ðàçëè÷èå ìåæäó çàäåðæàíèåì è àðåñòîì.")
                        wait(1500)
                        sampSendChat(
                            "Çàäåðæàíèå - ýòî êðàòêîâðåìåííîå ëèøåíèå ñâîáîäû ëèöà, ïîäîçðåâàåìîãî â ñîâåðøåíèè ïðåñòóïëåíèÿ.")
                        wait(1500)
                        sampSendChat(
                            "Â ñâîþ î÷åðåäü, àðåñò - ýòî âèä óãîëîâíîãî íàêàçàíèÿ, çàêëþ÷àþùåãîñÿ â ñîäåðæàíèè ñîâåðøèâøåãî ïðåñòóïëåíèå..")
                        wait(1500)
                        sampSendChat("..è îñóæä¸ííîãî ïî ïðèãîâîðó ñóäà â óñëîâèÿõ ñòðîãîé èçîëÿöèè îò îáùåñòâà.")
                        wait(1500)
                        sampSendChat("Âàì ðàçðåøåíî çàäåðæèâàòü ëèöà íà ïåðèîä 48 ÷àñîâ ñ ìîìåíòà èõ çàäåðæàíèÿ.")
                        wait(1500)
                        sampSendChat(
                            "Åñëè â òå÷åíèå 48 ÷àñîâ âû íå ïðåäúÿâèòå äîêàçàòåëüñòâà âèíû, âû îáÿçàíû îòïóñòèòü ãðàæäàíèíà.")
                        wait(1500)
                        sampSendChat("Îáðàòèòå âíèìàíèå, ãðàæäàíèí ìîæåò ïîäàòü íà âàñ èñê çà íåçàêîííîå çàäåðæàíèå.")
                        wait(1500)
                        sampSendChat(
                            "Âî âðåìÿ çàäåðæàíèÿ âû îáÿçàíû ïðîâåñòè ïåðâè÷íûé îáûñê íà ìåñòå çàäåðæàíèÿ è âòîðè÷íûé ó êàïîòà ñâîåãî àâòîìîáèëÿ.")
                        wait(1500)
                        sampSendChat(
                            "Âñå íàéäåííûå âåùè ïîëîæèòü â 'ZIP-lock', èëè â êîíòåéíåð äëÿ âåù. äîêîâ, Âñå ëè÷íûå âåùè ïðåñòóïíèêà êëàäóòñÿ â ìåøîê äëÿ ëè÷íûõ âåùåé çàäåðæàííîãî")
                        wait(1500)
                        sampSendChat("Íà ýòîì äàííàÿ ëåêöèÿ ïîäõîäèò ê êîíöó. Ó êîãî-òî èìåþòñÿ âîïðîñû?")
                    end)
                end
                if imgui.Button(u8 "Ñóááîðäèíàöèÿ") then
                    lua_thread.create(function()
                        sampSendChat(" Óâàæàåìûå ñîòðóäíèêè Ïîëèöåéñêîãî Äåïàðòàìåíòà!")
                        wait(1500)
                        sampSendChat(" Ïðèâåòñòâóþ âàñ íà ëåêöèè î ñóáîðäèíàöèè")
                        wait(1500)
                        sampSendChat(" Äëÿ íà÷àëà ðàññêàæó, ÷òî òàêîå ñóáîðäèíàöèÿ")
                        wait(1500)
                        sampSendChat(
                            " Ñóáîðäèíàöèÿ - ïðàâèëà ïîä÷èíåíèÿ ìëàäøèõ ïî çâàíèþ ê ñòàðøèì ïî çâàíèþ, óâàæåíèå, îòíîøåíèå ê íèì")
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
                if imgui.Button(u8 "Ïðàâèëà ïîâåäåíèÿ â ñòðîþ.") then
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
                if imgui.Button(u8 'Äîïðîñ') then
                    lua_thread.create(function()
                        sampSendChat(
                            " Çäðàâñòâóéòå óâàæàåìûå ñîòðóäíèêè äåïàðòàìåíòà ñåãîäíÿ, ÿ ïðîâåäó ëåêöèþ íà òåìó Äîïðîñ ïîäîçðåâàåìîãî.")
                        wait(1500)
                        sampSendChat(" Ñîòðóäíèê ÏÄ îáÿçàí ñíà÷àëà ïîïðèâåòñòâîâàòü, ïðåäñòàâèòüñÿ;")
                        wait(1500)
                        sampSendChat(
                            " Ñîòðóäíèê ÏÄ îáÿçàí ïîïðîñèòü äîêóìåíòû âûçâàííîãî, ñïðîñèòü, ãäå ðàáîòàåò, çâàíèå, äîëæíîñòü, ìåñòî æèòåëüñòâà;")
                        wait(1500)
                        sampSendChat(
                            " Ñîòðóäíèê ÏÄ îáÿçàí ñïðîñèòü, ÷òî îí äåëàë (íàçâàòü ïðîìåæóòîê âðåìåíè, ãäå îí ÷òî-òî íàðóøèë, ïî êîòîðîìó îí áûë âûçâàí);")
                        wait(1500)
                        sampSendChat(
                            " Åñëè ïîäîçðåâàåìûé áûë çàäåðæàí çà ðîçûñê, ñòàðàéòåñü óçíàòü çà ÷òî îí ïîëó÷èë ðîçûñê;")
                        wait(1500)
                        sampSendChat(" Â êîíöå äîïðîñà ïîëèöåéñêèé âûíîñèò âåðäèêò âûçâàííîìó.")
                        wait(1500)
                        sampSendChat(
                            " Ïðè îãëàøåíèè âåðäèêòà, íåîáõîäèìî ïðåäåëüíî òî÷íî îãëàñèòü âèíó äîïðàøèâàåìîãî (Ðàññêàçàòü åìó ïðè÷èíó, çà ÷òî îí áóäåò ïîñàæåí);")
                        wait(1500)
                        sampSendChat(
                            " Ïðè âûíåñåíèè âåðäèêòà, íå ñòîèò çàáûâàòü î îòÿã÷àþùèõ è ñìÿã÷àþùèõ ôàêòîðàõ (Ðàñêàÿíèå, àäåêâàòíîå ïîâåäåíèå, ïðèçíàíèå âèíû èëè ëîæü, íåàäåêâàòíîå ïîâåäåíèå, ïðîâîêàöèè, ïðåäñòàâëåíèå ïîëåçíîé èíôîðìàöèè è òîìó ïîäîáíîå).")
                        wait(1500)
                        sampSendChat(
                            " Íà ýòîì ëåêöèÿ ïîäîøëà ê êîíöó, åñëè ó êîãî-òî åñòü âîïðîñû, îòâå÷ó íà ëþáîé ïî äàííîé ëåêöèè (Åñëè çàäàëè âîïðîñ, òî íóæíî îòâåòèòü íà íåãî)")
                    end)
                end
                if imgui.Button(u8 "Ïðàâèëà ïîâåäåíèÿ äî è âî âðåìÿ îáëàâû íà íàðêîïðèòîí.") then
                    lua_thread.create(function()
                        sampSendChat(
                            " Äîáðûé äåíü, ñåé÷àñ ÿ ïðîâåäó âàì ëåêöèþ íà òåìó Ïðàâèëà ïîâåäåíèÿ äî è âî âðåìÿ îáëàâû íà íàðêîïðèòîí")
                        wait(1500)
                        sampSendChat(" Â ñòðîþ, ïåðåä îáëàâîé, âû äîëæíû âíèìàòåëüíî ñëóøàòü òî, ÷òî ãîâîðÿò âàì Àãåíòû")
                        wait(1500)
                        sampSendChat(" Óáåäèòåëüíàÿ ïðîñüáà, çàðàíåå óáåäèòüñÿ, ÷òî ïðè ñåáå ó âàñ èìåþòñÿ áàëàêëàâû")
                        wait(1500)
                        sampSendChat(" Ïî ïóòè ê íàðêîïðèòîíó, ïîäúåçæàÿ ê îïàñíîìó ðàéîíó, âñå îáÿçàíû èõ îäåòü")
                        wait(1500)
                        sampSendChat(
                            " Ïðèåõàâ íà òåððèòîðèþ ïðèòîíà, íóæíî ïîñòàâèòü îöåïëåíèå òàê, ÷òîáû çàãîðîäèòü âñå âîçìîæíûå ïóòè ê ñîçðåâàþùèì êóñòàì Êîíîïëè")
                        wait(1500)
                        sampSendChat(
                            " Î÷åíü âàæíûì çàìå÷àíèåì ÿâëÿåòñÿ òî, ÷òî íèêîìó, êðîìå àãåíòîâ, çàïðåùåíî ïîäõîäèòü ê êóñòàì, à òåì áîëåå èõ ñîáèðàòü")
                        wait(1500)
                        sampSendChat(" Íàðóøåíèå äàííîãî ïóíêòà ñòðîãî íàêàçûâàåòñÿ, âïëîòü äî óâîëüíåíèå")
                        wait(1500)
                        sampSendChat(" Òàê æå ïðèåõàâ íà ìåñòî, ìû íå óñòðàèâàåì ïàëüáó ïî âñåì, êîãî âèäèì")
                        wait(1500)
                        sampSendChat(
                            " Îòêðûâàòü îãîíü ïî ïîñòîðîííåìó ðàçðåøàåòñÿ òîëüêî â òîì ñëó÷àå, åñëè îí íàöåëèëñÿ íà âàñ îðóæèåì, íà÷àë àòàêîâàòü âàñ èëè ñîáèðàòü ñîçðåâøèå êóñòû")
                        wait(1500)
                        sampSendChat(" Êàê òîëüêî ñïåö. îïåðàöèÿ çàêàí÷èâàåòñÿ, âñå îöåïëåíèå óáèðàåòñÿ")
                        wait(1500)
                        sampSendChat(" Íà ýòîì ëåêöèÿ îêîí÷åíà, âñåì ñïàñèáî")
                    end)
                end
                if imgui.Button(u8 "Ïðàâèëî ìèðàíäû.") then
                    lua_thread.create(function()
                        sampSendChat("Ïðàâèëî Ìèðàíäû  þðèäè÷åñêîå òðåáîâàíèå â ÑØÀ")
                        wait(1500)
                        sampSendChat(
                            "Ñîãëàñíî êîòîðîìó âî âðåìÿ çàäåðæàíèÿ çàäåðæèâàåìûé äîëæåí áûòü óâåäîìëåí î ñâîèõ ïðàâàõ.")
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
                        sampSendChat(
                            "- Åñëè âû íå ìîæåòå îïëàòèòü óñëóãè àäâîêàòà, îí áóäåò ïðåäîñòàâëåí âàì ãîñóäàðñòâîì.")
                        wait(1500)
                        sampSendChat("- Âû ïîíèìàåòå ñâîè ïðàâà?")
                    end)
                end
                if imgui.Button(u8 "Ïåðâàÿ Ïîìîùü.") then
                    lua_thread.create(function()
                        sampSendChat("Äëÿ íà÷àëà îïðåäåëèìñÿ ÷òî ñ ïîñòðàäàâøèì")
                        wait(1500)
                        sampSendChat("Åñëè, ó ïîñòðàäàâøåãî êðîâîòå÷åíèå, òî íåîáõîäèìî îñòàíîâèòü ïîòîê êðîâè æãóòîì")
                        wait(1500)
                        sampSendChat(
                            "Åñëè ðàíåíèå íåáîëüøîå äîñòàòî÷íî äîñòàòü íàáîð ïåðâîé ïîìîùè è ïåðåâÿçàòü ðàíó áèíòîì")
                        wait(1500)
                        sampSendChat(
                            "Åñëè â ðàíå ïóëÿ, è ðàíà íå ãëóáîêàÿ, Âû äîëæíû âûçâàòü ñêîðóþ ëèáî âûòàùèòü åå ñêàëüïåëåì, ñêàëüïåëü òàêæå íàõîäèòñÿ â àïòå÷êå ïåðâîé ïîìîùè")
                        wait(1500)
                        sampSendChat("Åñëè ÷åëîâåê áåç ñîçíàíèÿ âàì íóæíî ... ")
                        wait(1500)
                        sampSendChat(
                            " ... äîñòàòü èç íàáîð ïåðâîé ïîìîùè âàòó è ñïèðò, çàòåì íàìî÷èòü âàòó ñïèðòîì ... ")
                        wait(1500)
                        sampSendChat(
                            " ... è ïðîâåñòè âàòêîé ñî ñïèðòîì îêîëî íîñà ïîñòðàäàâøåãî, â ýòîì ñëó÷àå, îí äîëæåí î÷íóòüñÿ")
                        wait(1500)
                        sampSendChat("Íà ýòîì ëåêöèÿ îêîí÷åíà. Ó êîãî-òî åñòü âîïðîñû ïî äàííîé ëåêöèè?")
                        wait(1500)
                    end)
                end
            end
            imgui.InputInt(u8 'ID èãðîêà ñ êîòîðûì õîòèòå âçàèìîäåéñòâîâàòü', id, 10)
            if imgui.Button(u8 'Óâîëèòü ñîòðóäíèêà') then
                lua_thread.create(function()
                    sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                    wait(1500)
                    sendMe(" ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                    wait(1500)
                    sendMe(" íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Óâîëèòü")
                    wait(1500)
                    sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü 'Ñîòðóäíèê óñïåøíî óâîëåí!'")
                    wait(1500)
                    sendMe(" âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                    wait(1500)
                    sampSendChat("Íó ÷òî æ, âû óâîëåííû. Îñòàâüòå ïîãîíû â ìîåì êàáèíåòå.")
                    wait(1500)
                    sampSendChat("/uninvite" .. id[0])
                end)
            end

            if imgui.Button(u8 'Ïðèíÿòü ãðàæäàíèíà') then
                lua_thread.create(function()
                    sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                    wait(1500)
                    sendMe(" ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                    wait(1500)
                    sendMe(" çàøåë â òàáëèöó è ââåë äàííûå î íîâîì ñîòðóäíèêå")
                    wait(1500)
                    sampSendChat(
                        "/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Ñîòðóäíèê óñïåøíî äîáàâëåí! Ïîæåëàéòå åìó õîðîøåé ñëóæáû :)'")
                    wait(1500)
                    sendMe(" âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                    wait(1500)
                    sampSendChat("Ïîçäðîâëÿþ, âû ïðèíÿòû! Ôîðìó âîçüìåòå â ðàçäåâàëêå.")
                    wait(1500)
                    sampSendChat("/invite" .. id[0])
                end)
            end

            if imgui.Button(u8 'Âûäàòü âûãîâîð ñîòðóäíèêó') then
                lua_thread.create(function()
                    sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                    wait(1500)
                    sendMe(" ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                    wait(1500)
                    sendMe(" íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Âûäàòü âûãîâîð")
                    wait(1500)
                    sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Âûãîâîð âûäàí!'")
                    wait(1500)
                    sendMe(" âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                    wait(1500)
                    sampSendChat("Íó ÷òî æ, âûãîâîð âûäàí. Îòðàáàòûâàéòå.")
                    wait(1500)
                    sampSendChat("/fwarn" .. id[0])
                end)
            end

            if imgui.Button(u8 'Ñíÿòü âûãîâîð ñîòðóäíèêó') then
                lua_thread.create(function()
                    sampSendChat("/do ÊÏÊ âåñèò íà ïîÿñå.")
                    wait(1500)
                    sendMe(" ñíÿë ÊÏÊ ñ ïîÿñà è çàøåë â ïðîãðàììó óïðàâëåíèÿ")
                    wait(1500)
                    sendMe(" íàøåë â ñïèñêå ñîòðóäíèêà è íàæàë íà êíîïêó Ñíÿòü âûãîâîð")
                    wait(1500)
                    sampSendChat("/do Íà ÊÏÊ âûñâåòèëàñü íàäïèñü: 'Âûãîâîð ñíÿò!'")
                    wait(1500)
                    sendMe(" âûêëþ÷èë ÊÏÊ è ïîâåñèë îáðàòíî íà ïîÿñ")
                    wait(1500)
                    sampSendChat("Íó ÷òî æ, îòðàáîòàëè.")
                    wait(1500)
                    sampSendChat("/unfwarn" .. id[0])
                end)
            end
        elseif menu2 == 2 then
            imgui.Text(u8("Ââåäèòå id èãðîêà:"))
            imgui.SameLine()
            imgui.PushItemWidth(200)
            imgui.InputInt("                ##select id for sobes", select_id)
            namesobeska = sampGetPlayerNickname(select_id[0])
            if namesobeska then
                imgui.Text(u8(namesobeska))
            else
                imgui.Text(u8 'Íåèçâåñòíî')
            end
            imgui.Separator()
            imgui.BeginChild('sobesvoprosi', imgui.ImVec2(-1, 143 * MONET_DPI_SCALE), true)
            if imgui.Button(u8 " Íà÷àòü ñîáåñåäîâàíèå", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                sampSendChat("Çäðàâñòâóéòå, âû ïðèøëè íà ñîáåñåäîâàíèå?")
            end
            imgui.SameLine()
            if imgui.Button(u8 " Ïîïðîñèòü äîêóìåíòû", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                lua_thread.create(function()
                    sampSendChat("Îòëè÷íî, ïðåäîñòàâüòå ìíå ïàñïîðò, ìåä. êàðòó è ëèöåíçèè.")
                    wait(1000)
                    sampSendChat(
                        "/b ×òîáû ïîêàçàòü äîêóìåíòàöèþ ââåäèòå: /showpass - ïàñïîðò, /showmc - ìåä.êàðòà, /showlic - ëèöåíççèè")
                    wait(2000)
                    sampSendChat("/b ÐÏ äîëæíî áûòü îáÿçàòåëüíî!")
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 " Ðàññêàæèòå î ñåáå", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                lua_thread.create(function()
                    sampSendChat("Õîðîøî, òåïåðü ÿ çàäàì ïàðó âîïðîñîâ.")
                    wait(2000)
                    sampSendChat("Ðàññêàæèòå î ñåáå.")
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 " Ïî÷åìó èìåííî ìû?", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                sampSendChat("Ïî÷åìó âû âûáðàëè èìåííî íàø äåïàðòàìåíò?")
            end
            imgui.Separator()
            imgui.Columns(3, nil, false)
            imgui.Text(u8 'Ïàñïîðò: ' .. sobes['pass'])
            imgui.Text(u8 'Ìåä.êàðòà: ' .. sobes['mc'])
            imgui.Text(u8 'Ëèöåíçèè: ' .. sobes['lic'])
            imgui.NextColumn()
            imgui.Text(u8 "Ëåò â øòàòå:")
            imgui.SameLine()
            if let_v_shtate then
                imgui.Text(goda)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî")
            end
            imgui.Text(u8 "Çàêîíêà:")
            imgui.SameLine()
            if zakonoposlushen then
                imgui.Text(zakonka)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî")
            end
            imgui.Text(u8 "Ëèö. íà àâòî:")
            imgui.SameLine()
            if lic_na_avto then
                imgui.Text(u8 "Åñòü")
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî/Íåòó")
            end
            imgui.Text(u8 "Âîåííèê:")
            imgui.SameLine()
            if voenik then
                imgui.Text(u8 "Åñòü")
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî/Íåòó")
            end
            imgui.NextColumn()
            imgui.Text(u8 "Çàâèñèìîñòü:")
            imgui.SameLine()
            if narkozavisim then
                imgui.Text(narkozavisimost)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî")
            end
            imgui.Text(u8 "Çäîðîâüå:")
            imgui.SameLine()
            imgui.Text(tostring(sampGetPlayerHealth(select_id[0])))
            imgui.Text(u8 "×åðíûé ñïèñîê:")
            imgui.SameLine()
            if cherny_spisok then
                imgui.Text(u8('ÅÑÒÜ'))
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî/Íåòó")
            end
            imgui.Text(u8 "Ðàáîòàåò:")
            imgui.SameLine()
            if rabotaet then
                imgui.Text(u8(str(rabota)))
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Íåèçâåñòíî")
            end
            imgui.EndChild()
            imgui.Columns(1)
            imgui.Separator()

            imgui.Text(u8 "Ëîêàëüíûé ÷àò")
            imgui.BeginChild("ChatWindow", imgui.ImVec2(0, 100), true)
            for i, v in pairs(chatsobes) do
                imgui.Text(u8(v))
            end
            imgui.EndChild()

            imgui.PushItemWidth(800)
            imgui.InputText("##input", sobesmessage, 256)
            imgui.SameLine()
            if imgui.Button(u8 "Îòïðàâèòü") then
                sampSendChat(u8:decode(str(sobesmessage)))
            end
            imgui.PopItemWidth()

            imgui.Separator()
            if imgui.Button(u8 " Ñîáåñåäîâàíèå ïðîéäåíî", imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                lua_thread.create(function()
                    sampSendChat("/todo Ïîçäðàâëÿþ! Âû ïðîøëè ñîáåñåäîâàíèå!* ñ óëûáêîé íà ëèöå")
                    wait(2000)
                    sampSendChat('/invite ' .. select_id[0])
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 "Ïðåêðàòèòü ñîáåñåäîâàíèå", imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                select_id[0] = -1
                sobes_1 = {
                    false,
                    false,
                    false
                }

                sobes = {
                    pass = u8 'Íå ïðîâåðåíî',
                    mc = u8 'Íå ïðîâåðåíî',
                    lic = u8 'Íå ïðîâåðåíî'
                }
                chatsobes = {}
                voenik = false
                lic_na_avto = false
                cherny_spisok = false
                narkozavisim = false
                zakonoposlushen = false
                rabotaet = false
                let_v_shtate = false
            end
        end
        imgui.EndChild()
        imgui.End()
    end)
imgui.OnFrame(
    function() return setUkWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 700), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Íàñòðîéêà óìíîãî ðîçûñêà", setUkWindow)

        if imgui.Button(u8 'Ñêà÷àòü ÓÊ äëÿ ñâîåãî ñåðâåðà') then
            DownloadUk()
        end
        if imgui.Button(u8 "Ñêà÷àòü ÓÊ äëÿ ëþáîãî ñåðâåðà") then
            importUkWindow[0] = not importUkWindow[0]
        end
        if imgui.BeginChild('Name', imgui.ImVec2(0, imgui.GetWindowSize().y - 36 - imgui.GetCursorPosY() - imgui.GetStyle().FramePadding.y * 2), true) then
            for i = 1, #tableUk["Text"] do
                imgui.Text(u8(tableUk["Text"][i] .. ' Óðîâåíü ðîçûñêà: ' .. tableUk["Ur"][i]))
                Uk = #tableUk["Text"]
            end
            imgui.EndChild()
        end
        if imgui.Button(u8 'Äîáàâèòü', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
            addUkWindow[0] = not addUkWindow[0]
        end
        imgui.SameLine()
        if imgui.Button(u8 'Óäàëèòü', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
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

imgui.OnFrame(
    function() return addUkWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Íàñòðîéêà óìíîãî ðîçûñêà", addUkWindow)
        imgui.InputText(u8 'Òåêñò ñòàòüè(ñ íîìåðîì.)', newUkInput, 255)
        newUkName = u8:decode(ffi.string(newUkInput))
        imgui.InputInt(u8 'Óðîâåíü ðîçûñêà(òîëüêî öèôðà)', newUkUr, 10)
        if imgui.Button(u8 'Ñîõðàíèòü') then
            Uk = #tableUk["Text"]
            tableUk["Text"][Uk + 1] = newUkName
            tableUk["Ur"][Uk + 1] = newUkUr[0]
            encodedTable = encodeJson(tableUk)
            local file = io.open("smartUk.json", "w")
            file:write(encodedTable)
            file:flush()
            file:close()
        end
        imgui.End()
    end
)

local importUkFrame = imgui.OnFrame(
    function() return importUkWindow[0] end,
    function() return true end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Èìïîðò óìíîãî ðîçûñêà", importUkWindow)
        local file = io.open(getWorkingDirectory() .. "/smartUk.json", "r")
        a = file:read("*a")
        file:close()
        tableUk = decodeJson(a)
        for _, serverName in ipairs(serversList) do
            if imgui.Button(u8(serverName)) then
                local serverKey = string.lower(string.gsub(serverName, " ", "-"))
                local url = smartUkUrl[serverKey]
                if url then
                    downloadFile(url, smartUkPath)
                    msg(string.format("{FFFFFF} Óìíûé ðîçûñê íà %s óñïåøíî óñòàíîâëåí!", serverName), 0x8B00FF)
                else
                    msg(string.format("{FFFFFF} Ê ñîæàëåíèþ, íà ñåðâåð %s íå íàéäåí óìíûé ðîçûñê. Îí áóäåò äîáàâëåí â ñëåäóþùèõ îáíîâëåíèÿõ", serverName), 0x8B00FF)
                end
                break
            end
        end
    end
)

function GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth()
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width / count - ((space * (count - 1)) / count)
end

function calculateZone(x, y, z)
    local streets = {
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406 },
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406 },
        { "Ãàðñèÿ", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000 },
        { "Øåéäè-Êýáèí", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916 },
        { "Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916 },
        { "Ïåðåñå÷åíèå Áëýêôèëä", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916 },
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100 },
        { "Òåìïë", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916 },
        { "Ñòàíöèÿ «Þíèòè»", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508 },
        { "Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916 },
        { "Ëîñ-Ôëîðåñ", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916 },
        { "Êàçèíî «Ìîðñêàÿ çâåçäà»", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916 },
        { "Õèìçàâîä Èñòåð-Áýé", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000 },
        { "Äåëîâîé ðàéîí", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916 },
        { "Âîñòî÷íàÿ Ýñïàëàíäà", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000 },
        { "Ñòàíöèÿ «Ìàðêåò»", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874 },
        { "Ñòàíöèÿ «Ëèíäåí»", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406 },
        { "Ïåðåñå÷åíèå Ìîíòãîìåðè", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000 },
        { "Ìîñò «Ôðåäåðèê»", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000 },
        { "Ñòàíöèÿ «Éåëëîó-Áåëë»", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074 },
        { "Äåëîâîé ðàéîí", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916 },
        { "Äæåôôåðñîí", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916 },
        { "Ìàëõîëëàíä", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916 },
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000 },
        { "Äæåôôåðñîí", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916 },
        { "Çàïàäàíàÿ àâòîñòðàäà Äæóëèóñ", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916 },
        { "Äæåôôåðñîí", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916 },
        { "Ðîäåî", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916 },
        { "Ñòàíöèÿ «Êðýíáåððè»", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000 },
        { "Äåëîâîé ðàéîí", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916 },
        { "Çàïàäíûé Ðýäñýíäñ", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916 },
        { "Ìàëåíüêàÿ Ìåêñèêà", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916 },
        { "Ïåðåñå÷åíèå Áëýêôèëä", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916 },
        { "Áåêîí-Õèëë", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511 },
        { "Ðîäåî", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916 },
        { "Ðè÷ìàí", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916 },
        { "Äåëîâîé ðàéîí", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916 },
        { "Ñòðèï", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916 },
        { "Äåëîâîé ðàéîí", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916 },
        { "Ïåðåñå÷åíèå Áëýêôèëä", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916 },
        { "Êîíôåðåíö Öåíòð", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916 },
        { "Ìîíòãîìåðè", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000 },
        { "Äîëèíà Ôîñòåð", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000 },
        { "×àñîâíÿ Áëýêôèëä", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916 },
        { "Ìàëõîëëàíä", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916 },
        { "Ïîëå äëÿ ãîëüôà «Éåëëîó-Áåëë»", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916 },
        { "Ñòðèï", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916 },
        { "Äæåôôåðñîí", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916 },
        { "Ìàëõîëëàíä", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916 },
        { "Àëüäåà-Ìàëüâàäà", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000 },
        { "Ëàñ-Êîëèíàñ", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916 },
        { "Ëàñ-Êîëèíàñ", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916 },
        { "Ðè÷ìàí", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916 },
        { "Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916 },
        { "Óèëëîóôèëä", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916 },
        { "Òåìïë", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916 },
        { "Ìàëåíüêàÿ Ìåêñèêà", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916 },
        { "Êâèíñ", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000 },
        { "Àýðîïîðò Ëàñ-Âåíòóðàñ", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500 },
        { "Ðè÷ìàí", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916 },
        { "Òåìïë", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916 },
        { "Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916 },
        { "Óèëëîóôèëä", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916 },
        { "Ëàñ-Êîëèíàñ", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916 },
        { "Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916 },
        { "Ðîäåî", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916 },
        { "Ëàñ-Áðóõàñ", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000 },
        { "Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916 },
        { "Ðîäåî", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916 },
        { "Âàéíâóä", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916 },
        { "Ðîäåî", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916 },
        { "Äåëîâîé ðàéîí", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916 },
        { "Ðîäåî", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916 },
        { "Äæåôôåðñîí", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916 },
        { "Õýìïòîí-Áàðíñ", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000 },
        { "Òåìïë", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916 },
        { "Ìîñò «Êèíêåéä»", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916 },
        { "Ïëÿæ «Âåðîíà»", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916 },
        { "Êîììåð÷åñêèé ðàéîí", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916 },
        { "Ìàëõîëëàíä", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916 },
        { "Ðîäåî", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916 },
        { "Ìàëõîëëàíä", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916 },
        { "Ìàëõîëëàíä", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916 },
        { "Þæíàÿ àâòîñòðàäà Äæóëèóñ", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916 },
        { "Àéäëâóä", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916 },
        { "Îêåàíñêèå äîêè", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916 },
        { "Êîììåð÷åñêèé ðàéîí", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916 },
        { "Òåìïë", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916 },
        { "Ãëåí Ïàðê", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000 },
        { "Ìîñò «Ìàðòèí»", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000 },
        { "Ñòðèï", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916 },
        { "Óèëëîóôèëä", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916 },
        { "Ìàðèíà", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916 },
        { "Àýðîïîðò Ëàñ-Âåíòóðàñ", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916 },
        { "Àéäëâóä", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916 },
        { "Âîñòî÷íàÿ Ýñïàëàíäà", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000 },
        { "Äåëîâîé ðàéîí", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916 },
        { "Ìîñò «Ìàêî»", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000 },
        { "Ðîäåî", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916 },
        { "Ïëîùàäü «Ïåðøèíã»", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916 },
        { "Ìàëõîëëàíä", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916 },
        { "Ìîñò «Ãàíò»", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000 },
        { "Ëàñ-Êîëèíàñ", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916 },
        { "Ìàëõîëëàíä", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916 },
        { "Êîììåð÷åñêèé ðàéîí", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916 },
        { "Ðîäåî", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916 },
        { "Ðîêà-Ýñêàëàíòå", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916 },
        { "Ðîäåî", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916 },
        { "Ìàðêåò", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916 },
        { "Ëàñ-Êîëèíàñ", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916 },
        { "Ìàëõîëëàíä", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916 },
        { "Êèíãñ", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000 },
        { "Âîñòî÷íûé Ðýäñýíäñ", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916 },
        { "Äåëîâîé ðàéîí", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000 },
        { "Êîíôåðåíö Öåíòð", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916 },
        { "Ðè÷ìàí", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916 },
        { "Îóøåí-Ôëýòñ", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000 },
        { "Êîëëåäæ Ãðèíãëàññ", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916 },
        { "Ãëåí Ïàðê", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916 },
        { "Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916 },
        { "Ðåãüþëàð-Òîì", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000 },
        { "Ïëÿæ «Âåðîíà»", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916 },
        { "Äâîðåö Êàëèãóëû", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916 },
        { "Àéäëâóä", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916 },
        { "Ïèëèãðèì", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916 },
        { "Àéäëâóä", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916 },
        { "Êâèíñ", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000 },
        { "Äåëîâîé ðàéîí", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000 },
        { "Êîììåð÷åñêèé ðàéîí", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916 },
        { "Ìàðèíà", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916 },
        { "Ðè÷ìàí", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916 },
        { "Âàéíâóä", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916 },
        { "Ðîäåî", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916 },
        { "Èñòåðñêèé Òîííåëü", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000 },
        { "Ðîäåî", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916 },
        { "Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916 },
        { "Êàçèíî «Êàðìàí êëîóíà»", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916 },
        { "Àéäëâóä", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916 },
        { "Ïåðåñå÷åíèå Ìîíòãîìåðè", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000 },
        { "Óèëëîóôèëä", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916 },
        { "Òåìïë", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916 },
        { "Ïðèêë-Ïàéí", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916 },
        { "Ìîñò «Ãàðâåð»", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916 },
        { "Ìîñò «Ãàðâåð»", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916 },
        { "Ìîñò «Êèíêåéä»", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916 },
        { "Ìîñò «Êèíêåéä»", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916 },
        { "Ïëÿæ «Âåðîíà»", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916 },
        { "Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ»", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916 },
        { "Âàéíâóä", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916 },
        { "Âàéíâóä", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916 },
        { "Êîììåð÷åñêèé ðàéîí", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916 },
        { "Ìàðêåò", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916 },
        { "Çàïàäíûé Ðîêøîð", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916 },
        { "Âîñòî÷íûé ïëÿæ", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916 },
        { "Ìîñò «Ôàëëîó»", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000 },
        { "Óèëëîóôèëä", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916 },
        { "×àéíàòàóí", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000 },
        { "Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000 },
        { "Îêåàíñêèå äîêè", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916 },
        { "Õèìçàâîä Èñòåð-Áýé", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000 },
        { "Êàçèíî «Âèçàæ»", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916 },
        { "Îóøåí-Ôëýòñ", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000 },
        { "Ðè÷ìàí", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916 },
        { "Íåôòÿíîé êîìïëåêñ «Çåëåíûé îàçèñ»", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000 },
        { "Ðè÷ìàí", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916 },
        { "Êàçèíî «Ìîðñêàÿ çâåçäà»", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916 },
        { "Âîñòî÷íûé ïëÿæ", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916 },
        { "Äæåôôåðñîí", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916 },
        { "Äåëîâîé ðàéîí", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916 },
        { "Äåëîâîé ðàéîí", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916 },
        { "Ìîñò «Ãàðâåð»", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385 },
        { "Þæíàÿ àâòîñòðàäà Äæóëèóñ", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916 },
        { "Êîëëåäæ «Ãðèíãëàññ»", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916 },
        { "Ëàñ-Êîëèíàñ", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916 },
        { "Ìàëõîëëàíä", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916 },
        { "Îêåàíñêèå äîêè", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916 },
        { "Âîñòî÷íûé Ëîñ-Ñàíòîñ", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916 },
        { "Ãàíòîí", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916 },
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000 },
        { "Óèëëîóôèëä", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916 },
        { "Ñåâåðíàÿ Ýñïëàíàäà", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000 },
        { "Êàçèíî «Õàé-Ðîëëåð»", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916 },
        { "Îêåàíñêèå äîêè", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916 },
        { "Ìîòåëü «Ïîñëåäíèé öåíò»", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916 },
        { "Áýéñàéíä-Ìàðèíà", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000 },
        { "Êèíãñ", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000 },
        { "Ýëü-Êîðîíà", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916 },
        { "×àñîâíÿ Áëýêôèëä", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916 },
        { "«Ðîçîâûé ëåáåäü»", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916 },
        { "Çàïàäàíàÿ àâòîñòðàäà Äæóëèóñ", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916 },
        { "Ëîñ-Ôëîðåñ", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916 },
        { "Êàçèíî «Âèçàæ»", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916 },
        { "Ïðèêë-Ïàéí", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916 },
        { "Ïëÿæ «Âåðîíà»", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916 },
        { "Ïåðåñå÷åíèå Ðîáàäà", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916 },
        { "Ëèíäåí-Ñàéä", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916 },
        { "Îêåàíñêèå äîêè", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916 },
        { "Óèëëîóôèëä", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916 },
        { "Êèíãñ", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000 },
        { "Êîììåð÷åñêèé ðàéîí", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916 },
        { "Ìàëõîëëàíä", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916 },
        { "Ìàðèíà", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916 },
        { "Áýòòåðè-Ïîéíò", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000 },
        { "Êàçèíî «4 Äðàêîíà»", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916 },
        { "Áëýêôèëä", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916 },
        { "Ñåâåðíàÿ àâòîñòðàäà Äæóëèóñ", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916 },
        { "Ïîëå äëÿ ãîëüôà «Éåëëîó-Áåëë»", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916 },
        { "Àéäëâóä", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916 },
        { "Çàïàäíûé Ðýäñýíäñ", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916 },
        { "Äîýðòè", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000 },
        { "Ôåðìà Õèëëòîï", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000 },
        { "Ëàñ-Áàððàíêàñ", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000 },
        { "Êàçèíî «Ïèðàòû â ìóæñêèõ øòàíàõ»", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916 },
        { "Ñèòè Õîëë", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000 },
        { "Çàãîðîäíûé êëóá «Àâèñïà»", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000 },
        { "Ñòðèï", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916 },
        { "Õàøáåðè", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916 },
        { "Óàéòâóä-Èñòåéòñ", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916 },
        { "Âîäîõðàíèëèùå Øåðìàíà", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916 },
        { "Ýëü-Êîðîíà", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916 },
        { "Äåëîâîé ðàéîí", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000 },
        { "Äîëèíà Ôîñòåð", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000 },
        { "Ëàñ-Ïàÿñàäàñ", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000 },
        { "Äîëèíà Îêóëüòàäî", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000 },
        { "Ïåðåñå÷åíèå Áëýêôèëä", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916 },
        { "Ãàíòîí", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000 },
        { "Âîñòî÷íûé Ðýäñýíäñ", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916 },
        { "Âîñòî÷íàÿ Ýñïàëàíäà", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385 },
        { "Äâîðåö Êàëèãóëû", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916 },
        { "Êàçèíî «Ðîÿëü»", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916 },
        { "Ðè÷ìàí", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916 },
        { "Êàçèíî «Ìîðñêàÿ çâåçäà»", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916 },
        { "Ìàëõîëëàíä", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916 },
        { "Äåëîâîé ðàéîí", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000 },
        { "Õàíêè-Ïàíêè-Ïîéíò", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000 },
        { "Âîåííûé ñêëàä òîïëèâà Ê.À.Ñ.Ñ.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916 },
        { "Àâòîñòðàäà «Ãàððè-Ãîëä»", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916 },
        { "Òîííåëü Áýéñàéä", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916 },
        { "Îêåàíñêèå äîêè", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916 },
        { "Ðè÷ìàí", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916 },
        { "Ïðîìñêëàä èìåíè Ðýíäîëüôà", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916 },
        { "Âîñòî÷íûé ïëÿæ", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916 },
        { "Ôëèíò-Óîòåð", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916 },
        { "Áëóáåððè", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000 },
        { "Ñòàíöèÿ «Ëèíäåí»", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916 },
        { "Ãëåí Ïàðê", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916 },
        { "Äåëîâîé ðàéîí", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000 },
        { "Çàïàäíûé Ðýäñýíäñ", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916 },
        { "Ðè÷ìàí", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916 },
        { "Ìîñò «Ãàíò»", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000 },
        { "Áàð «Probe Inn»", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000 },
        { "Ïåðåñå÷åíèå Ôëèíò", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916 },
        { "Ëàñ-Êîëèíàñ", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916 },
        { "Ñîáåëë-Ðåéë-ßðäñ", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916 },
        { "Èçóìðóäíûé îñòðîâ", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916 },
        { "Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000 },
        { "Ñàíòà-Ôëîðà", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000 },
        { "Ïëàéÿ-äåëü-Ñåâèëü", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916 },
        { "Ìàðêåò", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916 },
        { "Êâèíñ", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000 },
        { "Ïåðåñå÷åíèå Ïèëñîí", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916 },
        { "Ñïèíèáåä", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916 },
        { "Ïèëèãðèì", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916 },
        { "Áëýêôèëä", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916 },
        { "«Áîëüøîå óõî»", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000 },
        { "Äèëëèìîð", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000 },
        { "Ýëü-Êåáðàäîñ", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000 },
        { "Ñåâåðíàÿ Ýñïëàíàäà", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000 },
        { "Ðûáàöêàÿ ëàãóíà", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000 },
        { "Ìàëõîëëàíä", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916 },
        { "Âîñòî÷íûé ïëÿæ", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916 },
        { "Ñàí-Àíäðåàñ Ñàóíä", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000 },
        { "Òåíèñòûå ðó÷üè", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000 },
        { "Ìàðêåò", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916 },
        { "Çàïàäíûé Ðîêøîð", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916 },
        { "Ïðèêë-Ïàéí", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916 },
        { "«Áóõòà Ïàñõè»", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000 },
        { "Ëèôè-Õîëëîó", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000 },
        { "Ãðóçîâîå äåïî Ëàñ-Âåíòóðàñà", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916 },
        { "Ïðèêë-Ïàéí", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916 },
        { "Áëóáåððè", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000 },
        { "Ýëü-Êàñòèëüî-äåëü-Äüÿáëî", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000 },
        { "Äåëîâîé ðàéîí", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000 },
        { "Âîñòî÷íûé Ðîêøîð", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916 },
        { "Çàëèâ Ñàí-Ôèåððî", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000 },
        { "Ïàðàäèçî", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000 },
        { "Êàçèíî «Íîñîê âåðáëþäà»", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916 },
        { "Îëä-Âåíòóðàñ-Ñòðèï", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916 },
        { "Äæàíèïåð-Õèëë", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000 },
        { "Äæàíèïåð-Õîëëîó", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000 },
        { "Ðîêà-Ýñêàëàíòå", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916 },
        { "Âîñòî÷íàÿ àâòîñòðàäà Äæóëèóñ", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916 },
        { "Ïëÿæ «Âåðîíà»", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916 },
        { "Äîëèíà Ôîñòåð", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000 },
        { "Àðêî-äåëü-Îýñòå", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000 },
        { "«Óïàâøåå äåðåâî»", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000 },
        { "Ôåðìà", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981 },
        { "Äàìáà Øåðìàíà", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000 },
        { "Ñåâåðíàÿ Ýñïëàíàäà", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000 },
        { "Ôèíàíñîâûé ðàéîí", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000 },
        { "Ãàðñèÿ", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000 },
        { "Ìîíòãîìåðè", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000 },
        { "Êðèê", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916 },
        { "Ïëÿæ «Ñàíòà-Ìàðèÿ»", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916 },
        { "Ïåðåñå÷åíèå Ìàëõîëëàíä", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916 },
        { "Ýéíäæåë-Ïàéí", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000 },
        { "Â¸ðäàíò-Ìåäîóñ", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000 },
        { "Îêòàí-Ñïðèíãñ", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000 },
        { "Êàçèíî Êàì-ý-Ëîò", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916 },
        { "Çàïàäíûé Ðýäñýíäñ", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916 },
        { "Ïëÿæ «Ñàíòà-Ìàðèÿ»", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916 },
        { "Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916 },
        { "Àýðîïîðò Ëàñ-Âåíòóðàñ", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916 },
        { "Îêðóã Ôëèíò", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000 },
        { "Îáñåðâàòîðèÿ «Çåë¸íûé óò¸ñ", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916 },
        { "Ïàëîìèíî Êðèê", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000 },
        { "Îêåàíñêèå äîêè", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000 },
        { "Óàéòâóä-Èñòåéòñ", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916 },
        { "Êàëòîí-Õàéòñ", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000 },
        { "«Áóõòà Ïàñõè»", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000 },
        { "Çàëèâ Ëîñ-Ñàíòîñ", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916 },
        { "Äîýðòè", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000 },
        { "Ãîðà ×èëèàä", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083 },
        { "Ôîðò-Êàðñîí", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000 },
        { "Äîëèíà Ôîñòåð", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000 },
        { "Îóøåí-Ôëýòñ", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000 },
        { "Ôåðí-Ðèäæ", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000 },
        { "Áýéñàéä", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000 },
        { "Àýðîïîðò Ëàñ-Âåíòóðàñ", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916 },
        { "Ïîìåñòüå Áëóáåððè", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000 },
        { "Ïýëèñåéäñ", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000 },
        { "Íîðò-Ðîê", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000 },
        { "Êàðüåð «Õàíòåð»", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Ëîñ-Ñàíòîñ", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916 },
        { "Ìèññèîíåð-Õèëë", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000 },
        { "Çàëèâ Ñàí-Ôèåððî", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000 },
        { "Çàïðåòíàÿ Çîíà", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000 },
        { "Ãîðà «×èëèàä»", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083 },
        { "Ãîðà «×èëèàä»", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083 },
        { "Ìåæäóíàðîäíûé àýðîïîðò Èñòåð-Áýé", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000 },
        { "Ïàíîïòèêóì", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000 },
        { "Òåíèñòûå ðó÷üè", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000 },
        { "Áýê-î-Áåéîíä", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000 },
        { "Ãîðà «×èëèàä»", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083 },
        { "Òüåððà Ðîáàäà", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000 },
        { "Îêðóã Ôëèíò", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000 },
        { "Óýòñòîóí", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000 },
        { "Ïóñòûííûé îêðóã", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000 },
        { "Òüåððà Ðîáàäà", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000 },
        { "Ñàí Ôèåððî", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000 },
        { "Ëàñ Âåíòóðàñ", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000 },
        { "Òóìàííûé îêðóã", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000 },
        { "Ëîñ Ñàíòîñ", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000 }
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Ïðèãîðîä'
end

function imgui.TextColoredRGB(text, wrapped)
    local style = imgui.GetStyle()
    local colors = style.Colors
    text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')
    local render_func = wrapped and imgui_text_wrapped or function(clr, text)
        if clr then imgui.PushStyleColor(ffi.C.ImGuiCol_Text, clr) end
        imgui.TextUnformatted(text)
        if clr then imgui.PopStyleColor() end
    end
    local split = function(str, delim, plain)
        local tokens, pos, i, plain = {}, 1, 1, not (plain == false)
        repeat
            local npos, epos = string.find(str, delim, pos, plain)
            tokens[i] = string.sub(str, pos, npos and npos - 1)
            pos = epos and epos + 1
            i = i + 1
        until not pos
        return tokens
    end

    local color = colors[ffi.C.ImGuiCol_Text]
    for _, w in ipairs(split(text, '\n')) do
        local start = 1
        local a, b = w:find('{........}', start)
        while a do
            local t = w:sub(start, a - 1)
            if #t > 0 then
                render_func(color, t)
                imgui.SameLine(nil, 0)
            end

            local clr = w:sub(a + 1, b - 1)
            if clr:upper() == 'STANDART' then
                color = colors[ffi.C.ImGuiCol_Text]
            else
                clr = tonumber(clr, 16)
                if clr then
                    local r = bit.band(bit.rshift(clr, 24), 0xFF)
                    local g = bit.band(bit.rshift(clr, 16), 0xFF)
                    local b = bit.band(bit.rshift(clr, 8), 0xFF)
                    local a = bit.band(clr, 0xFF)
                    color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
                end
            end

            start = b + 1
            a, b = w:find('{........}', start)
        end
        imgui.NewLine()
        if #w >= start then
            imgui.SameLine(nil, 0)
            render_func(color, w:sub(start))
        end
    end
end

imgui.OnFrame(
    function() return suppWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Âñïîìîãàòåëüíîå îêîøêî", suppWindow,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)

        imgui.Text(u8 'Âðåìÿ: ' .. os.date('%H:%M:%S'))
        imgui.Text(u8 'Ìåñÿö: ' .. os.date('%B'))
        imgui.Text(u8 'Ïîëíàÿ äàòà: ' .. arr.day .. '.' .. arr.month .. '.' .. arr.year)
        local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
        imgui.Text(u8 'Ðàéîí:' .. u8(calculateZone(positionX, positionY, positionZ)))
        local p_city = getCityPlayerIsIn(PLAYER_PED)
        if p_city == 1 then pCity = u8 'Ëîñ - Ñàíòîñ' end
        if p_city == 2 then pCity = u8 'Ñàí - Ôèåððî' end
        if p_city == 3 then pCity = u8 'Ëàñ - Âåíòóðàñ' end
        if getActiveInterior() ~= 0 then pCity = u8 'Âû íàõîäèòåñü â èíòåðüåðå!' end
        imgui.Text(u8 'Ãîðîä: ' .. (pCity or u8 'Íåèçâåñòíî'))
        imgui.End()
    end
)

function table.find(t, v)
    for k, vv in pairs(t) do
        if vv == v then return k end
    end
    return nil
end


function sampev.onSendChat(cmd)
    if mainIni.settings.autoAccent then
        if cmd == ')' or cmd == '(' or cmd == '))' or cmd == '((' or cmd == 'xD' or cmd == ':D' or cmd == ':d' or cmd == 'XD' then
            return { cmd }
        end
        cmd = mainIni.Accent.accent .. ' ' .. cmd
        return { cmd }
    end
    return { cmd }
end

function sampev.onServerMessage(color, message)
    if message:find("Âû ïîñàäèëè èãðîêà (%w+_%w+) â òþðüìó íà (.+) ìèíóò.") then
        local player, duration = message:match("Âû ïîñàäèëè èãðîêà (%w+_%w+) â òþðüìó íà (.+) ìèíóò.")
        addLogEntry("Àðåñò", player, nil, nil, duration)
    end
    if message:find("(%w+_%w+) îïëàòèë øòðàô â ðàçìåðå (.+)") then
        local player, amount = message:match("(%w+_%w+) îïëàòèë øòðàô â ðàçìåðå (.+)")
        addLogEntry("Øòðàô", player, amount, nil)
    end
    if message:find('%[D%]') then
        if message:find('[' .. (str(departsettings.myorgname)) .. ']') then
            local tmsg = message
            dephistory[#dephistory + 1] = tmsg
        end
    end
    if leaderPanel[0] then
        if message:find(nickname .. '%[' .. myId .. '%]') or message:find((str(namesobeska) .. '%[' .. select_id[0] .. '%]')) then
            local bool_t = imgui.new.char[98]()
            local ch_end_f = message:gsub('%{B7AFAF%}', '%{464d4f%}'):gsub('%{FFFFFF%}', '%{464d4f%}')
            ch_end_f = ch_end_f:gsub('%{464d4f%}', '')
            bool_t = ch_end_f
            table.insert(chatsobes, bool_t)

            if bool_t ~= ch_end_f then
                local icran = bool_t:gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%.', '%%.'):gsub('%-', '%%-')
                    :gsub('%+', '%%+'):gsub('%?', '%%?'):gsub('%$', '%%$'):gsub('%*', '%%*')
                    :gsub('%(', '%%('):gsub('%)', '%%)')

                bool_t = ch_end_f:gsub(icran, '')
                table.insert(chatsobes, bool_t)
            end
        end
    end
end

HeaderButton = function(bool, icon, str_id)
    local DL = imgui.GetWindowDrawList()
    local ToU32 = imgui.ColorConvertFloat4ToU32
    local result = false
    local label = string.gsub(str_id, "##.*$", "")
    local duration = { 0.5, 0.3 }
    local cols = {
        idle = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
        hovr = imgui.GetStyle().Colors[imgui.Col.Text],
        slct = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    }

    if not AI_HEADERBUT then AI_HEADERBUT = {} end
    if not AI_HEADERBUT[str_id] then
        AI_HEADERBUT[str_id] = {
            color = bool and cols.slct or cols.idle,
            clock = os.clock() + duration[1],
            h = {
                state = bool,
                alpha = bool and 1.00 or 0.00,
                clock = os.clock() + duration[2],
            }
        }
    end
    local pool = AI_HEADERBUT[str_id]

    local degrade = function(before, after, start_time, duration)
        local result = before
        local timer = os.clock() - start_time
        if timer >= 0.00 then
            local offs = {
                x = after.x - before.x,
                y = after.y - before.y,
                z = after.z - before.z,
                w = after.w - before.w
            }

            result.x = result.x + ((offs.x / duration) * timer)
            result.y = result.y + ((offs.y / duration) * timer)
            result.z = result.z + ((offs.z / duration) * timer)
            result.w = result.w + ((offs.w / duration) * timer)
        end
        return result
    end

    local pushFloatTo = function(p1, p2, clock, duration)
        local result = p1
        local timer = os.clock() - clock
        if timer >= 0.00 then
            local offs = p2 - p1
            result = result + ((offs / duration) * timer)
        end
        return result
    end

    local set_alpha = function(color, alpha)
        return imgui.ImVec4(color.x, color.y, color.z, alpha or 1.00)
    end

    imgui.BeginGroup()
    local pos = imgui.GetCursorPos()
    local p = imgui.GetCursorScreenPos()
    -- imgui.Text(icon)
    -- imgui.SameLine()
    imgui.PushFont(Menu)
    imgui.TextColored(pool.color, label)
    imgui.PopFont()
    local s = imgui.GetItemRectSize()
    local hovered = imgui.IsItemHovered()
    local clicked = imgui.IsItemClicked()

    if pool.h.state ~= hovered and not bool then
        pool.h.state = hovered
        pool.h.clock = os.clock()
    end

    if clicked then
        pool.clock = os.clock()
        result = true
    end

    if os.clock() - pool.clock <= duration[1] then
        pool.color = degrade(
            imgui.ImVec4(pool.color),
            bool and cols.slct or (hovered and cols.hovr or cols.idle),
            pool.clock,
            duration[1]
        )
    else
        pool.color = bool and cols.slct or (hovered and cols.hovr or cols.idle)
    end

    if pool.h.clock ~= nil then
        if os.clock() - pool.h.clock <= duration[2] then
            pool.h.alpha = pushFloatTo(
                pool.h.alpha,
                pool.h.state and 1.00 or 0.00,
                pool.h.clock,
                duration[2]
            )
        else
            pool.h.alpha = pool.h.state and 1.00 or 0.00
            if not pool.h.state then
                pool.h.clock = nil
            end
        end

        local max = s.x / 2
        local Y = p.y + s.y + 3
        local mid = p.x + max

        DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid + (max * pool.h.alpha), Y),
            ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
        DL:AddLine(imgui.ImVec2(mid, Y), imgui.ImVec2(mid - (max * pool.h.alpha), Y),
            ToU32(set_alpha(pool.color, pool.h.alpha)), 3)
    end

    imgui.EndGroup()
    return result
end


imgui.PageButton = function(bool, icon, name, but_wide, but_high)
    but_wide = but_wide or 290
    but_high = but_high or 55
    local duration = 0.25
    local DL = imgui.GetWindowDrawList()
    local p1 = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]

    if not AI_PAGE[name] then
        AI_PAGE[name] = { clock = nil }
    end
    local pool = AI_PAGE[name]

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, but_high))
    if result and not bool then
        pool.clock = os.clock()
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
    if bool then
        if pool.clock and (os.clock() - pool.clock) < duration then
            local wide = (os.clock() - pool.clock) * (but_wide / duration)
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y + mainIni.menuSettings.vtpos),
                imgui.ImVec2((p1.x + but_wide) - wide, p1.y + mainIni.menuSettings.vtpos + but_high),
                0x10FFFFFF, 15, 10)
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y + mainIni.menuSettings.vtpos),
                imgui.ImVec2(p1.x + 5, p1.y + mainIni.menuSettings.vtpos + but_high), ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y + mainIni.menuSettings.vtpos),
                imgui.ImVec2(p1.x + wide, p1.y + mainIni.menuSettings.vtpos + but_high),
                ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
        else
            DL:AddRectFilled(
                imgui.ImVec2(p1.x, (pressed and p1.y + mainIni.menuSettings.vtpos or p1.y + mainIni.menuSettings.vtpos)),
                imgui.ImVec2(p1.x + 10,
                    (pressed and p1.y + but_high - 23 + mainIni.menuSettings.vtpos or p1.y + but_high + mainIni.menuSettings.vtpos)),
                ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y + mainIni.menuSettings.vtpos),
                imgui.ImVec2(p1.x + but_wide + 2, p1.y + but_high + mainIni.menuSettings.vtpos), --Âîò ýòè äåñÿòêè
                ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
        end
    else
        if imgui.IsItemHovered() then
            DL:AddRectFilled(imgui.ImVec2(p1.x + 2, p1.y + mainIni.menuSettings.vtpos),
                imgui.ImVec2(p1.x + but_wide + 2, p1.y + but_high + mainIni.menuSettings.vtpos), 0x10FFFFFF, 15, 10)
        end
    end
    imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 18)
    if bool then
        imgui.Text((' '):rep(3) .. icon)
        imgui.SameLine(60)
        imgui.Text(name)
    else
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
        imgui.SameLine(60)
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
    end
    imgui.SetCursorPosY(p2.y + but_high + 15)
    return result
end


function apply_n_t()
    if mainIni.theme.themeta == 'standart' then
        DarkTheme()
    elseif mainIni.theme.themeta == 'moonmonet' then
        gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
        local a, r, g, b = explode_argb(gen_color.accent1.color_300)
        curcolor = '{' .. rgb2hex(r, g, b) .. '}'
        curcolor1 = '0x' .. ('%X'):format(gen_color.accent1.color_300)
        apply_monet()
    end
end

function decor()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    style.WindowPadding = imgui.ImVec2(15, 15)
    style.WindowRounding = 10.0
    style.ChildRounding = mainIni.menuSettings.ChildRoundind
    style.FramePadding = imgui.ImVec2(8, 7)
    style.FrameRounding = 8.0
    style.ItemSpacing = imgui.ImVec2(8, 8)
    style.ItemInnerSpacing = imgui.ImVec2(10, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 20.0
    style.ScrollbarRounding = 12.0
    style.GrabMinSize = 10.0
    style.GrabRounding = 6.0
    style.PopupRounding = 8
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildBorderSize = 1.0
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
    colors[clr.ScrollbarBg] = imgui.ImVec4(0, 0, 0, 0)
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

function DarkTheme() -- https://www.blast.hk/threads/25442/post-973165
    imgui.SwitchContext()
    local style                                  = imgui.GetStyle()

    style.WindowPadding                          = imgui.ImVec2(15, 15)
    style.WindowRounding                         = 10.0
    style.ChildRounding                          = 6.0
    style.FramePadding                           = imgui.ImVec2(8, 7)
    style.FrameRounding                          = 8.0
    style.ItemSpacing                            = imgui.ImVec2(8, 8)
    style.ItemInnerSpacing                       = imgui.ImVec2(10, 6)
    style.IndentSpacing                          = 25.0
    style.ScrollbarSize                          = 13.0
    style.ScrollbarRounding                      = 12.0
    style.GrabMinSize                            = 10.0
    style.GrabRounding                           = 6.0
    style.PopupRounding                          = 8
    style.WindowTitleAlign                       = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign                        = imgui.ImVec2(0.5, 0.5)

    style.Colors[imgui.Col.Text]                 = imgui.ImVec4(0.80, 0.80, 0.83, 1.00)
    style.Colors[imgui.Col.TextDisabled]         = imgui.ImVec4(0.50, 0.50, 0.55, 1.00)
    style.Colors[imgui.Col.WindowBg]             = imgui.ImVec4(0.16, 0.16, 0.17, 1.00)
    style.Colors[imgui.Col.ChildBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.PopupBg]              = imgui.ImVec4(0.18, 0.18, 0.19, 1.00)
    style.Colors[imgui.Col.Border]               = imgui.ImVec4(0.31, 0.31, 0.35, 1.00)
    style.Colors[imgui.Col.BorderShadow]         = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]              = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]       = imgui.ImVec4(0.35, 0.35, 0.37, 1.00)
    style.Colors[imgui.Col.FrameBgActive]        = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
    style.Colors[imgui.Col.TitleBg]              = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]     = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.TitleBgActive]        = imgui.ImVec4(0.25, 0.25, 0.28, 1.00)
    style.Colors[imgui.Col.MenuBarBg]            = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]          = imgui.ImVec4(0.20, 0.20, 0.22, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]        = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]  = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.CheckMark]            = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
    style.Colors[imgui.Col.SliderGrab]           = imgui.ImVec4(0.60, 0.60, 0.63, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]     = imgui.ImVec4(0.70, 0.70, 0.73, 1.00)
    style.Colors[imgui.Col.Button]               = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.ButtonHovered]        = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ButtonActive]         = imgui.ImVec4(0.45, 0.45, 0.47, 1.00)
    style.Colors[imgui.Col.Header]               = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.HeaderHovered]        = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.HeaderActive]         = imgui.ImVec4(0.45, 0.45, 0.48, 1.00)
    style.Colors[imgui.Col.Separator]            = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]     = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.SeparatorActive]      = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
    style.Colors[imgui.Col.ResizeGrip]           = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]    = imgui.ImVec4(0.30, 0.30, 0.33, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]     = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.PlotLines]            = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]     = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
    style.Colors[imgui.Col.PlotHistogram]        = imgui.ImVec4(0.65, 0.65, 0.68, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(0.75, 0.75, 0.78, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]       = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]     = imgui.ImVec4(0.20, 0.20, 0.22, 0.80)
    style.Colors[imgui.Col.Tab]                  = imgui.ImVec4(0.25, 0.25, 0.27, 1.00)
    style.Colors[imgui.Col.TabHovered]           = imgui.ImVec4(0.35, 0.35, 0.38, 1.00)
    style.Colors[imgui.Col.TabActive]            = imgui.ImVec4(0.40, 0.40, 0.43, 1.00)
end

function join_argb(a, r, g, b)
    local argb = b                          -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

function imgui.Hint(str_id, hint_text, no_trinagle, show_always, y_offset)
    local p_orig = imgui.GetCursorPos()
    local hovered = show_always or imgui.IsItemHovered()
    imgui.SameLine(nil, 0)

    local animTime = 0.2
    local show = true

    if not allHints then allHints = {} end
    if not allHints[str_id] then
        allHints[str_id] = {
            status = false,
            timer = 0
        }
    end

    if hovered then
        for k, v in pairs(allHints) do
            if k ~= str_id and os.clock() - v.timer <= animTime then
                show = false
            end
        end
    end

    if show and allHints[str_id].status ~= hovered then
        allHints[str_id].status = hovered
        allHints[str_id].timer = os.clock()
    end

    local rend_window = function(alpha)
        local size = imgui.GetItemRectSize()
        local scrPos = imgui.GetCursorScreenPos()
        local DL = imgui.GetWindowDrawList()
        local center = imgui.ImVec2(scrPos.x - (size.x / 2), scrPos.y + (size.y / 2) - (alpha * 4) + (y_offset or 0))
        local a = imgui.ImVec2(center.x - 8, center.y - size.y - 1)
        local b = imgui.ImVec2(center.x + 8, center.y - size.y - 1)
        local c = imgui.ImVec2(center.x, center.y - size.y + 7)

        if no_trinagle then
            imgui.SetNextWindowPos(imgui.ImVec2(center.x, center.y - size.y / 2), imgui.Cond.Always,
                imgui.ImVec2(0.5, 1.0))
        else
            local bg_color = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.PopupBg])
            bg_color.w = alpha

            DL:AddTriangleFilled(a, b, c, u32(bg_color))
            imgui.SetNextWindowPos(imgui.ImVec2(center.x, center.y - size.y - 3), imgui.Cond.Always,
                imgui.ImVec2(0.5, 1.0))
        end
        imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(0, 0, 0, 0))
        imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.WindowBg])
        imgui.PushStyleColor(imgui.Col.WindowBg, imgui.GetStyle().Colors[imgui.Col.PopupBg])
        imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(5, 5))
        imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 6)
        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, alpha)

        imgui.Begin('bvsdfs##' .. str_id, _,
            imgui.WindowFlags.Tooltip + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
        for line in hint_text:gmatch('[^\n]+') do
            imgui.Text(line)
        end
        imgui.End()

        imgui.PopStyleVar(3)
        imgui.PopStyleColor(3)
    end

    if show then
        local between = os.clock() - allHints[str_id].timer
        if between <= animTime then
            local s = function(f)
                return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
            end
            local alpha = hovered and s(between / animTime) or s(1.00 - between / animTime)
            rend_window(alpha)
        elseif hovered then
            rend_window(1.00)
        end
    end

    imgui.SetCursorPos(p_orig)
end

--Íàø äàðàãîé Ìàñòóðáå÷åê
imgui.OnFrame(
    function() return joneV[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 350, 500
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY - 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        imgui.Begin('Jone', joneV, imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize)
        -- imgui.ImageURL(
        --     "https://sun9-73.userapi.com/impf/c622023/v622023770/33fd/T9qIlEYed6o.jpg?size=320x427&quality=96&sign=bfc6230a550a94c075a5b0747a7c6bca&c_uniq_tag=Kl4qcaTNH2y8ypcpjcIMF7CDzDRlSY1rwm8e1dQD504&type=album",
        --     imgui.ImVec2(200, 200), true)
        if window[0] then
            imgui.SetWindowFocus()

            if page == 8 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Ýòî - ñòðàíè÷êà áûñòðîãî âçàèìîäåéñòâèÿ.")
                imgui.Text(u8 "Òàê æå ýòî îêîøêî îòêðûâàåòñÿ ïðè äâîéíîì íàæàòèè íà èãðîêà(ðàáîòàåò êîðÿâî)")
                if imgui.Button(u8 'Äàëåå >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 2
                end
            elseif page == 2 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "À ýòî - îäíà èç ñàìûõ âûæíûõ âêëàäîê!\nÝòî áèíäåð, â êîòîðîì òû ìîæåøü\nñîçäàâàòü ñâîè êîìàíäû\nà òàê æå èçìåíÿòü ãîòîâûå!")
                if imgui.Button(u8 'Äàëåå >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 3
                end
            elseif page == 3 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Ýòî - âêëàäêà ãîñ. âîëíû\nÒóò òû ìîæåøü ñâÿçûâàòüñÿ ñ îðãàíèçàöèÿìè\nÔóíêöèé ïîêà ÷òî ìàëî, îíè áóäóò äîáàâëÿòüñÿ!")
                if imgui.Button(u8 'Äàëåå >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 5
                end
            elseif page == 5 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Ýòî - âêëàäêà ñ çàìåòêàìè. Çäåñü òû ìîæåøü íàïèñàòü âñå ÷òî óãîäíî è ïîñìîòðåòü ýòî â ëþáîé ìîìåíò")
                if imgui.Button(u8 'Äàëåå >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 6
                end
            elseif page == 6 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Òóò íàõîäèòñÿ èíô-ÿ î ÌÂÄ õåëïåðå")
                if imgui.Button(u8 'Äàëåå >>') then
                    page = 1
                end
            elseif page == 1 then -- åñëè çíà÷åíèå tab == 1
                imgui.SetWindowFocus()
                imgui.Text(u8 "Ýòî - âêëàäêà â êîòîðîé òû ìîæåøü ìåíÿ âûêëþ÷èòü. Íà ýòîé ñòðàíèöå åñòü íàñòðîéêà ÓÊ.\nÒàì òû ìîæåøü ñêà÷àòü äëÿ ñåáÿ ÓÊ èëè íàñòðîèòü åãî!\nÅùå òóò åñòü âûáîð òåìû MVD Helper. \nÒû ìîæåøü âûáðàòü MoonMonet è íàñòðîèòü ñâîé öâåò!")
                if imgui.Button(u8 'Âûêëþ÷èòü ìåíÿ', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    joneV[0] = false
                    mainIni.settings.Jone = false
                    inicfg.save(mainIni, "mvdhelper.ini")
                end
            
            end
        else
            imgui.Text(u8 "Ïðèâåò! ß " ..
                u8(mainIni.settings.ObuchalName) .. u8 ".\nß ïîìîãó òåáå íàó÷èòñÿ ðàáîòàòü ñ\nõåëïåðîì.")
            if imgui.Button(u8 'Äàëåå >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                window[0] = true
            end
            imgui.End()
        end
    end
)

imgui.OnFrame(
    function() return updateWin[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8 "Îáíîâëåíèå!", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        imgui.Text(u8 'Íàéäåíà íîâàÿ âåðñèÿ õåëïåðà: ' .. u8(version))
        imgui.Text(u8 'Â íåì åñòü íîâûé ôóíêöèîíàë!')
        imgui.Separator()
        imgui.CenterText(u8('Ñïèñîê äîáàâëåíûõ ôóíêöèé â âåðñèè ') .. u8(version) .. ':')
        imgui.Text(textnewupdate)
        imgui.Separator()
        if imgui.Button(u8 'Íå îáíîâëÿòüñÿ', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            updateWin[0] = false
        end
        imgui.SameLine()
        if imgui.Button(u8 'Çàãðóçèòü íîâóþ îáíîâó', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            downloadFile(updateUrl, helper_path)
            updateWin[0] = false
        end
        imgui.End()
    end
)


function startPatrul()
    startTime = os.time()
    isPatrolActive = true
end

function getPatrolDuration()
    local elapsedSeconds = os.time() - startTime
    local minutes = math.floor(elapsedSeconds / 60)
    local seconds = elapsedSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

function formatPatrolDuration(seconds)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    if minutes > 0 then
        return string.format("%d ìèíóò %d ñåêóíä", minutes, secs)
    else
        return string.format("%d ñåêóíä(-û)", secs)
    end
end

imgui.OnFrame(
    function() return patroolhelpmenu[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 100 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver,
            imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(225 * MONET_DPI_SCALE, 113 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 " ##patrol_menu", patroolhelpmenu,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)

        if isPatrolActive then
            imgui.Text(u8(' Âðåìÿ ïàòðóëèðîâàíèÿ: ') .. u8(getPatrolDuration()))
            imgui.Separator()
            if imgui.Button(u8('Äîêëàä'), imgui.ImVec2(100 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                lua_thread.create(function()
                    sampSendChat('/r' .. nickname .. ' íà CONTROL. Ïðîäîëæàþ ïàòðóëü')
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8('Çàâåðøèòü'), imgui.ImVec2(100 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                lua_thread.create(function()
                    isPatrolActive = false
                    sampSendChat('/r' .. nickname .. ' íà CONTROL. Çàâåðøàþ ïàòðóëü')
                    wait(1200)
                    sampSendChat('Ïàòðóëèðîâàë ' .. formatPatrolDuration(os.time() - startTime))
                    patrolDuration = 0
                    patrool_start_time = 0
                    patroolhelpmenu[0] = false
                end)
            end
        else
            if imgui.Button(u8(' Íà÷àòü ïàòðóëü'), imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                sampSendChat('/r' .. nickname .. ' íà CONTROL. Íà÷èíàþ ïàòðóëü.')
                startPatrul()
            end
        end

        imgui.End()
    end
)
imgui.OnFrame(
    function() return megafon[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Ìåãàôîí äààà", megafon,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar +
            imgui.WindowFlags.NoBackground)
        imgui.SameLine()
        if imgui.Button(fa.BULLHORN, imgui.ImVec2(75 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            sampSendChat('/m Âîäèòåëü, ñíèçüòå ñêîðîñòü è ïðèæìèòåñü ê îáî÷èíå.')
            sampSendChat('/m Ïîñëå îñòàíîâêè çàãëóøèòå äâèãàòåëü, äåðæèòå ðóêè íà ðóëå è íå âûõîäèòå èç òðàíñïîðòà.')
            sampSendChat('/m Â ñëó÷àå íåïîä÷èíåíèÿ ïî âàì áóäåò îòêðûò îãîíü!')
        end
        imgui.End()
    end
)


function getFilesInPath()
    local Files = {}
    for i = 1, 2 do
        table.insert(Files, getWorkingDirectory() .. '/arzfun/' .. i .. '.png')
    end
    return Files
end

function imgui.LoadFrames(path)
    local Files = getFilesInPath()
    local t = { Current = 1, Max = #Files, LastFrameTime = os.clock() }
    table.sort(Files, function(a, b)
        local aNum, bNum = tonumber(a:match('(%d+)%.png')), tonumber(b:match('(%d+)%.png'))
        return aNum < bNum
    end)
    for index = 1, #Files do
        t[index] = imgui.CreateTextureFromFile(Files[index])
    end
    return t
end

function imgui.DrawFrames(ImagesTable, size, FrameTime)
    if ImagesTable then
        imgui.Image(ImagesTable[ImagesTable.Current], size)
        if ImagesTable.LastFrameTime + ((FrameTime or 50) / 1000) - os.clock() <= 0 then
            ImagesTable.LastFrameTime = os.clock()
            if ImagesTable.Current ~= nil then
                ImagesTable.Current = ImagesTable[ImagesTable.Current + 1] == nil and 1 or
                    ImagesTable.Current + 1
            else
                ImagesTable.Current = 1
            end
        end
    end
end

--Èãðîêè ðÿäîì
function get_players_in_radius()
    local playersInRadius = {}
    for _, h in pairs(getAllChars()) do
        local temp2, id = sampGetPlayerIdByCharHandle(h)
        temp3, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local id = tonumber(id)
        if id ~= -1 and id ~= m and doesCharExist(h) then
            local x, y, z = getCharCoordinates(h)
            local mx, my, mz = getCharCoordinates(PLAYER_PED)
            local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
            if dist <= 3 then
                table.insert(playersInRadius, id)
            end
        end
    end
    return playersInRadius
end

--Ýêðàííûå êíîïêè
local buttonsJson = getWorkingDirectory() .. "/MVDHelper/buttons.json"
local standartButtons = {
    ['10-55'] = {'/m Âîäèòåëü, ñíèçüòå ñêîðîñòü è ïðèæìèòåñü ê îáî÷èíå.', '/m Äåðæèòå ðóêè íà ðóëå è çàãëóøèòå äâèãàòåëü'}
}

function readButtons()
    local file = io.open(buttonsJson, "r")
    if file then
        local buttonsJson = file:read("*a")
        file:close()
        return decodeJson(buttonsJson)
    else
        local file = io.open(buttonsJson, "w")
        file:write(encodeJson(standartButtons))
        file:close()
        return standartButtons
    end
end
function addNewButton(name, text)
    if not buttons then
        buttons = readButtons()
    end 
    local linesArray = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(linesArray, line)
    end
    buttons[name] = {}
    for i = 1, #linesArray do
        table.insert(buttons[name], linesArray[i])
    end
    local file = io.open(buttonsJson, "w")
    file:write(encodeJson(buttons))
    print(buttons)
    file:close()
end 

function loadButtons()
    if not buttons then
        buttons = readButtons()
    end
    local _ = imgui.new.bool(true)
    imgui.OnFrame(function() return _ end, function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(250, 250), imgui.Cond.FirstUseEver)
        imgui.Begin("pon", _, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoMove)
        for name, text in pairs(buttons) do
            if imgui.Button(u8(name)) then
                lua_thread.create(function()
					for i = 1, #text do
						sampSendChat (text[i])
						wait(1500)
					end
				end)
            end
            imgui.SameLine()
        end
        
        imgui.End()
    end)
end

function deleteButton(name)
    buttons[name] = nil
    local file = io.open(buttonsJson, "w")
    file:write(encodeJson(buttons))
    print(buttons)
    file:close()
end

function arrayToText(array)
    local result = ""
    for i = 1, #array do
      result = result .. array[i]
      if i < #array then
        result = result .. "\n"
      end
    end
    return result
  end

function getPlayerPass(json)
    let_v_shtate    = true
    local godashtat = json["level"]
    zakonoposlushen = true
    zakonka         = json["zakono"]
    rabotaet        = true
    local rabotka   = json["job"]
    imgui.StrCopy(rabota, rabotka)
    imgui.StrCopy(goda, godashtat)
end



function onReceivePacket(id, bs, ...) 
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8) 
        local type = raknetBitStreamReadInt8(bs)
        if type == 84 then
            local interfaceid = raknetBitStreamReadInt8(bs)
            local subid = raknetBitStreamReadInt8(bs)
            local len = raknetBitStreamReadInt16(bs) 
            local encoded = raknetBitStreamReadInt8(bs)
            local json = (encoded ~= 0) and raknetBitStreamDecodeString(bs, len + encoded) or raknetBitStreamReadString(bs, len)
            if interfaceid ==104 and subid == 2 then
                local json = decodeJson(json)
                if json["level"] then
                    sobes['pass'] = u8 "Ïðîâåðåíî"
                    getPlayerPass(json)
                end
            end
        end
    end
end

function checkUser()
    local serv = server
    if serv == "Unknown" then
        serv = sampGetCurrentServerAddress() .. ":" .. select(2, sampGetCurrentServerAddress())
    end
    local dat = {
        ['name'] = nickname,
        ['server'] = serv
    }

    local header = {
        ['Content-Type'] = 'application/x-www-form-urlencoded',
        ['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:134.0) Gecko/20100101 Firefox/134.0',
    }
    local url = "https://mvd.arzmod.com/test.php"
    requests.post(url, { data = dat, headers = header })

end
