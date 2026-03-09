// lib/screens/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:news_app/screens/Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showLoader = false;
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late AnimationController _gradientController;
  late Animation<Color?> _gradientColor;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _gradientColor = ColorTween(
      begin: const Color(0xFF4A148C),
      end: const Color(0xFF311B92),
    ).animate(_gradientController);

    _gradientController.repeat(reverse: true);
  }

  void _startSequence() {
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
        setState(() => _showLoader = true);
      }
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 600),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _gradientColor.value ?? const Color(0xFF4A148C),
                const Color(0xFF6C63FF),
                const Color(0xFF2575FC),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: size.width * 0.28,
                    height: size.width * 0.28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/news_app_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.newspaper_rounded,
                        size: size.width * 0.15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      Text(
                        'News App',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stay Informed, Stay Ahead',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.038,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                if (_showLoader)
                  SpinKitThreeBounce(
                    color: Colors.white.withOpacity(0.9),
                    size: size.width * 0.07,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}