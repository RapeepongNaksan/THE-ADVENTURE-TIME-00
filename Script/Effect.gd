extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "no_animation_finished")
	play("Animate")
	
func no_animation_finished():
	queue_free()

