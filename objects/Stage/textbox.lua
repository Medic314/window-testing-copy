Textbox = GameObject:extend()

function Textbox:new(area, x, y, opts)
    Textbox.super.new(self, area, x, y, opts)
    self.layer = 'menu'
    --self.x, self.y = camera:toWorldCoords(x, y)
    self.w, self.h = gw-gw/6, gh/5
    self.x, self.y = x-self.w/2, y+self.h/1
    movelock, inputlock = true, true

    love.graphics.setFont(ST.f.alphabetaBig)
    self.charsize = 16
    self.bounds = {x = self.w, y = self.h}
    self.imagelock = false
    
    self.textline = opts.textline or {TT.placeholder.ptext1, TT.placeholder.ptext2, TT.placeholder.ptext3, TT.placeholder.ptext4}
    self.data = opts.data or nil
    self.selectedtext = 1
    self.text = self.textline[self.selectedtext]
    if self.text[1] then
        self.options = {}
        self.marker = 1
        for i=1, #self.text+1 do
            table.insert(self.options, self.text[i+1])
            print(self.options[i])
        end
        self.text = self.text[1]
    elseif type(self.text) ~= "string" then
        print(type(self.text))
        self.imagelock = true
        self.i = self.text
    end
    if type(self.text) == "string" then
        if self.options then
            self.lines = self:wrapText(self.text, (self.bounds.x/4)*3-25)
            self.elines = {}
            for i=1, #self.options do
                table.insert(self.elines, self:wrapText(self.options[i], self.bounds.x/2-25))
            end
        else
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
    end
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
    if self.options then
        if input:pressed('up') then
            self.marker = self.marker + 1
        end
        if input:pressed('down') then
            self.marker = self.marker - 1
        end
        if self.marker > #self.elines then self.marker = 1 end
        if self.marker < 1 then self.marker = #self.elines end
    end
    if input:pressed('next') then
        self.selectedtext = self.selectedtext + 1
        local STOP = false
        if self.selectedtext > #self.textline then
            movelock, inputlock = false, false
            self.dead = true
            self.imagelock = false
        else
            if self.options then
                print('opts')
                self.selectedtext = self.selectedtext - 1
                self.textline = self.textline[self.selectedtext+self.marker]
                if self.textline == nil then STOP = true movelock, inputlock = false, false self.dead = true self.imagelock = false end
                if not STOP then
                    for i=1, #self.textline do
                        print(self.textline[i])
                        if self.textline[i] == 'OS' then
                            if self.data then
                                OSD = self.data
                            end
                            gotoRoom('OS')
                            SaveState = {
                                PX = PlayerX,
                                PY = PlayerY,
                                Room = currentRoom,
                            }
                            movelock, inputlock = false, false
                            STOP = true
                        elseif self.textline[i] == 'Folders' then
                            if self.data then
                                FolderD = self.data
                            end
                            gotoRoom('Folders')
                            SaveState = {
                                PX = PlayerX,
                                PY = PlayerY,
                                Room = currentRoom,
                            }
                            movelock, inputlock = false, false
                            STOP = true
                        end
                    end
                end
            end
            if not STOP then
                self.options = nil
                self.text = self.textline[self.selectedtext]
                if self.text[1] then
                    self.options = {}
                    self.marker = 1
                    for i=1, #self.text+1 do
                        table.insert(self.options, self.text[i+1])
                        print(self.options[i])
                    end
                    self.text = self.text[1]
                end
                if self.options then
                    self.lines = self:wrapText(self.text, (self.bounds.x/4)*3-25)
                    self.elines = {}
                    for i=1, #self.options do
                        table.insert(self.elines, self:wrapText(self.options[i], self.bounds.x/2-25))
                    end
                else
                    if type(self.text) == 'string' then
                        self.lines = self:wrapText(self.text, self.bounds.x)
                    end
                end
            end
        end
    end
end

function Textbox:draw()
    if self.imagelock and self.i then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.i, camera.x-self.i:getWidth()/2, camera.y-self.i:getHeight()/2)
    end
    if type(self.text) == "string" then
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
        if self.options then
            local markerh = ((self.y + (1-1) * font:getHeight())+1) + (self.marker-1)*75
            love.graphics.print('>', self.x+((self.bounds.x/4)*3), markerh)
            for j=1, #self.elines do
                for i, line in ipairs(self.elines[j]) do
                    local liney = ((self.y + (i - 1) * font:getHeight())+1)
                    if liney < self.y + self.bounds.y and liney > self.y then
                        love.graphics.print(line, self.x+((self.bounds.x/4)*3)+25, liney+(j-1)*75)
                    end
                end
            end
        end
    end
end