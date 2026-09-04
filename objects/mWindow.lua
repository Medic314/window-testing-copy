mWindow = GameObject:extend()

function mWindow:new(area, x, y, opts)
    mWindow.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = gw/2
    self.y = gh/2
    love.graphics.setFont(ST.f.alphabeta)
    self.charsize = 16
    self.bounds = {x = 800, y = 600}
    self.dragging = false
    self.memos = opts.memos or {TT.placeholder.ptext1, TT.placeholder.ptext2, TT.placeholder.ptext3, TT.placeholder.ptext4}
    self.memoButtonHeight = 80
    self.memoButtonGap = 4
    self.memoPadding = 16

    self.collider = self.area.world:newRectangleCollider(self.x, self.y-50, self.bounds.x, self.bounds.y+50)
    self.collider:setCollisionClass("Window")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.id = self.id
end

function mWindow:update(dt)
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
            timer:after(0.2, function() self.closebuttondown = 0 self.dead = true end)
        end
        if self.dragging then self.dragging = false end
    end
    
    if Focus == self.id then
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

            if input:pressed('lmb') and GMY >= self.y then
                local buttonWidth = self.bounds.x - self.memoPadding * 2
                local buttonX = self.x + self.memoPadding
                local buttonY = self.y + self.memoPadding
                for index, memo in ipairs(self.memos) do
                    local currentButtonY = buttonY + (index - 1) * (self.memoButtonHeight + self.memoButtonGap)
                    if currentButtonY + self.memoButtonHeight > self.y + self.bounds.y then
                        break
                    end
                    if GMX >= buttonX and GMX <= buttonX + buttonWidth and
                        GMY >= currentButtonY and GMY <= currentButtonY + self.memoButtonHeight then
                        self.area:addGameObject('tWindow', self.x, self.y, {text = memo})
                        break
                    end
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
    
    if self.bounds.x < 400 then self.bounds.x = 400 end
    if self.bounds.y < 300 then self.bounds.y = 300 end
    if self.bounds.x > 1500 then self.bounds.x = 1500 end
    if self.bounds.y > 1500 then self.bounds.y = 1500 end
end

function mWindow:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y-50, self.bounds.x, self.bounds.y+50)
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.rectangle('line', self.x, self.y, self.bounds.x, self.bounds.y)

    local down
    if self.closebuttondown then down = 'fill' else down = 'line' end
    love.graphics.rectangle('line', self.x, self.y-50, self.bounds.x, 50)
    love.graphics.rectangle(down, self.x, self.y-50, 50, 50)

    local buttonWidth = self.bounds.x - self.memoPadding * 2
    local buttonX = self.x + self.memoPadding
    local buttonY = self.y + self.memoPadding
    for index, memo in ipairs(self.memos) do
        local currentButtonY = buttonY + (index - 1) * (self.memoButtonHeight + self.memoButtonGap)
        if currentButtonY + self.memoButtonHeight > self.y + self.bounds.y then
            break
        end
        love.graphics.rectangle('line', buttonX, currentButtonY, buttonWidth, self.memoButtonHeight)
    end
end