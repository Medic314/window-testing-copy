mWindow = GameObject:extend()

local function memoImage(memo)
    if type(memo) == 'userdata' then return memo end
    if type(memo) ~= 'table' then return nil end
    return memo.image or memo.imageLine or memo.lineImage
end

local function memoField(memo, field, fallback)
    if type(memo) == 'table' then return memo[field] or fallback end
    return fallback
end

function mWindow:new(area, x, y, opts)
    opts = opts or {}
    mWindow.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = gw/2
    self.y = gh/2
    love.graphics.setFont(ST.f.alphabeta)
    self.charsize = 16
    self.bounds = {x = 800, y = 600}
    self.dragging = false
    self.memos = opts.memos or {{text=TT.placeholder.ptext1, title="AM Speech"}, {text=TT.placeholder.ptext2, title="Ozymandias Poem"}, {text=TT.placeholder.ptext3, title="BlackBoxWarrior Monologue"}, {text=TT.placeholder.ptext4, title="COINFLIP"}}
    self.memos2 = opts.memos2 or {{title="Image", imageLine=ST.placeholder}, {title="Image", imageLine=ST.placeholder2}, {title="Image", imageLine=ST.placeholder3}}
    self.memos3 = opts.memos3 or {{title="Image", imageLine=ST.placeholder}}
    self.memos2Name = "Gallery"
    self.memos3Name = "Placehold"
    self.mID = opts.mID or 'memo'
    self.title = opts.title or (self.mID == 'email' and 'Inbox' or 'File Manager')
    self.memoButtonHeight = 72
    self.memoButtonGap = 4
    self.memoPadding = 16
    self.sidebarButtonHeight = 36
    self.sidebarButtonGap = 8
    self.sidebarScroll = 0
    self.activeMemoList = 1
    self.memoLists = {{key = 'memos', title = self.memosName or 'Memos', items = self.memos}}

    local numberedLists = {}
    for key, items in pairs(self) do
        local number = type(key) == 'string' and key:match('^memos(%d+)$')
        if number and tonumber(number) >= 2 and type(items) == 'table' then
            table.insert(numberedLists, {key = key, number = tonumber(number), items = items})
        end
    end
    table.sort(numberedLists, function(a, b) return a.number < b.number end)
    for _, list in ipairs(numberedLists) do
        local title = self[list.key .. 'Name'] or ('Memos ' .. list.number)
        table.insert(self.memoLists, {key = list.key, title = title, items = list.items})
    end

    self.colliderWidth = self.bounds.x + 25
    self.colliderHeight = self.bounds.y + 50
    self.collider = self.area.world:newRectangleCollider(self.x + self.colliderWidth / 2, self.y - 50 + self.colliderHeight / 2, self.colliderWidth, self.colliderHeight)
    self.collider:setCollisionClass("Window")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.scroll = 0
    self.collider.id = self.id

    updateFocus(self.id)
end

function mWindow:update(dt)
    local colliderWidth = self.bounds.x + 25
    local colliderHeight = self.bounds.y + 50
    if Focus == self.id then self.layer = "main layer" else self.layer = 'background' end
    self.colliders = self.area.world:queryRectangleArea(self.x, self.y - 50, colliderWidth, colliderHeight, {'Mouse'})

    local buttonH = #self.memos * (self.memoButtonHeight + self.memoButtonGap)
    local VH = self.bounds.y - 76
    local sidebarWidth = self.mID == 'memo' and 176 or 0
    local sidebarContentHeight = #self.memoLists * (self.sidebarButtonHeight + self.sidebarButtonGap) - self.sidebarButtonGap
    local sidebarViewportHeight = self.bounds.y - 66
    local maxSidebarScroll = math.max(0, sidebarContentHeight - sidebarViewportHeight)
    self.sidebarScroll = math.max(-maxSidebarScroll, math.min(0, self.sidebarScroll))
    
    local mScroll = math.max(0, buttonH - VH)
    if self.scroll > 0 then self.scroll = 0 end
    if self.scroll < -mScroll then self.scroll = -mScroll end

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
            local overSidebar = sidebarWidth > 0 and GMX >= self.x and GMX <= self.x + sidebarWidth and GMY >= self.y
            if input:pressed('upscroll') then
                if overSidebar then self.sidebarScroll = math.min(0, self.sidebarScroll + 32)
                else self.scroll = self.scroll + 8*2 end
            end
            if input:pressed('downscroll') then
                if overSidebar then self.sidebarScroll = math.max(-maxSidebarScroll, self.sidebarScroll - 32)
                else self.scroll = self.scroll - 8*2 end
            end

            if input:pressed('lmb') and sidebarWidth > 0 then
                for index, list in ipairs(self.memoLists) do
                    local rowY = self.y + 48 + (index - 1) * (self.sidebarButtonHeight + self.sidebarButtonGap) + self.sidebarScroll
                    if GMX >= self.x + 12 and GMX <= self.x + sidebarWidth - 12 and GMY >= rowY and GMY <= rowY + self.sidebarButtonHeight then
                        self.activeMemoList = index
                        self.memos = list.items
                        self.scroll = 0
                        break
                    end
                end
            end

            if input:pressed('lmb') and GMY >= self.y + 58 then
                local buttonWidth = self.bounds.x - sidebarWidth - self.memoPadding * 2
                local buttonX = self.x + sidebarWidth + self.memoPadding
                local buttonY = self.y + 64
                for index, memo in ipairs(self.memos) do
                    local currentButtonY = (buttonY + (index - 1) * (self.memoButtonHeight + self.memoButtonGap)) + self.scroll
                    if GMX >= buttonX and GMX <= buttonX + buttonWidth and GMY >= currentButtonY and GMY <= currentButtonY + self.memoButtonHeight then
                        local image = memoImage(memo)
                        if self.mID == 'memo' and image then
                            self.area:addGameObject('pWindow', self.x, self.y, {title = memoField(memo, 'title', 'Image'), images = {image}})
                        else
                            self.area:addGameObject('tWindow', self.x, self.y, {text = memoField(memo, 'text', ''), title = memoField(memo, 'title', 'Message')})
                        end
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

    colliderWidth = self.bounds.x + 25
    colliderHeight = self.bounds.y + 50
    if colliderWidth ~= self.colliderWidth or colliderHeight ~= self.colliderHeight then
        self.collider:destroy()
        self.collider = self.area.world:newRectangleCollider(self.x + colliderWidth / 2, self.y - 50 + colliderHeight / 2, colliderWidth, colliderHeight)
        self.collider:setCollisionClass("Window")
        self.collider:setType('static')
        self.collider:setObject(self)
        self.collider.id = self.id
        self.colliderWidth = colliderWidth
        self.colliderHeight = colliderHeight
    end
    self.collider:setPosition(self.x + colliderWidth / 2, self.y - 50 + colliderHeight / 2)
end

function mWindow:draw()
    local width, height = self.bounds.x + 25, self.bounds.y + 50
    local top = self.y - 50
    local titleHeight = 50
    local panel = {0.08, 0.09, 0.11}
    local navy = self.mID == 'email' and {0.02, 0.24, 0.22} or {0.08, 0.18, 0.29}
    local white = {0.88, 0.91, 0.93}
    local dark = {0.10, 0.09, 0.12}

    love.graphics.setColor(panel)
    love.graphics.rectangle('fill', self.x, top, width, height)
    love.graphics.setColor(dark)
    love.graphics.line(self.x, top + height - 1, self.x + width - 1, top + height - 1)
    love.graphics.line(self.x + width - 1, top, self.x + width - 1, top + height - 1)
    love.graphics.setColor(white)
    love.graphics.line(self.x + 1, top + 1, self.x + width - 2, top + 1)
    love.graphics.line(self.x + 1, top + 1, self.x + 1, top + height - 2)

    if Focus == self.id then love.graphics.setColor(navy) else love.graphics.setColor(dark) end
    love.graphics.rectangle('fill', self.x + 3, top + 3, width - 6, titleHeight - 6)
    love.graphics.setColor(white)
    love.graphics.setFont(ST.f.alphabeta)
    love.graphics.print(self.title, self.x + 10, top + 14)

    local sidebarWidth = self.mID == 'memo' and 176 or 0
    if self.mID == 'memo' then
        love.graphics.setColor(0.05, 0.06, 0.08)
        love.graphics.rectangle('fill', self.x + 3, self.y, sidebarWidth, self.bounds.y - 3)
        love.graphics.setColor(0.72, 0.77, 0.81)
        love.graphics.print('FILES', self.x + 18, self.y + 12)
        for index, list in ipairs(self.memoLists) do
            local rowY = self.y + 48 + (index - 1) * (self.sidebarButtonHeight + self.sidebarButtonGap) + self.sidebarScroll
            if rowY + self.sidebarButtonHeight >= self.y + 42 and rowY <= self.y + self.bounds.y - 8 then
                if index == self.activeMemoList then
                    love.graphics.setColor(navy)
                    love.graphics.rectangle('fill', self.x + 12, rowY, sidebarWidth - 24, self.sidebarButtonHeight)
                    love.graphics.setColor(0.94, 0.96, 0.98)
                    love.graphics.print('> ' .. list.title, self.x + 20, rowY + 4)
                else
                    love.graphics.setColor(0.61, 0.67, 0.71)
                    love.graphics.print(list.title, self.x + 20, rowY + 4)
                end
            end
        end
        local sidebarContentHeight = #self.memoLists * (self.sidebarButtonHeight + self.sidebarButtonGap) - self.sidebarButtonGap
        local sidebarViewportHeight = self.bounds.y - 66
        if sidebarContentHeight > sidebarViewportHeight then
            local trackX = self.x + sidebarWidth - 7
            local trackY = self.y + 48
            local thumbHeight = math.max(18, sidebarViewportHeight * sidebarViewportHeight / sidebarContentHeight)
            local thumbY = trackY + (-self.sidebarScroll / (sidebarContentHeight - sidebarViewportHeight)) * (sidebarViewportHeight - thumbHeight)
            love.graphics.setColor(0.24, 0.27, 0.30)
            love.graphics.rectangle('fill', trackX, trackY, 3, sidebarViewportHeight)
            love.graphics.setColor(0.57, 0.63, 0.68)
            love.graphics.rectangle('fill', trackX, thumbY, 3, thumbHeight)
        end
    else
        love.graphics.setColor(0.02, 0.20, 0.19)
        love.graphics.rectangle('fill', self.x + 3, self.y, self.bounds.x - 6, 42)
        love.graphics.setColor(0.88, 0.94, 0.93)
        love.graphics.print('INBOX     SENT     ARCHIVE', self.x + 18, self.y + 6)
    end

    local buttonWidth = self.bounds.x - sidebarWidth - self.memoPadding * 2
    local buttonX = self.x + sidebarWidth + self.memoPadding
    local buttonY = self.y + 64
    for index, memo in ipairs(self.memos) do
        local currentButtonY = (buttonY + (index - 1) * (self.memoButtonHeight + self.memoButtonGap))+self.scroll
        if (currentButtonY + self.memoButtonHeight <= self.y + self.bounds.y) and (currentButtonY >= self.y + 58) then
            if self.mID == 'email' then
                love.graphics.setColor(0.12, 0.14, 0.16)
                love.graphics.rectangle('fill', buttonX, currentButtonY, buttonWidth, self.memoButtonHeight)
                love.graphics.setColor(0.03, 0.45, 0.41)
                love.graphics.rectangle('fill', buttonX, currentButtonY, 6, self.memoButtonHeight)
                love.graphics.setColor(0.68, 0.73, 0.75)
                love.graphics.print(memoField(memo, 'sender', 'Unknown sender'), buttonX + 18, currentButtonY + 2)
                love.graphics.setColor(0.91, 0.93, 0.94)
                love.graphics.print(memoField(memo, 'title', 'No subject'), buttonX + 18, currentButtonY + 30)
                love.graphics.setColor(0.58, 0.63, 0.65)
            else
                local image = memoImage(memo)
                love.graphics.setColor(0.12, 0.14, 0.17)
                love.graphics.rectangle('fill', buttonX, currentButtonY, buttonWidth, self.memoButtonHeight)
                love.graphics.setColor(0.30, 0.35, 0.39)
                love.graphics.rectangle('line', buttonX, currentButtonY, buttonWidth, self.memoButtonHeight)
                love.graphics.setColor(0.50, 0.72, 0.88)
                love.graphics.print(image and '[IMG]' or '[TXT]', buttonX + 12, currentButtonY + 18)
                love.graphics.setColor(0.91, 0.93, 0.95)
                love.graphics.print(memoField(memo, 'title', 'Untitled'), buttonX + 112, currentButtonY + 4)
                love.graphics.setColor(0.61, 0.66, 0.69)
            end
        end
    end

    love.graphics.setColor(dark)
    love.graphics.rectangle('line', self.x + 3, top + 3, width - 6, height - 6)

    local buttonH = #self.memos * (self.memoButtonHeight + self.memoButtonGap)
    local VH = self.bounds.y - 76

    if buttonH > VH then
        local trackX = self.x + self.bounds.x + 8
        local trackY = self.y + 64
        local trackHeight = VH
        local thumbHeight = math.max(16, trackHeight * VH / buttonH)
        local mScroll = buttonH - VH
        local thumbY = trackY + (-self.scroll / mScroll) * (trackHeight - thumbHeight)

        love.graphics.rectangle('line', trackX, trackY, 8, trackHeight)
        love.graphics.rectangle('fill', trackX, thumbY, 8, thumbHeight)
    end
    love.graphics.setColor(1, 1, 1)
end