shader_type canvas_item;

void fragment() {
    // Obtener las coordenadas normales (0 a 1)
    vec2 uv = UV;
    
    // Calcular la distancia al centro
    float dist = distance(uv, vec2(0.5));
    
    // Difuminar del centro hacia afuera
    float alpha = smoothstep(0.4, 0.5, dist);
    
    // Fondo gris con difuminado hacia adentro
    COLOR = vec4(0.5, 0.5, 0.5, 1.0 - alpha); // RGB = gris, Alpha controlado
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
