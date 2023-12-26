import 'package:call_filter/helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidget createState() => _HomeWidget();
}

class _HomeWidget extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _barColor;
  late Animation<Decoration?> _decorationColor;
  final List<bool> _selectedIndex = <bool>[true, false];
  var _selectedEnable = 0;
  String image = 'assets/images/shield_ok.png';
  String text = 'Votre protection est activée.';

  List<Widget> _activesStats = <Widget>[
  ];

  Future<void> loadSettings() async {
    getConfig().then((value) => {
          setState(() {
            _selectedEnable = value.getIsEnabled() == true ? 1 : 0;
            _selectedIndex[0] = value.getIsEnabled() == true ? false : true;
            _selectedIndex[1] = value.getIsEnabled() == true ? true : false;
            image = value.getIsEnabled() == true
                ? 'assets/images/shield_ok.png'
                : 'assets/images/shield_error.png';

            _changeColor();
          })
        });
  }

  @override
  void initState() {
    super.initState();

    print("sep1");
    loadSettings();

    getConfig().then((value) => {
          setState(() {
            _activesStats = <Widget>[
              ListTile(
                title: Text( "${value.blacklist.length} Numéros sur la liste noire"),
                leading: Icon(Icons.block),
                tileColor: Color.fromARGB(50, 50, 50, 1),
              ),
              ListTile(
                title: Text( "${value.whitelist.length} Numéros sur la liste blanche"),
                leading: Icon(Icons.check_circle),
                tileColor: Color.fromARGB(50, 50, 50, 1),
              ),
              ListTile(
                title: Text( "${value.intercepts.length} Appels bloqués"),
                leading: Icon(Icons.call_missed_outgoing),
                tileColor: Color.fromARGB(50, 50, 50, 1),
              ),
            ];
          })
        });

    // Initialisez le contrôleur d'animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialisez l'animation de couleur
    _barColor = ColorTween(
      begin: Colors.red,
      end: Colors.green,
    ).animate(_controller);

    _decorationColor = DecorationTween(
      begin: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.red, Colors.white],
          stops: [0.4, 0.7],
        ),
      ),
      end: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green, Colors.white],
          stops: [0.4, 0.7],
        ),
      ),
    ).animate(_controller);
  }

  void _changeColor() {
    setState(() {
      if (_selectedEnable == 0) {
        image = 'assets/images/shield_ok.png';
        _controller.forward();
      } else {
        image = 'assets/images/shield_error.png';
        _controller.reverse();
      }
      text = _selectedEnable == 0
          ? 'Votre protection est activée.'
          : 'Votre protection est désactivée.';
    });
    // _controller.isDismissed ? _controller.forward() : _controller.reverse();
    print(_selectedEnable);
  }

  @override
  Widget build(BuildContext context) {
    print("sep2");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: GestureDetector(
          onTap: () {
            _changeColor();
          },
          child: AnimatedBuilder(
            animation: _barColor,
            builder: (context, child) => AppBar(
              title:
                  const Text('Accueil', style: TextStyle(color: Colors.white)),
              backgroundColor: _barColor.value,
            ),
          ),
        ),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _decorationColor,
          builder: (context, child) => AnimatedContainer(
            duration: const Duration(microseconds: 500),
            decoration: _decorationColor.value,
            // Ajoutez un child avec plus d'un enfant
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(image),
                  width: 200,
                  height: 200,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        if (_selectedEnable != index) {
                          _selectedEnable = index;
                          _changeColor();
                          getConfig().then((value) => {
                                value.setIsEnabled(
                                    _selectedEnable == 1 ? true : false),
                                value.saveConfig()
                              });

                          for (int buttonIndex = 0;
                              buttonIndex < _selectedIndex.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              _selectedIndex[buttonIndex] = true;
                            } else {
                              _selectedIndex[buttonIndex] = false;
                            }
                          }
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor:
                        _selectedEnable == 1 ? Colors.red : Colors.green,
                    selectedColor: Colors.white,
                    fillColor: _selectedEnable == 1 ? Colors.red : Colors.green,
                    color: Colors.white,
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedIndex,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Activer'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Désactiver'),
                      ),
                    ]),
                const SizedBox(height: 80),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    children: _activesStats,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
