import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../utils/glassmorphism_theme.dart';
import '../utils/toast_utils.dart';

class TestConfettiScreen extends StatefulWidget {
  const TestConfettiScreen({super.key});

  @override
  State<TestConfettiScreen> createState() => _TestConfettiScreenState();
}

class _TestConfettiScreenState extends State<TestConfettiScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiUtils.buildConfettiWidget(
      controller: _confettiController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confetti Test'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [GlassmorphismTheme.backgroundColor, Color(0xFF1E293B)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Test Confetti Animation',
                  style: TextStyle(
                    color: GlassmorphismTheme.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    ConfettiUtils.showSuccessConfetti(_confettiController);
                    ToastUtils.showSuccessToast('Success confetti triggered!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Show Success Confetti'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ConfettiUtils.showCelebrationConfetti(_confettiController);
                    ToastUtils.showInfoToast('Celebration confetti triggered!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Show Celebration Confetti'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ConfettiUtils.showAchievementConfetti(_confettiController);
                    ToastUtils.showInfoToast('Achievement confetti triggered!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Show Achievement Confetti'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ConfettiUtils.showMilestoneConfetti(_confettiController);
                    ToastUtils.showInfoToast('Milestone confetti triggered!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Show Milestone Confetti'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
