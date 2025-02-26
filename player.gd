extends CharacterBody2D

const SPEED = 300.0
var current_bullet : WeakRef

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and \
			(current_bullet == null or current_bullet.get_ref() == null):
		var new_bullet = $FirePoint.fire()
		if new_bullet:
			current_bullet = weakref(new_bullet)
