Cali = GameObject:extend()

function Cali:new(area, x, y, opts)
    Cali.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = PX or x
    self.Y = PY or y
    
    self.W, self.H = (76/1.25)*1.25, (122/1.25)*1.25
    self.DX, self.DY = 0, 0

    self.collider = self.area.world:newRectangleCollider(self.X-self.W/2, self.Y-self.H/2, self.W, self.H)
    self.collider:setCollisionClass("Player")
    self.collider:setType('static')
    self.collider:setObject(self)
    PlayerX, PlayerY = self.X, self.Y
    self.facing = 'up'
end

function Cali:update(dt)
    self.X, self.Y = PlayerX, PlayerY
    self.A = 250

    self.LX, self.LY = self.X, self.Y

    if not movelock and not inputlock then
        if input:down('up') then self.facing = "up" self.Y = self.Y - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.Y = self.Y + self.A*dt end end
        if input:down('left') then self.facing = "left" self.X = self.X - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.X = self.X + self.A*dt end end
        if input:down('down') then self.facing = "down" self.Y = self.Y + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.Y = self.Y - self.A*dt end end
        if input:down('right') then self.facing = "right" self.X = self.X + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain', 'TerrainP'}) if self.colliders[1] then self.X = self.X - self.A*dt end end
    end
    
    self.collider:setPosition(self.X, self.Y)
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
    if input:pressed("interact") then
        self.icolliders = self.area.world:queryCircleArea(self.X, self.Y, self.W*1.5, {'Interactable'})
        local LDO
        if #self.icolliders > 1 then
            local LD = 99999
            for i=1, #self.icolliders do
                if self.icolliders[i].distance < LD then
                    LD = self.icolliders[i].distance
                    LDO = self.icolliders[i]
                end
            end
            if LDO then LDO.interacted = true end
        elseif self.icolliders[1] then
            self.icolliders[1].interacted = true
        end
    end

end

function Cali:draw()
    love.graphics.rectangle('line', self.X-self.W/2, self.Y-self.H/2, self.W, self.H)
    love.graphics.circle('line', self.X, self.Y, self.W*1.5)
end
    
    
    
    
    
    
    
 