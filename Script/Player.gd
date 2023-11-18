extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FLICTION = 500
export var ROLL_SPEED = 110

enum{
	MOVE,
	ATTACK,
	ROLL
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats



onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	
	if input_direction != Vector2.ZERO:
		roll_vector = input_direction
		swordHitbox.knockback_vector = input_direction
		animationTree.set("parameters/Idle/blend_position", input_direction)
		animationTree.set("parameters/Run/blend_position", input_direction)
		animationTree.set("parameters/Roll/blend_position", input_direction)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO ,FLICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state(_delta):
	pass
	
func roll_animation_finished():
	state = MOVE
	velocity = velocity * 0.8
	
func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
# func attack_animation_finished():
	#state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	knockback(area.get_parent().velocity)
	
	
	
func knockback(enemyVelocity: Vector2):
	var knokbackDirection = (enemyVelocity - velocity).normalized() * 200
	velocity = knokbackDirection





