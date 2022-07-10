import 'package:flutter/material.dart';
import 'package:goal_app/core/widgets/check_box.dart';

import 'package:goal_app/feachers/goals/presentation/history_screen/goals_history_screen.dart';

class SetGoalScreen extends StatelessWidget {
  const SetGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
              children: [
                const Text(
                  'Goal for today',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    CheckBox(),
                    SizedBox(width: 10),
                    Expanded(child: GoalTextField())
                  ],
                )
              ],
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: QoauteWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class QoauteWidget extends StatelessWidget {
  const QoauteWidget({
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

class GoalTextField extends StatelessWidget {
  const GoalTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      style: TextStyle(fontSize: 22),
      decoration: InputDecoration(
          hintText: 'Set a goal',
          hintStyle: TextStyle(fontSize: 22),
          border: InputBorder.none),
    );
  }
}
