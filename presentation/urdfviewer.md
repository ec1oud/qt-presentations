# Exporting URDF to a Qt Quick 3D Digital Twin

But first: *what is URDF?*

- **U**nified **R**obot **D**escription **F**ormat
- industry-standard XML schema
- links and joints
- visual materials
- collision volumes
- physics: mass, moment of inertia

How to get it: export from your CAD

How to use it:

```
$ urdfviewer --help 
Usage: /home/rutledge/dev/qt-stabilizing-rel/qtbase/bin/urdfviewer [options] urdf or xacro destination 
Import a URDF file, preview and export a Qt Quick 3D scene 

Options: 
 -h, --help                   Displays help on commandline options. 
 --help-all                   Displays help, including generic Qt options. 
 -v, --version                Displays version information. 
 -b, --bridge                 Preview with live ROS bridge. 
 -u, --upm <units>            Scene <units> per meter. 
 -p, --topic-prefix <prefix>  DDS topic <prefix> for robot. 

Arguments: 
 urdf or xacro                File to open 
 destination                  Output directory 
```
### Demo:

```
urdfviewer -b -u 1000 -p dogzilla ~/dev/qt-robotics/dogzilla/digitwin/urdf/dogzilla.urdf /tmp
```

