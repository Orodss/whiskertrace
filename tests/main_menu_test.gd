extends SceneTree
## Run with --path . --script tests/main_menu_test.gd (optionally --headless).


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var menu: Control = load("res://scenes/main_menu.tscn").instantiate()
	root.add_child(menu)
	await process_frame
	await process_frame
	var start: Button = menu.get_node("%Start")
	var missions: Control = menu.get_node("MissionSelect")
	var back: Button = missions.get_node("Back")
	assert(start.has_focus(), "Start must be reachable immediately by keyboard")
	assert(not missions.visible)
	var cats = menu.get_node("Cats")
	cats.set_process(false)
	var original_x: float = cats.cat_x(0)
	cats._process(0.5)
	assert(cats.cat_x(0) > original_x, "Cats must walk left to right")
	cats.elapsed = 100000.0
	for index in range(4):
		assert(cats.cat_x(index) >= -32.0 and cats.cat_x(index) < cats.size.x / 4.0 + 32.0,
				"Cats must wrap into the visible lane even after a long session")
	cats.elapsed = 0.5
	cats.queue_redraw()
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		DirAccess.make_dir_recursive_absolute("res://build")
		root.get_texture().get_image().save_png("res://build/main-menu.png")
		for window_size in [Vector2i(800, 600), Vector2i(1280, 800), Vector2i(1920, 1080)]:
			root.size = window_size
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var content: Control = menu.get_node("Center/Content")
			var footer: Control = menu.get_node("Footer")
			assert(content.get_global_rect().end.y < footer.position.y,
					"Menu content must not overlap the footer")
			assert(root.get_visible_rect().encloses(content.get_global_rect()),
					"Menu content must fit within the viewport")
			root.get_texture().get_image().save_png(
					"res://build/main-menu-%dx%d.png" % [window_size.x, window_size.y])
	var enter := InputEventAction.new()
	enter.action = "ui_accept"
	enter.pressed = true
	Input.parse_input_event(enter)
	await process_frame
	enter = InputEventAction.new()
	enter.action = "ui_accept"
	enter.pressed = false
	Input.parse_input_event(enter)
	await process_frame
	assert(missions.visible, "Keyboard activation must open the missions")
	var cast = missions.get_node("Cast")
	cast.set_process(false)
	cast.elapsed = 2.0
	var cast_x: float = cast.cat_x(0)
	cast._process(0.5)
	assert(cast.cat_x(0) > cast_x, "Pawcity characters must walk to the right")
	cast.queue_redraw()
	for index in range(1, 4):
		assert(missions.get_node("Mission%d" % index) is VBoxContainer,
				"Missions are display-only, not actionable buttons")
	assert(back.has_focus(), "Focus must enter the missions")
	assert(start.focus_mode == Control.FOCUS_NONE)
	assert(not cats.animation_enabled, "Mission selection pauses background motion")
	var paused_time: float = cats.elapsed
	cats._process(1.0)
	assert(cats.elapsed == paused_time, "Mission selection must keep background still")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://build/missions.png")
		for window_size in [Vector2i(800, 600), Vector2i(1280, 800), Vector2i(1920, 1080)]:
			root.size = window_size
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			for index in range(1, 4):
				var caption: Control = missions.get_node("Mission%d" % index)
				assert(root.get_visible_rect().encloses(caption.get_global_rect()))
			root.get_texture().get_image().save_png(
					"res://build/missions-%dx%d.png" % [window_size.x, window_size.y])
	back.pressed.emit()
	assert(not missions.visible and start.has_focus())
	var hidden_time: float = cast.elapsed
	cast._process(1.0)
	assert(cast.elapsed == hidden_time, "Hidden Pawcity animation must stop updating")
	assert(cats.animation_enabled, "Closing missions resumes animation")
	start.pressed.emit()
	var escape := InputEventAction.new()
	escape.action = "ui_cancel"
	escape.pressed = true
	Input.parse_input_event(escape)
	await process_frame
	assert(not missions.visible and start.has_focus(), "Escape must return to Start")
	print("PASS: initial focus, keyboard Start, modal focus, Back, Escape; rendered layouts when GPU enabled")
	quit()
