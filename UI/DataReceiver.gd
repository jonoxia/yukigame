extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: Detect collisions with data blocks, free the data block
# and increase the score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area2D_body_entered(body):
	# For some reason i can't get this one to work.
	print("You got a point!")
	body.queue_free()


func _on_Area2D_area_entered(area):
	print("You got a point from area entering!")
	area.parent.queue_free()
