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
    self.title = opts.title or 'Pictures'
    self.imagesize = 400

    self.images = opts.images or {ST.placeholder, ST.placeholder2, ST.placeholder3}
    self.selectedimage = opts.selectedimage or 1

    self.collider = self.area.world:newRectangleCollider(self.x, self.y-50, self.bounds.x, self.bounds.y+50)
    self.collider:setCollisionClass("Window")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.id = self.id

    updateFocus(self.id)
end

function pWindow:update(dt)
    self.collider:setPosition(self.x+self.bounds.x/2, (self.y-50)+(self.bounds.y+50)/2)
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
    local width, height = self.bounds.x, self.bounds.y + 50
    local top = self.y - 50
    local titleHeight = 50
    local panel = {0.08, 0.07, 0.09}
    local pink = {0.78, 0.20, 0.43}
    local lightPink = {0.96, 0.55, 0.70}
    local white = {0.93, 0.90, 0.92}
    local dark = {0.02, 0.02, 0.03}

    love.graphics.setColor(panel)
    love.graphics.rectangle('fill', self.x, top, width, height)
    love.graphics.setColor(dark)
    love.graphics.line(self.x, top + height - 1, self.x + width - 1, top + height - 1)
    love.graphics.line(self.x + width - 1, top, self.x + width - 1, top + height - 1)
    love.graphics.setColor(0.28, 0.10, 0.17)
    love.graphics.line(self.x + 1, top + 1, self.x + width - 2, top + 1)
    love.graphics.line(self.x + 1, top + 1, self.x + 1, top + height - 2)

    if Focus == self.id then love.graphics.setColor(pink) else love.graphics.setColor({0.19, 0.11, 0.15}) end
    love.graphics.rectangle('fill', self.x + 3, top + 3, width - 6, titleHeight - 6)
    love.graphics.setColor(white)
    love.graphics.setFont(ST.f.alphabeta)
    love.graphics.print(self.title, self.x + 10, top + 14)
    
    love.graphics.setFont(ST.f.alphabeta)
    love.graphics.setColor(lightPink)
    love.graphics.print('<', self.x + ((self.bounds.x-self.imagesize)/4), (self.y+self.bounds.y/2))
    love.graphics.print('>', self.x+self.bounds.x - ((self.bounds.x-self.imagesize)/4), (self.y+self.bounds.y/2))

    love.graphics.setColor(white)
    local image = self.images[self.selectedimage]
    local imageScale = self.imagesize / math.max(image:getWidth(), image:getHeight())
    love.graphics.draw(image, (self.x+self.bounds.x/2)-(image:getWidth()*imageScale)/2, (self.y+self.bounds.y/2)-(image:getHeight()*imageScale)/2, 0, imageScale, imageScale)
    love.graphics.setColor(pink)
    love.graphics.circle('fill',self.x+self.bounds.x/2, self.y+self.bounds.y/2, 3)

    love.graphics.rectangle('line', self.x + 3, top + 3, width - 6, height - 6)
    love.graphics.setColor(1, 1, 1)
end