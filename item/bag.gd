class_name Bag
extends Node

var size: int = 3
var items: Array[Item] = [Iron.new()]

func get_size():
	return size;

func set_size(new_size: int):
	if new_size < items.size():
		print("Discarding ", items.size() - new_size, " items in the bag")
		items = items.slice(0, new_size)
	size = new_size

# 
func get_item_type() -> String:
	if items.size() > 0:
		return items[0].get_type()
	return ""

func get_item_type_class() -> Item:
	if items.size() > 0:
		return items[0].duplicate()
	return Item.new()

func get_item_count() -> int:
	return items.size()

# Returns the amount of items that can still be stored in the bag
# -1 indicates that the bag contains a different type of item
func can_carry(item_type: String) -> int:
	if items.size() > 0 and item_type != items[0].get_type():
		return -1;
	return size - items.size();

# Adds the provided items to the bag.
# Returns the number of items that were added to the bag.
# Returns -1 if the bag cannot carry this type of item
func add_item(new_items: Array[Item]) -> int:
	if (new_items.size() <= 0):
		return 0
	
	var carryable_items = can_carry(new_items[0].get_type())
	
	if carryable_items <= 0:
		return carryable_items
	
	if carryable_items > new_items.size():
		items.append_array(new_items)
		return new_items.size()
	
	while carryable_items < new_items.size():
		new_items.pop_back()
	
	items.append_array(new_items)
	return carryable_items

func take_items(amount: int) -> Array[Item]:
	var items_to_return
	if amount >= items.size():
		items_to_return = items
		items = []
		return items_to_return
	
	items_to_return = items.slice(0, amount)
	items = items.slice(amount, items.size())
	return items_to_return
