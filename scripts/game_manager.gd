extends Node2D

signal level_completed
signal game_restarted
var level_is_not_completed = true
var game_is_playing = false 
#variabile per non fare togliere la pausa dal menu

func _ready():
	# Connettiti al segnale level_completed per gestire il cambio di livello
	connect("level_completed", Callable(self, "_on_level_completed"))
	%GameOver.visible = false
	%GameMenu.visible = true
	%GamePause.visible = false
	%Credits.visible = false
	%Level.text = "level " + str(Global.level)
	get_tree().paused = true
	%Music.play()
	if Global.music:
		%MusicToggle.button_pressed = true
	if Global.sfx:
		%SFXToggle.button_pressed = true
	
func _process(_delta):
	# Controlla se tutti i mattoncini sono stati distrutti
	check_bricks_remaining()

func check_bricks_remaining():
	var bricks = get_tree().get_nodes_in_group("brick")
	if bricks.size() == 0 and level_is_not_completed:
		# Non ci sono più mattoncini, livello completato
		level_is_not_completed = false
		emit_signal("level_completed")

func _on_level_completed():
	# Incrementa il livello
	%Win.play()
	Global.next_level()
	print("Livello completato! Ora al livello ", Global.level)
	# Resetta la scena dopo un breve ritardo
	var timer = get_tree().create_timer(0.5)  # Attendi 0.5 secondi
	timer.connect("timeout", Callable(self, "restart_level"))

func restart_level():
	# Riavvia il livello
	get_tree().paused = false
	emit_signal("game_restarted")
	get_tree().reload_current_scene()
	

func game_over():
	print("Game Over!")
	%GOver.play()
	%GameOver.visible = true
	get_tree().paused = true  # Metti in pausa il gioco
	game_is_playing = false


func _on_retry_pressed_game_over() -> void:
	restart_level()

func _on_start_pressed() -> void:
	%GameMenu.visible= false
	get_tree().paused = false
	game_is_playing = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and game_is_playing:
		if Input.is_action_just_pressed("pause"):
			toggle_pause()

func toggle_pause() -> void:
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	%GamePause.visible = new_state




func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Se il CheckButton è selezionato, attiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
		print("Musica attivata")
		Global.music = true 
	else:
		# Se il CheckButton è deselezionato, disattiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		print("Musica disattivata")
		Global.music = false


func _on_sfx_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Se il CheckButton è selezionato, attiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		print("SFX attivata")
		Global.sfx = true 
	else:
		# Se il CheckButton è deselezionato, disattiva l'audio del bus "Music"
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true)
		print("SFX disattivata")
		Global.sfx = false


func _on_back_pressed() -> void:
	%Credits.visible = false
	%GameMenu.visible = true
	


func _on_b_credits_pressed() -> void:
	%Credits.visible = true
	%GameMenu.visible = false
