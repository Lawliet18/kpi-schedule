import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'save_data/notifier.dart';
import 'save_data/shared_prefs.dart';
import 'schedule.dart';

class HomeScreen extends StatefulWidget {
  final List<String> groups;
  const HomeScreen({Key? key, required this.groups}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String autocompleteText;
  bool ifOpen = false;
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();
    keyboardVisibilityController.onChange.listen((visible) {
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
                        const Image(image: AssetImage('assets/img/logo.png')),
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

  Form buildField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
          padding: MediaQuery.of(context).viewPadding,
          child: RawAutocomplete(
            optionsBuilder: (textEditingValue) {
              return widget.groups.where((option) =>
                  option.contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selection) {
              ifOpen = false;
              setState(() {
                autocompleteText = selection;
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (value) {
                  setState(() {
                    autocompleteText = value;
                  });
                  onFieldSubmitted();
                },
                validator: (value) {
                  if (!widget.groups.contains(value) && value == null) {
                    return 'Nothing Selected';
                  }
                  return null;
                },
                textInputAction: TextInputAction.go,
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
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none)),
              );
            },
            optionsViewBuilder: (context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: options
                          .map<Widget>((String option) => GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Text(option),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  ElevatedButton buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            const Size(100, 50),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (!_formKey.currentState!.validate()) {
          return;
        }
        SharedPref.saveString('groups', autocompleteText);
        Provider.of<Notifier>(context, listen: false)
            .addGroupName(autocompleteText);
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
