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
    self.optionWidth = self.bounds.x/4+25
    self.imagelock = false

    self.func = opts.func or nil
    
    self.textline = opts.textline or {TT.placeholder.ptext1, TT.placeholder.ptext2, TT.placeholder.ptext3, TT.placeholder.ptext4}
    self.data = opts.data or nil
    self.selectedtext = 1
    self.portrait = nil
    self:showStep(self.textline[self.selectedtext])
end

function Textbox:parseChoice(step)
    if type(step) ~= "table" or type(step[1]) ~= "string" or type(step[2]) ~= "string" then
        return nil
    end

    local options = {}
    for i=2, #step do
        if type(step[i]) ~= "string" then return nil end
        table.insert(options, step[i])
    end
    return step[1], options
end

function Textbox:showStep(step)
    local prompt, options = self:parseChoice(step)
    self.options = options
    self.marker = options and 1 or nil
    self.elines = nil
    self.imagelock = false
    self.i = nil

    if options then
        self.text = prompt
    else
        self.text = step
        if type(step) ~= "string" then
            self.imagelock = true
            self.i = step
        end
    end

    if type(self.text) == "string" then
        if self.options then
            self.lines = self:wrapText(self.text, (self.bounds.x/4)*3-25)
            self.elines = {}
            for i=1, #self.options do
                table.insert(self.elines, self:wrapText(self.options[i], self.optionWidth, true))
            end
        else
            self.lines = self:wrapText(self.text, self.bounds.x)
        end
    else
        self.lines = {}
    end
    self:resetReveal()
end

function Textbox:finish(callFunc)
    movelock, inputlock = false, false
    if callFunc ~= false and self.func then self.func() end
    self.dead = true
    self.imagelock = false
end

function Textbox:handleAction(step)
    if type(step) ~= "table" then return false end

    if step[1] == 'OS' then
        if self.data then OSD = self.data end
        self:finish()
        gotoRoom('OS')
        savestate()
        movelock, inputlock = false, false
        return true
    elseif step[1] == 'Folders' then
        if self.data then FolderD = self.data end
        self:finish()
        gotoRoom('Folders')
        savestate()
        return true
    elseif step[1] == 'PassTime' then
        if Day == 1 and Time == 2 then
            self:finish()
            if GV.day1.rollcall.Rspoke and GV.day1.rollcall.TSspoke and GV.day1.rollcall.ATspoke then
                timePulse = true
                gamestate()
                return true
            else
                self.area:addGameObject('Textbox', camera.x, camera.y, {textline = {TT.main.rollcallerror}})
            end
        end
    elseif step[1] == nil then
        self:finish()
    end
    return false
end

function Textbox:resetReveal()
    self.revealedChars = 0
    self.revealTimer = 0
    self.totalChars = 0
    for _, line in ipairs(self.lines or {}) do
        self.totalChars = self.totalChars + #line
    end
    for _, lines in ipairs(self.elines or {}) do
        for _, line in ipairs(lines) do
            self.totalChars = self.totalChars + #line
        end
    end
end

function Textbox:wrapText(text, maxWidth, p)
    local font = love.graphics.getFont()
    local lines = {}
    local currentLine = ""
    if not p then 
        self.portrait = nil 
        self.l = nil
    end

    for word in text:gmatch("%S+") do
        if word ~= '[]' and word ~= '[[]]' and word ~= '.C.' and word ~= '.A.' and word ~= '.T.' and word ~= '.R.' and word ~= '^C' then
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
            elseif word == '[]' then
                table.insert(lines, currentLine)
                currentLine = ""
            else
                if word == '.C.' then
                    currentLine = ""
                    self.portrait = ST.CaliP
                    self.l = true
                end
                if word == '.A.' then
                    currentLine = ""
                    self.portrait = ST.ATP
                end
                if word == '.T.' then
                    currentLine = ""
                    self.portrait = ST.TSP
                end
                if word == '.R.' then
                    currentLine = ""
                    self.portrait = ST.RP
                end

                if word == '^C' then
                    currentLine = ""
                    self.i = nil
                    self.imagelock = nil
                end
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
    self.revealTimer = self.revealTimer + dt
    while self.revealTimer >= 0.02 and self.revealedChars < self.totalChars do
        self.revealTimer = self.revealTimer - 0.02
        self.revealedChars = self.revealedChars + 1
    end
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
        if self.revealedChars < self.totalChars then
            self.revealedChars = self.totalChars
            self.revealTimer = 0
        else
            if self.options then
                local choiceIndex = self.selectedtext
                local nextStep = self.textline[choiceIndex + 1]
                local isBranchGroup = type(nextStep) == "table" and #nextStep == #self.options
                if isBranchGroup then
                    for i=1, #nextStep do
                        if type(nextStep[i]) ~= "table" then
                            isBranchGroup = false
                            break
                        end
                    end
                end

                if isBranchGroup then
                    self.textline = nextStep[self.marker]
                    self.selectedtext = 1
                    self:showStep(self.textline[self.selectedtext])
                else
                    local selectedStep = self.textline[choiceIndex + self.marker]
                    if not selectedStep then
                        self:finish()
                    elseif self:handleAction(selectedStep) then
                        return
                    else
                        self.selectedtext = choiceIndex + self.marker
                        self:showStep(selectedStep)
                    end
                end
            else
                self.selectedtext = self.selectedtext + 1
                local nextStep = self.textline[self.selectedtext]
                if not nextStep then
                    self:finish()
                elseif self:handleAction(nextStep) then
                    return
                else
                    self:showStep(nextStep)
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
    if self.portrait then
        love.graphics.setColor(1, 1, 1)
        if self.l then love.graphics.draw(self.portrait, camera.x-self.portrait:getWidth()*1.3, camera.y-self.portrait:getHeight()/2) else love.graphics.draw(self.portrait, camera.x-self.portrait:getWidth()*-0.3, camera.y-self.portrait:getHeight()/2) end
    end
    if type(self.text) == "string" then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', self.x-50, self.y-50, self.w+100, self.h+100)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('line', self.x-50, self.y-50, self.w+100, self.h+100)

        love.graphics.setFont(ST.f.alphabetaBig)
        local font = love.graphics.getFont()
        local remainingChars = self.revealedChars
        for i, line in ipairs(self.lines) do
            local liney = ((self.y + (i - 1) * font:getHeight())+1)
            if liney < self.y + self.bounds.y and liney > self.y then
                love.graphics.print(line:sub(1, math.min(#line, math.max(0, remainingChars))), self.x, liney)
            end
            remainingChars = remainingChars - #line
        end
        if self.options then
            local optionOffset = 0
            for j=1, #self.elines do
                local optionY = self.y + optionOffset
                if j == self.marker then
                    love.graphics.print('>', self.x+((self.bounds.x/4)*3), optionY+1)
                end
                for i, line in ipairs(self.elines[j]) do
                    local liney = optionY + (i - 1) * font:getHeight() + 1
                    if liney < self.y + self.bounds.y and liney > self.y then
                        love.graphics.print(line:sub(1, math.min(#line, math.max(0, remainingChars))), self.x+((self.bounds.x/4)*3)+25, liney)
                    end
                    remainingChars = remainingChars - #line
                end
                optionOffset = optionOffset + 75 + math.max(0, #self.elines[j]-1)*font:getHeight()
            end
        end
    end
end