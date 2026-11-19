import 'package:fladder/providers/settings/client_settings_provider.dart';
import 'package:fladder/util/adaptive_layout/adaptive_layout.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PinchPosterZoom extends ConsumerStatefulWidget {
  final Widget child;
  final Function(double difference)? scaleDifference;
  const PinchPosterZoom({required this.child, this.scaleDifference, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PinchPosterZoomState();
}

class _PinchPosterZoomState extends ConsumerState<PinchPosterZoom> {
  double lastScale = 1.0;

  @override
  Widget build(BuildContext context) {
    // Scale gestures compete with vertical scrolling in mobile browsers and
    // can make the page visibly shake. Poster zoom remains available on
    // larger screens.
    if (AdaptiveLayout.viewSizeOf(context) == ViewSize.phone) {
      return widget.child;
    }

    return GestureDetector(
      onScaleStart: (details) {
        lastScale = 1;
      },
      onScaleUpdate: (details) {
        final difference = details.scale - lastScale;
        if (ref.watch(
          clientSettingsProvider.select((value) => value.pinchPosterZoom),
        )) {
          widget.scaleDifference?.call(difference);
        }
        lastScale = details.scale;
      },
      child: widget.child,
    );
  }
}
