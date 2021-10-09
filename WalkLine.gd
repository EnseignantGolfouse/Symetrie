extends Line2D

# true if we are walking the line.
var running: bool = false
# How many seconds it takes to walk the line.
export var speed: float = 5.0
# signal with a `Vector2` that the point moved on the line.
signal moved
# signal that the walking of the line is finished.
signal finished


# Start the walking of the line.
func start():
	self.running = true
	$Path.curve.clear_points()
	for point in self.points:
		$Path.curve.add_point(point)
	$Path/PointPosition.unit_offset = 0.0
	$Path.show()

# Stop the walking of the line.
func stop():
	self.running = false
	$Path.hide()

# When the walking process is active, move the point along the line.
func _process(delta: float):
	if self.running:
		$Path/PointPosition.unit_offset += delta / self.speed
		self.emit_signal("moved", $Path/PointPosition.position)
		if $Path/PointPosition.unit_offset >= 1.0:
			$Path.hide()
			self.running = false
			$Path/PointPosition.unit_offset = 0.0
			self.emit_signal("finished")
