cd /d %~dp0
"%godot%" --headless -q ../suika-game/project.godot --export-release "Windows Desktop" "../build/win/suika.exe"
robocopy ../suika-game/streaming_data ../build/win/streaming_data /E /XF secret.ini *.import
