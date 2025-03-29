import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/screens/Home/widgets/no_internet_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:news_app/services/NewsProviderApi.dart';
import 'package:news_app/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProviderApi()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        return GetMaterialApp(
          title: 'News App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home:
              connectivityService.hasInternet
                  ? const SplashScreen()
                  : NoInternetScreen(
                    onRetry: connectivityService.retryConnection,
                  ),
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                if (!connectivityService.hasInternet)
                  NoInternetScreen(
                    onRetry: connectivityService.retryConnection,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
