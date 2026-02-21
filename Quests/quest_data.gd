class_name QuestData extends Resource

@export var id: String = ""
@export var title: String = ""
@export_multiline var description: String = ""
@export var level: int = 1          # 1, 2, or 3

var completed: bool = false
