extends Control

export(Color) var colour: Color = Color.red setget _set_colour
export(float) var progress: float = 0.0 setget _set_progress

var _finished: bool = false
var _selected: bool = false

onready var circle := $Panel as Panel
onready var ring := $TextureProgress as TextureProgress

func _set_colour(new_colour: Color) -> void:
	colour = new_colour
	circle.get("custom_styles/panel").bg_color = colour

func _set_progress(new_progress: float) -> void:
	if _finished: 
		return
	progress = new_progress
	ring.value = progress
	if progress >= 1.0:
		_finished = true
		ring.visible = false
		if not _selected:
			circle.get("custom_styles/panel").bg_color = Color.gray

func select():
	_selected = true
	circle.get("custom_styles/panel").bg_color = colour
