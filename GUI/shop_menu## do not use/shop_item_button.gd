class_name ShopItemButton extends Button

var item : ItemData

func setup_item(_item : ItemData) -> void:
	item = _item
	$Label.text = item.name
	$PriceLabel.text = str(item.cost)
	$TextureRect.texture = item.texture
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# This will be connected in the shop menu script
	pass
