extends Area2D

# Projektil-Skript für Auto-Shooter Spiel

# Projektil-Eigenschaften
var damage = 10
var speed = 300
var lifetime = 2.0
var direction = Vector2.RIGHT

# Timer für die Lebensdauer
var timer = 0.0

func _ready():
	# Drehe das Projektil in die Richtung, in die es fliegt
	rotation = direction.angle()

func _process(delta):
	# Bewege das Projektil
	position += direction * speed * delta
	
	# Aktualisiere den Timer
	timer += delta
	if timer >= lifetime:
		queue_free()

func _on_body_entered(body):
	# Überprüfe, ob das Projektil einen Gegner getroffen hat
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
