class ToDo {
  int id;
  String todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: 1, todoText: 'Create a new project', isDone: true),
      ToDo(id: 2, todoText: 'Write some Flutter code', isDone: false),
      ToDo(id: 3, todoText: 'Polish the UI', isDone: false),
    ];
  }
}
