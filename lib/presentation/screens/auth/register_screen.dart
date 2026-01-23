import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatController;
  late AnimationController _shimmerController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Logout first to clear session, so user needs to login manually
      await authProvider.logout();
      
      if (!mounted) return;
      
      // Navigate to login screen instead of main
      Navigator.of(context).pushReplacementNamed('/login');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Account created! Please login with your credentials.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF50C878),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  authProvider.errorMessage ?? 'Registration failed',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF2C3E35),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Floating Particles
          _buildFloatingParticles(),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildRegisterCard(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
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
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlesPainter(_floatAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      constraints: BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: Color(0xFFEFEBE7).withOpacity(0.98),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2C3E35).withOpacity(0.3),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: Color(0xFF50C878).withOpacity(0.1),
            blurRadius: 60,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Shimmer Effect
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Positioned.fill(
                  child: CustomPaint(
                    painter: _ShimmerPainter(_shimmerController.value),
                  ),
                );
              },
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo with Glow
                    _buildLogo(),

                    SizedBox(height: 32),

                    // Title
                    _buildTitle(),

                    SizedBox(height: 40),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Aziza Firda',
                      icon: Icons.person_outline_rounded,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'your.email@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Confirm Password Field
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      onToggle: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 32),

                    // Register Button
                    _buildRegisterButton(),

                    SizedBox(height: 32),

                    // Divider
                    _buildDivider(),

                    SizedBox(height: 32),

                    // Sign In Link
                    _buildSignInLink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/splash/splash_img.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C3E35),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Start managing your finances',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF5D6B63),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      style: TextStyle(
        color: Color(0xFF2C3E35),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Color(0xFF5D6B63),
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF8B7E74).withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 12),
          child: Icon(icon, color: Color(0xFF50C878), size: 22),
        ),
        filled: true,
        fillColor: Color(0xFFD4CFC9).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFD4CFC9), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF50C878), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8B7E74), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8B7E74), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Color(0xFF2C3E35),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: '••••••••',
        labelStyle: TextStyle(
          color: Color(0xFF5D6B63),
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF8B7E74).withOpacity(0.5),
          fontSize: 18,
          letterSpacing: 2,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.only(right: 12),
          child: Icon(Icons.lock_outline, color: Color(0xFF50C878), size: 22),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Color(0xFF5D6B63),
            size: 22,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Color(0xFFD4CFC9).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFD4CFC9), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF50C878), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8B7E74), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8B7E74), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      validator: validator,
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF50C878), Color(0xFF3EB489), Color(0xFF2E8B57)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF50C878).withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: authProvider.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFF8B7E74).withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF5D6B63),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8B7E74).withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: Color(0xFF5D6B63),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFF2E8B57),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// Particles Painter
class _ParticlesPainter extends CustomPainter {
  final double animationValue;

  _ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i % 5) * (size.width / 4) + animationValue;
      final y =
          (i ~/ 5) * (size.height / 4) + math.sin(animationValue / 5 + i) * 30;
      final opacity = 0.1 + (math.sin(animationValue / 10 + i) * 0.05);

      paint.color = Color(0xFF50C878).withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}

// Shimmer Painter
class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Color(0xFF50C878).withOpacity(0.05),
          Color(0xFFEFEBE7).withOpacity(0.1),
          Color(0xFF50C878).withOpacity(0.05),
          Colors.transparent,
        ],
        stops: [
          math.max(0.0, progress - 0.3),
          math.max(0.0, progress - 0.1),
          progress,
          math.min(1.0, progress + 0.1),
          math.min(1.0, progress + 0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) => true;
}
