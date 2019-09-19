extends Spatial

var base_night_sky_rotation = Basis(Vector3(1.0, 1.0, 1.0).normalized(), 1.2)
var horizontal_angle = 25.0

func _set_sky_rotation():
	var rot = Basis(Vector3(0.0, 1.0, 0.0), deg2rad(horizontal_angle)) * Basis(Vector3(1.0, 0.0, 0.0), $Control/Time_Of_Day.value * PI / 12.0)
	rot = rot * base_night_sky_rotation;
	$Skybox.set_rotate_night_sky(rot)

func _ready():
	# init our time of day
	$Skybox.set_time_of_day($Control/Time_Of_Day.value, get_node("Sun"), deg2rad(horizontal_angle))
	
	# rotate our night sky so our milkyway isn't on our horizon
	_set_sky_rotation()

func _on_Skybox_sky_updated():
	#$Skybox.copy_to_environment(get_viewport().get_camera().environment)
	pass

func _on_Time_Of_Day_value_changed(value):
	$Skybox.set_time_of_day(value, get_node("Sun"), deg2rad(horizontal_angle))
	_set_sky_rotation()


