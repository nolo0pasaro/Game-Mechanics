extends CharacterBody2D
class_name Player


@export var inv: Inv
@export var speed : float = 300.0
@export var jump_velocity: float = -500.0
#@export var double_jump_velocity: float = -150.0
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D



#var gravity = ProjectSettings.get_settings("physics/2d/default_gravity")
#var has_double_jumped: bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("player")
	if RoomManager.activate:
		global_position = RoomManager.player_pos
		RoomManager.activate = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()

func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("walk")
			animated_sprite.flip_h = direction.x < 0
		else:
			animated_sprite.play("idle")
			
func player():
	pass

func collect(item):
	inv.insert(item)
