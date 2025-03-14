# brick.gd - Versione modificata
extends StaticBody2D

var health: int = 1  # Salute del mattoncino
var max_health: int = 1  # Salute massima

func _ready() -> void:
	#var random = randi_range(0, 6)
	$AnimatedSprite2D.frame = Global.color
	add_to_group("brick")
	# Inizializza la salute in base al livello
	setup_health()
	update_appearance()

func setup_health() -> void:
	# Determina la probabilità di mattoncini a doppio colpo in base al livello
	var chance_of_double_health = min(0.1 * Global.level, 0.6)  # Max 60% al livello 6+
	
	# Più alto è il livello, più probabilità ci sono di mattoncini a doppio colpo
	if randf() < chance_of_double_health:
		max_health = 2
		health = 2

func update_appearance() -> void:
	# Modifica l'aspetto in base alla salute
	if health == 2:
		# Per i mattoncini a 2 colpi, usiamo un effetto visivo
		modulate = Color(1.5, 1.5, 1.5)  # Più luminoso
		scale = Vector2(1.1, 1.1)  # Leggermente più grande
	else:
		modulate = Color(1, 1, 1)  # Normale
		scale = Vector2(1, 1)

func _on_ball_collision():
	health -= 1
	if health <= 0:
		queue_free()
	else:
		# Aggiorna l'aspetto quando danneggiato ma non distrutto
		update_appearance()
		# Opzionale: riproduci un suono o un'animazione di danno
