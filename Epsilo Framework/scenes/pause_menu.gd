extends Control
@onready var pause = $"."

var paused : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pausemenu()
func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
		paused = false

func _on_settings_pressed() -> void:
	print("Settings Clicked!")

func _on_quit_pressed() -> void:
	get_tree().quit()

func pausemenu():
	
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		get_tree().paused = true
	paused = !paused
