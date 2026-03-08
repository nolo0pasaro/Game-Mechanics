extends Node

signal quest_started(quest: QuestData)
signal quest_completed(quest: QuestData)

var active_quests: Dictionary = {}          # String > QuestData
var completed_quests: Array[String] = []

@onready var PlayerInventory: Inv = preload("res://Inventory/playersinv.tres")


func start_quest(quest: QuestData) -> void:
	if active_quests.has(quest.quest_id):
		print("[Quest] Already active: ", quest.quest_id)
		return
	if completed_quests.has(quest.quest_id):
		print("[Quest] Already completed: ", quest.quest_id)
		return
	
	active_quests[quest.quest_id] = quest
	print("[Quest] quest accepted: ", quest.title)
	quest_started.emit(quest)


func is_quest_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)


func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.has(quest_id)


func try_complete_quest(quest_id: String) -> bool:
	if not active_quests.has(quest_id):
		return false
	
	var quest: QuestData = active_quests[quest_id]
	
	# ——— AQUI VC VE SE O JOGADOR TEM TUDO ———
	for i: int in quest.required_items.size():
		var item: InvItem = quest.required_items[i]
		var needed: int = quest.required_amounts[i] if i < quest.required_amounts.size() else 1
		
		if get_item_count(item) < needed:
			print("[Quest] Missing ", needed, " × ", item.name if item else "null")
			return false
	
	# ——— AQUI VAI CONSUMIR OS ITENS ———
	for i: int in quest.required_items.size():
		var item: InvItem = quest.required_items[i]
		var needed: int = quest.required_amounts[i] if i < quest.required_amounts.size() else 1
		_consume_exact_item(item, needed)
	
	# ——— RECOMPENSAS CASO VC COMPLETE ———
	for i: int in quest.reward_items.size():
		var item: InvItem = quest.reward_items[i]
		var amount: int = quest.reward_amounts[i] if i < quest.reward_amounts.size() else 1
		_add_exact_item(item, amount)
	
	# ——— TERMINAR QUEST ———
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	print("[Quest] quest completed: ", quest.title)
	quest_completed.emit(quest)
	return true


# ────────────────

func get_item_count(target_item: InvItem) -> int:
	if PlayerInventory == null:
		return 0
	
	var count: int = 0
	for slot in PlayerInventory.slots:
		if slot.item == target_item:
			count += slot.amount
	return count


func _consume_exact_item(target_item: InvItem, amount: int) -> void:
	if PlayerInventory == null or amount <= 0:
		return
	
	var remaining: int = amount
	for slot in PlayerInventory.slots:
		if slot.item == target_item and remaining > 0:
			var remove: int = min(remaining, slot.amount)
			slot.amount -= remove
			remaining -= remove
			if remaining == 0:
				break
	
	PlayerInventory.update.emit()


func _add_exact_item(target_item: InvItem, amount: int) -> void:
	if PlayerInventory == null or amount <= 0:
		return
	
	for i: int in amount:
		PlayerInventory.insert(target_item)
