import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Plan plan = const Plan();
  late ScrollController scrollController;
  // focus nodes per task index so we can scroll the focused field into view
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    // dispose any focus nodes we created
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ganti 'Namaku' dengan nama panggilan Anda
      appBar: AppBar(
        title: const Text('Master Plan Ruphasa'),
      ),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          plan = Plan(
            name: plan.name,
            tasks: List<Task>.from(plan.tasks)..add(const Task()),
          );
        });
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior: Theme.of(context).platform == TargetPlatform.iOS
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) => _buildTaskTile(plan.tasks[index], index),
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    // Ensure we reuse a FocusNode per index so we can attach a listener once.
    if (!_focusNodes.containsKey(index)) {
      _focusNodes[index] = FocusNode();
    }

    final focusNode = _focusNodes[index]!;

    // Use a Builder so we can grab this tile's BuildContext for ensureVisible.
    return Builder(builder: (tileContext) {
      // When focus changes to this node, make sure the tile is visible.
      // We add a listener here that reacts when the node gains focus.
      // Note: the FocusNode already has a listener attached above when
      // first created; this local closure simply calls ensureVisible using
      // the correct tileContext.
      focusNode.removeListener(_noop); // remove any previous simple noop
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            try {
              Scrollable.ensureVisible(
                tileContext,
                duration: const Duration(milliseconds: 300),
                alignment: 0.2,
                curve: Curves.easeOut,
              );
            } catch (_) {
              // ignore errors during rebuild/visibility changes
            }
          });
        }
      });

      return ListTile(
        leading: Checkbox(
          value: task.complete,
          onChanged: (selected) {
            setState(() {
              plan = Plan(
                name: plan.name,
                tasks: List<Task>.from(plan.tasks)
                  ..[index] = Task(
                    description: task.description,
                    complete: selected ?? false,
                  ),
              );
            });
          },
        ),
        title: TextFormField(
          focusNode: focusNode,
          initialValue: task.description,
          onChanged: (text) {
            setState(() {
              plan = Plan(
                name: plan.name,
                tasks: List<Task>.from(plan.tasks)
                  ..[index] = Task(
                    description: text,
                    complete: task.complete,
                  ),
              );
            });
          },
        ),
      );
    });
  }

  // helper noop used when removing listeners safely
  void _noop() {}
}
