-- A little script to gather any application windows that are partially
-- offscreen in some way and shift them back to the desktop. This is
-- particularly useful if you use a MacBook with an external display.
-- Origin: https://github.com/bradchoate/gather-windows

tell application "Finder"
	-- get desktop dimensions (dw = desktop width; dh = desktop height)
	set db to bounds of window of desktop
	set {dw, dh} to {item 3 of db, item 4 of db}
end tell

tell application "System Events"
	repeat with proc in application processes
		tell proc
			repeat with win in windows
				-- get window dimensions (w = width; h = height)
				set {w, h} to size of win

				-- get window postion (l = left of window; t = top of window)
				set {l, t} to position of win

				-- nh = new window height; nw = new window width
				set {nh, nw} to {h, w}

				-- window width is bigger than desktop size,
				-- so set new window width to match the desktop
				if (w > dw) then Â
					set nw to dw

				-- window height is bigger than the desktop size (minus menu bar),
				-- so set new window height to be desktop height - 22 pixels
				if (h > dh - 22) then Â
					set nh to dh - 22

				-- r = right coordinate of window; b = bottom coordinate of window
				set {r, b} to {l + nw, t + nh}

				-- nl = new left coordinate; nt = new top coordinate
				set {nl, nt} to {l, t}

				-- left coordinate is off screen, so set new left coordinate
				-- to be 0 (at the left edge of the desktop)
				if (l < 0) then Â
					set nl to 0

				-- top coordinate is above bottom of menu bar (22 pixels tall),
				-- so set new top coordinate to be 22
				if (t < 22) then Â
					set nt to 22

				-- right coordinate extends beyond desktop width,
				-- so set new left coordinate to be desktop width - window width
				if (r > dw) then Â
					set nl to dw - nw

				-- bottom coordinate extends beyond desktop height,
				-- so set new top coordinate to be desktop height - window height
				if (b > dh) then Â
					set nt to dh - nh

				-- if we have calculated a new top or left coordinate, reposition window
				if (l ­ nl or t ­ nt) then Â
					set position of win to {nl, nt}

				-- if we have calculated a new height or width, resize window
				if (h ­ nh or w ­ nw) then Â
					set size of win to {nw, nh}
			end repeat
		end tell
	end repeat
end tell
