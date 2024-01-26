extends Control

var text_resource
var exchange_index = 0

var yuki_texture = "a"   # Move to be owned by panel
var convo_key = null
var convo_map = null
var conversation_state = null
var current_choice_dictionary = null
var next_state = null

var current_topic = null
var npc = null
var panel_history = []
var current_panel = null


# Have a current conversation state, it presents you 
# with some choices, each choice leads to an exchange, each
# exchange leads to a new conversation state.
# that means: show conversation options; clicking one
# hides the options, starts the exchange; ending the exchange
# does new conversation state.

# All the logic is in here, while the data is in ConvoData
# the idea being that i can easily substitute different
# ConvoDatas.

# Next stage: this is currently all reactive, with the choices
# determined entirely by the conversation. However I want to mix this
# with a system where Yuki can drive the conversation towards her
# own agenda using abilities

# Feel like both characters need to have Agendas which they can
# introduce to the conversation

# Maybe when they ask you a question (the main case of conversation-determined
# choice menu)  the question becomes an object that's out there in front of you
# and the *question* has answers on it, but you can also ignore it to
# pick one of your other conversation moves

# Will instantiate copies of PanelScene:
var PanelScene = preload("res://UI/Panl.tscn")
var ConvoTopic = load("res://UI/ConvoTopic.gd").new()

func _ready():	
	# TODO i'm using a global variable for this; is
	# there a way to pass it in when the scene is instantiated
	# from Global.gd instead?
	convo_key = PlayerStats.get_current_convo_key()
	self.start_conversation(convo_key)
	
func hide_buttons():
	for child in self.get_node("HBoxContainer/Menu Items").get_children():
		child.queue_free()
	self.get_node("HBoxContainer/Menu Items").hide()
	
func show_buttons(visible_buttons):
	self.get_node("HBoxContainer/Menu Items").show()
	var menuItems = get_node("HBoxContainer/Menu Items")
	for button_name in visible_buttons:
		var new_button = Button.new()
		new_button.text = button_name
		new_button.connect("pressed", Callable(self, "_on_choice_pressed").bind(button_name))
		menuItems.add_child(new_button)

func _physics_process(delta):
	pass
	
func start_conversation(node_name):
	self.convo_map = get_parent().get_node(node_name).convo_map
	self.npc = get_parent().get_node(node_name)
	# TODO: Start conversation with current topic either at
	# Small Talk (if Yuki initiated) or NPC's current Agenda
	# if NPC initiated.
	# TODO the below commented-out code was an incomplete refactor to
	# an agenda-based system.
	#var exchange = null
	#var agenda = self.npc.get_agenda() # XXX nonexistent function
	#if agenda != null:
	#	self.current_topic = ConvoTopic.retrieve_convo_topic(agenda)
	#	exchange = npc.get_agenda_exchange(agenda)
	#else:
	#	self.current_topic = null # null-topic = small talk?
	#	exchange = npc.get_neutral_start_exchange()
		
	# TODO repurpose "conversation state" variable such that it is either
	# "yuki's turn to start an exchange about the topic",
	# or "picking new topic", or "yuki responding to exchagne
	# from NPC".
	self.conversation_state = "start"
	#print("Starting conversation and topic is %s" % self.current_topic.topic_name)
	var exchange = self.convo_map[ self.conversation_state ]
	
	# FUTURE TODO possible to go straight to a choice here maybe?
	# examine whether convo_map["start"] is a dict or an array?pch
	print("Starting exchange with next state = " + exchange[1])
	self.start_exchange(exchange[0], exchange[1])
	
	
func start_exchange(dialog, next_state):
	
	# Slide former panels left
	for panel in self.panel_history:
		var tween = self.create_tween()
		var final_pos = Vector2(panel.position.x + 400, panel.position.y)
		tween.tween_property(panel, "position", final_pos, 1)
		# wait I should make all of the above tweeners simultaneous.
		# Or... i don't move panels I just move the camera?
		await tween.finished
	
	self.current_panel = PanelScene.instantiate()
	self.current_panel.position = Vector2(200, 50)
	self.current_panel.size = Vector2(500, 500)
	self.panel_history.append(self.current_panel)
	$CurrentPage.add_child(self.current_panel)
	self.current_panel.set_text_resource(dialog)
	self.current_panel.connect("exchange_ended", self._on_end_exchange)
	# TODO will it cause any problem that multiple old panels could still be connected?
	
	hide_buttons()
	self.text_resource = dialog # Needed anymore???
	self.next_state = next_state
	self.current_panel.continue_exchange()


func get_yuki_special_moves(interlocutor):
	# TODO move this to the global yuki object??? because it depends on yuki's development
	var infodump_dialog = [
		{"Name": "Yuki",
		"Expression": "Excited",
		"Position": "2",	
		"Text": "Did you know that (random fact) and (other random fact?)"},
	
		{"Name": interlocutor,
		"Expression": "Cringe",
		"Position": "1",	
		"Text": "Um how is that at all relevant?"}, # TODO this should depend on who you talking to
	
		{"Name": "Yuki",
		"Expression": "Cringe",
		"Position": "2",	
		"Text": "It's not but it's really cool!"}
	]
	var kokuhaku_dialog = [
		{"Name": "Yuki",
		"Expression": "Embarassed",
		"Position": "2",
		"Balloon": "Thought",
		"Text": "You can't possibly kokuhaku here! You are within panopticon range"},
		{"Name": "Yuki",
		"Expression": "Embarassed",
		"Position": "2",
		"Balloon": "Thought",
		"Text": "And second you don't have enough spoons"}

	]
	var special_moves = {
			"Infodump": [infodump_dialog, "A"] # how do we encode what state this takes the conversation to?
		}
	#if interlocutor == "Fudai":
	special_moves["Kokuhaku"] = [kokuhaku_dialog, "A"]
	return special_moves

func _on_end_exchange():
	
	if self.next_state == null:
		end_conversation()
	else:
		self.conversation_state = self.next_state
		self.next_state = null
		# Now we're going to choice mode!
		
		self.current_choice_dictionary = self.convo_map[self.conversation_state].duplicate(true)
		
		# But! There are also other choices -- if Yuki has a Special Move
		# or if she has an Agenda towards this person.
		# So uh wait do we add to self.convo_map[ self.conversation_state ]?
		# More like we want to *copy* this dict, get another dict from 
		# yuki's special moves, and combine the two.
		var bonus_actions = get_yuki_special_moves("Sato") # TODO pass in correct interlocutor
		
		# Is there a better way to combine dictionaries?
		for key in bonus_actions.keys():
			self.current_choice_dictionary[key] = bonus_actions[key]
		
		show_buttons(self.current_choice_dictionary.keys())
		
	
func end_conversation():
	print("Ending conversation")
	Global.goto_scene("res://world.tscn")

#func on_tween_finished():
#	finished = true
# Do we still need this?

func _on_Timer_timeout():
	# change animation sprites
	if yuki_texture == "a":
		$Yuki.texture = load("res://Player/yuki1b.png")
		yuki_texture = "b"
	elif yuki_texture == "b":
		$Yuki.texture = load("res://Player/yuki1a.png")
		yuki_texture = "a"


func _on_choice_pressed(button_title):
	print("Choice pressed: " + str(button_title))
	var new_exchange = self.current_choice_dictionary[button_title]
	# TODO deduct spoon if the choice had a spoon cost!
	# TODO call a .execute() callback if the choice has one?
	start_exchange(new_exchange[0], new_exchange[1])
