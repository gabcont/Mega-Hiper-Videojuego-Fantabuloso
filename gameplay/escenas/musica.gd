extends AudioStreamPlayer  # Asegúrate de que el script esté asignado al nodo AudioStreamPlayer

func _ready():
	# Configura el nodo de música para ignorar la pausa del árbol
	self.pause_mode = Node.PAUSE_MODE_PROCESS
