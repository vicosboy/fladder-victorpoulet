{{flutter_js}}
{{flutter_build_config}}

// Force browsers to fetch the current interface after a deployment instead
// of reusing an older, long-lived compiled bundle.
for (const build of _flutter.buildConfig.builds) {
  if (build.mainJsPath) {
    build.mainJsPath = `${build.mainJsPath}?release=connectivity-playback-20261127`;
  }
}

// Keep the Jellyfin page and API on the user's server, while loading the
// sizeable compiled application from a fast static host.
_flutter.loader.load({
  config: {
    entrypointBaseUrl: "https://vicosboy.github.io/fladder-victorpoulet/",
    assetBase: "https://vicosboy.github.io/fladder-victorpoulet/",
  },
});
