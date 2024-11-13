_:
let
  rgba =
    r: g: b: a:
    if a == null then "rgba(${r},${g},${b},1.0)" else "rgba(${r},${g}.${b},${a})";
in
{
  general = {

  };

  background = [
    {
      path = builtins.toString ../../../etc/wallpapers/sorcerer-casting.jpg;
      blur_passes = 2;
    }
  ];

  input-field = [
    {
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = rgba 202 211 245 null;
      inner_color = rgba 91 96 120 null;
      outer_color = rgba 24 25 38 null;
      outline_thickness = 5;
      placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
      shadow_passes = 2;
    }
  ];
}
