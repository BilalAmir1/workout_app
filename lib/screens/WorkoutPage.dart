import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/exercise_tile.dart';

import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //function to check the checkbox
  void onCheckboxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //function to add new exercise
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Create new Workout"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: exerciseNameController,
                      decoration: new InputDecoration(
                        hintText: "Exercise Name"
                      ),
                    ),
                    TextField(
                      controller: weightController,
                      decoration: new InputDecoration(
                          hintText: "Weight"
                      ),
                    ),
                    TextField(
                      controller: setsController,
                      decoration: new InputDecoration(
                          hintText: "Sets"
                      ),
                    ),
                    TextField(
                      controller: repsController,
                      decoration: new InputDecoration(
                          hintText: "Reps"
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text("Save"),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  void save() {
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        exerciseNameController.text,
        weightController.text,
        setsController.text,
        weightController.text);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.workoutName,
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.lime,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                child: Icon(Icons.add),
                backgroundColor: Colors.lime,
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ListView.builder(
                    itemCount:
                        value.numberOfExercisesInWorkout(widget.workoutName),
                    itemBuilder: (context, index) => exerciseTile(
                        exerciseName: value
                            .getReleventWorkout(widget.workoutName)
                            .exercises[index]
                            .name,
                        reps: value
                            .getReleventWorkout(widget.workoutName)
                            .exercises[index]
                            .reps,
                        sets: value
                            .getReleventWorkout(widget.workoutName)
                            .exercises[index]
                            .sets,
                        weight: value
                            .getReleventWorkout(widget.workoutName)
                            .exercises[index]
                            .weight,
                        isCompleted: value
                            .getReleventWorkout(widget.workoutName)
                            .exercises[index]
                            .isCompleted,
                        onCheckboxChanged: (val) => onCheckboxChanged(
                            widget.workoutName,
                            value
                                .getReleventWorkout(widget.workoutName)
                                .exercises[index]
                                .name))),
              ),
            ));
  }
}
