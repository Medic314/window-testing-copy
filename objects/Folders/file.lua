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
    local imageX = ((1920/2)-self.sw/2)-((MX-1920/2)/32)*-1
    local imageY = ((1080/2)-self.sh/2)-((MY-1080/2)/32)*-1
    if self.scale == 1.2 then
        love.graphics.setColor(0.04, 0.05, 0.06, 0.65)
        love.graphics.rectangle('fill', imageX + 12, imageY + 12, self.sw, self.sh)
        love.graphics.setColor(0.88, 0.85, 0.76)
        love.graphics.rectangle('fill', imageX - 8, imageY - 8, self.sw + 16, self.sh + 16)
        love.graphics.setColor(0.25, 0.28, 0.28)
        love.graphics.rectangle('line', imageX - 8, imageY - 8, self.sw + 16, self.sh + 16)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.info, imageX, imageY, 0, self.scale, self.scale)
    else
        imageX = ((1920/2)-self.sw/2)-((MX-1920/2))
        imageY = ((1080/2)-self.sh/2)-((MY-1080/2))
        love.graphics.setColor(0.04, 0.05, 0.06, 0.65)
        love.graphics.rectangle('fill', imageX + 12, imageY + 12, self.sw, self.sh)
        love.graphics.setColor(0.88, 0.85, 0.76)
        love.graphics.rectangle('fill', imageX - 8, imageY - 8, self.sw + 16, self.sh + 16)
        love.graphics.setColor(0.25, 0.28, 0.28)
        love.graphics.rectangle('line', imageX - 8, imageY - 8, self.sw + 16, self.sh + 16)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.info, imageX, imageY, 0, self.scale, self.scale)
    end
    love.graphics.setColor(1, 1, 1)
end