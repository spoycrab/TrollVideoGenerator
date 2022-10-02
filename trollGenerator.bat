@echo off

@REM deletes previous generated video
del output.mp4
@REM gets video resolution and stores it into a variable
set "CommandLine=ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=':':p=0 %~dp0\troll\troll.mp4"
setlocal EnableDelayedExpansion
for /F "delims=" %%I in ('!CommandLine!') do set "codec=%%I"

ffmpeg -i %~1 -vf "scale=%codec%:force_original_aspect_ratio=decrease,pad=%codec%:-1:-1:color=black" resizedTemp.png
ffmpeg -i %~dp0\troll\troll.mp4 -i resizedTemp.png -filter_complex "[0:v][1:v] overlay=(W-w)/2:(H-h)/2:enable='between(t,0,0.1)'" -pix_fmt yuv420p -c:a copy output.mp4
del resizedTemp.png
endlocal
