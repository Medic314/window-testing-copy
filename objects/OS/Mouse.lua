Mouse = GameObject:extend()

function Mouse:new(area, x, y, opts)
    Mouse.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.layer = 'menu'

    self.collider = self.area.world:newCircleCollider(self.x, self.y, 2)
    self.collider:setCollisionClass("Mouse")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.id = self.id
    GMX, GMY = 0, 0
end

function Mouse:update(dt)
    local MX, MY = love.mouse.getPosition() 
    MX, MY = camera:toWorldCoords(MX/sx, MY/sy)
    self.x, self.y = MX, MY
    GMX, GMY = self.x, self.y
    self.collider:setPosition(self.x, self.y)
    if input:pressed('lmb') then
        self.colliders = self.area.world:queryCircleArea(self.x, self.y, 2, {'Window'})
        if self.colliders[1] then
            if #self.colliders > 1 then
                for i=1, #self.colliders do
                    for j=1, #self.colliders do
                        print(#self.colliders)
                        if findFocus(self.colliders[i].id) ~= findFocus(self.colliders[j].id) then
                            if findFocus(self.colliders[i].id) > findFocus(self.colliders[j].id) then
                                updateFocus(self.colliders[i].id)
                            else
                                updateFocus(self.colliders[j].id)
                            end
                        end
                    end
                end
            else
                updateFocus(self.colliders[1].id)
            end
        end
    end
end

function Mouse:draw()

end
