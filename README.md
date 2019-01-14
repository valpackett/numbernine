WORK IN PROGRESS

# numbernine

> I’ll have two number nines, a number 9 large, a number 6 with extra dip, a number 7, two number 45s, one with cheese, and a large soda.   
> — Big Smoke

A lightweight Wayland desktop environment.

## Requirements

- Right now, being a developer :) This is an early stage project.
- FreeBSD -CURRENT (or 12-STABLE guess, but [r342768](https://reviews.freebsd.org/rS342768) wasn't MFC'd yet)
	- to launch on FreeBSD, either [loginw](https://github.com/myfreeweb/loginw) or [patched ConsoleKit2](https://reviews.freebsd.org/D18754)
	- and either `chmod g+rw /dev/input/*` (bad security) or [patched kernel](https://reviews.freebsd.org/D18694) plus [patched libudev-devd](https://github.com/FreeBSDDesktop/libudev-devd/pull/8) for input devices to be recognized
	- you need newer libudev-devd than in ports right now anyway because [this fixed the gpu enumeration](https://github.com/FreeBSDDesktop/libudev-devd/commit/f11ee5b418c740ba6fd4c946ab10b0d89702e4d0) and because of that I removed the hardcoded `dri/card0` hack from the weston mentioned below
	- XXX: Linux support should be easy to add (just needs a supervisor implementation for systems w/o process descriptors)
- `gtkmm30`
- `flatbuffers` (with `flatc` for building)
- [`fmt`](https://github.com/fmtlib/fmt) ([libfmt in FreeBSD ports needs this update for the pkg-config file](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=234951))
- [This fork of Weston](https://github.com/myfreeweb/weston)
	- build options for FreeBSD: `meson build -Dsystemd=false -Dlauncher-logind=false -Dsimple-dmabuf-drm=auto -Dbackend-fbdev=false`
- [These Weston plugins](https://github.com/myfreeweb/weston-extra-dip)
- Weston configured like this:

```ini
[core]
xwayland=true
shell=desktop-shell.so
modules=capabilities.so,layer-shell.so,compositor-management.so
# Extra plugins: key-modifier-binds.so,gamma-control.so,layered-screenshot.so

[shell]
# (well, adjust paths to the PREFIX you installed to)
client=/usr/local/libexec/weston-desktop-shell-boneless
real-client=/usr/local/libexec/n9-supervisor
```
