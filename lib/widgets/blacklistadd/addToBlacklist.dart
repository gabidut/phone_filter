import 'package:call_filter/helpers/blacklist.dart';
import 'package:call_filter/helpers/config.dart';
import 'package:flutter/material.dart';
String value = "";
class AddToBlacklistWidget extends StatefulWidget {
  final String val;

  const AddToBlacklistWidget({super.key, this.val = ''});


  @override
  _AddToBlacklistWidget createState() {
    value = val;
    return _AddToBlacklistWidget();
  }
}

class _AddToBlacklistWidget extends State<AddToBlacklistWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(value == '' ? 'Ajouter sur liste noire' : 'Modifier liste noire'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Numéro de téléphone (ex: 0123456789)'),
              SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Entrez un numéro de téléphone',
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                  onPressed: () {
                    getConfig().then((config) {
                      if(controller.value.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez entrer un numéro de téléphone'),
                          ),
                        );
                        return;
                      }
                      if(controller.value.text.length < 10 || controller.value.text.length > 13 || !RegExp(r'^[0-9]+$').hasMatch(controller.value.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez entrer un numéro de téléphone valide'),
                          ),
                        );
                        return;
                      }
                      for (BlacklistEntry numero in config.blacklist) {
                        if (numero.value == controller.value.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ce numéro est déjà sur la liste noire'),
                            ),
                          );
                          return;
                        }
                      }
                      if(value =='') {
                        config.blacklist.add(BlacklistEntry(controller.value.text, BlacklistType.BLACKLIST, true));
                      } else {
                        BlacklistEntry entry = config.blacklist.firstWhere((element) => element.value == value);
                        config.blacklist.removeWhere((element) => entry.value == value);
                        config.blacklist.add(BlacklistEntry(controller.value.text, BlacklistType.BLACKLIST, entry.isEnable));
                      }
                      config.saveConfig();
                      Navigator.pop(context);
                    });
                  },
                  child: Text(value == '' ? 'Ajouter' : 'Modifier')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
