import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/core/app_constant.dart';
import '/src/ui/path/path_provider.dart';

class PathView extends StatefulWidget {
  const PathView({super.key});

  @override
  State<PathView> createState() => _PathViewState();
}

class _PathViewState extends State<PathView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PathProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Path")),
        body: SafeArea(
          child: Consumer<PathProvider>(
            builder: (context, model, child) {
              if (model.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Text(
                    "Mental Math Path",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tier 1 mastery progress",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: model.tierOneProgress,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text("${(model.tierOneProgress * 100).round()}% complete"),
                  const SizedBox(height: 12),
                  ...model.lessons.map(
                    (lesson) => Card(
                      child: ListTile(
                        title: Text(lesson.title),
                        subtitle: Text(lesson.subtitle),
                        trailing: Text(model.isUnlocked(lesson) ? "Open" : "Locked"),
                        onTap: model.isUnlocked(lesson)
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  KeyUtil.lesson,
                                  arguments: lesson.id,
                                );
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
