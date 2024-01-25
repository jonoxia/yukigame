extends Polygon2D

signal tween_finished

var times_floated_up = 0
var tail_is_left = false
var inner_width = 200
var inner_height = 40
var ellipse_a = 50
var ellipse_b = 40
var text_tween = null

var style = "normal"

func parellipse(a, b, t):
	# Ellipse in parametric: x = a cos(t)   y = b sin(t)  as t goes 0 to 2pi
	return Vector2(a * cos(t), b * sin(t))
	
func set_style(new_style):
	self.style = new_style

func calc_balloon_polygon(y_offset):
	if self.style == "normal":
		calc_normal_balloon_polygon(y_offset)
	elif self.style == "Thought":
		calc_thought_cloud_polygon(y_offset)
	
func calc_normal_balloon_polygon(y_offset):
	var poly_data = PackedVector2Array()
	var poly_coordinates
	var left_corneroid_x
	var tail_base_1
	
	var angle_param = 0 # will go up to 2pi
	var angle_step = PI/16
	var ellipse_vector = null
	
	if self.tail_is_left:
		left_corneroid_x = -100
		tail_base_1 = 100
	else:
		left_corneroid_x = -200
		tail_base_1 = -100
		
	var tl = Vector2(left_corneroid_x, -80 - inner_height - y_offset)
	var tr = Vector2(left_corneroid_x + inner_width, -80 - inner_height - y_offset)
	var bl = Vector2(left_corneroid_x, -80 - y_offset)
	var br = Vector2(left_corneroid_x + inner_width, -80 - y_offset)
	
	# pseudocode:
	# start at br +  a cos(t) b sin(t)  with t = 0
	# step angle param from 0 to pi/4, at each step adding br + a cos(t) b sin(t)
	ellipse_vector = parellipse(ellipse_a, ellipse_b, angle_param)
	poly_data.append(br + ellipse_vector)
	for x in range(8):
		angle_param += angle_step
		ellipse_vector = parellipse(ellipse_a, ellipse_b, angle_param)
		poly_data.append(br + ellipse_vector)
	#  then keep angle the same and replace br with tail base right
	poly_data.append(Vector2(tail_base_1 + 20, -80 - y_offset) + ellipse_vector)
	# then add tail tip and tail base left
	poly_data.append(Vector2(0, 0)) # tail tip
	poly_data.append(Vector2(tail_base_1, -80 - y_offset) + ellipse_vector)
	# then go over to bl plus vector
	poly_data.append(bl + ellipse_vector)
	# then step t from pi/4 to pi/2, at each step adding bl plus vector
	for x in range(8):
		angle_param += angle_step
		ellipse_vector = parellipse(ellipse_a, ellipse_b, angle_param)
		poly_data.append(bl + ellipse_vector)
	# then keep vector the same and replace bl with tl
	poly_data.append(tl + ellipse_vector)
	# then step t from pi/2 to 3pi/4, at each step adding tl plus vector
	for x in range(8):
		angle_param += angle_step
		ellipse_vector = parellipse(ellipse_a, ellipse_b, angle_param)
		poly_data.append(tl + ellipse_vector)
	# then keep vector the same and replace tl with tr
	poly_data.append(tr + ellipse_vector)
	# then step t from 3pi/4 to 2pi, at each step adding tr plus vector
	for x in range(8):
		angle_param += angle_step
		ellipse_vector = parellipse(ellipse_a, ellipse_b, angle_param)
		poly_data.append(tr + ellipse_vector)
	# it automatically closes up
	#print(poly_data)
	#poly_data = [tl, tr, br, bl]
	#poly_coordinates = [[0, 0], [tail_base_1, -80], [left_corneroid_x, -80], [left_corneroid_x, -160],
	#					[left_corneroid_x + width, -160], [left_corneroid_x + width, -80], [tail_base_1 + 20, -80]]
	$RichText.set_position(Vector2(tl.x - ellipse_a/2, tl.y)) #tip.x - 100, tip.y - 160))

	#for subarray in poly_coordinates:
	#	poly_data.append(Vector2(subarray[0], subarray[1]))
	self.set_polygon(poly_data)
	
func calc_thought_cloud_polygon(y_offset):
	var poly_data = PackedVector2Array()
	var left_corneroid_x
	var tail_base_1
	if self.tail_is_left:
		left_corneroid_x = -100
		tail_base_1 = 100
	else:
		left_corneroid_x = -200
		tail_base_1 = -100
		
	var center = Vector2(left_corneroid_x + inner_width/2, -80 - inner_height/2 - y_offset)
		
	var cycle_angle = 0
	var lump_size = inner_width/5.0
	
	for cycle in range(16):
		var epicycle_center = center + parellipse(inner_width/2, inner_height, cycle_angle)
		
		var epicycle_angle = cycle_angle - PI/2
		for epicycle in range(8):
			var ellipse_vector = parellipse(lump_size*0.5, lump_size*0.4, epicycle_angle)
			poly_data.append(epicycle_center + ellipse_vector)
			epicycle_angle += PI/8
		var ellipse_vector = parellipse(lump_size*0.5, lump_size*0.4, epicycle_angle)
		poly_data.append(epicycle_center + ellipse_vector)
			
		cycle_angle += PI/8
	
	$RichText.set_position(Vector2(left_corneroid_x, center.y - inner_height/2)) #tip.x - 100, tip.y - 160))
	self.set_polygon(poly_data)
	# TODO: Add separate polygons for the bubble trail
	

func draw_speech_balloon(tip_pos, text, tail_is_left):
	var richtext
	
	self.set_position(tip_pos.position)
	#tip = tip_pos.position
	richtext = $RichText
		
	self.visible = true
	richtext.visible = true
	self.tail_is_left = tail_is_left
	self.calc_balloon_polygon(0)
	# TODO: Calculate size of balloon from size of text
	
	# Move the rich text label up in here
	
	richtext.set_size(Vector2(self.inner_width + self.ellipse_a, self.inner_height + self.ellipse_b))
	
	richtext.text = text
	richtext.visible_ratio = 0
	var text_tween = self.create_tween()
	text_tween.tween_property(richtext, "visible_ratio", 1, 2)
	text_tween.tween_callback(self._on_Text_tween_completed)
	self.text_tween = text_tween
	#$TextTween.interpolate_property(
	#	richtext, "visible_ratio", 0, 1, 2,
	#	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	#)
	#$TextTween.start()
	
func float_upward():
	# TODO what do we do if this gets called again while
	# we're alraedy floating upward? (that can happen)
	# In that case, probably disappearing immediately is
	# our best bet.
	#var oldpos = Vector2(self.position.x, self.position.y)
	#var newpos = Vector2(self.position.x, self.position.y - 100)
	#$FloatUpTween.interpolate_property(
	#	self, "position", oldpos, newpos, 0.5
	#)
	var oldpos = self.times_floated_up * 100
	var newpos = (self.times_floated_up + 1)* 100
	var tween = self.create_tween()
	#tween_property($Sprite, "modulate", Color.RED, 1)
	tween.tween_method(self.calc_balloon_polygon, oldpos, newpos, 0.5)
	#tween.tween_method(look_at.bind(Vector3.UP), Vector3(-1, 0, -1), Vector3(1, 0, -1), 1) # The look_at() method takes up vector as second argument.
	tween.tween_callback(self._on_Float_tween_completed)

	#$FloatUpTween.interpolate_method(
	#	self, "calc_balloon_polygon", oldpos, newpos, 0.5
	#)
	#$FloatUpTween.start()
	self.times_floated_up += 1
	
func _on_Text_tween_completed():
	# i cant directly set finished=true here
	# I need to emit a signal that my parent can listen for
	emit_signal("tween_finished")
	
func _on_Float_tween_completed():
	if self.times_floated_up > 1:
		self.set_visible(false)

func skip_to_end():
	# TODO re-implement
	if self.text_tween != null:
		if self.text_tween.is_valid() and self.text_tween.is_running():
			self.text_tween.custom_step(5)
			$RichText.visible_ratio= 1
	
	#$TextTween.stop_all()
	#$RichText.percent_visible = 1
