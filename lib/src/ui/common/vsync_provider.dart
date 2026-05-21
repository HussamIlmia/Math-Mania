import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class VsyncProvider extends SingleChildStatefulWidget {
  const VsyncProvider({super.key, super.child});

  static TickerProvider of(BuildContext context) {
    return context.read<TickerProvider>();
  }

  @override
  State<VsyncProvider> createState() => _VsyncProviderState();
}

class _VsyncProviderState extends SingleChildState<VsyncProvider>
    with TickerProviderStateMixin {
  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return Provider<TickerProvider>.value(value: this, child: child);
  }
}
