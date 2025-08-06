import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:confetti/confetti.dart';
import 'glassmorphism_theme.dart';

class ToastUtils {
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showInfoToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: GlassmorphismTheme.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showWarningToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class ConfettiUtils {
  static void showSuccessConfetti(ConfettiController controller) {
    controller.play();
    Future.delayed(const Duration(seconds: 3), () {
      controller.stop();
    });
  }

  static void showCelebrationConfetti(ConfettiController controller) {
    controller.play();
    Future.delayed(const Duration(seconds: 5), () {
      controller.stop();
    });
  }

  static void showAchievementConfetti(ConfettiController controller) {
    controller.play();
    Future.delayed(const Duration(seconds: 4), () {
      controller.stop();
    });
  }

  static void showMilestoneConfetti(ConfettiController controller) {
    controller.play();
    Future.delayed(const Duration(seconds: 6), () {
      controller.stop();
    });
  }

  static Widget buildConfettiWidget({
    required ConfettiController controller,
    required Widget child,
  }) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirection: pi / 2,
            maxBlastForce: 8,
            minBlastForce: 3,
            emissionFrequency: 0.03,
            numberOfParticles: 80,
            gravity: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.red,
              Colors.yellow,
              Colors.teal,
              Colors.indigo,
              Colors.amber,
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildCenterConfettiWidget({
    required ConfettiController controller,
    required Widget child,
  }) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirection: 0,
            maxBlastForce: 8,
            minBlastForce: 3,
            emissionFrequency: 0.03,
            numberOfParticles: 80,
            gravity: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.red,
              Colors.yellow,
              Colors.teal,
              Colors.indigo,
              Colors.amber,
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildMultiConfettiWidget({
    required ConfettiController controller1,
    required ConfettiController controller2,
    required Widget child,
  }) {
    return Stack(
      children: [
        child,
        // Top confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller1,
            blastDirection: pi / 2,
            maxBlastForce: 8,
            minBlastForce: 3,
            emissionFrequency: 0.03,
            numberOfParticles: 60,
            gravity: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        // Center confetti
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: controller2,
            blastDirection: 0,
            maxBlastForce: 6,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 40,
            gravity: 0.08,
            colors: const [
              Colors.red,
              Colors.yellow,
              Colors.teal,
              Colors.indigo,
              Colors.amber,
            ],
          ),
        ),
      ],
    );
  }
}
