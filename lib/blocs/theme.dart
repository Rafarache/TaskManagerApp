import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // .obs torna a propriedade reativa, para interagir na view
  var isDark = false.obs;
  Map<String, ThemeMode> themeModes = {
    'light': ThemeMode.light,
    'dark': ThemeMode.dark
  };

  SharedPreferences prefs; // variável que irá salvar as instâncias do shared

  //recuperar a instancia do ThemeController
  static ThemeController get to => Get.find();

  loadThemeMode() async {
    //recuperar a instancia do SharedPreferences
    prefs = await SharedPreferences.getInstance();
    String themeText = prefs.getString('theme') ?? 'light';
    isDark.value = themeText == 'dark' ? true : false;
    setMode(themeText);
  }

  Future setMode(String themeText) async {
    //recuperar um themeMode
    ThemeMode themeMode = themeModes[themeText];
    //Get.changeTheme(theme) altera o tema
    Get.changeThemeMode(themeMode); // altera o modo, dark ou light
    //Gravar a opcao do usuário
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeText);
  }

  //Função do botao
  changeTheme() {
    setMode(isDark.value ? 'ligth' : 'dark');
    isDark.value = !isDark.value;
  }
}
