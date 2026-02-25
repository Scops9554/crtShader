extern number numColours;
extern number spacing = 4.0;

float getB(vec4 pix) {
  return (pix.r + pix.g + pix.b) / 3;
}

vec4 effect(vec4 colour, Image image, vec2 uv, vec2 sc) {
  vec2 texel = 1 / (spacing * love_ScreenSize.xy);

  vec4 pixel = Texel(image, uv);
  vec4 top = Texel(image, uv + vec2(0, -1) * texel);
  vec4 bot = Texel(image, uv + vec2(0, 1) * texel);

  pixel.rgb = floor(pixel.rgb * numColours) / numColours;
  top.rgb = floor(top.rgb * numColours) / numColours;
  bot.rgb = floor(bot.rgb * numColours) / numColours;

  float pixelB = getB(pixel);
  float topB = getB(top);
  float botB = getB(bot);

  float col = mod(floor(sc.x), spacing);
  float row = mod(floor(sc.y), spacing);

  float onSL = step(1, row);

  float surroundB = max(topB, botB);
  float bleed = surroundB * surroundB * 0.75;
  float lineB = mix(bleed, 1.0, onSL);

  vec4 side = mix(bot, top, step(botB, topB));
  pixel = mix(side, pixel, onSL);

  float avg = (spacing - 1) / 2;
  float isVE = step(avg, abs(col - avg));
  float isHE = step(avg - 0.5, abs(row - avg - 0.5));

  float decay = (pixelB - 1) * (pixelB - 1) / 5;
  float edgeB = 1 - isHE * decay;

  pixel.a *= mix(1.0, 0.85, isVE * isHE);

  return pixel * lineB * edgeB;
}
