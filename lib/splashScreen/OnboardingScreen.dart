import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ai_masa/Auth/login.dart';
import 'package:ai_masa/Auth/register.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- DHAMAKEDAR PREMIUM BACKGROUND ---
          // 1. Top Left Glow
          Positioned(
            top: -100,
            left: -50,
            child: _buildBlurCircle(
              300,
              Colors.green.shade200.withOpacity(0.5),
            ),
          ),
          // 2. Center Right Glow
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            right: -80,
            child: _buildBlurCircle(
              250,
              Colors.lightGreen.shade100.withOpacity(0.6),
            ),
          ),
          // 3. Bottom Left Accent
          Positioned(
            bottom: -50,
            left: -30,
            child: _buildBlurCircle(
              200,
              Colors.green.shade300.withOpacity(0.4),
            ),
          ),
          // 4. Subtle Texture Overlay (Optional: If you want a grainy feel)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.green.shade50.withOpacity(0.3),
                ],
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => isLastPage = index == 3),
            children: [
              buildPage(
                content: Hero(
                  tag: 'logo',
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/img/logo.png', height: 180),
                  ),
                ),
                title: 'Welcome to AI Masa',
                subtitle:
                    'Step into the future of intelligent assistance. AI Masa is designed to harmonize your workflow and bring world-class AI capabilities right to your pocket. Efficiency has a new name.',
              ),
              buildPage(
                content: _buildFeatureIcon(Icons.bolt_rounded),
                title: 'Lightning Fast',
                subtitle:
                    'Experience zero-lag interactions and instant AI-driven results. We have optimized every line of code to ensure that your experience is as smooth as silk, keeping you ahead of the curve.',
              ),
              buildPage(
                content: _buildFeatureIcon(Icons.auto_graph_rounded),
                title: 'Smart Insights',
                subtitle:
                    'Unlock the power of your data with advanced analytics. AI Masa learns your preferences to provide deeply personalized suggestions that get smarter every single day.',
              ),
              buildPage(
                content: _buildFeatureIcon(Icons.rocket_launch_rounded),
                title: 'Launch Success',
                subtitle:
                    'You are just one step away from transforming your digital life. Join our elite community of users and experience why AI Masa is consistently rated as a 5-star innovation.',
              ),
            ],
          ),

          // --- UI OVERLAYS ---
          if (!isLastPage)
            Positioned(
              top: 55,
              right: 25,
              child: TextButton(
                onPressed: () => _controller.animateToPage(
                  3,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.decelerate,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Navigation Area
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.green.shade800,
                    dotColor: Colors.green.shade200,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                const SizedBox(height: 40),
                if (isLastPage)
                  _buildFinalButtons(context)
                else
                  _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildFeatureIcon(IconData icon) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.15),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, size: 100, color: Colors.green.shade700),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () => _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      ),
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildFinalButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: _buildActionBtn(
              "LOGIN",
              Colors.green.shade700,
              Colors.white,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildActionBtn(
              "SIGN UP",
              Colors.white,
              Colors.green.shade700,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              border: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    String text,
    Color bg,
    Color txt,
    VoidCallback tap, {
    bool border = false,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: border ? 0 : 8,
          shadowColor: Colors.green.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: border
                ? BorderSide(color: Colors.green.shade700, width: 2)
                : BorderSide.none,
          ),
        ),
        onPressed: tap,
        child: Text(
          text,
          style: TextStyle(
            color: txt,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required Widget content,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          content,
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green.shade900,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
