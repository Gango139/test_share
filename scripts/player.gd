extends CharacterBody2D

@export var speed: float = 30
@onready var anim = $AnimatedSprite2D

var max_health = 3
var current_health = max_health

func _ready():
	add_to_group("Player")

func _process(_delta):
	handle_movement()
	handle_animation()
	limit_position()

func handle_movement():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

func handle_animation():
	if velocity.length() > 0:
		anim.play("Walk")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("Idle")

func limit_position():
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)



func take_damage(amount):
	# Diese Funktion wird jetzt aufgerufen, wenn der Spieler Schaden erleidet.
	current_health -= amount
	print("Spieler bekommt Schaden! HP: ", current_health)
	if current_health <= 0:
		die()

func die():
	anim.play("Die")
	await anim.animation_finished
	get_tree().quit()
