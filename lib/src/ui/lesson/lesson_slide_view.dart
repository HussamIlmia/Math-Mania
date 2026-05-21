import 'package:flutter/material.dart';
import '/src/data/models/trainer/lesson_slide.dart';

class LessonSlideView extends StatelessWidget {
  final LessonSlide slide;

  const LessonSlideView({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Step ${slide.order}", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(slide.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              Text(slide.body, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
