extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export(int) var MAX_SPEED
export(int) var ROLL_SPEED
export(int) var ACCELERATION
export(int) var FRICTION
export(float) var INVISIBILITY_TIME
export(Vector2) var START_POSITION = Vector2(160, 88)

enum {
	MOVE, # starts at 0 by default
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.DOWN
var roll_vector = Vector2.DOWN
var stats = PlayerStats # recommended to use interface to access global var?

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitBox
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var comment = $Comment
onready var hitTimer = $HitTimer

func _ready(): # makes sure that nodes are initialized here, global doesn't guarandee
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state: # a bit similar to switch, cannot run them simultaneously
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	

func move_state(delta):
	# Get direction vector
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Velocity magnitude
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector # kb vector same as movement direction
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	### MAIN INPUT MAPPER
	if Input.is_action_just_pressed("attack"): # transition from move to attack
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	# warning: returns, might also access physics properties under the hood
	velocity = move_and_slide(velocity)
	
	

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack") # travel through the animation tree

func roll_animation_finished():
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(INVISIBILITY_TIME)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("start")
	hitTimer.start()
	displayHitComment()


func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("stop")


func _on_HitTimer_timeout():
	comment.visible = false

func displayHitComment():
	var comments = ["GAHH!!", "Ouch!"]
	comment.text = comments[rand_range(0, 2)]
	
	comment.visible = true
