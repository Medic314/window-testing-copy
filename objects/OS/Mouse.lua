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
            local focusedId = self.colliders[1].id
            local highestFocus = findFocus(focusedId)
            for i = 2, #self.colliders do
                local colliderId = self.colliders[i].id
                local colliderFocus = findFocus(colliderId)
                if colliderFocus > highestFocus then
                    focusedId = colliderId
                    highestFocus = colliderFocus
                end
            end
            updateFocus(focusedId)
        end
    end
    if notifpulse then 
        self.area:addGameObject('Notification', 0, 0, {text=notifpulse})
        notifpulse = nil
    end
end

function Mouse:draw()

end
