WORK IN PROGRESS

# numbernine

WORK IN PROGRESS

> I’ll have two number nines, a number 9 large, a number 6 with extra dip, a number 7, two number 45s, one with cheese, and a large soda.   
> — Big Smoke

A lightweight Wayland desktop environment,
focused on a good balance between friendliness/discoverability and customization/power-user-features.

## Requirements

- **Right now, being a developer :) This is an early stage project. Do not package into OS repos yet, please.**
- FreeBSD -CURRENT (or 12-STABLE I guess), Linux, any other system you can run Wayfire on (DragonFly??)
	- FreeBSD currently needs either `chmod g+rw /dev/input/*` (bad security) or [patched libudev-devd](https://github.com/FreeBSDDesktop/libudev-devd/pull/8) for input devices to be recognized
- [`Wayfire`](https://github.com/WayfireWM/wayfire) (git master)
- [`wf-gsettings`](https://github.com/myfreeweb/wf-gsettings)
- [`ldc`](https://github.com/ldc-developers/ldc) (maybe `dmd` or `gdc`, but you might need to tweak stuff in that case)
- [`dub`](https://github.com/dlang/dub)
- [`wayland-d` fork](https://github.com/myfreeweb/wayland-d)
- [`GtkD`](https://github.com/gtkd-developers/GtkD) (installed as shared libraries)
- [`gtk-layer-shell`](https://github.com/wmww/gtk-layer-shell)
- [`libhandy`](https://source.puri.sm/Librem5/libhandy)
- [`libqalculate`](https://github.com/Qalculate/libqalculate)
- [`polkit`](https://gitlab.freedesktop.org/polkit/polkit)
- [`upower-glib`](https://gitlab.freedesktop.org/upower/upower)
- [`libepoxy`](https://github.com/anholt/libepoxy)

Get `wayland-d` fork (TODO: will be converted to meson hopefully soon), register, and build the client lib in matching mode (release/debug) to meson:

```shell
git clone https://github.com/myfreeweb/wayland-d
cd wayland-d
dub build wayland:scanner -b release
dub build wayland:client -b release
dub add-local $PWD
```

Install with Meson (into the same prefix as Wayfire), configure Wayfire like this (substitute `$PREFIX` with where you install it, e.g. `/usr/local` or `$HOME/.local`):

```ini
[core]
plugins = mod2key gsettings
# gsettings will load all the plugins (but mod2key is not in its defaults..)

[autostart]
shell = $PREFIX/bin/n9-shell
pk-agent = $PREFIX/bin/n9-pk-agent

# don't really need anything else in the config,
# other than binding touchscreens to displays and setting display scales.
# when that becomes possible via gsettings, n9 will include this kind of config
```

Don't forget to compile GSettings schemas:

```
doas glib-compile-schemas /usr/local/share/glib-2.0/schemas/
```

And if you install to an unusual prefix, make sure its `share` directory is on `XDG_DATA_HOME`, then GSettings would see it.
