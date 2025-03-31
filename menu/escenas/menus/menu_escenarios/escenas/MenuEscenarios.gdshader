shader_type canvas_item;

uniform vec4 overlay_color : source_color = vec4(1.0, 0.0, 0.0, 0.2); // Rojo semi-transparente con opacidad base

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    COLOR = mix(color, overlay_color, overlay_color.a); // Mezcla con la opacidad de overlay_color
}