extends Control
## Small code-native pixel characters; no sprite library or physics required.

const INK := Color("624a3d")
const CREAM := Color("f8ebd9")
const COATS := [Color("dfa98f"), Color("b5b49b"), Color("9b7a67"), Color("ead5b9")]
const SPEEDS := [18.0, 13.0, 21.0, 16.0]
const OFFSETS := [0.06, 0.32, 0.59, 0.84]

var animation_enabled := true
var elapsed := 0.0
var redraw_elapsed := 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


func _process(delta: float) -> void:
	if not animation_enabled or not is_visible_in_tree():
		return
	elapsed += delta
	redraw_elapsed += delta
	if redraw_elapsed >= 0.1:
		redraw_elapsed = fmod(redraw_elapsed, 0.1)
		queue_redraw()


func cat_x(index: int) -> float:
	var width := size.x / 4.0
	return fposmod(OFFSETS[index] * (width + 64.0) + elapsed * SPEEDS[index], width + 64.0) - 32.0


func _draw() -> void:
	for index in range(COATS.size()):
		var origin := Vector2(floorf(cat_x(index)) * 4.0,
				floorf(size.y * (0.94 if index % 2 == 0 else 0.98) / 4.0) * 4.0)
		var step := int(elapsed * 6.0 + index) % 4
		_draw_cat(origin, COATS[index], COATS[(index + 1) % COATS.size()], step)


func _pixel(origin: Vector2, x: int, y: int, width: int, height: int, color: Color) -> void:
	draw_rect(Rect2(origin + Vector2(x, y) * 4.0, Vector2(width, height) * 4.0), color)


func _draw_cat(origin: Vector2, fur: Color, scarf: Color, step: int) -> void:
	var stride := 1 if step < 2 else -1
	var bob := 1 if step % 2 == 0 else 0
	_pixel(origin, 0, 1, 19, 1, Color(0.384, 0.29, 0.239, 0.18))
	# Tail and walking feet remain separate from the bobbing body.
	_pixel(origin, -2, -9 + stride, 3, 2, INK)
	_pixel(origin, -3, -13 + stride, 2, 5, INK)
	_pixel(origin, -2, -12 + stride, 1, 4, fur)
	_pixel(origin, 4 + stride, -4, 3, 4, INK)
	_pixel(origin, 11 - stride, -4, 3, 4, INK)
	_pixel(origin, 5 + stride, -1, 4, 1, INK)
	_pixel(origin, 12 - stride, -1, 4, 1, INK)
	var body := origin + Vector2(0, bob * 4)
	_pixel(body, 1, -13, 14, 9, INK)
	_pixel(body, 2, -12, 12, 7, fur)
	_pixel(body, 9, -11, 4, 5, CREAM)
	# Upright ears, right-facing muzzle, eye, nose, and whisker.
	_pixel(body, 3, -24, 3, 5, INK)
	_pixel(body, 12, -24, 3, 5, INK)
	_pixel(body, 4, -23, 1, 3, scarf)
	_pixel(body, 13, -23, 1, 3, scarf)
	_pixel(body, 2, -21, 15, 9, INK)
	_pixel(body, 3, -20, 13, 7, fur)
	_pixel(body, 14, -17, 4, 4, INK)
	_pixel(body, 13, -16, 4, 2, CREAM)
	_pixel(body, 13, -19, 1, 2, INK)
	_pixel(body, 17, -17, 1, 1, INK)
	_pixel(body, 15, -14, 4, 1, INK)
	_pixel(body, 3, -13, 12, 2, scarf)
	_pixel(body, 2, -12, 3, 4, scarf)
