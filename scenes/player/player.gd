extends CharacterBody2D

# Spieler-Eigenschaften
@export var speed = 100.0
@export var health = 100
@export var max_health = 100

# Waffen-Eigenschaften
@export var fire_rate = 0.5
var fire_timer = 0.0

# Erfahrungspunkte und Level
var experience = 0
var level = 1
var experience_to_next_level = 100

# Signale
signal player_hit(damage)
signal player_level_up(new_level)
signal player_died

func _ready():
	# Initialisierung des Spielers
	pass

func _process(delta):
	# Schießen-Logik
	fire_timer += delta
	if fire_timer >= fire_rate:
		fire()
		fire_timer = 0.0

func _physics_process(delta):
	# Bewegungslogik
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func fire():
	# Hier wird die Logik zum Schießen implementiert
	# In einem Auto-Shooter passiert dies automatisch
	pass

func take_damage(damage):
	health -= damage
	emit_signal("player_hit", damage)
	
	if health <= 0:
		die()

func die():
	emit_signal("player_died")
	# Spieler-Tod-Logik

func add_experience(amount):
	experience += amount
	
	# Überprüfen, ob ein Level-Up erreicht wurde
	if experience >= experience_to_next_level:
		level_up()

func level_up():
	level += 1
	experience -= experience_to_next_level
	experience_to_next_level = int(experience_to_next_level * 1.2)  # Erhöhe XP für nächstes Level
	
	# Verbessere Spieler-Statistiken
	max_health += 10
	health = max_health
	speed += 5
	
	emit_signal("player_level_up", level)
