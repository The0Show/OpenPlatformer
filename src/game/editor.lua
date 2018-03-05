--[[
 * Copyright (C) 2015 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]

--[[
	editor binds (see editbinds.lua) or
	https://github.com/Jigoku/boxclip/wiki/Controls#editor-controls
	
	some may be undocumented, check this when adding help menu for editor
--]]

editor = {}
editing = false
require "editbinds"

editor.mouse = {
	x = 0,
	y = 0,
	pressed  = { x=0, y=0 },
	released = { x=0, y=0 }
}

editor.entdir = 0				--rotation placement 0,1,2,3 = up,down,right,left
editor.entsel = 1				--current entity id for placement
editor.themesel = 1				--world theme/pallete
editor.texturesel = 1			--texture slot to use for platforms
editor.showpos = true			--display coordinates of entities
editor.showid  = true			--display numeric id of entities
editor.showmmap = true			--show minimap
editor.showguide = true			--show guidelines/grid
editor.showentmenu = true		--show entmenu
editor.showhelpmenu = false		--show helpmenu
editor.showmusicbrowser = false --show musicbrowser
editor.drawsel = false			--draw selection area
editor.floatspeed = 1000		--editing floatspeed
editor.maxcamerascale = 6		--maximum zoom
editor.mincamerascale = 0.1		--minimum zoom

editor.errortex = love.graphics.newImage("data/images/error.png")

-- minimap
editor.mmapw = 200
editor.mmaph = 200
editor.mmapscale = camera.scale/10
editor.mmapcanvas = love.graphics.newCanvas( editor.mmapw, editor.mmaph )

-- entity selection menu
editor.entmenuw = 150    
editor.entmenuh = 300	
editor.entmenu = love.graphics.newCanvas(editor.entmenuw,editor.entmenuh)
	
-- help menu
editor.helpmenuw = 420
editor.helpmenuh = 500
editor.helpmenu = love.graphics.newCanvas(editor.helpmenuw,editor.helpmenuh)

-- texture preview
editor.texmenutexsize = 75
editor.texmenupadding = 10
editor.texmenuoffset = 2
editor.texmenutimer = 0
editor.texmenuduration = 2
editor.texmenuopacity = 0
editor.texmenufadespeed = 300
editor.texmenuw = editor.texmenutexsize+(editor.texmenupadding*2)
editor.texmenuh = (editor.texmenutexsize*(editor.texmenuoffset*2+1))+(editor.texmenupadding*(editor.texmenuoffset*2))+(editor.texmenupadding*2)
editor.texmenu = love.graphics.newCanvas(editor.texmenuw,editor.texmenuh)


--order of placable entities in entmenu
editor.entities = {
	"spawn",
	"goal",
	"platform" ,
	"platform_b" ,
	"platform_x" ,
	"platform_y" ,
	"platform_s" ,
	"log",
	"bridge",
	"brick",
	"water",
	"stream",
	"lava",
	"blood",
	"death",
	"checkpoint" ,
	"crate" ,
	"spike",
	"spike_large",
	"icicle" ,
	"walker",
	"floater", 
	"spikeball" ,
	"gem" ,
	"life",
	"star",
	"magnet", 
	"shield" ,
	"flower" ,
	"flower2" ,
	"grass" ,
	"rock",
	"tree" ,
	"post",
	"arch" ,
	"arch1_r",
	"arch2",
	"arch3",
	"arch3_end_l",
	"arch3_end_r",
	"arch3_pillar",
	"porthole",
	"mesh",
	"girder",
	"pillar", 
	"spring_s",
	"spring_m" ,
	"spring_l",
	"bumper",
}

-- entity priority for selection / hover mouse
editor.entorder = {
    "material",
    "trap",
    "enemy",
    "pickup",
    "portal",
    "crate",
    "checkpoint",
    "bumper",
    "spring",
    "platform",
    "prop",
    "decal"
 }


--entities which are draggable (size placement)
editor.draggable = {
	"platform", "platform_b", "platform_x", "platform_y", 
	"blood", "lava", "water", "stream", 
	"death" 
}

-- world themes
editor.themes = {
	"default",
	"sunny",
	"neon",
	"frost",
	"hell",
	"mist",
	"dust",
	"swamp",
	"night"
}


editor.help = {
	{ 
		editor.binds.edittoggle, 
		"toggle editmode" 
	},
	{ 
		binds.screenshot, 
		"take a screenshot" 
	},
	{ 
		binds.savefolder, 
		"open local data directory" 
	},
	{ 
		editor.binds.up..", "..editor.binds.left..", "..editor.binds.down..", "..editor.binds.right, 
		"move"
	},
	{
		"left mouse",
		"place entity"
	},
	{
		"right mouse",
		"remove entity"
	},
	{
		"mouse wheel",
		"scroll entity type"
	},
	{
		editor.binds.rotate .." + scroll",
		"rotate entity"
	},
	{
		editor.binds.moveup..", "..editor.binds.moveleft..", "..editor.binds.movedown..", "..editor.binds.moveright,
		"adjust entity position"
	},
	{
		editor.binds.themecycle,
		"set the world theme"
	},
	{
		editor.binds.entcopy,
		"copy entity to clipboard"
	},	
	{
		editor.binds.entpaste,
		"paste entity from clipboard"
	},
	{
		editor.binds.savemap,
		"save the map"
	},
	{
		binds.exit,
		"exit to title"
	},
	{
		binds.debug,
		"toggle console"
	},
	{
		editor.binds.guidetoggle,
		"toggle grid"
	},
	{
		editor.binds.maptoggle,
		"toggle minimap"
	},
	{
		editor.binds.helptoggle,
		"help menu"
	},
	{
		editor.binds.respawn,
		"reset camera"
	},
	{
		editor.binds.showpos,
		"toggle entity coordinates"
	},
	{
		editor.binds.showid,
		"toggle entity id"
	},
	{	
		editor.binds.decmovedist .. ", " .. editor.binds.incmovedist,
		"increase/decrease move distance"
	},
	{
		editor.binds.texturesel .. " + scroll",
		"change entity texture"
	},
	{
		editor.binds.musicnext  .. ", " .. editor.binds.musicprev,
		"set world music"
	},
	{
		editor.binds.camera .. " + scroll",
		"set camera zoom level"
	}
	
}

function editor:settexture(platform)
	--show the texture browser display
	
	self.texmenutimer = editor.texmenuduration
	self.texmenuopacity = 255
	
	--update the texture value
	for _,platform in ripairs(world.entities.platform) do
		if platform.selected then
			local cols = math.ceil(platform.w/platforms.textures[self.texturesel]:getWidth())
			local rows = math.ceil(platform.h/platforms.textures[self.texturesel]:getHeight())
			
			platform.texture = self.texturesel
			platform.verts = { 
				--top left
				{0,0,0,0},  
				--top right
				{0+platform.w,0,cols,0},
				--bottom right
				{0+platform.w,0+platform.h,cols,rows}, 
				--bottom left
				{0,0+platform.h,0,rows}
			}
			platform.selected = false
			return true
		end
	end
end

function editor:update(dt)
	--update world before anything else
	if editor.paused then
		--only update these when paused
		camera:update(dt)
		player:update(dt)
		camera:follow(player.x+player.w/2, player.y+player.h/2)
	else
		world:update(dt) 
	end
	
	--update active entity selection
	self:selection()
		
	--texture browser display
	self.texmenutimer = math.max(0, self.texmenutimer- dt)
		
	if self.texmenutimer == 0 then
		if self.texmenuopacity > 0 then
			self.texmenuopacity = math.max(0,self.texmenuopacity - self.texmenufadespeed * dt)
		end
	end
	
	--debug stuff
	--[[
	for _,i in ipairs(self.entorder) do
		for n,e in ripairs(world.entities[i]) do
			if e.selected then print(n,e.group) end
		end
	end
	--]]
	
end

function editor:settheme()
	world.theme = self.themes[self.themesel]

	world:settheme(world.theme)
	
	--fix this
	--update themeable textures
	--[[for i,e in ipairs(enemies) do 
		if e.name == "spike" then e.gfx = spike_gfx end
		if e.name == "spike_large" then e.gfx = spike_large_gfx end
		if e.name == "icicle" then e.gfx = icicle_gfx end
	end--]]
	self.themesel = self.themesel +1
	if self.themesel > #self.themes then self.themesel = 1 end
	
end

function editor:warn(func)
	if not func then
		console:print("action cannot be performed on selected entity")
	end
end

function editor:keypressed(key)
	if key == self.binds.edittoggle then 
		editing = not editing
		player.xvel = 0
		player.yvel = 0
		player.angle = 0
		player.jumping = false
		player.xvelboost = 0
	end


	if key == self.binds.helptoggle then self.showhelpmenu = not self.showhelpmenu end	
	if key == self.binds.maptoggle then self.showmmap = not self.showmmap end
	if key == self.binds.musicbrowser then self.showmusicbrowser = not self.showmusicbrowser end
		
	
	--free roaming	
	if editing then
		if key == self.binds.entselup then self.entsel = self.entsel +1 end
		if key == self.binds.entseldown then self.entsel = self.entsel -1 end
		if key == self.binds.pause then self.paused = not self.paused end
		if key == self.binds.delete then self:remove() end
		if key == self.binds.entcopy then self:copy() end
		if key == self.binds.entpaste then self:paste() end
		if key == self.binds.entmenutoggle then self.showentmenu = not self.showentmenu end
		if key == self.binds.flip then self:warn(self:flip()) end
		if key == self.binds.guidetoggle then self.showguide = not self.showguide end
		if key == self.binds.respawn then self:sendtospawn() end
		if key == self.binds.showpos then self.showpos = not self.showpos end
		if key == self.binds.showid then self.showid = not self.showid end
		if key == self.binds.savemap then mapio:savemap(world.map) end
	
		if key == self.binds.musicprev then 
			if world.mapmusic == 0 then 
				world.mapmusic = #sound.music
			else
				world.mapmusic = world.mapmusic -1
			end
		
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)	
		end
		
		if key == self.binds.musicnext then 
			if world.mapmusic == #sound.music then 
				world.mapmusic = 0 
			else
				world.mapmusic = world.mapmusic +1
			end
			
			sound:playbgm(world.mapmusic)
			sound:playambient(world.mapambient)	
		end
	
		if key == self.binds.themecycle then self:settheme() end
	
		for _, i in ipairs(self.entorder) do	
			for _,e in ipairs(world.entities[i]) do
				--fix this for moving platform (yorigin,xorigin etc)
				if e.selected then
					if love.keyboard.isDown(self.binds.moveup) then 
						e.y = math.round(e.y - 10,-1) --up
					end
					if love.keyboard.isDown(self.binds.movedown) then 
						e.y = math.round(e.y + 10,-1) --down
						e.yorigin = e.y
					end 
					if love.keyboard.isDown(self.binds.moveleft) then 
						e.x = math.round(e.x - 10,-1) --left
						e.xorigin = e.x
					end 
					if love.keyboard.isDown(self.binds.moveright) then 
						e.x = math.round(e.x + 10,-1)  --right
						e.xorigin = e.x
					end
	
					return true
					
				end
			end
		end
		
	end
end

function editor:checkkeys(dt)

	if love.keyboard.isDown(self.binds.right)  then
		player.x = player.x + self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.left)  then
		player.x = player.x - self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.up) then
		player.y = player.y - self.floatspeed /camera.scale *dt
	end
	if love.keyboard.isDown(self.binds.down) then
		player.y = player.y + self.floatspeed /camera.scale *dt
	end
	
	if love.keyboard.isDown(self.binds.decmovedist) then
		self:movedist(-1,dt)
	end
	if love.keyboard.isDown(self.binds.incmovedist) then
		self:movedist(1,dt)
	end
end


function editor:movedist(dir,dt)
	--horizontal size adjustment
	for _,type in pairs(world.entities) do
		for _,e in ipairs(type) do
			if e.selected then
				if e.swing == 1 then
					e.angle = math.max(0,math.min(math.pi,e.angle - dir*2 *dt))
					return true
				end

				if e.movex == 1 then
					e.movedist = math.round(e.movedist + dir*2,1)
					if e.movedist < e.w then e.movedist = e.w end
					return true
				end
				if e.movey == 1  then
					e.movedist = math.round(e.movedist + dir*2,1)
					if e.movedist < e.h then e.movedist = e.h end
					return true
				end
			end
		end
	end
end

function editor:wheelmoved(dx, dy)
    if love.keyboard.isDown(self.binds.camera) then
		--camer zoom
		camera.scale = math.max(self.mincamerascale,math.min(self.maxcamerascale,camera.scale + dy/25))
		
	elseif love.keyboard.isDown(self.binds.texturesel) then
		--platform texture slot selection
		self.texturesel = math.max(1,math.min(#platforms.textures,self.texturesel - dy))
		self:warn(self:settexture(p))
	elseif love.keyboard.isDown(self.binds.rotate) then
		self:warn(self:rotate(dy))
	else
		--entmenu selection
		editor.entsel = math.max(1,math.min(#editor.entities,editor.entsel - dy))

	end
end

function editor:mousepressed(x,y,button)
	if not editing then return end
	
	--this function is used to place entities which are not resizable. 
	
	self.mouse.pressed.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.pressed.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)

	local x = self.mouse.pressed.x
	local y = self.mouse.pressed.y
	
	if button == 1 then
		local selection = self.entities[self.entsel]
		
		if selection == "spawn" then
			self:removeall("portal", "spawn")
			portals:add(x,y,"spawn")
		end
		if selection == "goal" then
			self:removeall("portal", "goal")
			portals:add(x,y,"goal")
		end
		
		if selection == "crate" then crates:add(x,y,"gem") end
		
		if selection == "walker" then enemies:add(x,y,100,100,0,"walker") end
		
		if selection == "floater" then enemies:add(x,y,100,400,0,"floater") end
		if selection == "spikeball" then enemies:add(x,y,0,0,0,"spikeball") end
		if selection == "spike" then enemies:add(x,y,0,0,self.entdir,"spike") end
		if selection == "spike_large" then enemies:add(x,y,0,0,self.entdir,"spike_large") end
		if selection == "icicle" then enemies:add(x,y,0,0,0,"icicle") end
		
		if selection == "platform_s" then platforms:add(x,y,0,20,0,0,0,1.5,0,1,0,self.texturesel) end

		if selection == "checkpoint" then checkpoints:add(x,y) end
		
		if selection == "gem" then pickups:add(x,y,"gem") end
		if selection == "life" then pickups:add(x,y,"life") end
		if selection == "magnet" then pickups:add(x,y,"magnet") end
		if selection == "shield" then pickups:add(x,y,"shield") end
		if selection == "star" then pickups:add(x,y,"star") end

		if selection == "log" then traps:add(x,y,"log") end
		if selection == "bridge" then traps:add(x,y,"bridge") end
		if selection == "brick" then traps:add(x,y,"brick") end
		
		if selection == "flower" then props:add(x,y,self.entdir,false,"flower") end
		if selection == "flower2" then props:add(x,y,self.entdir,false,"flower2") end
		if selection == "grass" then props:add(x,y,self.entdir,false,"grass") end
		if selection == "rock" then props:add(x,y,self.entdir,false,"rock") end
		if selection == "tree" then props:add(x,y,self.entdir,false,"tree") end
		if selection == "post" then props:add(x,y,self.entdir,false,"post") end
		if selection == "arch" then props:add(x,y,self.entdir,false,"arch") end
		if selection == "arch1_r" then props:add(x,y,self.entdir,false,"arch1_r") end
		if selection == "arch2" then props:add(x,y,self.entdir,false,"arch2") end
		if selection == "arch3" then props:add(x,y,self.entdir,false,"arch3") end
		if selection == "arch3_end_l" then props:add(x,y,self.entdir,false,"arch3_end_l") end
		if selection == "arch3_end_r" then props:add(x,y,self.entdir,false,"arch3_end_r") end
		if selection == "arch3_pillar" then props:add(x,y,self.entdir,false,"arch3_pillar") end
		if selection == "porthole" then props:add(x,y,self.entdir,false,"porthole") end
		if selection == "mesh" then props:add(x,y,self.entdir,false,"mesh") end
		if selection == "pillar" then props:add(x,y,self.entdir,false,"pillar") end
		if selection == "girder" then props:add(x,y,self.entdir,false,"girder") end
		
		if selection == "spring_s" then springs:add(x,y,self.entdir,"spring_s") end
		if selection == "spring_m" then springs:add(x,y,self.entdir,"spring_m") end
		if selection == "spring_l" then springs:add(x,y,self.entdir,"spring_l") end
		
		if selection == "bumper" then bumpers:add(x,y) end
		
		
	elseif button == 2 then
		self:remove()
	end
end

function editor:mousereleased(x,y,button)
	--check if we have selected draggable entity, then place if neccesary
	if not editing then return end
	
	self.mouse.released.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.released.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	
	editor.drawsel = false

	if button == 1 then 
		for _,entity in ipairs(self.draggable) do
			if self.entities[self.entsel] == entity then
				self:placedraggable(self.mouse.pressed.x,self.mouse.pressed.y,self.mouse.released.x,self.mouse.released.y)
			end
		end
		return
	end
	
	--reorder entity (sendtoback)
	if button == 3 then
		for _,i in ipairs(self.entorder) do
			for n,e in ripairs(world.entities[i]) do
				if e.selected then
					world:sendtoback(world.entities[i],n)
					return true
				end
			end
		end
	end
end


function editor:sendtospawn()
	--world:resetcamera()
	-- find the spawn entity
	for _, portal in ipairs(world.entities.portal) do
		if portal.type == "spawn" then
			player.x = portal.x
			player.y = portal.y
		end
	end	
	
end


function editor:placedraggable(x1,y1,x2,y2)

	--this function is used for placing entities which 
	-- can be dragged/resized when placing
	
	local ent = self.entities[self.entsel]

	--we must drag down and right
	if not (x2 < x1 or y2 < y1) then
		--min sizes (we don't want impossible to select/remove platforms)
		if x2-x1 < 20  then x2 = x1 +20 end
		if y2-y1 < 20  then y2 = y1 +20 end

		local x = math.round(x1,-1)
		local y = math.round(y1,-1)
		local w = (x2-x1)
		local h = (y2-y1)
		
		--place the platform
		if ent == "platform" then platforms:add(x,y,w,h,1,0,0,0,0,0,0,self.texturesel) end
		if ent == "platform_b" then platforms:add(x,y,w,h,0,0,0,0,0,0,0,self.texturesel) end
		if ent == "platform_x" then platforms:add(x,y,w,h,0,1,0,100,200,0,0,self.texturesel) end
		if ent == "platform_y" then platforms:add(x,y,w,h,0,0,1,100,200,0,0,self.texturesel) end
		
		if ent == "blood" then decals:add(x,y,w,h,"blood") end
		if ent == "lava" then decals:add(x,y,w,h,"lava") end
		if ent == "water" then decals:add(x,y,w,h,"water") end
		if ent == "stream" then decals:add(x,y,w,h,"stream") end
		
		if ent == "death" then materials:add(x,y,w,h,"death") end
	end
end

function editor:drawguide()
	--draw crosshairs/grid

	if self.showguide then

		--grid
		love.graphics.setColor(255,255,255,25)
		-- horizontal
		for x=camera.x-love.graphics.getWidth()/2/camera.scale,
			camera.x+love.graphics.getWidth()/2/camera.scale,10 do
			love.graphics.line(
				math.round(x,-1), camera.y-love.graphics.getHeight()/2/camera.scale,
				math.round(x,-1), camera.y+love.graphics.getHeight()/2/camera.scale
			)
		end
		-- vertical
		for y=camera.y-love.graphics.getHeight()/2/camera.scale,
			camera.y+love.graphics.getHeight()/2/camera.scale,10 do
			love.graphics.line(
				camera.x-love.graphics.getWidth()/2/camera.scale, math.round(y,-1),
				camera.x+love.graphics.getWidth()/2/camera.scale, math.round(y,-1)
			)
		end

		--crosshair
		love.graphics.setColor(200,200,255,50)
		--vertical
		love.graphics.line(
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y+love.graphics.getHeight()/camera.scale,-1),
			math.round(self.mouse.x,-1),
			math.round(self.mouse.y-love.graphics.getHeight()/camera.scale,-1)
		)
		--horizontal
		love.graphics.line(
			math.round(self.mouse.x-love.graphics.getWidth()/camera.scale,-1),
			math.round(self.mouse.y,-1),
			math.round(self.mouse.x+love.graphics.getWidth()/camera.scale-1),
			math.round(self.mouse.y,-1)
		)
	end
end

function editor:drawcursor()
	--draw the cursor
	love.graphics.setColor(255,255,255,255)
	love.graphics.line(
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1),
		math.round(self.mouse.x,-1)+10,
		math.round(self.mouse.y,-1)
	)
	love.graphics.line(
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1),
		math.round(self.mouse.x,-1),
		math.round(self.mouse.y,-1)+10
	)
	
	if debug then
	self:drawcoordinates(
		{ x = self.mouse.x, y = self.mouse.y }
	)
	end
end

function editor:drawtexturesel()
	if self.texmenuopacity > 0 then
	
		love.graphics.setCanvas(self.texmenu)
		love.graphics.clear()
	
		local x = self.texmenupadding
		local y = self.texmenupadding
		local n = 0
	
		love.graphics.setColor(0,0,0,150)
		love.graphics.rectangle("fill",0,0,self.texmenu:getWidth(), self.texmenu:getHeight(),10)

		
		for i=math.max(-self.texmenuoffset,self.texturesel-self.texmenuoffset), 
			math.min(#platforms.textures+self.texmenuoffset,self.texturesel+self.texmenuoffset) do
			
			if type(platforms.textures[i]) == "userdata" then
			
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(
					platforms.textures[i],
					x,
					y+(n*self.texmenutexsize)+n*(self.texmenupadding),
					0,
					self.texmenutexsize/platforms.textures[i]:getWidth(),
					self.texmenutexsize/platforms.textures[i]:getHeight()
				)
				
				if self.texturesel == i then
					love.graphics.setColor(0,255,0,255)
					love.graphics.rectangle(
						"line",
						x,
						y+(n*self.texmenutexsize)+n*(self.texmenupadding),
						self.texmenutexsize,self.texmenutexsize
					)
				end
				
				love.graphics.setColor(0,0,0,255)
				love.graphics.print(i,x+5,y+(n*self.texmenutexsize)+n*(self.texmenupadding)+5)
			
			else
				
				love.graphics.setColor(255,255,255,255)
				
				love.graphics.draw(
					self.errortex,
					x,
					y+(n*self.texmenutexsize)+n*(self.texmenupadding),
					0,
					self.texmenutexsize/self.errortex:getWidth(),
					self.texmenutexsize/self.errortex:getHeight()
				)
				
			end
			
			n = n + 1	
		end
			
		love.graphics.setCanvas()
	
		love.graphics.setColor(255,255,255,self.texmenuopacity)
		love.graphics.draw(self.texmenu, 10, 10)
	end
end


function editor:draw()
	
	--editor hud
	love.graphics.setColor(0,0,0,125)
	love.graphics.rectangle("fill", love.graphics.getWidth() -130, 10, 120,50,10)
	love.graphics.setFont(fonts.large)
	love.graphics.setColor(255,255,255,175)
	love.graphics.print("editing",love.graphics.getWidth()-100, 10,0,1,1)
	love.graphics.setFont(fonts.default)
	love.graphics.print("press 'h' for help",love.graphics.getWidth()-120, 40,0,1,1)
	
	
	--interactive editing
	if editing then
	
		camera:attach()
	
		self:drawguide()
		self:drawcursor()
		self:drawselbox()
		
		camera:detach()
		
		if world.collision == 0 then
			--notify keybind for camera reset when 
			--no entities are in view
			love.graphics.setColor(255,255,255,255)
			love.graphics.setFont(fonts.menu)
			love.graphics.print("(Tip: press \"".. self.binds.respawn .. "\" to reset camera)", 200, love.graphics.getHeight()-50,0,1,1)
			love.graphics.setFont(fonts.default)
		end
		
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("selection:",love.graphics.getWidth()-115, 65,0,1,1)
	
		love.graphics.setColor(255,155,55,255)
		love.graphics.print(editor.selname or "",love.graphics.getWidth()-115, 80,0,1,1)
	
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("theme:",love.graphics.getWidth()-115, 95,0,1,1)
	
		love.graphics.setColor(255,155,55,255)
		love.graphics.print(world.theme or "default",love.graphics.getWidth()-115, 110,0,1,1)
	
		if self.showentmenu then self:drawentmenu() end
		if self.showmusicbrowser then musicbrowser:draw() end
		
		self:drawtexturesel()
	end
	
	if self.showmmap then self:drawmmap() end
	if self.showhelpmenu then self:drawhelpmenu() end
end

function editor:drawselbox()
	--draw an outline when dragging mouse if 
	-- entsel is one of these types
	if self.drawsel then
		for _,entity in ipairs(self.draggable) do
			if self.entities[self.entsel] == entity then
				love.graphics.setColor(0,255,255,255)
				love.graphics.rectangle(
					"line", 
					self.mouse.pressed.x,self.mouse.pressed.y, 
					self.mouse.x-self.mouse.pressed.x, self.mouse.y-self.mouse.pressed.y
				)
			end
		end
	end
	
	--draw box  for actively selected entity
	if self.selbox then
		love.graphics.setColor(0,255,0,255)
		love.graphics.rectangle("line", self.selbox.x, self.selbox.y, self.selbox.w, self.selbox.h)
	end
end


function editor:formathelp(t)
	local s = 15 -- vertical spacing
	love.graphics.setFont(fonts.menu)
	for i,item in ipairs(t) do
		love.graphics.setColor(155,255,255,155)
		love.graphics.print(string.upper(item[1]),10,s*i+s); 
		love.graphics.setColor(255,255,255,155)
		love.graphics.printf(item[2],150,s*i+s,fonts.menu:getWidth(item[2]),"left")
	end
	love.graphics.setFont(fonts.default)
end


function editor:drawhelpmenu()
		
	love.graphics.setCanvas(self.helpmenu)
	love.graphics.clear()
	
	--frame
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), self.helpmenu:getHeight(),10)
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",0,0, self.helpmenu:getWidth(), 5)
	--title
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Editor Help",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle("fill",10,25, self.helpmenu:getWidth()-10, 1)


	--menu title
	love.graphics.setColor(255,255,255,155)
	love.graphics.printf("["..self.binds.helptoggle.."] to close",self.helpmenu:getWidth()-110,10,100,"right")
		
	--loop bind/key description and format it
	self:formathelp(self.help)

	love.graphics.setCanvas()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.helpmenu, love.graphics.getWidth()/2-self.helpmenu:getWidth()/2, love.graphics.getHeight()/2-self.helpmenu:getHeight()/2 )
	
	
end


function editor:drawentmenu()
	--gui scrolling list for entity selection
	if not editing then return end
	love.graphics.setCanvas(self.entmenu)
	love.graphics.clear()
		
	--frame
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), self.entmenu:getHeight(),10
	)
	
	--border
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",0,0, self.entmenu:getWidth(), 5
	)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("entity selection",10,10)
	
	--hrule
	love.graphics.setColor(255,255,255,150)
	love.graphics.rectangle(
		"fill",10,25, self.entmenu:getWidth()-10, 1
	)
	
	local s = 20 -- vertical spacing
	local entname = self.entities[self.entsel]
	local empty = "*"
	local padding = 2
	
	love.graphics.setFont(fonts.menu)
	
	love.graphics.setColor(150,150,150,255)
	love.graphics.print(self.entities[self.entsel-4] or empty,10,s*2)
	love.graphics.print(self.entities[self.entsel-3] or empty,10,s*3)
	love.graphics.print(self.entities[self.entsel-2] or empty,10,s*4)
	love.graphics.print(self.entities[self.entsel-1] or empty,10,s*5)
	
	--selected
	love.graphics.setColor(150,150,150,255)

	love.graphics.rectangle(
		"fill",-padding+10,-padding+s*6, self.entmenu:getWidth()-20+padding*2, 15+padding*2
	)
	----------
	
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(self.entities[self.entsel] or empty,10,s*6)
	
	love.graphics.setColor(150,150,150,255)
	love.graphics.print(self.entities[self.entsel+1] or empty,10,s*7)
	love.graphics.print(self.entities[self.entsel+2] or empty,10,s*8)
	love.graphics.print(self.entities[self.entsel+3] or empty,10,s*9)
	love.graphics.print(self.entities[self.entsel+4] or empty,10,s*10)
	love.graphics.setFont(fonts.default)
	
	love.graphics.setCanvas()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.entmenu, 10, love.graphics.getHeight()-self.entmenu:getHeight()-10 )
end






function editor:selection()
	-- selects the entity when mouseover 
	
	-- so we can break nested loop
	-- and not have multiple entities selected
	local should_break = false 
	
	for _, i in ipairs(self.entorder) do
		for n,e in ipairs(world.entities[i]) do
			--deselect all before continuing
			--stops weird texture change bug for non-selected platforms
			--also, stops performing actions on entities "below" selected ones
			e.selected = false
		end
	end
	
	for _, i in ipairs(self.entorder) do
		if should_break then break end
		--reverse loop
		for n,e in ripairs(world.entities[i]) do
			--if should_break then break end
			if world:inview(e) then
				editor.selname = e.group .. "("..n..")"
				if e.movex == 1 then
					--collision area for moving entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,e.xorigin, e.y, e.movedist+e.w, e.h) then
						self.selbox = { 
							x = e.xorigin, 
							y = e.y, 
							w = e.movedist+e.w, 
							h = e.h 
						}
						e.selected = true
						
					end
				elseif e.movey == 1 then
					--collision area for moving entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,e.xorigin, e.yorigin, e.w, e.h+e.movedist) then
						self.selbox = { 	
							x = e.xorigin, 
							y = e.yorigin, 
							w = e.w, 
							h = e.h+e.movedist 
						}
						e.selected = true
					
					end
				elseif e.swing == 1 then
					--collision area for swinging entity
					if collision:check(self.mouse.x,self.mouse.y,1,1,
						e.xorigin-platform_link_origin:getWidth()/2, e.yorigin-platform_link_origin:getHeight()/2,  
						platform_link_origin:getWidth(),platform_link_origin:getHeight()) then
						self.selbox = {	
							x = e.xorigin-platform_link_origin:getWidth()/2, 
							y = e.yorigin-platform_link_origin:getHeight()/2,  
							w = platform_link_origin:getWidth(),
							h = platform_link_origin:getHeight()
						}
						e.selected = true
					
					end
				elseif collision:check(self.mouse.x,self.mouse.y,1,1,e.x,e.y,e.w,e.h) then
					--collision area for static entities
					self.selbox = { 
						x = e.x, 
						y = e.y, 
						w = e.w, 
						h = e.h 
					} 
					e.selected = true

				else
					self.selbox = nil
					editor.selname = "null"
				end
				
				--update active selected texture for entity
				self.texturesel = e.texture or 1
				
				--if we've selected an entity, break entire loop
				if e.selected then	
					should_break = true
					break
				end
			end
		end
	end
end


function editor:removeall(group,type)
	--removes all entity types of given entity
	for _, enttype in pairs(world.entities) do
		for i, e in ripairs(enttype) do
			if e.group == group and e.type == type then
				table.remove(enttype,i)
			end
		end
	end
end

function editor:remove()
	--removes the currently selected entity from the world
	for _, i in ipairs(self.entorder) do
		for n,e in ipairs(world.entities[i]) do
			if e.selected then
				table.remove(world.entities[i],n)
				console:print( e.group .. " (" .. n .. ") removed" )
				self.selbox = nil
				return true	
			end
		end
	end
end


function editor:flip()
	for _, i in ipairs(self.entorder) do
		for n,e in ipairs(world.entities[i]) do
			if e.selected and e.editor_canflip then
				e.flip = not e.flip
				console:print( e.group .. " (" .. n .. ") flipped" )
				e.selected = false
				return true
			end
		end
	end
end

function editor:rotate(dy)
	--set rotation value for the entity
	--four directions, 0,1,2,3 at 90degree angles

	for _, i in ipairs(self.entorder) do
		for n,e in ipairs(world.entities[i]) do
			if e.selected and e.editor_canrotate then
			
				e.dir = e.dir + dy
				if e.dir > 3 then
					e.dir = 0
				elseif e.dir < 0 then
					e.dir = 3
				end
				
				if e.dir == 0 or e.dir == 1 then
					e.w = e.gfx:getWidth()
					e.h = e.gfx:getHeight()
				end
				if e.dir == 2 or e.dir == 3 then
					e.w = e.gfx:getHeight()
					e.h = e.gfx:getWidth()
				end
				
				console:print( e.group .. " (" .. n .. ") rotated, direction = "..e.dir)
				e.selected = false
				return true

			end
		end
	end
end


function editor:copy()
	--primitive copy (dimensions only for now)
	for _,type in pairs(world.entities) do
		for i, e in ipairs(type) do
			if e.selected then
				console:print("copied "..e.group.."("..i..")")
				self.clipboard = e
				return true
			end
		end
	end
end

function editor:paste()
	local x = math.round(self.mouse.x,-1)
	local y = math.round(self.mouse.y,-1)
	
	--paste the cloned entity
	local p = table.deepcopy(self.clipboard)
	if type(p) == "table" then
		p.x = x
		p.y = y
		p.xorigin = x + (p.x-x)
		p.yorigin = y + (p.y-y)
		table.insert(world.entities[p.group],p)
		console:print("paste "..p.group.."("..#world.entities[p.group]..")")
	end
end




function editor:drawmmap()
	
	love.graphics.setCanvas(self.mmapcanvas)
	love.graphics.clear()

	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill", 0,0,self.mmapw,self.mmaph)
	
	for i, platform in ipairs(world.entities.platform) do
		if platform.clip == 1 then
			love.graphics.setColor(
				platform_r,
				platform_g,
				platform_b,
				255
			)
		else
			love.graphics.setColor(
				platform_behind_r,
				platform_behind_g,
				platform_behind_b,
				255
			)
		end
		love.graphics.rectangle(
			"fill", 
			(platform.x*self.mmapscale)-(camera.x*self.mmapscale)+self.mmapw/2, 
			(platform.y*self.mmapscale)-(camera.y*self.mmapscale)+self.mmaph/2, 
			platform.w*self.mmapscale, 
			platform.h*self.mmapscale
		)
	end

	love.graphics.setColor(0,255,255,255)
	for i, crate in ipairs(world.entities.crate) do
		love.graphics.rectangle(
			"fill", 
			(crate.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(crate.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			crate.w*self.mmapscale, 
			crate.h*self.mmapscale
		)
	end
	
	love.graphics.setColor(255,50,50,255)
	for i, enemy in ipairs(world.entities.enemy) do
		love.graphics.rectangle(
			"fill", 
			(enemy.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(enemy.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			enemy.w*self.mmapscale, 
			enemy.h*self.mmapscale
		)
	end
	
	love.graphics.setColor(100,255,100,255)
	for i, pickup in ipairs(world.entities.pickup) do
		love.graphics.rectangle(
			"fill", 
			(pickup.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(pickup.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			pickup.w*self.mmapscale, 
			pickup.h*self.mmapscale
		)
	end
	
	love.graphics.setColor(0,255,255,255)
	for i, checkpoint in ipairs(world.entities.checkpoint) do
		love.graphics.rectangle(
			"fill", 
			(checkpoint.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(checkpoint.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			checkpoint.w*self.mmapscale, 
			checkpoint.h*self.mmapscale
		)
	end

	love.graphics.setColor(255,30,255,255)
	for i, spring in ipairs(world.entities.spring) do
		love.graphics.rectangle(
			"fill", 
			(spring.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(spring.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			spring.w*self.mmapscale, 
			spring.h*self.mmapscale
		)
	end

	love.graphics.setColor(255,155,0,255)
	for i, bumper in ipairs(world.entities.bumper) do
		love.graphics.rectangle(
			"fill", 
			(bumper.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(bumper.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			bumper.w*self.mmapscale, 
			bumper.h*self.mmapscale
		)
	end
	
	love.graphics.setColor(255,255,255,255)
	for i, trap in ipairs(world.entities.trap) do
		love.graphics.rectangle(
			"fill", 
			(trap.x*self.mmapscale)-camera.x*self.mmapscale+self.mmapw/2, 
			(trap.y*self.mmapscale)-camera.y*self.mmapscale+self.mmaph/2, 
			trap.w*self.mmapscale, 
			trap.h*self.mmapscale
		)
	end
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle(
		"line", 
		(player.x*self.mmapscale)-(camera.x*self.mmapscale)+self.mmapw/2, 
		(player.y*self.mmapscale)-(camera.y*self.mmapscale)+self.mmaph/2, 
		player.w*self.mmapscale, 
		player.h*self.mmapscale
	)
	

	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.mmapcanvas, love.graphics.getWidth()-10-self.mmapw,love.graphics.getHeight()-10-self.mmaph )

end


function editor:drawid(entity,i)
	--local id = split(string.format("%s",entity) ," ")
	--local hash = id[2]
	if editor.showid then
		love.graphics.setColor(255,255,0,100)       
		love.graphics.print(entity.group .. "(" .. i .. ")", entity.x-20, entity.y-40, 0)
	end
end

function editor:drawcoordinates(object)
	if editor.showpos then
		love.graphics.setColor(255,255,255,100)
		love.graphics.print("x ".. math.round(object.x) ..", y " .. math.round(object.y) , object.x-20,object.y-20,0)  
	end
end


function editor:mousemoved(x,y,dx,dy)
	if not editing then return end
	
	self.mouse.x = math.round(camera.x-(love.graphics.getWidth()/2/camera.scale)+x/camera.scale,-1)
	self.mouse.y = math.round(camera.y-(love.graphics.getHeight()/2/camera.scale)+y/camera.scale,-1)
	
	if love.mouse.isDown(1) then
		editor.drawsel = true
	else
		editor.drawsel = false
	end

end


