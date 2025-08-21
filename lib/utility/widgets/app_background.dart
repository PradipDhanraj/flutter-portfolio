import 'package:flutter/material.dart';
import 'dart:async';

class AppBackgroundWidget extends StatefulWidget {
  const AppBackgroundWidget({super.key});

  @override
  State<AppBackgroundWidget> createState() => _AppBackgroundWidgetState();
}

class _AppBackgroundWidgetState extends State<AppBackgroundWidget>
    with SingleTickerProviderStateMixin {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1517841905240-472988babdf9',
    'https://images.unsplash.com/photo-1464983953574-0892a716854b',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9',
    'https://images.unsplash.com/photo-1464983953574-0892a716854b',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
  ];
  int _currentImage = 0;
  late Timer _timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _startImageTimer();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _fadeController.forward();
      setState(() {
        _currentImage = (_currentImage + 1) % imageUrls.length;
      });
      _fadeController.reverse();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/background.png',
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //     height: double.infinity,
          //   ),
          // ),
          Opacity(
            opacity: 1 - _fadeAnimation.value,
            child: Expanded(
              child: AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1 - _fadeAnimation.value,
                    child: Image.network(
                      imageUrls[_currentImage],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          _fadeController.reverse();
                          return child;
                        } else {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 30),
                          ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
