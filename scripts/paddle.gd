extends CharacterBody2D

@export var speed: float = 100.0
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _physics_process(_delta):
	var target_x = get_viewport().get_mouse_position().x
	target_x = clamp(target_x, collision.shape.size.x/2, get_viewport_rect().size.x - collision.shape.size.x/2)
	velocity.x = (target_x - position.x) * speed
	velocity.y = 0
	move_and_slide()
