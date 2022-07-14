import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/feachers/goals/presentation/history_screen/cubit/history_screen_cubit.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/goal.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: const Text(
          'Goals',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const GoalsListView(),
    );
  }
}

class GoalsListView extends StatelessWidget {
  const GoalsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryScreenCubit, HistoryScreenState>(
      builder: (context, state) {
        if (state.status == HistoryScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final goals = state.goals;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.separated(
              itemCount: goals.length,
              itemBuilder: (BuildContext context, int index) =>
                  ListViewItem(goal: goals[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10)),
        );
      },
    );
  }
}

class ListViewItem extends StatelessWidget {
  const ListViewItem({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy').format(goal.createdAt);
    return Row(
      children: [
        Text(
          date,
        ),
        const SizedBox(width: 10),
        const CheckboxItem(),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            goal.text,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}

class CheckboxItem extends StatelessWidget {
  const CheckboxItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        fillColor:
            MaterialStateProperty.all(const Color.fromRGBO(71, 77, 175, 1)),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        value: true,
        onChanged: (bool? value) {},
      ),
    );
  }
}
