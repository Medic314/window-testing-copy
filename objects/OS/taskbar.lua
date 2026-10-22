Taskbar = GameObject:extend()

function Taskbar:new(area, x, y, opts)
    Taskbar.super.new(self, area, x, y, opts)
    self.layer = 'taskbar'
    self.height = 70
end

function Taskbar:draw()
    local y = gh - self.height

    love.graphics.setFont(ST.f.alphabeta)

    love.graphics.setColor(0.08, 0.10, 0.13, 0.96)
    love.graphics.rectangle('fill', 0, y, gw, self.height)
    love.graphics.setColor(0.30, 0.38, 0.46, 1)
    love.graphics.rectangle('fill', 0, y, gw, 2)

    love.graphics.setColor(0.16, 0.20, 0.25, 1)
    love.graphics.rectangle('fill', 16, y + 8, 126, 44)
    love.graphics.setColor(0.88, 0.91, 0.94, 1)
    love.graphics.printf(OSD:upper(), 16, y + 20, 126, 'center')

    love.graphics.printf("9:00 AM", gw - 240, y + 11, 200, 'left')
    love.graphics.setColor(0.66, 0.71, 0.76, 1)
    love.graphics.printf('Jan '.. Day+3 ..'th, 20XX', gw - 240, y + 32, 300, 'left')
    love.graphics.setColor(1, 1, 1, 1)
end
