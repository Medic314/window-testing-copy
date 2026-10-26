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
        self.area:addGameObject('Wall', -((1920*0.8)/2)-100, -((1080*0.8)/2), {w=50, h=(1080*0.4), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), 0, {w=50, h=(1080*0.4), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2)-100, 0, {w=100, h=50, idr=self.id})
        self.area:addGameObject('Wall', ((1920*0.8)/2)-50, -((1080*0.8)/2), {w=50, h=(1080*0.8), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2)-100, -((1080*0.8)/2), {w=(1920*0.8)+100, h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.8)/2)-50, {w=(1920*0.8), h=50, idr=self.id})
        
        self.area:addGameObject('Wall', -525+75, -375, {w=500, h=150, idr=self.id})
        self.area:addGameObject('Texttester', -500+75, -300, {idr = self.id, textline = {TT.main.coffee}})
        self.area:addGameObject('Texttester', -400+75, -300, {idr = self.id, textline = {TT.main.papers}})
        self.area:addGameObject('Texttester', -300+75, -300, {idr = self.id, textline = {TT.main.sampaper, TT.main.sampaper2, TT.main.sampaper3}})
        self.area:addGameObject('Texttester', -100+75, -300, {idr = self.id, textline = {TT.main.object}})
        
        self.area:addGameObject('Texttester', -((1920*0.8)/2), 100, {idr = self.id, textline = {TT.main.poster}})
        self.area:addGameObject('Texttester', -510, -375, {idr = self.id, textline = {TT.main.trash}})
        
        --self.area:addGameObject('Texttester', 0, -200, {idr = self.id, textline = {TT.placeholder.ptextopt, {TT.placeholder.ptextopt11, TT.placeholder.ptextopt12}, {TT.placeholder.ptextopt21, {TT.placeholder.ptextopt22}, {TT.placeholder.ptextopt23}}}})

        self.area:addGameObject('Wall', 225, -125, {w=450, h=300, idr=self.id})
        --self.area:addGameObject('Computer', 300, 300, {idr = self.id})
        --self.area:addGameObject('FolderT', 400, 300, {idr = self.id})
        self.area:addGameObject('Door', ((1920*0.8)/2)-50, -300, {room = 'hallway', idr=self.id, position = {-((1920*0.8)/2)+125, 0+25}})
        self.area:addGameObject('Door', -700, -((1080*0.8)/2), {room = 'stairs', idr=self.id, position = {550, 325-150}})
        self.area:addGameObject('Door', -605, ((1080*0.8)/2)-50, {room = 'closet', idr=self.id, position = {0+50, -315+125}})
        if Time == 1 then self.area:addGameObject('FTexttester', -200, ((1080*0.8)/2)-50, {idr = self.id, textline = {TT.main.rollcallstart}, func = function() timePulse = true end}) end
        self.area:addGameObject('Door', -200, ((1080*0.8)/2)-50, {room = 'Croom', idr=self.id, position = {0, -432+100}})
        self.area:addGameObject('Door', 500, ((1080*0.8)/2)-50, {room = 'exit', idr=self.id, position = {0,0}})
    elseif self.rid == 'hallway' then
        Camerascroll = true
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.4)/2), {w=50, h=(1080*0.4), idr=self.id})
        self.area:addGameObject('Wall', ((1920*1)/2)-50, -((1080*0.4)/2), {w=50, h=(1080*0.4), idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), -((1080*0.4)/2), {w=(1920*0.9), h=50, idr=self.id})
        self.area:addGameObject('Wall', -((1920*0.8)/2), ((1080*0.4)/2)-50, {w=(1920*0.9), h=50, idr=self.id})

        self.area:addGameObject('Texttester', ((1920*1)/2)-225, -((1080*0.4)/2)+50, {idr = self.id, w=150, h=75, textline = {TT.hallway.shelf}})
        self.area:addGameObject('Texttester', ((1920*1)/2)-325, -((1080*0.4)/2), {idr = self.id, textline = {TT.hallway.poster, TT.hallway.poster2, TT.hallway.poster3}})
        
        self.area:addGameObject('Texttester', -((1920*0.8)/2)+100, -((1080*0.4)/2), {idr = self.id, textline = {TT.hallway.vest}})
        self.area:addGameObject('Wall', -((1920*0.8)/2)+200, -((1080*0.4)/2)+40, {w=225, h=60, idr=self.id})
        
        self.area:addGameObject('Texttester', 475, ((1080*0.4)/2)-100, {idr = self.id, w=75, h=75, textline = {TT.hallway.lilr, TT.hallway.lilr2}})

        if ATDoorlock then
            self.area:addGameObject('Texttester', -500+150, ((1080*0.4)/2)-50, {idr = self.id, textline = {TT.hallway.Alocked}})
        else
            self.area:addGameObject('Door', -500+150, ((1080*0.4)/2)-50, {room = 'ATroom', idr=self.id, position = {0, -432+100}})
        end

        if TDoorlock then
            self.area:addGameObject('Texttester', 0+150, ((1080*0.4)/2)-50, {idr = self.id, textline = {TT.hallway.Tlocked}})
        else
            self.area:addGameObject('Door', 0+150, ((1080*0.4)/2)-50, {room = 'TSroom', idr=self.id, position = {0, -432+100}})
        end

        if RDoorlock then
            self.area:addGameObject('Texttester', 500+150, ((1080*0.4)/2)-50, {idr = self.id, textline = {TT.hallway.Rlocked}})
        else
            self.area:addGameObject('Door', 500+150, ((1080*0.4)/2)-50, {room = 'Rroom', idr=self.id, position = {0, -432+100}})
        end

        self.area:addGameObject('Door', -((1920*0.8)/2), 0, {room = 'main', idr=self.id, position = {((1920*0.8)/2)-50-75, -300+25}})
        
    elseif self.rid == 'closet' then
        Camerascroll = false
        self.area:addGameObject('Wall', -157.5, -315, {w=50, h=630, idr=self.id})
        self.area:addGameObject('Wall', 107.5, -315, {w=50, h=630, idr=self.id})
        self.area:addGameObject('Wall', -157.5, -315, {w=315, h=50, idr=self.id})
        self.area:addGameObject('Wall', -157.5, 265, {w=315, h=50, idr=self.id})

        self.area:addGameObject('Wall', -157.5, 265-75, {w=315, h=50+75, idr=self.id})
        --self.area:addGameObject('FolderT', 107.5-75, 265-125, {idr = self.id})
        --self.area:addGameObject('FolderT', 107.5-125, 265-125, {idr = self.id})
        self.area:addGameObject('Texttester', 107.5-75, 265-125, {idr = self.id, textline = {TT.closet.baseinfo, TT.closet.baseinfo2, TT.closet.baseinfo3, {'Folders', nil}}})
        self.area:addGameObject('Texttester', 107.5-125, 265-125, {idr = self.id, textline = {TT.closet.reginfo, TT.closet.reginfo2, TT.closet.reginfo3, {'Folders', nil}}})

        self.area:addGameObject('Door', 0+25, -315, {room = 'main', idr=self.id, position = {-605+25, 382-100}})
    elseif self.rid == 'stairs' then
        Camerascroll = false
        self.area:addGameObject('Wall', -700, -375+75, {w=50, h=750-150, idr=self.id})
        self.area:addGameObject('Wall', 650, -375+75, {w=50, h=750-150, idr=self.id})
        self.area:addGameObject('Wall', -700, -375+75, {w=1400, h=50, idr=self.id})
        self.area:addGameObject('Wall', -700, 325-75, {w=1400, h=50, idr=self.id})
        
        self.area:addGameObject('Wall', -700+300, -50, {w=1400-300, h=50, idr=self.id})
        
        self.area:addGameObject('Door', 525, 325-75, {room = 'main', idr=self.id, position = {-700+25, -382+100}})
    elseif self.rid == 'ATroom' then
        Camerascroll = false
        self.area:addGameObject('Wall', -432+50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', 382-50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', -432+50, -532+50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Wall', -432+50, 482-50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Texttester', 382-150, -200, {idr = self.id, textline = {TT.atroom.computer, TT.atroom.computer2, {'OS', nil}}})
        self.area:addGameObject('Door', 0-25, -532+50, {room = 'hallway', idr=self.id, position = {-500+150+25, ((1080*0.4)/2)-150}})
    elseif self.rid == 'TSroom' then
        Camerascroll = false
        self.area:addGameObject('Wall', -432+50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', 382-50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', -432+50, -532+50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Wall', -432+50, 482-50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Texttester', 382-150, -200, {idr = self.id, textline = {TT.tsroom.computer, TT.tsroom.computer2, {'OS', nil}}})
        self.area:addGameObject('Door', 0-25, -532+50, {room = 'hallway', idr=self.id, position = {0+150+25, ((1080*0.4)/2)-150}})
    elseif self.rid == 'Rroom' then
        Camerascroll = false
        self.area:addGameObject('Wall', -432+50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', 382-50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', -432+50, -532+50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Wall', -432+50, 482-50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Texttester', 382-150, -200, {idr = self.id, textline = {TT.rroom.computer, TT.rroom.computer2, {'OS', nil}}})
        self.area:addGameObject('Door', 0-25, -532+50, {room = 'hallway', idr=self.id, position = {500+150+25, ((1080*0.4)/2)-150}})
    elseif self.rid == 'Croom' then
        Camerascroll = false
        self.area:addGameObject('Wall', -432+50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', 382-50, -532+50, {w=50, h=964, idr=self.id})
        self.area:addGameObject('Wall', -432+50, -532+50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Wall', -432+50, 482-50, {w=764, h=50, idr=self.id})
        self.area:addGameObject('Texttester', -432+50, 482-50, {w=764, h=50, idr = self.id, textline = {TT.croom.window1, TT.croom.window2, TT.croom.window3}})

        self.area:addGameObject('Texttester', -432+75, -300+25, {h=400, idr = self.id, textline = {TT.croom.pinboard, TT.croom.pinboard2, TT.croom.pinboard3,}})
        self.area:addGameObject('Texttester', -300, -50+25, {w = 100, h = 100, c = '', idr = self.id, textline = {TT.croom.papers}})

        self.area:addGameObject('Texttester', -320, 200, {w = 200, h = 200, c = '', idr = self.id, textline = {TT.croom.refuel}})

        self.area:addGameObject('Wall', 382-150, -350, {h=350, w=100, idr=self.id})
        self.area:addGameObject('Texttester', 382-100, 0, {h=100, w=75, idr = self.id, textline = {TT.croom.box}})

        self.area:addGameObject('Texttester', 382-150, -200, {idr = self.id, textline = {TT.croom.computer, TT.croom.computer2, {'OS', nil}}})

        if not GV.day1.pre.sawEmail then self.area:addGameObject('Texttester', 0-25, -532+50, {idr = self.id, textline = {TT.croom.locked}}) else self.area:addGameObject('Door', 0-25, -532+50, {room = 'main', idr=self.id, position = {-200+25, ((1080*0.8)/2)-150}}) end
    elseif self.rid == 'exit' then
    end
end

function prRooms:update(dt)
    if savepulse then
        --self.area:addGameObject('Notification', 0, 0, {text='Saved!'})
        savepulse = false
    end
    if doorPulse then
        Cull = self.idr
        self.area:addGameObject('prRooms', 0, 0, {rid=doorPulse})
        doorPulse = nil
    end
    if Cull == self.idr then
        self.dead = true
    end

    if input:pressed('1') then
        savestate()
        gamestate()
    end
    if input:pressed('2') then
        --ATDoorlock = not ATDoorlock
        timePulse = true
    end
    if input:pressed('3') then
        Day, Time = 1, 1
        savestate()
        gamestate()
    end
    if input:pressed('4') then
        --RDoorlock = not RDoorlock
        Day, Time = 1, 1
        GameState = {}
        SaveState = {}
        UnlockedFiles = {}
        gamestate()
    end
end

function prRooms:draw()

end