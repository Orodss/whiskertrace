extends Control
## Title screen and display-only Pawcity mission selection.

@onready var start_button: Button = %Start
@onready var missions: Control = $MissionSelect
@onready var back_button: Button = $MissionSelect/Back
@onready var cats: Control = $Cats


func _ready() -> void:
	get_window().min_size = Vector2i(800, 600)
	start_button.pressed.connect(_open_missions)
	missions.back_requested.connect(_close_missions)
	start_button.grab_focus()


func _open_missions() -> void:
	missions.show()
	$Center.hide()
	start_button.focus_mode = Control.FOCUS_NONE
	cats.animation_enabled = false
	back_button.grab_focus()


func _close_missions() -> void:
	missions.hide()
	$Center.show()
	start_button.focus_mode = Control.FOCUS_ALL
	cats.animation_enabled = true
	start_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if missions.visible and event.is_action_pressed("ui_cancel"):
		_close_missions()
		get_viewport().set_input_as_handled()
