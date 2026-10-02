extends Area2D

@export var item_name: String = "Item"
@export_multiline var description: String = "An ordinary object."
@export_enum("Past", "Future", "Personal") var category: String = "Past"

var player_nearby := false

@onready var ui = get_tree().current_scene.get_node("UI")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_nearby = true
		ui.show_interaction()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_nearby = false
		ui.hide_interaction()

func take_item():
	print("Item taken: ", item_name)
	queue_free()

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		ui.show_item(item_name, description, self)
