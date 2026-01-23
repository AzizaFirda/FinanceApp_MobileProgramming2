import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _logoRotateAnimation;

  @override
  void initState() {
    super.initState();

    // Main Animation Controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );

    // Particle Animation Controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();

    // Shimmer Animation Controller
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    // Pulse Animation Controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    // Continuous Rotation Controller
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 20000),
      vsync: this,
    )..repeat();

    // Logo Scale Animation with Bounce
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    // Logo Initial Rotation
    _rotateAnimation = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    // Continuous Logo Rotation
    _logoRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    // Glow Effect
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.2, 0.75, curve: Curves.easeIn),
      ),
    );

    // Fade Animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.35, 0.85, curve: Curves.easeInOut),
      ),
    );

    // Text Fade with Delay
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Slide Animation
    _slideAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Shimmer Animation
    _shimmerAnimation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _mainController.forward();

    // Navigate to login after animation completes (3 seconds)
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 ELEGANT GRADIENT BACKGROUND
          _buildAnimatedBackground(),

          // ✨ FLOATING PARTICLES
          _buildFloatingParticles(),

          // 📱 MAIN CONTENT - ALL CENTERED
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  // 💎 LOGO WITH ADVANCED ANIMATIONS
                  _buildAnimatedLogo(),

                  const SizedBox(height: 55),

                  // 📱 APP NAME WITH CUSTOM FONT
                  _buildAppName(),

                  const SizedBox(height: 16),

                  // 📝 TAGLINE
                  _buildTagline(),

                  const SizedBox(height: 80),

                  // 💫 ELEGANT LOADING INDICATOR
                  _buildLoadingIndicator(),

                  const SizedBox(height: 80),

                  // 👤 CREATOR CREDIT
                  _buildCreatorCredit(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🎨 ELEGANT GRADIENT BACKGROUND
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2C3E35), // Dark Forest Green
                Color(0xFF3A4F47), // Deep Emerald Grey
                Color(0xFF4A5C54), // Sage Green Grey
                Color(0xFF5D6B63), // Slate Grey
                Color(0xFF8B7E74), // Warm Taupe
                Color(0xFFA69785), // Soft Brown
                Color(0xFFD4CFC9), // Warm Cream
                Color(0xFFEFEBE7), // Soft White
              ],
              stops: [0.0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.88, 1.0],
            ),
          ),
        );
      },
    );
  }

  // ✨ FLOATING PARTICLES EFFECT
  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(_particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  // 💎 ANIMATED LOGO - CENTERED
  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Animated Glow Ring
                AnimatedBuilder(
                  animation: _logoRotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _logoRotateAnimation.value,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 260 + (_pulseController.value * 25),
                            height: 260 + (_pulseController.value * 25),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  Color(
                                    0xFF50C878,
                                  ).withOpacity(0.2 * _glowAnimation.value),
                                  Color(
                                    0xFF3EB489,
                                  ).withOpacity(0.3 * _glowAnimation.value),
                                  Color(
                                    0xFF2E8B57,
                                  ).withOpacity(0.2 * _glowAnimation.value),
                                  Color(
                                    0xFF50C878,
                                  ).withOpacity(0.2 * _glowAnimation.value),
                                ],
                                stops: [0.0, 0.3, 0.7, 1.0],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // Middle Glow Ring
                Container(
                  width: 235,
                  height: 235,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(
                          0xFF50C878,
                        ).withOpacity(0.35 * _glowAnimation.value),
                        blurRadius: 60,
                        spreadRadius: 15,
                      ),
                      BoxShadow(
                        color: Color(
                          0xFF8B7E74,
                        ).withOpacity(0.25 * _glowAnimation.value),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),

                // Decorative Ring
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF50C878).withOpacity(0.3),
                        Color(0xFF2E8B57).withOpacity(0.2),
                      ],
                    ),
                  ),
                ),

                // Main Logo Container
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF5F5F5), Color(0xFFE8E8E8)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2E8B57).withOpacity(0.5),
                        blurRadius: 35,
                        offset: Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 25,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      children: [
                        // Background Gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF50C878), // Emerald
                                Color(0xFF3EB489), // Sea Green
                                Color(0xFF2E8B57), // Sea Green Dark
                                Color(0xFF1F6F4A), // Forest Green
                              ],
                            ),
                          ),
                        ),

                        // Image or Fallback Icon
                        Image.asset(
                          'assets/images/splash/splash_img.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildFallbackIcon();
                          },
                        ),

                        // Shine Effect Overlay
                        AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Positioned.fill(
                              child: CustomPaint(
                                painter: ShinePainter(_shimmerAnimation.value),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 📱 APP NAME WITH ELEGANT FONT - CENTERED
  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Column(
            children: [
              // Main Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFF2E8B57), // Sea Green
                    Color(0xFF50C878), // Emerald
                    Color(0xFF3EB489), // Light Emerald
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  'CuanKu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                    height: 1.2,
                    fontFamily: 'serif',
                    shadows: [
                      Shadow(
                        blurRadius: 25.0,
                        color: Color(0xFF2E8B57).withOpacity(0.5),
                        offset: Offset(0, 6),
                      ),
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),

              // Decorative Line
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 180,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF50C878).withOpacity(0.7),
                      Color(0xFF2E8B57).withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 📝 TAGLINE - CENTERED
  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _textFadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF50C878).withOpacity(0.15),
                    Color(0xFF8B7E74).withOpacity(0.12),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFF50C878).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2E8B57).withOpacity(0.15),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Personal Finance Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2C3E35),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 💫 LOADING INDICATOR - CENTERED
  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ring
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF8B7E74).withOpacity(0.4),
                  ),
                  strokeWidth: 2,
                ),
              ),
              // Middle Ring
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF50C878).withOpacity(0.5),
                  ),
                  strokeWidth: 2.5,
                ),
              ),
              // Main Ring
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E8B57)),
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 👤 CREATOR CREDIT - CENTERED
  Widget _buildCreatorCredit() {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _textFadeAnimation.value,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD4CFC9).withOpacity(0.85),
                        Color(0xFFA69785).withOpacity(0.75),
                        Color(0xFFB8AFA4).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Color(0xFF50C878).withOpacity(0.35),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2E8B57).withOpacity(0.25),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF50C878), Color(0xFF2E8B57)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Created by Aziza Firdaus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C3E35),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF2C3E35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF50C878).withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Version 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A5C54),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🎯 FALLBACK ICON
  Widget _buildFallbackIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF50C878),
            Color(0xFF3EB489),
            Color(0xFF2E8B57),
            Color(0xFF1F6F4A),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.account_balance_wallet_rounded,
          size: 110,
          color: Colors.white,
        ),
      ),
    );
  }
}

// 🎨 PARTICLE PAINTER FOR FLOATING EFFECT
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 35; i++) {
      final progress = (animationValue + (i * 0.08)) % 1.0;
      final x = (size.width * 0.15) + (i % 6) * (size.width * 0.17);
      final y = size.height * progress;
      final opacity = (1 - progress) * 0.5;
      final size_particle = 2.5 + (i % 4) * 1.8;

      paint.color = [
        Color(0xFF50C878), // Emerald
        Color(0xFF3EB489), // Sea Green
        Color(0xFF8B7E74), // Soft Brown
        Color(0xFFA69785), // Taupe
      ][i % 4].withOpacity(opacity);

      canvas.drawCircle(
        Offset(x + math.sin(progress * 2 * math.pi) * 40, y),
        size_particle,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// ✨ SHINE PAINTER FOR SHIMMER EFFECT
class ShinePainter extends CustomPainter {
  final double progress;

  ShinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.4),
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: [
          math.max(0.0, progress - 0.4),
          math.max(0.0, progress - 0.2),
          progress,
          math.min(1.0, progress + 0.2),
          math.min(1.0, progress + 0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShinePainter oldDelegate) => true;
}
