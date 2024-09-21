extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	Loading.visible = false
	Hud.Begin()
	Ending.buttons_refresh = false
	Ending.can_click = false
	Ending.ButtonSubmit.visible = true
	Ending.ButtonDeny.visible = true
	Ending.ButtonDestroy.visible = true
	Ending.AnimPlayer.play_backwards("fade")
	Music2d.Pause()

