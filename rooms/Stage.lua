Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
    CamX, CamY = 0,0
end

function Stage:init()
    GMX, GMY = 0, 0
    CR, PR = 'main', nil
    Camerascroll = false

    if SaveState then
        PX, PY = SaveState.PX, SaveState.PY
        CR = SaveState.Room
    end

    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('mouse1', 'lmb')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('a', 'left')
    input:bind('d', 'right')
    input:bind('w', 'directional_input')
    input:bind('a', 'directional_input')
    input:bind('s', 'directional_input')
    input:bind('d', 'directional_input')
    input:bind('up', 'directional_input')
    input:bind('down', 'directional_input')
    input:bind('left', 'directional_input')
    input:bind('right', 'directional_input')
    input:bind('wheelup','upscroll')
    input:bind('wheeldown','downscroll')
    input:bind('1', '1')
    input:bind('2', '2')
    input:bind('3', '3')
    input:bind('4', '4')

    input:bind('e', 'interact')
    input:bind('space', 'next')

    input:bind('0', function() gotoRoom('OS') end)

    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Terrain')
    self.area.world:addCollisionClass('Interactable')

    self.area:addGameObject('Cali', 0, 0)
    self.area:addGameObject('prRooms', 0, 0, {rid=CR})
end

function Stage:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        camera:update(dt)
        local MX, MY = love.mouse.getPosition()
        MX = MX - gw / 2
        MY = MY - gh / 2
        if Camerascroll then
            camera:follow(PlayerX+MX/32, PlayerY+MY/32)
        else
            camera:follow(0+MX/(32*2), 0+MY/(32*2))
        end
    end
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    
    camera:attach(CamX, CamY, gw, gh)
    self.area:draw()
    camera:draw()

    camera:detach()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end