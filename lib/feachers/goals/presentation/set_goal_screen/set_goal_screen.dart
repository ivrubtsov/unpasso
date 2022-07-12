import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/widgets/check_box.dart';

import 'package:goal_app/feachers/goals/presentation/history_screen/goals_history_screen.dart';
import 'package:goal_app/feachers/goals/presentation/set_goal_screen/cubit/set_goal_screen_cubit.dart';

class SetGoalScreen extends StatelessWidget {
  const SetGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
            child: const Text(
              'History',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 50,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                child: Column(
                  children: const [
                    Align(
                        alignment: Alignment(0, -0.6),
                        child: Icon(
                          Icons.check,
                          size: 60,
                          color: Colors.green,
                        )),
                    Align(
                        alignment: Alignment(0, -0.4),
                        child: Text(
                          'Well done!\nYou did it!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _GoalWidget(),
              ],
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: QuoteWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        Text(
          '"A journey of a thousand miles begins with a single step"',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            'Lao Tzu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalWidget extends StatelessWidget {
  const _GoalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Goal for today',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Row(
          children: const [
            CheckBox(),
            SizedBox(width: 10),
            Expanded(child: GoalTextField()),
          ],
        ),
      ],
    );
  }
}

class GoalTextField extends StatefulWidget {
  const GoalTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalTextField> createState() => _GoalTextFieldState();
}

class _GoalTextFieldState extends State<GoalTextField> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<SetGoalScreenCubit>();

    return BlocBuilder<SetGoalScreenCubit, SetGoalScreenState>(
      builder: (context, state) {
        _controller.text = state.goal;
        return TextField(
          controller: _controller,
          onChanged: model.changeGoal,
          onSubmitted: (value) => model.onSubmittedComplete(value, context),
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(
              hintText: 'Set a goal',
              hintStyle: TextStyle(fontSize: 22),
              border: InputBorder.none),
        );
      },
    );
  }
}
