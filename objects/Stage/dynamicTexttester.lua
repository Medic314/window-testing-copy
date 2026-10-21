DTexttester = GameObject:extend()

function DTexttester:new(area, x, y, opts)
    DTexttester.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.X = x
    self.Y = y
    self.W = opts.w or 50
    self.H = opts.h or 50
    self.dtid = opts.dtid
    self.idr = opts.idr or self.id
    self.c = opts.c or false
    self.positions = {}

    if self.dtid == 'Arctread' then
        self.W, self.H = 110, 200
        self.positions = {
            day1 = {
                pre = {r='gone', x=1000000, y=1000000, tl={}},
                rollcall = {r='main', x=-500+100, y=-120, tl={TT.arctread.rollcallgreeting1, TT.arctread.rollcallgreeting12, TT.arctread.rollcallgreeting13, {'PassTime', nil}}},
                int = {r='gone', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
        self.func = function() if Day == 1 and Time == 2 then GV.day1.rollcall.ATspoke = true end end
    end
    if self.dtid == 'Tungsten' then
        self.W, self.H = 76, 122
        self.positions = {
            day1 = {
                pre = {r='gone', x=1000000, y=1000000, tl={}},
                rollcall = {r='main', x=-100+75, y=-95, tl={TT.tungsten.rollcallgreeting1, TT.tungsten.rollcallgreeting12, TT.tungsten.rollcallgreeting13, TT.tungsten.rollcallgreeting14, {'PassTime', nil}}},
                int = {r='gone', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
        self.func = function() if Day == 1 and Time == 2 then GV.day1.rollcall.TSspoke = true end end
    end
    if self.dtid == 'Rhenium' then
        self.W, self.H = 80, 135
        self.positions = {
            day1 = {
                pre = {r='gone', x=1000000, y=1000000, tl={}},
                rollcall = {r='main', x=-300+100, y=-100, tl={TT.rhenium.rollcallgreeting1, TT.rhenium.rollcallgreeting12, TT.rhenium.rollcallgreeting13, {{TT.rhenium.rollcallgreeting141, TT.rhenium.rollcallgreeting142, TT.rhenium.rollcallgreeting143, TT.rhenium.rollcallgreeting16, {'PassTime', nil}}, {TT.rhenium.rollcallgreeting151, TT.rhenium.rollcallgreeting152, TT.rhenium.rollcallgreeting153, TT.rhenium.rollcallgreeting16, {'PassTime', nil}}}}},
                int = {r='gone', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
        self.func = function() if Day == 1 and Time == 2 then GV.day1.rollcall.Rspoke = true end end
    end

    self.position = self.positions["day" .. Day][timelist[Time]]
    self.X, self.Y, self.textline = self.position.x, self.position.y, self.position.tl

    if self.c == true then 
        self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
        self.collider:setCollisionClass("Terrain")
        self.collider:setType('static')
        self.collider:setObject(self)
    end

    self.icollider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.icollider:setCollisionClass("Interactable")
    self.icollider:setType('static')
    self.icollider:setObject(self)
    self.icollider.distance = 0
    self.icollider.interacted = false

    self.real = true
end

function DTexttester:update(dt)
    self.position = self.positions["day" .. Day][timelist[Time]]    
    self.X, self.Y, self.textline = self.position.x, self.position.y, self.position.tl
    if currentRoom == self.position.r then self.real = true self.X, self.Y = self.position.x, self.position.y else self.real = false self.X, self.Y = 100000, 1000000 end
    self.icollider:setPosition(self.X+self.W/2, self.Y+self.H/2)
    if self.real then 
        if Cull == self.idr then
            self.dead = true
        end
        self.icollider.distance = math.sqrt(((PlayerX-(self.X+self.W/2))^2) + ((PlayerY-(self.Y+self.H/2))^2))

        if self.icollider.interacted then
            print('wagh')
            self.icollider.interacted = false
            self.area:addGameObject('Textbox', camera.x, camera.y, {textline = self.textline, func = self.func})
        end
    end
end

function DTexttester:draw()
    if self.real then
        love.graphics.rectangle('line', self.X, self.Y, self.W, self.H)
        love.graphics.line(self.X+self.W/2, self.Y+self.H/2, PlayerX, PlayerY)
    end
end