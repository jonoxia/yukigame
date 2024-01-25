extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func retrieve_convo_topic(topic_name):
	# can we have a consistent auto-transform from topic_name
	# to the filename where it lives?
	var filename = topic_name.replace(" ", "")
	filename = filename.replace("'", "")
	# e.g. "Sato's Loneliness" -> "SatosLonelinessTopic.gd"
	print("Looking for file: ")
	print("res://Convo Topics/%sTopic.gd" % filename)
	
	return load("res://Convo Topics/%sTopic.gd" % filename).new()
	

# Example: "Sato" (conversation topic)
# "Sato's Loneliness"
# "Admin Password"
# "Surveillance System"
# "Filling in your T-sheets"
# "Tuesday night's enkai"


	

# function to instantiate correct child from string

# is this actually a class?  or just a string?
# like, what methods would it have? Or is everything about it contained in the NPC?
# I guess this class could contain what Yuki thinks about it / what it does when agreed to
# what it means if you get somebody else to do it
