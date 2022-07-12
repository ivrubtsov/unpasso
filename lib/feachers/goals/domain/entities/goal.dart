class Goal {
  final String text;
  final int authorId;
  final bool isCompleted;

  const Goal({
    required this.text,
    required this.authorId,
    this.isCompleted = false,
  });
}
