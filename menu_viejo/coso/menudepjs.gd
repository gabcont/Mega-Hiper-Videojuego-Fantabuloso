extends CanvasLayer

const personajes = [
	preload("res://Knuckles.png"),
	preload("res://Kirby.png"),
	preload("res://Sans.png"),
	preload("res://Luffy.png")
]
var index_selection = 2
var personaje_sprite

func _ready():
	personaje_sprite = $Sprite2D
	update_portrait(index_selection)
	
func update_portrait(index):
	personaje_sprite.texture = personajes[index]

func _on_button_izq_pressed() -> void:
	if(index_selection > 0 ):
		index_selection -= 1
	elif(index_selection == 0):
		index_selection = personajes.size()-1
	update_portrait(index_selection)


func _on_button_der_pressed() -> void:
	if(index_selection < personajes.size()-1):
		index_selection +=1
	elif(index_selection == personajes.size()-1 ):
		index_selection = 0
	update_portrait(index_selection)


func _on_button_ok_pressed() -> void:
	print("texto")

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		_on_button_ok_pressed()
	elif(event.is_action_pressed("ui_right")):
		_on_button_der_pressed()
	elif(event.is_action_pressed("ui_left")):
		_on_button_izq_pressed()
