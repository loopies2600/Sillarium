shader_type canvas_item;

uniform sampler2D maskTexture;

void fragment() {
    vec4 maskedColor = texture(TEXTURE, UV);
    maskedColor.a *= texture(maskTexture, UV).a;

    COLOR = maskedColor;
}