extends CharacterBody2D

# Basis-Gegner-Skript für Auto-Shooter Spiel

# Gegner-Eigenschaften
@export var speed = 50.0
@export var health = 20
@export var damage = 10
@export var experience_value = 5

# Ziel (normalerweise der Spieler)
var target = null
var attack_cooldown = 1.0
var attack_timer = 0.0

# Signale
signal enemy_died(experience)

func _ready():
	# Füge den Gegner zur "enemies" Gruppe hinzu für einfaches Tracking
	add_to_group("enemies")
	
	# Finde den Spieler als Ziel
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if target == null:
		# Versuche erneut, den Spieler zu finden, falls er noch nicht existiert
		target = get_tree().get_first_node_in_group("player")
		return
		
	# Bewege dich in Richtung des Spielers
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * speed
	move_and_slide()
	
	# Überprüfe Kollision mit dem Spieler
	attack_timer += delta
	if attack_timer >= attack_cooldown:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider.is_in_group("player"):
				attack_player(collider)
				attack_timer = 0.0

func take_damage(amount):
	health -= amount
	
	# Hier könntest du Schadensanimationen oder -effekte hinzufügen
	
	if health <= 0:
		die()

func die():
	# Sende Signal mit Erfahrungspunkten
	emit_signal("enemy_died", experience_value)
	
	# Informiere den Game Manager
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.on_enemy_defeated()
	
	# Hier könntest du Todesanimationen oder -effekte hinzufügen
	
	# Entferne den Gegner
	queue_free()

func attack_player(player):
	# Füge dem Spieler Schaden zu
	if player.has_method("take_damage"):
		player.take_damage(damage)
