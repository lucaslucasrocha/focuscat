import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const FocusCatsApp());
}

class FocusCatsApp extends StatelessWidget {
  const FocusCatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Cats MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FocusCatsHomePage(),
    );
  }
}

class FocusCatsHomePage extends StatefulWidget {
  const FocusCatsHomePage({super.key});

  @override
  State<FocusCatsHomePage> createState() => _FocusCatsHomePageState();
}

class _FocusCatsHomePageState extends State<FocusCatsHomePage> {
  static const int focusDuration = 1500;

  late int currentTimeLeft;
  int totalFocusMinutes = 0;
  int catCount = 0;
  bool rewardReady = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    currentTimeLeft = focusDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_timer?.isActive ?? false) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      currentTimeLeft = focusDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTimeLeft <= 1) {
        timer.cancel();
        setState(() {
          totalFocusMinutes += focusDuration ~/ 60;
          rewardReady = true;
          currentTimeLeft = focusDuration;
        });
      } else {
        setState(() {
          currentTimeLeft -= 1;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {});
  }

  void _claimReward() {
    if (!rewardReady) return;
    setState(() {
      catCount += 1;
      rewardReady = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secs.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _timer?.isActive ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Cats MVP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Focus: $totalFocusMinutes min'),
                Text('Cats: $catCount'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(currentTimeLeft),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      catCount,
                      (index) => Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleTimer,
                    child: Text(isRunning ? 'STOP' : 'START'),
                  ),
                ),
                if (rewardReady) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _claimReward,
                      child: const Text('CLAIM REWARD'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
