extends CharacterBody2D

var dragging = false

func _input_event(viewport, event, shape_idx):
	print("input_event callback called")
	if event is InputEventMouseButton:
		print("Input event  was mouse button")
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("It was left mouse button, start dragging")
			dragging = event.pressed
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			print("Stop dragging")
			dragging = false
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			
func _physics_process(delta):
	# If dragging is enabled, use mouse position to calculate movement
	if dragging:
		var new_position = get_global_mouse_position()
		var movement = new_position - position;
		move_and_collide(movement)


# Called when the node enters the scene tree for the first time.
func _ready():
	self.input_pickable = true
	self.set_pickable(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ReflectorWidget_input_event(viewport, event, shape_idx):
	print("do i really have to do this?")
