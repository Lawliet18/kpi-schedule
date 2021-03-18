import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../settings.dart';

class NotesAppBar extends StatelessWidget {
  const NotesAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        S.of(context).notes,
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 1.2,
          wordSpacing: 1.2,
        ),
      ),
      leading: const Icon(
        Icons.notes,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Settings(),
            ),
          ),
        )
      ],
    );
  }
}
