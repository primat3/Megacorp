extends Node2D

# Hauptspiel-Manager für das Auto-Shooter Spiel
# Verwaltet Spielzustand, Spawning von Gegnern und Progression

# Spielzustände
enum GameState {MENU, PLAYING, PAUSED, GAME_OVER}
var current_state = GameState.MENU

# Spielzeit
var game_time = 0.0
var wave_timer = 0.0
@export var wave_duration = 30.0  # Sekunden pro Welle

# Schwierigkeitsgrad
var difficulty = 1
var enemy_spawn_rate = 1.0
var max_enemies = 20

# Spielstatistiken
var score = 0
var enemies_defeated = 0

# Signale
signal wave_completed(wave_number)
signal game_over(final_score)

func _ready():
	randomize()
	# Initialisiere das Spiel im Menüzustand
	# In einem echten Spiel würdest du hier das Hauptmenü laden

func _process(delta):
	match current_state:
		GameState.PLAYING:
			game_time += delta
			wave_timer += delta
			
			# Überprüfe, ob eine neue Welle beginnen sollte
			if wave_timer >= wave_duration:
				complete_wave()
			
			# Spawne Gegner basierend auf der Schwierigkeit
			try_spawn_enemy(delta)
		
		GameState.PAUSED:
			# Pausiert - keine Aktualisierungen
			pass
			
		GameState.MENU, GameState.GAME_OVER:
			# Menü oder Game Over Zustand
			pass

func start_game():
	current_state = GameState.PLAYING
	game_time = 0.0
	wave_timer = 0.0
	difficulty = 1
	score = 0
	enemies_defeated = 0
	
	# Hier würdest du den Spieler spawnen und das Level initialisieren

func pause_game():
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
	elif current_state == GameState.PAUSED:
		current_state = GameState.PLAYING

func game_over():
	current_state = GameState.GAME_OVER
	emit_signal("game_over", score)
	# Zeige Game Over Bildschirm

func complete_wave():
	wave_timer = 0.0
	difficulty += 0.5
	enemy_spawn_rate += 0.2
	max_enemies += 5
	
	emit_signal("wave_completed", difficulty)
	
	# Hier könntest du Belohnungen oder Power-ups für den Spieler spawnen

func try_spawn_enemy(delta):
	# Einfache Logik zum Spawnen von Gegnern basierend auf der Schwierigkeit
	# In einem echten Spiel würdest du verschiedene Gegnertypen und Spawn-Muster haben
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()
	
	if enemy_count < max_enemies:
		var spawn_chance = enemy_spawn_rate * delta
		if randf() < spawn_chance:
			spawn_enemy()

func spawn_enemy():
	# Hier würdest du einen Gegner an einer zufälligen Position um den Spieler herum spawnen
	# In einem echten Spiel würdest du verschiedene Gegnertypen basierend auf der Schwierigkeit spawnen
	pass

func add_score(points):
	score += points
	# Aktualisiere UI

func on_enemy_defeated():
	enemies_defeated += 1
	# Erhöhe den Score basierend auf dem aktuellen Schwierigkeitsgrad
	add_score(10 * difficulty)
