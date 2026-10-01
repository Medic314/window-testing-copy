Button = GameObject:extend()

function Button:new(area, x, y, opts)
    Button.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.w = opts.w or 50
    self.h = opts.h or 50
    self.x = x
    self.y = y
    self.type = opts.type or 't'
    self.mID = opts.mID or nil

    --[[self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass("Desktop Button")
    self.collider:setType('static')
    self.collider:setObject(self)]]--
end

function Button:update(dt)
    if input:pressed('lmb') then
        self.collider = self.area.world:queryRectangleArea(self.x, self.y, self.w, self.h, {'Mouse'})
        if self.collider[1] then
            if self.type == 'e' then
                gotoRoom('Stage')
            else
                self.area:addGameObject(self.type .. 'Window', self.x, self.y, {mID = self.mID})
            end
        end
    end
end

function Button:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end