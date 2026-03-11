import 'package:re_highlight/languages/java.dart';
import 'package:re_highlight/languages/javascript.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/languages/kotlin.dart';
import 'package:re_highlight/languages/python.dart';
import 'package:re_highlight/languages/smali.dart';
import 'package:re_highlight/re_highlight.dart';

class AppCodeEditorStyle {
  static Mode? getLangMode(String lang) {
    switch (lang.toLowerCase()) {
      case 'javascript':
      case 'js':
        return langJavascript;
      case 'java':
        return langJava;
      case 'kotlin':
      case 'kt':
        return langKotlin;
      case 'python':
      case 'py':
        return langPython;
      case 'json':
        return langJson;
      case 'smali':
        return langSmali;
      default:
        return null;
    }
  }
}
