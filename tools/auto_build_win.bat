cd /d %~dp0
%godot% --headless -q ../suika-game/project.godot --export-release "Windows Desktop" "../builds/win/suika.exe"
robocopy ../suika-game/streaming_data ../builds/win/streaming_data /E /XF *.import