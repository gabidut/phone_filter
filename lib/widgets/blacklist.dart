import 'package:call_filter/helpers/config.dart';
import 'package:call_filter/widgets/blacklistadd/addToBlacklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class BlacklistWidget extends StatefulWidget {
  const BlacklistWidget({super.key});

  @override
  _BlacklistWidget createState() => _BlacklistWidget();
}

class _BlacklistWidget extends State<BlacklistWidget> {
  final _key = GlobalKey<ExpandableFabState>();
  bool running = true;

  late Widget _blacklistWidget = const Center(
    child: Text('Loading...'),
  );

  @override
  void initState() {
    if (!running) {
      print('not running');
      return;
    }
    getConfig().then((config) {
      setState(() {
        List<ListTile> _blacklist = [];

        config.blacklist.forEach((element) {
          PopupMenuItem item;
          if (element.isEnable) {
            item = PopupMenuItem(
              value: 3,
              child: Row(
                children: const [
                  Icon(Icons.highlight_off),
                  SizedBox(width: 10),
                  Text('Désactiver'),
                ],
              ),
            );
          } else {
            item = PopupMenuItem(
              value: 4,
              child: Row(
                children: const [
                  Icon(Icons.check_circle),
                  SizedBox(width: 10),
                  Text('Activer'),
                ],
              ),
            );
          }
          _blacklist.add(
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: !element.isEnable ? [Colors.red, Colors.white] : [Colors.grey, Colors.white],
                  ),
                ),
                child: ListTile(
                  title: Text(element.value + (element.isEnable ? '' : ' (désactivé)'), style: TextStyle(color: !element.isEnable ? Colors.white : Colors.black)),
                ),
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    config.blacklist.remove(element);
                    config.saveConfig();
                    setState(() {});
                  } else if (value == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddToBlacklistWidget(
                          val: element.value,
                        ),
                      ),
                    );
                  } else if (value == 3) {
                    element.isEnable = false;
                    config.saveConfig();
                    setState(() {});
                  } else if (value == 4) {
                    element.isEnable = true;
                    config.saveConfig();
                    setState(() {});
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  item
                ],
              ),
            ),
          );
        });

        _blacklistWidget = _blacklist.isNotEmpty
            ? ListView(
                children: _blacklist,
              )
            : const Center(
                child: Text('Votre liste noire est vide ! '),
              );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initState();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste noire'),
      ),
      body: Center(
        child: _blacklistWidget,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 70.0,
        openButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
        ),
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.filter_alt_off),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddToBlacklistWidget(),
                ),
              );
            },
            label: const Text('Ajouter sur liste noire'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.playlist_add_check),
            onPressed: () {},
            label: const Text('Ajouter une exception'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.keyboard_alt),
            onPressed: () {},
            label: const Text('       Ajouter un prefixe'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print("dispose blacklist");
    running = false;
    super.dispose();

    // animationController.dispose() instead of your controller.dispose
  }
}
