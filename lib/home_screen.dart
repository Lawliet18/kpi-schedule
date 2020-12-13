import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/save_data/notifier.dart';
import 'package:schedule_kpi/schedule.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:schedule_kpi/save_data/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  final List<String> groups;
  const HomeScreen({Key key, this.groups}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AutoCompleteTextFieldState<String>> _key = GlobalKey();
  AutoCompleteTextField<String> searchTextField;
  bool ifOpen = false;

  @override
  void initState() {
    super.initState();
    searchTextField = AutoCompleteTextField<String>(
      textInputAction: TextInputAction.done,
      submitOnSuggestionTap: true,
      clearOnSubmit: false,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black45,
      ),
      decoration: InputDecoration(
          filled: true,
          hintText: 'ТВ-71',
          labelText: 'Group',
          hintStyle: TextStyle(fontSize: 18, color: Colors.black54),
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
      itemBuilder: (context, item) {
        return Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
            item,
            style: TextStyle(fontSize: 14),
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
        setState(() => searchTextField.textField.controller.text = item);
      },
      key: _key,
      suggestions: widget.groups,
    );
    var keyboardVisibilityController = KeyboardVisibilityController();
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      ifOpen = visible;
      print('Keyboard visibility update. Is visible: ${visible}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, !ifOpen ? 80 : 20, 20, 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedCrossFade(
                    firstChild: Image(image: AssetImage("assets/img/logo.png")),
                    secondChild: Container(),
                    crossFadeState: !ifOpen
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 500)),
                SizedBox(height: 10),
                const Text(
                  'KPI Schedule',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
          const Text(
            'Please input your group\n(like in example)',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          buildField(context),
          SizedBox(height: 20),
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

  RaisedButton buildConfirmButton(BuildContext context) {
    return RaisedButton(
      elevation: 4,
      onPressed: () {
        SharedPref.saveString(
            'groups', searchTextField.textField.controller.text);
        Provider.of<Notifier>(context, listen: false)
            .addGroupName(searchTextField.textField.controller.text);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Schedule()));
      },
      color: Color(0xff5422E2),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Text(
          'Confirm',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
