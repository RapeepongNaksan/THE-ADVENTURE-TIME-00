extends Control


var hearts = 5 setget set_hearts
var max_hearts = 5 setget set_max_hearts

onready var HeartUIEmpty = $HeartUIEmpty
onready var HeartUIFull = $HeartUIFull

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if HeartUIFull != null:
		HeartUIFull.rect_min_size.x = hearts * 15
	
func  set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts, max_hearts)
	if HeartUIEmpty != null:
		HeartUIEmpty.rect_min_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_change", self, "set_hearts")
	PlayerStats.connect("max_health_change", self, "set_max_hearts")
