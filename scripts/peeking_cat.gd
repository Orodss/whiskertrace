extends Control
## Decorative pixel cat behind the top edge, with paws resting on the button.

const INK := Color("624a3d")
const FUR := Color("f8ebd9")
const APRICOT := Color("dfa98f")


func _ready() -> void:
	resized.connect(queue_redraw)


func _draw() -> void:
	var origin := Vector2(size.x - 104, -54)
	# The lower head ends at the button edge; only the paws overlap its surface.
	for ear_x in [1, 17]:
		_pixel(origin, ear_x, 0, 4, 7, INK)
		_pixel(origin, ear_x + 1, 1, 2, 5, APRICOT)
	_pixel(origin, 1, 6, 20, 12, INK)
	_pixel(origin, 0, 9, 22, 7, INK)
	_pixel(origin, 2, 7, 18, 11, FUR)
	_pixel(origin, 1, 10, 20, 6, FUR)
	_pixel(origin, 3, 7, 5, 3, APRICOT)
	_pixel(origin, 15, 7, 4, 4, APRICOT)
	_pixel(origin, 5, 11, 2, 3, INK)
	_pixel(origin, 15, 11, 2, 3, INK)
	_pixel(origin, 5, 11, 1, 1, Color.WHITE)
	_pixel(origin, 15, 11, 1, 1, Color.WHITE)
	_pixel(origin, 10, 14, 2, 1, APRICOT)
	_pixel(origin, 10, 15, 1, 1, INK)
	_pixel(origin, 8, 16, 5, 1, INK)
	for paw_x in [3, 15]:
		_pixel(origin, paw_x, 17, 5, 3, FUR)
		_pixel(origin, paw_x + 1, 19, 1, 1, APRICOT)
		_pixel(origin, paw_x + 3, 19, 1, 1, APRICOT)


func _pixel(origin: Vector2, x: int, y: int, width: int, height: int, color: Color) -> void:
	draw_rect(Rect2(origin + Vector2(x, y) * 3.0, Vector2(width, height) * 3.0), color)
