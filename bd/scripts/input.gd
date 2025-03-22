extends LineEdit

@onready var statusLabel = get_node("../StatusLabel")

func _on_text_changed(new_text : String):
	var regex = RegEx.new()
	regex.compile("\\s") # Expresión regular para espacios en blanco
	if regex.search(new_text):
		self.text = new_text.replace(" ", "")

	statusLabel.text = ""
