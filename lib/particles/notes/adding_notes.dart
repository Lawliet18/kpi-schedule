import 'package:flutter/material.dart';
import 'package:schedule_kpi/Models/lessons.dart';
import 'package:schedule_kpi/particles/lesson_block.dart';

class AddingNotes extends StatelessWidget {
  const AddingNotes({Key key, this.data}) : super(key: key);

  final Lessons data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Notes'),
        ),
        body: LessonBlock(
          data: data,
        ),
        floatingActionButton: CustomFloatingButton());
  }
}

class CustomFloatingButton extends StatefulWidget {
  const CustomFloatingButton({
    Key key,
  }) : super(key: key);

  @override
  _CustomFloatingButtonState createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 1.0, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 0.75, curve: _curve)));
    super.initState();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'btnAdd',
        onPressed: null,
        tooltip: 'Add',
        child: Icon(Icons.text_fields),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'btnImage',
        onPressed: null,
        tooltip: 'Image',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'btnInbox',
        onPressed: null,
        tooltip: 'Inbox',
        child: Icon(Icons.mic),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        elevation: 6,
        heroTag: 'btnToggle',
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}
