// shader inspired by scanl line effect in Animal Well

extern number numColours;
extern vec2 texelSize;

const number spacing = 6.0;

float getB(vec4 pix) {
  return (pix.r + pix.g + pix.b) / 3;
}

vec4 effect(vec4 colour, Image image, vec2 uv, vec2 sc) {
  vec4 pixel = Texel(image, uv);
  vec4 left = Texel(image, uv - vec2(1.0, 0) * texelSize);
  vec4 right = Texel(image, uv + vec2(1.0, 0) * texelSize);

  pixel.rgb = floor(pixel.rgb * numColours) / numColours;
  float pixelB = getB(pixel);

  float row = mod(floor(sc.y), spacing);
  float col = mod(floor(sc.x), spacing);

  float isHE = float(row == 1 || row == 4);
  float isVE = float(col == 0 || col == 5);

  float edgeB = mix(1.0, (1 + pixelB) / 2, isHE * (1 - isVE));

  float onSL = float(0 != row && row != 5);
  float lineB = mix(pixelB, 1.0, onSL);

  float sameNs = float(distance(left.rgb, right.rgb) < 0.05);
  float dimming = mix((1 + 2 * pixelB) / 3, (1 + pixelB) / 2, sameNs);
  float cornerB = mix(1.0, dimming, isVE * isHE);

  pixel.a = pixel.a * lineB * edgeB * cornerB;

  return pixel;
}
