class_name SFX extends Node


func play_sfx(audio : String) -> void:
    match audio:
        "ataque_1":
            $ataque_1.play()
        "ataque_2":
            $ataque_2.play()
        "ataque_especial":
            $ataque_especial.play()
        "huida":
            $huida.play()