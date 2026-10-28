GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.area = area
    self.x, self.y = x, y
    self.id = UUID()
    self.creation_time = love.timer.getTime()
    self.timer = Timer()
    self.dead = false
    self.depth = 50
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:startWindowAnimation()
    self.windowAnimationProgress = 0
    self.windowAnimationState = 'opening'
end

function GameObject:updateWindowAnimation(dt)
    if not self.windowAnimationState then return false end

    local duration = 0.08
    local direction = self.windowAnimationState == 'closing' and -1 or 1
    self.windowAnimationProgress = math.max(0, math.min(1, self.windowAnimationProgress + direction * dt / duration))

    if self.windowAnimationState == 'closing' and self.windowAnimationProgress == 0 then
        self.dead = true
        if FocusHis then
            local focusIndex = findFocus and findFocus(self.id)
            if focusIndex and focusIndex > 0 then table.remove(FocusHis, focusIndex) end
        end
        if Focus == self.id then Focus = FocusHis and FocusHis[#FocusHis] or nil end
        return true
    end

    if self.windowAnimationState == 'opening' and self.windowAnimationProgress == 1 then
        self.windowAnimationState = nil
    end
    return self.windowAnimationState ~= nil
end

function GameObject:closeWindow()
    if self.windowAnimationState ~= 'closing' then
        self.windowAnimationState = 'closing'
    end
end

function GameObject:beginWindowDraw()
    if not self.windowAnimationState then return false end

    local progress = self.windowAnimationProgress
    local easedProgress = progress * progress * (3 - 2 * progress)
    local scale = 0.94 + 0.06 * easedProgress
    local centerX = self.x + (self.bounds and self.bounds.x or 0) / 2
    local centerY = self.y + (self.bounds and self.bounds.y or 0) / 2

    love.graphics.push()
    love.graphics.translate(centerX, centerY)
    love.graphics.scale(scale, scale)
    love.graphics.translate(-centerX, -centerY)
    love.graphics.translate(0, (1 - easedProgress) * -8)
    return true
end

function GameObject:endWindowDraw(animated)
    if animated then love.graphics.pop() end
end

function GameObject:draw()

end

function GameObject:destroy()
    self.timer:destroy()
    if self.collider then self.collider:destroy() end
    if self.icollider then self.icollider:destroy() end
    if self.ficollider then self.ficollider:destroy() end
    self.collider = nil
    self.icollider = nil
    self.ficollider = nil
end