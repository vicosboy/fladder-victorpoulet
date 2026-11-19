import 'package:material_ui/material_ui.dart';

import 'package:fladder/screens/shared/fladder_icon.dart';

class FladderLogo extends StatelessWidget {
  const FladderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Hero(tag: "Fladder_Logo_Tag", child: FladderIcon());
  }
}
