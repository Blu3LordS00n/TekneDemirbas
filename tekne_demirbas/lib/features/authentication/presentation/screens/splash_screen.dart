import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _boatController;
  late AnimationController _waveController;
  late Animation<double> _boatAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Tekne animasyonu - yatay hareket
    _boatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _boatAnimation = Tween<double>(begin: -0.2, end: 1.2)
        .animate(CurvedAnimation(
      parent: _boatController,
      curve: Curves.easeInOut,
    ));

    // Dalga animasyonu - sürekli hareket
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.linear,
      ),
    );

    // Animasyonları başlat
    _boatController.forward();

    // 2.5 saniye sonra yönlendirme yap
    Timer(const Duration(milliseconds: 2500), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() {
    final firebaseAuth = FirebaseAuth.instance;
    final isLoggedIn = firebaseAuth.currentUser != null;
    final isEmailVerified = firebaseAuth.currentUser?.emailVerified ?? false;

    if (mounted) {
      if (isLoggedIn && isEmailVerified) {
        context.go('/roomSelection');
      } else {
        context.go('/signIn');
      }
    }
  }

  @override
  void dispose() {
    _boatController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: Appstyles.oceanGradient,
        ),
        child: Stack(
          children: [
            // Dalga animasyonu
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(_waveAnimation.value),
                  );
                },
              ),
            ),

            // Tekne animasyonu
            AnimatedBuilder(
              animation: Listenable.merge([_boatAnimation, _waveAnimation]),
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                final screenHeight = MediaQuery.of(context).size.height;
                final boatX = screenWidth * _boatAnimation.value;
                final boatY = screenHeight * 0.6;
                
                // Dalga animasyonuna göre tekneyi hafifçe yukarı aşağı hareket ettir
                final waveOffset = 5 * math.sin(_waveAnimation.value * 2 * math.pi);

                return Positioned(
                  left: boatX,
                  top: boatY + waveOffset,
                  child: Transform.rotate(
                    angle: 0.05 * math.sin(_waveAnimation.value * 2 * math.pi),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.sailing,
                        size: 50,
                        color: Appstyles.primaryBlue,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Logo ve başlık
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: Appstyles.strongShadow,
                    ),
                    child: const Icon(
                      Icons.sailing,
                      size: 64,
                      color: Appstyles.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tekne Demirbas',
                    style: Appstyles.headingTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: SizeConfig.getProportionateHeight(28),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dalga çizimi için CustomPainter
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 2;

    // İlk dalga
    path.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.7 +
          waveHeight *
              math.sin((x / waveLength + animationValue * 2 * math.pi) * 2 * math.pi);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // İkinci dalga (daha küçük)
    final path2 = Path();
    path2.moveTo(0, size.height * 0.75);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.75 +
          waveHeight *
              0.6 *
              math.sin((x / waveLength * 1.5 - animationValue * 2 * math.pi) * 2 * math.pi);
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
