extern number numColours;

const int spacing = 4;

vec4 effect(vec4 colour, Image texture, vec2 uv, vec2 sc) {
  vec2 screenSize = love_ScreenSize.xy;

  vec4 pixel = Texel(texture, uv);
  pixel = floor(pixel * numColours) / numColours;
  float pixelB = (pixel.r + pixel.g + pixel.b) * pixel.a / 3;

  vec4 top = Texel(texture, uv + vec2(0.0, -1) / (spacing * screenSize));
  vec4 bot = Texel(texture, uv + vec2(0.0,  1) / (spacing * screenSize));
  top = floor(top * numColours) / numColours;
  bot = floor(bot * numColours) / numColours;

  float topB = (top.r + top.g + top.b) * top.a / 3;
  float botB = (bot.r + bot.g + bot.b) * bot.a / 3;

  float surroundB = max(topB, botB);

  float xRow = mod(floor(sc.x), spacing);
  float yRow = mod(floor(sc.y), spacing);

  float line = clamp(yRow + surroundB, 0.0, 1.0);
  float edge = 1 - mod(floor(sc.y), 2) * (1 - pixelB) / 3.5;

  float isTop = step(surroundB, topB);
  float isBot = step(surroundB, botB);
  float isLine = step(line, surroundB);

  pixel = mix(pixel, top, isTop * isLine);
  pixel = mix(pixel, bot, isBot * isLine);

  float isVE = step(1.5, abs(xRow - 1.5));
  float isHE = step(1.0, abs(yRow - 2.0));
  pixel.a *= mix(1.0, 0.85, isVE * isHE);

  return pixel * line * edge;
}
