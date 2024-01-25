extends Node

@export var max_spoons: int = 4
@export var spoons: int = max_spoons: set = set_spoons

var last_convo_key = "FudaiConvoData"

signal no_spoons
signal spoons_changed
signal max_spoons_changed

func set_spoons(value):
	spoons = value
	emit_signal("spoons_changed", spoons)
	if spoons <= 0:
		emit_signal("no_spoons")
		
func set_max_spoons(value):
	max_spoons = value
	emit_signal("max_spoons_changed", max_spoons)
	
func _ready():
	self.spoons = self.max_spoons
	
func get_current_convo_key():
	print("Returning last convo key " + self.last_convo_key)
	return self.last_convo_key
	
func set_convo_key(key):
	print("Setting last convo key to " + key)
	self.last_convo_key = key
