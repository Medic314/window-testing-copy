CComment = GameObject:extend()

function CComment:new(area, x, y, opts)
    CComment.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.input = opts.input or nil
    self.font = opts.font or ST.f.alphabeta
    self.maxWidth = opts.maxWidth or 320*2
    self.padding = opts.padding or 10
    self.text = ''
    self.lines = {}
    self.w = self.padding * 2
    self.h = self.padding * 2
    self.x = GMX + 20
    self.y = GMY - 50
    self.revealedChars = 0
    self.revealTimer = 0
    self.totalChars = 0
    print(self.input)
end

function CComment:update(dt)
    local response = CT[self.input] or ''
    if response ~= self.text then
        self.text = response
        local _, lines = self.font:getWrap(self.text, self.maxWidth - self.padding * 2)
        self.lines = lines
        self.revealedChars = 0
        self.revealTimer = 0
        self.totalChars = 0
        for _, line in ipairs(self.lines) do
            self.totalChars = self.totalChars + #line
        end

        local textWidth = 0
        for _, line in ipairs(self.lines) do
            textWidth = math.max(textWidth, self.font:getWidth(line))
        end
        self.w = textWidth + self.padding * 2
        self.h = #self.lines * self.font:getHeight() + self.padding * 2
    end
    self.revealTimer = self.revealTimer + dt
    while self.revealTimer >= 0.02 and self.revealedChars < self.totalChars do
        self.revealTimer = self.revealTimer - 0.02
        self.revealedChars = self.revealedChars + 1
    end
    if input:pressed('lmb') then
        self.colliders = self.area.world:queryRectangleArea(self.x, self.y, self.w, self.h, {'Mouse'})
        if self.colliders[1] then
            self.dead = true
        end
    end
end

function CComment:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    local remainingChars = self.revealedChars
    for index, line in ipairs(self.lines) do
        love.graphics.print(line:sub(1, math.min(#line, math.max(0, remainingChars))), self.x + self.padding, self.y + self.padding + (index - 1) * self.font:getHeight())
        remainingChars = remainingChars - #line
    end
end