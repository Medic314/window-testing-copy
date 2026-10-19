Texttester = GameObject:extend()

function Texttester:new(area, x, y, opts)
    Texttester.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = x
    self.Y = y
    
    self.W = opts.w or 50
    self.H = opts.h or 50
    self.idr = opts.idr or self.id
    self.textline = opts.textline or nil
    if self.textline[1] == TT.croom.computer then
        self.data = 'Cali'
    elseif self.textline[1] == TT.tsroom.computer then
        self.data = 'Ts'
    elseif self.textline[1] == TT.atroom.computer then
        self.data = 'At'
    elseif self.textline[1] == TT.rroom.computer then
        self.data = 'R'
    else
        self.data = nil
    end
    self.c = opts.c or true

    if self.c == true then 
        self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
        self.collider:setCollisionClass("Terrain")
        self.collider:setType('static')
        self.collider:setObject(self)
    end

    self.icollider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.icollider:setCollisionClass("Interactable")
    self.icollider:setType('static')
    self.icollider:setObject(self)
    self.icollider.distance = 0
    self.icollider.interacted = false
end

function Texttester:update(dt)
    if Cull == self.idr then
        self.dead = true
    end
    self.icollider.distance = math.sqrt(((PlayerX-(self.X+self.W/2))^2) + ((PlayerY-(self.Y+self.H/2))^2))

    if self.icollider.interacted then
        print('wagh')
        self.icollider.interacted = false
        self.area:addGameObject('Textbox', camera.x, camera.y, {textline = self.textline, data = self.data})
    end
end

function Texttester:draw()
    love.graphics.rectangle('line', self.X, self.Y, self.W, self.H)
    love.graphics.line(self.X+self.W/2, self.Y+self.H/2, PlayerX, PlayerY)
end