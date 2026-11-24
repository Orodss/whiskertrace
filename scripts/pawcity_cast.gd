extends "res://scripts/pixel_cats.gd"
## Larger front-three-quarter faces keep the story cast readable while walking.

const FURS := [Color("dfa98f"), Color("fff4df"), Color("655951"), Color("aaa69d")]
const OUTFITS := [Color("9b7a67"), Color("b5b49b"), Color("817369"), Color("dfa98f")]
const BLUE := Color("6d8994")
const PINK := Color("d79591")


func cat_x(index: int) -> float:
	var width := size.x / 4.0
	var initial_x := width * (0.04 + index * 0.22)
	return fposmod(initial_x + 32.0 + elapsed * SPEEDS[index], width + 64.0) - 32.0


func _draw() -> void:
	for index in range(4):
		var origin := Vector2(floorf(cat_x(index)) * 4.0,
				floorf((size.y * 0.97 - (index % 2) * 8) / 4.0) * 4.0)
		_draw_character(origin, index, int(elapsed * 6 + index) % 4)


func _draw_character(origin: Vector2, index: int, step: int) -> void:
	var fur: Color = FURS[index]
	var outfit: Color = OUTFITS[index]
	var stride := 1 if step < 2 else -1
	_pixel(origin, 0, 1, 26, 1, Color(0.384, 0.29, 0.239, 0.18))
	_pixel(origin, -3, -12 + stride, 3, 9, INK)
	_pixel(origin, -2, -11 + stride, 1, 7, fur)
	_pixel(origin, -2, -5, 6, 3, fur)
	for leg_x in [7 + stride, 18 - stride]:
		_pixel(origin, leg_x, -5, 4, 5, INK)
		_pixel(origin, leg_x + 1, -4, 2, 3, fur)
		_pixel(origin, leg_x, -1, 6, 2, INK)
	var body := origin + Vector2(0, (step % 2) * 4)
	_pixel(body, 4, -17, 21, 13, INK)
	_pixel(body, 5, -16, 19, 11, outfit)
	_pixel(body, 2, -14 + stride, 4, 8, fur)
	_pixel(body, 24, -14 - stride, 4, 8, fur)
	_pixel(body, 13, -15, 2, 10, INK)
	_pixel(body, 16, -10, 1, 1, CREAM)
	_pixel(body, 16, -7, 1, 1, CREAM)
	# Wide face with inner ears, two eyes and highlights, muzzle and whiskers.
	_pixel(body, 2, -36, 6, 8, INK)
	_pixel(body, 21, -36, 6, 8, INK)
	_pixel(body, 3, -35, 4, 7, fur)
	_pixel(body, 22, -35, 4, 7, fur)
	_pixel(body, 4, -33, 2, 4, PINK)
	_pixel(body, 23, -33, 2, 4, PINK)
	_pixel(body, 1, -30, 27, 12, INK)
	_pixel(body, 3, -32, 23, 16, INK)
	_pixel(body, 3, -29, 23, 11, fur)
	_pixel(body, 4, -31, 21, 14, fur)
	_pixel(body, 8, -22, 16, 5, CREAM)
	for eye_x in [8, 19]:
		_pixel(body, eye_x - 1, -28, 4, 1, INK)
		_pixel(body, eye_x, -26, 3, 4, INK)
		_pixel(body, eye_x, -26, 1, 2, Color.WHITE)
	_pixel(body, 14, -22, 3, 2, PINK)
	_pixel(body, 15, -20, 1, 2, INK)
	_pixel(body, 12, -18, 7, 1, INK)
	_pixel(body, 0, -22, 6, 1, INK)
	_pixel(body, 1, -19, 5, 1, INK)
	_pixel(body, 25, -22, 5, 1, INK)
	_pixel(body, 25, -19, 4, 1, INK)
	match index:
		0: # Detective Whiskers: fedora, coat lapels, orange forehead markings.
			_pixel(body, 5, -37, 19, 5, INK)
			_pixel(body, 7, -39, 15, 4, OUTFITS[0])
			_pixel(body, 0, -33, 29, 2, INK)
			_pixel(body, 11, -31, 2, 2, INK)
			_pixel(body, 16, -31, 2, 2, INK)
			_pixel(body, 8, -16, 4, 4, CREAM)
			_pixel(body, 17, -16, 4, 4, CREAM)
		1: # Sir Purrcival: cream-white face and blue tie.
			_pixel(body, 10, -16, 10, 3, CREAM)
			_pixel(body, 14, -16, 3, 8, BLUE)
			_pixel(body, 13, -10, 5, 2, BLUE)
		2: # Mr. Clawford: dark fur, hoodie, clearly outlined glasses.
			for lens_x in [6, 17]:
				_pixel(body, lens_x, -28, 7, 1, CREAM)
				_pixel(body, lens_x, -22, 7, 1, CREAM)
				_pixel(body, lens_x, -28, 1, 7, CREAM)
				_pixel(body, lens_x + 6, -28, 1, 7, CREAM)
			_pixel(body, 13, -26, 4, 1, CREAM)
			_pixel(body, 10, -15, 1, 5, CREAM)
			_pixel(body, 19, -15, 1, 5, CREAM)
		3: # Miss Mochi: gray fur, pink bow and cheeks.
			_pixel(body, 19, -35, 4, 5, PINK)
			_pixel(body, 25, -35, 4, 5, PINK)
			_pixel(body, 23, -33, 2, 2, INK)
			_pixel(body, 5, -22, 3, 2, PINK)
			_pixel(body, 23, -22, 2, 2, PINK)
