extends Node

# true if we are in the middle of drawing the symetric.
var walking: bool = false
# Maximum y position to draw
var max_y: float
# Maximum x position to draw
var max_x: float

func _ready():
	var screen_size = get_viewport().size
	self.new(screen_size.x / 2, screen_size.y)

func new(axis_position_x: float, axis_length: float):
	self.max_x = axis_position_x
	self.max_y = axis_length - 50
	$SymetricLine.position = Vector2(0, 0)
	$SymetricLine.points = []
	$Axis.position = Vector2(axis_position_x, 0)
	$Axis.points = [Vector2(0, 0), Vector2(0, axis_length)]

# 'StartButton' is pressed
func on_start_pressed():
	self.walking = true
	$SymetricLine.clear_points()
	$OriginalLine.start()

# 'ResetButton' is pressed
func on_reset_pressed():
	$SymetricLine.points = []
	$SymetricLine.clear_points()
	$OriginalLine.stop()
	self.walking = false

# 'ClearButton' is pressed
func on_clear_pressed():
	if not self.walking:
		$OriginalLine.clear_points()
		$SymetricLine.clear_points()

# When 'OriginalLine' is `running`, it periodically emit the position of the
# point.
func on_walk_line_moved(point: Vector2):
	var posx = 2 * $Axis.position.x - (point.x + $OriginalLine.position.x)
	var posy = point.y + $OriginalLine.position.y
	$SymetricLine.add_point(Vector2(posx, posy))

func on_walk_line_finished():
	self.walking = false

# Allows the creation of new points by clicking.
func _input(event: InputEvent):
	if (not self.walking) and (event is InputEventMouseButton):
		if event.position.x <= self.max_x and event.position.y <= self.max_y:
			$OriginalLine.add_point(event.position)
