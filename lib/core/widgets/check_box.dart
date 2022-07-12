import 'package:flutter/material.dart';
import 'package:goal_app/feachers/goals/presentation/history_screen/goals_history_screen.dart';

class CheckBox extends StatefulWidget {
  const CheckBox(
      {Key? key, this.onChanged, required this.value, this.readOnly = false})
      : super(key: key);
  final Function(bool)? onChanged;
  final bool value;
  final bool readOnly;
  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        fillColor:
            MaterialStateProperty.all(const Color.fromRGBO(71, 77, 175, 1)),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        value: isChecked,
        onChanged: (value) {
          if (widget.readOnly == true) return;
          setState(() {
            isChecked = value ?? false;
            if (widget.onChanged != null) {
              widget.onChanged!(value ?? false);
            }
          });
        },
      ),
    );
  }
}

class Chek extends StatelessWidget {
  const Chek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen()));
                },
                icon: const Icon(
                  Icons.format_list_bulleted,
                  size: 30,
                  color: Colors.black,
                ))
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
              SizedBox(
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
              )
            ],
          ),
        ));
  }
}
