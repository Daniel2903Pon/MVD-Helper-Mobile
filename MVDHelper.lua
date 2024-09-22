require 'moonloader'
local imgui = require('mimgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local AI_PAGE = {}

local ToU32 = imgui.ColorConvertFloat4ToU32

local page = 1

local window = imgui.new.bool()

script_name("MVD Helper Mobile")

script_version("5.0.2")
script_author("@Sashe4ka_ReZoN @daniel29032012 @Theopka")

MDS = MONET_DPI_SCALE or 1

local http = require("socket.http")
local ltn12 = require("ltn12")
local imgui = require 'mimgui'
local ffi = require 'ffi'
local inicfg = require("inicfg")
local faicons = require('fAwesome6')
local sampev = require('lib.samp.events')
local mainIni = inicfg.load({
    Accent = {
        accent = '[Молдавский акцент]: '
    },
    Info = {
        org = u8'Вы не состоите в ПД',
        dl = u8'Вы не состоите в ПД',
        rang_n = 0
    },
    theme = {
        themeta = "standart",
        selected = 0,
        moonmonet = 759410733
    },
    settings = {
        autoRpGun = true,
        poziv = false,
        autoAccent = false,
        standartBinds = true,
        Jone = true,
        ObuchalName = "Мастурбек"
    }
}, "mvdhelper.ini")
local mmloaded, monet = pcall(require, "MoonMonet")
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
function msg(text)
	gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    local a, r, g, b = explode_argb(gen_color.accent1.color_300)
	curcolor = '{'..rgb2hex(r, g, b)..'}'
    curcolor1 = '0x'..('%X'):format(gen_color.accent1.color_300)
	sampAddChatMessage("[MVD Helper]: {FFFFFF}" .. text, curcolor1)
end

local joneV = imgui.new.bool(mainIni.settings.Jone)
if not mmloaded then
    print("MoonMonet doesn`t found. Script will work without it.")
end

function isMonetLoader() return MONET_VERSION ~= nil end

local servers = {
	["80.66.82.162"] = { number = -1, name = "Mobile I"},
	["80.66.82.148"] = { number = -2, name = "Mobile II"},
	["80.66.82.136"] = { number = -3, name = "Mobile III"},

    ["185.169.134.44"] = {number = 4, name = "Chandler"},
    ["185.169.134.43"] = {number = 3, name = "Scottdale"},
    ["185.169.134.45"] = {number = 5, name = "Brainburg"},
    ["185.169.134.5"] = {number = 6, name = "Saint-Rose"},
    ["185.169.132.107"] = {number = 6, name = "Saint-Rose"},
    ["185.169.134.59"] = {number = 7, name = "Mesa"},
    ["185.169.134.61"] = {number = 8, name = "Red-Rock"},
    ["185.169.134.107"] = {number = 9, name = "Yuma"},
    ["185.169.134.109"] = {number = 10, name = "Surprise"},
    ["185.169.134.166"] = {number = 11, name = "Prescott"},
    ["185.169.134.171"] = {number = 12, name = "Glendale"},
    ["185.169.134.172"] = {number = 13, name = "Kingman"},
    ["185.169.134.173"] = {number = 14, name = "Winslow"},
    ["185.169.134.174"] = {number = 15, name = "Payson"},
    ["80.66.82.191"] = {number = 16, name = "Gilbert"},
    ["80.66.82.190"] = {number = 17, name = "Show Low"},
    ["80.66.82.188"] = {number = 18, name = "Casa-Grande"},
    ["80.66.82.168"] = {number = 19, name = "Page"},
    ["80.66.82.159"] = {number = 20, name = "Sun-City"},
    ["80.66.82.200"] = {number = 21, name = "Queen-Creek"},
    ["80.66.82.144"] = {number = 22, name = "Sedona"},
    ["80.66.82.132"] = {number = 23, name = "Holiday"},
    ["80.66.82.128"] = {number = 24, name = "Wednesday"},
    ["80.66.82.113"] = {number = 25, name = "Yava"},
    ["80.66.82.82"] = {number = 26, name = "Faraway"},
    ["80.66.82.87"] = {number = 27, name = "Bumble Bee"},
    ["80.66.82.54"] = {number = 28, name = "Christmas"},
    ["80.66.82.39"] = {number = 29, name = "Mirage"},
    ["185.169.134.3"] = {number = 1, name = "Phoenix"},
    ["185.169.132.105"] = {number = 1, name = "Phoenix"},
    ["185.169.134.4"] = {number = 2, name = "Tucson"},
    ["185.169.132.106"] = {number = 2, name = "Tucson"},
}

server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new

-- Ссылки
local mvdPath = script.this.filename
local smartUkPath = "smartUk.json"
local mvdUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper.lua"
-- Смарт Ук
local smartUkUrl = {
    m1 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile1.json",
    m2 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile2.json",
    m3 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile%203.json",
    phenix = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Phoenix.json",
    tucson = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Tucson.json",
    saint = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Saint-Rose.json",
    mesa = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mesa.json",
    red = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Red-Rock.json",
    press = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Prescott.json",
    winslow = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Winslow.json",
    payson = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Payson.json",
    gilbert = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Gilbert.json",
    casa = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Casa-Grande.json",
    page = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Page.json",
    sunCity = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sun-Сity.json",
    wednesday = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Wednesday.json",
    yava = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Yava.json",
    faraway = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Faraway.json",
    bumble = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Bumble%20Bee.json",
    christmas = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Crihstmas.json"
}


local renderWindow = new.bool()
local sizeX, sizeY = getScreenResolution()
local id = imgui.new.int(0)
local otherorg = imgui.new.char(255)
local searchInput = imgui.new.char(255)
local zk = new.bool()
local tab = 1
local patrul = new.bool()
local partner = imgui.new.char(255)
local inputComName = imgui.new.char(255)
local inputComText = imgui.new.char(255)
local chatrp = new.bool()
local arr = os.date("*t")
local poziv = imgui.new.char(255)
local pozivn = imgui.new.bool()
local suppWindow = imgui.new.bool()
local windowTwo = imgui.new.bool()
local setUkWindow = imgui.new.bool()
local addUkWindow = imgui.new.bool()
local importUkWindow = imgui.new.bool()
local binderWindow = imgui.new.bool()
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
local leaderPanel = imgui.new.bool()
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

    msg("{FFFFFF} Проверка наличия обновлений...", 0x8B00FF)
    local currentVersionFile = io.open(mvdPath, "r")
    local currentVersion = currentVersionFile:read("*a")
    currentVersionFile:close()
    local response = http.request(mvdUrl)
    if response and response ~= currentVersion then
    	msg("{FFFFFF} У вас не актуальная версия! Для обновления перейдите во вкладку Инфо", 0x8B00FF)
    else
    	msg("{FFFFFF} У вас актуальная версия скрипта.", 0x8B00FF)
    end
    
local function updateScript(scriptUrl, scriptPath)
    msg("{FFFFFF} Проверка наличия обновлений...", 0x8B00FF)
	local response = http.request(scriptUrl)
    if response and response ~= currentVersion then
        msg("{FFFFFF} Доступна новая версия скрипта! Обновление...", 0x8B00FF)
        
        local success = downloadFile(scriptUrl, scriptPath)
        if success then
            msg("{FFFFFF} Скрипт успешно обновлен.", 0x8B00FF)
            thisScript():reload()
        else
            msg("{FFFFFF} Не удалось обновить скрипт.", 0x8B00FF)
        end
    else
        msg("{FFFFFF} Скрипт уже является последней версией.", 0x8B00FF)
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
if checkValue("confing/Binder.json") ~= nil then
    downloadFile("https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/refs/heads/main/Binder.json", "confing/Binder.json")
end

local autogun = new.bool(mainIni.settings.autoRpGun)
-- Умный розыск
local file = io.open("smartUk.json", "r") -- Открываем файл в режиме чтения
if not file then
    tableUk = {Ur = {6}, Text = {"Нападение на полицейского 14.4"}}

    file = io.open("smartUk.json", "w")
    file:write(encodeJson(tableUk)) -- Записываем в файл
    file:close()
else
    a = file:read("*a") -- Читаем файл, там у нас таблица
    file:close() -- Закрываем
    tableUk = decodeJson(a) -- Читаем нашу JSON-Таблицу
end

local selected_theme = imgui.new.int(mainIni.theme.selected)
local theme_a = {u8'Стандартная', 'MoonMonet'}
local theme_t = {u8'standart', 'moonmonet'}
local items = imgui.new['const char*'][#theme_a](theme_a)

local standartBindsBox = new.bool(mainIni.settings.standartBinds)
local statsCheck = false
local AutoAccentBool = new.bool(mainIni.settings.autoAccent)
local AutoAccentInput = new.char[255](u8(mainIni.Accent.accent))
local org = u8'Вы не состоите в ПД'
local org_g = u8'Вы не состоите в ПД'
local ccity = u8'Вы не состоите в ПД'
local org_tag = u8'Вы не состоите в ПД'
local dol = 'Вы не состоите в ПД'
local dl = u8'Вы не состоите в ПД'
local rang_n = 0

local nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))


--Биндер успешно спизженый у Богдана(он разрешил)
require "lib.moonloader"
require 'encoding'.default = 'CP1251'
local u8 = require 'encoding'.UTF8

local settings = {}
local default_settings = {
	commands = {
		{},
	},
}
local configDirectory = getWorkingDirectory() .. "/config"
local path = configDirectory .. "/Binder.json"

function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(path) then
        settings = default_settings
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

local ffi = require 'ffi'

local message_color = 0x00CCFF
local message_color_hex = '{00CCFF}'

local fa = require('fAwesome6_solid')
local imgui = require('mimgui')
local sizeX, sizeY = getScreenResolution()
local new = imgui.new
local MainWindow = new.bool()
local BinderWindow = new.bool()
local ComboTags = new.int()
local item_list = {u8'Без аргумента', u8'{arg} - принимает что угодно, буквы/цифры/символы', u8'{arg_id} - принимает только ID игрока', u8'{arg_id} {arg2} - принимает 2 аругмента: ID игрока и второе что угодно'}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local change_cmd_bool = false
local change_cmd = ''
local change_description = ''
local change_text = ''
local change_arg = ''
local slider = new.float(0)

local isActiveCommand = false

local tagReplacements = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
	my_ru_nick = function() return TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) end,
	get_time = function ()
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
					msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [аргумент]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id}' then
				if isParamSampID(arg) then
					arg = tonumber(arg)
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
					arg_check = true
				else
					msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока]', message_color)
					play_error_sound()
				end
			elseif cmd_arg == '{arg_id} {arg2}' then
				if arg and arg ~= '' then
					local arg_id, arg2 = arg:match('(%d+) (.+)')
					if isParamSampID(arg_id) and arg2 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						arg_check = true
					else
						msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
						play_error_sound()
					end
				else
					msg('[Binder] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
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
							msg('[Binder] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 
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

imgui.OnInitialize(function()
    decor() -- применяем декор часть
    apply_n_t()

    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 20, config, iconRanges) -- solid - тип иконок, так же есть thin, regular, light и duotone
	local tmp = imgui.ColorConvertU32ToFloat4(mainIni.theme['moonmonet'])
	gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
	mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
    if doesFileExist('Jone.png') then -- находим необходимую картинку с названием example.png в папке moonloader/resource/
        imhandle = imgui.CreateTextureFromFile('Jone.png') -- если найдена, то записываем в переменную хендл картинки
    end
end)

local MainWindow = imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
	
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425	* MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.TERMINAL..u8" Binder by MTG MODS - Главное меню", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
	
		if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 333 * MONET_DPI_SCALE), true) then
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
			imgui.CenterColumnText(u8"/binder")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Открыть главное меню биндера")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Недоступно")
			imgui.Columns(1)	
			imgui.Separator()
			imgui.Columns(3)
			imgui.CenterColumnText(u8"/stop [Недоступен]")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Остановить любую отыгровку из биндера [Недоступен]")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Недоступно")
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
						if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
							command.enable = not command.enable
							save_settings()
							sampUnregisterChatCommand(command.cmd)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8"Отключение команды /"..command.cmd)
						end
					else
						if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
							command.enable = not command.enable
							save_settings()
							register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8"Включение команды /"..command.cmd)
						end
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
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
						imgui.SetTooltip(u8"Изменение команды /"..command.cmd)
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"Удаление команды /"..command.cmd)
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
						imgui.CenterText(u8'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
		if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую команду##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true , waiting = '1.200', deleted = false }
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
		if imgui.Button(fa.HEADSET .. u8' Discord сервер MTG MODS (Связь с автором и тех.поддержка)',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			openLink('https://discord.com/invite/qBPEYjfNhv')
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425	* MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.TERMINAL..u8" Binder by MTG MODS - Редактирование команды /" .. change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * MONET_DPI_SCALE, 361 * MONET_DPI_SCALE), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' Описание команды:')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' Команда для использования в чате (без /):')
			imgui.PushItemWidth(579 * MONET_DPI_SCALE)
			imgui.InputText("##input_cmd", input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' Аргументы которые принимает команда:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' Текстовый бинд команды:')
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * MONET_DPI_SCALE, 173 * MONET_DPI_SCALE))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' Задержка',imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' Задержка (в секундах) ')
		end
		if imgui.BeginPopupModal(fa.CLOCK .. u8' Задержка (в секундах) ', _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(200 * MONET_DPI_SCALE)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 5)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(change_waiting))	
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' Тэги ', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' Основные тэги для использования в биндере')
		end
		if imgui.BeginPopupModal(fa.TAGS .. u8' Основные тэги для использования в биндере', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(4), 0)) then	
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды!')
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
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg_id}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg_id} {arg2}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!', message_color)
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
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg_id}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!', message_color)
							elseif command.arg == '{arg_id} {arg2}' then
								msg('[Binder] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!', message_color)
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
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды!', _, imgui.WindowFlags.AlwaysAutoResize ) then
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8" В команде можно использовать только англ. буквы и/или цифры!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8" Команда не может быть пустая!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8" Описание команды не может быть пустое!")
			end
			if ffi.string(input_text) == '' then
				imgui.BulletText(u8" Бинд команды не может быть пустой!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(300 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end	
		imgui.End()
    end
)


function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end
function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterColumnInputText(text,v,size)

	if text:find('^(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - (imgui.CalcTextSize(text1).x / 2) - (imgui.CalcTextSize(v).x / 2 ))
	elseif text:find('^##(.+)') then
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2) ) - (imgui.CalcTextSize(v).x / 2 ) )
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - (imgui.CalcTextSize(text).x / 2) - (imgui.CalcTextSize(v).x / 2 ))
	end   
	
	if imgui.InputText(text,v,size) then
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
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.TextDisabled(text)
end
function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() -- ширины контекста окно
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width/count - ((space * (count-1)) / count) -- вернется средние ширины по количеству
end


function openLink(link)
	if isMonetLoader() then
		local gta = ffi.load('GTASA')
		ffi.cdef[[
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
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
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
        elseif ch == 168 then -- Ё
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
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function TranslateNick(name)
	if name:match('%a+') then
        for k, v in pairs({['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['lack'] = 'лэк',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У', ['Ee'] = 'И', ['ee'] = 'и', ['Un'] = 'Ан', ['un'] = 'ан', ['Ci'] = 'Ци', ['ci'] = 'ци', ['yse'] = 'уз', ['cate'] = 'кейт', ['eow'] = 'яу', ['rown'] = 'раун', ['yev'] = 'уев', ['Babe'] = 'Бэйби', ['Jason'] = 'Джейсон', ['liy'] = 'лий', ['ane'] = 'ейн', ['ame'] = 'ейм'}) do
            name = name:gsub(k, v) 
        end
		for k, v in pairs({['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['y`'] = 'ы',['e`'] = 'э',['A'] = 'А',['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',['R'] = 'Р',['S'] = 'С',['zm'] = 'зьм',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к',['``'] = 'ъ',['`'] = 'ь',['_'] = ' '}) do
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
    local p  = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()
 
    local bebrochka = false

    local label      = label or ""                          -- Текст false
    local label_true = label_true or ""                     -- Текст true
    local h          = imgui.GetTextLineHeightWithSpacing() -- Высота кнопки
    local w          = h * 1.7                              -- Ширина кнопки
    local r          = h / 2                                -- Радиус кружка
    local s          = a_speed or 0.2                       -- Скорость анимации
 
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
 
    local x_begin = bool[0] and 1.0 or 0.0
    local t_begin = bool[0] and 0.0 or 1.0
 
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
        if time <= s then
            local anim = ImSaturate(time / s)
            x_begin = bool[0] and anim or 1.0 - anim
            t_begin = bool[0] and 1.0 - anim or anim
        else
            LastActive[label] = false
        end
    end
 
    local bg_color = imgui.ImVec4(x_begin * 0.13, x_begin * 0.9, x_begin * 0.13, imgui.IsItemHovered(0) and 0.7 or 0.9) -- Цвет прямоугольника
    local t_color  = imgui.ImVec4(1, 1, 1, x_begin) -- Цвет текста при false
    local t2_color = imgui.ImVec4(1, 1, 1, t_begin) -- Цвет текста при true
 
    dl:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x + w, p.y + h), imgui.GetColorU32Vec4(bg_color), r)
    dl:AddCircleFilled(imgui.ImVec2(p.x + r + x_begin * (w - r * 2), p.y + r), t_begin < 0.5 and x_begin * r or t_begin * r, imgui.GetColorU32Vec4(imgui.ImVec4(0.9, 0.9, 0.9, 1.0)), r + 5)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)), imgui.GetColorU32Vec4(t_color), label_true)
    dl:AddText(imgui.ImVec2(p.x + w + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)), imgui.GetColorU32Vec4(t2_color), label)
    return bebrochka
end
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('mvd', function() window[0] = not window[0] end)
    sampRegisterChatCommand("su", cmd_su)
    sampRegisterChatCommand("stop", function() if isActiveCommand then command_stop = true else sampAddChatMessage('[Binder] {ffffff}Ошибка, сейчас нету активной отыгровки!', message_color) end end)
    registerCommandsFrom(settings.commands)
    
    while true do
        wait(0)
    end
end

function cmd_su(p_id)
    if p_id == "" then
        msg("Введи айди игрока: {FFFFFF}/su [ID].",0x318CE7FF -1)
    else
    	id = tonumber(p_id)  -- Преобразуем строку в число
        id = imgui.new.int(id)
        windowTwo[0] = not windowTwo[0]
    end
end

local ObuchalName = new.char[255](mainIni.settings.ObuchalName)

imgui.OnFrame(function() return window[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500,500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(1700, 800), imgui.Cond.FirstUseEver)
    imgui.Begin('##Window', window, imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)

    imgui.BeginChild('tabs', imgui.ImVec2(320, -1), true)
    imgui.CenterText(u8('MVD Helper'))
    imgui.Separator()
    if imgui.PageButton(page == 1, ' ', u8'Настройки') then
        page = 1
    end
    if imgui.PageButton(page == 2, ' ', u8'Биндер') then
        page = 2
    end
    if imgui.PageButton(page == 8, ' ', u8'Основное') then
        page = 8
    end
    if imgui.PageButton(page == 3, ' ', u8'Рация департамента') then
        page = 3
    end
    if imgui.PageButton(page == 4, ' ', u8'Для СС') then
        page = 4
    end
    if imgui.PageButton(page == 5, ' ', u8'Шпаргалки') then
        page = 5
    end
    if imgui.PageButton(page == 6, ' ', u8'Дополнительно') then
        page = 6
    end
    if imgui.PageButton(page == 7, ' ', u8'Инфа') then
        page = 7
    end
    imgui.CenterText(u8(''))
    imgui.CenterText(u8('v ' .. thisScript().version))
    imgui.EndChild()
    imgui.SameLine()
    
    imgui.BeginChild('workspace', imgui.ImVec2(-1, -1), true)
    local size = imgui.GetWindowSize()
    local pos = imgui.GetWindowPos()
    

    local tabSize = 40 - 10

    imgui.SetCursorPos(imgui.ImVec2(size.x - tabSize - 5, 5))
    if imgui.Button('X##..##Window::closebutton', imgui.ImVec2(tabSize, tabSize)) then if window then window[0] = false end end

    imgui.SetCursorPosY(20)
    if page == 1 then -- если значение tab == 1
        imgui.Text(u8'Ваш ник: '.. nickname)
        imgui.Text(u8'Ваша организация: '.. mainIni.Info.org)
        imgui.Text(u8'Ваша должность: '.. mainIni.Info.dl)
        if imgui.Button(u8' Настроить УК') then
            setUkWindow[0] = not setUkWindow[0]
        end
        if imgui.Combo(u8'Темы', selected_theme, items, #theme_a) then
            themeta = theme_t[selected_theme[0]+1]
            mainIni.theme.themeta = themeta
            mainIni.theme.selected = selected_theme[0]
            inicfg.save(mainIni, 'mvdhelper.ini')
            apply_n_t()
        end
        imgui.Text(u8'Цвет MoonMonet - ')
        imgui.SameLine()
        if imgui.ColorEdit3('## COLOR', mmcolor, imgui.ColorEditFlags.NoInputs) then
            r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
            argb = join_argb(0, r, g, b)
            mainIni.theme.moonmonet = argb
            inicfg.save(mainIni, 'mvdhelper.ini')
            apply_n_t()
        end
        imgui.ToggleButton(u8 'Авто отыгровка оружия', u8'Авто отыгровка оружия', autogun)
        if autogun[0] then
            mainIni.settings.autoRpGun = true
            inicfg.save(mainIni, "mvdhelper.ini")
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
            
        else
            mainIni.settings.autoRpGun = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        
        imgui.ToggleButton(u8'Авто-Акцент', u8'Авто-Акцент', AutoAccentBool)
        if AutoAccentBool[0] then
            AutoAccentCheck = true
            mainIni.settings.autoAccent = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
            mainIni.settings.autoAccent = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.InputText(u8'Акцент', AutoAccentInput, 255)
        AutoAccentText = u8:decode(ffi.string(AutoAccentInput))
        mainIni.Accent.accent = AutoAccentText
        inicfg.save(mainIni, "mvdhelper.ini")
        if imgui.Button(u8'Вспомогательное окошко') then
            suppWindow[0] = not suppWindow [0]
        end
        imgui.ToggleButton (u8(mainIni.settings.ObuchalName) .. u8' работает', u8(mainIni.settings.ObuchalName) .. u8' отдыхает', joneV)
        if joneV[0] then
            mainIni.settings.Jone = true
            inicfg.save(mainIni, "mvdhelper.ini")
        else
        	mainIni.settings.Jone = false
            inicfg.save(mainIni, "mvdhelper.ini")
        end
        imgui.InputText(u8"Имя обучальщика", ObuchalName, 255)
        Obuchal = u8:decode(ffi.string(ObuchalName))
        mainIni.settings.ObuchalName = Obuchal
        inicfg.save(mainIni, "mvdhelper.ini")
        
    elseif page == 8 then -- если значение tab == 8
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
                wait(1500)
                sampSendChat("/showbadge ")
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
                msg("Встаньте на чекпоинт",0x8B00FF)
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
                sampSendChat("/me проверяет карманы")
                                wait(1500)
        sampSendChat ("/me проводит руками по ногам")
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
    elseif page == 2 then -- если значение 
        
        -- для удобства зададим ширину каждой колонки в начале
        local w = {
            first = 150,
            second = 250,
        }
        
        
        -- == Первая строка
        		if imgui.BeginChild('##1', imgui.ImVec2(589 * MONET_DPI_SCALE, 333 * MONET_DPI_SCALE), true) then
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
			imgui.CenterColumnText(u8"/binder")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Открыть главное меню биндера")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Недоступно")
			imgui.Columns(1)	
			imgui.Separator()
			imgui.Columns(3)
			imgui.CenterColumnText(u8"/stop")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Остановить любую отыгровку из биндера")
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Недоступно")
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
						if imgui.SmallButton(fa.TOGGLE_ON .. '##'..command.cmd) then
							command.enable = not command.enable
							save_settings()
							sampUnregisterChatCommand(command.cmd)
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8"Отключение команды /"..command.cmd)
						end
					else
						if imgui.SmallButton(fa.TOGGLE_OFF .. '##'..command.cmd) then
							command.enable = not command.enable
							save_settings()
							register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						end
						if imgui.IsItemHovered() then
							imgui.SetTooltip(u8"Включение команды /"..command.cmd)
						end
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
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
						imgui.SetTooltip(u8"Изменение команды /"..command.cmd)
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8"Удаление команды /"..command.cmd)
					end
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
						imgui.CenterText(u8'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить', imgui.ImVec2(200 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
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
		if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую команду##new_cmd',imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local new_cmd = {cmd = '', description = 'Новая команда созданная вами', text = '', arg = '', enable = true , waiting = '1.200', deleted = false }
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
    elseif page == 3 then -- если значение tab == 3
        imgui.InputText(u8 'Фракция с которой будете взаимодействовать', otherorg, 255)
        otherdeporg = u8:decode(ffi.string(otherorg))
        imgui.ToggleButton(u8'Открытый канал', u8'Закрытый канал', zk)
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
    elseif page == 4 then
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
        if rang_n > 8 then
            
            if imgui.Button(u8'Панель лидера/заместителя') then
                leaderPanel[0] = not leaderPanel[0]
            end
        end
    elseif page == 5 then
        if imgui.CollapsingHeader(u8 'УК') then
            for i = 1, #tableUk["Text"] do
                imgui.Text(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i]))
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
            imgui.Text(u8"10-10 - Нарушение юрисдикции ")
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

    elseif page == 6 then
        imgui.Text(u8'Версия: ' .. thisScript().version)
        imgui.Text(u8'Разработчики: https://t.me/Sashe4ka_ReZoN, https://t.me/daniel2903_pon, https://t.me/Theopka')
        imgui.Text(u8'ТГ канал: t.me/lua_arz') 
        imgui.Text(u8'Поддержать: Временно не доступно') 
        imgui.Text(u8'Спонсоры: @Negt,@King_Rostislavia,@sidrusha,@Timur77998, @osp_x, @Theopka')
        imgui.Text(u8'5.1 - обновление интерфейса, новый биндер(взят у @MTG_mods), Обучальщик, убрана вкладка дополнительно(перенесено в настройки)')
    end
    imgui.EndChild()
    imgui.End()
end)
      
function DownloadUk()
    if server == 'Phoenix' then
        updateScript(smartUkUrl['phenix'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile I' then
        updateScript(smartUkUrl['m1'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 1 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile II' then
        updateScript(smartUkUrl['m2'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 2 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile III' then
        updateScript(smartUkUrl['m3'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 3 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Phoenix' then
        updateScript(smartUkUrl['phoenix'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Tucson' then
        updateScript(smartUkUrl['tucson'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Tucson успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Saintrose' then
        updateScript(smartUkUrl['saintrose'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Saintrose успешно установлен!", 0x8B00FF)
                    
    elseif server == 'Mesa' then
        updateScript(smartUkUrl['mesa'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mesa успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Red-Rock' then
        updateScript(smartUkUrl['red'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Red Rock успешно установлен!", 0x8B00FF)
                                            
    elseif server == 'Prescott' then
        updateScript(smartUkUrl['press'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Prescott успешно установлен!", 0x8B00FF)
                                            
    elseif server == 'Winslow' then
        updateScript(smartUkUrl['winslow'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Winslow успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Payson' then
        updateScript(smartUkUrl['payson'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Payson успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Gilbert' then
        updateScript(smartUkUrl['gilbert'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Gilbert успешно установлен!", 0x8B00FF)
    
    elseif server == 'Casa-Grande' then
        updateScript(smartUkUrl['casa'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Casa-Grande успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Page' then
        updateScript(smartUkUrl['page'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Page успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Sun-City' then
        updateScript(smartUkUrl['sunCity'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Sun-City успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Wednesday' then
        updateScript(smartUkUrl['wednesday'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Wednesday успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Yava' then
        updateScript(smartUkUrl['yava'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Yava успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Faraway' then
        updateScript(smartUkUrl['faraway'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Faraway успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Bumble Bee' then
        updateScript(smartUkUrl['bumble'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Bumble успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Christmas' then
        updateScript(smartUkUrl['christmas'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Christmas успешно установлен!", 0x8B00FF)
    
    else
        msg("{FFFFFF} К сожалению на ваш сервер не найден умный розыск. Он будет добавлен в следующих обновлениях", 0x8B00FF)
    end
end
function sampev.onSendSpawn()
	if spawn and isMonetLoader() then
		spawn = false
		sampSendChat('/stats')
        msg("{FFFFFF}MVDHelper успешно загружен!", 0x8B00FF)
        msg("{FFFFFF}Команда: /mvd",0x8B00FF)
        nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))
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


function imgui.CenterText(text)
    imgui.SetCursorPosX(imgui.GetWindowWidth()/2-imgui.CalcTextSize(u8(text)).x/2)
    imgui.Text(text)
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
        imgui.InputInt(u8 'ID игрока с которым будете взаимодействовать', id, 10)
        
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

        if imgui.Button(u8'Скачать умный розыск для своего сервера') then
            DownloadUk()
        end    
        if imgui.BeginChild('Name', imgui.ImVec2(0, imgui.GetWindowSize().y - 36 - imgui.GetCursorPosY() - imgui.GetStyle().FramePadding.y * 2), true) then
                for i = 1, #tableUk["Text"] do
                    imgui.Text(u8(tableUk["Text"][i] .. ' Уровень розыска: ' .. tableUk["Ur"][i]))
                    Uk = #tableUk["Text"]
                end
                imgui.EndChild()
            end
            if imgui.Button(u8'Добавить', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
                addUkWindow[0] = not addUkWindow[0]
            end
            imgui.SameLine()
            if imgui.Button(u8'Удалить', imgui.ImVec2(GetMiddleButtonX(2), 36)) then
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

local importUkFrame = imgui.OnFrame(
    function() return importUkWindow[0] end,
    function() return true end,
    function (player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Импорт умного розыска", addUkWindow)
        if imgui.Button(u8'Phoenix') then
            updateScript(smartUkUrl['phenix'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
       
        elseif imgui.Button(u8'Mobile I') then
            updateScript(smartUkUrl['m1'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Mobile 1 успешно установлен!", 0x8B00FF)
        
        elseif imgui.Button(u8'Mobile II') then
            updateScript(smartUkUrl['m2'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Mobile 2 успешно установлен!", 0x8B00FF)
        
        elseif imgui.Button(u8'Mobile III') then
            updateScript(smartUkUrl['m3'], smartUkPath)
        
        elseif imgui.Button(u8'Phoenix') then
            updateScript(smartUkUrl['phenix'], smartUkPath)
                            
        elseif imgui.Button(u8'Tucson') then
            updateScript(smartUkUrl['tucson'], smartUkPath)
                            
        elseif imgui.Button(u8'Saintrose') then
            updateScript(smartUkUrl['phenix'], smartUkPath)
                            
        elseif imgui.Button(u8'Mesa') then
            updateScript(smartUkUrl['mesa'], smartUkPath)
                            
        elseif imgui.Button(u8'Red-Rock') then
            updateScript(smartUkUrl['red'], smartUkPath)
                                                
        elseif imgui.Button(u8'Prescott') then
            updateScript(smartUkUrl['press'], smartUkPath)
                                                
        elseif imgui.Button(u8'Winslow') then
            updateScript(smartUkUrl['winslow'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Payson') then
            updateScript(smartUkUrl['payson'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Gilbert') then
            updateScript(smartUkUrl['gilbert'], smartUkPath)
        
        elseif imgui.Button(u8'Casa-Grande') then
            updateScript(smartUkUrl['casa'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Casa-Grande успешно установлен!", 0x8B00FF)
                                                                    
        elseif imgui.Button(u8'Page') then
            updateScript(smartUkUrl['page'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Sun-City') then
            updateScript(smartUkUrl['sunCity'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Sun-City успешно установлен!", 0x8B00FF)
                                                                    
        elseif imgui.Button(u8'Wednesday') then
            updateScript(smartUkUrl['wednesday'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Yava') then
            updateScript(smartUkUrl['yava'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Faraway') then
            updateScript(smartUkUrl['faraway'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Bumble Bee') then
            updateScript(smartUkUrl['bumble'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Christmas') then
            updateScript(smartUkUrl['christmas'], smartUkPath)
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
			imgui.Text(u8'Город: ' .. (pCity or u8'Неизвестно'))
		imgui.End()
    end
)
      
local binderWindowFrame = imgui.OnFrame(
    function() return binderWindow[0] end,
    function()
        return true
    end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(200, 150), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Создание бинда", binderWindow)
        imgui.InputText(u8'Введите команду(без/)', inputComName, 10)
        imgui.InputTextMultiline(u8'Введите текст', inputComText, 255)
        if imgui.Button(u8'Сохранить') then
            local comName = u8:decode(ffi.string(inputComName))
            local comText = u8:decode(ffi.string(inputComText))
            local linesArray = {}
            for line in comText:gmatch("[^\r\n]+") do
                table.insert(linesArray, line)
            end
            
            Binds = #tableBinder
            tableBinder[comName] = {}
            for i = 1, #linesArray do
                table.insert(tableBinder[comName], linesArray[i])
            end
            encodedTable = encodeJson(tableBinder)
            local file = io.open("binder.json", "w")
            file:write(encodedTable)
            file:flush()
            file:close()
            sampRegisterChatCommand (comName, function()
            	lua_thread.create(function()
					for I = 1, #linesArray do
						sampSendChat (linesArray [I])
						wait(1500)
					end
				end)
            end)
        end
		imgui.End()
    end
)

function table.find(t, v)
    for k, vv in pairs(t) do
       if vv == v then return k end
    end
    return nil
 end
 
 function deleteBindFunc(key)
 	tableBinder[key] = nil
                        encodedTable = encodeJson(tableBinder)
            local file = io.open("binder.json", "w")
            file:write(encodedTable)
            file:flush()
            file:close()
 end

 function sampev.onSendChat(cmd)
    if  mainIni.settings.autoAccent then
      if cmd == ')' or cmd == '(' or cmd ==  '))' or cmd == '((' or cmd == 'xD' or cmd == ':D' or cmd == ':d' or cmd == 'XD' then
        return{cmd}
      end
      cmd = mainIni.Accent.accent .. ' ' .. cmd
      return{cmd}
    end
    return{cmd}
  end

imgui.PageButton = function(bool, icon, name, but_wide)
    but_wide = but_wide or 290
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
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 55))
    if result and not bool then
        pool.clock = os.clock()
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
    if bool then
        if pool.clock and (os.clock() - pool.clock) < duration then
            local wide = (os.clock() - pool.clock) * (but_wide / duration)
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 290) - wide, p1.y + 55), 0x10FFFFFF, 15, 10)
               DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 5, p1.y + 55), ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 55), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
        else
            DL:AddRectFilled(imgui.ImVec2(p1.x, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 5, (pressed and p1.y + 32 or p1.y + 55)), ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 290, p1.y + 55), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 15, 10)
        end
    else
        if imgui.IsItemHovered() then
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 290, p1.y + 55), 0x10FFFFFF, 15, 10)
        end
    end
    imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
    if bool then
        imgui.Text((' '):rep(3) .. icon)
        imgui.SameLine(60)
        imgui.Text(name)
    else
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
        imgui.SameLine(60)
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
    end
    imgui.SetCursorPosY(p2.y + 70)
    return result
end

function apply_n_t()
    if mainIni.theme.themeta == 'standart' then
    	DarkTheme()
	elseif mainIni.theme.themeta == 'moonmonet' then
		gen_color = monet.buildColors(mainIni.theme.moonmonet, 1.0, true)
    	local a, r, g, b = explode_argb(gen_color.accent1.color_300)
		curcolor = '{'..rgb2hex(r, g, b)..'}'
    	curcolor1 = '0x'..('%X'):format(gen_color.accent1.color_300)
        apply_monet()
	end
end

function decor()
    imgui.SwitchContext()
	local style = imgui.GetStyle()
    style.WindowPadding = imgui.ImVec2(15, 15)
    style.WindowRounding = 10.0
    style.ChildRounding = 25.0
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

function DarkTheme() -- https://www.blast.hk/threads/25442/post-973165
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    -- Цвета
    style.Colors[imgui.Col.Text]                   = imgui.ImVec4(0.90, 0.85, 0.85, 1.00)
    style.Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    style.Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
    style.Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.18, 0.05, 0.05, 1.00)
    style.Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
    style.Colors[imgui.Col.Border]                 = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    style.Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.08, 0.08, 1.00)
    style.Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.30, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.20, 0.05, 0.05, 1.00)
    style.Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
    style.Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.20, 0.05, 0.05, 1.00)
    style.Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.15, 0.03, 0.03, 1.00)
    style.Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.60, 0.12, 0.12, 1.00)
    style.Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.70, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.CheckMark]              = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
    style.Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
    style.Colors[imgui.Col.Button]                 = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
    style.Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
    style.Colors[imgui.Col.Header]                 = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
    style.Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
    style.Colors[imgui.Col.Separator]              = imgui.ImVec4(0.50, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.60, 0.12, 0.12, 1.00)
    style.Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.70, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
    style.Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
    style.Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.80, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.80, 0.10, 0.10, 1.00)
    style.Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(0.90, 0.15, 0.15, 1.00)
    style.Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.20, 0.05, 0.05, 0.80)
    style.Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.25, 0.07, 0.07, 1.00)
    style.Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.80, 0.20, 0.20, 1.00)
    style.Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.90, 0.25, 0.25, 1.00)
end
function join_argb(a, r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))  -- g
    argb = bit.bor(argb, bit.lshift(r, 16)) -- r
    argb = bit.bor(argb, bit.lshift(a, 24)) -- a
    return argb
end

--Наш дарагой Джончек
local newFrame = imgui.OnFrame(
    function() return joneV[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 1500, 300
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY - 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        imgui.Begin('Jone', joneV, imgui.WindowFlags.NoDecoration)
        imgui.Image(imhandle, imgui.ImVec2(200, 200))
        imgui.SetCursorPosX(250)
        imgui.SetCursorPosY(25)
        if window [0] then
            imgui.SetWindowFocus()
        	if page == 1 then -- если значение tab == 1
                imgui.SetWindowFocus()
                imgui.Text(u8"Отлично! И так, я помогу тебе обучится работать с МВД хелпером!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Для начала начнем с того, что МВД хелпер разработан для Mobile устройств")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"С целью облегчить работу в МЮ.")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"На этой страничке есть кнопка настройки УК. Там ты можешь скачать для себя УК и настроить его!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Еще тут есть выбор темы. Ты можешь выбрать MoonMonet и настроить свой цвет!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 8 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - страничка быстрого взаимодействия.")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Так же это окошко открывается при двойном нажатии на игрока(работает коряво)")
                imgui.SetCursorPosX(250)                
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 2 then
                imgui.SetWindowFocus()
                imgui.Text(u8"А это - одна из самых выжных вкладок!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Это биндер, в котором ты можешь создавать свои команды, а так же изменять готовые!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 3 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - вкладка гос. волны")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Тут ты можешь связываться с другими организациями\nФункций покачто мало, но они будут доабвляться!")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 4 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - вкладка для старшего состава, она тоже будет дорабатываться")        
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 5 then
                imgui.SetWindowFocus()
                imgui.Text(u8"А это шпаргалки с УК, тен-кодами и т.д.")        
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 6 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Тоже не менее важная вкладка - доп. настройки")        
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Что тут есть ты сам видешь внизу.")
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Встретимся в следующей вкладке!")
            elseif page == 7 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - последняя вкладка. Тут находится инф-я о МВД хелпере")        
                imgui.SetCursorPosX(250)
                imgui.Text(u8"Ну что, пришло время прощаться. Наше обучение подошло к концу.\nТы можешь меня выключить/включить в это вкладке, удачи!")
            end
        else
        	imgui.Text(u8"Привет! Я " .. u8(mainIni.settings.ObuchalName) .. u8". Я помогу тебе научится работать с хелпером.")
        	imgui.SetCursorPosX(250)
        	imgui.Text(u8"Для начала открой меню через команду в чате /mvd")
        	imgui.End()
        end
    end
)

