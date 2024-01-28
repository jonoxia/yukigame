extends NinePatchRect

signal exchange_ended

var exchange_index = 0
var SpeechBalloonScene = preload("res://UI/SpeechBalloon.tscn")
var balloon_queue = []  # Move to be owned by panel
var finished
var active
var text_resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.exchange_index = 0
	self.finished = false
	self.active = true
	
func set_text_resource(text_resource):
	self.text_resource = text_resource
	
func continue_exchange():
	var new_balloon_parent_node
	if self.exchange_index < self.text_resource.size():
		self.active = true
		self.finished = false
		var tail_is_left
		var next_balloon = self.text_resource[self.exchange_index]
		if next_balloon["Position"] == "1":
			new_balloon_parent_node = $Position2DA
			tail_is_left = true
		else:
			new_balloon_parent_node = $Position2DB
			tail_is_left = false
		
		# All previous balloons float upward
		for balloon in self.balloon_queue:
			balloon.float_upward()
		var new_balloon = SpeechBalloonScene.instantiate()
		
		if next_balloon.has("Balloon"):
			new_balloon.set_style(next_balloon["Balloon"])
		
		# TODO is there a way to pass args to instance?
		#$SpeechBalloonGroup.add_child(new_balloon)
		new_balloon_parent_node.add_child(new_balloon)
		balloon_queue.append(new_balloon)
		
		new_balloon.connect("tween_finished", Callable(self, "on_tween_finished"))
	
		new_balloon.draw_speech_balloon(next_balloon["Text"],
						tail_is_left)
		# TODO: Move all previous balloons in the ballon_queue
		# upward, and delete any ones that scroll off screen
		self.exchange_index += 1
		
	else:
		self.active = false
		self.finished = true
		self.exchange_ended.emit() # signal to the main conversation object
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.active:
		if Input.is_action_just_pressed("ui_accept"):
			if self.finished:
				self.continue_exchange()
			else:
				if len(self.balloon_queue) > 0:
					var active_balloon = balloon_queue[-1]
					active_balloon.skip_to_end()
				
				self.finished = true
