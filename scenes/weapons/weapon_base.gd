extends Node2D

# Waffen-Basis-Skript für Auto-Shooter Spiel

# Waffen-Eigenschaften
@export var damage = 10
@export var fire_rate = 0.5  # Schüsse pro Sekunde
@export var projectile_speed = 300
@export var projectile_lifetime = 2.0  # Sekunden
@export var projectile_scene: PackedScene  # Szene für das Projektil

# Waffen-Status
var can_fire = true
var fire_timer = 0.0

# Referenz zum Spieler
var player = null

func _ready():
	# Finde den Spieler
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	# Aktualisiere den Feuer-Timer
	if !can_fire:
		fire_timer += delta
		if fire_timer >= 1.0 / fire_rate:
			can_fire = true
			fire_timer = 0.0

func fire():
	if can_fire and projectile_scene != null:
		# Erstelle ein neues Projektil
		var projectile = projectile_scene.instantiate()
		
		# Setze Projektil-Eigenschaften
		projectile.damage = damage
		projectile.speed = projectile_speed
		projectile.lifetime = projectile_lifetime
		
		# Positioniere das Projektil am Spieler
		projectile.global_position = player.global_position
		
		# Finde das nächste Ziel
		var target = find_closest_enemy()
		if target:
			# Richte das Projektil auf das Ziel aus
			projectile.direction = player.global_position.direction_to(target.global_position)
		else:
			# Wenn kein Ziel gefunden wurde, schieße in eine zufällige Richtung
			projectile.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
		# Füge das Projektil zur Szene hinzu
		get_tree().current_scene.add_child(projectile)
		
		# Setze den Feuer-Timer zurück
		can_fire = false
		fire_timer = 0.0

func find_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		return null
		
	var closest_enemy = enemies[0]
	var closest_distance = player.global_position.distance_to(closest_enemy.global_position)
	
	for enemy in enemies:
		var distance = player.global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_enemy = enemy
			closest_distance = distance
	
	return closest_enemy

func upgrade():
	# Verbessere die Waffe (wird beim Level-Up aufgerufen)
	damage += 5
	fire_rate += 0.1
