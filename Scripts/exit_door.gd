extends Area2D

var player_nearby := false

@onready var ui = get_tree().current_scene.get_node("UI")


func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_nearby = true
		ui.show_exit()


func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_nearby = false
		ui.hide_exit()


func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		ui.show_ending()
