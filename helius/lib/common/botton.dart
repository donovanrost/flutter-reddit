import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final Color color;
  final double size;
  final bool animate;

  Button(
      {@required this.onTap,
      this.iconData,
      this.color,
      this.size,
      this.animate = true});

  @override
  _ButtonState createState() => _ButtonState(
      this.onTap, this.iconData, this.color, this.size, this.animate);
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  final onTap;
  final iconData;
  final color;
  final size;
  final animate;
  _ButtonState(this.onTap, this.iconData, this.color, this.size, this.animate);
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: size).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ButtonContainer(
        animation: _animation,
        controller: _controller,
        onTap: onTap,
        color: color,
        iconData: iconData,
        size: size,
        animate: this.animate);
  }
}

class ButtonContainer extends AnimatedWidget {
  const ButtonContainer(
      {Key key,
      Animation animation,
      this.controller,
      this.onTap,
      this.iconData,
      this.color,
      this.size,
      this.animate})
      : super(key: key, listenable: animation);

  // Animation<double> get _progress => listenable;
  final AnimationController controller;
  final VoidCallback onTap;
  final IconData iconData;
  final Color color;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;

    return Center(
        child: GestureDetector(
            onTap: () {
              if (animation.isCompleted || animation.isDismissed) this.onTap();

              if (animate)
                animation.isCompleted
                    ? controller.reverse()
                    : controller.forward();
            },
            child: Stack(alignment: Alignment.center, children: [
              _baseContainer(animation),
              _animatedContainer(animation)
            ])));
  }

  _animatedContainer(animation) {
    return Container(
      height: (animation.value < 0) ? 0 : animation.value,
      width: (animation.value < 0) ? 0 : animation.value,
      decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: (animation.value > 20)
          ? Icon(
              this.iconData,
              //     ? CupertinoColors.white
              color: CupertinoColors.white,
            )
          : null,
    );
  }

  _baseContainer(animation) {
    return Container(
      height: size, //(animation.value < 0) ? 0 : animation.value,
      width: size, //(animation.value < 0) ? 0 : animation.value,
      child: Icon(
        this.iconData,
        color: CupertinoColors.activeBlue,
      ),
    );
  }
}
