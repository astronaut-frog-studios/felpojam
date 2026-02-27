extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer

func resume() -> void:
	get_tree().paused = false
	$Moldura/resume.button_pressed = false
	animation.play_backwards("blur")
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED

func pause() -> void:
	get_tree().paused = true
	animation.play("blur")
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED

func testEsc() -> void:
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_button_down() -> void:
	resume()

func _on_quit_button_down() -> void:
	get_tree().quit()

func _process(_delta: float) -> void:
	testEsc()
