function gifit --argument-names "in" "out"
	ffmpeg -i $in -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $out
end
