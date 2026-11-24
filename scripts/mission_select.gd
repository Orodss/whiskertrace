extends Control
## A display-only mission map. Locks are presentation, not progression logic yet.

signal back_requested

const CREAM := Color("f8ebd9")
const INK := Color("624a3d")
const SAGE := Color("b5b49b")
const APRICOT := Color("dfa98f")
const TAUPE := Color("9b7a67")
const MISSION_NAMES := ["The Golden Tuna Heist", "The Phishy Fish", "Misteri berikutnya"]
const BACKGROUND := preload("res://assets/backgrounds/pawcity.png")
var captions: Array[VBoxContainer] = []


func _ready() -> void:
	$Back.pressed.connect(back_requested.emit)
	for index in range(3):
		var caption := VBoxContainer.new()
		caption.name = "Mission%d" % (index + 1)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		caption.add_theme_constant_override("separation", 8)
		add_child(caption)
		captions.append(caption)
		var title := Label.new()
		title.text = "Mission %d" % (index + 1)
		title.theme_type_variation = &"GameTitle"
		title.add_theme_font_size_override("font_size", 32)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.add_child(title)
		var name_label := Label.new()
		name_label.text = MISSION_NAMES[index]
		name_label.add_theme_font_size_override("font_size", 16)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.add_child(name_label)
	resized.connect(_layout)
	_layout()


func _center(index: int) -> Vector2:
	return Vector2(size.x * (0.2 + index * 0.3), size.y * 0.44 + index * 20)


func _layout() -> void:
	for index in range(captions.size()):
		captions[index].position = _center(index) + Vector2(-140, 108)
		captions[index].size = Vector2(280, 112)
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), CREAM)
	# One static texture, drawn before the mission islands and character layer.
	draw_texture_rect(BACKGROUND, Rect2(Vector2.ZERO, size), false)
	# Stepped islands follow the three separate areas in the supplied sketch.
	for index in range(3):
		var center := _center(index)
		var outline := PackedVector2Array([
			Vector2(-124, -40), Vector2(-108, -40), Vector2(-108, -72),
			Vector2(-76, -72), Vector2(-76, -88), Vector2(44, -88),
			Vector2(44, -72), Vector2(92, -72), Vector2(92, -48),
			Vector2(120, -48), Vector2(120, -8), Vector2(136, -8),
			Vector2(136, 40), Vector2(112, 40), Vector2(112, 72),
			Vector2(64, 72), Vector2(64, 88), Vector2(-64, 88),
			Vector2(-64, 72), Vector2(-108, 72), Vector2(-108, 48), Vector2(-124, 48)])
		for point in range(outline.size()):
			outline[point] += center
		draw_set_transform(Vector2(0, 10))
		draw_colored_polygon(outline, TAUPE.lightened(0.2))
		draw_set_transform(Vector2.ZERO)
		draw_colored_polygon(outline, SAGE if index == 0 else SAGE.lightened(0.23))
		_tile(center, -16, 20, 32, 68, Color("e7d3b5"))
		_house(center, index > 0)
		_tree(center + Vector2(-86, 8))
		_tree(center + Vector2(86, 40))
		if index > 0:
			_lock(center + Vector2(0, -4))
		else:
			_tile(center, 54, -78, 4, 48, INK)
			_tile(center, 58, -78, 28, 18, APRICOT)


func _tile(origin: Vector2, x: float, y: float, width: float, height: float, color: Color) -> void:
	draw_rect(Rect2(origin + Vector2(x, y), Vector2(width, height)), color)


func _house(origin: Vector2, locked: bool) -> void:
	var wall := Color("ddc9af") if locked else APRICOT
	_tile(origin, -48, -42, 96, 76, TAUPE)
	_tile(origin, -44, -38, 88, 68, wall)
	_tile(origin, -56, -50, 112, 12, INK if not locked else TAUPE)
	_tile(origin, -44, -62, 88, 12, TAUPE)
	_tile(origin, -28, -74, 56, 12, TAUPE)
	for x in [-30, 18]:
		_tile(origin, x, -22, 16, 20, CREAM)
		_tile(origin, x + 6, -22, 4, 20, TAUPE)
	_tile(origin, -10, 8, 20, 26, INK)


func _tree(origin: Vector2) -> void:
	_tile(origin, -4, -12, 8, 32, TAUPE)
	_tile(origin, -20, -28, 40, 24, Color("93967e"))
	_tile(origin, -12, -40, 24, 40, Color("93967e"))
	_tile(origin, -12, -28, 12, 8, SAGE)


func _lock(origin: Vector2) -> void:
	_tile(origin, -28, -34, 56, 64, CREAM)
	_tile(origin, -14, -26, 28, 26, INK)
	_tile(origin, -8, -20, 16, 20, CREAM)
	_tile(origin, -22, -4, 44, 28, INK)
	_tile(origin, -3, 4, 6, 12, CREAM)
