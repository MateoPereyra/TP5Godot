extends Sprite2D

@export var speed = 400

@onready var mouse_pos = get_viewport().get_mouse_position()
@onready var sfx_enabled = true;

var target = position
var radio_sprite = texture.get_size().x / 2
var currentScore := 0

func _input(event):
	if event.is_action_pressed("click") && %GamePanel.get_global_rect().has_point(mouse_pos):
		move_frog()

func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	
	if global_position.distance_to(target) > radio_sprite:
		global_position += global_position.direction_to(target) * speed * delta
		
	global_position.x = max(global_position.x, 600)
	
	%Position.text = "X: %d Y: %d" % [int(position.x), int(position.y)]

func _on_sfx_button_toggled(toggled_on: bool) -> void:
	sfx_enabled = !toggled_on

func _on_bgm_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%BGM.stream_paused = true
	else:
		%BGM.stream_paused = false

func move_frog():
	if sfx_enabled:
		$SFX.play()
	target = mouse_pos
	currentScore += 1
	%Score.text = "SCORE: %d" % [int(currentScore)]
