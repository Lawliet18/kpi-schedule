import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import 'package:schedule_kpi/generated/l10n.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';
import 'package:schedule_kpi/schedule.dart';

class HomeScreen extends StatefulWidget {
  final List<String> groups;
  const HomeScreen({Key? key, required this.groups}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AutoCompleteTextFieldState<String>> _key = GlobalKey();
  late AutoCompleteTextField<String> searchTextField;
  bool ifOpen = false;

  @override
  void initState() {
    super.initState();
    searchTextField = AutoCompleteTextField<String>(
      onFocusChanged: (hasFocus) {},
      textInputAction: TextInputAction.go,
      clearOnSubmit: false,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
          filled: true,
          hintText: 'ТВ-71',
          labelText: 'Group',
          hintStyle: const TextStyle(fontSize: 18),
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder:
              const UnderlineInputBorder(borderSide: BorderSide.none)),
      itemBuilder: (context, item) {
        return Container(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            item,
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
      itemFilter: (item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.compareTo(b);
      },
      itemSubmitted: (item) {
        setState(() => searchTextField.textField.controller?.text = item);
      },
      key: _key,
      suggestions: widget.groups,
    );
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      ifOpen = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, !ifOpen ? 80 : 20, 20, 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedCrossFade(
                    firstChild:
                        const Image(image: AssetImage("assets/img/logo.png")),
                    secondChild: Container(),
                    crossFadeState: !ifOpen
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500)),
                const SizedBox(height: 10),
                Text(
                  S.of(context).title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: !ifOpen ? 40 : 20),
                buildTextField(
                  context,
                )
              ]),
        ),
      ),
    ));
  }

  Padding buildTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).homeScreenInput,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          buildField(context),
          const SizedBox(height: 20),
          buildConfirmButton(context)
        ],
      ),
    );
  }

  Padding buildField(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewPadding,
        child: Column(children: <Widget>[
          Column(
            children: [
              searchTextField,
            ],
          )
        ]));
  }

  ElevatedButton buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            const Size(100, 50),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
      onPressed: () {
        final controllerText = searchTextField.textField.controller?.text ?? "";
        SharedPref.sharedPref.saveString('groups', controllerText);
        Provider.of<Notifier>(context, listen: false)
            .addGroupName(controllerText);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Schedule()));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Text(
          S.of(context).confirm,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
