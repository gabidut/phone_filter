
import 'dart:convert';
import 'dart:io';

import 'package:call_filter/helpers/blacklist.dart';
import 'package:path_provider/path_provider.dart';

import 'intercept.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}
Future<File> writeFile(String fileToSave, String value) async {
  var path = await _localPath;
  final file = File('$path/$fileToSave.phonefilter');
  return file.writeAsString(value);
}

Future<String> readFile(String fileToRead) async {
  try {
    var path = await _localPath;
    final file = File('$path/$fileToRead.phonefilter');
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return "";
  }
}

Future<bool> isConfigExists(String fileToRead) async {
  try {
    var path = await _localPath;
    final file = File('$path/$fileToRead.phonefilter');
    return file.exists();
  } catch (e) {
    return false;
  }
}

Future<Config> getConfig() async {
  var config = jsonDecode(await readFile('config'));
  // convert list<dynamic> to list<String>
  config['blacklist'] = List<BlacklistEntry>.from(config['blacklist'].map((x) => BlacklistEntry.fromJson(x)));
  config['whitelist'] = List<String>.from(config['whitelist']);
  config['intercepts'] = List<Intercept>.from(config['intercepts'].map((x) => Intercept.fromJson(x)));
  return Config(
    config['blacklist'],
    config['whitelist'],
    config['isEnabled'],
    config['intercepts'],
  );
}

class Config {
  List<BlacklistEntry> blacklist = <BlacklistEntry>[];
  List<String> whitelist = <String>[];
  bool isEnabled = false;
  List<Intercept> intercepts = <Intercept>[];

  Config(this.blacklist, this.whitelist, this.isEnabled, this.intercepts);

  getBlacklist() {
    return this.blacklist;
  }

  getWhitelist() {
    return this.whitelist;
  }

  getIsEnabled() {
    return this.isEnabled;
  }

  getIntercepts() {
    return this.intercepts;
  }

  setBlacklist(List<BlacklistEntry> blacklist) {
    this.blacklist = blacklist;
  }

  setWhitelist(List<String> whitelist) {
    this.whitelist = whitelist;
  }

  setIsEnabled(bool isEnabled) {
    this.isEnabled = isEnabled;
  }

  setIntercepts(List<Intercept> intercepts) {
    this.intercepts = intercepts;
  }

  addBlacklist(BlacklistEntry number) {
    blacklist.add(number);
  }

  addWhitelist(String number) {
    whitelist.add(number);
  }

  addIntercept(Intercept intercept) {
    intercepts.add(intercept);
  }

  saveConfig() {
    print(blacklist.map((e) => e.toJson()));
    String config = jsonEncode({
      'blacklist': blacklist.map((e) => e.toJson()).toList(),
      'whitelist': whitelist,
      'isEnabled': isEnabled,
      'intercepts': intercepts.map((e) => e.toJson()).toList(),
    });
    print(config);
    writeFile('config', config);
  }

  factory Config.createConfig() {
    Config(<BlacklistEntry>[], <String>[], false, <Intercept>[]).saveConfig();
    return Config(<BlacklistEntry>[], <String>[], false, <Intercept>[]);
  }


  @override
  String toString() {
    return 'Config{blacklist: $blacklist, whitelist: $whitelist, isEnabled: $isEnabled, intercepts: $intercepts}';
  }
}