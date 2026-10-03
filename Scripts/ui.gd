extends CanvasLayer


# =========================
# UI REFERENCES
# =========================

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

@onready var intro_panel = $IntroPanel
@onready var intro_text = $IntroPanel/IntroText


# =========================
# CURRENT ITEM
# =========================

var current_item = null


# =========================
# INTRO
# =========================

var intro_messages = [
	"The time has finally come. \nToday, you have to leave this house behind.",
	"You have spent years here. \nEvery room holds a memory.",
	"But you cannot take everything with you.",
	"Choose carefully what you want to keep.",
	"Use the arrows to move."
]

var intro_index := 0


# =========================
# INVENTORY
# =========================

var inventory: Array = []

const MAX_INVENTORY_SIZE := 3


# =========================
# READY
# =========================

func _ready():

	# Hide UI elements at the beginning
	interaction_label.visible = false
	item_panel.visible = false
	exit_label.visible = false
	ending_panel.visible = false

	# Show intro
	intro_panel.visible = true
	intro_text.text = intro_messages[0]

	# Pause the game while intro is displayed
	get_tree().paused = true

	# Initial inventory
	update_inventory()


# =========================
# INPUT
# =========================

func _process(_delta):

	# INTRO
	if intro_panel.visible:

		if Input.is_action_just_pressed("next"):
			next_intro_message()

		return


	# ITEM PANEL
	if item_panel.visible:

		if Input.is_action_just_pressed("take_item"):
			take_current_item()

		elif Input.is_action_just_pressed("leave_item"):
			hide_item()


# =========================
# INTRO FUNCTIONS
# =========================

func next_intro_message():

	intro_index += 1

	if intro_index < intro_messages.size():

		intro_text.text = intro_messages[intro_index]

	else:

		close_intro()


func close_intro():

	intro_panel.visible = false

	# Start the game
	get_tree().paused = false


# =========================
# INTERACTION LABEL
# =========================

func show_interaction():

	interaction_label.visible = true


func hide_interaction():

	interaction_label.visible = false


# =========================
# ITEM PANEL
# =========================

func show_item(item_name: String, description: String, item):

	interaction_label.visible = false

	item_panel.visible = true

	title_label.text = item_name
	description_label.text = description

	current_item = item


func hide_item():

	item_panel.visible = false

	current_item = null


# =========================
# TAKE ITEM
# =========================

func take_current_item():

	if current_item == null:
		return


	# Check inventory space
	if inventory.size() >= MAX_INVENTORY_SIZE:

		description_label.text = "Your inventory is full."

		return


	# Add item to inventory
	inventory.append({
		"name": current_item.item_name,
		"category": current_item.category
	})


	# Remove item from the world
	current_item.take_item()


	# Update inventory UI
	update_inventory()


	# Close item panel
	hide_item()


# =========================
# INVENTORY UI
# =========================

func update_inventory():

	inventory_title.text = "INVENTORY: " + str(inventory.size()) + " / 3"


	# Reset slots
	slot1.text = "Empty"
	slot2.text = "Empty"
	slot3.text = "Empty"


	# Slot 1
	if inventory.size() > 0:

		slot1.text = inventory[0]["name"]


	# Slot 2
	if inventory.size() > 1:

		slot2.text = inventory[1]["name"]


	# Slot 3
	if inventory.size() > 2:

		slot3.text = inventory[2]["name"]


# =========================
# EXIT
# =========================

func show_exit():

	exit_label.visible = true


func hide_exit():

	exit_label.visible = false


# =========================
# ENDING
# =========================

func show_ending():

	# Pause the game
	get_tree().paused = true


	# Hide other UI
	exit_label.visible = false
	interaction_label.visible = false
	item_panel.visible = false


	# Count categories
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


	# Show ending panel
	ending_panel.visible = true


	# =========================
	# ENDING 1 - NOTHING
	# =========================

	if inventory.size() == 0:

		ending_title.text = "You left everything behind."

		ending_text.text = "You walked out with nothing.\n\nMaybe some memories are easier to leave behind than to carry."


	# =========================
	# ENDING 2 - PAST
	# =========================

	elif past_count > future_count and past_count >= personal_count:

		ending_title.text = "You chose the past."

		ending_text.text = "You decided to keep the memories that connected you to who you used to be.\n\nSome things may change, but the past will always be part of you."


	# =========================
	# ENDING 3 - FUTURE
	# =========================

	elif future_count > past_count and future_count >= personal_count:

		ending_title.text = "You chose the future."

		ending_text.text = "You took the things that reminded you of where you are going.\n\nLeaving was difficult, but you were ready to move forward."


	# =========================
	# ENDING 4 - MIXED
	# =========================

	else:

		ending_title.text = "You took a little of everything."

		ending_text.text = "You kept memories from different parts of your life.\n\nYou don't have to choose between who you were and who you will become."
