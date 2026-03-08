extends Resource
class_name QuestData

@export var quest_id : String = "my_quest"
@export var title : String = "Untitled Quest"
@export var description : String = ""

@export var required_items : Array[InvItem] = []
@export var required_amounts : Array[int] = []   
@export var reward_items : Array[InvItem] = []
@export var reward_amounts : Array[int] = []     # RECOMPENSAS EXTRAS

@export var debug_color : Color = Color.YELLOW
