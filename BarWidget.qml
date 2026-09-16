import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "io.github.swadowmaster.spotify"

  property bool opened: false
  property bool popoutSwitchClosing: false

  readonly property var players: Mpris.players ? Mpris.players.values : []
  readonly property var player: pickSpotify()
  readonly property bool hasTrack: player && (player.trackTitle || player.trackArtist)
  readonly property bool playing: player ? !!player.isPlaying : false
  readonly property bool isAd: {
    if (!player)
      return false
    const trackId = player.trackId || player.dbusName || ""
    return String(trackId).indexOf(":ad:") !== -1
  }
  readonly property string artist: player ? (player.trackArtist || "") : ""
  readonly property string title: player ? (player.trackTitle || "") : ""
  readonly property string displayText: {
    if (isAd)
      return "Advertisement"
    if (artist && title)
      return artist + " - " + title
    return title || artist
  }
  readonly property string label: {
    if (!hasTrack)
      return ""
    const icon = playing ? "" : ""
    return icon + " " + displayText + "  "
  }

  visible: hasTrack
  implicitWidth: hasTrack ? button.implicitWidth : 0
  implicitHeight: button.implicitHeight

  function open() {}
  function close() {}
  function toggle() {}
  function closeForPopoutSwitch() {}

  function looksLikeSpotify(p) {
    if (!p)
      return false
    const blob = [
      p.identity || "",
      p.desktopEntry || "",
      p.dbusName || "",
      p.busName || ""
    ].join(" ").toLowerCase()
    return blob.indexOf("spotify") !== -1
  }

  function pickSpotify() {
    const list = players || []
    for (let i = 0; i < list.length; i++) {
      if (looksLikeSpotify(list[i]))
        return list[i]
    }
    return null
  }

  function playPause() {
    if (!player)
      return
    if (player.isPlaying && player.canPause)
      player.pause()
    else if (!player.isPlaying && player.canPlay)
      player.play()
    else if (player.canTogglePlaying)
      player.togglePlaying()
  }

  function next() {
    if (player && player.canGoNext)
      player.next()
  }

  function previous() {
    if (player && player.canGoPrevious)
      player.previous()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    tooltipText: root.hasTrack ? ((root.playing ? "Playing" : "Paused") + "\n" + root.displayText + "\n\nClick: play/pause · scroll: skip") : ""
    onPressed: function(buttonCode) {
      if (!root.hasTrack)
        return
      if (buttonCode === Qt.LeftButton)
        root.playPause()
      else if (buttonCode === Qt.MiddleButton)
        root.previous()
      else if (buttonCode === Qt.RightButton)
        root.next()
    }
    onWheelMoved: function(delta) {
      if (!root.hasTrack || delta === 0)
        return
      // Match Omarchy media widget: scroll up = previous, scroll down = next
      if (delta > 0)
        root.previous()
      else
        root.next()
    }
  }
}
