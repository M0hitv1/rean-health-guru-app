import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:patient/infra/networking/awards_api_provider.dart';
import 'package:patient/infra/networking/chat_api_provider.dart';
import 'package:patient/infra/provider_setup.dart';
import 'package:patient/infra/router.dart';
import 'package:patient/infra/utils/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/route_paths.dart';
import 'infra/networking/api_provider.dart';

Future<void> main() async {
  //enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await dotenv.load(fileName: 'res/.env');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login1.8.167');
  login ??= false;
  String? sponsor = prefs.getString('Sponsor');
  setSponsor(sponsor??'');
  runApp(MyApp(login));
}
//ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? isLogin;
  String? _baseUrl;
  String? _botBaseUrl;
  String? _awardBaseUrl;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  MyApp(bool isLogin) {
    debugPrint('Print from .env ==> ${dotenv.env['DEV_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['DEV_BOT_BASE_URL']}');
    debugPrint('Print from .env ==> ${dotenv.env['AWARD_BASE_URL']}');
    _baseUrl = dotenv.env['DEV_BASE_URL'];
    _botBaseUrl = dotenv.env['DEV_BOT_BASE_URL'];
    _awardBaseUrl = dotenv.env['AWARD_BASE_URL'];
    this.isLogin = isLogin;
    setSessionFlag(isLogin);
    setBaseUrl(_baseUrl);
    setAppName('REAN HealthGuru');
    setAppFlavour('RHG-Dev');
    GetIt.instance.registerSingleton<ApiProvider>(ApiProvider(_baseUrl));
    GetIt.instance
        .registerSingleton<ChatApiProvider>(ChatApiProvider(_botBaseUrl));
    GetIt.instance
        .registerSingleton<AwardApiProvider>(AwardApiProvider(_awardBaseUrl));
    debugPrint('MyApp Constructor >> Login Session: $isLogin');
  }


  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp >> Login Session: $isLogin');
    debugPrint('ApiProvider >> Base URL: $_baseUrl');
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'REAN HealthGuru',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.deepPurple, fontFamily: 'Montserrat'),
        //https://github.com/FilledStacks/flutter-tutorials/blob/master/014-provider-v3-updates/2-final/pubspec.yaml
        //initialRoute: RoutePaths.Login,
        initialRoute: RoutePaths.Splash_Screen,
        /*home: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: AfterSplashScreen(isLogin),
            title: new Text('REAN Care\n\nDev-Build' , style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white)),
            image: new Image.asset('res/images/app_logo_transparent.png'),
            backgroundColor: primaryColor,
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
            loaderColor: Colors.transparent,
            baseUrl: _baseUrl,
        ),*/
        onGenerateRoute: Routers.generateRoute,
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }

  loadSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool('login');
  }
}
