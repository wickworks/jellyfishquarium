@tool
extends Path3D
class_name Rail

@onready var csg_polygon: CSGPolygon3D = %CSGPolygon3D

func _ready() -> void:
	# create a new curve if we were just added to the tree somewhere (not the base scene)
	if curve == null and get_parent() != null:
		curve = Curve3D.new()
		curve.add_point(Vector3.ZERO)
		curve.add_point(Vector3(2,2,2))
		curve = curve
	
	#remove_child(csg_polygon)
	#add_child(csg_polygon)
