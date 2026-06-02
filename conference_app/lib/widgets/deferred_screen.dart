import 'package:flutter/material.dart';

typedef DeferredWidgetLoader = Future<Widget> Function();

class DeferredScreen extends StatefulWidget {
  final DeferredWidgetLoader load;

  const DeferredScreen({super.key, required this.load});

  @override
  State<DeferredScreen> createState() => _DeferredScreenState();
}

class _DeferredScreenState extends State<DeferredScreen> {
  late final Future<Widget> _future = widget.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (context, snapshot) {
        final child = snapshot.data;
        if (child != null) return child;

        if (snapshot.hasError) {
          return Material(
            color: Colors.white,
            child: Center(
              child: Text(
                'Failed to load page',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return const Material(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
        );
      },
    );
  }
}
