pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
p = {
	x=64,
	y=-20,
	anim="fall",
	direction="right",
	fall={f=0,st=0,sz=4,spd=2/5},
	fly_in_fall={f=16,st=16,sz=5,spd=2/5}
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

function controls()
	if (btn(0)) then
		p.direction="left"
		if not hit(p.x+4, p.y, 1, 1, 7) then
			p.x -= 1
		end
	end
	if (btn(1)) then
		p.direction="right"
		if not hit(p.x+10, p.y, 1, 1, 7) then
			p.x += 1
		end
	end
	if (btn(3)) p.y += 1

	if(p.anim == "fall"
	or p.anim == "fly_in_fall")
	then
  if (btn(2)) then
  	p.anim="fly_in_fall"
  	p.y -= 1.25
  end
 else
		if (btn(2)) p.y -= 1
	end
	
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
	end
end

function autofall()
	p.y += 1
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

	if(p.anim == "fly_in_fall")
	then p.anim="fall"
	end

	controls()
	autofall()

	bubble.y -= 0.75
	background.y += 1
end

function _draw()
	cls()
	
	map(0,0,background.x,background.y,16,16)
	
	if(p.direction == "left") then
		spr(anim_player(),p.x,p.y,2,2,false)
	else
		spr(anim_player(),p.x,p.y,2,2,true)
	end

	spr(64,bubble.x,bubble.y)
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
02288882eeeeeeee1eeeee222888822021eeeeeeeeeeeeeeeeeeeeeeeeeee1220000000000000000000000000000000000000000000000000000000000000000
02288882eeeeeeee544eee2228888220221eeeeeeeeeeeeeeeeeeeeeee7e12220000000000000000000000000000000000000000000000000000000000000000
02288882eeee6eee1eeeee22288882202221eeeee7eeeeeee6eeeeeeeeeee1220000000000000000000000000000000000000000000000000000000000000000
02287882eee66eee544eee2228888220221ee7eeeeeee7eeeeeee6eeeeeeee120000000000000000000000000000000000000000000000000000000000000000
02278782ee6eeeee1eeeee222888822021eeeeeeeeeeeeeeeeeeeeeeee6ee1220000000000000000000000000000000000000000000000000000000000000000
02287882e666eeee544eee2228888220221eeeeee6eeeeeee7eeeeeeeeee12220000000000000000000000000000000000000000000000000000000000000000
02288882eeeeeeee1eeeee22288882202221e6eeeeeee6eeeeeee7eeeeeee1220000000000000000000000000000000000000000000000000000000000000000
02288882eeeeeeee544eee2228888220221eeeeeeeeeeeeeeeeeeeeeeeeeee120000000000000000000000000000000000000000000000000000000000000000
000000000000000022eee44502288882eeeee122eeeeeeee21eeeeee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eeeee102288882ee6e1222e7eeeeee221eeeee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eee44502288882eeeee122eeee2eee2221eeee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eeeee102288882eeeeee12eee212ee221ee6ee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eee44502288882ee7ee122ee212eee21eeeeee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eeeee102288882eeee1222e6e2eeee221eeeee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eee44502288882eeeee122eeeee6ee2221e7ee000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000022eeeee102288882eeeeee12eeeeeeee221eeeee000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0202020202020202020202020000000002020202020202020202020200000000020202020202020202020000000000000202020202020202020200000000000000000000800000800000000000000000000000008000800000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4253444545454545454545454554435200590000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
425344454545454545454545455443525a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545464545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253444545454545454545454547435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4253564545454545454545454554435200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
