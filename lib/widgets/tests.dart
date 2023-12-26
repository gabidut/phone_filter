import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    // Initialisez le contrôleur d'animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Durée de la transition
    );

    // Initialisez l'animation de couleur
    _colorTween = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_controller);
  }

  // Fonction pour changer la couleur avec transition
  void _changeColor() {
    // Inversez la direction de l'animation si elle est en cours
    _controller.isDismissed
        ? _controller.forward()
        : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: GestureDetector(
          onTap: () {
            _changeColor();
          },
          child: AnimatedBuilder(
            animation: _colorTween,
            builder: (context, child) => AppBar(
              title: Text('Color Changer with Transition'),
              backgroundColor: _colorTween.value,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Contenu de l\'écran'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // N'oubliez pas de disposer du contrôleur d'animation
    super.dispose();
  }
}
