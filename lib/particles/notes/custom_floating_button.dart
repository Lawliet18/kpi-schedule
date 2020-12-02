import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_kpi/particles/notes/image_picker.dart';
import 'package:schedule_kpi/particles/notes/voice_recoder.dart';
import 'package:schedule_kpi/save_data/notifier.dart';

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

  Widget add(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'text',
        onPressed: () =>
            Provider.of<Notifier>(context, listen: false).addTextField(),
        tooltip: 'text',
        child: Icon(Icons.text_fields),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        elevation: 0,
        heroTag: 'btnImage',
        onPressed: () =>
            CustomImagePicker.imagePicker.onImageButtonPressed(context),
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
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VoiceRecorder())),
        tooltip: 'Microphone',
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
          child: add(context),
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
