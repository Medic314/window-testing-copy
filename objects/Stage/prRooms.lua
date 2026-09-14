prRooms = GameObject:extend()

function prRooms:new(area, x, y, opts)
    prRooms.super.new(self, area, x, y, opts)
    self.layer = 'background'

    self.x = 0
    self.y = 0
    self.rid = opts.rid or 'main'
    self.idr = self.id
    currentRoom = self.rid

    if self.rid == 'main' then
        Camerascroll = false
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', ((1920*0.8)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.8)/2)-50, {w=(1920*0.8), h=50, idr=self.id})

        self.area:addGameObject('Texttester', -500, -300, {idr = self.id, textline = {TT.main.mtext1}})
        self.area:addGameObject('Texttester', -400, -300, {idr = self.id, textline = {TT.main.mtext2}})
        self.area:addGameObject('Texttester', -300, -300, {idr = self.id, textline = {TT.main.mtext3, TT.main.mtext32, TT.main.mtext33}})
        self.area:addGameObject('Texttester', -100, -300, {idr = self.id, textline = {TT.main.mtext4}})
        self.area:addGameObject('Computer', 300, 300, {idr = self.id})
        self.area:addGameObject('Door', 600, 0, {room = 'hallway', idr=self.id})
    elseif self.rid == 'hallway' then
        Camerascroll = true
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', ((1920*1.2)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.6)/2), {w=(1920*1.2), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.6)/2)-50, {w=(1920*1.2), h=50, idr=self.id})

        self.area:addGameObject('Door', -500+150, ((1080*0.6)/2)-50, {room = 'ATroom', idr=self.id})
        self.area:addGameObject('Door', 0+150, ((1080*0.6)/2)-50, {room = 'TSroom', idr=self.id})
        self.area:addGameObject('Door', 500+150, ((1080*0.6)/2)-50, {room = 'Rroom', idr=self.id})

        self.area:addGameObject('Door', -500, 0, {room = 'main', idr=self.id})
    elseif self.rid == 'closet' then
    elseif self.rid == 'stairs' then
    elseif self.rid == 'ATroom' then
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', ((1920*0.8)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.8)/2)-50, {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Door', 600, 0, {room = 'hallway', idr=self.id})
    elseif self.rid == 'TSroom' then
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', ((1920*0.8)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.8)/2)-50, {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Door', 600, 0, {room = 'hallway', idr=self.id})
    elseif self.rid == 'Rroom' then
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', ((1920*0.8)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.8)/2), {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.8)/2)-50, {w=(1920*0.8), h=50, idr=self.id})
        self.area:addGameObject('Door', 600, 0, {room = 'hallway', idr=self.id})
    elseif self.rid == 'Croom' then
    end
end

function prRooms:update(dt)
    if doorPulse then
        Cull = self.idr
        self.area:addGameObject('prRooms', 0, 0, {rid=doorPulse})
        doorPulse = nil
    end
    if Cull == self.idr then
        self.dead = true
    end

    if input:pressed('1') then
        Cull = self.id
        self.area:addGameObject('prRooms', 0, 0, {rid='main'})
    end
    if input:pressed('2') then
        Cull = self.id
        self.area:addGameObject('prRooms', 0, 0, {rid='hallway'})
    end
end

function prRooms:draw()

end