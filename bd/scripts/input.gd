extends LineEdit

@onready var statusLabel = %StatusLabel

func _on_text_changed(new_text : String):
	var regex = RegEx.new()
	regex.compile("\\s") # Expresión regular para espacios en blanco
	if regex.search(new_text):
		self.text = new_text.replace(" ", "")
	if not self.secret:
		var regex_username = RegEx.new()
		regex_username.compile("[^a-zA-Z0-9]")
		if regex_username.search(self.text):
			for i in range(0,self.text.length()):
				if i<self.text.length():
					if regex_username.search(self.text[i]):
						self.text[i]=''
				else:
					#arregla error de ` y ~ 
					self.text=self.text.substr(0,self.text.length()-1)	
		
	self.caret_column = self.text.length()

	statusLabel.text = ""
