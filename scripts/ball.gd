extends CharacterBody2D

#velocita nornale = 500.0
#aggiungere facile e difficile
var base_spped: float = 400.0
var speed: float = 400.0 #viene calcolata in ready
var direction: Vector2 = Vector2.DOWN
var IsGameOver: bool = false
var global_pos_paddle_y_fix: float = 0.0
func _ready():
	direction = Vector2.DOWN.rotated(randf_range(-PI/4, PI/4))
	global_pos_paddle_y_fix = $"../Paddle".global_position.y
	#incrementa la velocità del 10% in base al livello
	var level_factor = 1 + (Global.level - 1) * 0.1
	speed = base_spped * level_factor
func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var normal = collision.get_normal()
		direction = direction.bounce(normal)
		# Prevenzione rimbalzi orizzontali
		enforce_min_vertical_angle()
		var collider = collision.get_collider()
		if collider.is_in_group("paddle"):
			var paddle = collision.get_collider()
			var hit_pos = (position.x - paddle.position.x) / (paddle.collision.shape.size.x/2)
			direction = Vector2(hit_pos, -1).normalized()
			$"../Paddle".global_position.y = global_pos_paddle_y_fix #fix move paddle in y 
			%SFXPaddle.play()
		elif collider.is_in_group("brick"):
			collider._on_ball_collision()
			%SFX.play()
		elif collider.is_in_group("wall"):
			%SFX.play()

func enforce_min_vertical_angle():
	var min_vertical = 0.2  # Angolo verticale minimo
	# Mantiene un angolo verticale minimo
	if abs(direction.y) < min_vertical:
		direction.y = sign(direction.y) * min_vertical
		direction = direction.normalized()
		
#game over
func _process(_delta):
	if !IsGameOver:
		if position.y > get_viewport_rect().size.y:
			print('GameOver')
			IsGameOver = true
			get_tree().call_group("game_manager", "game_over")
