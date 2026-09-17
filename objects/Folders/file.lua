file = GameObject:extend()

function file:new(area, x, y, opts)
    file.super.new(self, area, x, y, opts)
    self.layer = 'foreground'
    self.w = opts.w or 600
    self.h = opts.h or 800
    self.sw = self.w*1.2
    self.sh = self.h*1.2
    self.x = x
    self.y = y
    self.info = opts.info or FT[1]
    self.scale = 1.2
    filelock = true
end

function file:update(dt)
    self.sw = self.w*self.scale
    self.sh = self.h*self.scale
    if input:pressed('lmb') or input:down('lmb') then
        self.scale = 2
    else
        self.scale = 1.2
    end
    if input:pressed('space') or input:pressed('escape') then
        filelock = false
        self.dead = true
    end
end

function file:draw()
    local MX, MY = love.mouse.getPosition()
    love.graphics.rectangle('line', (1920/2)-self.sw/2, (1080/2)-self.sh/2, self.w, self.h)
    if self.scale == 1.2 then
        love.graphics.draw(self.info, ((1920/2)-self.sw/2)-((MX-1920/2)/32)*-1, ((1080/2)-self.sh/2)-((MY-1080/2)/32)*-1, 0, self.scale, self.scale)
    else
        love.graphics.draw(self.info, ((1920/2)-self.sw/2)-((MX-1920/2)), ((1080/2)-self.sh/2)-((MY-1080/2)), 0, self.scale, self.scale)
    end
end