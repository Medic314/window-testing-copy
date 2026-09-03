tWindow = GameObject:extend()

function tWindow:new(area, x, y, opts)
    tWindow.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = gw/2
    self.y = gh/2
    love.graphics.setFont(ST.f.alphabeta)
    self.charsize = 16
    self.bounds = {x = 800, y = 400}
    self.text = opts.text or TT.placeholder.ptext1
    self.lines = self:wrapText(self.text, self.bounds.x)
    self.dragging = false
    self.scroll = 0
end

function tWindow:wrapText(text, maxWidth)
    local font = love.graphics.getFont()
    local lines = {}
    local currentLine = ""

    for word in text:gmatch("%S+") do
        if word ~= '[]' and word ~= '[[]]' then
            local candidate = currentLine == "" and word or currentLine .. " " .. word
            if font:getWidth(candidate) <= maxWidth then
                currentLine = candidate
            else
                if currentLine ~= "" then
                    table.insert(lines, currentLine)
                end
                currentLine = word
            end
        else
            if word == '[[]]' then
                table.insert(lines, currentLine)
                currentLine =  ""
                table.insert(lines, currentLine)
                currentLine = ""
            else
                table.insert(lines, currentLine)
                currentLine = ""
            end
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return lines
end

function tWindow:update(dt)
    if Focus == self.id then self.layer = "main layer" else self.layer = 'background' end
    local font = love.graphics.getFont()
    local textH = #self.lines * font:getHeight()
    local VH = self.bounds.y - 50
    local mScroll = math.max(0, textH - VH)
    self.colliders = self.area.world:queryRectangleArea(self.x, self.y, self.bounds.x+25, self.bounds.y+16, {'Mouse'})

    if self.scroll > 0 then self.scroll = 0 end
    if self.scroll < -mScroll then self.scroll = -mScroll end

    if input:pressed('lmb') then
        if self.colliders[1] then
            Focus = self.id
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
                if (GMY < self.y + 50) and GMX > self.x+50 then
                    self.dragging = true
                end
            end
            if input:pressed('lmb') then
                if (GMY < self.y + 50) and GMX < self.x+50 then
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
end

function tWindow:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.bounds.x+25, self.bounds.y+16)
    love.graphics.setColor(1, 1, 1)
    
    love.graphics.setFont(ST.f.alphabeta)
    local font = love.graphics.getFont()
    local textH = #self.lines * font:getHeight()
    local VH = self.bounds.y - 50

    for i, line in ipairs(self.lines) do
        local liney = ((self.y + (i - 1) * font:getHeight())+50) + self.scroll
        if liney < self.y + self.bounds.y and liney > self.y + 49 then
            love.graphics.print(line, self.x, liney)
        end
    end

    love.graphics.rectangle('line', self.x, self.y, self.bounds.x+25, self.bounds.y+16)

    local down
    if self.closebuttondown then down = 'fill' else down = 'line' end
    love.graphics.rectangle('line', self.x, self.y, self.bounds.x+25, 50)
    love.graphics.rectangle(down, self.x, self.y, 50, 50)

    if textH > VH then
        local trackX = self.x + self.bounds.x + 8
        local trackY = self.y + 50
        local trackHeight = VH
        local thumbHeight = math.max(16, trackHeight * VH / textH)
        local mScroll = textH - VH
        local thumbY = trackY + (-self.scroll / mScroll) * (trackHeight - thumbHeight)

        love.graphics.rectangle('line', trackX, trackY, 8, trackHeight)
        love.graphics.rectangle('fill', trackX, thumbY, 8, thumbHeight)
    end
end