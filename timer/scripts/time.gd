extends TextureProgressBar

signal tiempo_partida_acabado

@onready var timer = $Timer 
@onready var label = $Label 

var countdown_time = 30

func _ready():
	# Configuramos la barra de progreso y el Label al inicio
	self.max_value = countdown_time
	self.value = countdown_time
	label.text = str(countdown_time)
	timer.start()  # Iniciar el temporizador

# Método que se ejecuta cada vez que se emite la señal timeout
func _on_Timer_timeout():
	countdown_time -= 1  
	if countdown_time >= 0:
		#Actualizando variable y texto
		self.value = countdown_time  
		label.text = str(countdown_time) 
	else:
		timer.stop()
		emit_signal("tiempo_partida_acabado")  
	   
