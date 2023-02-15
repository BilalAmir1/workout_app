import 'package:flutter/material.dart';

class exerciseTile extends StatelessWidget {
  final String exerciseName;
  final String reps;
  final String sets;
  final String weight;
  final bool isCompleted;
  void Function(bool?)? onCheckboxChanged;

  exerciseTile(
      {Key? key,
      required this.exerciseName,
      required this.reps,
      required this.sets,
      required this.weight,
      required this.isCompleted,
      required this.onCheckboxChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListTile(
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            Chip(label: Text("${weight}kg")),
            SizedBox(width: 5),
            Chip(label: Text("$reps reps")),
            SizedBox(width: 5),
            Chip(label: Text("$sets sets")),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckboxChanged!(value),
          checkColor: Colors.lime,
        ),
      ),
    );
  }
}
