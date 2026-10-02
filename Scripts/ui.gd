extends CanvasLayer

@onready var interaction_label = $InteractionLabel
@onready var item_panel = $ItemPanel
@onready var title_label = $ItemPanel/Title
@onready var description_label = $ItemPanel/Description

@onready var inventory_title = $InventoryPanel/InventoryTitle
@onready var slot1 = $InventoryPanel/Slot1
@onready var slot2 = $InventoryPanel/Slot2
@onready var slot3 = $InventoryPanel/Slot3

@onready var exit_label = $ExitLabel
@onready var ending_panel = $EndingPanel
@onready var ending_title = $EndingPanel/EndingTitle
@onready var ending_text = $EndingPanel/EndingText
var current_item = null

var inventory: Array = []
const MAX_INVENTORY_SIZE := 3

func _process(_delta):
	if item_panel.visible:
		if Input.is_action_just_pressed("take_item"):
			take_current_item()
		
		elif Input.is_action_just_pressed("leave_item"):
			hide_item()

func show_interaction():
	interaction_label.visible = true


func hide_interaction():
	interaction_label.visible = false


func show_item(item_name: String, description: String, item):
	interaction_label.visible = false
	item_panel.visible = true
	
	title_label.text = item_name
	description_label.text = description
	
	current_item = item


func hide_item():
	item_panel.visible = false
	current_item = null

func take_current_item():
	if current_item == null:
		return
	
	if inventory.size() >= MAX_INVENTORY_SIZE:
		description_label.text = "Your inventory is full."
		return
	
	inventory.append({
		"name": current_item.item_name,
		"category": current_item.category
	})
	
	current_item.take_item()
	update_inventory()
	hide_item()
	
func update_inventory():
	inventory_title.text = "INVENTORY: " + str(inventory.size()) + " / 3"
	
	slot1.text = "Empty"
	slot2.text = "Empty"
	slot3.text = "Empty"
	
	if inventory.size() > 0:
		slot1.text = inventory[0]["name"]
	
	if inventory.size() > 1:
		slot2.text = inventory[1]["name"]
	
	if inventory.size() > 2:
		slot3.text = inventory[2]["name"]
		
func show_exit():
	exit_label.visible = true


func hide_exit():
	exit_label.visible = false


func show_ending():
	get_tree().paused = true
	exit_label.visible = false
	interaction_label.visible = false
	item_panel.visible = false
	
	var past_count := 0
	var future_count := 0
	var personal_count := 0
	
	for item in inventory:
		match item["category"]:
			"Past":
				past_count += 1
			
			"Future":
				future_count += 1
			
			"Personal":
				personal_count += 1
	
	ending_panel.visible = true
	
	if inventory.size() == 0:
		ending_title.text = "You left everything behind."
		
		ending_text.text = "You walked out with nothing.\n\nMaybe some memories are easier to leave behind than to carry."
	
	elif past_count > future_count and past_count >= personal_count:
		ending_title.text = "You chose the past."
		
		ending_text.text = "You decided to keep the memories that connected you to who you used to be.\n\nSome things may change, but the past will always be part of you."
	
	elif future_count > past_count and future_count >= personal_count:
		ending_title.text = "You chose the future."
		
		ending_text.text = "You took the things that reminded you of where you are going.\n\nLeaving was difficult, but you were ready to move forward."
	
	else:
		ending_title.text = "You took a little of everything."
		
		ending_text.text = "You kept memories from different parts of your life.\n\nYou don't have to choose between who you were and who you will become."
