Object = require("libraries.general.classic")
Input = require("libraries.boipushy.input")
Timer = require("libraries.hump.timer")
Camera = require("libraries.general.Camera")
Utils = require("libraries.general.utils")
Physics = require("libraries.windfield")
Json = require("libraries.general.json")

function writeSaveData()
    local info = {
        savestate = SaveState or {},
        gamestate = GameState or {},
    }
    local encoded = Json.encode(info, { indent = true })
    love.filesystem.write('GameSave.json', encoded)
end

function savestate()
    SaveState = {
        PX = PlayerX,
        PY = PlayerY,
        Room = currentRoom,
    }
    writeSaveData()
end

function gamestate()
    GameState = {
        Day = Day,
        Time = Time,
    }
    writeSaveData()
end

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    math.randomseed(os.time())

    ATDoorlock, TDoorlock, RDoorlock = false, false, false
    timelist = {'rollcall', 'int', 'restperiod', 'night'}


    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)
    
    local object_files = {}
    recursiveEnumerate('objects/OS', object_files)
    requireFiles(object_files)

    local object_files = {}
    recursiveEnumerate('objects/Stage', object_files)
    requireFiles(object_files)
    
    local object_files = {}
    recursiveEnumerate('objects/Folders', object_files)
    requireFiles(object_files)

    timer = Timer()
    input = Input() 
    camera = Camera()
    camera:setFollowLerp(0.1) 

    paused = false 

    current_room = nil
    --resize(0.625)
    
    local filename = 'GameSave.json'
    
    if love.filesystem.getInfo(filename) then
        local contents = love.filesystem.read(filename)
        local info = Json.decode(contents) or {}
        SaveState = info.savestate or (info.Room and info) or nil
        GameState = info.gamestate or nil
    end

    GameState = GameState or nil

    gotoRoom('Stage')
end

function love.update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end 

function gotoRoom(room_type, ...) 
    current_room = _G[room_type](...)
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item 
        if love.filesystem.getInfo(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then 
            recursiveEnumerate(file, file_list)
        end
    end
end


function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end