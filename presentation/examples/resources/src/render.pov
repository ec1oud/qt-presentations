#include "./joystick-outer-case.inc"
#include "math.inc"
#include "finish.inc"
#include "transforms.inc"
background {color rgb 1}
light_source {
  <200,500,400>
  rgb 1
}
global_settings {
  assumed_gamma 2
}
#declare Min = min_extent(m_OpenSCAD_Model);
#declare Max = max_extent(m_OpenSCAD_Model);
#declare bottom_diag = sqrt(pow(Max.y - Min.y, 2) + pow(Max.x - Min.x, 2));
#debug concat("bottom_diag:", str(bottom_diag, 5, 0))
#declare box_diag = sqrt(pow(bottom_diag, 2) + pow(Max.z - Min.z, 2));
#debug concat("box_diag:", str(box_diag, 5, 0))
#declare look_angle = degrees(tanh((Max.z - Min.z) / (bottom_diag / 2)));
#declare look_at_z = (Max.z - Min.z) / 2;
#debug concat("look_at:", str(look_at_z, 5, 0))
camera {
  orthographic
  location <0,box_diag-40,200>
  rotate <look_angle,0,0>
  look_at <0,0,look_at_z>
}
sky_sphere {
  pigment {
  gradient y
  color_map {
    [0.0 rgb <1.0,1.0,1.0>] //153, 178.5, 255 //150, 240, 192
    [0.7 rgb <0.9,0.9,0.9>] // 0, 25.5, 204 //155, 240, 96
  }
  scale 2
  translate 1
  }
}
object {
  m_OpenSCAD_Model
  texture {
    pigment {color <0.4,0.4,0.4>}
normal {
    bump_map {
      jpeg "Metal-PSE-009.jpg"
      bump_size 0.2
    }
  }
  finish {phong 0.5}
  }
}

// to render:
// povray +I"render.pov" +FN +W1920 +H1440 +O"joystick-outer-case-pov.png" +Q9 +AM1 +A +UA
