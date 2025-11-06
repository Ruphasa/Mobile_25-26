import 'package:flutter/material.dart';
import '../models/data_layer.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;

  @override
  void initState() {
    super.initState();
    // Initialize controller but don't unfocus on scroll. Removing the
    // listener prevents the keyboard from being dismissed when the user
    // scrolls to bring a field into view.
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        int planIndex = planNotifier.value.indexWhere((p) => p.name == plan.name);
        List<Task> updatedTasks = List<Task>.from(plan.tasks)..add(const Task());
        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = Plan(name: plan.name, tasks: updatedTasks);
        setState(() {
          widget.plan.tasks.clear();
          widget.plan.tasks.addAll(updatedTasks);
        });
        // After the frame, animate to the bottom so the newly added task is visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      },
    );
  }

  Widget _buildTaskTile(Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          int planIndex = planNotifier.value.indexWhere((p) => p.name == plan.name);
          List<Task> updatedTasks = List<Task>.from(plan.tasks)
            ..[index] = Task(description: task.description, complete: selected ?? false);
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(name: plan.name, tasks: updatedTasks);
          setState(() {
            widget.plan.tasks.clear();
            widget.plan.tasks.addAll(updatedTasks);
          });
        },
      ),
      title: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            // Ensure the focused field is visible above the keyboard.
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 250),
              alignment: 0.3,
            );
          }
        },
        child: TextFormField(
          initialValue: task.description,
          onChanged: (text) {
          int planIndex = planNotifier.value.indexWhere((p) => p.name == plan.name);
          List<Task> updatedTasks = List<Task>.from(plan.tasks)
            ..[index] = Task(description: text, complete: task.complete);
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(name: plan.name, tasks: updatedTasks);
          setState(() {
            widget.plan.tasks.clear();
            widget.plan.tasks.addAll(updatedTasks);
          });
        },
        ),
      ),
    );
  }

  Widget _buildList(Plan currentPlan) {
    return ListView.builder(
      controller: scrollController,
      // Add bottom padding equal to viewInsets so list content is pushed
      // up when the keyboard appears. Also prevent drag from auto-dismissing
      // the keyboard so the form remains focused while the user scrolls.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      itemCount: currentPlan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(currentPlan.tasks[index], index, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan =
              plans.firstWhere((p) => p.name == plan.name);
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }
}
