Button = GameObject:extend()

function Button:new(area, x, y, opts)
    Button.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.w = opts.w or 100
    self.h = opts.h or 100
    self.x = x
    self.y = y
    self.type = opts.type or 't'
    self.mID = opts.mID or nil
    self.memos = opts.memos
    self.memos2 = opts.memos2
    self.memos3 = opts.memos3
    self.password = opts.password
    self.passwordKey = opts.passwordKey
    self.title = opts.title or 'WHat'
    print(self.type)
    print(self.mID)

    --[[self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass("Desktop Button")
    self.collider:setType('static')
    self.collider:setObject(self)]]--
end

function Button:update(dt)
    if input:pressed('lmb') then
        self.collider = self.area.world:queryRectangleArea(self.x, self.y, self.w, self.h, {'Mouse'})
        if self.collider[1] then
            if self.type == 'e' then
                gotoRoom('Stage')
            else
                self.area:addGameObject(self.type .. 'Window', self.x, self.y, {
                    mID = self.mID,
                    memos = self.memos,
                    memos2 = self.memos2,
                    memos3 = self.memos3,
                    password = self.password,
                    passwordKey = self.passwordKey
                })
            end
        end
    end
end

function Button:draw()
    if self.type == 'm' and self.mID == 'memo' then
        love.graphics.draw(ST.files, self.x, self.y)
    elseif self.type == 'm' and self.mID == 'email' then
        love.graphics.draw(ST.email, self.x, self.y)
    elseif self.type == 't' then
        love.graphics.draw(ST.txt, self.x, self.y)
    elseif self.type == 'p' then
        love.graphics.draw(ST.image, self.x, self.y)
    else
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end
    if self.type ~= 'e' then
        love.graphics.draw(ST.shortcut, self.x, self.y+75)
    end
    love.graphics.setFont(ST.f.alphabetaSmall)
    if self.title then love.graphics.printf(self.title, self.x-10, self.y+100-5, 125, 'center') end
    love.graphics.setFont(ST.f.alphabeta)
end