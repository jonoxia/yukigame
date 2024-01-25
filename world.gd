extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Node2D/NPC (Fudai)".setup("res://Enemies/fudai_idle_1.png", "FudaiConvoData", false)
	$"Node2D/NPC (Sato)".setup("res://Enemies/sato_idle_1.png", "SatoConvoData", true)
	$"Node2D/NPC (Fudai)".connect("start_convo", Callable(self, "_on_convo_start"))
	$"Node2D/NPC (Sato)".connect("start_convo", Callable(self, "_on_convo_start"))
	#Global.goto_scene("res://UI/ProgrammingMinigame.tscn")

func _on_convo_start(convo_data_key):
	print("On convo start - key is " + convo_data_key)
	PlayerStats.set_convo_key(convo_data_key)
	# We're using PlayerStats global to store the last set convo-data-key
	# I 'd like to find a cleaner way to do this.
	Global.goto_scene("res://UI/MainMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
