extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_convo(convo_data_key)

enum {
	FORWARD,
	LOOK_AROUND,
	AGGRO
}
var ai_state
var ai_target = null
var wander_direction
var seconds_left
var convo_data_key = ""
var aggro_agenda = false

var how_they_feel_about_yuki = null # does this go in global?
var story_agendax

# My own function to initialize data properties that are
# different between NPC instances. Not sure if there is a more
# Godot-idiomatic way of expressing this?
func setup(sprite_filename, convo_name, aggro_agenda):
	$Sprite2D.texture = load(sprite_filename)
	self.aggro_agenda = aggro_agenda
	self.convo_data_key = convo_name
	
func get_agenda():
	return null
	
func get_agenda_exchange(agenda):
	return null
		
func get_neutral_start_exchange():
	return null

# Called when the node enters the scene tree for the first time.
func _ready():
	ai_state = FORWARD
	seconds_left = randf_range(1, 5)
	pick_random_wander_direction()
	
func pick_random_wander_direction():
	var possible_vectors = [
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(-1, 0),
		Vector2(0, -1)
	]
	var die_roll = floor( randf_range(0, 4) )
	wander_direction = possible_vectors[die_roll]
	#$VisionArea/CollisionPolygon2D.
	rotation_degrees = 90 * die_roll


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# If i'm in Wander, pick a random direction to go in
	# for three seconds
	var velocity = null
	if ai_state == FORWARD:
		velocity = wander_direction * 100
		seconds_left -= delta
		if seconds_left <= 0:
			ai_state = LOOK_AROUND
			seconds_left = 1
	elif ai_state == AGGRO and ai_target != null:
		velocity = position.direction_to(ai_target.position) * 100
	elif ai_state == LOOK_AROUND:
		velocity = Vector2.ZERO
		seconds_left -= delta
		if seconds_left <= 0:
			pick_random_wander_direction()
			var roll = randf_range(0, 4)
			if roll > 3:
				ai_state = FORWARD
				seconds_left = randf_range(1, 5)
			else:
				seconds_left = 1
		
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity

# TODO if i'm in aggro state, move straight towards player
# if player gets too far away from me, go from aggro to wander
# if player comes close enough, go from wander to aggro

# THen: have a cone of vision facing whichever way i moved
# sometiems during wander, switch to "look around" state. Then
# switch back to wander.
# only aggro if player enters cone

# Much later todo: he only goes aggro if he has something he
# wants to tell you, like youre late on a project or you broke
# a rule or something

func _on_VisionArea_entered(area_id, area, area_shape_index, local_shape):
	var other = area.shape_owner_get_owner(area_shape_index)
	if self.aggro_agenda and other.get_parent().get_parent().name == "Player":
		ai_state = AGGRO
		ai_target = other.get_parent().get_parent()

func _on_ThreatArea_entered(area_id, area, area_shape_index, local_shape):
	var other = area.shape_owner_get_owner(area_shape_index)
	if other.get_parent().get_parent().name == "Player":
		emit_signal("start_convo", self.convo_data_key)
		# Emitted signal includes my convo data key argument
