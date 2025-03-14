# generate_briks.gd - Versione modificata
extends Node2D

func _ready():
	# Seleziona colore iniziale
	Global.color = randi_range(0, 6)
	
	var brick_scene = load("res://scenes/brick.tscn")
	var viewport = get_viewport_rect().size
	
	# Calcola dimensioni mattoncino
	var temp_brick = brick_scene.instantiate()
	var brick_size = temp_brick.get_node("CollisionShape2D").shape.size
	temp_brick.queue_free()
	
	# Configurazione griglia - modificata in base al livello
	var cols = 6 + min(Global.level - 1, 3)  # Aumenta fino a 9 colonne
	var rows = 4 + min(Global.level - 1, 3)  # Aumenta fino a 7 righe
	var h_spacing = max(10 - Global.level, 5)  # Diminuisce fino a 5
	var v_spacing = max(5 - Global.level/2, 2)  # Diminuisce fino a 2
	var top_margin = 100
	
	# Calcola larghezza totale della griglia (mattoni + spazi)
	var total_h_spacing = (cols - 1) * h_spacing
	var grid_width = cols * brick_size.x + total_h_spacing
	
	# Calcola margini laterali per centratura perfetta
	var side_margin = (viewport.x - grid_width) / 2
	
	# Posizione iniziale
	var start_x = side_margin + brick_size.x / 2  # Offset per centratura mattoncino
	var start_y = top_margin
	
	# Crea formazioni diverse in base al livello
	match Global.level:
		1, 2:
			# Livelli iniziali: griglia standard
			generate_grid(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing)
		3, 4:
			# Livelli intermedi: pattern alternati
			generate_alternating_pattern(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing)
		_:
			# Livelli avanzati: pattern complessi
			generate_advanced_pattern(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing)

# Generazione standard a griglia
func generate_grid(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing):
	for x in cols:
		for y in rows:
			var brick = brick_scene.instantiate()
			brick.position = Vector2(
				start_x + x * (brick_size.x + h_spacing),
				start_y + y * (brick_size.y + v_spacing)
			)
			add_child(brick)

# Pattern alternato per livelli intermedi
func generate_alternating_pattern(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing):
	for x in cols:
		for y in rows:
			# Salta alcuni mattoncini per creare un pattern
			if (x + y) % 2 == 0 or Global.level > 3:
				var brick = brick_scene.instantiate()
				brick.position = Vector2(
					start_x + x * (brick_size.x + h_spacing),
					start_y + y * (brick_size.y + v_spacing)
				)
				add_child(brick)

# Pattern avanzato per livelli superiori
func generate_advanced_pattern(brick_scene, cols, rows, start_x, start_y, brick_size, h_spacing, v_spacing):
	for x in cols:
		for y in rows:
			# Pattern più complesso
			if (x > 1 and x < cols-2) or (y > 0 and y < rows-1):
				var brick = brick_scene.instantiate()
				brick.position = Vector2(
					start_x + x * (brick_size.x + h_spacing),
					start_y + y * (brick_size.y + v_spacing)
				)
				add_child(brick)
