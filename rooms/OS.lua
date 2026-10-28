function hextorgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
end

pallete = {
    blue = {
        panel = {0.08, 0.09, 0.10},
        muted = {0.14, 0.20, 0.29},
        primary = {0.08, 0.18, 0.29},
        accent = {0.20, 0.48, 0.68},
        
        
        dark = {0.02, 0.03, 0.04},
        text = {1, 1, 1},
    },
    green = {
        panel = {0.06, 0.12, 0.12},
        muted = {0.13, 0.25, 0.24},
        primary = {0.02, 0.30, 0.27},
        accent = {0.04, 0.48, 0.42},

        --[[panel = {hextorgb("4B7F52")},
        muted = {hextorgb("B6F9C9")},
        primary = {hextorgb("7DD181")},
        accent = {hextorgb("96E8BC")},]]
        
        
        dark = {0.02, 0.06, 0.06},
        text = {1, 1, 1},
    },
}

OS = Object:extend()


function OS:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
    CamX, CamY = gw/2,gh/2
    print(hextorgb("#456990"))
end

function OS:init()
    GMX, GMY = 0, 0
    Focus = nil
    
    FocusHis = {}

    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('mouse1', 'lmb')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('a', 'left')
    input:bind('d', 'right')
    input:bind('wheelup','upscroll')
    input:bind('wheeldown','downscroll')
    input:bind('1', '1')
    input:bind('2', '2')
    input:bind('3', '3')
    input:bind('4', '4')

    self.area.world:addCollisionClass('Mouse')
    self.area.world:addCollisionClass('Window')

    --self.area:addGameObject('Window', 0, 0)
    self.area:addGameObject('Mouse', 0, 0)

    if OSD == 'Cali' then
        self.area:addGameObject('Background', 0, 0)
        self.area:addGameObject('Button', (200*1.5)-200, (200*1.5)-200, {type='m', mID = 'memo', title = "Folder1", memos2 = {{text=TT.COST.memo1, title="Cursed"}}})
        self.area:addGameObject('Button', (200*1.5)-200, (300*1.5)-200, {type='m', mID = 'email', title = "Email", memos = {{text=TT.COST.samEmail, title = "Mission Statement", sender = "Sam"}}})
        self.area:addGameObject('Button', (300*1.5)-200, (200*1.5)-200, {type='p', title = "Gallery"})
        self.area:addGameObject('Button', (400*1.5)-200, (200*1.5)-200, {title="Hate"})
        self.area:addGameObject('Button', (800*1.5)-200, (200*1.5)-200, {type='e'})
    elseif OSD == 'At' then
        self.area:addGameObject('Button', 600, 200, {type='e'})
        self.area:addGameObject('Button', (200*1.5)-200, (200*1.5)-200, {type='m', mID = 'memo'})
        self.area:addGameObject('Button', (300*1.5)-200, (200*1.5)-200, {type='m', mID = 'email'})
    elseif OSD == 'Ts' then
        self.area:addGameObject('Button', 600, 200, {type='e'})
        self.area:addGameObject('Button', (200*1.5)-200, (200*1.5)-200, {type='m', mID = 'memo', password = 'tungsten'})
        self.area:addGameObject('Button', (300*1.5)-200, (200*1.5)-200, {type='m', mID = 'email', password = 'tungsten2'})
    elseif OSD == 'R' then
        self.area:addGameObject('Button', 600, 200, {type='e'})
        self.area:addGameObject('Button', 200, 200, {type='g'})
    end
    
    self.taskbar = self.area:addGameObject('Taskbar', 0, 0)
    self.area:addGameObject('Transition', 0, 0, {type = 'room'})

    effect = Moonshine(Moonshine.effects.filmgrain)
                    .chain(Moonshine.effects.crt)
                    .chain(Moonshine.effects.scanlines)
    effect.filmgrain.size = 4
    effect.filmgrain.opacity = 0.1
    effect.crt.distortionFactor = {1.02, 1.02}
    effect.scanlines.width = 1
    effect.scanlines.thickness = 0.2
    effect.scanlines.frequency = gh/2
    effect.scanlines.opacity = 0.3
end

function findFocus(id)
    for i, v in ipairs(FocusHis) do
        if v == id then
            return i
        end
    end
    return 0
end

function updateFocus(id)
    Focus = id
    for i, v in ipairs(FocusHis) do
        if v == id then
            table.remove(FocusHis, i)
        end
    end
    table.insert(FocusHis, Focus)
    --for i=1, #FocusHis do print(FocusHis[i],  findFocus(FocusHis[i])) end
    --print("")
end

function OS:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        camera:update(dt)

        camera:follow(CamX, CamY)
    end
end

function OS:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    effect.draw(function()
        camera:attach(CamX, CamY, gw, gh)
        self.area:draw()
        camera:draw()
        
        camera:detach()
        self.taskbar:draw()
    end)
    
    love.graphics.setCanvas()
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
    --[[effect(function()
      love.graphics.rectangle("fill", 0, 0, gw, gh)
    end)]]
end