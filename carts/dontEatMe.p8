pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
p = {
	x=64,
	y=-20,
	anim="fall",
	fall={f=0,st=0,sz=4,spd=2/5},
	fly_in_fall={f=16,st=16,sz=5,spd=2/5}
}

function controls()
	if (btn(0)) p.x -= 1
	if (btn(1)) p.x += 1
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

function _update()

	if(p.anim == "fly_in_fall")
	then p.anim="fall"
	end

	controls()
	autofall()
end

function _draw()
	cls()
	spr(anim_player(),p.x,p.y,2,2)
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
000000aaaa000000000000aaaa000000050000aaaa000000000000aaaa0000000000000000000000000400000000595599550000044000000000000000000000
00000aaaa000000005000aaaa000000000500aaaa000000005000aaaa00000000000000000000000000400000095599599590000440000000000000000000000
0055aaa0000000000555aaa0000000000005aaa0000000000555aaa0000000000000000000000000000400000559999599599000400000000000000000000000
055aa55000000000000aa55000000000000aaa5000000000000aa550000000000000000000000000000440000599999599559000440000000000000000000000
00005500000000000000050000000000000000550000000000000500000000000000000000000000000040009599999999999900040000000000000000000000
00005000000000000000050000000000000000050000000000000500000000000000000000000000000000009999999999999900000000000000000000000000
00000aaa00000000000000aa000000000000000a000000000000000a00000000000000aa00000000000000099999999999999990000000000000000000000000
000000aaa00000000000000aa0000000000000aa00000000000000aa000000000000000aa0000000000000099959999999999999000000000000000000000000
000060077a006000000000097a00000000000097a000000000000097a0000000000000077a00000000000a599959999559999559900000000000000000000000
000060097a006000000000077a00000000000077c000000000000077c0000000000000097a0000000000a5599599995859999999999000000000000000000000
0000660aaaa660000000000aaaa00000000000aaca000000000000aaca0000000000000aaaa0000000aaa5999999995885999999999900000000000000000000
000006688a66000000000008aaa000000000008aaa0000000000008aaa00000000000008aaa0000000aaa999999995a885599999599999000000000000000000
000000688a60000000666668aa6666600000068aa66000000000068aa660000000666668aa66666000aaa99999999588aaa55999559999000000000000000000
0000000aaaa000000000000aaaa00000000006aaaa600000000006aaaa6000000000000aaaa000000999999999995a88aaaa5599955999900000000000000000
0000000aaaa000000000000aaaa00000000066aaaa600000000066aaaa6000000000000aaaa00000099999999995a88aaaaaa559999999900000000000000000
000000aaaaa000000000000aaaa00000000060aaaa060000000060aaaa0600000000000aaaa0000000a99999995a888aaaaaaaa5555999900000000000000000
000000aaaa0000000000000aaa000000000060aaa0060000000060aaa00600000000000aaa00000000aaa55555aa888aaaaaaaaaaa5555500000000000000000
05000aaaa50000000000000aaa000000000000aaa0000000000000aaa00000000000000aaa0000000000aaaaaaa8888aaaaaaaaaaaa000000000000000000000
0555aa5555000000000005aaa0000000000000aa50000000000000aa50000000000005aaa00000000000000088888888aaaaaa00000000000000000000000000
000aaa0000000000000005a5500000000000005a500000000000005a5000000000005aa5500000000000000888888888aaa00000000000000000000000000000
00000000000000000000500055000000000000505000000000000050500000000000500055000000000000000000000000000000000000000000000000000000
00000000000000000000500005000000000000505000000000000050500000000000500005000000000000000000000000000000000000000000000000000000
__gff__
0202020202020202020202020000000002020202020202020202020200000000020202020202020202020000000000000202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
