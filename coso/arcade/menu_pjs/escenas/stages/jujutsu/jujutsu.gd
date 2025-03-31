extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Iniciar la animación automáticamente
	animated_sprite.play("fondo")
