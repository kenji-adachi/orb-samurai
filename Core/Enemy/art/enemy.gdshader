shader_type canvas_item;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Default to white
instance uniform float flash_percentage : hint_range(0.0, 1.0, 0.1) = 0.0; // Controls the mix amountnstancenstannn

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    // Mix the original color with the flash color based on the percentage
    texture_color.rgb = mix(texture_color.rgb, flash_color.rgb, flash_percentage);
    COLOR = texture_color;
}
