@tool
extends StaticBody3D

@export var mesh:Mesh = BoxMesh.new():
	get:
		return mesh
	set(value):
		mesh = value
		sync_mesh()

func _ready() -> void:
	sync_mesh()
	
	if not Engine.is_editor_hint():
		%MeshInstance3D.create_trimesh_collision()

func sync_mesh() -> void:
	if is_inside_tree():
		%MeshInstance3D.mesh = mesh
		
