import 'package:flutter/material.dart';

/// Örnek Feature Model (Immutable)
@immutable
class SampleModel {
  const SampleModel({
    required this.title,
    this.counter = 0,
  });

  final String title;
  final int counter;

  SampleModel copyWith({
    String? title,
    int? counter,
  }) {
    return SampleModel(
      title: title ?? this.title,
      counter: counter ?? this.counter,
    );
  }
}

/// Örnek Feature Controller (ValueNotifier tabanlı)
class SampleController {
  SampleController()
      : state = ValueNotifier<SampleModel>(
          const SampleModel(title: 'Örnek Başlık'),
        );

  final ValueNotifier<SampleModel> state;

  void increment() {
    state.value = state.value.copyWith(counter: state.value.counter + 1);
  }

  void dispose() {
    state.dispose();
  }
}

/// Örnek Feature View (ValueListenableBuilder ile reaktif)
class SampleView extends StatefulWidget {
  const SampleView({super.key});

  @override
  State<SampleView> createState() => _SampleViewState();
}

class _SampleViewState extends State<SampleView> {
  late final SampleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SampleController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Örnek Ekran'),
      ),
      body: ValueListenableBuilder<SampleModel>(
        valueListenable: _controller.state,
        builder: (context, state, _) {
          return Center(
            child: Text(
              '${state.title}: ${state.counter}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
