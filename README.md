# Spotify

Now-playing widget for the [Omarchy](https://omarchy.org/) Quattro bar.

Shows the current Spotify track. Click play/pause, scroll or use the mouse buttons to skip. The widget hides when Spotify is idle.

Plugin id: `io.github.swadowmaster.spotify`

## Install

Omarchy 4 (Quattro) only.

```bash
omarchy plugin add https://github.com/SwadowMaster/omarchy-spotify.git --enable
```

Optional placement:

```bash
omarchy bar move io.github.swadowmaster.spotify --section center
```

## Remove

```bash
omarchy plugin remove io.github.swadowmaster.spotify
```

That disables the widget and deletes the git checkout. It does not change other Omarchy settings.

## Requirements

- Omarchy 4 (Quattro)
- Spotify (or another player whose MPRIS identity/desktop/dbus name contains `spotify`)

No extra packages. The widget uses Quickshell's MPRIS service. `playerctl` is not required.

## License

MIT. See [LICENSE](LICENSE).
