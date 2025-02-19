@tool
extends Path3D
class_name Rail

@onready var csg_polygon: CSGPolygon3D = %CSGPolygon3D

var old_point_count:int = 0

func _ready() -> void:
	# create a new curve if we were just added to the tree somewhere (not the base scene)
	if is_inside_tree() and get_parent() != null:
		if curve == null:
			curve = Curve3D.new()
			curve.add_point(Vector3.ZERO)
			curve.add_point(Vector3(2,2,2))
	
		curve_changed.connect(on_curve_changed)
	
	old_point_count = curve.point_count
	
	#remove_child(csg_polygon)
	#add_child(csg_polygon)

	
func on_curve_changed() -> void:
	if not curve: return
	
	# adding a new point? make it the same elevation as the last one
	if curve.point_count > old_point_count and curve.point_count > 1 and curve.point_count != old_point_count:
		old_point_count = curve.point_count
		
		var prev := curve.point_count-2
		var prev_pos := curve.get_point_position(prev)
		var new := curve.point_count-1
		var new_pos := curve.get_point_position(new)
		curve.set_point_position(new, Vector3(new_pos.x, prev_pos.y, new_pos.z))
	
