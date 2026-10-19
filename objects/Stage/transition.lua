Transition = GameObject:extend()

function Transition:new(area, x, y, opts)
    Transition.super.new(self, area, x, y, opts)
    self.layer = 'menu2'
    self.X = -2000
    self.Y = -2000
    self.W, self.H = 5000, 5000
    self.A = {A = 0}
    self.type = opts.type or 'door'
    local i
    if self.type == 'time' then i = 1.5 else i = 1 end
    doorlock = true
    if self.type == 'door' then timer:tween(0.15, self.A, {A = 1}, 'in-quad') else self.A.A = 1 end
    timer:after(0.15*i, function()
        self.A.A = 1
    timer:tween(0.175*i, self.A, {A = 0}, 'in-quad')
    timer:after(0.175*i, function() self.dead = true doorlock = nil end) end)
end

function Transition:update(dt)
end

function Transition:draw()
    love.graphics.setColor(0, 0, 0, self.A.A)
    love.graphics.rectangle('fill', self.X, self.Y, self.W, self.H)
    love.graphics.setColor(1, 1, 1)
end