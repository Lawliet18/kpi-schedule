import 'package:flutter/material.dart';
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
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  @override
  void initState() {
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
          hintStyle: TextStyle(fontSize: 18, color: Colors.black54),
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none)),
      itemBuilder: (context, item) {
        return Container(
          child: Text(item),
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
      key: key,
      suggestions: widget.groups,
    );
    super.initState();
  }

  onSubmit(BuildContext context) {
    SharedPref.saveString('groups', searchTextField.textField.controller.text);
    Provider.of<Notifier>(context, listen: false)
        .addGroupName(searchTextField.textField.controller.text);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Schedule()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 60),
                Image(image: AssetImage("assets/img/logo.png")),
                SizedBox(height: 10),
                Text(
                  'KPI Schedule',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 40),
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
            'Please input your group',
          ),
          Text('(like in example)'),
          buildField(context),
          SizedBox(height: 20),
          buildConfirmButton(context)
        ],
      ),
    );
  }

  Center buildField(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Column(children: <Widget>[
            searchTextField,
          ])
        ]));
  }

  RaisedButton buildConfirmButton(BuildContext context) {
    return RaisedButton(
      elevation: 4,
      onPressed: onSubmit(context),
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
