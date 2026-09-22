Folders = Object:extend()

function Folders:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
    CamX, CamY = gw/2,gh/2
end

function Folders:init()
    GMX, GMY = 0, 0
    filelock = false

    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('mouse1', 'lmb')
    input:bind('space', 'space')
    input:bind('escape', 'escape')
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
    self.area.world:addCollisionClass('Folder')

    self.area:addGameObject('Mouse', 0, 0)
    self.area:addGameObject('Folder', 50, 50)
    self.area:addGameObject('Folder', 150, 50)
    self.area:addGameObject('Folder', 250, 50)
    self.area:addGameObject('Folder', 350, 50)
    self.area:addGameObject('Folder', 450, 50)
    self.area:addGameObject('Folder', 550, 50)

    self.area:addGameObject('Fbutton', 1600, 50)

    self.area:addGameObject('Transition', 0, 0, {type = 'room'})
end

function Folders:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        camera:update(dt)

        camera:follow(CamX, CamY)
    end
end

function Folders:draw()
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