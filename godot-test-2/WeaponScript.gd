extends Node2D

@onready var anim_player = $"../../AnimationPlayer"
@onready var camera = $".."
@onready var raycast = $"../RayCast3D"
@onready var player = $"../../.."

var is_swaying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_sway(is_moving: bool) -> void:
	if is_moving:
		sway()
	else:
		stop_sway()
func sway():
	if not is_swaying:
		anim_player.play("walksway")
		is_swaying = true

func stop_sway():
		anim_player.play("idle")
		is_swaying = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
