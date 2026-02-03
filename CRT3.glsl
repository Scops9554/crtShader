extern number numColours;

const float spacing = 4.0;

float getB(vec4 pix) {
  return (pix.r + pix.g + pix.b) / 3;
}

vec4 effect(vec4 colour, Image image, vec2 uv, vec2 sc) {
    vec2 texel = 1 / love_ScreenSize.xy;

    vec4 pixel = Texel(image, uv) * colour;
    pixel.rgb = floor(pixel.rgb * numColours) / numColours;
    float pixelB = getB(pixel);

    float row = mod(floor(sc.y), spacing);
    float col = mod(floor(sc.x), spacing);

    float onSL = step(1, col);

    float lineB = mix(1.0, 0.9, step(3, row));

    return pixel * onSL * lineB;
}
