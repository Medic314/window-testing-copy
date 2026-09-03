Background = GameObject:extend()

function Background:new(area, x, y, opts)
    Background.super.new(self, area, x, y, opts)
    self.layer = 'backerground'
    self.x = x
    self.y = y
    self.image = love.graphics.newImage('assets/basewallpaper.png')
end

function Background:update(dt)

end

function Background:draw()
    --love.graphics.draw(self.image, 0, 0)
end