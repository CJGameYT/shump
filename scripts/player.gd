extends Area2D

@export var speed := 100
@export var cooldown := 0.25
@export var laser_scene: PackedScene

@onready var screensize = get_viewport_rect().size

var can_shoot = true

func _ready() -> void:
	start()

func _process(delta: float) -> void:
	var input = Input.get_vector("left","right","up","down")
	
	if input.x > 0:
		$ship.frame = 2
		$ship/booster.animation = "RIGHT"
	elif input.x < 0:
		$ship.frame = 0
		$ship/booster.animation = "LEFT"
	else:
		$ship.frame = 1
		$ship/booster.animation = "forward"
	
	if Input.is_action_pressed("Shoot"):
		shoot()
	
	position += input * speed * delta
	position = position.clamp(Vector2(8,8), screensize - Vector2(8,15))
	
func start():
	position = Vector2(screensize.x/2, screensize.y-64)
	$cooldown.wait_time = cooldown

func shoot():
	if not can_shoot:
		return
	can_shoot = false
	$cooldown.start()
	var l = laser_scene.instantiate()
	get_tree().root.add_child(l)
	l.start(position + Vector2(0,-8))
	
	
func _on_cooldown_timeout() -> void:
	can_shoot = true
