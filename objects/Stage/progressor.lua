Progressor = GameObject:extend()

function Progressor:new(area, x, y, opts)
    Progressor.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = 0
    self.Y = 0
end

function Progressor:update(dt)
    if timePulse then
        self.area:addGameObject('Transition', 0, 0, {type = 'time'})
        if Time+1 > 5 then
            Time = 1
            --Day = Day + 1
        else
            Time = Time + 1
        end
        if Time == 2 or Time == 4 then
            ATDoorlock, TDoorlock, RDoorlock = true, true, true
        elseif Time == 5 then 
            ATDoorlock = false 
        else 
            ATDoorlock, TDoorlock, RDoorlock = false, false, false 
        end
        timePulse = false
        print(Day, Time)
    end
    if notifpulse then 
        self.area:addGameObject('Notification', 0, 0, {text=notifpulse})
        notifpulse = nil
    end
end

function Progressor:draw()
    --love.graphics.print(Day, camera.x-gw/2, camera.y-gh/2)
    --love.graphics.print(timelist[Time], camera.x-gw/2, camera.y-gh/2+20)
end