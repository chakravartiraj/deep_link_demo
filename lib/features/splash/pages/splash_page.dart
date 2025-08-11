import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../core/utils/responsive_utils.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback? onComplete;

  const SplashPage({super.key, this.onComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _spinnerController;
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _fadeController;

  late Animation<double> _spinnerAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _fadeAnimation;

  int _currentStatusIndex = 0;
  Timer? _statusTimer;

  final List<String> _statusMessages = [
    'Initializing...',
    'Loading Flutter engine...',
    'Preparing widgets...',
    'Almost ready...',
    'Welcome!',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStatusUpdates();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Spinner animations
    _spinnerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _spinnerAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _spinnerController, curve: Curves.linear),
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 0.9).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _particleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    // Fade out animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations
    _spinnerController.repeat();
    _pulseController.repeat(reverse: true);
    _particleController.repeat();
    _progressController.forward();
  }

  void _startStatusUpdates() {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1600), (timer) {
      if (mounted && _currentStatusIndex < _statusMessages.length - 1) {
        setState(() {
          _currentStatusIndex++;
        });
      }
    });
  }

  void _startSplashSequence() {
    // Complete splash after 8 seconds or when progress reaches 100%
    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        _completeSplash();
      }
    });
  }

  void _completeSplash() async {
    _statusTimer?.cancel();
    await _fadeController.forward();
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: 1 + (1 - _fadeAnimation.value) * 0.1,
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Floating particles
                    _buildParticles(),

                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Spinner container with responsive sizing
                          _buildSpinnerContainer(context),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveValue<double>(
                              context,
                              mobile: 25.0,
                              tablet: 30.0,
                              desktop: 35.0,
                            ),
                          ),

                          // Loading text with pulse animation
                          _buildLoadingText(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveValue<double>(
                              context,
                              mobile: 20.0,
                              tablet: 25.0,
                              desktop: 30.0,
                            ),
                          ),

                          // Progress bar with responsive sizing
                          _buildProgressBar(),

                          SizedBox(
                            height: ResponsiveUtils.getResponsiveValue<double>(
                              context,
                              mobile: 12.0,
                              tablet: 15.0,
                              desktop: 18.0,
                            ),
                          ),

                          // Status indicator
                          _buildStatusIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(9, (index) {
            final leftPosition = (index + 1) * 0.1;
            final animationDelay = index * 0.5;

            return Positioned(
              left: MediaQuery.of(context).size.width * leftPosition,
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  final adjustedAnimation =
                      (_particleAnimation.value + animationDelay) % 1.0;
                  final yPosition =
                      MediaQuery.of(context).size.height *
                      (1 - adjustedAnimation);
                  final opacity =
                      adjustedAnimation > 0.1 && adjustedAnimation < 0.9
                      ? 1.0
                      : 0.0;

                  return Transform.translate(
                    offset: Offset(0, yPosition),
                    child: Opacity(
                      opacity: opacity * 0.3,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSpinnerContainer(BuildContext context) {
    final spinnerSize = ResponsiveUtils.getResponsiveValue<double>(
      context,
      mobile: 70.0,
      tablet: 80.0,
      desktop: 90.0,
    );
    final mainSpinnerSize = ResponsiveUtils.getResponsiveValue<double>(
      context,
      mobile: 50.0,
      tablet: 60.0,
      desktop: 70.0,
    );
    final innerSpinnerSize = ResponsiveUtils.getResponsiveValue<double>(
      context,
      mobile: 30.0,
      tablet: 40.0,
      desktop: 50.0,
    );
    final mainSpinnerOffset = ResponsiveUtils.getResponsiveValue<double>(
      context,
      mobile: 10.0,
      tablet: 10.0,
      desktop: 10.0,
    );
    final innerSpinnerOffset = ResponsiveUtils.getResponsiveValue<double>(
      context,
      mobile: 20.0,
      tablet: 20.0,
      desktop: 20.0,
    );

    return SizedBox(
      width: spinnerSize,
      height: spinnerSize,
      child: Stack(
        children: [
          // Outer spinner
          AnimatedBuilder(
            animation: _spinnerController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_spinnerAnimation.value,
                child: Container(
                  width: spinnerSize,
                  height: spinnerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(spinnerSize / 2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: ResponsiveUtils.getResponsiveValue<double>(
                        context,
                        mobile: 1.5,
                        tablet: 2.0,
                        desktop: 2.5,
                      ),
                    ),
                  ),
                  child: CustomPaint(
                    painter: SpinnerPainter(
                      color: Colors.white.withValues(alpha: 0.3),
                      strokeWidth: ResponsiveUtils.getResponsiveValue<double>(
                        context,
                        mobile: 1.5,
                        tablet: 2.0,
                        desktop: 2.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Main spinner
          Positioned(
            top: mainSpinnerOffset,
            left: mainSpinnerOffset,
            child: AnimatedBuilder(
              animation: _spinnerController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinnerAnimation.value,
                  child: Container(
                    width: mainSpinnerSize,
                    height: mainSpinnerSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mainSpinnerSize / 2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: ResponsiveUtils.getResponsiveValue<double>(
                          context,
                          mobile: 2.5,
                          tablet: 3.0,
                          desktop: 3.5,
                        ),
                      ),
                    ),
                    child: CustomPaint(
                      painter: SpinnerPainter(
                        color: Colors.white.withValues(alpha: 0.8),
                        strokeWidth: ResponsiveUtils.getResponsiveValue<double>(
                          context,
                          mobile: 2.5,
                          tablet: 3.0,
                          desktop: 3.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Inner spinner
          Positioned(
            top: innerSpinnerOffset,
            left: innerSpinnerOffset,
            child: AnimatedBuilder(
              animation: _spinnerController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinnerAnimation.value * 1.5,
                  child: Container(
                    width: innerSpinnerSize,
                    height: innerSpinnerSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(innerSpinnerSize / 2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: ResponsiveUtils.getResponsiveValue<double>(
                          context,
                          mobile: 1.5,
                          tablet: 2.0,
                          desktop: 2.5,
                        ),
                      ),
                    ),
                    child: CustomPaint(
                      painter: SpinnerPainter(
                        color: Colors.white.withValues(alpha: 0.5),
                        strokeWidth: ResponsiveUtils.getResponsiveValue<double>(
                          context,
                          mobile: 1.5,
                          tablet: 2.0,
                          desktop: 2.5,
                        ),
                        startAngle: math.pi / 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: Text(
            'Deep Link Demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontFamily: 'Segoe UI',
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: 240,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(2),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Progress fill
              Container(
                width: 240 * _progressAnimation.value,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withValues(alpha: 0.8), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Shimmer effect
              if (_progressAnimation.value > 0)
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        (240 * 2 * _particleAnimation.value) - 240,
                        0,
                      ),
                      child: Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      height: 16,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          _statusMessages[_currentStatusIndex],
          key: ValueKey(_currentStatusIndex),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontFamily: 'Segoe UI',
          ),
        ),
      ),
    );
  }
}

class SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double startAngle;

  SpinnerPainter({
    required this.color,
    required this.strokeWidth,
    this.startAngle = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
