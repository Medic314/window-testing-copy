Wall = GameObject:extend()

function Wall:new(area, x, y, opts)
    Wall.super.new(self, area, x, y, opts)
    self.layer = 'background'

    self.x = x
    self.y = y
    self.w = opts.w or 0
    self.h = opts.h or 0
    self.nocollisions = opts.nc or false
    self.idr = opts.idr or self.id

    if not self.nocollisions then
        self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
        self.collider:setCollisionClass("Terrain")
        self.collider:setType('static')
        self.collider:setObject(self)
    end
end

function Wall:update(dt)
    if Cull == self.idr then
        self.dead = true
    end
end

function Wall:draw()

end