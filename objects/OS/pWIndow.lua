pWindow = GameObject:extend()

function pWindow:new(area, x, y, opts)
    pWindow.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = gw/2
    self.y = gh/2
    love.graphics.setFont(ST.f.alphabeta)
    self.charsize = 16
    self.bounds = {x = 800, y = 600}
    self.dragging = false
    self.imagesize = 400

    self.images = {ST.placeholder, ST.placeholder2, ST.placeholder3}
    self.selectedimage = 1

    self.collider = self.area.world:newRectangleCollider(self.x, self.y-50, self.bounds.x, self.bounds.y+50)
    self.collider:setCollisionClass("Window")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.id = self.id

    updateFocus(self.id)
end

function pWindow:update(dt)
    self.collider:setPosition(self.x+self.bounds.x/2, self.y+self.bounds.y/2)
    if Focus == self.id then self.layer = "main layer" else self.layer = 'background' end
    self.colliders = self.area.world:queryRectangleArea(self.x, self.y-50, self.bounds.x, self.bounds.y+50, {'Mouse'})

    if input:pressed('lmb') then
        if self.colliders[1] then
            self.MX2, self.MY2 = GMX - self.x, GMY - self.y
        end
    end
    if input:released('lmb') then
        if self.closebuttondown then
            timer:after(0.2, function() self.closebuttondown = 0 self.dead = true FocusHis[findFocus(self.id)] = nil end)
        end
        if self.dragging then self.dragging = false end
    end
    
    if Focus == self.id then
        --print(self.bounds.x/2-self.imagesize/2)
        if self.dragging then self.x, self.y = GMX-self.MX2, GMY-self.MY2 end
        if self.colliders[1] then
            if input:down('lmb') then
                if (GMY < self.y) and GMX > self.x+50 then
                    self.dragging = true
                end
            end
            if input:pressed('lmb') then
                if (GMY < self.y) and GMX < self.x+50 then
                    self.closebuttondown = 1
                end
            end
            if input:pressed('lmb') then
                if ((GMX > self.x) and (GMX < self.x+(self.bounds.x/2-self.imagesize/2))) and GMY > self.y then
                    self.selectedimage = self.selectedimage - 1
                    if self.selectedimage <= 0 then self.selectedimage = #self.images end
                end
                if ((GMX < self.x+self.bounds.x) and (GMX > self.x+(self.bounds.x/2+self.imagesize/2))) and GMY > self.y then
                    self.selectedimage = self.selectedimage + 1
                    if self.selectedimage > #self.images then self.selectedimage = 1 end
                end
            end
        end
        if input:pressed('left') or input:down('left') then
            self.bounds.x = self.bounds.x - 16
        end
        if input:pressed('right') or input:down('right') then
            self.bounds.x = self.bounds.x + 16
        end
        if input:pressed('up') or input:down('up') then
            self.bounds.y = self.bounds.y - 16
        end
        if input:pressed('down') or input:down('down') then
            self.bounds.y = self.bounds.y + 16
        end
    end
    local smalledge
    if self.bounds.x < 400+200 then self.bounds.x = 400+200 end
    if self.bounds.y < 400 then self.bounds.y =  400 end
    if self.bounds.x-200 < self.bounds.y then smalledge = self.bounds.x-200 else smalledge = self.bounds.y end
    if self.bounds.x > 1500 then self.bounds.x = 1500 end
    if self.bounds.y > 1500 then self.bounds.y = 1500 end
    self.imagesize = smalledge

    if self.bounds.x ~= self.colliderWidth or self.bounds.y ~= self.colliderHeight then
        self.collider:destroy()
        self.collider = self.area.world:newRectangleCollider(self.x, self.y-50, self.bounds.x, self.bounds.y+50)
        self.collider:setCollisionClass("Window")
        self.collider:setType('static')
        self.collider:setObject(self)
        self.collider.id = self.id
        self.colliderWidth = self.bounds.x
        self.colliderHeight = self.bounds.y
    end
end

function pWindow:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y-50, self.bounds.x, self.bounds.y+50)
    love.graphics.setColor(1, 1, 1)

    love.graphics.rectangle('line', self.x, self.y, self.bounds.x, self.bounds.y)

    local down
    if self.closebuttondown then down = 'fill' else down = 'line' end
    love.graphics.rectangle('line', self.x, self.y-50, self.bounds.x, 50)
    love.graphics.rectangle(down, self.x, self.y-50, 50, 50)
    
    love.graphics.setFont(ST.f.alphabeta)
    love.graphics.print('<', self.x + ((self.bounds.x-self.imagesize)/4), (self.y+self.bounds.y/2))
    love.graphics.print('>', self.x+self.bounds.x - ((self.bounds.x-self.imagesize)/4), (self.y+self.bounds.y/2))

    love.graphics.draw(self.images[self.selectedimage], (self.x+self.bounds.x/2)-self.imagesize/2, (self.y+self.bounds.y/2)-self.imagesize/2, 0, self.imagesize/400, self.imagesize/400)
    love.graphics.circle('fill',self.x+self.bounds.x/2, self.y+self.bounds.y/2, 3)
end