tWindow = GameObject:extend()

function tWindow:new(area, x, y, opts)
    tWindow.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.x = gw/2
    self.y = gh/2
    love.graphics.setFont(ST.f.alphabeta)
    self.charsize = 16
    self.bounds = {x = 800, y = 400}
    self.text = opts.text or TT.placeholder.ptext1
    self.lines = self:wrapText(self.text, self.bounds.x)
    self.textHitAreas = {}
    self.dragging = false
    self.scroll = 0

    self.title = opts.title or 'Window'

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.bounds.x+25, self.bounds.y+16)
    self.collider:setCollisionClass("Window")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.id = self.id
    self.colliderWidth = self.bounds.x
    self.colliderHeight = self.bounds.y

    updateFocus(self.id)
    self.MX2, self.MY2 = GMX - self.x, GMY - self.y
end

function tWindow:wrapText(text, maxWidth)
    local font = love.graphics.getFont()
    local lines = {}
    local currentLine = {words = {}, width = 0}
    local redText = false
    local redSectionId
    local nextRedSectionId = 0
    local redSections = {}
    local tokenIndex = 0

    local function addPiece(pieces, pieceText, currentTokenIndex)
        local piece = {text = pieceText, red = redText}
        if redText and redSectionId then
            piece.sectionId = redSectionId
            local section = redSections[redSectionId]
            if section.lastToken ~= currentTokenIndex and section.text ~= '' then
                section.text = section.text .. ' '
            end
            section.text = section.text .. pieceText
            section.lastToken = currentTokenIndex
        end
        table.insert(pieces, piece)
    end

    local function addLine()
        table.insert(lines, currentLine)
        currentLine = {words = {}, width = 0}
    end

    for word in text:gmatch("%S+") do
        tokenIndex = tokenIndex + 1
        if word == '[]' then
            addLine()
        elseif word == '[[]]' then
            addLine()
            addLine()
        else
            local pieces = {}
            local position = 1
            while position <= #word do
                local redStart = word:find('*R*', position, true)
                local endStart = word:find('*RE*', position, true)
                local markerStart = redStart and endStart and math.min(redStart, endStart) or redStart or endStart
                if not markerStart then
                    addPiece(pieces, word:sub(position), tokenIndex)
                    break
                end
                if markerStart > position then
                    addPiece(pieces, word:sub(position, markerStart - 1), tokenIndex)
                end
                if markerStart == redStart then
                    nextRedSectionId = nextRedSectionId + 1
                    redSectionId = nextRedSectionId
                    redSections[redSectionId] = {text = '', lastToken = nil}
                    redText = true
                    position = markerStart + 3
                else
                    redText = false
                    redSectionId = nil
                    position = markerStart + 4
                end
            end

            local wordWidth = 0
            for _, piece in ipairs(pieces) do
                wordWidth = wordWidth + font:getWidth(piece.text)
            end
            local spaceWidth = #currentLine.words > 0 and font:getWidth(' ') or 0
            if #currentLine.words > 0 and currentLine.width + spaceWidth + wordWidth > maxWidth then
                addLine()
                spaceWidth = 0
            end
            for index, piece in ipairs(pieces) do
                piece.clickable = piece.red
                piece.spaceBefore = index == 1 and #currentLine.words > 0
                table.insert(currentLine.words, piece)
            end
            currentLine.width = currentLine.width + spaceWidth + wordWidth
        end
    end

    if #currentLine.words > 0 or #lines == 0 then
        table.insert(lines, currentLine)
    end

    for _, line in ipairs(lines) do
        local lineText = {}
        for _, word in ipairs(line.words) do
            if word.spaceBefore then table.insert(lineText, ' ') end
            table.insert(lineText, word.text)
            if word.sectionId then
                word.sectionText = redSections[word.sectionId].text
            end
        end
        line.text = table.concat(lineText)
    end

    return lines
end

function tWindow:update(dt)
    self.collider:setPosition(self.x+(self.bounds.x+25)/2, self.y+(self.bounds.y+16)/2)
    if Focus == self.id then self.layer = "foreground" else self.layer = 'main layer' end
    local font = love.graphics.getFont()
    local textH = #self.lines * font:getHeight()
    local VH = self.bounds.y - 50
    local mScroll = math.max(0, textH - VH)
    self.colliders = self.area.world:queryRectangleArea(self.x, self.y, self.bounds.x+25, self.bounds.y+16, {'Mouse'})

    if self.scroll > 0 then self.scroll = 0 end
    if self.scroll < -mScroll then self.scroll = -mScroll end

    if input:pressed('lmb') then
        if self.colliders[1] then
            self.MX2, self.MY2 = GMX - self.x, GMY - self.y
            if Focus == self.id then
                for _, hitArea in ipairs(self.textHitAreas) do
                    if GMX >= hitArea.x and GMX <= hitArea.x + hitArea.width and GMY >= hitArea.y and GMY <= hitArea.y + hitArea.height then
                        self.area:addGameObject('CComment', self.x, self.y, {input = hitArea.sectionText})
                        print(hitArea.sectionText)
                        break
                    end
                end
            end
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
                if (GMY < self.y + 50) and GMX < self.x + self.bounds.x + 25 - 50 then
                    self.dragging = true
                end
            end
            if input:pressed('lmb') then
                if (GMY < self.y + 50) and GMX >= self.x + self.bounds.x + 25 - 50 then
                    self.closebuttondown = 1
                end
            end
        end
        if input:pressed('left') or input:down('left') then
            self.bounds.x = self.bounds.x - 16
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
        if input:pressed('right') or input:down('right') then
            self.bounds.x = self.bounds.x + 16
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
        if input:pressed('up') or input:down('up') then
            self.bounds.y = self.bounds.y - 16
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
        if input:pressed('down') or input:down('down') then
            self.bounds.y = self.bounds.y + 16
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
        if input:pressed('upscroll') then
            self.scroll = self.scroll + 8*2
        end
        if input:pressed('downscroll') then
            self.scroll = self.scroll - 8*2
        end
    end
    
    if self.bounds.x < 400 then self.bounds.x = 400 end
    if self.bounds.y < 300 then self.bounds.y = 300 end
    if self.bounds.x > 1500 then self.bounds.x = 1500 end
    if self.bounds.y > 1500 then self.bounds.y = 1500 end

    if self.bounds.x ~= self.colliderWidth or self.bounds.y ~= self.colliderHeight then
        self.collider:destroy()
        self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.bounds.x+25, self.bounds.y+16)
        self.collider:setCollisionClass("Window")
        self.collider:setType('static')
        self.collider:setObject(self)
        self.collider.id = self.id
        self.colliderWidth = self.bounds.x
        self.colliderHeight = self.bounds.y
    end
end

function tWindow:draw()
    local font = love.graphics.getFont()
    local width, height = self.bounds.x + 25, self.bounds.y + font:getHeight()
    local titleHeight = 50
    local panel = {0.08, 0.09, 0.10}
    local navy = {0.08, 0.18, 0.29}
    local white = {0.88, 0.91, 0.93}
    local dark = {0.02, 0.03, 0.04}

    love.graphics.setColor(panel)
    love.graphics.rectangle('fill', self.x, self.y, width, height)
    love.graphics.setColor(dark)
    love.graphics.line(self.x, self.y + height - 1, self.x + width - 1, self.y + height - 1)
    love.graphics.line(self.x + width - 1, self.y, self.x + width - 1, self.y + height - 1)
    love.graphics.setColor(0.24, 0.19, 0.12)
    love.graphics.line(self.x + 1, self.y + 1, self.x + width - 2, self.y + 1)
    love.graphics.line(self.x + 1, self.y + 1, self.x + 1, self.y + height - 2)

    if Focus == self.id then love.graphics.setColor(navy) else love.graphics.setColor({0.10, 0.09, 0.12}) end
    love.graphics.rectangle('fill', self.x + 3, self.y + 3, width - 6, titleHeight - 6)
    love.graphics.setColor(white)
    love.graphics.setFont(ST.f.alphabeta)
    local titleFont = love.graphics.getFont()
    local _, titleLines = titleFont:getWrap(self.title or 'Window', width - 70)
    for index = 1, math.min(#titleLines, 2) do
        love.graphics.print(titleLines[index], self.x + 10, self.y + 8 + (index - 1) * titleFont:getHeight())
    end
    local closeX, closeY = self.x + width - 46, self.y + 4
    love.graphics.setColor(self.closebuttondown and dark or {0.16, 0.36, 0.56})
    love.graphics.rectangle('fill', closeX, closeY, 42, 42)
    love.graphics.setColor(white)
    love.graphics.setLineWidth(3)
    love.graphics.line(closeX + 13, closeY + 13, closeX + 29, closeY + 29)
    love.graphics.line(closeX + 29, closeY + 13, closeX + 13, closeY + 29)
    love.graphics.setLineWidth(1)

    love.graphics.setColor(0.88, 0.91, 0.93)
    love.graphics.setFont(ST.f.alphabeta)
    local textH = #self.lines * font:getHeight()
    local VH = self.bounds.y - 50
    self.textHitAreas = {}

    for i, line in ipairs(self.lines) do
        local liney = ((self.y + (i - 1) * font:getHeight())+50) + self.scroll
        if liney < self.y + self.bounds.y and liney > self.y + 49 then
            local hoveredLine = false
            local hoverX = self.x + 5
            for _, word in ipairs(line.words) do
                if word.spaceBefore then hoverX = hoverX + font:getWidth(' ') end
                local wordWidth = font:getWidth(word.text)
                if word.red and GMX >= hoverX and GMX <= hoverX + wordWidth
                    and GMY >= liney and GMY <= liney + font:getHeight() then
                    hoveredLine = true
                end
                hoverX = hoverX + wordWidth
            end

            local lineX = self.x + 5
            for _, word in ipairs(line.words) do
                if word.spaceBefore then lineX = lineX + font:getWidth(' ') end
                local wordWidth = font:getWidth(word.text)
                if word.red then
                    if hoveredLine then
                        love.graphics.setColor(0.31, 0.45, 0.62)
                    else
                        love.graphics.setColor(0.31, 0.65, 0.76)
                    end
                else
                    love.graphics.setColor(0.88, 0.91, 0.93)
                end
                love.graphics.print(word.text, lineX, liney)
                if word.clickable then
                    table.insert(self.textHitAreas, {
                        sectionText = word.sectionText,
                        x = lineX,
                        y = liney,
                        width = wordWidth,
                        height = font:getHeight()
                    })
                end
                lineX = lineX + wordWidth
            end
        end
    end
    
    love.graphics.setColor(dark)
    love.graphics.rectangle('line', self.x + 3, self.y + 3, width - 6, height - 6)
    love.graphics.setColor(1, 1, 1)
    if textH > VH then
        local trackX = self.x + self.bounds.x + 8
        local trackY = self.y + 50
        local trackHeight = VH
        local thumbHeight = math.max(16, trackHeight * VH / textH)
        local mScroll = textH - VH
        local thumbY = trackY + (-self.scroll / mScroll) * (trackHeight - thumbHeight)
        
        love.graphics.setColor(navy)
        love.graphics.rectangle('line', trackX, trackY, 8, trackHeight)
        love.graphics.rectangle('fill', trackX, thumbY, 8, thumbHeight)
        love.graphics.setColor(1, 1, 1)
    end
end