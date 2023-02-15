import 'package:flutter/cupertino.dart';
import 'package:workout/data/hive_database.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/time/date_time.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier{
  final db = HiveDatabase();

  List<Workout> workoutlist = [
    Workout(name: "Upper Body", exercises: [
      Exercise(name: "Bicep Curls", reps: "10", sets: "3", weight: "10"),
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(name: "Squats", reps: "10", sets: "3", weight: "10"),
    ]),
  ];

  //check if app is used first time if not then display usual data
  void initalizeWorkoutList(){
    if(db.previousDataExists()){
      workoutlist = db.readFromDatabase();
    }else{
      db.saveToDatabase(workoutlist);
    }

    loadHeatMap();
  }

//get list of the workouts
  List<Workout> getWorkoutList() {
    return workoutlist;
  }

//add a workout
  void addWorkout(String name) {
    workoutlist.add(Workout(name: name, exercises: []));

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutlist);
  }

//add exercise to a workout
  void addExercise(String workoutName, String exerciseName, String reps,
      String sets, String weight) {
    //find if workout is already present or not
    Workout releventWorkout =
        getReleventWorkout(workoutName);

    releventWorkout.exercises.add(
        Exercise(name: exerciseName, reps: reps, sets: sets, weight: weight));

    notifyListeners();
    db.saveToDatabase(workoutlist);

  }

//check oof a workout if it is done
  void checkOffExercise(String workoutName, String exerciseName){
    Exercise releventExercise = getReleventExercise(exerciseName, workoutName);
    releventExercise.isCompleted = !releventExercise.isCompleted;

    notifyListeners();
    db.saveToDatabase(workoutlist);
    loadHeatMap();
  }

//get length of a workout
  int numberOfExercisesInWorkout(String workoutName){
    Workout releventWorkout = getReleventWorkout(workoutName);
    return releventWorkout.exercises.length;
  }

//get object of a relevent workout
Workout getReleventWorkout(String workoutName){
  Workout releventWorkout =
  workoutlist.firstWhere((workout) => workout.name == workoutName);

  return releventWorkout;
}

//get object of a relevent workout exercise
Exercise getReleventExercise(String exerciseName, String workoutName){
    Workout releventWorkout = getReleventWorkout(workoutName);
    Exercise releventExercise = releventWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);

    return releventExercise;
}

//get start date
String getStartDate(){
    return db.getStartDate();
}
//HEATMAP
  Map<DateTime,int> heatMapDataSet = {};

void loadHeatMap(){
    DateTime startDate = createDateTimeObject(getStartDate());

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for(int i=0; i<daysInBetween+1; i++){
      String yyyymmdd = convertDateTimetoYYYYMMDD(startDate.add(Duration(days: 1)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime,int>{
        DateTime(year,month,day): completionStatus
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
}
}
