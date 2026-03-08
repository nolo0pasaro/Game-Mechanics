extends Area2D
class_name Interactable

@export var prompt_text: String = "Press [E] to interact"
@export var max_interact_distance: float = 64.0

signal interacted()

var player_in_range: CharacterBody2D = null

func _ready() -> void:
	add_to_group("interactables")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_layer = 0  # Optional: not solid
	collision_mask = 1   # Hits player layer (assume player on layer 1)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		player_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null

func can_interact(player_pos: Vector2) -> bool:
	return player_in_range != null and global_position.distance_to(player_pos) <= max_interact_distance

func interact() -> void:
	interacted.emit()
