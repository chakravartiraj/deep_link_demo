import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _heroAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutBack,
    );

    _floatingAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_floatingController);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _heroController.forward();
    _floatingController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Helper method for responsive values
  T _getResponsiveValue<T>(
    BuildContext context,
    T mobile,
    T tablet,
    T desktop,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 768) return mobile;
    if (screenWidth <= 1024) return tablet;
    return desktop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
              Color(0xFF000DFF),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(),

            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(),
                  _buildFeaturesSection(),
                  _buildTutorialSection(),
                  // _buildDemoSection(),
                  _buildFooterSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + math.sin(_floatingAnimation.value) * 20,
              right: _getResponsiveValue(context, 50.0, 75.0, 100.0),
              child: _buildFloatingIcon(
                Icons.link,
                _getResponsiveValue(context, 40.0, 50.0, 60.0),
              ),
            ),
            Positioned(
              top: 200 + math.cos(_floatingAnimation.value + 1) * 15,
              left: _getResponsiveValue(context, 25.0, 35.0, 50.0),
              child: _buildFloatingIcon(
                Icons.mobile_friendly,
                _getResponsiveValue(context, 30.0, 35.0, 40.0),
              ),
            ),
            Positioned(
              bottom: 200 + math.sin(_floatingAnimation.value + 2) * 25,
              right: _getResponsiveValue(context, 100.0, 150.0, 200.0),
              child: _buildFloatingIcon(
                Icons.web,
                _getResponsiveValue(context, 35.0, 42.0, 50.0),
              ),
            ),
            Positioned(
              bottom: 100 + math.cos(_floatingAnimation.value + 3) * 18,
              left: _getResponsiveValue(context, 75.0, 110.0, 150.0),
              child: _buildFloatingIcon(
                Icons.integration_instructions,
                _getResponsiveValue(context, 32.0, 38.0, 45.0),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingIcon(IconData icon, double size) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.all(
              _getResponsiveValue(context, 15.0, 18.0, 20.0),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: _getResponsiveValue(context, 1.5, 1.8, 2.0),
              ),
            ),
            child: Icon(
              icon,
              size: size,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _heroAnimation.value)),
          child: Opacity(
            opacity: _heroAnimation.value.clamp(0.0, 1.0),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveValue(context, 20.0, 40.0, 60.0),
                vertical: _getResponsiveValue(context, 40.0, 60.0, 60.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo/icon
                  TweenAnimationBuilder(
                    duration: const Duration(seconds: 2),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.rotate(
                        angle: value * 2 * math.pi,
                        child: Container(
                          width: _getResponsiveValue(
                            context,
                            80.0,
                            100.0,
                            120.0,
                          ),
                          height: _getResponsiveValue(
                            context,
                            80.0,
                            100.0,
                            120.0,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.white.withValues(alpha: 0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.link,
                            size: _getResponsiveValue(
                              context,
                              40.0,
                              50.0,
                              60.0,
                            ),
                            color: Color(0xFF667eea),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: _getResponsiveValue(context, 20.0, 25.0, 30.0),
                  ),

                  // Main title
                  Text(
                    'Deep Link Demo',
                    style: GoogleFonts.poppins(
                      fontSize: _getResponsiveValue(context, 32.0, 48.0, 56.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: _getResponsiveValue(context, 10.0, 12.0, 15.0),
                  ),

                  // Subtitle
                  Text(
                    'Master Flutter Deep Linking with Beautiful Animations',
                    style: GoogleFonts.lato(
                      fontSize: _getResponsiveValue(context, 16.0, 20.0, 24.0),
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: _getResponsiveValue(context, 25.0, 30.0, 35.0),
                  ),

                  // CTA Buttons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: _getResponsiveValue(context, 15.0, 18.0, 20.0),
                    runSpacing: _getResponsiveValue(context, 12.0, 15.0, 15.0),
                    children: [
                      _buildAnimatedButton(
                        'Try Demo',
                        Icons.play_arrow,
                        () => context.go('/home'),
                        isPrimary: true,
                      ),
                      _buildAnimatedButton(
                        'View Docs',
                        Icons.book,
                        () => _scrollToSection(1),
                        isPrimary: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required bool isPrimary,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1, end: 1),
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrimary ? Colors.white : Colors.transparent,
              foregroundColor: isPrimary
                  ? const Color(0xFF667eea)
                  : Colors.white,
              side: isPrimary
                  ? null
                  : const BorderSide(color: Colors.white, width: 2),
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveValue(context, 20.0, 25.0, 30.0),
                vertical: _getResponsiveValue(context, 12.0, 13.0, 15.0),
              ),
              textStyle: GoogleFonts.poppins(
                fontSize: _getResponsiveValue(context, 16.0, 17.0, 18.0),
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: isPrimary ? 8 : 0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: EdgeInsets.all(_getResponsiveValue(context, 30.0, 50.0, 60.0)),
      child: Column(
        children: [
          Text(
            'Features',
            style: GoogleFonts.poppins(
              fontSize: _getResponsiveValue(context, 32.0, 40.0, 48.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: _getResponsiveValue(context, 30.0, 40.0, 50.0)),
          Wrap(
            spacing: _getResponsiveValue(context, 20.0, 25.0, 30.0),
            runSpacing: _getResponsiveValue(context, 20.0, 25.0, 30.0),
            children: [
              _buildFeatureCard(
                Icons.mobile_friendly,
                'Multi-Platform',
                'Works on Android, iOS, Web & Desktop',
                Colors.green,
              ),
              _buildFeatureCard(
                Icons.speed,
                'Fast Setup',
                'Quick integration with GoRouter',
                Colors.orange,
              ),
              _buildFeatureCard(
                Icons.security,
                'Secure',
                'Built-in security with App Links',
                Colors.red,
              ),
              _buildFeatureCard(
                Icons.code,
                'Open Source',
                'Complete source code included',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              width: _getResponsiveValue(context, 280.0, 300.0, 320.0),
              height: _getResponsiveValue(context, 180.0, 190.0, 200.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(
                  _getResponsiveValue(context, 14.0, 16.0, 18.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _getResponsiveValue(context, 40.0, 45.0, 50.0),
                      height: _getResponsiveValue(context, 40.0, 45.0, 50.0),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          _getResponsiveValue(context, 8.0, 10.0, 12.0),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: _getResponsiveValue(context, 20.0, 24.0, 26.0),
                        color: color,
                      ),
                    ),
                    SizedBox(
                      height: _getResponsiveValue(context, 8.0, 10.0, 12.0),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: _getResponsiveValue(
                          context,
                          14.0,
                          15.0,
                          16.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: _getResponsiveValue(context, 4.0, 5.0, 6.0),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.lato(
                        fontSize: _getResponsiveValue(
                          context,
                          10.0,
                          11.0,
                          12.0,
                        ),
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildTutorialSection() {
    return Container(
      padding: EdgeInsets.all(_getResponsiveValue(context, 30.0, 50.0, 60.0)),
      child: Column(
        children: [
          Text(
            'Quick Tutorial',
            style: GoogleFonts.poppins(
              fontSize: _getResponsiveValue(context, 32.0, 40.0, 48.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: _getResponsiveValue(context, 30.0, 40.0, 50.0)),
          _buildTutorialStep(1, 'Setup GoRouter', 'Configure your app routing'),
          _buildTutorialStep(
            2,
            'Add Intent Filters',
            'Configure platform manifests',
          ),
          _buildTutorialStep(
            3,
            'Test Deep Links',
            'Verify links work correctly',
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialStep(int step, String title, String description) {
    return Container(
      margin: EdgeInsets.only(
        bottom: _getResponsiveValue(context, 20.0, 25.0, 30.0),
      ),
      child: Row(
        children: [
          Container(
            width: _getResponsiveValue(context, 50.0, 55.0, 60.0),
            height: _getResponsiveValue(context, 50.0, 55.0, 60.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                _getResponsiveValue(context, 25.0, 27.5, 30.0),
              ),
            ),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.poppins(
                  fontSize: _getResponsiveValue(context, 20.0, 22.0, 24.0),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF667eea),
                ),
              ),
            ),
          ),
          SizedBox(width: _getResponsiveValue(context, 20.0, 25.0, 30.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: _getResponsiveValue(context, 18.0, 21.0, 24.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: _getResponsiveValue(context, 14.0, 15.0, 16.0),
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoSection() {
    return Container(
      padding: EdgeInsets.all(_getResponsiveValue(context, 30.0, 50.0, 60.0)),
      child: Column(
        children: [
          Text(
            'Try Deep Links',
            style: GoogleFonts.poppins(
              fontSize: _getResponsiveValue(context, 32.0, 40.0, 48.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: _getResponsiveValue(context, 30.0, 40.0, 50.0)),
          Wrap(
            spacing: _getResponsiveValue(context, 15.0, 18.0, 20.0),
            runSpacing: _getResponsiveValue(context, 15.0, 18.0, 20.0),
            children: [
              _buildDemoButton('Home', '/home', Icons.home),
              _buildDemoButton('Details', '/details/123', Icons.info),
              _buildDemoButton('Profile', '/profile', Icons.person),
              _buildDemoButton(
                'Deep Link',
                '/deeplink?source=web&data=demo',
                Icons.link,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton(String label, String route, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => context.go(route),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsiveValue(context, 20.0, 22.0, 25.0),
          vertical: _getResponsiveValue(context, 12.0, 13.0, 15.0),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      padding: EdgeInsets.all(_getResponsiveValue(context, 30.0, 35.0, 40.0)),
      child: Column(
        children: [
          Text(
            'Made with ❤️ using Flutter',
            style: GoogleFonts.lato(
              fontSize: _getResponsiveValue(context, 14.0, 15.0, 16.0),
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: _getResponsiveValue(context, 15.0, 18.0, 20.0)),
          ElevatedButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Start Exploring'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF667eea),
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveValue(context, 25.0, 28.0, 30.0),
                vertical: _getResponsiveValue(context, 12.0, 13.0, 15.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSection(int section) {
    // Implement smooth scrolling to sections
    // This is a placeholder for scroll functionality
  }
}
