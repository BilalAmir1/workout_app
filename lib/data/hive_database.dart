import 'package:hive/hive.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/models/workout.dart';
import 'package:workout/time/date_time.dart';

class HiveDatabase {
//referencing our HIVE box
  final _myBox = Hive.box("workout_database1");

//check if data is already stored
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Data Does not exist");
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return false;
    } else {
      print("Data Exists");
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

//write data in database
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 0);
    }

    //save in the database(hive box)
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

//read from database
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];
      for (int j = 0; j > exerciseDetails[i].length; j++) {
        exerciseInEachWorkout.add(Exercise(
            name: exerciseDetails[i][j][0],
            reps: exerciseDetails[i][j][1],
            sets: exerciseDetails[i][j][2],
            weight: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,));
      }
      Workout workout = Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

//return completed status of a exercise
  bool exerciseCompleted(List<Workout> workouts) {
    //go through each workout
    for (var workout in workouts) {
      //go through each exercise
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return compeltion status of a day or date
int getCompletionStatus(String yyyymmdd){
    int completionStatus = _myBox.get("COMPELTION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
}
}

//converts objects into lists
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

//converts exercises object into list
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exercisesInWorkout[j].name,
        exercisesInWorkout[j].weight,
        exercisesInWorkout[j].sets,
        exercisesInWorkout[j].reps,
        exercisesInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
