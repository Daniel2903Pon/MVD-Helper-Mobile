-- The ini file config library.
-- 
-- This file is part of SA MoonLoader package.
-- Licensed under the MIT License.
-- Copyright (c) 2019, BlastHack Team <blast.hk>
--
-- Modified by Monetloader for Linux support

local inicfg = {}

local PATH_SEPARATOR = '/'
if MONET_VERSION == nil then
    PATH_SEPARATOR = '\\'
end

CONFIG_PATH_SEP = PATH_SEPARATOR .. 'config' .. PATH_SEPARATOR

local function find_config(file)
    local workdir = getWorkingDirectory()
    local paths = {
        workdir..CONFIG_PATH_SEP..file..'.ini',
        workdir..CONFIG_PATH_SEP..file,
        file,
    }
    for _, path in ipairs(paths) do
        if doesFileExist(path) then
            return path
        end
    end
    return nil
end

local function ini_value(val)
    local lwr = val:lower()
    if lwr == 'true' then return true end
    if lwr == 'false' then return false end
    return tonumber(val) or val
end

function inicfg.load(default, file)
    local file = file or (script.this.filename..'.ini')
    file:gsub('\\', PATH_SEPARATOR)
    if MONET_VERSION ~= nil then
        file:gsub('moonloader/', 'monetloader/')
    end
    local path = find_config(file)
    if not path then return default end
    path:gsub('\\', PATH_SEPARATOR)
    if MONET_VERSION ~= nil then
        path:gsub('moonloader/', 'monetloader/')
    end

    local f = io.open(path, 'r')
    if not f then return nil end
    local data = default or {}
    local cursec
    for line in f:lines() do
        local secname = string.match(line, '^%s*%[([^%[%]]+)%]%s*$')
        if secname then
            local section = tonumber(secname) or secname
            if data[section] then
                cursec = data[section]
            else
                cursec = {}
                data[section] = cursec
            end
        else
            local key, value = line:match('^%s*([^=%s]+)%s-=%s*(.*)$')
            if key and value then
                if not cursec then
                    error('parameter out of section')
                end
                cursec[ini_value(key)] = ini_value(value)
            end
        end
    end
	f:close()
    return data
end

function inicfg.save(data, file)
	assert(type(data) == 'table')
    local file = file or (script.this.filename..'.ini')
    file:gsub('\\', PATH_SEPARATOR)
    if MONET_VERSION ~= nil then
        file:gsub('moonloader/', 'monetloader/')
    end
    local path = find_config(file)
    local dir
    if not path then
        if file:match('^%a:[\\/]') then
            dir = file:match('(.+[\\/]).-')
            path = file
        else
            if file:sub(-4):lower() ~= '.ini' then
                file = file..'.ini'
            end
            dir = getWorkingDirectory()..CONFIG_PATH_SEP
            path = dir..file
        end
    end
    path:gsub('\\', PATH_SEPARATOR)
    if MONET_VERSION ~= nil then
        path:gsub('moonloader/', 'monetloader/')
    end
    if dir and not doesDirectoryExist(dir) then
        createDirectory(dir)
    end
    local f = io.open(path, 'w')
    if f then
        for secname, secdata in pairs(data) do
            assert(type(secdata) == 'table')
            f:write('['..tostring(secname)..']\n')
            for key, value in pairs(secdata) do
                f:write(tostring(key)..' = '..tostring(value)..'\n')
            end
            f:write('\n')
        end
		f:close()
        return true
    end
    return false
end

return inicfg
