import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../settings.dart';

class TeacherAppBar extends StatelessWidget {
  const TeacherAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: const Icon(Icons.people),
      title: Text(
        S.of(context).teacher,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          letterSpacing: 1.2,
          wordSpacing: 1.2,
        ),
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
