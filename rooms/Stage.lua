Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
    --CamX, CamY = 0,0
end

function Stage:init()
    GMX, GMY = 0, 0
    Focus = nil

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

    --self.area:addGameObject('Window', 0, 0)
    self.area:addGameObject('Mouse', 0, 0)
    self.area:addGameObject('Background', 0, 0)
    self.area:addGameObject('Button', 200, 200)
    self.area:addGameObject('Button', 300, 200, {type='p'})
    self.area:addGameObject('Button', 400, 200, {type='m'})
end

function Stage:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        camera:update(dt)

        camera:follow(CamX, CamY)
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