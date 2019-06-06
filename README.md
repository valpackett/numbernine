WORK IN PROGRESS

# numbernine

> I’ll have two number nines, a number 9 large, a number 6 with extra dip, a number 7, two number 45s, one with cheese, and a large soda.   
> — Big Smoke

A lightweight Wayland desktop environment.

## Requirements

- Right now, being a developer :) This is an early stage project.
- FreeBSD -CURRENT (or 12-STABLE I guess), Linux, any other system you can run Wayfire on (DragonFly??)
	- FreeBSD currently needs either `chmod g+rw /dev/input/*` (bad security) or [patched libudev-devd](https://github.com/FreeBSDDesktop/libudev-devd/pull/8) for input devices to be recognized
- [Wayfire](https://github.com/WayfireWM/wayfire) git `stabilize-api-v2`
- `gtkmm30`
- `libhandy`
- `polkit`
- `flatbuffers` (with `flatc` for building)
- [`fmt`](https://github.com/fmtlib/fmt)
- `pugixml`


Install with Meson (into the same prefix as Wayfire), configure Wayfire like this (substitute `$PREFIX` with where you install it, e.g. `/usr/local` or `$HOME/.local`):

```ini
[core]
plugins = … wobbly decoration alpha mod2key gsettings

[autostart]
background = $PREFIX/libexec/n9-wallpaper
panel = $PREFIX/libexec/n9-panel
launcher = $PREFIX/libexec/n9-launcher
notifications = $PREFIX/libexec/n9-notification-daemon
```

Don't forget to install GSettings schemas into your main prefix where glib lives, and to compile them, e.g.:

```
doas cp ~/.local/share/glib-2.0/schemas/* /usr/local/share/glib-2.0/schemas/
doas glib-compile-schemas /usr/local/share/glib-2.0/schemas/
```
