Progressor = GameObject:extend()

function Progressor:new(area, x, y, opts)
    Progressor.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = 0
    self.Y = 0
end

function Progressor:update(dt)
    if timePulse then
        Time = Time + 1
        if Time > 4 then
            Time = 1
            Day = Day + 1
        end
        timePulse = false
    end
end

function Progressor:draw()
    --love.graphics.print(Day, camera.x-gw/2, camera.y-gh/2)
    --love.graphics.print(timelist[Time], camera.x-gw/2, camera.y-gh/2+20)
end