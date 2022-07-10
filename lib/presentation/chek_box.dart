import 'package:flutter/material.dart';
import 'package:goal_app/presentation/second_screen.dart';

class ChekBox extends StatefulWidget {
  const ChekBox({Key? key}) : super(key: key);

  @override
  State<ChekBox> createState() => _ChekBoxState();
}

class _ChekBoxState extends State<ChekBox> {
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
          setState(() {
            isChecked = value!;
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
                          builder: (context) => const SecondScreen()));
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
