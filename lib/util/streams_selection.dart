import 'package:flutter/foundation.dart';

import 'package:fladder/models/items/media_streams_model.dart';

int? selectAudioStream(
  bool rememberAudioSelection,
  AudioAndSubStreamModel? previousStream,
  List<AudioAndSubStreamModel>? currentStream,
  int? defaultStream,
) {
  if (!rememberAudioSelection) {
    return defaultStream;
  }
  return _selectStream(previousStream, currentStream, defaultStream);
}

int? selectSubStream(
  bool rememberSubSelection,
  AudioAndSubStreamModel? previousStream,
  List<AudioAndSubStreamModel>? currentStream,
  int? defaultStream,
) {
  if (!rememberSubSelection) {
    return defaultStream;
  }
  return _selectStream(previousStream, currentStream, defaultStream);
}

/// Browser video elements cannot display Blu-ray bitmap subtitles (PGS).
/// Prefer an equivalent text track so Jellyfin does not have to burn the
/// subtitles into the video. If no text equivalent exists, keep playback
/// working with subtitles disabled instead of starting a fragile transcode.
int? selectWebCompatibleSubStream(
  int? requestedStream,
  List<SubStreamModel>? streams,
) {
  if (!kIsWeb || requestedStream == null || requestedStream == -1) {
    return requestedStream;
  }

  final requested = streams
      ?.where((stream) => stream.index == requestedStream)
      .firstOrNull;
  if (requested == null || _isWebTextSubtitle(requested)) {
    return requestedStream;
  }

  final requestedLanguage = requested.language.toLowerCase();
  final requestedForced = _looksForced(requested);
  final compatible = (streams ?? const <SubStreamModel>[])
      .where(_isWebTextSubtitle)
      .toList();
  if (compatible.isEmpty) return -1;

  compatible.sort((a, b) {
    int score(SubStreamModel stream) {
      var value = 0;
      if (stream.language.toLowerCase() == requestedLanguage) value += 8;
      if (_looksForced(stream) == requestedForced) value += 4;
      if (stream.supportsExternalStream) value += 2;
      if (stream.isExternal) value += 1;
      return value;
    }

    return score(b).compareTo(score(a));
  });

  final best = compatible.first;
  return best.language.toLowerCase() == requestedLanguage ? best.index : -1;
}

bool _isWebTextSubtitle(SubStreamModel stream) {
  return const {
    'srt',
    'subrip',
    'vtt',
    'webvtt',
    'ass',
    'ssa',
  }.contains(stream.codec.toLowerCase());
}

bool _looksForced(SubStreamModel stream) {
  final label = '${stream.title} ${stream.displayTitle}'.toLowerCase();
  return label.contains('forced') ||
      label.contains('force') ||
      label.contains('forcé');
}

int? _selectStream(
  AudioAndSubStreamModel? previousStream,
  List<AudioAndSubStreamModel>? currentStream,
  int? defaultStream,
) {
  if (currentStream == null || previousStream == null) {
    return defaultStream;
  }

  int? bestStreamIndex;
  int bestStreamScore = 0;

  // Find the relative index of the previous stream
  int prevRelIndex = 0;
  for (var stream in currentStream) {
    if (stream.index == previousStream.index) break;
    prevRelIndex += 1;
  }

  int newRelIndex = 0;
  for (var stream in currentStream) {
    int score = 0;

    if (previousStream.codec == stream.codec) score += 1;
    if (prevRelIndex == newRelIndex) score += 1;
    if (previousStream.displayTitle == stream.displayTitle) {
      score += 2;
    }
    if (previousStream.language != 'und' &&
        previousStream.language == stream.language) {
      score += 2;
    }

    if (score > bestStreamScore && score >= 3) {
      bestStreamScore = score;
      bestStreamIndex = stream.index;
    }

    newRelIndex += 1;
  }
  return bestStreamIndex ?? defaultStream;
}
