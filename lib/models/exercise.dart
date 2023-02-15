class Exercise{
  final String name;
  final String weight;
  final String sets;
  final String reps;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.reps,
    required this.sets,
    required this.weight,
    this.isCompleted = false
  });
}