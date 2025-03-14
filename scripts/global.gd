extends Node

var level: int = 1
var color: int = 1
var score: int = 0
var music: bool = true
var sfx: bool = true

# Funzione per resettare tutto quando si inizia una nuova partita
func reset_game():
	level = 1
	score = 0
	color = randi_range(0, 6)

# Funzione per passare al livello successivo
func next_level():
	level += 1
	color = randi_range(0, 6)  # Cambia colore ad ogni livello
