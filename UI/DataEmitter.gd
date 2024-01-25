extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	# Spawn a DataBlock moving in the direction we're facing
	print("DataEmitter timer timed out")
	var blob_scene = load("res://UI/ProgrammingDataBlob.tscn")
	var new_data_blob = blob_scene.instantiate()
	
	# do i need to give new_data_area width and height? collision shape??
	new_data_blob.applied_force = Vector2(0, 50)
	#new_data_block.contact_monitor = true
	#new_data_block.contacts_reported = 1
	#print("New rigid bod is on collision layer " + str(new_data_block.collision_layer))
	#print("New rigid bod is on collision mask " + str(new_data_block.collision_mask))
	add_child(new_data_blob)
	
# TODO: when are these data blocks going to get deleted if they
# don't hit a data receiver?
