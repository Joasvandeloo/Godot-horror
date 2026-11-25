extends CharacterBody2D

#defines all the variables
signal Death
const SPEED = 250.0
const JUMP_VELOCITY = -300.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area2D: Area2D = $Area2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x != 0:
			anim.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#handles animations
	if Input.is_action_just_pressed("JUMP") and direction == 0 and is_on_floor():
		anim.play("IdleStartJump")
	elif Input.is_action_just_pressed("RIGHT") or Input.is_action_just_pressed("LEFT") and is_on_floor():
		anim.play("StartRun")
	elif not is_on_floor() and direction == 0:
		anim.play("IdleInAir")
	elif not is_on_floor():
		anim.play("RunInAir")
	elif direction != 0:
		anim.play("Run")
	elif is_on_floor():
		anim.play("Idle")
	

#detects collisions
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Death")
	Death.emit()
	
func Finish(body: Node2D) -> void:
	print("Finish")
