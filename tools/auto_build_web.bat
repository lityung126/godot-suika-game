cd /d %~dp0
"%godot%" --headless -q ../suika-game/project.godot --export-release "web" "../build/web/index.html"