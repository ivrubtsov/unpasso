import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: const ListViewGoal(),
    );
  }
}

class ListViewGoal extends StatelessWidget {
  const ListViewGoal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView.separated(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return const ListViewItem();
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }
}

class ListViewItem extends StatelessWidget {
  const ListViewItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          '03.06.22',
        ),
        SizedBox(width: 10),
        ChekBoxItem(),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Buy an English textbook ',
            style: TextStyle(fontSize: 16),
          ),
        )
      ],
    );
  }
}

class ChekBoxItem extends StatefulWidget {
  const ChekBoxItem({Key? key}) : super(key: key);

  @override
  State<ChekBoxItem> createState() => _ChekBoxItemState();
}

class _ChekBoxItemState extends State<ChekBoxItem> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
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
