FTexttester = GameObject:extend()

function FTexttester:new(area, x, y, opts)
    FTexttester.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = x
    self.Y = y
    
    self.W = opts.w or 50
    self.H = opts.h or 50
    self.idr = opts.idr or self.id
    self.textline = opts.textline or nil
    self.c = opts.c or true
    self.func = opts.func or nil

    if self.c == true then 
        self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
        self.collider:setCollisionClass("Terrain")
        self.collider:setType('static')
        self.collider:setObject(self)
    end

    self.ficollider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.ficollider:setCollisionClass("fInteractable")
    self.ficollider:setType('static')
    self.ficollider:setObject(self)
    self.ficollider.distance = 0
    self.ficollider.interacted = false
end

function FTexttester:update(dt)
    if Cull == self.idr then
        self.dead = true
    end
    self.ficollider.distance = math.sqrt(((PlayerX-(self.X+self.W/2))^2) + ((PlayerY-(self.Y+self.H/2))^2))

    if self.ficollider.interacted then
        print('wagh')
        self.ficollider.interacted = false
        self.area:addGameObject('Textbox', camera.x, camera.y, {textline = self.textline, func = self.func})
        self.dead = true
    end
end

function FTexttester:draw()
    love.graphics.rectangle('line', self.X, self.Y, self.W, self.H)
    love.graphics.line(self.X+self.W/2, self.Y+self.H/2, PlayerX, PlayerY)
end