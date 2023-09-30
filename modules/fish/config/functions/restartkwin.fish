function restartkwin
	pkill kwin_x11
	kwin_x11 &> /dev/null &
	disown
end
