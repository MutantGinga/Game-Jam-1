extends Attack

var is_firing: bool = false

@onready var raycast = $RayCast2D
@onready var resource_component = owner.get_node("ResourceComponent")
@export var b_can_damage: bool = true
@export var b_has_force: bool = false
@export var force: float = 0
@export var resource_usage: int = 2



func use():
	if resource_component.current_resource > 0:
		fire()
	else:
		stop_firing()
	
func fire():
	is_firing = true
	raycast.enabled = true
	raycast.line.visible = true
	
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
		



func stop_firing():
	is_firing = false
	raycast.enabled = false
	raycast.line.visible = false
	
	$AudioStreamPlayer.stop()


func _on_timer_timeout():
	if is_firing:
		print(resource_component.current_resource)
		resource_component.spend_resource(resource_usage)
