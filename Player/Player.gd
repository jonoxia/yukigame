extends CharacterBody2D

const ACCELERATION = 300
const MAX_SPEED = 100
const FRICTION = 300
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var animationPlayer = null

var stats = PlayerStats


	
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	velocity = Vector2.ZERO
	stats.connect("no_spoons", Callable(self, "queue_free"))
	animationTree.active = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity += input_vector.normalized() * ACCELERATION *delta
		velocity = velocity.limit_length(MAX_SPEED)	
	else:
		animationState.travel("Idle")		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	


#func _on_Area2D_area_entered(area):
#	print("Area2d entered")
#	Global.goto_scene("res://UI/MainMenu.tscn", null)
