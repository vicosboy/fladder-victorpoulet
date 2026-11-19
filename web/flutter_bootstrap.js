{{flutter_js}}
{{flutter_build_config}}

// Keep the Jellyfin page and API on the user's server, while loading the
// sizeable compiled application from a fast static host.
_flutter.loader.load({
  config: {
    entrypointBaseUrl: "https://vicosboy.github.io/fladder-victorpoulet/",
  },
});
