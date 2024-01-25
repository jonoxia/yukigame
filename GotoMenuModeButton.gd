extends Button


func _pressed():
	print("U clicked Goto Menu Mode")
	Global.goto_scene("res://UI/MainMenu.tscn")
