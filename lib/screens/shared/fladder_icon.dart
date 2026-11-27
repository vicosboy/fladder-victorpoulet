import 'package:material_ui/material_ui.dart';

class FladderIcon extends StatelessWidget {
  final double size;
  const FladderIcon({this.size = 72, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.dns_outlined,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class FladderIconOutlined extends StatelessWidget {
  final double size;
  final Color? color;
  const FladderIconOutlined({this.size = 100, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.dns_outlined,
      size: size,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
