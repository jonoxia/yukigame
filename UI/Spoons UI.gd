extends Control

var spoons = 4: set = set_spoons
var max_spoons = 4: set = set_max_spoons

@onready var uiFullSpoon = $FullSpoonTexture
@onready var uiEmptySpoon = $EmptySpoonTexture

func set_spoons(value):
	spoons = clamp(value, 0, max_spoons)
	if uiFullSpoon != null:
		uiFullSpoon.size.x = spoons * 32
	
func set_max_spoons(value):
	max_spoons = max(value, 1)
	spoons = min(spoons, max_spoons)
	if uiEmptySpoon != null:
		uiEmptySpoon.size.x = max_spoons * 32

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.max_spoons = PlayerStats.max_spoons
	self.spoons = PlayerStats.spoons
	PlayerStats.connect("spoons_changed", Callable(self, "set_spoons"))
	PlayerStats.connect("max_spoons_changed", Callable(self, "set_max_spoons"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
