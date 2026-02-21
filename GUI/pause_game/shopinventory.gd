class_name ShopInventory
extends Control

@export var shop_inventory: Array[ItemData]

@onready var shop_menu := self
@onready var item_container: VBoxContainer = %ShopItemContainer
@onready var gems_label: Label = %GemsLabel

@onready var purchase_button: Button = $Button
# @onready var close_button: Button = %CloseButton 

var selected_item: ItemData = null

func _ready() -> void:
	# Connect to inventory changes for real-time updates
	if PlayerManager.INVENTORY_DATA:
		PlayerManager.INVENTORY_DATA.changed.connect(update_gems_display)
	
	# Populate items when shop tab is opened
	update_gems_display()
	populate_items(shop_inventory)
	# Initialize Detail Panel with first item if available
	if shop_inventory.size() > 0:
		update_item_details(shop_inventory[0])
		selected_item = shop_inventory[0]
	
	visibility_changed.connect(update_gems_display)

func show_shop_menu() -> void:
	# This is called when the shop tab is selected
	# Items are already populated in _ready()
	pass
		
func update_inventory_display() -> void:
	# Update the inventory grid container directly
	if PauseMenu and PauseMenu.inventory:
		var inventory_grid = PauseMenu.inventory.get_node_or_null("PanelContainer/GridContainer")
		if inventory_grid and inventory_grid.has_method("update_inventory"):
			inventory_grid.update_inventory()
	
	# Also try to update any UI with inventory_ui group
	var inventory_ui = get_tree().get_first_node_in_group("inventory_ui")
	if inventory_ui and inventory_ui.has_method("update_inventory"):
		inventory_ui.update_inventory()



func update_item_details(item: ItemData) -> void:
	# Update the Detail Panel with item information
	
	# Try direct path access 
	var item_image = get_node_or_null("DetailPanel/Control/ItemImage")
	var item_name = get_node_or_null("DetailPanel/Control/ItemName")
	var item_price = get_node_or_null("DetailPanel/Control/ItemPrice")
	var item_description = get_node_or_null("DetailPanel/Control/ItemDescribtion")
	
	# Update the UI elements
	if item_image and item.texture:
		item_image.texture = item.texture
	if item_name:
		item_name.text = item.name
	if item_price:
		item_price.text = str(item.cost)
	if item_description:
		item_description.text = item.description

	# Update Purchase Button state
	if purchase_button:
		var gem_item = preload("res://Items/gem.tres")
		var gem_count = PlayerManager.INVENTORY_DATA.get_item_held_quantity(gem_item)
		purchase_button.disabled = gem_count < item.cost

func clear_items() -> void:
	for c in item_container.get_children():
		c.queue_free()

func populate_items(items: Array[ItemData]) -> void:
	clear_items()
	for item in items:
		var item_button = preload("res://GUI/shop_menu## do not use/shop_item_button.tscn").instantiate()
		item_button.setup_item(item)
		item_button.pressed.connect(func(): purchase_item(item))
		# Add focus enter signal for item details
		item_button.focus_entered.connect(func(): 
			update_item_details(item)
			selected_item = item
		)
		# Also separate mouse enter signal if using mouse
		item_button.mouse_entered.connect(func():
			update_item_details(item)
			selected_item = item
		)
		item_container.add_child(item_button)
	
	# Connect the general purchase button to purchase the selected item
	if purchase_button:
		if purchase_button.pressed.is_connected(on_purchase_button_pressed):
			purchase_button.pressed.disconnect(on_purchase_button_pressed)
		purchase_button.pressed.connect(on_purchase_button_pressed)
	
	# Update displays when items are populated
	update_gems_display()

func on_purchase_button_pressed() -> void:
	if selected_item:
		purchase_item(selected_item)

func update_gems_display() -> void:
	if gems_label and PlayerManager.INVENTORY_DATA:
		var gem_item = preload("res://Items/gem.tres")
		var gem_count = PlayerManager.INVENTORY_DATA.get_item_held_quantity(gem_item)
		gems_label.text = str(gem_count)
		
		# Refresh button state if an item is selected
		if selected_item:
			update_item_details(selected_item)
	
	# Also update any other gem displays in the UI
	var player_hud = get_tree().get_first_node_in_group("player_hud")
	if player_hud and player_hud.has_method("update_gem_display"):
		player_hud.update_gem_display()

func purchase_item(item: ItemData) -> void:
	var gem_item = preload("res://Items/gem.tres")
	var gem_count = PlayerManager.INVENTORY_DATA.get_item_held_quantity(gem_item)
	
	if gem_count >= item.cost:
		# Remove gems and add purchased item
		if PlayerManager.INVENTORY_DATA.use_item(gem_item, item.cost):
			if PlayerManager.INVENTORY_DATA.add_item(item, 1):
				# Trigger item effects immediately on purchase (e.g. sword upgrade -> x2 damage)
				item.use()
				# Update all UI elements
				update_gems_display()
				update_inventory_display()
			else:
				# If item couldn't be added, refund the gems
				PlayerManager.INVENTORY_DATA.add_item(gem_item, item.cost)
