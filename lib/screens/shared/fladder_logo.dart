import 'package:material_ui/material_ui.dart';

class FladderLogo extends StatelessWidget {
  const FladderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "Fladder_Logo_Tag",
      child: Material(
        color: Colors.transparent,
        child: Text(
          "NAS",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
              ),
        ),
      ),
    );
  }
}
