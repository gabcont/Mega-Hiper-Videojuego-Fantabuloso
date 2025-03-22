extends TextureProgressBar

@onready var timer = $Timer  # Nodo Timer

var max_health = 100  # Valor máximo de la barra
var current_health = 0  # La barra empieza en 0

func _ready():
	# Configurar la barra de vida
	self.max_value = max_health  # Establece el máximo de la barra
	self.value = current_health  # Inicia la barra en 0

	# Inicia el temporizador
	timer.start()  # Asegúrate de que el Timer esté configurado con un tiempo adecuado en el Inspector

# Método que se ejecuta cuando el Timer emite la señal 'timeout'
func _on_Timer_timeout():
	if current_health < max_health:
		current_health += 3  # Aumenta la vida en 10 unidades
		self.value = current_health  # Actualiza el valor de la barra
	else:
		timer.stop()  # Detén el temporizador cuando la barra esté llena
