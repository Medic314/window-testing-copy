Cali = GameObject:extend()

function Cali:new(area, x, y, opts)
    Cali.super.new(self, area, x, y, opts)
    self.layer = 'backerground'
    self.X = x
    self.Y = y
    
    self.W, self.H = 76/1.25, 122/1.25
    self.DX, self.DY = 0, 0
    self.image = love.graphics.newImage('assets/basewallpaper.png')

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.W, self.H)
    self.collider:setCollisionClass("Player")
    self.collider:setType('static')
    self.collider:setObject(self)
    PlayerX, PlayerY = self.X, self.Y
end

function Cali:update(dt)
    self.X, self.Y = PlayerX, PlayerY
    self.A = 300

    self.LX, self.LY = self.X, self.Y

    if not movelock then
        if input:down('up') then self.Y = self.Y - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.Y = self.Y + self.A*dt end end
        if input:down('left') then self.X = self.X - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.X = self.X + self.A*dt end end
        if input:down('down') then self.Y = self.Y + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.Y = self.Y - self.A*dt end end
        if input:down('right') then self.X = self.X + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.X = self.X - self.A*dt end end
    end
    
    self.collider:setPosition(self.X+self.W/2, self.Y+self.H/2)
    self.DfX, self.DfY = self.X - self.LX, self.Y - self.LY

    if not input:down('directional_input') then
        self.DX = self.DX - (self.DX/50)
        self.DY = self.DY - (self.DY/50)

        if math.abs(self.DX) < 0.5 then self.DX = 0 end
        if math.abs(self.DY) < 0.5 then self.DY = 0 end
    end

    self.X = self.X + self.DX
    self.Y = self.Y + self.DY
    PlayerX, PlayerY = self.X, self.Y

    
end

function Cali:draw()
    love.graphics.rectangle('line', self.X, self.Y, self.W, self.H)
end
    
    
    
    
    
    
    
 