import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/src/core/app_constant.dart';
import '/src/ui/today/srs_review_view.dart';
import '/src/ui/today/today_provider.dart';

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodayProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<TodayProvider>(
            builder: (context, model, child) {
              if (model.loading) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Today",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        title: const Text("Review cards due today"),
                        subtitle: Text("${model.dueCount} cards"),
                        trailing: ElevatedButton(
                          onPressed: model.dueCards.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SrsReviewView(
                                        dueCards: model.dueCards,
                                      ),
                                    ),
                                  ).then((value) {
                                    model.load();
                                  });
                                },
                          child: const Text("Start review"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (model.lesson != null) ...[
                      Card(
                        child: ListTile(
                          title: Text(model.lesson!.title),
                          subtitle: const Text("Start your first lesson"),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                KeyUtil.lesson,
                                arguments: model.lesson!.id,
                              );
                            },
                            child: const Text("Today's lesson"),
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back to Dashboard"),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
