pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
p = {
	x=64,
	y=-16,
	anim="fall",
	direction="right",
	fall={f=0,st=0,sz=4,spd=2/5},
	fly_in_fall={f=16,st=16,sz=5,spd=2/5},
	flap={f=16,st=16,sz=5,spd=2/5}
}
bubble = {
	x=8,
	y=128
}
background = {
	x=0,
	y=0
}

cpt = 0
firstroom = true
secondroom = false
finishroom = false
transition = false

p_map_secondroom = {
	x=65,
	y=6
}

p_map_finishroom = {
	x=16,
	y=0
}

cam={
	x=0,
	y=0
}

speed=1
allowance=28

function controls()
	if (hit(p.x+4, p.y+15, 1, 1, 4) and firstroom) or (hit(p.x+10, p.y+15, 1, 1, 4) and firstroom) then
		initfirstroom()
	end
	if(p.anim == "flap") then
		if (hit(p.x+520, p.y+47, 1, 1, 2) and hit(p.x+520, p.y+61, 1, 1, 2)) then
			secondroom = false
			transition = true
			finishroom = true
		end
		if (btn(2)) then
			if (p.y-cam.y<(64-allowance)) then
   				cam.y-=speed
  			end
			p.y -= 2
		end
		if (not hit(p.x+520, p.y+47, 1, 1, 6)) and (not hit(p.x+520, p.y+61, 1, 1, 6)) then
			if (p.y-cam.y>(64-allowance)) then
   				cam.y+=speed
  			end
			p.y += 1
		else
			initfirstroom()
		end
	end
	if (btn(0)) then
		p.direction="left"
		if (not hit(p.x+4, p.y+15, 1, 1, 7) and firstroom) then
			p.x -= 1
		elseif (secondroom) then
			if (p.x-cam.x<(64-allowance)) then
   				cam.x-=speed
  			end
			p.x -= 1
		end
	end
	if (btn(1)) then
		p.direction="right"
		if (not hit(p.x+10, p.y+15, 1, 1, 7) and firstroom) then
			p.x += 1
		elseif (secondroom) then
			if (p.x-cam.x>(64+allowance)) then
   				cam.x+=speed
  			end
			  p.x += 1
		end
	end
	if (btn(3) and (p.anim != "flap")) then
		if (p.y-cam.y>(64-allowance)) then
   				cam.y+=speed
		end
		p.y += 4
	end
	if(p.anim == "fall" or p.anim == "fly_in_fall") then
  		if (btn(2)) then
			p.anim="fly_in_fall"
			if (p.y-cam.y<(64-allowance)) and p.y>36 then
   				cam.y-=speed
  			end
			p.y -= 0.4
  		end
 	elseif(p.anim != "flap") then
		if (btn(2)) then
			if (p.y-cam.y<(64-allowance)) and p.y>36 then
   				cam.y-=speed
  			end
			p.y -= 1
		end
	end
end

function initfirstroom()
	firstroom = true
	secondroom = false
	transition = false
	background.x = 0
	background.y = 0
	cpt = 0
	bubble.x = 8
	bubble.y = 128
	p.x = 64
	p.y = -16
	p.anim = "fall"
	p.direction = "right"
	cam.x = 0
	cam.y = 0
end

function anim(a)
	a.f += a.spd
	if(a.f >= a.st + a.sz) then
		a.f = a.st
	end
	return flr(a.f)*2
end

function anim_player()
	if(p.anim == "fall") then
		return anim(p.fall)
	elseif(p.anim == "fly_in_fall") then
		return anim(p.fly_in_fall)
	elseif(p.anim == "flap") then
		return anim(p.flap)
	end
end

function autofall()
	if (p.y-cam.y>(64-allowance)) then
		cam.y+=speed
	end
	p.y += 0.2
end

function hit(x,y,w,h,flag)
  collide=false
  for i=x,x+w,w do
    if (fget(mget(i/8,y/8), flag)==true) or
         (fget(mget(i/8,(y+h)/8), flag)==true) then
          collide=true
    end
  end
  
  for i=y,y+h,h do
    if (fget(mget(x/8,i/8), flag)==true) or
         (fget(mget((x+w)/8,i/8), flag)==true) then
          collide=true
    end
  end
  
  return collide
end

function _update()
	if (p.y >= 256) and (firstroom == true) then
		firstroom = false
		secondroom = true
		transition = true
		p.y = 16
	end

	if firstroom then
		if(p.anim == "fly_in_fall") then
			p.anim="fall"
		end

		controls()
		autofall()

		bubble.y -= 0.75
		
	elseif secondroom then
		if transition then
			cam.x = 0
			cam.y = 0
			p.y += 1.5
			transition = false
			p.anim = "flap"
		else
			controls()
		end
	end
end

function _draw()
	cls()
	
	if firstroom then
		camera(cam.x,cam.y)
		map(0,0,background.x,background.y,16,48)
		if(p.direction == "left") then
			spr(anim_player(),p.x,p.y,2,2,false)
		else
			spr(anim_player(),p.x,p.y,2,2,true)
		end

		spr(64,bubble.x,bubble.y)
	elseif secondroom then
		camera(cam.x,cam.y)
		
		background.x = 0
		background.y = 0
		map(p_map_secondroom.x,p_map_secondroom.y,background.x,background.y,64,128)
		if(p.direction == "left") then
			spr(anim_player(),p.x,p.y,2,2,false)
		else
			spr(anim_player(),p.x,p.y,2,2,true)
		end
	elseif finishroom then
		camera(0,0)

		background.x = 0
		background.y = 0
		map(p_map_finishroom.x,p_map_finishroom.y,background.x,background.y,16,16)
	end
end
__gfx__
00000aaa0000000000000aaa0000000000000aaa0000000000000aaa000000000000000000000000000000000000000000000000000000000000000000000000
000000aaa0000000000000aaa0000000000000aaa0000600000000aaa00000000000000000000000000000000000400000000000000000000000000000000000
000060077a000000000600077a000060000000077a000600000600077a0000600000000000000000000000000000400000000000000000000000000000000000
000060097a000660000660097a006600006600097a066000000660097a0066000000000000000000000000000000400000000000000000000000000000000000
0000660aaaa666000000660aaaa660000006600aaaa600000000660aaaa660000000000000000000000000000004005000000000000000000000000000000000
000006688a660000000006688a660000000066688a600000000006688a6600000000000000000000004400000440005500000000000000000000000000000000
0000000e8aa0000000000008eaa000000000000e8aa0000000000008eaa000000000000000000000000400000400000500000000004000000000000000000000
0000000aaaa000000000000aaaa000000000000aaaa000000000000aaaa000000000000000000000000040000400000500000000004000000000000000000000
0000000aaaa000000000000aaaa000000000000aaaa000000000000aaaa000000000000000000000000040000040005500000000004000000000000000000000
000000aaaaa00000000000aaaaa00000000000aaaaa00000000000aaaaa000000000000000000000000040000000005555500000004000000000000000000000
000000aaaa000000000000aaaa000000050000aaaa000000000000aaaa00000000000000000000000004000000005a55aa550000044000000000000000000000
00000aaaa000000005000aaaa000000000500aaaa000000005000aaaa000000000000000000000000004000000a55aa5aa5a0000440000000000000000000000
0055aaa0000000000555aaa0000000000005aaa0000000000555aaa000000000000000000000000000040000055aaaa5aa5aa000400000000000000000000000
055aa55000000000000aa55000000000000aaa5000000000000aa5500000000000000000000000000004400005aaaaa5aa55a000440000000000000000000000
0000550000000000000005000000000000000055000000000000050000000000000000000000000000004000a5aaaaaaaaaaaa00040000000000000000000000
0000500000000000000005000000000000000005000000000000050000000000000000000000000000000000aaaaaaaaaaaaaa00000000000000000000000000
00000aaa00000000000000aa000000000000000a000000000000000a00000000000000aa000000000000000aaaaaaaaaaaaaaaa0000000000000000000000000
000000aaa00000000000000aa0000000000000aa00000000000000aa000000000000000aa00000000000000aaa5aaaaaaaaaaaaa000000000000000000000000
000060077a006000000000097a00000000000097a000000000000097a0000000000000077a0000000000095aaa5aaaa55aaaa55aa00000000000000000000000
000060097a006000000000077a00000000000077c000000000000077c0000000000000097a0000000000955aa5aaaa585aaaaaaaaaa000000000000000000000
0000660aaaa660000000000aaaa00000000000aaca000000000000aaca0000000000000aaaa00000009995aaaaaaaa5885aaaaaaaaaa00000000000000000000
000006688a66000000000008aaa000000000008aaa0000000000008aaa00000000000008aaa0000000999aaaaaaaa598855aaaaa5aaaaa000000000000000000
000000688a60000000666668aa6666600000068aa66000000000068aa660000000666668aa66666000999aaaaaaaa58899955aaa55aaaa000000000000000000
0000000aaaa000000000000aaaa00000000006aaaa600000000006aaaa6000000000000aaaa000000aaaaaaaaaaa5988999955aaa55aaaa00000000000000000
0000000aaaa000000000000aaaa00000000066aaaa600000000066aaaa6000000000000aaaa000000aaaaaaaaaa598899999955aaaaaaaa00000000000000000
000000aaaaa000000000000aaaa00000000060aaaa060000000060aaaa0600000000000aaaa00000009aaaaaaa59888999999995555aaaa00000000000000000
000000aaaa0000000000000aaa000000000060aaa0060000000060aaa00600000000000aaa000000009995555599888999999999995555500000000000000000
05000aaaa50000000000000aaa000000000000aaa0000000000000aaa00000000000000aaa000000000099999998888999999999999000000000000000000000
0555aa5555000000000005aaa0000000000000aa50000000000000aa50000000000005aaa0000000000000008888888899999900000000000000000000000000
000aaa0000000000000005a5500000000000005a500000000000005a5000000000005aa550000000000000088888888899900000000000000000000000000000
00000000000000000000500055000000000000505000000000000050500000000000500055000000000000000888880000000000000000000000000000000000
00000000000000000000500005000000000000505000000000000050500000000000500005000000000000000000000000000000000000000000000000000000
02288882eeeeeeee1eeeee222888822021eeeeeeeeeeeeeeeeeeeeeeeeeee122b00000000000000b7777777744444444bbbbbbbb444444444400444444444444
02288882eeeeeeee544eee2228888220221eeeeeeeeeeeeeeeeeeeeeee7e1222b00000000000000b7777777744444444bbbbbbbb444444444444044444444444
02288882eeee6eee1eeeee22288882202221eeeee7eeeeeee6eeeeeeeeeee122bb000000000000bb7777777744444444bbbbbbbb444444404444404444000444
02287882eee66eee544eee2228888220221ee7eeeeeee7eeeeeee6eeeeeeee12bb00000bb00000bb7777777744444444bbbbbbbb444444404444404440444444
02278782ee6eeeee1eeeee222888822021eeeeeeeeeeeeeeeeeeeeeeee6ee122bb0000b11b0000bb7777777744499944bbbbbbbb444444044444404404444444
02287882e666eeee544eee2228888220221eeeeee6eeeeeee7eeeeeeeeee1222bb000b1111b000bb7777777744999994bbbbbbbb444000444444444404444444
02288882eeeeeeee1eeeee22288882202221e6eeeeeee6eeeeeee7eeeeeee122bbb00b1aa1b00bbb7777777749999999bbbbbbbb444444444444444444444444
02288882eeeeeeee544eee2228888220221eeeeeeeeeeeeeeeeeeeeeeeeeee120bbbbb1aa1bbbbb07777777799999999bbbbbbbb444444444444444444444444
444444440000000022eee44502288882eeeee122eeeeeeee21eeeeee0000000000bbbb1aa1bbbb0000000000ffffffff44444444944444449999999900000000
444444440000000022eeeee102288882ee6e1222e7eeeeee221eeeee0000000000000b1aa1b0000000000000ffffffff44444444994444449999999400000000
044444440000000022eee44502288882eeeee122eeee2eee2221eeee0000000000000b1111b0000000000000ffffffff44444444999444444999994400000000
044444440000000022eeeee102288882eeeeee12eee212ee221ee6ee00000000000000b11b00000000000000ffffffff44444444999944444499944400000000
004444440000000022eee44502288882ee7ee122ee212eee21eeeeee000000000000000bb000000000000000ffffffff44444444999944444444444400000000
000004440000000022eeeee102288882eeee1222e6e2eeee221eeeee00000000000000000000000000000000ffffffff44444444999944444444444400000000
000000440000000022eee44502288882eeeee122eeeee6ee2221e7ee00000000000000000000000000000000ffffffff44444444999444444444444400000000
000000040000000022eeeee102288882eeeeee12eeeeeeee221eeeee00000000000000000000000000000000ffffffff44444444994444440000000000000000
00000004999999990000000000000000000000000000000000000000000000000000000000000000000000004444449944444444000000004444444400000000
00000044999999990000000000000000000000000000000000000000000000000000000000000000000000004444499944444444400000004444444400000000
00000444999999990000000000000000000000000000000000000000000000000000000000000000000000004444999944444444444400004444444000000000
00444444999999990000000000000000000000000000000000000000000000000000000bb0000000000000004444999944044444444444004444444000000000
0444444499999999000000000000000000000000000000000000000000000000000000b11b000000000000004444999944044444444444404444440000000000
044444449999999900000000000000000000000000000000000000000000000000000b1111b00000000000004444499944044444444444444440000000000000
444444449999999900000000000000000000000000000000000000000000000000000b1aa1b00000000000004444449944404444444444444400000000000000
444444449999999900000000000000000000000000000000000000000000000000bbbb1aa1bbbb00000000004444444944440044444444444000000000000000
00000000000000000000000000000000888888887777777788888888aaaaaaaa0bbbbb1aa1bbbbb0000000004444444400000444444444404000000000000000
00000000000000000000000000000000800000087777777788888888aaaaaaaabbb00b1aa1b00bbb000000004444444400004444444444004400000000000000
00000000000000000000000000000000800000087777777788888888aaaaaaaabb000b1111b000bb000000004444444400044444444444004440000000000000
00000000000000000000000000000000880880087777777788888888aaaaaaaabb0000b11b0000bb000000000444444400044444444444004444440000000000
00000000000000000000000000000000880088087777777788888888aaaaaaaabb00000bb00000bb000000000044444400444444444440004444444000000000
00000000000000000000000000000000880008087777777788888888aaaaaaaabb000000000000bb000000000000444400444444444440004444444000000000
00000000000000000000000000000000880008087777777788888888aaaaaaaab00000000000000b000000000000000400444444444400004444444400000000
00000000000000000000000000000000888888887777777788888888aaaaaaaab00000000000000b000000000000000004444444444000004444444400000000
f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f0f0f0f0f0f0f0f5f5f5f5f5f5f5f5f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005c5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5c5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5b61616161616d5d4
f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f506c5b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4c5b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b61616161616d5d4
f5f0f0f5f0f0f0f5f5f5f5f5f5f5f5f0f0f00000000000000000a4a4a4a4a4b5b5b5b5b5b5b5b5b5b5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f5f0f0f0f0f0f5f5f5f5f5f5f5f5f5f000f0f00000000000a4a4a400000000000000000000000000b5b5b5b50000000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f0f0f5f5f5f0f5f5f5f5f5f5f5f5f5f0f00000000000a4a4a4000000000000000000000000000000000000b5b500000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f0f5f5f5f5f5f5f5f0f0f0f0f0f0f0f00000000000a4a4000000000000000000000000000000000000000000b5b5000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f000000000a4a40000000000000000000000000000000000000000000000b5000000000000000000000000000000000000
00f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f5f5f5f5f0f0f0f0f5f5f5f5f5f5f0f000f500a4a400000000000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5b5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0f0f5f5a4a4f5f5f5f500000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5b5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f4b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616d5d4
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0f0f0a4000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5b5b5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f4b61616161616d5e5e5e5e5e5e5e5e5e5c5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5c5e6
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4000000f500f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b61616161616d5b4b4b4b4b4b4b4b4b4c5b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4e7
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5d4a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1e1
e1f4b616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161667
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1
e1f4c5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5c5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5c5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5e1e1e1f5f5f5e1
e1b7c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c5c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6d7
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5e1e1e1e1e1
e1f5f5f5f5f6f5f5f6f6f6f5f5f5f5f5f5f5f6f5f5f5f5f6f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500000000f5f5f50000f500000000f5f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4a4f5f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f500f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500000000f5f50000f50000000000f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500000000f5f50000000000000000f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5f5f5f5a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f500f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500000000f5f50000000000000000f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4f5f5f5f5f5a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f500f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500000000f5f50000000000000000f5f5
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5a4a4a4a4a4a4a4f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f500f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5000000000000000000f5f5
d5e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f5f50000f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5000000000000000000f5f5
d5e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
00f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
d5e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7e7f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f500
f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
d5000000000000000000000000000000000000000000000000000000000000000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f5f5f5f5f5f500000000000000000000f600000000000000000000000000000000000000000000000000000000f5f5f5f5f5f5000000000000000000f5f5
d5000000000000000000000000000000000000000000000000000000000000000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5
f5f5f5f5f5f5f50000000000000000000000f600000000000000000000000000000000f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f50000000000000000000000
__gff__
02020202020202020202020200000000020202020202020202020202000000000202020202020202020200000000000002020202020202020202000000000000000000009000009040008040c0404040400000009000900000000000404040004000000000000000000000404040400000000000400004100000004040404000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
42534445454545454545454545544352004e00000000000000000000000000000000000000000000000000005f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f00000000000000000000000000006f000000000000000000000000000000005f5f5f5f5f5f5f5f5f5f5f5f5f5f5f005f5f0000000000000000000000
42534445454545454545454545544352000000000000000000000000000000000000000000000000000000005f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f005f5f0000000000000000000000
42534445454545454545454545544352000000000000000000000000000000000000000000000000000000005f0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f005f5f0000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f005f5f0000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f5f5f5f0f0f0f0f0f5f5f5f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f005f5f0000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f5f5f5f0f0f0f000f5f5f5f5f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f6f00000000000000000000
425344454545454545454545455443525a007575750000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61615d4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e6d
425344454545454545454545455443525a007500000075000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61615d4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b5c5c
425344454545454545454545455443525a007500000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
425344454545457745454545455443525a007575000075000075757500000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
4253444545454545454545454554435200007500000075000075007500000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
4253444545454545454545454554435200007500000075000075007500000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f5f5f6f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e6f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f1e006f6f6f6f6f6f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
4253444545464545454545454554435200000000000000000000000000000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f1e006f6f6f6f6f6f4f6b5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e61616161615d4d
42534445454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f6f6f6f6f6f6f4f5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c5c61616161615d4d
42534445454577454545774545474352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f605c4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b61616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e5f0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e5f0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e1e5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f4f6b61616161615d5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5e5c6e
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000001e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e5f5f5f5f4f6b61616161615d4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b5c7e
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
425356454545454545454545455443520000000000000000000000000000005f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
425356454545454545454545455443520000000000000000000000000000005f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f4f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
42535645454545454545454545544352000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004f6b61616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161615d4d
