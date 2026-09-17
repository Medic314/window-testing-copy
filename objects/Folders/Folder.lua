Folder = GameObject:extend()

function Folder:new(area, x, y, opts)
    Folder.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.w = opts.w or 70
    self.h = opts.h or 900
    self.x = x
    self.y = y
    self.info = opts.info or FT[1]
end

function Folder:update(dt)
    if not filelock then
        if input:pressed('lmb') then
            self.collider = self.area.world:queryRectangleArea(self.x, self.y, self.w, self.h, {'Mouse'})
            if self.collider[1] then
                self.area:addGameObject('file', self.x, self.y, {info=self.info})
            end
        end
    end
end

function Folder:draw()
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end