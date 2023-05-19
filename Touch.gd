extends Control

const PLAYER = preload("res://Player.tscn")

export(Resource) var user_settings

var _colours := []
var _rng := RandomNumberGenerator.new()

onready var _player_list := $Players as Control
onready var _timer := $Timer as Timer
onready var _effect := $Particles as CPUParticles2D
onready var _effect_colour := $ColourParticles as CPUParticles2D

func _ready() -> void:
	_setup(user_settings as UserSettings)

func _setup(settings: UserSettings) -> void:
	VisualServer.set_default_clear_color(settings.background_colour)
	_colours = settings.player_colours
	_timer.wait_time = settings.press_duration
	randomize()
	_rng.randomize()
	_reset()

func _reset() -> void:
	_colours.shuffle()
	_effect.emitting = false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_add_player(event.index, event.position)
		else:
			_remove_player(event.index)
	elif event is InputEventScreenDrag:
		_move_player(event.index, event.position)

func _add_player(index: int, position: Vector2) -> void:
	var player := PLAYER.instance() as PlayerIndicator
	_player_list.add_child(player)
	player.rect_position = position
	player.name = str(index)
	var colour := _colours[index % _colours.size()] as Color
	player.colour = colour
	_timer.start()

func _remove_player(index: int) -> void:
	var node = _player_list.get_node(str(index)) as PlayerIndicator
	_player_list.remove_child(node)
	_timer.stop()
	if _player_list.get_child_count() > 0:
		_timer.start()
	else:
		_reset()

func _move_player(index: int, position: Vector2) -> void:
	_player_list.get_node(str(index)).rect_position = position

func _process(_delta: float) -> void:
	for player in _player_list.get_children():
		player.progress = 1.0 - (_timer.time_left / _timer.wait_time)

func _choose_first_player() -> void:
	var i = _rng.randi_range(0, _player_list.get_child_count()-1)
	var starting_player := _player_list.get_child(i) as PlayerIndicator
	starting_player.select()
	_effect.global_position = starting_player.rect_global_position
	_effect_colour.global_position = starting_player.rect_global_position
	_effect_colour.color = starting_player.colour
	_effect.restart()
	_effect_colour.restart()
	_effect.emitting = true
	_effect_colour.emitting = true
