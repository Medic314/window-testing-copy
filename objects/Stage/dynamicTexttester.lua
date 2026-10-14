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
                rollcall = {r='main', x=-500+100, y=-120, tl={TT.arctread.atext1}},
                int = {r='main', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
    end
    if self.dtid == 'Tungsten' then
        self.W, self.H = 76, 122
        self.positions = {
            day1 = {
                rollcall = {r='main', x=-100+75, y=-95, tl={TT.tungsten.tstext1}},
                int = {r='main', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
    end
    if self.dtid == 'Rhenium' then
        self.W, self.H = 80, 135
        self.positions = {
            day1 = {
                rollcall = {r='main', x=-300+100, y=-100, tl={TT.rhenium.rtext1}},
                int = {r='main', x=1000000, y=1000000, tl={}},
                restperiod = {r='hallway', x=100, y=100, tl={}},
                night = {r='main', x=100, y=100, tl={}},
            },
        }
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
            self.area:addGameObject('Textbox', camera.x, camera.y, {textline = self.textline})
        end
    end
end

function DTexttester:draw()
    if self.real then
        love.graphics.rectangle('line', self.X, self.Y, self.W, self.H)
        love.graphics.line(self.X+self.W/2, self.Y+self.H/2, PlayerX, PlayerY)
    end
end