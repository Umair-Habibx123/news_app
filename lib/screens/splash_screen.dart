import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:news_app/screens/Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showProgressIndicator = false;
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;
  late AnimationController _gradientController;
  late Animation<Color?> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOutCubic,
    );

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF4A148C),
      end: const Color(0xFF2A5298),
    ).animate(_gradientController);

    // Start animations
    _logoController.forward();
    _gradientController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showProgressIndicator = true;
        _textController.forward();
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 800),
            child: const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  _gradientAnimation.value ??
                      const Color(0xFF561EBE), // Vibrant purple
                  isDarkMode
                      ? const Color(0xFF0F2027)
                      : const Color(0xFF2575FC), // Dark teal or bright blue
                ],
                stops: const [0.1, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Image.asset(
                      'assets/images/news_app_logo.png',
                      width: width * 0.4,
                      height: height * 0.4,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.newspaper_rounded,
                          size: width * 0.4,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _textAnimation,
                    child: Text(
                      "Stay Informed, Stay Ahead",
                      style: GoogleFonts.poppins(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.95),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  if (_showProgressIndicator)
                    SpinKitThreeBounce(
                      color: Colors.white.withOpacity(0.8),
                      size: width * 0.1,
                    ),
                ],
              ),
            ),
            // Glow effect
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.5,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
