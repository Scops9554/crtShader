extern number numColours;

vec4 effect(vec4 colour, Image image, vec2 uv, vec2 sc) {
  vec4 pixel = floor(Texel(image, uv) * numColours) / numColours;
  float row = mod(floor(sc.y), 8); 

  float opacity = 0.05;
  float scanline = 1 - opacity * step(1.0, row - 3);

  return pixel * scanline;
}
