import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/heat_map.dart';
import 'package:workout/data/workout_data.dart';

import 'WorkoutPage.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();
  // function for creating new workout
  void createNewWorkout(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text("Create new Workout"),
      content: TextField(controller: newWorkoutNameController,),
      actions: [
        MaterialButton(onPressed: save,
          child: Text("Save"),),
        MaterialButton(onPressed: cancel,child: Text("Cancel"),)
      ],
    ));
  }
  void save(){
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutNameController.text);
    Navigator.pop(context);
    clear();
  }
  void cancel(){
    Navigator.pop(context);
  }
  void clear(){
    newWorkoutNameController.clear();
  }
//function to go to workout page
  void gotoWorkoutPage(String workoutName){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName),));
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: const Text("Workout Manager",style: TextStyle(color: Colors.black87),),
                backgroundColor: Colors.lime,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewWorkout,
                child: const Icon(Icons.add),
                backgroundColor: Colors.lime,
              )
              ,body: ListView(
          children: [
            //heatmap calender
            MyHeatMap(datasets: value.heatMapDataSet, startDateYYYYMMDD: value.getStartDate()),
            //listview builder
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getWorkoutList().length,
              itemBuilder: (context, index) => ListTile(
                title: Text(value.getWorkoutList()[index].name,style: TextStyle(fontSize: 16,color: Colors.black),),
                trailing: IconButton(onPressed: () => gotoWorkoutPage(value.getWorkoutList()[index].name), icon: Icon(Icons.arrow_forward)),
              ),
            ),
          ],
        )
            ));
  }
}
