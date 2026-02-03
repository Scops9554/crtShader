extern number numColours;

const int spacing = 4;

float getB(vec4 pix) {
  return (pix.r + pix.g + pix.b) / 3;
}

vec4 effect(vec4 colour, Image image, vec2 uv, vec2 sc) {
  vec2 texel = 1 / (spacing * love_ScreenSize.xy);

  vec4 pixel = Texel(image, uv);
  vec4 top   = Texel(image, uv + vec2(0, -1) * texel);
  vec4 bot   = Texel(image, uv + vec2(0,  1) * texel);

  pixel.rgb = floor(pixel.rgb * numColours) / numColours;
  top.rgb   = floor(top.rgb * numColours) / numColours;
  bot.rgb   = floor(bot.rgb * numColours) / numColours;

  float pixelB = getB(pixel);
  float topB   = getB(top);
  float botB   = getB(bot);

  float onEdge = mod(floor(sc.y), 2);
  float decay = (pixelB - 1) * (pixelB - 1) / 5;
  float edgeB = 1 - onEdge * decay;

  float col = mod(floor(sc.x), spacing);
  float row = mod(floor(sc.y), spacing);

  float onSL = step(1, row);

  float surroundB = max(topB, botB);
  float bleed = surroundB * surroundB;
  float lineB = mix(bleed, 1.0, onSL);

  vec4 side = mix(bot, top, step(botB, topB));
  pixel = mix(side, pixel, onSL);

  float isVE = step(1.5, abs(col - 1.5));
  float isHE = step(1.0, abs(row - 2.0));
  pixel.a *= mix(1.0, 0.85, isVE * isHE);

  return pixel * lineB * edgeB;
}
