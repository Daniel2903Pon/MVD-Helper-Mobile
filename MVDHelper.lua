---@diagnostic disable: need-check-nil, lowercase-global

script_name("MVD Helper Mobile")

script_version("5.6.1")
script_authors("@Sashe4ka_ReZoN", "@daniel29032012", "@makson4ck2", "@osp_x")

--Библиотеки
require('moonloader')
local copas            = require("copas")
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

--Кодировка
encoding.default       = 'CP1251'
local u8               = encoding.UTF8

--Окна
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
local BinderWindow     = imgui.new.bool(false)
local leaderPanel      = imgui.new.bool(false)
local MainWindow       = imgui.new.bool(false)

--Конфиг
local mainIni = inicfg.load({
    Accent = {
        accent = '[Молдавский акцент]: '
    },
    Info = {
        org = u8 'Вы не состоите в ПД',
        dl = u8 'Вы не состоите в ПД',
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
        ObuchalName = "Мастурбек",
        button = false
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
        xpos = 59,
        vtpos = 8,
        ChildRoundind = 10
    }
}, "mvdhelper.ini")
inicfg.save(mainIni, 'mvdhelper.ini')

--Остальные переменные
local new             = imgui.new
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
local arr             = os.date("*t")
local newUkInput      = imgui.new.char(255)
local newUkUr         = imgui.new.int(0)
local spawn           = true
local autogun         = new.bool(mainIni.settings.autoRpGun)
local selected_theme  = imgui.new.int(mainIni.theme.selected)
local theme_a         = { u8 'Стандартная', 'MoonMonet' }
local theme_t         = { u8 'standart', 'moonmonet' }
local items           = imgui.new['const char*'][#theme_a](theme_a)
local AutoAccentBool  = new.bool(mainIni.settings.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org             = u8 'Вы не состоите в ПД'
local org_g           = u8 'Вы не состоите в ПД'
local dol             = 'Вы не состоите в ПД'
local dl              = u8 'Вы не состоите в ПД'
local rang_n          = 0
local notes           = {}
local newNoteTitle    = imgui.new.char[256]()
local newNoteContent  = imgui.new.char[1024]()
local editNoteTitle   = imgui.new.char[256]()
local editNoteContent = imgui.new.char[1024]()
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
local servers = {
    ["80.66.82.162"]    = { number = -1, name = "Mobile I" },
    ["80.66.82.148"]    = { number = -2, name = "Mobile II" },
    ["80.66.82.136"]    = { number = -3, name = "Mobile III" },
    ["185.169.134.44"]  = { number = 4, name = "Chandler" },
    ["185.169.134.43"]  = { number = 3, name = "Scottdale" },
    ["185.169.134.45"]  = { number = 5, name = "Brainburg" },
    ["185.169.134.5"]   = { number = 6, name = "Saint-Rose" },
    ["185.169.132.107"] = { number = 6, name = "Saint-Rose" },
    ["185.169.134.59"]  = { number = 7, name = "Mesa" },
    ["185.169.134.61"]  = { number = 8, name = "Red-Rock" },
    ["185.169.134.107"] = { number = 9, name = "Yuma" },
    ["185.169.134.109"] = { number = 10, name = "Surprise" },
    ["185.169.134.166"] = { number = 11, name = "Prescott" },
    ["185.169.134.171"] = { number = 12, name = "Glendale" },
    ["185.169.134.172"] = { number = 13, name = "Kingman" },
    ["185.169.134.173"] = { number = 14, name = "Winslow" },
    ["185.169.134.174"] = { number = 15, name = "Payson" },
    ["80.66.82.191"]    = { number = 16, name = "Gilbert" },
    ["80.66.82.190"]    = { number = 17, name = "Show Low" },
    ["80.66.82.188"]    = { number = 18, name = "Casa-Grande" },
    ["80.66.82.168"]    = { number = 19, name = "Page" },
    ["80.66.82.159"]    = { number = 20, name = "Sun-City" },
    ["80.66.82.200"]    = { number = 21, name = "Queen-Creek" },
    ["80.66.82.144"]    = { number = 22, name = "Sedona" },
    ["80.66.82.132"]    = { number = 23, name = "Holiday" },
    ["80.66.82.128"]    = { number = 24, name = "Wednesday" },
    ["80.66.82.113"]    = { number = 25, name = "Yava" },
    ["80.66.82.82"]     = { number = 26, name = "Faraway" },
    ["80.66.82.87"]     = { number = 27, name = "Bumble Bee" },
    ["80.66.82.54"]     = { number = 28, name = "Christmas" },
    ["80.66.82.39"]     = { number = 29, name = "Mirage" },
    ["80.66.82.33"]     = { number = 30, name = "Love" },
    ["185.169.134.3"]   = { number = 1, name = "Phoenix" },
    ["185.169.132.105"] = { number = 1, name = "Phoenix" },
    ["185.169.134.4"]   = { number = 2, name = "Tucson" },
    ["185.169.132.106"] = { number = 2, name = "Tucson" },
}
local changingInfo    = false
local ObuchalName     = new.char[255](u8(mainIni.settings.ObuchalName))
local orga            = imgui.new.char[255](u8(mainIni.Info.org))
local dolzh           = imgui.new.char[255](u8(mainIni.Info.dl))
local spawncar_bool   = false
local jsonFile        = getWorkingDirectory() .. "/MVDHelper/gunCommands.json"
local weapons         = {
    "Дубинка",
    "Граната",
    "Слезоточивый газ",
    "Тайзер",
    "Colt-45",
    "Desert Eagle",
    "Дробовик",
    "Обрезы",
    "Spas",
    "УЗИ",
    "МП5",
    "AK-47",
    "М4",
    "TEC-9",
    "Винтовка",
    "Снайперская винтовка",
    "Фотокамера",
    "Без оружия"
}
local gunCommands     = {
    "/me достал дубинку с поясного держателя",
    "/me взял с пояса гранату",
    "/me взял гранату слезоточивого газа с пояса",
    "/me достал тайзер с кобуры, убрал предохранитель",
    "/me достал пистолет Colt-45, снял предохранитель",
    "/me достал Desert Eagle с кобуры, убрал предохранитель",
    "/me достал чехол со спины, взял дробовик и убрал предохранитель",
    "/me резким движением обоих рук, снял военный рюкзак с плеч и достал Обрезы",
    "/me достал дробовик Spas, снял предохранитель",
    "/me резким движением обоих рук, снял военный рюкзак с плеч и достал УЗИ",
    "/me достал чехол со спины, взял МП5 и убрал предохранитель",
    "/me достал карабин AK-47 со спины",
    "/me достал карабин М4 со спины",
    "/me резким движением обоих рук, снял военный рюкзак с плеч и достал TEC-9",
    "/me достал винтовку без прицела из военной сумки",
    "/me достал Снайперскую винтовку с военной сумки",
    "/me достал фотокамеру из рюкзака",
    "/me поставил предохранитель, убрал оружие"
}
local newButtonText   = imgui.new.char[255]()
local newButtonCommand= imgui.new.char[2555]()
local pages = {
    { icon = faicons("HOUSE"), title = "  Главная", index = 8 },
    { icon = faicons("BOOK"), title = "  Биндер", index = 2 },
    { icon = faicons("TOWER_BROADCAST"), title = "  Гос. волна ", index = 3 },
    { icon = faicons("RECTANGLE_LIST"), title = "  Заметки", index = 5 },
    { icon = faicons("CIRCLE_INFO"), title = "  Инфо", index = 6 },
    { icon = faicons("GEAR"), title = "  Настройки", index = 1 },
}

--MOONMONET START
function join_argb(a, r, g, b)
    local argb = b                          -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end
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
--MOONMONET END 

--MTG mods binder START
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
        print('[Binder] Файл с настройками не найден, использую стандартные настройки!')
    else
        local file = io.open(path, 'r')
        if file then
            local contents = file:read('*a')
            file:close()
            if #contents == 0 then
                settings = default_settings
                print('[Binder] Не удалось открыть файл с настройками, использую стандартные настройки!')
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
                    print('[Binder] Настройки успешно загружены!')
                else
                    print('[Binder] Не удалось открыть файл с настройками, использую стандартные настройки!')
                end
            end
        else
            settings = default_settings
            downloadBinder()
            print('[Binder] Не удалось открыть файл с настройками, использую стандартные настройки!')
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
        print('[Binder] Не удалось сохранить настройки хелпера, ошибка: ', errstr)
        return false
    end
end

load_settings()
function isMonetLoader() return MONET_VERSION ~= nil end

if MONET_DPI_SCALE == nil then MONET_DPI_SCALE = 1.0 end


local message_color = 0x00CCFF
local message_color_hex = '{00CCFF}'

local sizeX, sizeY = getScreenResolution()
local ComboTags = new.int()
local item_list = { u8 'Без аргумента', u8 '{arg} - принимает что угодно, буквы/цифры/символы', u8 '{arg_id} - принимает только ID игрока',
    u8 '{arg_id} {arg2} - принимает 2 аругмента: ID игрока и второе что угодно' }
local ImItems = imgui.new['const char*'][#item_list](item_list)
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
{my_id} - Ваш игровой ID
{my_nick} - Ваш игровой Nick
{my_ru_nick} - Ваше Имя и Фамилия указанные в хелпере

{get_time} - Получить текущее время

{get_nick({arg_id})} - получить Nick игрока из аргумента ID игрока
{get_rp_nick({arg_id})}  - получить Nick игрока без символа _ из аргумента ID игрока
{get_ru_nick({arg_id})}  - получить Nick игрока на кирилице из аргумента ID игрока
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
                    msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [аргумент]',
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
                    msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока]',
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
                            '[Binder] {ffffff}Используйте ' ..
                            message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
                        play_error_sound()
                    end
                else
                    msg(
                        '[Binder] {ffffff}Используйте ' ..
                        message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]',
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
                            msg('[Binder] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!",
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
            msg('[Binder] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
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
    decor() -- применяем декор часть
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
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14 * MDS, config, iconRanges) -- solid - тип иконок, так же есть thin, regular, light и duotone
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
local MainWindow = imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.TERMINAL .. u8 " Binder by MTG MODS - Главное меню", MainWindow,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)

        if imgui.BeginChild('##1', imgui.ImVec2(700 * MONET_DPI_SCALE, 700 * MONET_DPI_SCALE), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "Команда")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Описание")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Действие")
            imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/binder")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Открыть главное меню биндера")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Недоступно")
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/stop [Недоступен]")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Остановить любую отыгровку из биндера [Недоступен]")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Недоступно")
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
                            imgui.SetTooltip(u8 "Отключение команды /" .. command.cmd)
                        end
                    else
                        if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Включение команды /" .. command.cmd)
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
                        imgui.SetTooltip(u8 "Изменение команды /" .. command.cmd)
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
                        imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. command.cmd)
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Удаление команды /" .. command.cmd)
                    end
                    if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. command.cmd, _, imgui.WindowFlags.NoResize) then
                        imgui.CenterText(u8 'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
                        imgui.Separator()
                        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Нет, отменить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(fa.TRASH_CAN .. u8 ' Да, удалить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
        if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Создать новую команду##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            local new_cmd = {
                cmd = '',
                description = 'Новая команда созданная вами',
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
        imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425 * MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.TERMINAL .. u8 " Binder by MTG MODS - Редактирование команды /" .. change_cmd, BinderWindow,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * MONET_DPI_SCALE, 361 * MONET_DPI_SCALE), true) then
            imgui.CenterText(fa.FILE_LINES .. u8 ' Описание команды:')
            imgui.PushItemWidth(579 * MONET_DPI_SCALE)
            imgui.InputText("##input_description", input_description, 256)
            imgui.Separator()
            imgui.CenterText(fa.TERMINAL .. u8 ' Команда для использования в чате (без /):')
            imgui.PushItemWidth(579 * MONET_DPI_SCALE)
            imgui.InputText("##input_cmd", input_cmd, 256)
            imgui.Separator()
            imgui.CenterText(fa.CODE .. u8 ' Аргументы которые принимает команда:')
            imgui.Combo(u8 '', ComboTags, ImItems, #item_list)
            imgui.Separator()
            imgui.CenterText(fa.FILE_WORD .. u8 ' Текстовый бинд команды:')
            imgui.InputTextMultiline("##text_multiple", input_text, 8192,
                imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
            imgui.EndChild()
        end
        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            BinderWindow[0] = false
        end
        imgui.SameLine()
        if imgui.Button(fa.CLOCK .. u8 ' Задержка', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            imgui.OpenPopup(fa.CLOCK .. u8 ' Задержка (в секундах) ')
        end
        if imgui.BeginPopupModal(fa.CLOCK .. u8 ' Задержка (в секундах) ', _, imgui.WindowFlags.NoResize) then
            imgui.PushItemWidth(200 * MONET_DPI_SCALE)
            imgui.SliderFloat(u8 '##waiting', waiting_slider, 0.3, 5)
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                waiting_slider = imgui.new.float(tonumber(change_waiting))
                imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
            if imgui.Button(fa.FLOPPY_DISK .. u8 ' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.SameLine()
        if imgui.Button(fa.TAGS .. u8 ' Тэги ', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            imgui.OpenPopup(fa.TAGS .. u8 ' Основные тэги для использования в биндере')
        end
        if imgui.BeginPopupModal(fa.TAGS .. u8 ' Основные тэги для использования в биндере', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8(binder_tags_text))
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.SameLine()
        if imgui.Button(fa.FLOPPY_DISK .. u8 ' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
            if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
                imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Ошибка сохранения команды!')
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
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg_id}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg_id} {arg2}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex ..
                                    '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!',
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
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg_id}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!',
                                    message_color)
                            elseif command.arg == '{arg_id} {arg2}' then
                                msg(
                                    '[Binder] {ffffff}Команда ' ..
                                    message_color_hex ..
                                    '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!',
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
        if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Ошибка сохранения команды!', _, imgui.WindowFlags.AlwaysAutoResize) then
            if ffi.string(input_cmd):find('%W') then
                imgui.BulletText(u8 " В команде можно использовать только англ. буквы и/или цифры!")
            elseif ffi.string(input_cmd) == '' then
                imgui.BulletText(u8 " Команда не может быть пустая!")
            end
            if ffi.string(input_description) == '' then
                imgui.BulletText(u8 " Описание команды не может быть пустое!")
            end
            if ffi.string(input_text) == '' then
                imgui.BulletText(u8 " Бинд команды не может быть пустой!")
            end
            imgui.Separator()
            if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Закрыть', imgui.ImVec2(300 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                imgui.CloseCurrentPopup()
            end
            imgui.End()
        end
        imgui.End()
    end
)

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
    [168] = 'Ё',
    [184] = 'ё',
    [192] = 'А',
    [193] = 'Б',
    [194] = 'В',
    [195] = 'Г',
    [196] = 'Д',
    [197] = 'Е',
    [198] = 'Ж',
    [199] = 'З',
    [200] = 'И',
    [201] = 'Й',
    [202] = 'К',
    [203] = 'Л',
    [204] = 'М',
    [205] = 'Н',
    [206] = 'О',
    [207] = 'П',
    [208] = 'Р',
    [209] = 'С',
    [210] = 'Т',
    [211] = 'У',
    [212] = 'Ф',
    [213] = 'Х',
    [214] = 'Ц',
    [215] = 'Ч',
    [216] = 'Ш',
    [217] = 'Щ',
    [218] = 'Ъ',
    [219] = 'Ы',
    [220] = 'Ь',
    [221] = 'Э',
    [222] = 'Ю',
    [223] = 'Я',
    [224] = 'а',
    [225] = 'б',
    [226] = 'в',
    [227] = 'г',
    [228] = 'д',
    [229] = 'е',
    [230] = 'ж',
    [231] = 'з',
    [232] = 'и',
    [233] = 'й',
    [234] = 'к',
    [235] = 'л',
    [236] = 'м',
    [237] = 'н',
    [238] = 'о',
    [239] = 'п',
    [240] = 'р',
    [241] = 'с',
    [242] = 'т',
    [243] = 'у',
    [244] = 'ф',
    [245] = 'х',
    [246] = 'ц',
    [247] = 'ч',
    [248] = 'ш',
    [249] = 'щ',
    [250] = 'ъ',
    [251] = 'ы',
    [252] = 'ь',
    [253] = 'э',
    [254] = 'ю',
    [255] = 'я',
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
        elseif ch == 168 then           -- Ё
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
        elseif ch == 184 then           -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function TranslateNick(name)
    if name:match('%a+') then
        for k, v in pairs({ ['ph'] = 'ф', ['Ph'] = 'Ф', ['Ch'] = 'Ч', ['ch'] = 'ч', ['Th'] = 'Т', ['th'] = 'т', ['Sh'] = 'Ш', ['sh'] = 'ш', ['ea'] = 'и', ['Ae'] = 'Э', ['ae'] = 'э', ['size'] = 'сайз', ['Jj'] = 'Джейджей', ['Whi'] = 'Вай', ['lack'] = 'лэк', ['whi'] = 'вай', ['Ck'] = 'К', ['ck'] = 'к', ['Kh'] = 'Х', ['kh'] = 'х', ['hn'] = 'н', ['Hen'] = 'Ген', ['Zh'] = 'Ж', ['zh'] = 'ж', ['Yu'] = 'Ю', ['yu'] = 'ю', ['Yo'] = 'Ё', ['yo'] = 'ё', ['Cz'] = 'Ц', ['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и', ['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав', ['ay'] = 'эй', ['rise'] = 'райз', ['oo'] = 'у', ['Oo'] = 'У', ['Ee'] = 'И', ['ee'] = 'и', ['Un'] = 'Ан', ['un'] = 'ан', ['Ci'] = 'Ци', ['ci'] = 'ци', ['yse'] = 'уз', ['cate'] = 'кейт', ['eow'] = 'яу', ['rown'] = 'раун', ['yev'] = 'уев', ['Babe'] = 'Бэйби', ['Jason'] = 'Джейсон', ['liy'] = 'лий', ['ane'] = 'ейн', ['ame'] = 'ейм' }) do
            name = name:gsub(k, v)
        end
        for k, v in pairs({ ['B'] = 'Б', ['Z'] = 'З', ['T'] = 'Т', ['Y'] = 'Й', ['P'] = 'П', ['J'] = 'Дж', ['X'] = 'Кс', ['G'] = 'Г', ['V'] = 'В', ['H'] = 'Х', ['N'] = 'Н', ['E'] = 'Е', ['I'] = 'И', ['D'] = 'Д', ['O'] = 'О', ['K'] = 'К', ['F'] = 'Ф', ['y`'] = 'ы', ['e`'] = 'э', ['A'] = 'А', ['C'] = 'К', ['L'] = 'Л', ['M'] = 'М', ['W'] = 'В', ['Q'] = 'К', ['U'] = 'А', ['R'] = 'Р', ['S'] = 'С', ['zm'] = 'зьм', ['h'] = 'х', ['q'] = 'к', ['y'] = 'и', ['a'] = 'а', ['w'] = 'в', ['b'] = 'б', ['v'] = 'в', ['g'] = 'г', ['d'] = 'д', ['e'] = 'е', ['z'] = 'з', ['i'] = 'и', ['j'] = 'ж', ['k'] = 'к', ['l'] = 'л', ['m'] = 'м', ['n'] = 'н', ['o'] = 'о', ['p'] = 'п', ['r'] = 'р', ['s'] = 'с', ['t'] = 'т', ['u'] = 'у', ['f'] = 'ф', ['x'] = 'x', ['c'] = 'к', ['``'] = 'ъ', ['`'] = 'ь', ['_'] = ' ' }) do
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
--MTG mods binder END

-- Timer START
local cfg = mainIni
mcx = 0x0087FF
local sX, sY = getScreenResolution()
local to = new.bool(cfg.statTimers.state)
local nowTime = os.date("%H:%M:%S", os.time())
local settingsonline = new.bool(false)
local myOnline = new.bool(false)
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
    [0] = 'Воскресенье',
    [1] = 'Понедельник',
    [2] = 'Вторник',
    [3] = 'Среда',
    [4] = 'Четверг',
    [5] = 'Пятница',
    [6] = 'Суббота'
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
            --imgui.CenterTextColoredRGB("Подключение: " .. get_clock(connectingTime))
        else
            if cfg.statTimers.sesOnline then imgui.CenterTextColoredRGB("Сессия (чистый): " .. get_clock(sesOnline[0])) end
            if cfg.statTimers.sesAfk then imgui.CenterTextColoredRGB("AFK за сессию: " .. get_clock(sesAfk[0])) end
            if cfg.statTimers.sesFull then imgui.CenterTextColoredRGB("Онлайн за сессию: " .. get_clock(sesFull[0])) end
            if cfg.statTimers.dayOnline then
                imgui.CenterTextColoredRGB("За день (чистый): " ..
                    get_clock(cfg.onDay.online))
            end
            if cfg.statTimers.dayAfk then imgui.CenterTextColoredRGB("АФК за день: " .. get_clock(cfg.onDay.afk)) end
            if cfg.statTimers.dayFull then imgui.CenterTextColoredRGB("Онлайн за день: " .. get_clock(cfg.onDay.full)) end
            if cfg.statTimers.weekOnline then
                imgui.CenterTextColoredRGB("За неделю (чистый): " ..
                    get_clock(cfg.onWeek.online))
            end
            if cfg.statTimers.weekAfk then imgui.CenterTextColoredRGB("АФК за неделю: " .. get_clock(cfg.onWeek.afk)) end
            if cfg.statTimers.weekFull then imgui.CenterTextColoredRGB("Онлайн за неделю: " .. get_clock(cfg.onWeek.full)) end
        end
        imgui.PopStyleVar()
        if editpos and imgui.Button(u8 "Закрепить", imgui.ImVec2(-1, 35)) then
            editpos = false
            settingsonline[0] = true
            cfg.pos.x, cfg.pos.y = pos.x, pos.y
            inicfg.save(mainIni, 'mvdhelper.ini')
            msg('Позиция окна сохранена!')
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

        if imgui.RadioButtonBool(u8 'Текущее дата и время', Radio['clock']) then
            Radio['clock'] = not Radio['clock']; cfg.statTimers.clock = Radio['clock']
        end
        if imgui.RadioButtonBool(u8 'Онлайн сессию', Radio['sesOnline']) then
            Radio['sesOnline'] = not Radio['sesOnline']; cfg.statTimers.sesOnline = Radio['sesOnline']
        end
        imgui.Hint('##1234', u8 'Без учёта АФК (Чистый онлайн)')
        if imgui.RadioButtonBool(u8 'AFK за сессию', Radio['sesAfk']) then
            Radio['sesAfk'] = not Radio['sesAfk']; cfg.statTimers.sesAfk = Radio['sesAfk']
        end
        if imgui.RadioButtonBool(u8 'Общий за сессию', Radio['sesFull']) then
            Radio['sesFull'] = not Radio['sesFull']; cfg.statTimers.sesFull = Radio['sesFull']
        end
        if imgui.RadioButtonBool(u8 'Онлайн за день', Radio['dayOnline']) then
            Radio['dayOnline'] = not Radio['dayOnline']; cfg.statTimers.dayOnline = Radio['dayOnline']
        end
        imgui.Hint('##1233', u8 'Без учёта АФК (Чистый онлайн)')
        if imgui.RadioButtonBool(u8 'АФК за день', Radio['dayAfk']) then
            Radio['dayAfk'] = not Radio['dayAfk']; cfg.statTimers.dayAfk = Radio['dayAfk']
        end
        if imgui.RadioButtonBool(u8 'Общий за день', Radio['dayFull']) then
            Radio['dayFull'] = not Radio['dayFull']; cfg.statTimers.dayFull = Radio['dayFull']
        end
        if imgui.RadioButtonBool(u8 'Онлайн за неделю', Radio['weekOnline']) then
            Radio['weekOnline'] = not Radio['weekOnline']; cfg.statTimers.weekOnline = Radio['weekOnline']
        end
        imgui.Hint('##123', u8 'Без учёта АФК (Чистый онлайн)')
        if imgui.RadioButtonBool(u8 'АФК за неделю', Radio['weekAfk']) then
            Radio['weekAfk'] = not Radio['weekAfk']; cfg.statTimers.weekAfk = Radio['weekAfk']
        end
        if imgui.RadioButtonBool(u8 'Общий за неделю', Radio['weekFull']) then
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
            imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8 'Включено')
        else
            imgui.TextDisabled(u8 'Выключено')
        end
        if imgui.Button(u8 'Местоположение', imgui.ImVec2(-1, 30 * MDS)) then
            editpos = true
            settingsonline[0] = false
            msg('Перемещайте окно')
        end
        if cfg.statTimers.server == sampGetCurrentServerAddress() then
            if imgui.Button(u8(sampGetCurrentServerName()), imgui.ImVec2(-1, 30 * MDS)) then
                cfg.statTimers.server = nil
                msg('Теперь этот сервер не считается основным!')
            end
        else
            if imgui.Button(u8 'Установить этот сервер основным', imgui.ImVec2(-1, 30 * MDS)) then
                cfg.statTimers.server = sampGetCurrentServerAddress()
                msg('Теперь онлайн будет считаться только на этом сервере!')
            end
            imgui.Hint('##1123', u8 'Скрипт будет запускаться только на этом сервере!')
        end
        imgui.PushItemWidth(-1)
        if imgui.SliderFloat('##Round', sRound, 0.0, 10.0, u8 "Скругление краёв: %.2f") then
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
        imgui.Text(u8 'Цвет фона')
        if imgui.ColorEdit4(u8 '##Texta', colorT, imgui.ColorEditFlags.NoInputs) then
            argbT = imgui.ColorConvertFloat4ToU32(
                imgui.ImVec4(colorT[0], colorT[1], colorT[2], colorT[3])
            )
            cfg.style.colorT = argbT
        end
        imgui.SameLine()
        imgui.Text(u8 'Цвет текста')

        imgui.EndChild()
        if imgui.Button(u8 'Сохранить и закрыть', imgui.ImVec2(-1, 30 * MDS)) then
            if inicfg.save(mainIni, 'mvdhelper.ini') then
                msg('Настройки сохранены!')
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
    imgui.CenterTextColoredRGB('Онлайн за неделю')
    imgui.PopFont()
    imgui.CenterTextColoredRGB('{0087FF}Всего отыграно: ' .. get_clock(cfg.onWeek.full))
    imgui.NewLine()
    for day = 1, 6 do -- ПН -> СБ
        imgui.Text(u8(tWeekdays[day])); imgui.SameLine(250 * MDS)
        imgui.Text(get_clock(cfg.myWeekOnline[day]))
    end
    --> ВС
    imgui.Text(u8(tWeekdays[0])); imgui.SameLine(250 * MDS)
    imgui.Text(get_clock(cfg.myWeekOnline[0]))

    imgui.SetCursorPosX((imgui.GetWindowWidth() - 200 * MDS) / 2)
    if imgui.Button(u8 'Закрыть', imgui.ImVec2(200 * MDS, 25 * MDS)) then myOnline[0] = false end
    imgui.End()
end)


function time()
    startTime = os.time() -- "Точка отсчёта"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampIsLocalPlayerSpawned() then                       -- Игровой статус равен "Подключён к серверу" (Что бы онлайн считало только, когда, мы подключены к серверу)
            sesOnline[0] = sesOnline[0] + 1                      -- Онлайн за сессию без учёта АФК
            sesFull[0] = os.time() - startTime                   -- Общий онлайн за сессию
            sesAfk[0] = sesFull[0] - sesOnline[0]                -- АФК за сессию

            cfg.onDay.online = cfg.onDay.online + 1              -- Онлайн за день без учёта АФК
            cfg.onDay.full = dayFull[0] + sesFull[0]             -- Общий онлайн за день
            cfg.onDay.afk = cfg.onDay.full - cfg.onDay.online    -- АФК за день

            cfg.onWeek.online = cfg.onWeek.online + 1            -- Онлайн за неделю без учёта АФК
            cfg.onWeek.full = weekFull[0] + sesFull[0]           -- Общий онлайн за неделю
            cfg.onWeek.afk = cfg.onWeek.full - cfg.onWeek.online -- АФК за неделю

            local today = tonumber(os.date('%w', os.time()))
            cfg.myWeekOnline[today] = cfg.onDay.full

            connectingTime = 0
        else
            connectingTime = connectingTime + 1 -- Вермя подключения к серверу
            startTime = startTime + 1           -- Смещение начала отсчета таймеров
        end
    end
end

function autoSave()
    while true do
        wait(60000) -- сохранение каждые 60 секунд
        inicfg.save(mainIni, "mvdhelper.ini")
    end
end

function number_week() -- получение номера недели в году
    local current_time = os.date '*t'
    local start_year = os.time { year = current_time.year, day = 1, month = 1 }
    local week_day = (os.date('%w', start_year) - 1) % 7
    return math.ceil((current_time.yday + week_day) / 7)
end

function getStrDate(unixTime)
    local tMonths = { 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября',
        'ноября', 'декабря' }
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400) .. 'д ' or '') .. '%H:%M:%S', time + timezone_offset)
end
function timerMain()
    if cfg.statTimers.server ~= nil and cfg.statTimers.server ~= sampGetCurrentServerAddress() then
        msg('Вы зашли на свой не основной сервер. Скрипт отключён!')
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
-- Timer END

--Menu sizes START
local xsize         = imgui.new.int(mainIni.menuSettings.x)
local ysize         = imgui.new.int(mainIni.menuSettings.y)
local tabsize       = imgui.new.int(mainIni.menuSettings.tab)
local snegPos       = imgui.new.int(mainIni.menuSettings.snegPos)
local xpos          = imgui.new.int(mainIni.menuSettings.xpos)
local vtpos         = imgui.new.int(mainIni.menuSettings.vtpos)
local childRounding = imgui.new.int(mainIni.menuSettings.ChildRoundind)
imgui.OnFrame(function() return menuSizes[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 300), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Настройки окна', menuSizes)
    imgui.SliderInt(u8 "Ширина окна", xsize, 200, 1000)
    imgui.SliderInt(u8 "Высота окна", ysize, 200, 1000)
    imgui.SliderInt(u8 "Ширина таб бара", tabsize, 100, 700)
    imgui.SliderInt(u8 "Положение крестика", xpos, 1, 1000)
    imgui.SliderInt(u8 "Положение обводки выбранного таба", vtpos, 1, 15)
    imgui.SliderInt(u8 "Закругление окна и чаилдов(нужно будет перезагрузить скрипт)", childRounding, 0, 25)
    --Темы
    if imgui.Combo(u8 'Темы', selected_theme, items, #theme_a) then
        themeta = theme_t[selected_theme[0] + 1]
        mainIni.theme.themeta = themeta
        mainIni.theme.selected = selected_theme[0]
        inicfg.save(mainIni, 'mvdhelper.ini')
        apply_n_t()
    end
    imgui.Text(u8 'Цвет MoonMonet - ')
    imgui.SameLine()
    if imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
        r, g, b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
        argb = join_argb(0, r, g, b)
        mainIni.theme.moonmonet = argb
        inicfg.save(mainIni, 'mvdhelper.ini')
        apply_n_t()
    end
    --Конец тем
    mainIni.menuSettings.x = xsize[0]
    mainIni.menuSettings.y = ysize[0]
    mainIni.menuSettings.tab = tabsize[0]
    mainIni.menuSettings.snegPos = snegPos[0]
    mainIni.menuSettings.xpos = xpos[0]
    mainIni.menuSettings.vtpos = vtpos[0]
    mainIni.menuSettings.ChildRoundind = childRounding[0]
    if imgui.Button(u8 "Сохранить") then
        inicfg.save(mainIni, "mvdhelper.ini")
    end
    imgui.End()
end)
--Menu sizes END

--Vzaim menu START
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
imgui.OnFrame(function() return vzWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.3), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8 '', vzWindow,
        imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar)
    if imgui.Button(u8 "Взаимодействие") then
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
    imgui.Begin(u8 'Взаимодействие', vzaimWindow)
    imgui.Text(u8 "Выберите игрока для взаимодействия")
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
    imgui.Begin(u8 'Взаимодействие с ' .. sampGetPlayerNickname(id[0]), fastVzaimWindow)
    if imgui.Button(u8 'Приветствие') then
        lua_thread.create(function()
            sampSendChat("Доброго времени суток, я «" .. nickname .. "» «" .. u8:decode(mainIni.Info.dl) .. "».")
            wait(1500)
            sampSendChat("/do Удостоверение в руках.")
            wait(1500)
            sendMe(" показал своё удостоверение человеку на против")
            wait(1500)
            sampSendChat("/do «" .. nickname .. "».")
            wait(1500)
            sampSendChat("/do «" .. u8:decode(mainIni.Info.dl) .. "» " .. mainIni.Info.org .. ".")
            wait(1500)
            sampSendChat("Предъявите ваши документы, а именно паспорт. Не беспокойтесь, это всего лишь проверка.")
            wait(1500)
            sampSendChat("/showbadge ")
        end)
    end
    if imgui.Button(u8 'Найти игрока') then
        lua_thread.create(function()
            sampSendChat("/do КПК в левом кармане.")
            wait(1500)
            sendMe(" достал левой рукой КПК из кармана")
            wait(1500)
            sampSendChat("/do КПК в левой руке.")
            wait(1500)
            sendMe(" включил КПК и зашел в базу данных Полиции")
            wait(1500)
            sendMe(" открыл дело номер " .. id[0] .. " преступника")
            wait(1500)
            sampSendChat("/do Данные преступника получены.")
            wait(1500)
            sendMe(" подключился к камерам слежения штата")
            wait(1500)
            sampSendChat("/do На навигаторе появился маршрут.")
            wait(1500)
            sampSendChat("/pursuit " .. id[0])
        end)
    end
    if imgui.Button(u8 'Арест') then
        lua_thread.create(function()
            sendMe(" взял ручку из кармана рубашки, затем открыл бардачок и взял оттуда бланк протокола")
            wait(1500)
            sampSendChat("/do Бланк протокола и ручка в руках.")
            wait(1500)
            sendMe(" заполняет описание внешности нарушителя")
            wait(1500)
            sendMe(" заполняет характеристику о нарушителе")
            wait(1500)
            sendMe(" заполняет данные о нарушении")
            wait(1500)
            sendMe(" проставил дату и подпись")
            wait(1500)
            sendMe(" положил ручку в карман рубашки")
            wait(1500)
            sampSendChat("/do Ручка в кармане рубашки.")
            wait(1500)
            sendMe(" передал бланк составленного протокола в участок")
            wait(1500)
            sendMe(" передал преступника в Управление Полиции под стражу")
            wait(1500)
            sampSendChat("/arrest")
            msg("Встаньте на чекпоинт", 0x8B00FF)
        end)
    end
    if imgui.Button(u8 'Надеть наручники') then
        lua_thread.create(function()
            sampSendChat("/do Наручники висят на поясе.")
            wait(1500)
            sendMe(" снял с держателя наручники")
            wait(1500)
            sampSendChat("/do Наручники в руках.")
            wait(1500)
            sendMe(" резким движением обеих рук, надел наручники на преступника")
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
            sendMe(" движением правой руки достал из кармана ключ и открыл наручники")
            wait(1500)
            sampSendChat("/do Преступник раскован.")
            wait(1500)
            sampSendChat("/uncuff " .. id[0])
        end)
    end
    if imgui.Button(u8 'Вести за собой') then
        lua_thread.create(function()
            sampSendChat("/me заломил правую руку нарушителю")
            wait(1500)
            sendMe(" ведет нарушителя за собой")
            wait(1500)
            sampSendChat("/gotome " .. id[0])
        end)
    end
    if imgui.Button(u8 'Перестать вести за собой') then
        lua_thread.create(function()
            sendMe(" отпустил правую руку преступника")
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
            sendMe(" открыл заднюю дверь в машине")
            wait(1500)
            sendMe(" посадил преступника в машину")
            wait(1500)
            sendMe(" заблокировал двери")
            wait(1500)
            sampSendChat("/do Двери заблокированы.")
            wait(1500)
            sampSendChat("/incar " .. id[0] .. "3")
        end)
    end
    if imgui.Button(u8 'Обыск') then
        lua_thread.create(function()
            sendMe(" нырнув руками в карманы, вытянул оттуда белые перчатки и натянул их на руки")
            wait(1500)
            sampSendChat("/do Перчатки надеты.")
            wait(1500)
            sendMe(" проводит руками по верхней части тела")
            wait(1500)
            sendMe(" проверяет карманы")
            wait(1500)
            sendMe(" проводит руками по ногам")
            wait(1500)
            sampSendChat("/frisk " .. id[0])
        end)
    end
    if imgui.Button(u8 'Мегафон') then
        lua_thread.create(function()
            sampSendChat("/do Мегафон в бардачке.")
            wait(1500)
            sendMe(" достал мегафон с бардачка после чего включил его")
            wait(1500)
            sampSendChat("/m Водитель авто, остановитесь и заглушите двигатель, держите руки на руле.")
        end)
    end
    if imgui.Button(u8 'Вытащить из авто') then
        lua_thread.create(function()
            sendMe(" сняв дубинку с поясного держателя разбил стекло в транспорте")
            wait(1500)
            sampSendChat("/do Стекло разбито.")
            wait(1500)
            sendMe(" схватив за плечи человека ударил его после чего надел наручники")
            wait(1500)
            sampSendChat("/pull " .. id[0])
            wait(1500)
            sampSendChat("/cuff " .. id[0])
        end)
    end
    if imgui.Button(u8 'Выдача розыска') then
        windowTwo[0] = not windowTwo[0]
    end
    imgui.End()
end)
--Vzaim menu END

--RP guns START
function loadCommands()
    local file = io.open(jsonFile, "r")
    if file then
        local content = file:read("*a")
        file:close()
        local decodedJson = decodeJson(content)
        if decodedJson then
            gunCommands = decodedJson
            print("Загружено из файла:", gunCommands)
        else
          msg("Ошибка декодирования JSON. Загружаю стандартные.")
          saveCommands()
        end
    else
        msg("Не удалось загрузить JSON файл с отыгровками оружий. Загружаю стандартные")
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
        msg("Не удалось открыть файл для записи!")
    end
end

local selectedGun = nil

imgui.OnFrame(function() return gunsWindow[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(850, 500), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 'Изменение отыгровок оружия', gunsWindow)
    imgui.Text(u8 "Выберите оружие")

    for i = 1, #weapons do
        if imgui.Button(u8(weapons[i])) then
            selectedGun = i

            local command = gunCommands[i]
            otInput = imgui.new.char[255](u8(command))
            msg("Выбрано оружие: " .. weapons[i] .. " Команда: " .. command)
        end
        if selectedGun ~= nil and selectedGun ~= "" and selectedGun == i then
            imgui.SameLine()
            imgui.Text(u8("Вы выбрали " .. weapons[selectedGun]))
            imgui.InputText(u8 "Отыгровка", otInput, 255)
            if imgui.Button(u8 "Сохранить", imgui.ImVec2(100, 50)) then
                gunCommands[selectedGun] = ffi.string(otInput)
                saveCommands()
                msg("Отыгровки сохранены")
            end
        end
    end

    imgui.End()
end)
--RP guns END

--Notes START
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
function allNotes() 
    for i, note in ipairs(notes) do
        imgui.Text(note.title)
        imgui.SameLine()
        if imgui.Button(u8 "Открыть##" .. i) then
            note_name = note.title
            note_text = note.content
            NoteWindow[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 "Редактировать##" .. i) then
            selectedNote = i
            imgui.StrCopy(editNoteTitle, note.title)
            imgui.StrCopy(editNoteContent, note.content)
            imgui.OpenPopup(u8 "Редактировать заметку")
            showEditWindow[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 "Удалить##" .. i) then
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
        if imgui.Button(u8 ' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * MONET_DPI_SCALE)) then
            NoteWindow[0] = false
        end
        imgui.End()
    end
)
--Notes END

--Sobes menu START
local namesobeska     = imgui.new.char[256](u8 'Неизвестно')
local rabotaet        = false
local rabota          = imgui.new.char[256]()
local let_v_shtate    = false
local goda            = imgui.new.char[256]()
local zakonoposlushen = false
local zakonka         = imgui.new.int(0)
local narkozavisim    = false
local narkozavisimost = imgui.new.char[256]()
local cherny_spisok   = false
local voenik          = false
local lic_na_avto     = false
local chatsobes       = {}
local sobesmessage    = imgui.new.char[256]()
local select_id       = imgui.new.int(1)
local sobes           = {
    pass = u8 'Не проверено',
    mc = u8 'Не проверено',
    lic = u8 'Не проверено'
}
local pages1          = {
    { icon = faicons("GEAR"), title = u8 "Главное", index = 1 },
    { icon = faicons("BOOK"), title = u8 "Меню собес", index = 2 },
}
imgui.OnFrame(
    function() return leaderPanel[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(910 * MDS, 480 * MDS), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Панель руководства фракцией", leaderPanel)
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
            if imgui.CollapsingHeader(u8 'Лекции') then
                if imgui.Button(u8 'Арест и задержание') then
                    lua_thread.create(function()
                        sampSendChat("Здравствуйте уважаемые сотрудники нашего департамента!")
                        wait(1500)
                        sampSendChat("Сейчас будет проведена лекция на тему арест и задержание преступников.")
                        wait(1500)
                        sampSendChat("Для начала объясню различие между задержанием и арестом.")
                        wait(1500)
                        sampSendChat(
                            "Задержание - это кратковременное лишение свободы лица, подозреваемого в совершении преступления.")
                        wait(1500)
                        sampSendChat(
                            "В свою очередь, арест - это вид уголовного наказания, заключающегося в содержании совершившего преступление..")
                        wait(1500)
                        sampSendChat("..и осуждённого по приговору суда в условиях строгой изоляции от общества.")
                        wait(1500)
                        sampSendChat("Вам разрешено задерживать лица на период 48 часов с момента их задержания.")
                        wait(1500)
                        sampSendChat(
                            "Если в течение 48 часов вы не предъявите доказательства вины, вы обязаны отпустить гражданина.")
                        wait(1500)
                        sampSendChat("Обратите внимание, гражданин может подать на вас иск за незаконное задержание.")
                        wait(1500)
                        sampSendChat(
                            "Во время задержания вы обязаны провести первичный обыск на месте задержания и вторичный у капота своего автомобиля.")
                        wait(1500)
                        sampSendChat(
                            "Все найденные вещи положить в 'ZIP-lock', или в контейнер для вещ. доков, Все личные вещи преступника кладутся в мешок для личных вещей задержанного")
                        wait(1500)
                        sampSendChat("На этом данная лекция подходит к концу. У кого-то имеются вопросы?")
                    end)
                end
                if imgui.Button(u8 "Суббординация") then
                    lua_thread.create(function()
                        sampSendChat(" Уважаемые сотрудники Полицейского Департамента!")
                        wait(1500)
                        sampSendChat(" Приветствую вас на лекции о субординации")
                        wait(1500)
                        sampSendChat(" Для начала расскажу, что такое субординация")
                        wait(1500)
                        sampSendChat(
                            " Субординация - правила подчинения младших по званию к старшим по званию, уважение, отношение к ним")
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
                if imgui.Button(u8 "Правила поведения в строю.") then
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
                if imgui.Button(u8 'Допрос') then
                    lua_thread.create(function()
                        sampSendChat(
                            " Здравствуйте уважаемые сотрудники департамента сегодня, я проведу лекцию на тему Допрос подозреваемого.")
                        wait(1500)
                        sampSendChat(" Сотрудник ПД обязан сначала поприветствовать, представиться;")
                        wait(1500)
                        sampSendChat(
                            " Сотрудник ПД обязан попросить документы вызванного, спросить, где работает, звание, должность, место жительства;")
                        wait(1500)
                        sampSendChat(
                            " Сотрудник ПД обязан спросить, что он делал (назвать промежуток времени, где он что-то нарушил, по которому он был вызван);")
                        wait(1500)
                        sampSendChat(
                            " Если подозреваемый был задержан за розыск, старайтесь узнать за что он получил розыск;")
                        wait(1500)
                        sampSendChat(" В конце допроса полицейский выносит вердикт вызванному.")
                        wait(1500)
                        sampSendChat(
                            " При оглашении вердикта, необходимо предельно точно огласить вину допрашиваемого (Рассказать ему причину, за что он будет посажен);")
                        wait(1500)
                        sampSendChat(
                            " При вынесении вердикта, не стоит забывать о отягчающих и смягчающих факторах (Раскаяние, адекватное поведение, признание вины или ложь, неадекватное поведение, провокации, представление полезной информации и тому подобное).")
                        wait(1500)
                        sampSendChat(
                            " На этом лекция подошла к концу, если у кого-то есть вопросы, отвечу на любой по данной лекции (Если задали вопрос, то нужно ответить на него)")
                    end)
                end
                if imgui.Button(u8 "Правила поведения до и во время облавы на наркопритон.") then
                    lua_thread.create(function()
                        sampSendChat(
                            " Добрый день, сейчас я проведу вам лекцию на тему Правила поведения до и во время облавы на наркопритон")
                        wait(1500)
                        sampSendChat(" В строю, перед облавой, вы должны внимательно слушать то, что говорят вам Агенты")
                        wait(1500)
                        sampSendChat(" Убедительная просьба, заранее убедиться, что при себе у вас имеются балаклавы")
                        wait(1500)
                        sampSendChat(" По пути к наркопритону, подъезжая к опасному району, все обязаны их одеть")
                        wait(1500)
                        sampSendChat(
                            " Приехав на территорию притона, нужно поставить оцепление так, чтобы загородить все возможные пути к созревающим кустам Конопли")
                        wait(1500)
                        sampSendChat(
                            " Очень важным замечанием является то, что никому, кроме агентов, запрещено подходить к кустам, а тем более их собирать")
                        wait(1500)
                        sampSendChat(" Нарушение данного пункта строго наказывается, вплоть до увольнение")
                        wait(1500)
                        sampSendChat(" Так же приехав на место, мы не устраиваем пальбу по всем, кого видим")
                        wait(1500)
                        sampSendChat(
                            " Открывать огонь по постороннему разрешается только в том случае, если он нацелился на вас оружием, начал атаковать вас или собирать созревшие кусты")
                        wait(1500)
                        sampSendChat(" Как только спец. операция заканчивается, все оцепление убирается")
                        wait(1500)
                        sampSendChat(" На этом лекция окончена, всем спасибо")
                    end)
                end
                if imgui.Button(u8 "Правило миранды.") then
                    lua_thread.create(function()
                        sampSendChat("Правило Миранды — юридическое требование в США")
                        wait(1500)
                        sampSendChat(
                            "Согласно которому во время задержания задерживаемый должен быть уведомлен о своих правах.")
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
                        sampSendChat(
                            "- Если вы не можете оплатить услуги адвоката, он будет предоставлен вам государством.")
                        wait(1500)
                        sampSendChat("- Вы понимаете свои права?")
                    end)
                end
                if imgui.Button(u8 "Первая Помощь.") then
                    lua_thread.create(function()
                        sampSendChat("Для начала определимся что с пострадавшим")
                        wait(1500)
                        sampSendChat("Если, у пострадавшего кровотечение, то необходимо остановить поток крови жгутом")
                        wait(1500)
                        sampSendChat(
                            "Если ранение небольшое достаточно достать набор первой помощи и перевязать рану бинтом")
                        wait(1500)
                        sampSendChat(
                            "Если в ране пуля, и рана не глубокая, Вы должны вызвать скорую либо вытащить ее скальпелем, скальпель также находится в аптечке первой помощи")
                        wait(1500)
                        sampSendChat("Если человек без сознания вам нужно ... ")
                        wait(1500)
                        sampSendChat(
                            " ... достать из набор первой помощи вату и спирт, затем намочить вату спиртом ... ")
                        wait(1500)
                        sampSendChat(
                            " ... и провести ваткой со спиртом около носа пострадавшего, в этом случае, он должен очнуться")
                        wait(1500)
                        sampSendChat("На этом лекция окончена. У кого-то есть вопросы по данной лекции?")
                        wait(1500)
                    end)
                end
            end
            imgui.InputInt(u8 'ID игрока с которым хотите взаимодействовать', id, 10)
            if imgui.Button(u8 'Уволить сотрудника') then
                lua_thread.create(function()
                    sampSendChat("/do КПК весит на поясе.")
                    wait(1500)
                    sendMe(" снял КПК с пояса и зашел в программу управления")
                    wait(1500)
                    sendMe(" нашел в списке сотрудника и нажал на кнопку Уволить")
                    wait(1500)
                    sampSendChat("/do На КПК высветилась надпись 'Сотрудник успешно уволен!'")
                    wait(1500)
                    sendMe(" выключил КПК и повесил обратно на пояс")
                    wait(1500)
                    sampSendChat("Ну что ж, вы уволенны. Оставьте погоны в моем кабинете.")
                    wait(1500)
                    sampSendChat("/uninvite" .. id[0])
                end)
            end

            if imgui.Button(u8 'Принять гражданина') then
                lua_thread.create(function()
                    sampSendChat("/do КПК весит на поясе.")
                    wait(1500)
                    sendMe(" снял КПК с пояса и зашел в программу управления")
                    wait(1500)
                    sendMe(" зашел в таблицу и ввел данные о новом сотруднике")
                    wait(1500)
                    sampSendChat(
                        "/do На КПК высветилась надпись: 'Сотрудник успешно добавлен! Пожелайте ему хорошей службы :)'")
                    wait(1500)
                    sendMe(" выключил КПК и повесил обратно на пояс")
                    wait(1500)
                    sampSendChat("Поздровляю, вы приняты! Форму возьмете в раздевалке.")
                    wait(1500)
                    sampSendChat("/invite" .. id[0])
                end)
            end

            if imgui.Button(u8 'Выдать выговор сотруднику') then
                lua_thread.create(function()
                    sampSendChat("/do КПК весит на поясе.")
                    wait(1500)
                    sendMe(" снял КПК с пояса и зашел в программу управления")
                    wait(1500)
                    sendMe(" нашел в списке сотрудника и нажал на кнопку Выдать выговор")
                    wait(1500)
                    sampSendChat("/do На КПК высветилась надпись: 'Выговор выдан!'")
                    wait(1500)
                    sendMe(" выключил КПК и повесил обратно на пояс")
                    wait(1500)
                    sampSendChat("Ну что ж, выговор выдан. Отрабатывайте.")
                    wait(1500)
                    sampSendChat("/fwarn" .. id[0])
                end)
            end

            if imgui.Button(u8 'Снять выговор сотруднику') then
                lua_thread.create(function()
                    sampSendChat("/do КПК весит на поясе.")
                    wait(1500)
                    sendMe(" снял КПК с пояса и зашел в программу управления")
                    wait(1500)
                    sendMe(" нашел в списке сотрудника и нажал на кнопку Снять выговор")
                    wait(1500)
                    sampSendChat("/do На КПК высветилась надпись: 'Выговор снят!'")
                    wait(1500)
                    sendMe(" выключил КПК и повесил обратно на пояс")
                    wait(1500)
                    sampSendChat("Ну что ж, отработали.")
                    wait(1500)
                    sampSendChat("/unfwarn" .. id[0])
                end)
            end
        elseif menu2 == 2 then
            imgui.Text(u8("Введите id игрока:"))
            imgui.SameLine()
            imgui.PushItemWidth(200)
            imgui.InputInt("                ##select id for sobes", select_id)
            namesobeska = sampGetPlayerNickname(select_id[0])
            if namesobeska then
                imgui.Text(u8(namesobeska))
            else
                imgui.Text(u8 'Неизвестно')
            end
            imgui.Separator()
            imgui.BeginChild('sobesvoprosi', imgui.ImVec2(-1, 143 * MONET_DPI_SCALE), true)
            if imgui.Button(u8 " Начать собеседование", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                sampSendChat("Здравствуйте, вы пришли на собеседование?")
            end
            imgui.SameLine()
            if imgui.Button(u8 " Попросить документы", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                lua_thread.create(function()
                    sampSendChat("Отлично, предоставьте мне паспорт, мед. карту и лицензии.")
                    wait(1000)
                    sampSendChat(
                        "/b Чтобы показать документацию введите: /showpass - паспорт, /showmc - мед.карта, /showlic - лиценззии")
                    wait(2000)
                    sampSendChat("/b РП должно быть обязательно!")
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 " Расскажите о себе", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                lua_thread.create(function()
                    sampSendChat("Хорошо, теперь я задам пару вопросов.")
                    wait(2000)
                    sampSendChat("Расскажите о себе.")
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 " Почему именно мы?", imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
                sampSendChat("Почему вы выбрали именно наш департамент?")
            end
            imgui.Separator()
            imgui.Columns(3, nil, false)
            imgui.Text(u8 'Паспорт: ' .. sobes['pass'])
            imgui.Text(u8 'Мед.карта: ' .. sobes['mc'])
            imgui.Text(u8 'Лицензии: ' .. sobes['lic'])
            imgui.NextColumn()
            imgui.Text(u8 "Лет в штате:")
            imgui.SameLine()
            if let_v_shtate then
                imgui.Text(goda)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно")
            end
            imgui.Text(u8 "Законка:")
            imgui.SameLine()
            if zakonoposlushen then
                imgui.Text(zakonka)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно")
            end
            imgui.Text(u8 "Лиц. на авто:")
            imgui.SameLine()
            if lic_na_avto then
                imgui.Text(u8 "Есть")
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно/Нету")
            end
            imgui.Text(u8 "Военник:")
            imgui.SameLine()
            if voenik then
                imgui.Text(u8 "Есть")
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно/Нету")
            end
            imgui.NextColumn()
            imgui.Text(u8 "Зависимость:")
            imgui.SameLine()
            if narkozavisim then
                imgui.Text(narkozavisimost)
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно")
            end
            imgui.Text(u8 "Здоровье:")
            imgui.SameLine()
            imgui.Text(tostring(sampGetPlayerHealth(select_id[0])))
            imgui.Text(u8 "Черный список:")
            imgui.SameLine()
            if cherny_spisok then
                imgui.Text(u8('ЕСТЬ'))
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно/Нету")
            end
            imgui.Text(u8 "Работает:")
            imgui.SameLine()
            if rabotaet then
                imgui.Text(u8(str(rabota)))
            else
                imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8 "Неизвестно")
            end
            imgui.EndChild()
            imgui.Columns(1)
            imgui.Separator()

            imgui.Text(u8 "Локальный чат")
            imgui.BeginChild("ChatWindow", imgui.ImVec2(0, 100), true)
            for i, v in pairs(chatsobes) do
                imgui.Text(u8(v))
            end
            imgui.EndChild()

            imgui.PushItemWidth(800)
            imgui.InputText("##input", sobesmessage, 256)
            imgui.SameLine()
            if imgui.Button(u8 "Отправить") then
                sampSendChat(u8:decode(str(sobesmessage)))
            end
            imgui.PopItemWidth()

            imgui.Separator()
            if imgui.Button(u8 " Собеседование пройдено", imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                lua_thread.create(function()
                    sampSendChat("/todo Поздравляю! Вы прошли собеседование!* с улыбкой на лице")
                    wait(2000)
                    sampSendChat('/invite ' .. select_id[0])
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 "Прекратить собеседование", imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
                select_id[0] = -1
                sobes_1 = {
                    false,
                    false,
                    false
                }

                sobes = {
                    pass = u8 'Не проверено',
                    mc = u8 'Не проверено',
                    lic = u8 'Не проверено'
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
    end
)
--Sobes menu END

--Smart UK START
local smartUkPath = getWorkingDirectory() .. "/smartUk.json"
local smartUkUrl = {
    ["mobile-i"]    = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile1.json",
    ["mobile-ii"]   = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile2.json",
    ["mobile-iii"]  = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile%203.json",
    phoenix         = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Phoenix.json",
    tucson          = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Tucson.json",
    ["saint-rose"]  = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Saint-Rose.json",
    mesa            = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mesa.json",
    ["red-rock"]    = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Red-Rock.json",
    prescott        = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Prescott.json",
    winslow         = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Winslow.json",
    payson          = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Payson.json",
    gilbert         = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Gilbert.json",
    ["casa-grande"] = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Casa-Grande.json",
    page            = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Page.json",
    ["sun-city"]    = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sun-City.json",
    wednesday       = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Wednesday.json",
    yava            = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Yava.json",
    faraway         = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Faraway.json",
    ["bumble-bee"]  = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Bumble%20Bee.json",
    christmas       = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Christmas.json",
    brainburg       = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Brainburg.json",
    sedona          = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sedona.json"
}
local file = io.open(getWorkingDirectory() .. "/smartUk.json", "r") -- Открываем файл в режиме чтения
if not file then
    tableUk = { Ur = { 6 }, Text = { "Нападение на полицейского 14.4" } }
    file = io.open(getWorkingDirectory() .. "/smartUk.json", "w")
    file:write(encodeJson(tableUk))
    file:close()
else
    a = file:read("*a")
    file:close()
    tableUk = decodeJson(a)
end
imgui.OnFrame(
    function() return setUkWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 700), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Настройка умного розыска", setUkWindow)

        if imgui.Button(u8 'Скачать УК для своего сервера') then
            DownloadUk()
        end
        if imgui.Button(u8 "Скачать УК для любого сервера") then
            importUkWindow[0] = not importUkWindow[0]
        end
        if imgui.BeginChild('Name', imgui.ImVec2(0, imgui.GetWindowSize().y - 36 - imgui.GetCursorPosY() - imgui.GetStyle().FramePadding.y * 2), true) then
            for i = 1, #tableUk["Text"] do
                imgui.Text(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i]))
                Uk = #tableUk["Text"]
            end
            imgui.EndChild()
        end
        if imgui.Button(u8 'Добавить', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
            addUkWindow[0] = not addUkWindow[0]
        end
        imgui.SameLine()
        if imgui.Button(u8 'Удалить', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
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
        imgui.Begin(u8 "Настройка умного розыска", addUkWindow)
        imgui.InputText(u8 'Текст статьи(с номером.)', newUkInput, 255)
        newUkName = u8:decode(ffi.string(newUkInput))
        imgui.InputInt(u8 'Уровень розыска(только цифра)', newUkUr, 10)
        if imgui.Button(u8 'Сохранить') then
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
        imgui.Begin(u8 "Импорт умного розыска", importUkWindow)
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
                    msg(string.format("{FFFFFF} Умный розыск на %s успешно установлен!", serverName), 0x8B00FF)
                else
                    msg(string.format("{FFFFFF} К сожалению, на сервер %s не найден умный розыск. Он будет добавлен в следующих обновлениях", serverName), 0x8B00FF)
                end
                break
            end
        end
    end
)
--Smart UK END

--Patrul START
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
        return string.format("%d минут %d секунд", minutes, secs)
    else
        return string.format("%d секунд(-ы)", secs)
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
            imgui.Text(u8(' Время патрулирования: ') .. u8(getPatrolDuration()))
            imgui.Separator()
            if imgui.Button(u8('Доклад'), imgui.ImVec2(100 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                lua_thread.create(function()
                    sampSendChat('/r' .. nickname .. ' на CONTROL. Продолжаю патруль')
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8('Завершить'), imgui.ImVec2(100 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                lua_thread.create(function()
                    isPatrolActive = false
                    sampSendChat('/r' .. nickname .. ' на CONTROL. Завершаю патруль')
                    wait(1200)
                    sampSendChat('Патрулировал ' .. formatPatrolDuration(os.time() - startTime))
                    patrolDuration = 0
                    patrool_start_time = 0
                    patroolhelpmenu[0] = false
                end)
            end
        else
            if imgui.Button(u8(' Начать патруль'), imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                sampSendChat('/r' .. nickname .. ' на CONTROL. Начинаю патруль.')
                startPatrul()
            end
        end

        imgui.End()
    end
)
--Patrul END

--Window buttons START
local buttonsJson = getWorkingDirectory() .. "/MVDHelper/buttons.json"
local standartButtons = {
    ['10-55'] = {'/m Водитель, снизьте скорость и прижмитесь к обочине.', '/m Держите руки на руле и заглушите двигатель'}
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
--Window buttons END

--CEF START
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
                    sobes['pass'] = u8 "Проверено"
                    getPlayerPass(json)
                end
            end
        end
    end
end
--CEF END

--Other function START
function sendMe(text)
    if tochkaMe[0] then
        sampSendChat("/me" .. text .. ".")
    else
        sampSendChat("/me" .. text)
    end
end
function spcars(arg)
    if arg == "" then
        msg("Используйте: /spcars (5 - 120)", -1)
    else
        lua_thread.create(function()
            sampSendChat("/rb Уважаемые сотрудники, через " .. arg .. " секунд будет спавн всего транспорта организации!")
            wait(1000)
            sampSendChat("/rb Займите свой транспорт, в противном случае он пропадет!")
            wait(arg * 1000)
            spawncar_bool = true
            sampSendChat("/lmenu")
        end)
    end
end

function cmd_su(p_id)
    if p_id == "" then
        msg("Введи айди игрока: {FFFFFF}/su [ID].", 0x318CE7FF - 1)
    else
        id = imgui.new.int(tonumber(p_id))
        windowTwo[0] = not windowTwo[0]
    end
end
function getFilesInPath()
    local Files = {}
    for i = 1, 2 do
        table.insert(Files, getWorkingDirectory() .. '/arzfun/' .. i .. '.png')
    end
    return Files
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
function msg(text, color)
    if not color then
        gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    else
        gen_color = monet.buildColors(color, 1.0, true)
    end 
    local curcolor1 = '0x' .. ('%X'):format(gen_color.accent1.color_300)
    sampAddChatMessage("[MVD Helper]: {FFFFFF}" .. text, curcolor1)
end
function GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth()
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width / count - ((space * (count - 1)) / count)
end

function calculateZone(x, y, z)
    local streets = {
        { "Загородный клуб «Ависпа»", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169 },
        { "Международный аэропорт Истер-Бэй", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406 },
        { "Загородный клуб «Ависпа»", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700 },
        { "Международный аэропорт Истер-Бэй", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406 },
        { "Гарсия", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000 },
        { "Шейди-Кэбин", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000 },
        { "Восточный Лос-Сантос", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916 },
        { "Грузовое депо Лас-Вентураса", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916 },
        { "Пересечение Блэкфилд", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916 },
        { "Загородный клуб «Ависпа»", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100 },
        { "Темпл", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916 },
        { "Станция «Юнити»", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508 },
        { "Грузовое депо Лас-Вентураса", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916 },
        { "Лос-Флорес", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916 },
        { "Казино «Морская звезда»", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916 },
        { "Химзавод Истер-Бэй", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000 },
        { "Деловой район", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916 },
        { "Восточная Эспаланда", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000 },
        { "Станция «Маркет»", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874 },
        { "Станция «Линден»", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406 },
        { "Пересечение Монтгомери", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000 },
        { "Мост «Фредерик»", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000 },
        { "Станция «Йеллоу-Белл»", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074 },
        { "Деловой район", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916 },
        { "Джефферсон", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916 },
        { "Малхолланд", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916 },
        { "Загородный клуб «Ависпа»", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000 },
        { "Джефферсон", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916 },
        { "Западаная автострада Джулиус", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916 },
        { "Джефферсон", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916 },
        { "Северная автострада Джулиус", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916 },
        { "Родео", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916 },
        { "Станция «Крэнберри»", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000 },
        { "Деловой район", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916 },
        { "Западный Рэдсэндс", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916 },
        { "Маленькая Мексика", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916 },
        { "Пересечение Блэкфилд", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916 },
        { "Международный аэропорт Лос-Сантос", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916 },
        { "Бекон-Хилл", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511 },
        { "Родео", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916 },
        { "Ричман", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916 },
        { "Деловой район", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916 },
        { "Стрип", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916 },
        { "Деловой район", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916 },
        { "Пересечение Блэкфилд", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916 },
        { "Конференц Центр", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916 },
        { "Монтгомери", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000 },
        { "Долина Фостер", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000 },
        { "Часовня Блэкфилд", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916 },
        { "Международный аэропорт Лос-Сантос", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916 },
        { "Малхолланд", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916 },
        { "Поле для гольфа «Йеллоу-Белл»", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916 },
        { "Стрип", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916 },
        { "Джефферсон", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916 },
        { "Малхолланд", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916 },
        { "Альдеа-Мальвада", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000 },
        { "Лас-Колинас", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916 },
        { "Лас-Колинас", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916 },
        { "Ричман", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916 },
        { "Грузовое депо Лас-Вентураса", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916 },
        { "Северная автострада Джулиус", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916 },
        { "Уиллоуфилд", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916 },
        { "Северная автострада Джулиус", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916 },
        { "Темпл", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916 },
        { "Маленькая Мексика", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916 },
        { "Квинс", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000 },
        { "Аэропорт Лас-Вентурас", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500 },
        { "Ричман", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916 },
        { "Темпл", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916 },
        { "Восточный Лос-Сантос", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916 },
        { "Восточная автострада Джулиус", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916 },
        { "Уиллоуфилд", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916 },
        { "Лас-Колинас", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916 },
        { "Восточная автострада Джулиус", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916 },
        { "Родео", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916 },
        { "Лас-Брухас", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000 },
        { "Восточная автострада Джулиус", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916 },
        { "Родео", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916 },
        { "Вайнвуд", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916 },
        { "Родео", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916 },
        { "Северная автострада Джулиус", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916 },
        { "Деловой район", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916 },
        { "Родео", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916 },
        { "Джефферсон", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916 },
        { "Хэмптон-Барнс", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000 },
        { "Темпл", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916 },
        { "Мост «Кинкейд»", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916 },
        { "Пляж «Верона»", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916 },
        { "Коммерческий район", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916 },
        { "Малхолланд", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916 },
        { "Родео", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916 },
        { "Малхолланд", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916 },
        { "Малхолланд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916 },
        { "Южная автострада Джулиус", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916 },
        { "Айдлвуд", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916 },
        { "Океанские доки", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916 },
        { "Коммерческий район", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916 },
        { "Северная автострада Джулиус", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916 },
        { "Темпл", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916 },
        { "Глен Парк", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916 },
        { "Международный аэропорт Истер-Бэй", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000 },
        { "Мост «Мартин»", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000 },
        { "Стрип", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916 },
        { "Уиллоуфилд", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916 },
        { "Марина", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916 },
        { "Аэропорт Лас-Вентурас", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916 },
        { "Айдлвуд", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916 },
        { "Восточная Эспаланда", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000 },
        { "Деловой район", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916 },
        { "Мост «Мако»", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000 },
        { "Родео", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916 },
        { "Площадь «Першинг»", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916 },
        { "Малхолланд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916 },
        { "Мост «Гант»", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000 },
        { "Лас-Колинас", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916 },
        { "Малхолланд", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916 },
        { "Северная автострада Джулиус", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916 },
        { "Коммерческий район", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916 },
        { "Родео", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916 },
        { "Рока-Эскаланте", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916 },
        { "Родео", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916 },
        { "Маркет", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916 },
        { "Лас-Колинас", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916 },
        { "Малхолланд", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916 },
        { "Кингс", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000 },
        { "Восточный Рэдсэндс", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916 },
        { "Деловой район", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000 },
        { "Конференц Центр", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916 },
        { "Ричман", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916 },
        { "Оушен-Флэтс", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000 },
        { "Колледж Грингласс", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916 },
        { "Глен Парк", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916 },
        { "Грузовое депо Лас-Вентураса", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916 },
        { "Регьюлар-Том", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000 },
        { "Пляж «Верона»", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916 },
        { "Восточный Лос-Сантос", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916 },
        { "Дворец Калигулы", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916 },
        { "Айдлвуд", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916 },
        { "Пилигрим", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916 },
        { "Айдлвуд", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916 },
        { "Квинс", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000 },
        { "Деловой район", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000 },
        { "Коммерческий район", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916 },
        { "Восточный Лос-Сантос", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916 },
        { "Марина", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916 },
        { "Ричман", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916 },
        { "Вайнвуд", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916 },
        { "Восточный Лос-Сантос", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916 },
        { "Родео", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916 },
        { "Истерский Тоннель", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000 },
        { "Родео", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916 },
        { "Восточный Рэдсэндс", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916 },
        { "Казино «Карман клоуна»", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916 },
        { "Айдлвуд", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916 },
        { "Пересечение Монтгомери", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000 },
        { "Уиллоуфилд", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916 },
        { "Темпл", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916 },
        { "Прикл-Пайн", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916 },
        { "Международный аэропорт Лос-Сантос", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916 },
        { "Мост «Гарвер»", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916 },
        { "Мост «Гарвер»", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916 },
        { "Мост «Кинкейд»", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916 },
        { "Мост «Кинкейд»", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916 },
        { "Пляж «Верона»", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916 },
        { "Обсерватория «Зелёный утёс»", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916 },
        { "Вайнвуд", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916 },
        { "Вайнвуд", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916 },
        { "Коммерческий район", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916 },
        { "Маркет", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916 },
        { "Западный Рокшор", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916 },
        { "Северная автострада Джулиус", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916 },
        { "Восточный пляж", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916 },
        { "Мост «Фаллоу»", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000 },
        { "Уиллоуфилд", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916 },
        { "Чайнатаун", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000 },
        { "Эль-Кастильо-дель-Дьябло", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000 },
        { "Океанские доки", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916 },
        { "Химзавод Истер-Бэй", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000 },
        { "Казино «Визаж»", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916 },
        { "Оушен-Флэтс", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000 },
        { "Ричман", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916 },
        { "Нефтяной комплекс «Зеленый оазис»", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000 },
        { "Ричман", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916 },
        { "Казино «Морская звезда»", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916 },
        { "Восточный пляж", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916 },
        { "Джефферсон", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916 },
        { "Деловой район", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916 },
        { "Деловой район", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916 },
        { "Мост «Гарвер»", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385 },
        { "Южная автострада Джулиус", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916 },
        { "Восточный Лос-Сантос", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916 },
        { "Колледж «Грингласс»", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916 },
        { "Лас-Колинас", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916 },
        { "Малхолланд", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916 },
        { "Океанские доки", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916 },
        { "Восточный Лос-Сантос", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916 },
        { "Гантон", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916 },
        { "Загородный клуб «Ависпа»", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000 },
        { "Уиллоуфилд", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916 },
        { "Северная Эспланада", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000 },
        { "Казино «Хай-Роллер»", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916 },
        { "Океанские доки", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916 },
        { "Мотель «Последний цент»", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916 },
        { "Бэйсайнд-Марина", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000 },
        { "Кингс", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000 },
        { "Эль-Корона", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916 },
        { "Часовня Блэкфилд", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916 },
        { "«Розовый лебедь»", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916 },
        { "Западаная автострада Джулиус", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916 },
        { "Лос-Флорес", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916 },
        { "Казино «Визаж»", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916 },
        { "Прикл-Пайн", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916 },
        { "Пляж «Верона»", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916 },
        { "Пересечение Робада", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916 },
        { "Линден-Сайд", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916 },
        { "Океанские доки", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916 },
        { "Уиллоуфилд", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916 },
        { "Кингс", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000 },
        { "Коммерческий район", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916 },
        { "Малхолланд", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916 },
        { "Марина", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916 },
        { "Бэттери-Пойнт", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000 },
        { "Казино «4 Дракона»", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916 },
        { "Блэкфилд", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916 },
        { "Северная автострада Джулиус", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916 },
        { "Поле для гольфа «Йеллоу-Белл»", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916 },
        { "Айдлвуд", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916 },
        { "Западный Рэдсэндс", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916 },
        { "Доэрти", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000 },
        { "Ферма Хиллтоп", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000 },
        { "Лас-Барранкас", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000 },
        { "Казино «Пираты в мужских штанах»", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916 },
        { "Сити Холл", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000 },
        { "Загородный клуб «Ависпа»", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000 },
        { "Стрип", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916 },
        { "Хашбери", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000 },
        { "Международный аэропорт Лос-Сантос", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916 },
        { "Уайтвуд-Истейтс", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916 },
        { "Водохранилище Шермана", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916 },
        { "Эль-Корона", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916 },
        { "Деловой район", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000 },
        { "Долина Фостер", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000 },
        { "Лас-Паясадас", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000 },
        { "Долина Окультадо", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000 },
        { "Пересечение Блэкфилд", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916 },
        { "Гантон", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916 },
        { "Международный аэропорт Истер-Бэй", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000 },
        { "Восточный Рэдсэндс", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916 },
        { "Восточная Эспаланда", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385 },
        { "Дворец Калигулы", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916 },
        { "Казино «Рояль»", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916 },
        { "Ричман", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916 },
        { "Казино «Морская звезда»", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916 },
        { "Малхолланд", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916 },
        { "Деловой район", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000 },
        { "Ханки-Панки-Пойнт", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000 },
        { "Военный склад топлива К.А.С.С.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916 },
        { "Автострада «Гарри-Голд»", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916 },
        { "Тоннель Бэйсайд", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916 },
        { "Океанские доки", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916 },
        { "Ричман", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916 },
        { "Промсклад имени Рэндольфа", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916 },
        { "Восточный пляж", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916 },
        { "Флинт-Уотер", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916 },
        { "Блуберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000 },
        { "Станция «Линден»", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916 },
        { "Глен Парк", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916 },
        { "Деловой район", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000 },
        { "Западный Рэдсэндс", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916 },
        { "Ричман", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916 },
        { "Мост «Гант»", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000 },
        { "Бар «Probe Inn»", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000 },
        { "Пересечение Флинт", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916 },
        { "Лас-Колинас", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916 },
        { "Собелл-Рейл-Ярдс", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916 },
        { "Изумрудный остров", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916 },
        { "Эль-Кастильо-дель-Дьябло", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000 },
        { "Санта-Флора", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000 },
        { "Плайя-дель-Севиль", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916 },
        { "Маркет", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916 },
        { "Квинс", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000 },
        { "Пересечение Пилсон", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916 },
        { "Спинибед", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916 },
        { "Пилигрим", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916 },
        { "Блэкфилд", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916 },
        { "«Большое ухо»", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000 },
        { "Диллимор", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000 },
        { "Эль-Кебрадос", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000 },
        { "Северная Эспланада", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000 },
        { "Международный аэропорт Истер-Бэй", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000 },
        { "Рыбацкая лагуна", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000 },
        { "Малхолланд", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916 },
        { "Восточный пляж", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916 },
        { "Сан-Андреас Саунд", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000 },
        { "Тенистые ручьи", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000 },
        { "Маркет", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916 },
        { "Западный Рокшор", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916 },
        { "Прикл-Пайн", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916 },
        { "«Бухта Пасхи»", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000 },
        { "Лифи-Холлоу", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000 },
        { "Грузовое депо Лас-Вентураса", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916 },
        { "Прикл-Пайн", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916 },
        { "Блуберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000 },
        { "Эль-Кастильо-дель-Дьябло", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000 },
        { "Деловой район", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000 },
        { "Восточный Рокшор", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916 },
        { "Залив Сан-Фиерро", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000 },
        { "Парадизо", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000 },
        { "Казино «Носок верблюда»", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916 },
        { "Олд-Вентурас-Стрип", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916 },
        { "Джанипер-Хилл", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000 },
        { "Джанипер-Холлоу", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000 },
        { "Рока-Эскаланте", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916 },
        { "Восточная автострада Джулиус", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916 },
        { "Пляж «Верона»", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916 },
        { "Долина Фостер", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000 },
        { "Арко-дель-Оэсте", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000 },
        { "«Упавшее дерево»", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000 },
        { "Ферма", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981 },
        { "Дамба Шермана", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000 },
        { "Северная Эспланада", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000 },
        { "Финансовый район", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000 },
        { "Гарсия", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000 },
        { "Монтгомери", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000 },
        { "Крик", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916 },
        { "Международный аэропорт Лос-Сантос", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916 },
        { "Пляж «Санта-Мария»", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916 },
        { "Пересечение Малхолланд", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916 },
        { "Эйнджел-Пайн", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000 },
        { "Вёрдант-Медоус", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000 },
        { "Октан-Спрингс", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000 },
        { "Казино Кам-э-Лот", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916 },
        { "Западный Рэдсэндс", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916 },
        { "Пляж «Санта-Мария»", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916 },
        { "Обсерватория «Зелёный утёс", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916 },
        { "Аэропорт Лас-Вентурас", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916 },
        { "Округ Флинт", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000 },
        { "Обсерватория «Зелёный утёс", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916 },
        { "Паломино Крик", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000 },
        { "Океанские доки", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916 },
        { "Международный аэропорт Истер-Бэй", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000 },
        { "Уайтвуд-Истейтс", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916 },
        { "Калтон-Хайтс", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000 },
        { "«Бухта Пасхи»", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000 },
        { "Залив Лос-Сантос", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916 },
        { "Доэрти", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000 },
        { "Гора Чилиад", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083 },
        { "Форт-Карсон", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000 },
        { "Долина Фостер", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000 },
        { "Оушен-Флэтс", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000 },
        { "Ферн-Ридж", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000 },
        { "Бэйсайд", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000 },
        { "Аэропорт Лас-Вентурас", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916 },
        { "Поместье Блуберри", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000 },
        { "Пэлисейдс", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000 },
        { "Норт-Рок", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000 },
        { "Карьер «Хантер»", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761 },
        { "Международный аэропорт Лос-Сантос", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916 },
        { "Миссионер-Хилл", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000 },
        { "Залив Сан-Фиерро", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000 },
        { "Запретная Зона", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000 },
        { "Гора «Чилиад»", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083 },
        { "Гора «Чилиад»", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083 },
        { "Международный аэропорт Истер-Бэй", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000 },
        { "Паноптикум", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000 },
        { "Тенистые ручьи", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000 },
        { "Бэк-о-Бейонд", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000 },
        { "Гора «Чилиад»", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083 },
        { "Тьерра Робада", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000 },
        { "Округ Флинт", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000 },
        { "Уэтстоун", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000 },
        { "Пустынный округ", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000 },
        { "Тьерра Робада", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000 },
        { "Сан Фиерро", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000 },
        { "Лас Вентурас", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000 },
        { "Туманный округ", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000 },
        { "Лос Сантос", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000 }
    }
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Пригород'
end
--Other function END

-- API, GitHub and other URLs START
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
-- API, GitHub and other URLs END

--Events START
function sampev.onSendSpawn()
    if spawn and isMonetLoader() then
        spawn = false
        server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"
        sampSendChat('/stats')
        msg("{FFFFFF}MVDHelper успешно загружен!", 0x8B00FF)
        msg("{FFFFFF}Команда: /mvd", 0x8B00FF)
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
function sampev.onServerMessage(color, message)
    if message:find("Вы посадили игрока (%w+_%w+) в тюрьму на (.+) минут.") then
        local player, duration = message:match("Вы посадили игрока (%w+_%w+) в тюрьму на (.+) минут.")
        addLogEntry("Арест", player, nil, duration)
    end
    if message:find("(%w+_%w+) оплатил штраф в размере (.+)") then
        local player, amount = message:match("(%w+_%w+) оплатил штраф в размере (.+)")
        addLogEntry("Штраф", player, amount, nil)
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
function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
    if spawncar_bool and title:find('$') and text:find('Спавн транспорта') then -- спавн транспорта
        sampSendDialogResponse(dialogId, 2, 3, 0)
        spawncar_bool = false
        return false
    end
    
    if dialogId == 235 and title == "{BFBBBA}Основная статистика" then
        statsCheck = true
        if string.find(text, "Имя:")then
            nickname = string.match(text, "Имя: {B83434}%[(%D+)%]")
        end
        if string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция ЛВ" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция ЛС" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Полиция СФ" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "SFa" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "LSa" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "RCSD" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "Областная полиция" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "ФБР" or string.match(text, "Организация: {B83434}%[(%D+)%]") == "FBI" then
            org = string.match(text, "Организация: {B83434}%[(%D+)%]")
            if org ~= 'Не имеется' then dol = string.match(text, "Должность: {B83434}(%D+)%(%d+%)") end
            dl = u8(dol)
            if org == 'Полиция ЛВ' then
                org_g = u8 'LVPD'; ccity = u8 'Лас-Вентурас'; org_tag = 'LVPD'
            end
            if org == 'Полиция ЛС' then
                org_g = u8 'LSPD'; ccity = u8 'Лос-Сантос'; org_tag = 'LSPD'
            end
            if org == 'Полиция СФ' then
                org_g = u8 'SFPD'; ccity = u8 'Сан-Фиерро'; org_tag = 'SFPD'
            end
            if org == 'ФБР' then
                org_g = u8 'FBI'; ccity = u8 'Сан-Фиерро'; org_tag = 'FBI'
            end
            if org == 'FBI' then
                org_g = u8 'FBI'; ccity = u8 'Сан-Фиерро'; org_tag = 'FBI'
            end
            if org == 'RCSD' or org == 'Областная полиция' then
                org_g = u8 'RCSD'; ccity = u8 'Red Country'; org_tag = 'RCSD'
            end
            if org == 'LSa' or org == 'Армия Лос Сантос' then
                org_g = u8 'LSa'; ccity = u8 'Лос Сантос'; org_tag = 'LSa'
            end
            if org == 'SFa' or org == 'Армия Сан Фиерро' then
                org_g = u8 'SFa'; ccity = u8 'Сан Фиерро'; org_tag = 'SFa'
            end
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
            inicfg.save(mainIni, 'mvdhelper.ini')
        end
    end
end
--Events END

--Mimgui functions START
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
                imgui.ImVec2(p1.x + but_wide + 2, p1.y + but_high + mainIni.menuSettings.vtpos), --Вот эти десятки
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
function imgui.CenterTextColoredRGB(text)
    text = u8(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local col = imgui.Col

    local designText = function(text__)
        local pos = imgui.GetCursorPos()
        if false then
            for i = 1, 1 --[[Степень тени]] do
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
    local width = imgui.GetWindowContentRegionWidth() -- ширины контекста окно
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or
        width / count -
        ((space * (count - 1)) / count) -- вернется средние ширины по количеству
end
function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(u8(text)).x / 2)
    imgui.Text(text)
end

function imgui.CenterTextMain(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(u8(text)).x / 2 + mainIni.menuSettings.tab / 2)
    imgui.TextColoredRGB(text)
end
function imgui.ToggleButton(label, label_true, bool, a_speed)
    local p          = imgui.GetCursorScreenPos()
    local dl         = imgui.GetWindowDrawList()

    local bebrochka  = false

    local label      = label or ""                          -- Текст false
    local label_true = label_true or ""                     -- Текст true
    local h          = imgui.GetTextLineHeightWithSpacing() -- Высота кнопки
    local w          = h * 1.7                              -- Ширина кнопки
    local r          = h / 2                                -- Радиус кружка
    local s          = a_speed or 0.2                       -- Скорость анимации

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

    local bg_color = imgui.ImVec4(x_begin * 0.13, x_begin * 0.9, x_begin * 0.13, imgui.IsItemHovered(0) and 0.7 or 0.9) -- Цвет прямоугольника
    local t_color  = imgui.ImVec4(1, 1, 1, x_begin)                                                                     -- Цвет текста при false
    local t2_color = imgui.ImVec4(1, 1, 1, t_begin)                                                                     -- Цвет текста при true

    dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + w, p.y + h), imgui.GetColorU32Vec4(bg_color), r)
    dl:AddCircleFilled(imgui.ImVec2(p.x + r + x_begin * (w - r * 2), p.y + r),
        t_begin < 0.5 and x_begin * r or t_begin * r, imgui.GetColorU32Vec4(imgui.ImVec4(0.9, 0.9, 0.9, 1.0)), r + 5)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)),
        imgui.GetColorU32Vec4(t_color), label_true)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)),
        imgui.GetColorU32Vec4(t2_color), label)
    return bebrochka
end
--Mimgui functions END

-- Download files START
function downloadFile(url, path)
    local response = requests.get(url)

    if response.status_code == 200 then
        local filepath = path
        os.remove(filepath)
        local f = assert(io.open(filepath, 'wb'))
        f:write(response.text)
        f:close()
    else
        print('Ошибка скачивания...')
    end
end
function DownloadUk()
    local serverLower = string.lower(server)

    local url = smartUkUrl[serverLower]

    if url then
        downloadFile(url, smartUkPath)
        msg(string.format("{FFFFFF} Умный розыск на %s успешно установлен!", server), 0x8B00FF)
    else
        msg("{FFFFFF} К сожалению, на ваш сервер не найден умный розыск. Он будет добавлен в следующих обновлениях", 0x8B00FF)
    end
end
function downloadBinder()
    file = io.open(path, "w")
    file:close()
    file = io.open(path, "a+")
    downloadFile("https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/refs/heads/main/Binder.json",
        path)
    msg('Устанавливается файл биндера, перезагрузка')
    thisScript():reload()
end
--Download files END

--Update START
imgui.OnFrame(
    function() return updateWin[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8 "Обновление!", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
        imgui.Text(u8 'Найдена новая версия хелпера: ' .. u8(version))
        imgui.Text(u8 'В нем есть новый функционал!')
        imgui.Separator()
        imgui.CenterText(u8('Список добавленых функций в версии ') .. u8(version) .. ':')
        imgui.Text(textnewupdate)
        imgui.Separator()
        if imgui.Button(u8'Не обновляться', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            updateWin[0] = false
        end
        imgui.SameLine()
        if imgui.Button(u8'Загрузить обновление', imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            downloadFile(updateUrl, helper_path)
            updateWin[0] = false
        end
        imgui.End()
    end
)
function check_update()
    function readJsonFile(filePath)
        if not doesFileExist(filePath) then
            print("Ошибка: Файл " .. filePath .. " не существует")
            return nil
        end
        local file = io.open(filePath, "r")
        local content = file:read("*a")
        file:close()
        local jsonData = decodeJson(content)
        if not jsonData then
            print("Ошибка: Неверный формат JSON в файле " .. filePath)
            return nil
        end
        return jsonData
    end

    msg('{ffffff}Начинаю проверку на наличие обновлений...')
    local pathupdate = getWorkingDirectory() .. "/config/infoupdate.json"
    os.remove(pathupdate)
    local url = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/infoupdate.json"
    downloadFile(url, pathupdate)
    local updateInfo = readJsonFile(pathupdate)
    if updateInfo then
        local uVer = updateInfo.current_version
        local uText = updateInfo.update_info
        if thisScript().version ~= uVer then
            msg('{ffffff}Доступно обновление!')
            updateUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper.lua"
            version = uVer
            textnewupdate = uText
            updateWin[0] = true
        else
            msg('{ffffff}Обновление не нужно, у вас актуальная версия!')
        end
    end
end
--Update END

--Logs START
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
        file:write(encodeJson(logs))
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
imgui.OnFrame(function() return logsWin[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(700, 200), imgui.Cond.FirstUseEver)
    imgui.Begin(u8 "Логи", logsWin)
    for _, log in ipairs(logs) do
        if log.type == "Штраф" then
            imgui.Text(u8(string.format(
                "Время: %s | Тип: %s | Игрок: %s | Сумма: %s",
                log.time, log.type, log.player, log.amount
            )))
        else
            imgui.Text(u8(string.format(
                "Время: %s | Тип: %s | Игрок: %s",
                log.time, log.type, log.player)))
        end
    end
    imgui.End()
end)
--Logs END

--Other windows START
imgui.OnFrame(
    function() return windowTwo[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Выдача розыска", windowTwo)
        imgui.InputInt(u8 'ID игрока с которым будете взаимодействовать', id, 10)

        for i = 1, #tableUk["Text"] do
            if imgui.Button(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i])) then
                lua_thread.create(function()
                    sampSendChat("/do Рация висит на бронежелете.")
                    wait(1500)
                    sendMe(" сорвав с грудного держателя рацию, сообщил данные о сапекте")
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
local mainMenuFrame = imgui.OnFrame(function() return window[0] end, 
    function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(mainIni.menuSettings.x * MDS, mainIni.menuSettings.y), imgui.Cond.FirstUseEver)
    imgui.Begin('##Window', window, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize)
    MainWindowPos = imgui.GetWindowPos()
    MainWindowSize = imgui.GetWindowSize()
    if menuSizes[0] then
        imgui.SetWindowSizeVec2(imgui.ImVec2(mainIni.menuSettings.x * MDS, mainIni.menuSettings.y))
    end
    imgui.BeginChild('tabs', imgui.ImVec2(mainIni.menuSettings.tab, -1), true)
    p = imgui.GetCursorScreenPos()
    imgui.DrawFrames(MyGif, imgui.ImVec2(mainIni.menuSettings.tab - 60, 120), FrameTime[0])
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

    if page == 1 then
        if changingInfo then
            imgui.Text(u8 'Ваш ник: ' .. nickname)
            imgui.Text(u8 'Ваша организация: ')
            imgui.SameLine()
            imgui.InputText("##орга", orga, 255)
            imgui.Text(u8 'Ваша должность: ')
            imgui.SameLine()
            imgui.InputText("##должность", dolzh, 255)

            if imgui.Button(u8 "Сохранить данные") then
                mainIni.Info.org = u8(u8:decode(ffi.string(orga)))
                mainIni.Info.dl = u8(u8:decode(ffi.string(dolzh)))
                inicfg.save(mainIni, "mvdhelper.ini")
                msg("Настроки успешно сохранены!")
                changingInfo = false
            end
        else
            imgui.Text(u8 'Ваш ник: ' .. nickname)
            imgui.Text(u8 'Ваша организация: ' .. mainIni.Info.org)
            imgui.Text(u8 'Ваша должность: ' .. mainIni.Info.dl)
            if imgui.Button(u8 "Изменить данные") then
                changingInfo = true
            end
        end
        if imgui.Button(u8 ' Настроить Умный Розыск') then
            setUkWindow[0] = not setUkWindow[0]
        end
        imgui.ToggleButton(u8 'Авто отыгровка оружия', u8 'Авто отыгровка оружия', autogun)
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
        imgui.ToggleButton(u8 'Авто-Акцент', u8 'Авто-Акцент', AutoAccentBool)
        if AutoAccentBool[0] then
            AutoAccentCheck = true
            mainIni.settings.autoAccent = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.autoAccent = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        if imgui.ToggleButton(u8 'Отображение кнопки 10-55', u8 'Отображение кнопки 10-55', button_megafon) then
            mainIni.settings.button = button_megafon[0]
            megafon[0] = button_megafon[0]
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.InputText(u8 'Акцент', AutoAccentInput, 255)
        AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
        mainIni.Accent.accent = AutoAccentText
        inicfg.save(mainIni, "mvdhelper.ini")

        imgui.ToggleButton(u8(mainIni.settings.ObuchalName) .. u8 ' работает',
            u8(mainIni.settings.ObuchalName) .. u8 ' отдыхает', joneV)
        if joneV[0] then
            mainIni.settings.Jone = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.Jone = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        if imgui.InputText(u8 "Имя обучальщика", ObuchalName, 255) then
            Obuchal = u8:decode(ffi.string(ObuchalName))
            mainIni.settings.ObuchalName = Obuchal
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        
        if imgui.Button(u8 "Настройки окна") then
            menuSizes[0] = not menuSizes[0]
        end
        if imgui.Button(u8 "Настройки отыгровок оружий") then
            gunsWindow[0] = not gunsWindow[0]
        end
    elseif page == 8 then
        if imgui.Button(u8 'Меню патрулирования') then
            patroolhelpmenu[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Панель рук-ва фракции') then
            leaderPanel[0] = true
        end


        if imgui.Button(u8 'Лог штрафов, аррестов') then
            logsWin[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Счетчик онлайна') then
            settingsonline[0] = true
        end
        imgui.SameLine()
        if imgui.Button(u8 'Вспомогательное окно') then
            suppWindow[0] = not suppWindow[0]
        end
        if imgui.Button(u8 'Выдача розыска') then
            windowTwo[0] = not windowTwo[0]
        end
        imgui.ToggleButton(u8 "Точка на конце /me НЕ стоит", u8 "Точка на конце /me стоит", tochkaMe)
    
    elseif page == 2 then -- Биндер
        if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 303 * MONET_DPI_SCALE), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8"Команда")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Описание")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Действие")
            imgui.SetColumnWidth(-1, 150 * MONET_DPI_SCALE)
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/binder")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Открыть главное меню биндера")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Недоступно")
            imgui.Columns(1)
            imgui.Separator()
            imgui.Columns(3)
            imgui.CenterColumnText(u8 "/stop")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Остановить любую отыгровку из биндера")
            imgui.NextColumn()
            imgui.CenterColumnText(u8 "Недоступно")
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
                            imgui.SetTooltip(u8 "Отключение команды /" .. command.cmd)
                        end
                    else
                        if imgui.SmallButton(fa.TOGGLE_OFF .. '##' .. command.cmd) then
                            command.enable = not command.enable
                            save_settings()
                            register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
                        end
                        if imgui.IsItemHovered() then
                            imgui.SetTooltip(u8 "Включение команды /" .. command.cmd)
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
                        imgui.SetTooltip(u8 "Изменение команды /" .. command.cmd)
                    end
                    imgui.SameLine()
                    if imgui.SmallButton(fa.TRASH_CAN .. '##' .. command.cmd) then
                        imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. command.cmd)
                    end
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(u8 "Удаление команды /" .. command.cmd)
                    end
                    if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. command.cmd, _, imgui.WindowFlags.NoResize) then
                        imgui.CenterText(u8 'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
                        imgui.Separator()
                        if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Нет, отменить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(fa.TRASH_CAN .. u8 ' Да, удалить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
        if imgui.Button(fa.CIRCLE_PLUS .. u8 ' Создать новую команду##new_cmd', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            local new_cmd = {
                cmd = '',
                description = 'Новая команда созданная вами',
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
            imgui.CenterColumnText(u8"Название кнопки")
            imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Текст")
            imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
            imgui.NextColumn()
            imgui.CenterColumnText(u8"Действие")
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
                    imgui.OpenPopup(fa.CIRCLE_PLUS .. u8 ' Изменение кнопки на экране')            
                end
                if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8 ' Изменение кнопки на экране', _, imgui.WindowFlags.NoResize) then
                    imgui.InputText(u8"Название кнопки", newButtonText, 255)
                    imgui.InputTextMultiline(u8"Текст", newButtonCommand, 2555)
                    if imgui.Button(u8"Сохранить", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                        deleteButton(name)
                        addNewButton(u8:decode(ffi.string(newButtonText)), u8:decode(ffi.string(newButtonCommand)))
                        imgui.CloseCurrentPopup()
                    end
                end
                imgui.SameLine()
                if imgui.SmallButton(fa.TRASH_CAN .. '##' .. name) then
                    imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. name)
                end
                if imgui.IsItemHovered() then
                    imgui.SetTooltip(u8 "Удаление кнопки " .. name)
                end
                imgui.Columns(1)
                imgui.Separator()
                if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8 ' Предупреждение ##' .. name, _, imgui.WindowFlags.NoResize) then
                    imgui.CenterText(u8 'Вы действительно хотите удалить кнопку ' .. u8(name) .. '?')
                    imgui.Separator()
                    if imgui.Button(fa.CIRCLE_XMARK .. u8 ' Нет, отменить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(fa.TRASH_CAN .. u8 ' Да, удалить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
                        deleteButton(name)
                    end
                    imgui.End()
                end
            end
            imgui.EndChild()
        end
            if imgui.Button(fa.CIRCLE_PLUS .. u8" Новая кнопка") then
                imgui.OpenPopup(fa.CIRCLE_PLUS .. u8 ' Создание новой кнопки на экране')            
            end
            

    elseif page == 3 then -- Рация депортамента
        imgui.BeginChild('##depbuttons',
            imgui.ImVec2((imgui.GetWindowWidth() * 0.35) - imgui.GetStyle().FramePadding.x * 2, 0), true,
            imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)
        imgui.TextColoredRGB(u8 'Тэг вашей организации', 1)
        if imgui.InputText('##myorgnamedep', orgname, 255) then
            departsettings.myorgname = u8:decode(str(orgname))
        end
        imgui.TextColoredRGB(u8 'Тэг с кем связываетесь')
        imgui.InputText('##toorgnamedep', otherorg, 255)
        imgui.Separator()
        if imgui.Button(u8 'Рация упала.') then
            if #str(departsettings.myorgname) > 0 then
                sampSendChat('/d [' .. (str(departsettings.myorgname)) .. '] - [Всем]: Рация упала.')
            else
                msg('У Вас что-то не указано.')
            end
        end
        imgui.Separator()
        imgui.TextColoredRGB(u8 'Частота (не Обязательно)')
        imgui.PushItemWidth(200)
        imgui.InputText('##frequencydep', departsettings.frequency, 255)
        imgui.PopItemWidth()

        imgui.EndChild()

        imgui.SameLine()

        imgui.BeginChild('##deptext', imgui.ImVec2(-1, -1), true, imgui.WindowFlags.NoScrollbar)
        imgui.TextColoredRGB(u8 'История сообщений департамента {808080}(?)')
        imgui.Hint('mytagfind depart',
            u8 'Если в чате департамента будет тэг \'' ..
            (str(departsettings.myorgname)) .. u8 '\'\nв этот список добавится это сообщение')
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
        if imgui.Button(u8 'Отправить', imgui.ImVec2(0, 30 * MDS)) then
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
                msg('У вас что-то не указано!')
            end
        end
        imgui.EndChild()
    elseif page == 5 then -- Заметки
        allNotes()
        imgui.Separator()
        if imgui.Button(u8 "Добавить новую заметку", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
            imgui.StrCopy(newNoteTitle, "")
            imgui.StrCopy(newNoteContent, "")
            imgui.OpenPopup(u8 "Добавить новую заметку")
            showAddNotePopup[0] = true
        end
        if imgui.BeginPopupModal(u8 "Редактировать заметку", showEditWindow, imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8 'Название заметки')
            imgui.InputText(u8 "##nazvanie", editNoteTitle, 256)
            imgui.Text(u8 "Текст заметки")
            imgui.InputTextMultiline(u8 "##2663737374", editNoteContent, 1024,
                imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
            if imgui.Button(u8 "Сохранить", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                notes[selectedNote].title = ffi.string(editNoteTitle)
                notes[selectedNote].content = ffi.string(editNoteContent)
                showEditWindow[0] = false
                imgui.CloseCurrentPopup()
                selectedNote = nil
                saveNotesToFile()
            end
            imgui.SameLine()
            if imgui.Button(u8 "Отменить", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                showEditWindow[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.EndPopup()
        end
        if imgui.BeginPopupModal(u8 "Добавить новую заметку", showAddNotePopup, imgui.WindowFlags.AlwaysAutoResize) then
            imgui.Text(u8 'Название новой заметки')
            imgui.InputText(u8 "##nazvanie2", newNoteTitle, 256)
            imgui.Text(u8 'Текст новой заметки')
            imgui.InputTextMultiline(u8 "##123123123", newNoteContent, 1024, imgui.ImVec2(-1, 100))
            if imgui.Button(u8 "Сохранить", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                table.insert(notes, { title = ffi.string(newNoteTitle), content = ffi.string(newNoteContent) })
                imgui.StrCopy(newNoteTitle, "")
                imgui.StrCopy(newNoteContent, "")
                saveNotesToFile()
                showAddNotePopup[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.SameLine()
            if imgui.Button(u8 "Закрыть", imgui.ImVec2(imgui.GetMiddleButtonX(2), 36)) then
                imgui.CloseCurrentPopup()
            end
            if imgui.Button(u8 "Удалить", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                imgui.StrCopy(newNoteTitle, "")
                imgui.StrCopy(newNoteContent, "")
                showAddNotePopup[0] = false
                imgui.CloseCurrentPopup()
            end
            imgui.EndPopup()
        end
    elseif page == 6 then -- Информация
        imgui.Text(u8 'Версия: ' .. thisScript().version)
        imgui.Text(u8 'Разработчики: https://t.me/Sashe4ka_ReZoN, https://t.me/daniel2903_pon, https://t.me/makson4ck2')
        imgui.Text(u8 'ТГ канал: t.me/lua_arz')
        imgui.Text(u8 'Поддержать: Временно не доступно')
        imgui.Text(u8 'Спонсоры: @Negt,@King_Rostislavia,@sidrusha,@Timur77998, @osp_x, @Theopka')
    end
    imgui.EndChild()
    imgui.End()
end)
imgui.OnFrame(
    function() return suppWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 "Вспомогательное окошко", suppWindow,
            imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)

        imgui.Text(u8 'Время: ' .. os.date('%H:%M:%S'))
        imgui.Text(u8 'Месяц: ' .. os.date('%B'))
        imgui.Text(u8 'Полная дата: ' .. arr.day .. '.' .. arr.month .. '.' .. arr.year)
        local positionX, positionY, positionZ = getCharCoordinates(PLAYER_PED)
        imgui.Text(u8 'Район:' .. u8(calculateZone(positionX, positionY, positionZ)))
        local p_city = getCityPlayerIsIn(PLAYER_PED)
        if p_city == 1 then pCity = u8 'Лос - Сантос' end
        if p_city == 2 then pCity = u8 'Сан - Фиерро' end
        if p_city == 3 then pCity = u8 'Лас - Вентурас' end
        if getActiveInterior() ~= 0 then pCity = u8 'Вы находитесь в интерьере!' end
        imgui.Text(u8 'Город: ' .. (pCity or u8 'Неизвестно'))
        imgui.End()
    end
)
imgui.OnFrame(
    function() return joneV[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 350, 500
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY - 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        imgui.Begin('Jone', joneV, imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize)
        imgui.ImageURL(
            "https://sun9-73.userapi.com/impf/c622023/v622023770/33fd/T9qIlEYed6o.jpg?size=320x427&quality=96&sign=bfc6230a550a94c075a5b0747a7c6bca&c_uniq_tag=Kl4qcaTNH2y8ypcpjcIMF7CDzDRlSY1rwm8e1dQD504&type=album",
            imgui.ImVec2(200, 200), true)
        if window[0] then
            imgui.SetWindowFocus()

            if page == 8 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Это - страничка быстрого взаимодействия.")
                imgui.Text(u8 "Так же это окошко открывается при двойном нажатии на игрока(работает коряво)")
                if imgui.Button(u8 'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 2
                end
            elseif page == 2 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "А это - одна из самых выжных вкладок!\nЭто биндер, в котором ты можешь\nсоздавать свои команды\nа так же изменять готовые!")
                if imgui.Button(u8 'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 3
                end
            elseif page == 3 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Это - вкладка гос. волны\nТут ты можешь связываться с организациями\nФункций пока что мало, они будут добавляться!")
                if imgui.Button(u8 'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 5
                end
            elseif page == 5 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Это - вкладка с заметками. Здесь ты можешь написать все что угодно и посмотреть это в любой момент")
                if imgui.Button(u8 'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 6
                end
            elseif page == 6 then
                imgui.SetWindowFocus()
                imgui.Text(u8 "Тут находится инф-я о МВД хелпере")
                if imgui.Button(u8 'Далее >>') then
                    page = 1
                end
            elseif page == 1 then -- если значение tab == 1
                imgui.SetWindowFocus()
                imgui.Text(u8 "Это - вкладка в которой ты можешь меня выключить. На этой странице есть настройка УК.\nТам ты можешь скачать для себя УК или настроить его!\nЕще тут есть выбор темы MVD Helper. \nТы можешь выбрать MoonMonet и настроить свой цвет!")
                if imgui.Button(u8 'Выключить меня', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    joneV[0] = false
                    mainIni.settings.Jone = false
                    inicfg.save(mainIni, "mvdhelper.ini")
                end
            
            end
        else
            imgui.Text(u8 "Привет! Я " ..
                u8(mainIni.settings.ObuchalName) .. u8 ".\nЯ помогу тебе научится работать с\nхелпером.")
            if imgui.Button(u8 'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                window[0] = true
            end
            imgui.End()
        end
    end
)
imgui.OnFrame(
    function() return megafon[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 2.1), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Мегафон дааа", megafon,
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar +
            imgui.WindowFlags.NoBackground)
        imgui.SameLine()
        if imgui.Button(fa.BULLHORN, imgui.ImVec2(75 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            sampSendChat('/m Водитель, снизьте скорость и прижмитесь к обочине.')
            sampSendChat('/m После остановки заглушите двигатель, держите руки на руле и не выходите из транспорта.')
            sampSendChat('/m В случае неподчинения по вам будет открыт огонь!')
        end
        imgui.End()
    end
)
--Other windows END

--MAIN
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    while not sampIsLocalPlayerSpawned() do wait(100) end
    if not doesDirectoryExist(getWorkingDirectory() .. '/MVDHelper') then
        createDirectory(getWorkingDirectory() .. '/MVDHelper')
    end
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
                '[Binder] {ffffff}Ошибка, сейчас нету активной отыгровки!', message_color)
        end 
    end)
    registerCommandsFrom(settings.commands)
    msg("Скрипт успешно загружен! Telegram-канал: @lua_arz. При поддержке arzfun.com")
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