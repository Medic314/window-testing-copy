Fbutton = GameObject:extend()

function Fbutton:new(area, x, y, opts)
    Fbutton.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.w = opts.w or 50
    self.h = opts.h or 50
    self.x = x
    self.y = y
end

function Fbutton:update(dt)
    if input:pressed('lmb') then
        self.collider = self.area.world:queryRectangleArea(self.x, self.y, self.w, self.h, {'Mouse'})
        if self.collider[1] then
            gotoRoom('Stage')
        end
    end
end

function Fbutton:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end