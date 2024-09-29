require 'moonloader'
local imgui = require('mimgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local AI_PAGE = {}
local ToU32 = imgui.ColorConvertFloat4ToU32
local page = 1
local requests = require'requests'
local window = imgui.new.bool()
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
script_name("MVD Helper Mobile")

script_version("5.2")
script_author("@Sashe4ka_ReZoN @daniel29032012 @makson4ck2")

MDS = MONET_DPI_SCALE or 1
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
local path = getWorkingDirectory() .. "/config/Binder.json"
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

local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new

-- Ссылки
local mvdPath = script.this.filename
local smartUkPath = getWorkingDirectory() .. "/smartUk.json"
local mvdUrl = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/MVDHelper.lua"
-- Смарт Ук
local smartUkUrl = {
    m1 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile1.json",
    m2 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile2.json",
    m3 = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Mobile 3.json",
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
    sunCity = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sun-City.json",
    wednesday = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Wednesday.json",
    yava = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Yava.json",
    faraway = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Faraway.json",
    bumble = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Bumble Bee.json",
    christmas = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Christmas.json",
    brainburg = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Brainburg.json",
    sedona = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/smartUkLink/Sedona.json"
}


local renderWindow = new.bool()
local sizeX, sizeY = getScreenResolution()
local id = imgui.new.int(0)
local otherorg = imgui.new.char(255)
local searchInput = imgui.new.char(255)
local zk = new.bool()
local tab = 1
local updateWin = imgui.new.bool(false)
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
						updateUrl = url
						version = uVer
						textnewupdate = uText
						updateWin[0] = true
					else
						msg('{ffffff}Обновление не нужно, у вас актуальная версия!')
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
        print('Ошибка скачивания...')
    end
end
function downloadBinder()
  file = io.open(path, "w")
  file:close()
  file = io.open(path, "a+")
    downloadFile("https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/refs/heads/main/Binder.json", path)
    msg('Устанавливается файл биндера, перезагрузка')
    thisScript():reload()
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
	if doesFileExist('config/Jone.png') then

  imhandle = imgui.CreateTextureFromFile('config/Jone.png')

  else
local http = require("socket.http") 
local ltn12 = require("ltn12") 
local url = "https://raw.githubusercontent.com/DanielBagdasarian/MVD-Helper-Mobile/main/Jone.png" 
local file_name = "config/Jone.png"
local qwerty = io.open(file_name, "wb") 
http.request{ 
    url = url, 
    sink = ltn12.sink.file(qwerty) 
} 
thisScript():reload() 
end
end)
function downloadToFile(url, path, callback, progressInterval)

	callback = callback or function() end

	progressInterval = progressInterval or 0.1

	local effil = require("effil")
	local progressChannel = effil.channel(0)

	local runner = effil.thread(function(url, path)
	local http = require("socket.http")
	local ltn = require("ltn12")

	local r, c, h = http.request({
		method = "HEAD",
		url = url,
	})

	if c ~= 200 then
		return false, c
	end
	local total_size = h["content-length"]

	local f = io.open(path, "wb")
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
local MainWindow = imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
	
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * MONET_DPI_SCALE, 425	* MONET_DPI_SCALE), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.TERMINAL..u8" Binder by MTG MODS - Главное меню", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
	
		if imgui.BeginChild('##1', imgui.ImVec2(700 * MONET_DPI_SCALE, 700 * MONET_DPI_SCALE), true) then
			imgui.Columns(3)
			imgui.CenterColumnText(u8"Команда")
			imgui.SetColumnWidth(-1, 170 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Описание")
			imgui.SetColumnWidth(-1, 300 * MONET_DPI_SCALE)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Действие")
			imgui.SetColumnWidth(-1, 230 * MONET_DPI_SCALE)
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
    check_update()
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

local ObuchalName = new.char[255](u8(mainIni.settings.ObuchalName))

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
        if imgui.InputText(u8"Имя обучальщика", ObuchalName, 255) then
        Obuchal = u8:decode(ffi.string(ObuchalName))
        mainIni.settings.ObuchalName = Obuchal
        inicfg.save(mainIni, "mvdhelper.ini")
        end
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
        		if imgui.BeginChild('##1', imgui.ImVec2(600 * MONET_DPI_SCALE, 333 * MONET_DPI_SCALE), true) then
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
            imgui.CenterText(u8'Маркировки патрульных автомобилей')
            imgui.Text(u8"* ADAM (A) - маркировка патруля с двумя офицерами на крузер")
            imgui.Text(u8"* LINCOLN (L) - маркировки патруля с одним офицером на крузер")
            imgui.Text(u8"* LINCOLN 10/20/30/40/50/60 - маркировка супервайзера")
            imgui.CenterText(u8'Маркировки других транспортных средств')
            imgui.Text(u8"* MARY (M) - маркировка мотоциклетного патруля")
            imgui.Text(u8"* AIR (AIR) - маркировка юнита Air Support Division")
            imgui.Text(u8"* AIR-100 - маркировка супервайзера Air Support Division")
            imgui.Text(u8"* AIR-10 - маркировка спасательного юнита Air Support Division")
            imgui.Text(u8"* EDWARD (E) - маркировка Tow Unit")
        end

    elseif page == 6 then
        imgui.Text(u8'Версия: ' .. thisScript().version)
        imgui.Text(u8'Разработчики: https://t.me/Sashe4ka_ReZoN, https://t.me/daniel2903_pon, https://t.me/makson4ck2')
        imgui.Text(u8'ТГ канал: t.me/lua_arz') 
        imgui.Text(u8'Поддержать: Временно не доступно') 
        imgui.Text(u8'Спонсоры: @Negt,@King_Rostislavia,@sidrusha,@Timur77998, @osp_x, @Theopka')
        imgui.Text(u8'5.1 - обновление интерфейса, новый биндер(взят у @MTG_mods), Обучальщик, убрана вкладка дополнительно(перенесено в настройки)')
elseif page == 7 then
    imgui.Text('Обновление 5.2:\n- Обучальное окошко переделано\nПосле обучения по МВД хелперу на последней странице вам предлагается сразу отключить помощника по кнопке\nТеперь биндер и УК правильно скачиваются\nСервер определяется правильно и УК установится с первого раза(ранее писало unkown server)\nДобавлена функция обновления скрипта, теперь при входе у вас проверяется скрипт на наличие обновлений, если есть - то вам вылезет окошко с обновлением\nи новыми функциями которые есть в данном обновлении, в ином случаи в чат выведет что обновления не найдены\nКартинка Jone.png теперь сама скачивается в папку config\nИсправлен баг с binder.json (ранее он не скачивался сам и при входе во вкладку крашился скрипт)')
end
    imgui.EndChild()
    imgui.End()
end)
      
function DownloadUk()
    if server == 'Phoenix' then
        downloadFile(smartUkUrl['phenix'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile I' then
        downloadFile(smartUkUrl['m1'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 1 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile II' then
        downloadFile(smartUkUrl['m2'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 2 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Mobile III' then
        downloadFile(smartUkUrl['m3'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mobile 3 успешно установлен!", 0x8B00FF)
    
    elseif server == 'Phoenix' then
        downloadFile(smartUkUrl['phoenix'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Tucson' then
        downloadFile(smartUkUrl['tucson'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Tucson успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Saintrose' then
        downloadFile(smartUkUrl['saintrose'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Saintrose успешно установлен!", 0x8B00FF)
                    
    elseif server == 'Mesa' then
        downloadFile(smartUkUrl['mesa'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Mesa успешно установлен!", 0x8B00FF)
                        
    elseif server == 'Red-Rock' then
        downloadFile(smartUkUrl['red'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Red Rock успешно установлен!", 0x8B00FF)
                                            
    elseif server == 'Prescott' then
        downloadFile(smartUkUrl['press'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Prescott успешно установлен!", 0x8B00FF)
                                            
    elseif server == 'Winslow' then
        downloadFile(smartUkUrl['winslow'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Winslow успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Payson' then
        downloadFile(smartUkUrl['payson'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Payson успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Gilbert' then
        downloadFile(smartUkUrl['gilbert'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Gilbert успешно установлен!", 0x8B00FF)
    
    elseif server == 'Casa-Grande' then
        downloadFile(smartUkUrl['casa'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Casa-Grande успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Page' then
        downloadFile(smartUkUrl['page'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Page успешно установлен!", 0x8B00FF)
                                                                
    elseif server == 'Sun-City' then
        downloadFile(smartUkUrl['sunCity'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Sun-City успешно установлен!", 0x8B00FF)
    elseif server == 'Sedona' then
        downloadFile(smartUkUrl['sedona'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Sedona успешно установлен!", 0x8B00FF)
    elseif server == 'Brainburg' then
        downloadFile(smartUkUrl['brainburg'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Brainburg успешно установлен!", 0x8B00FF)    
    elseif server == 'Wednesday' then
        downloadFile(smartUkUrl['wednesday'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Wednesday успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Yava' then
        downloadFile(smartUkUrl['yava'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Yava успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Faraway' then
        downloadFile(smartUkUrl['faraway'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Faraway успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Bumble Bee' then
        downloadFile(smartUkUrl['bumble'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Bumble успешно установлен!", 0x8B00FF)
                                                                                    
    elseif server == 'Christmas' then
        downloadFile(smartUkUrl['christmas'], smartUkPath)
        msg("{FFFFFF} Умный розыск на Christmas успешно установлен!", 0x8B00FF)
        
    else
        msg("{FFFFFF} К сожалению на ваш сервер не найден умный розыск. Он будет добавлен в следующих обновлениях", 0x8B00FF)
    end
end
server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"
function sampev.onSendSpawn()
	if spawn and isMonetLoader() then
		spawn = false
        server = servers[sampGetCurrentServerAddress()] and servers[sampGetCurrentServerAddress()].name or "Unknown"
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
            downloadFile(smartUkUrl['phenix'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Phoenix успешно установлен!", 0x8B00FF)
       
        elseif imgui.Button(u8'Mobile I') then
            downloadFile(smartUkUrl['m1'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Mobile 1 успешно установлен!", 0x8B00FF)
        
        elseif imgui.Button(u8'Mobile II') then
            downloadFile(smartUkUrl['m2'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Mobile 2 успешно установлен!", 0x8B00FF)
        
        elseif imgui.Button(u8'Mobile III') then
            downloadFile(smartUkUrl['m3'], smartUkPath)
        
        elseif imgui.Button(u8'Phoenix') then
            downloadFile(smartUkUrl['phenix'], smartUkPath)
                            
        elseif imgui.Button(u8'Tucson') then
            downloadFile(smartUkUrl['tucson'], smartUkPath)
                            
        elseif imgui.Button(u8'Saintrose') then
            downloadFile(smartUkUrl['phenix'], smartUkPath)
                            
        elseif imgui.Button(u8'Mesa') then
            downloadFile(smartUkUrl['mesa'], smartUkPath)
                            
        elseif imgui.Button(u8'Red-Rock') then
            downloadFile(smartUkUrl['red'], smartUkPath)
                                                
        elseif imgui.Button(u8'Prescott') then
            downloadFile(smartUkUrl['press'], smartUkPath)
                                                
        elseif imgui.Button(u8'Winslow') then
            downloadFile(smartUkUrl['winslow'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Payson') then
            downloadFile(smartUkUrl['payson'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Gilbert') then
            downloadFile(smartUkUrl['gilbert'], smartUkPath)
        
        elseif imgui.Button(u8'Casa-Grande') then
            downloadFile(smartUkUrl['casa'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Casa-Grande успешно установлен!", 0x8B00FF)
                                                                    
        elseif imgui.Button(u8'Page') then
            downloadFile(smartUkUrl['page'], smartUkPath)
                                                                    
        elseif imgui.Button(u8'Sun-City') then
            downloadFile(smartUkUrl['sunCity'], smartUkPath)
            msg("{FFFFFF} Умный розыск на Sun-City успешно установлен!", 0x8B00FF)
                                                                    
        elseif imgui.Button(u8'Wednesday') then
            downloadFile(smartUkUrl['wednesday'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Yava') then
            downloadFile(smartUkUrl['yava'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Faraway') then
            downloadFile(smartUkUrl['faraway'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Bumble Bee') then
            downloadFile(smartUkUrl['bumble'], smartUkPath)
                                                                                        
        elseif imgui.Button(u8'Christmas') then
            downloadFile(smartUkUrl['christmas'], smartUkPath)
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
        imgui.Begin(u8"Вспомогательное окошко", suppWindow, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)

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
            local file = io.open(path, "w")
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
            local file = io.open(path, "w")
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
        local sizeX, sizeY = 350, 500
        imgui.SetNextWindowPos(imgui.ImVec2(resX/2, resY - 200), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        imgui.Begin('Jone', joneV, imgui.WindowFlags.NoDecoration + imgui.WindowFlags.AlwaysAutoResize)
        imgui.Image(imhandle, imgui.ImVec2(200, 200))
        if window [0] then
            imgui.SetWindowFocus()
        	if page == 1 then -- если значение tab == 1
                imgui.SetWindowFocus()
                imgui.Text(u8"И так, я помогу тебе обучится работать\nс МВД хелпером!\nДля начала начнем с того,\nчто МВД хелпер разработан для Mobile\nС целью облегчить работу в МЮ.\nНа этой странице есть настройка УК.\nТам ты можешь скачать для себя УК или настроить его!\nЕще тут есть выбор темы MVD Helper. \nТы можешь выбрать MoonMonet и настроить свой цвет!")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 2
                end
            elseif page == 8 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - страничка быстрого взаимодействия.")
                imgui.Text(u8"Так же это окошко открывается при двойном нажатии на игрока(работает коряво)")

            elseif page == 2 then
                imgui.SetWindowFocus()
                imgui.Text(u8"А это - одна из самых выжных вкладок!\nЭто биндер, в котором ты можешь\nсоздавать свои команды\nа так же изменять готовые!")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 3
                end
            elseif page == 3 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - вкладка гос. волны\nТут ты можешь связываться с организациями\nФункций пока что мало, они будут добавляться!")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 4
                end
            elseif page == 4 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - вкладка для старшего состава\nона тоже будет дорабатываться")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 5
                end
            elseif page == 5 then
                imgui.SetWindowFocus()
                imgui.Text(u8"А это шпаргалки с УК, тен-кодами и т.д.")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 6
                end
            elseif page == 6 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Вкладка - доп. настройки\nЧто тут есть ты сам видешь внизу.")
                if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                    page = 7
                end
            elseif page == 7 then
                imgui.SetWindowFocus()
                imgui.Text(u8"Это - последняя вкладка.\nТут находится инф-я о МВД хелпере\nНу что, пришло время прощаться.\nНаше обучение подошло к концу.\nТы можешь меня выключить в первой вкладке\nЖелаю тебе удачи!")
                if imgui.Button(u8'Выключить меня') then
                  joneV[0] = false
                  mainIni.settings.Jone = false
            inicfg.save(mainIni, "mvdhelper.ini")
                  end
            end
        else
        	imgui.Text(u8"Привет! Я " .. u8(mainIni.settings.ObuchalName) .. u8".\nЯ помогу тебе научится работать с\nхелпером.")
        	if imgui.Button(u8'Далее >>', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
                window [0] = true
            end
        	imgui.End()
        end
    end
)

imgui.OnFrame(
    function() return updateWin[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Обновление!", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.Text(u8'Найдена новая версия хелпера: ' .. u8(version))
		imgui.Text(u8'В нем есть новый функционал!')
		imgui.Separator()
		imgui.CenterText(u8('Список добавленых функций в версии ') .. u8(version) .. ':')
		imgui.Text(u8(textnewupdate))
		imgui.Separator()
		if imgui.Button(u8'Не обновляться',  imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
			updateWin[0] = false
		end
		imgui.SameLine()
		if imgui.Button(u8'Загрузить новую обнову',  imgui.ImVec2(250 * MONET_DPI_SCALE, 25 * MONET_DPI_SCALE)) then
            downloadFile(updateUrl, helper_path)
			updateWin[0] = false
		end
		imgui.End()
    end
)

logo = "\xF4\xF2\x7A\x02\xF2\x65\xAF\xB6\x97\x09\xFE\x35\x2C\x40\xF8\xBF\xB4\xFC\xD2\xD9\xC1\xCE\xA6\x47\x8F \x1E\x3D\x7A\x39\xB9\x68\x18\x27\x7F\xF1\x02\xDC\xD9\x1A\xB4\xE9\xF0\x15\x8F\x27\x10\x8D\xC4\xE6\x4C \x7E\x9B\x6B\xF1\x18\x36\xE9\x55\x9E\xE7\xDA\x0E\x22\xD1\xCC\xE1\x5F\x01\x88\x3E\xFB\x20\x64\x2C\xC2 \xFA\x42\x8F\x1E\x3D\x7A\xF4\xF2\x78\xDA\x0E\x2F\x9C\xD7\xBB\xFB\x69\x0B\x15\xFE\x01\x48\x0D\xBE\x6D \xEC\x6C\x7A\xF4\xE8\xD1\xA3\x97\xB5\x49\x89\xE8\x8E\x67\x10\x9F\x0A\x60\x34\x68\xA5\xB4\x4B\xE1\x3F \xD5\x4C\xD3\x42\x38\x1C\x41\xBE\xB3\xA6\x19\x36\xE9\x55\xA2\xE7\x58\x16\xA2\xD1\xEC\x07\xB1\x26\x27 \x43\x70\x27\x2F\x22\xF6\xF2\xD3\x98\x35\xC8\x59\x5F\xE8\xD1\xA3\x47\x8F\xDE\x1C\x4F\x48\xEC\xCC\xC7 \x79\x0D\xFF\x98\xF3\x02\x4F\x2D\x17\xBE\xFB\x33\x9B\x86\xA0\xD4\x59\x76\x36\x3D\x7A\xF4\xE8\xD1\xCB \xE4\x99\x6F\xEE\x81\xD3\x9B\xFC\x9A\x38\x35\x1A\xCF\x18\xFE\x53\xCD\xB6\x1D\x84\x43\x61\x48\x29\xB3 \x70\x0C\x9B\xF4\x2A\xCF\xB3\xE2\x09\xC4\x62\x89\x9C\xEF\x1D\x1E\x99\x00\x00\x38\x7D\xE7\x60\x1E\x3D \xC0\xFA\x42\x8F\x1E\x3D\x7A\xF4\x32\x7A\x4A\xA9\x13\xBB\xEF\x6D\x1F\xCA\xC5\x15\x12\xFE\x81\x02\x0F \x00\x78\xC2\x85\x78\x99\x9D\x4D\x8F\x1E\x3D\x7A\xF4\xE6\x7A\xEE\xF8\x79\x24\x5E\x9F\x39\x88\x7D\x7C \x24\x96\x35\xFC\xA7\x9A\xE3\xB8\x08\x05\x23\x70\xE7\x1C\x04\x60\xD8\xA4\x57\x71\x9E\x12\x48\x44\x63 \x48\x98\x56\xDE\xF7\xF7\x0D\x8C\x5D\xFA\xEF\xC4\xFE\x97\x20\xC7\x2F\xB0\xBE\xD0\xA3\x47\x8F\x1E\xBD \x4C\xEF\x78\x25\x17\x57\x68\xF8\x07\x0A\x38\x00\xE0\x19\x17\x72\x47\x95\x7C\x98\xF4\xE8\xD1\xA3\x47 \x6F\xB1\x3C\xC7\x42\x6C\xC7\xB3\x50\x8E\x73\xE9\xE1\xAE\xF1\x04\xE2\xB6\xCC\xFB\x76\x29\x25\xC2\x81 \x30\x1C\xC7\x9D\xE6\x18\x36\xE9\x55\x96\xA7\x14\x10\x8D\x46\x61\xD9\x4E\xDE\xF7\x47\x2D\x89\xD1\x8B \xC1\x99\xF7\x3A\x0E\xA2\x3B\x9E\x01\x94\xCB\xFA\x42\x8F\x1E\x3D\x7A\xF4\x66\x35\x21\xC4\x4B\xD9\xB8 \x62\xC2\x3F\xE0\xF1\x00\x40\x21\xB8\x13\x6B\xDE\x09\x05\x87\x9D\x4D\x8F\x1E\x3D\x7A\xF4\x52\x9E\x79 \x64\x3F\xDC\x0B\x23\xB3\x9E\x92\x0A\x78\x7B\x38\xE6\x89\x91\x4A\x21\x1C\x0A\xC3\xB2\x6C\x86\x57\x7A \x15\xE5\x49\xA9\x10\x0D\x47\xE1\x3A\xAE\x27\xE3\xD8\x50\x14\x2A\x75\x46\xCB\xF4\xF5\xFF\xEE\xE8\x10 \x12\x47\x0E\xB0\xBE\xD0\xA3\x47\x8F\x1E\xBD\x99\xB7\x00\x56\x03\x8C\x3D\x99\x9E\x2B\x36\xFC\x03\x1E \x0E\x00\x14\x8A\x1F\xF8\xB5\xF7\x46\x14\x70\x88\x9D\x4D\x8F\x1E\x3D\x7A\xF4\x20\x5D\xC8\xE0\x14\x12 \x87\x77\xCD\x7E\x6E\xDA\x3B\xD4\x17\xF6\xCC\x49\xA9\x10\x0C\x84\x11\x8B\x26\x66\x2D\x1F\xC3\x2B\xBD \x72\x79\x8E\xED\x22\x1A\x8A\x64\x9D\xA7\x22\x53\xBB\x34\xE6\xE7\xCC\x70\x99\x78\x7D\x17\x64\x30\xC0 \xFA\x42\x8F\x1E\x3D\x7A\xF4\xA6\xDF\xA6\x0E\xEC\xB8\xEB\xCA\xCB\x7E\x29\x99\x4F\xF8\x07\xF2\x1C\x00 \x28\x16\x17\x50\x3B\xD8\xD9\xF4\xE8\xD1\xA3\x47\x0F\x50\x88\xEF\x7D\x71\xD6\xA9\xFF\xE9\xDE\xE9\xD1 \x38\x02\x71\xC7\x03\xA7\x20\xA5\x82\x02\x90\x48\x24\x10\x09\xC5\xA0\x14\x18\x5E\xE9\x95\xCD\x4B\x98 \x36\xA2\xD1\xA8\xD7\xBB\x55\x02\x00\x82\x31\x17\x67\xC6\x12\xC8\x78\x7B\x0B\xC7\x46\x7C\xFF\xCB\xAC \x2F\xF4\xE8\xD1\xA3\x47\x2F\xF9\xAA\x0C\xA7\xFF\xCF\x37\xFC\x03\x39\x0E\x00\xCC\x0B\x57\xDA\xCB\xEC\x6C\x7A\xF4\xE8\xD1\xA3\x67\x0F\x74\xC3\xEE\x39\x9D\xC6\xCE\xF6\x24\x80\xC3\xFD\x91\x3C\xDC\x4C\xF8 \x4F\x35\xDB\xB6\x11\x09\x47\x20\xA5\x2A\x62\xF1\x18\x5E\xE9\x15\xEF\x29\x05\x44\x23\x71\x98\xB1\x38 \x04\x0A\xF3\x0E\xF6\x87\x66\x4E\xFF\xCF\xD0\xEC\xEE\x93\x70\xFA\xCE\xB1\xBE\xD0\xA3\x47\x8F\x1E\x3D \x28\xC8\x59\x99\x7A\x21\xC2\x3F\x90\xE5\x00\xC0\x7C\x71\xD1\xB8\xEE\x4D\x00\x01\x76\x36\x3D\x7A\xF4 \xE8\xD5\xB1\x27\x25\x12\x7B\xB6\xA5\xB1\x99\xBD\x03\x3D\xE1\x1C\xDC\xE5\xE1\x3F\x75\xEB\x40\x25\x15 \x42\xC1\xE4\xBC\x00\xDE\x17\x8F\x61\x98\x5E\xF1\x9E\x94\x0A\xE1\x50\x14\x8E\x6D\x17\xEC\x29\xA5\xB0 \x3F\xC7\x58\x4F\x6D\x1F\xB1\x3D\xDB\x00\x57\x7A\x45\x59\xAF\xE8\xD1\xA3\x47\xAF\x06\x3D\xA5\xD4\xF8 \xBE\x03\x1D\xC7\x52\xFF\x5E\xA8\xF0\x0F\x64\x38\x00\xB0\x10\xF8\xEE\x8F\x0B\x47\x29\x6C\x67\x67\xD3 \xA3\x47\x8F\x5E\xFD\x7A\xE6\xB1\x43\x70\x27\xC7\xA7\xD9\xEC\xDE\x70\xD0\xC2\x99\xB1\x78\x06\x2E\x7B \xF8\x4F\x85\x2F\xA5\x14\x22\xE1\xE8\x9C\x79\x01\xB2\x2D\x1E\xC3\x30\xBD\xE2\x3D\xDB\x71\x11\x0A\x86 \xA1\xA4\x5B\x94\x77\x72\x34\x8E\xD1\x60\x96\x5B\x04\xA6\x79\x72\x72\x0C\xE6\xF1\x83\xAC\x2F\xF4\xE8 \xD1\xA3\x57\xC7\x9E\x80\xDA\x86\x2F\x09\x09\x2C\x6C\xF8\xC7\x1C\x64\x41\x71\x05\xF5\x73\x76\x36\x3D \x7A\xF4\xE8\xD5\xA7\x27\x63\x51\x24\xDE\xD8\x35\xCD\xE6\xF7\x76\x9E\x0D\xCE\xE1\xF2\x87\xFF\xF4\x96 \x48\x24\x10\x09\x47\x21\x95\xCA\xB2\x78\x0C\xC3\xF4\x8A\xF7\xE2\x71\x13\xD1\x60\x04\x02\x28\xDA\xDB \x79\x2E\x90\xF9\xC9\x0C\x5E\xFC\xE0\xAB\x50\xD1\x30\xEB\x0B\x3D\x7A\xF4\xE8\xD5\xA9\x27\x34\xFD\xE7 \xC0\xC2\x87\xFF\xAD\x5B\xB7\xCC\x40\x0B\x8D\x3B\x56\x62\xBB\x72\x1D\x87\x9D\x4D\x8F\x1E\x3D\x7A\xF5 \xE7\x25\x0E\xEC\x80\x32\x4D\xCF\xDE\xB1\xE1\x18\x26\x62\xCE\x34\x57\x58\xF8\x4F\x35\xCB\xB2\x11\x0A \x84\x61\xCF\xB9\x24\x80\x61\x98\x5E\xB1\x9E\x94\x0A\xE1\x60\x14\x89\x58\x02\x62\x1E\xDE\x58\xD8\xC2 \x3B\xC3\x97\x9F\xE5\x92\x75\xFB\xB0\x4C\xC4\x0F\xBE\xC2\xFA\x42\x8F\x1E\x3D\x7A\xF5\xE8\x29\x38\xF0 \xD9\xAF\x94\x22\xFC\x03\x30\xB4\xF4\x7F\x2C\x24\xDE\xFA\xAD\x3F\x0A\x01\xEA\x10\x3B\x9B\x1E\x3D\x7A \xF4\xEA\xCB\x73\x03\x93\xB0\x4E\x1F\x2F\xC8\x93\x52\x61\xF7\xB9\x50\xD1\xE1\x7F\xC6\x91\x08\x87\xA3 \x88\x45\x62\x50\x4A\x31\x0C\xD3\x2B\xDA\xB3\x2C\x07\xC1\x60\x18\x8E\xE3\x78\x1E\x7F\x99\x3C\x29\x15 \x76\x4D\x8F\xED\x59\x2D\x8F\x67\xBD\x7B\x04\x32\x30\xC1\xFA\x42\x8F\x1E\x3D\x7A\x75\xE7\xA9\x3D\xBE \x7F\xFA\x6F\x01\x94\x20\xFC\x03\xD0\xB4\x52\x1D\x59\x00\xA0\x09\xD7\x79\x81\x9D\x4D\x8F\x1E\x3D\x7A \xF5\xE5\x99\x6F\xEE\x05\x94\x2C\x98\xDB\xDB\x15\x44\xCC\x72\x8B\x0E\xFF\xE9\x2D\x61\x5A\x08\x06\x43 \xB0\x2C\x07\x0C\xC3\xF4\x0A\xF1\x94\x52\x88\x44\x62\x88\x84\xA3\x80\x54\xF3\x0E\xFF\x31\x4B\x5E\x3E \xD1\xA5\x17\x4F\x49\x24\xDE\xD8\xCD\xFA\x42\x8F\x1E\x3D\x7A\x75\xE6\x49\xA8\x9F\xA3\x44\xF9\x1C\xD3 \xFF\x57\x32\x5C\x45\x82\xDB\xD8\xD9\xF4\xE8\xD1\xA3\x57\x3F\x9E\x3B\x39\x0E\xEB\xCC\xF1\xA2\xBC\x88 \xE9\x62\xD7\xB9\x50\xFA\xD2\xCD\x2B\x7C\xD9\x96\x8B\x60\x28\x8C\x44\xC2\xBC\x24\x32\x0C\xD3\xCB\xE5 \x39\x8E\x83\x60\x20\x0C\xCB\xB4\xE7\x3D\xFE\x52\x67\xB2\xBC\x76\x2E\x80\x98\x9D\x76\x40\xAC\x00\xCF\x3A\x7D\x14\x72\x62\x8C\xF5\x85\x1E\x3D\x7A\xF4\xEA\xC8\xD3\x82\x17\xB7\xA3\x44\xF9\x1C\xD3\xFF\x51 \x32\xBC\xE1\xC1\xBF\x3E\xA9\x34\xBD\x8B\x9D\x4D\x8F\x1E\x3D\x7A\x35\xEE\xB9\x0A\xF1\xD7\x77\x22\xFC \xE4\x77\xA7\x9F\x2B\xD0\x9B\x6E\xAF\x9C\x09\x22\xE1\xC8\x05\x0B\x5F\x50\x40\x2C\x9A\x40\x38\x14\x85 \x80\x62\x18\xA6\x97\xD9\x73\x15\xE2\xF1\x04\x42\xC1\x08\xA4\x5C\xB8\xF1\x97\xB0\x25\x76\x9E\x0D\xA5 \x2D\x66\x81\x9E\x2B\x11\x7A\xFC\xDF\x61\x1D\x3F\xC4\x7A\x45\x8F\x1E\x3D\x7A\xF5\xE0\xB9\xF6\x59\xFF \x0F\xBE\xD0\x93\xF6\xE8\x82\xE6\x73\x00\x52\x2B\x25\x0E\xC0\x01\xD4\x36\x76\x36\x3D\x7A\xF4\xE8\xD5 \xAE\xE7\x8E\x8D\x20\xF8\xC8\xD7\x11\xDB\xFD\x0B\xC0\x2E\x3E\xFC\x03\x40\xC4\x74\xB1\xFB\x5C\x68\x61 \xC2\xFF\xCC\xDA\x42\xBA\x2E\x42\xC1\x08\xCC\x84\x09\x55\xA0\xC7\x70\x5D\xDB\x9E\x69\xDA\x08\x86\x42 \x88\xC7\x12\x97\xC6\xCB\x42\x8D\xBF\x9D\xE7\x82\x88\x5A\xD3\xBF\xFE\x17\xBB\xBD\xD9\x0E\x22\xDB\x1E \x43\xEC\xB5\x9F\x4F\x6F\x2F\xAC\x57\xF4\xE8\xD1\xA3\x57\xAB\x9E\x92\x32\x3D\x3B\x97\x24\x9F\x6B\xA5 \xC4\x5F\x79\x65\x17\x20\xF0\x02\x3B\x9B\x1E\x3D\x7A\xF4\x6A\xD0\x93\x12\xF1\x3D\xDB\x11\x78\xF8\xDF \xE0\x5C\x18\x84\xE6\x6B\x48\xA6\xA7\x42\xBC\x0C\xED\x95\x33\x41\x98\xAE\x2A\x62\xF1\x72\x4F\x20\xA8 \x94\x42\x34\x1A\x47\x68\x7A\x62\x37\x2F\x1E\xC3\x75\xED\x7A\xAE\xEB\x22\x14\x8A\x20\x14\x8A\xC0\x75 \xE4\x65\xE3\x65\xBE\xE3\x2F\x61\x4B\xEC\x3C\x33\x7D\x7B\xCB\x62\xB7\xB7\xD4\x5A\x1A\x0D\x88\xBF\xFE \x2A\xC2\x3F\x7B\x18\x70\x5D\xD6\x2B\x7A\xF4\xE8\xD1\xAB\x51\x4F\x33\x13\xA9\xEC\x5C\xB2\x7C\xAE\x95 \x12\x07\x80\x89\x60\x78\x17\xA0\x22\xEC\x6C\x7A\xF4\xE8\xD1\xAB\x1D\xCF\x9D\x1A\x47\xF0\xD1\x6F\x22 \x76\x60\x3B\xE0\x2A\x08\xA1\x41\xE8\xFE\xC2\xBC\x2C\x2D\x62\x49\xBC\x96\x7E\xDA\xB4\x27\xCE\xFB\xDD \x03\x5C\x27\x79\x36\x40\x34\x12\xBD\x7C\x66\xF6\x34\x8F\xE1\xBA\x76\xBD\x44\xC2\xC4\xD4\x64\x08\xA6 \x69\xE7\x1D\x2F\xC5\x8E\xBF\x9D\x67\xA7\x7F\xFD\x9F\x67\xF8\x07\x00\x61\xF8\x00\x21\x60\x9D\x3E\x86 \xC0\x23\x5F\x83\x3B\x3E\xCA\x7A\x45\x8F\x1E\x3D\x7A\x35\xE6\x29\x89\x90\x7B\xFC\xC9\x03\x28\x71\x3E \xD7\x4A\x89\x03\xC0\xC9\xDF\xBE\xC1\x02\xF0\x32\x3B\x9B\x1E\x3D\x7A\xF4\x6A\xC3\x33\x4F\xBC\x81\xE0 \x8F\xBE\x02\x67\xA4\x1F\xA9\x9F\xFC\x85\xCF\xE7\xFD\xD7\xFF\x1C\xE1\x3F\xB5\x7C\xDB\x4E\x4E\x21\x98 \x70\x3D\x72\xC5\xDD\x3A\xD0\x34\x6D\x04\xA6\x42\x48\x98\xD6\x65\x1E\xC3\x75\x6D\x7A\x8E\xEB\x22\x18 \x08\x21\x1C\x8A\x42\xA6\xFF\xC2\x8E\x85\x0D\xFF\x61\xD3\xC1\x2B\x67\x83\x0B\x12\xFE\x53\x4B\xA8\xF9 \x1A\x00\x08\xB8\x17\x86\x11\x7C\xE0\xCB\x48\x1C\x7E\x2D\xF7\xB6\xC4\x7A\x45\x8F\x1E\x3D\x7A\x55\xE5 \x09\x25\xB7\x37\x1E\xD8\x67\xA1\xC4\xF9\x5C\x2B\x25\x7E\x69\xDD\x92\xB7\x32\x60\x67\xD3\xA3\x47\x8F \x5E\x15\x7B\x2A\x91\x40\xE4\xF9\x47\x10\xF9\xC5\x4F\xA0\x2C\x13\x97\x12\xBF\x00\x60\x34\x78\xF7\xB2 \xB5\xB4\xE5\x4B\xD8\x12\x3F\x3B\x3E\xE9\x81\x2B\x2E\xFC\xA7\xBF\x3F\x16\x89\x21\x1C\x8A\xC0\x75\x25 \xC3\x75\x8D\x7A\x4A\x26\x2F\xFF\x08\x4E\x25\x6F\x0D\xB9\x10\xB7\x9A\xCC\x35\xFE\x9E\x3B\x1E\x40\xDC \x2E\xFC\x32\x96\x5C\xDB\x87\x30\xFC\x97\x36\x39\xE5\xD8\x88\xEE\x78\x06\xA1\x27\xBE\x03\x19\x0E\xB2\x5E\xD1\xA3\x47\x8F\x5E\x0D\x78\x52\xB9\x2F\xA0\xC4\xE1\x1F\x73\x5E\xB0\xE0\xF8\xA5\x3F\xE2\x97\xCF \x29\xC0\x62\x67\xD3\xA3\x47\x8F\x5E\x75\x7A\x76\xDF\x59\x04\x7E\xF8\x2F\x30\x4F\x1E\x99\x71\x53\xFF \xA5\x1B\xDE\xC2\x93\xC7\xF0\x9F\x6A\xFB\xBB\x43\xE8\x9B\x30\x73\x70\xF3\x0B\xFF\xE9\xCD\xB6\x1D\x04 \xA6\x82\x08\x85\x22\x50\x92\xE1\xBA\x96\xBC\x84\x69\x21\x10\x0C\x21\x11\x4F\x2C\xD8\x78\xC9\x35\xFE \x06\x83\x16\x0E\xF5\x86\x8B\xDB\xDE\x72\x6D\x1F\x42\x83\xD0\x7C\xB3\xC7\x6D\xCF\x69\x04\x7E\xF8\xCF \xB0\xCE\xBD\xC3\x7A\x45\x8F\x1E\x3D\x7A\xD5\xEC\x29\xE1\xC0\x51\xCF\x2F\xC6\x8F\xF3\x5A\x29\xF1\x54 \xDB\xFD\xF1\xCE\x00\x80\x3D\xEC\x6C\x7A\xF4\xE8\xD1\xAB\x32\xCF\x75\x11\xDF\xBB\x1D\xA1\x27\xEF\x83 \x8C\x04\x66\xDC\xF4\xBF\xA2\x37\x78\xF3\xB2\xB5\x2C\xCB\x27\x01\x3C\x71\x64\x3C\xE3\x75\xFA\x0B\x19 \xFE\xD3\x3D\xD3\xB4\x31\x15\x08\x22\x16\x35\xA1\x14\x18\xAE\xAB\xD8\xB3\xAC\xE4\x25\x1E\xB1\x48\x0C \xD2\x95\x8B\x12\xFE\x85\x00\x9E\x3C\x32\x01\x59\xCC\xF6\xE6\x61\xFB\x10\xC6\xE5\xF3\x6C\xA8\x58\x04 \xE1\x9F\x7E\x1F\x91\x9F\x3D\x02\x65\x9B\xAC\x7F\xF4\xE8\xD1\xA3\x57\x85\x9E\xD2\xB4\x97\xF7\x7D\xEE \xDA\x40\xA1\x5C\x51\x3F\xCE\x97\x12\x9F\xD3\x9E\x62\x67\xD3\xA3\x47\x8F\x5E\xF5\x78\xEE\xF8\x28\x82 \x8F\x7C\x0D\xB1\xFD\xDB\xD3\x02\xCA\x1C\x4F\x68\x10\x86\x91\xDF\xCB\xD6\xF2\x2C\x5F\xF7\x78\x02\x6F \xF4\x47\xE7\x70\xAA\xB4\x61\x4E\x01\x66\x22\x81\x70\x30\x0C\xD3\x34\xB3\x4E\x14\x98\xCB\x63\x58\x2F \x9F\x67\x5B\x36\x42\x81\x30\x22\xE1\x28\xA4\x94\xA5\x1F\x2F\x69\xDE\xEB\xFD\x51\x74\x5D\x4C\x14\xBE \xBD\x79\xDC\x3E\x84\x61\x00\x22\xF3\xAE\x9B\x79\xE2\x30\x82\x0F\x7C\x05\xCE\xF9\x7E\xD6\x3F\x7A\xF4 \xE8\xD1\xAB\x32\x4F\x08\xF1\x4C\xA1\x5C\xB1\xF9\x5C\x2B\x25\x9E\xDE\x7C\xBA\xF9\x9C\x82\x92\xEC\x6C \x7A\xF4\xE8\xD1\xAB\x70\xCF\x75\x90\x38\x76\x00\xC1\x87\xBF\x06\xE7\xC2\xD0\x6C\x77\x4E\xCB\xF4\x8B \xE4\x65\x5E\xB6\xE6\x71\xF9\x9E\x3A\x36\x01\xD3\x49\x7D\x7D\x2C\x5E\x98\x03\x80\x58\x34\x81\x40\x20 \x84\x44\x22\x01\xE5\xD1\x63\x58\x2F\x8F\xE7\xD8\x36\x42\xC1\x30\xC2\xE1\x28\x1C\xD7\x5D\xF4\xF1\x62 \x39\x0A\xCF\x1C\x9F\x28\x7C\x7B\x2B\x70\xFB\xD0\x72\x6C\x73\xEE\xC4\x79\x04\x1F\xFE\x37\xC4\xF7\xBE \x38\xFB\xA0\x1D\xEB\x1F\x3D\x7A\xF4\xE8\x55\xAC\xA7\x00\x07\x0D\xFA\xF3\x85\x70\xF3\xC9\xE7\x5A\x29 \xF1\xF4\xB6\x73\xEB\xE6\x31\xA1\xB0\x8F\x9D\x4D\x8F\x1E\x3D\x7A\x95\xEB\xA9\x70\x00\xA1\x67\x7E\x80 \xE8\xF6\x27\x67\x4E\x27\x4E\xB9\x19\x9A\xE6\xF3\xE5\x5E\xBE\x6C\xAD\x80\xE5\x0B\xC4\x1D\xFC\xEC\x9D \xC9\x45\x0D\x73\xE9\x9E\x92\x0A\xB1\x68\x02\xC1\xA9\x10\x12\x71\x93\xB7\x0E\xAC\x24\x4F\x01\xA6\x69 \x21\x14\x0C\x23\x14\x8A\xC2\x71\xDC\x82\xFB\x77\xA1\xC6\xCB\xB3\xC7\x27\x11\x8C\xB9\x85\x80\xC5\x6D \x1F\xBE\x6C\x07\x00\xA6\x3D\x57\x22\xB6\x7F\x3B\x42\x4F\xDC\x97\x9C\x20\x90\xF5\x8F\x1E\x3D\x7A\xF4 \x2A\xDB\x13\xD8\xB5\xE7\xE3\xEB\xC6\xBD\x72\xF3\xCD\xE7\x5A\x29\xF1\x0C\x6B\xFF\x0C\x3B\x9B\x1E\x3D \x7A\xF4\x2A\xD3\xB3\xBB\xDE\x45\xE0\xC1\x7F\x85\xDD\xF5\xEE\x9C\x27\xB3\x78\x9A\x9E\xF5\x74\xE4\x85 \x0A\xFF\xA9\xF6\xEA\xA9\x00\x4E\x8F\xC6\x17\x3D\xFC\xA7\x37\x29\x25\x62\xB1\x38\x02\x53\x21\xC4\xA3\x71\xC8\xB4\xC9\x02\x19\xD6\x17\xD7\x53\x0A\x48\x24\x4C\x04\x02\x21\x44\x23\xB1\x59\xC1\xBF\xD8\xFE \x9D\xCF\x78\x39\x7D\x21\x8E\xD7\xCE\x85\x0A\xDB\x7E\x8B\xDC\x3E\x84\x10\x10\xDA\xDC\xCB\x6E\x2E\xF7 \xEC\xFE\xB3\x08\xFC\xE0\x9F\x61\x9E\x7C\x8B\xF5\x8F\x1E\x3D\x7A\xF4\x2A\xD9\x93\x9A\xE7\xD3\xFF\x17 \x22\x9F\x6B\xA5\xC4\xE7\x7A\xC6\xE4\xD0\xF3\xA9\xAB\x00\xD8\xD9\xF4\xE8\xD1\xA3\x57\x19\x9E\xB2\x2D \x44\x5F\x7A\x0A\xA1\xA7\xBE\x07\x19\x9D\x1B\x62\xB2\x7B\x59\x4F\xFF\x5F\xE0\xF0\x0F\xA5\x20\x01\x3C \x7C\x78\x0C\x89\xE9\x4B\x01\x16\x3B\xFC\xCF\x7D\x7F\x3C\x61\x22\x38\x15\x44\x38\x1C\x85\x6D\x59\x0C \xEB\x8B\xE4\xB9\x52\x4E\x5F\x96\x11\x44\x2C\x1A\x87\x94\x72\xC1\xFB\xB7\x50\xCF\x74\x24\x7E\x7C\xF8 \xA2\xF7\xB9\x22\x16\x60\xFB\x98\x3D\xEF\x46\x76\x4F\x59\x26\x22\xCF\x3D\x94\x9C\x20\xD0\x4A\x78\x5F \x3E\xD6\x53\x7A\xF4\xE8\xD1\x5B\x24\x4F\x49\xC0\x79\xCE\x0B\xB7\x50\xF9\x5C\x2F\x25\x3E\xD7\x13\x47 \x77\x46\xDC\xDB\x3F\x73\x17\x84\x58\xC7\xCE\xA6\x47\x8F\x1E\xBD\xF2\x7B\xCE\xD8\x08\xC2\x4F\x7C\x07 \x76\xD7\x89\x0C\xCF\xE6\xF6\x74\x7F\xD3\xE5\x7F\xB3\x04\xE1\x3F\xD5\xE2\xB6\x44\xCC\x72\x71\xD3\xDA \x96\xB2\x85\xFF\xB9\xCD\x75\x5C\xC4\xE3\x16\x2C\xCB\x06\x84\x80\xAE\xEB\x10\x82\x61\x7D\x41\x3D\x05 \x58\xB6\x8D\x58\x34\x8E\x58\x34\x0E\xC7\x71\xB2\x66\xDE\x72\x5C\x26\xF2\xD8\x9B\xE3\x38\x75\x21\x5E \xF0\x78\x9E\xCF\xF6\x21\x34\x0D\xCA\xB6\x80\x9C\x33\x53\xCC\x78\xEE\xD8\x30\xAC\x77\xDF\x84\x7E\xE5 \x7A\xE8\x57\x2C\x67\xFD\xA3\x47\x8F\x1E\xBD\x4A\xF1\x14\xF6\xEE\xBD\x67\xFD\xBF\xE7\xE3\x16\x32\x9F \x6B\xA5\xC4\x33\x7A\xD2\xFD\x0F\x76\x36\x3D\x7A\xF4\xE8\x95\xD9\x53\x0A\x89\xD7\x77\x22\xF4\xE0\x97 \xE1\x5E\x1C\xC9\xF0\x82\x3C\x9E\xA6\x03\x9A\x76\xF9\xF2\x65\x6B\xF3\x0C\xFF\xA9\xB6\xAF\x27\x82\x77 \x2F\xC4\x2B\x22\xFC\xA7\x7B\xAE\xEB\x22\x16\x89\x21\x38\x15\x42\x3C\x1A\x83\xEB\x38\x45\x79\x0C\xFF \x33\x9E\xEB\x4E\xFF\xDA\x3F\x15\x44\x24\x1C\x85\x6D\x3B\x65\xEB\xDF\x6C\xDE\xC9\xD1\x18\xF6\xF5\x84 \x8B\x1E\xCF\x45\x6F\x1F\x42\xBB\x7C\xFB\xCB\xB3\xFD\xBA\xC1\x49\x84\x1E\xFD\x26\x62\x3B\x7F\x06\xB8 \x92\xF5\x94\x1E\x3D\x7A\xF4\x2A\xC1\xF3\x30\xFB\xFF\x42\xE7\x73\xAD\x94\x78\x46\x2F\x3A\xF9\x34\x3B \x9B\x1E\x3D\x7A\xF4\xCA\xE7\xC9\x68\x08\xE1\xC7\xBF\x8B\xE8\x2B\xCF\x40\xB9\x99\x42\x55\x7E\x4F\x18 \xBE\xCB\x97\x2F\xEB\x8B\x17\x26\xFC\x27\x1F\x56\x78\xE4\x8D\x8B\x88\x5A\xB2\x40\x4E\x2D\xDA\x7D\xE0 \x6D\xDB\x41\x28\x14\x4D\xDE\x83\x3E\x96\xB8\x34\x23\x7D\x3E\x8F\xE1\x5F\x40\x40\xC1\x4C\x58\x08\x05 \x23\x08\x4E\xDF\x7D\x41\x7A\x38\xB5\xBE\x1C\xE1\x3F\x66\x4B\x3C\xF4\xBA\xC7\x53\xFF\x4B\xB0\x7D\x5C \xB6\x0D\x7A\xD9\x7E\xA5\x8B\xF8\xC1\x1D\x08\xFE\xF8\x6B\x70\xA7\x2E\xB2\x9E\xD2\xA3\x47\x8F\x5E\x39 \x3D\xA5\xE0\x6A\x5A\xCE\xD3\xFF\x4B\x91\xCF\xF5\x52\xE2\x99\x3C\xFD\xE8\xAB\xE3\xEE\x47\x7F\xFD\x73 \x80\x58\xCD\xC1\x43\x8F\x1E\x3D\x7A\x8B\xEB\x59\xA7\x8F\x21\xFC\xF8\x77\xE0\x8C\x8F\x64\x79\x85\x37 \x4F\xF3\x37\xA5\x9D\xA2\xBD\x38\xE1\x3F\xE5\x99\xB6\x42\x20\xEE\xE2\x03\xED\x2D\x1E\xB9\x32\xDD\x3D \x40\x29\x38\x8E\x03\x33\x91\xBC\x44\x40\x29\x05\xA1\x09\x68\x73\x7E\xB9\xAD\xF7\xF0\xEF\x4A\x05\xCB\xB4\x61\xC6\x4D\xC4\xE3\x09\xD8\xB6\x93\xF1\xDA\xFE\x4A\xEB\xDF\x47\x0E\x8F\xA1\xEB\x62\xC2\x0B\x58 \xA2\xED\x43\x40\x39\x56\x51\xDB\xAF\x0C\x07\x60\xBE\xFD\x3A\x44\x73\x0B\x8C\x35\xED\xAC\xA7\xF4\xE8 \xD1\xA3\x57\x1E\xEF\xF0\xBE\xBB\xDA\xBF\x9A\x8D\x2B\x55\x3E\xD7\x4A\x89\x67\xF5\x94\x7A\x92\x83\x87 \x1E\x3D\x7A\xF4\x16\xCF\x53\x56\x02\xD1\x6D\x8F\x23\xFC\xCC\x0F\x20\x13\xD1\x2C\xAF\xF2\xE8\x69\x1A \x44\x2A\xC4\x2E\x72\xF8\x4F\xB5\x43\x7D\x61\xEC\xEF\x09\x79\xE0\xCA\x13\x0E\xE7\x36\xD7\x75\x11\x8F \x25\x10\x0A\x84\x11\x9C\x0A\x21\x16\x8D\xC3\xB6\x6D\x48\x29\xEB\x2E\xFC\x3B\x52\xC1\xB1\x1D\xC4\x62 \x09\x84\x02\x11\x84\xA6\x42\x30\xE3\x09\xB8\xAE\xBB\x68\xFD\x31\x5F\x6F\x7F\x4F\x08\x87\xFA\x22\x0B \x36\x9E\x8B\xD9\x3E\xC4\x65\x77\xE1\x28\xCC\x4B\xD6\x84\xC7\x10\x7E\xF6\x87\x50\xF1\x18\xEB\x29\x3D \x7A\xF4\xE8\x2D\xB2\xA7\x80\xA7\xB2\x71\xA5\xCC\xE7\xC6\xA2\x87\x7F\x00\x52\xC7\x13\x0F\x3C\xC6\x13 \x00\x00\x20\x00\x49\x44\x41\x54\x9A\xAB\xFE\xC9\xD3\x87\xCB\xC1\x43\x8F\x1E\x3D\x7A\xF3\xF2\x9C\x91 \x7E\x44\x9E\x7B\x08\xEE\xD4\x58\x8E\x57\x15\x30\x01\x99\x6E\xCC\x2C\x5F\xD6\x17\x95\x2E\xFC\xA7\xDA \x4F\xDE\x1C\x47\xC7\x8A\x46\xB4\x2F\xF3\x67\xE1\x2A\x23\xFC\xCF\x6D\xAE\x94\x70\x13\xC9\x5F\xBB\x95 \x54\xD0\x7D\x06\x74\xDD\x80\xDF\xAF\xC3\xF0\xF9\x6A\x32\xFC\x4B\x29\x61\x5A\x36\xCC\x84\x05\xDB\x71 \xA0\xA6\x6F\xA1\x58\x09\xFD\x51\xA8\x37\x1C\xB0\xF0\xD8\x9B\xE3\x5E\xC0\x92\x6F\x1F\x42\x37\xA6\xCF \x02\x28\xC2\x9B\x5E\x53\xEB\xF4\x31\x04\x86\xFB\xD1\xFA\xE9\xDF\x85\xAF\xE3\x2A\xD6\x53\x7A\xF4\xE8 \xD1\x5B\x14\x4F\x49\x4D\x8A\x27\x32\x3D\x53\xEA\x7C\x2E\xB6\x6E\xDD\xB2\xA8\xE1\x3F\xD5\xEE\xD8\x3E \x70\x50\x08\x71\x3B\x07\x0F\x3D\x7A\xF4\xE8\x95\xC8\x93\x2E\xE2\xAF\xEF\x44\x6C\xF7\xCF\x81\x9C\xBF \xAE\x16\xB6\x7C\x5A\x43\xF3\xCC\x41\x80\x8C\x5C\xE9\xC3\x7F\xAA\xAD\x5A\xE2\xC3\x17\xEF\x6A\x43\xA3 \xEF\xF2\xD3\xEA\x2B\x31\xFC\xE7\xF3\x74\x5D\xC0\xE7\xF3\xC3\x30\x34\xE8\x3E\x03\x86\x61\x40\xF3\x78 \x6B\xC2\x4A\x09\xFF\x52\x29\xB8\x8E\x03\xC7\x71\xE1\x3A\xEE\xA5\x53\xFA\xAB\xB1\x3F\xE6\x7A\xA6\x2D \xF1\x4F\x2F\x0F\xE1\x7C\xC8\x2E\xC9\x78\x2E\xD4\x53\x8E\x0D\x69\xC5\x51\x04\x98\x71\xB9\x1A\x6F\xFD \x65\xB4\x6C\xFD\x1C\xA0\xEB\xAC\xA7\xF4\xE8\xD1\xA3\x57\x42\x4F\x41\xED\xDA\x7B\x57\xC7\xC7\xE7\x3E \xBE\x18\x3F\xCE\x97\x25\xFC\x03\x80\x10\xE2\x71\x00\xB7\x73\xF0\xD0\xA3\x47\x8F\xDE\xC2\x7B\x6E\x68 \x12\xD1\xE7\x1E\x86\x3D\xD8\x0D\xAF\xB7\x0A\xF3\xDA\x44\xAE\xD9\xC7\x17\x31\xFC\x03\xC0\x58\xD8\xC6 \x8F\x5E\x1F\xC3\x9F\x7C\x74\xF5\xA5\xA0\x56\xAD\xE1\x5F\xD3\x04\x00\x01\xDB\xB6\x61\xDB\x00\xE2\x26 \x30\xFD\xB8\xAE\x1B\xD0\x75\x3D\x79\x60\x40\xD7\xA1\xE9\xDA\xAC\xF5\x2D\x47\xF8\x4F\xDD\xFD\x40\xBA \x12\xEE\x74\xD8\x77\x5C\xF7\xB2\xEB\xF7\xAB\xB9\x3F\xE6\xCE\xE9\xF0\xC0\xA1\xB1\x8A\x09\xFF\xC0\xF4 \x64\x9C\x05\x1F\x00\xC8\x7A\x0F\x45\x24\xDE\xDC\x0D\x7B\xE0\x1C\x96\x7C\xF6\xBF\x42\x5F\xB5\x96\xF5 \x94\x1E\x3D\x7A\xF4\x4A\xE4\x09\x88\xC7\xE7\x3E\xB6\x58\x67\xE6\x1B\xA5\xC4\x73\x79\x36\x8C\x27\x0C \x65\x7F\x55\x08\x61\x70\xF0\xD0\xA3\x47\x8F\xDE\xC2\x79\xE6\xA9\x23\x88\x6E\x7B\x1C\x2A\x11\xC7\xC2\x87\x7F\x31\xE7\xBA\xE3\xF4\x27\x17\x37\xFC\xA7\xDA\x91\xC1\x28\x7E\x71\x22\x80\x4F\xDF\xB8\xBC\x66 \xC2\x66\x7A\x93\x52\x41\x4A\x1B\xB6\x3D\x3B\x78\x6A\x42\x24\x0F\xC6\x08\x01\xA1\x09\xE8\xD3\x73\x33 \x08\x21\xE0\x33\x34\xA8\xE9\x79\x7E\x45\x81\xCB\xE7\xB8\x12\x6A\xFA\xBF\x95\x2B\x21\x95\x82\x80\x82 \xAD\xD4\xA5\x5F\xF2\x5D\x47\x42\x2A\x59\x15\x9F\xDF\x42\x79\xCF\xBF\x33\x85\xA3\x43\xD1\x92\x8F\xE7 \x82\x3D\xA1\x01\xCA\xEB\xA4\x89\xF9\xEB\x81\x3B\x36\x82\xC0\x43\x5F\x41\xCB\x96\xCF\xA0\xF1\x83\x5B \x72\x2F\x37\xEB\x33\x3D\x7A\xF4\xE8\x15\xEE\x29\x38\x3E\x5D\x3C\x9D\xFE\xD0\x62\x5E\x96\x6F\x94\x12 \xCF\xE5\x1D\xBC\xEB\xCA\xB1\x3B\xB7\x0F\xEE\x04\xF0\x49\x0E\x1E\x7A\xF4\xE8\xD1\x9B\xBF\xA7\xCC\x04 \xA2\xDB\x9F\x84\x79\xE2\x8D\xD4\x23\x39\x5E\x5D\xE4\x35\xC3\x5A\x96\x5B\x8F\x95\x29\xFC\xA7\xDA\xCF \xDF\x9D\xC2\x9A\xA5\x06\x3E\xD0\xD6\x52\x53\xE1\x3F\x57\x73\xA5\x84\x74\x5C\x4F\x9E\x26\x92\x8F\xA9 \xB4\x7F\x03\xB8\x74\x8B\x3D\x81\xE4\x75\xFA\x8E\x94\xB3\xBA\xA5\x96\x3F\xBF\x42\xBC\x23\x83\x51\xBC \x70\x32\xB0\x68\xE3\xB9\x10\x6F\x66\x1E\x00\x0F\xDB\xAF\xD7\x7A\x60\xDB\x88\xEE\x78\x06\x56\xCF\x49 \xB4\xFE\xEA\xE7\xA1\xB5\x2E\xAD\xBB\x7A\x4A\x8F\x1E\x3D\x7A\xA5\xF2\x14\xB0\xED\xD5\x4F\xB4\x4D\xA6 \xFE\xBD\xD8\x73\xF2\x69\x28\x43\xF8\x9F\x79\xA1\xF8\x09\x07\x0F\x3D\x7A\xF4\xE8\xCD\xDF\xB3\xFB\xCF \x22\xF0\xFD\xFF\x53\xDA\xF0\x0F\x64\xBE\xF6\xBF\xCC\xE1\x1F\x00\x94\x94\x78\xF8\xF0\x45\x0C\x06\xCC \x59\x6B\xC9\xF0\x9A\x6C\x52\xA9\xE4\x01\x83\xE9\xFF\x39\xEE\xCC\xE9\xFA\x33\xFF\x66\xF8\xCF\xE4\x0D \x4C\x99\x78\xF0\xD0\x18\x54\xAE\x31\x5B\xC6\x09\x31\x85\x61\x78\xDE\x7E\x0B\xAD\x07\x76\xF7\x29\x04 \x7E\xF8\xCF\xB0\xCF\x9D\xA8\xAB\x7A\x4A\x8F\x1E\x3D\x7A\xA5\xF4\x94\x50\x97\x4E\xFF\x2F\xC7\x84\xFC \x1A\xCA\x14\xFE\x01\x40\x26\x1A\x9E\x85\x42\x82\x83\x87\x1E\x3D\x7A\xF4\x8A\xF4\xA4\x8B\xF8\x9E\x6D \x08\xFD"