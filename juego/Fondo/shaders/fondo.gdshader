shader_type canvas_item;

// Parámetros de movimiento
uniform float move_speed : hint_range(0.1, 2.0) = 0.5;
uniform float move_amount : hint_range(0.0, 0.4) = 0.2; // Reducido para evitar bordes

// Parámetros de zoom
uniform float zoom_speed : hint_range(0.1, 1.0) = 0.3;
uniform float zoom_min : hint_range(1.0, 2.0) = 1.2; // Zoom mínimo >1 para margen
uniform float zoom_max : hint_range(1.0, 3.0) = 1.5;

void fragment() {
    // Calculamos el zoom (oscilación suave entre mínimo y máximo)
    float zoom = zoom_min + (zoom_max - zoom_min) * 0.5 * (1.0 + sin(TIME * zoom_speed));
    
    // Calculamos el desplazamiento (proporcional al zoom para mantener márgenes)
    float effective_move = move_amount / zoom;
    float offset_x = effective_move * sin(TIME * move_speed);
    
    // Aplicamos transformaciones (centrado perfecto)
    vec2 centered_uv = (UV - 0.5) / zoom + 0.5;
    vec2 final_uv = centered_uv + vec2(offset_x, 0.0);
    
    // Aseguramos que no se muestren bordes
    if (final_uv.x < 0.0 || final_uv.x > 1.0 || final_uv.y < 0.0 || final_uv.y > 1.0) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0); // Color de bordes (negro)
    } else {
        COLOR = texture(TEXTURE, final_uv);
    }
    
    // Versión alternativa con bordes transparentes (para fondos no rectangulares)
    // COLOR = texture(TEXTURE, clamp(final_uv, 0.0, 1.0));
}