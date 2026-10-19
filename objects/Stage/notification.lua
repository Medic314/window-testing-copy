Notification = GameObject:extend()

function Notification:new(area, x, y, opts)
    Notification.super.new(self, area, x, y, opts)
    opts = opts or {}
    self.layer = 'ui'
    self.offsetX, self.offsetY = x or 0, y or 0
    self.text = tostring(opts.text or opts.message or '')
    self.font = ST.f.alphabeta
    self.width = opts.width or 480
    self.padding = 18
    local _, lines = self.font:getWrap(self.text, self.width - 88)
    self.lines = lines
    self.height = math.max(72, #lines * self.font:getHeight() + self.padding * 2)
    self.enterDuration = 0.4
    self.holdDuration = opts.duration or 2.5
    self.exitDuration = 0.35
    self.elapsed = 0
end

function Notification:update(dt)
    self.elapsed = self.elapsed + dt
    if self.elapsed >= self.enterDuration + self.holdDuration + self.exitDuration then
        self.dead = true
    end
end

function Notification:draw()
    local left = camera.x - gw / 2 + 32 + self.offsetX
    local top = camera.y - gh / 2 + 32 + self.offsetY
    local x

    if self.elapsed < self.enterDuration then
        local progress = self.elapsed / self.enterDuration
        progress = 1 - (1 - progress) ^ 3
        x = left - self.width - 24 + (self.width + 24) * progress
    elseif self.elapsed < self.enterDuration + self.holdDuration then
        x = left
    else
        local progress = (self.elapsed - self.enterDuration - self.holdDuration) / self.exitDuration
        x = left - (self.width + 24) * progress ^ 3
    end

    love.graphics.setColor(0.08, 0.09, 0.1, 0.96)
    love.graphics.rectangle('fill', x, top, self.width, self.height)
    love.graphics.setColor(0.08+0.1, 0.18+0.1, 0.29+0.1, 1)
    love.graphics.polygon('fill', x, top, x + 24, top, x + 40, top + self.height, x + 16, top + self.height)

    local previousFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1, 1)
    for i, line in ipairs(self.lines) do
        love.graphics.print(line, x + 56, top + self.padding + (i - 1) * self.font:getHeight())
    end
    love.graphics.setFont(previousFont)
    love.graphics.setColor(1, 1, 1, 1)
end