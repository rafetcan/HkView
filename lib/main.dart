/*
  www.RafetHokka.com
  HkView Alpha Sürümü

  Bu Uygulamayı sorunsuz kullanabilmeniz için web sitenizi mobil uyumlu (responsive) olması gerekmektedir.


  Açılış Ekranında görünmesini istediğiniz dosyanın ismini splash.png yapıp assets klasörü içerisine atmanız gerekiyor. //! BURADA RESİM EKLENMEDİĞİ ZAMAN VERECEĞİ HATAYI AYIKLAMAMIZ LAZM TRY CATCH KULLANILABİLİR.
  assets/splash.png
 */

import 'package:flutter/material.dart';
import 'package:hkview/Screens/Home.dart';
import 'package:hkview/Screens/SplashScreen.dart';
import 'package:hkview/data.dart';
import 'package:hkview/Widgets/widgets.dart';

void main() => runApp(
      MaterialApp(
        title: appTitle,
        home: splashVisible ? SplashScreen() : WebViewExample(),
        theme: appBarThemeDataWidget(),
        debugShowCheckedModeBanner: false,
      ),
    );
