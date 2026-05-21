import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/core/app_constant.dart';
import '/src/data/repository/lesson_repository.dart';
import '/src/ui/lesson/lesson_provider.dart';
import '/src/ui/lesson/lesson_slide_view.dart';

class LessonView extends StatefulWidget {
  final String? lessonId;

  const LessonView({super.key, this.lessonId});

  @override
  State<LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LessonProvider(lessonId: widget.lessonId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Lesson")),
        body: Consumer<LessonProvider>(
          builder: (context, provider, child) {
            if (provider.loading) {
              return Center(child: CircularProgressIndicator());
            }
            final lesson = provider.lesson;
            if (lesson == null) {
              return Center(child: Text("Lesson not found"));
            }
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    children: lesson.slides
                        .map((slide) => LessonSlideView(slide: slide))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        KeyUtil.drillSession,
                        arguments: lesson.id,
                      );
                    },
                    child: const Text("Start Drill"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
