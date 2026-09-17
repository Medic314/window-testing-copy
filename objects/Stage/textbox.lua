Textbox = GameObject:extend()

function Textbox:new(area, x, y, opts)
    Textbox.super.new(self, area, x, y, opts)
    self.layer = 'foreground'
    --self.x, self.y = camera:toWorldCoords(x, y)
    self.w, self.h = gw-gw/6, gh/5
    self.x, self.y = x-self.w/2, y+self.h/1
    movelock, inputlock = true, true

    love.graphics.setFont(ST.f.alphabetaBig)
    self.charsize = 16
    self.bounds = {x = self.w, y = self.h}
    
    self.textline = opts.textline or {TT.placeholder.ptext1, TT.placeholder.ptext2, TT.placeholder.ptext3, TT.placeholder.ptext4}
    self.selectedtext = 1
    self.text = self.textline[self.selectedtext]
    self.lines = self:wrapText(self.text, self.bounds.x)
end

function Textbox:wrapText(text, maxWidth)
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

function Textbox:update(dt)
    self.x, self.y = camera.x-self.w/2, camera.y+self.h/1
    if input:pressed('next') then
        self.selectedtext = self.selectedtext + 1
        if self.selectedtext > #self.textline then
            movelock, inputlock = false, false
            self.dead = true
        else
            self.text = self.textline[self.selectedtext]
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
    end
end

function Textbox:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', self.x-50, self.y-50, self.w+100, self.h+100)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x-50, self.y-50, self.w+100, self.h+100)

    love.graphics.setFont(ST.f.alphabetaBig)
    local font = love.graphics.getFont()

    for i, line in ipairs(self.lines) do
        local liney = ((self.y + (i - 1) * font:getHeight())+1)
        if liney < self.y + self.bounds.y and liney > self.y then
            love.graphics.print(line, self.x, liney)
        end
    end
end