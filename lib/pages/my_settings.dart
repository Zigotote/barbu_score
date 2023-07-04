import 'package:flutter/material.dart';

import '../commons/widgets/default_page.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      title: "Paramètres",
      hasLeading: true,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Thème"),
          ElevatedButton(onPressed: () {}, child: const Text('Sombre')),
          ElevatedButton(onPressed: () {}, child: const Text('Clair'))
        ],
      ),
    );
  }
}
