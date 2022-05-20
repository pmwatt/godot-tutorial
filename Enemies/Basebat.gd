extends KinematicBody2D


const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

export(int) var MAX_SPEED # 600
export(int) var ACCELERATION # 330
export(int) var FRICTION # 10
export(int) var SOFT_COLLISION

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE

func _ready():
	state = pick_random_state([IDLE, WANDER]) # randomize() in Player's script
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION*delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			seek_player()
			if wanderController.get_time_left() <= 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderController.get_time_left() <= 0:
				update_wander()
			
			accelerate_towards_point(wanderController.target_position, delta)
			
			# not dangling at the target position.
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED:
				update_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * SOFT_COLLISION * delta
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta): # (player.global_position - global_position).normalized()
	var direction = global_position.direction_to(point) # (to - from)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(0.5, 1.5))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front() # remove and return the first state

# Hit by sword, ERROR HERE; happens whenever bat enters the goal
func _on_HurtBox_area_entered(area): # area == hitbox; area.damage == hitbox.damage
	stats.health -= area.damage # automatic setget that may emit no_health , less coupling
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
	queue_free()
	
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_HurtBox_invincibility_started():
	animationPlayer.play("Start")


func _on_HurtBox_invincibility_ended():
	animationPlayer.play("Stop")
