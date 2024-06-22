extends BaseProjectile

class_name Thrown

## A Thrown attack that inherits from BaseProjectile.
##
## Thrown is a projectile that can explode on impact depending on a boolean changed in the editor, leaving behind lingering flames. The Thrown attack deals damage on impact, and the flames use the DamageElement class to deal damage over time.

## A variable used to store the health component of the received collision body.
var health_component
## A preload of the damage element scene, so that we can instance it to represent flames.
var flames_scene = preload("res://Scenes/Components/damage_element.tscn")
## A variable that stores the root node of the level on ready, so that flames can be spawned as a child of the level.
@onready var level_root = get_tree().current_scene
## A varuable that controls the rotation of the thrown projectile for shurikens/etc

func _ready():
	pass

## A collision method that triggers when a body collides with the Thrown attack. This deals damage to the received collision body if it has a health component, and then makes the projectile explode if set to explode.
##[br]
##[br]
## We have to check if the collision body has a health component because the Thrown projectile can also collide with a wall, at which point it should not try to remove health.
func _on_thrown_area_body_entered(body):
	health_component = body.get_node("HealthComponent")
	if health_component:
		health_component.remove_health(damage_value, damage_type)
		delete_projectile()
	if impact_explosion:
		explode()
	else:
		delete_projectile()

## A method that instances a damage element to represent flames, sets its scale appropriately, and then deletes the projectile.
##[br]
##[br]
## The flames currently linger forever. However, once another branch is merged into main, we can implement simple functionality that allows us to set them to despawn after a certain amount of time in code.
func explode():
	super()
	var flames_instance = flames_scene.instantiate()
	print("FLAMES")
	level_root.add_child(flames_instance)
	flames_instance.global_position = global_position
	flames_instance.scale = Vector2(0.2, 0.2)
	delete_projectile()
	# NEED TO SET DESPAWN TIME AND BOOLEAN ONCE THE RELEVANT BRANCH IS MERGED WITH MAIN