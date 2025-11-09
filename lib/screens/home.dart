import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<ToDo> _tasks = ToDo.todoList();
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  // convenience getters
  int get _total => _tasks.length;
  int get _completed => _tasks.where((t) => t.isDone).length;

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.insert(
        0,
        ToDo(id: DateTime.now().microsecondsSinceEpoch, todoText: text),
      );
      _controller.clear();
    });
  }

  void _toggle(int id) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i != -1) _tasks[i].isDone = !_tasks[i].isDone;
    });
  }

  void _delete(int id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  List<ToDo> get _filtered {
    if (_query.isEmpty) return _tasks;
    return _tasks
        .where((t) => t.todoText.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header: gradient + greeting + avatar
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B21B6), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.checklist_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('My To-Do',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                            SizedBox(height: 4),
                            Text('Get things done',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      // avatar circle (initials)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('U',
                              style: TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatTile(title: 'Total', value: '$_total'),
                      _StatTile(title: 'Completed', value: '$_completed'),
                      _StatTile(
                          title: 'Pending', value: '${_total - _completed}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search field
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white70),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (s) => setState(() => _query = s),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search tasks',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Body: input + list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    // Input card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: 'Add a new task...',
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (_) => _addTask(),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                              onPressed: _addTask,
                              child: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // List / Empty state
                    Expanded(
                      child: filtered.isEmpty
                          ? _EmptyState(query: _query)
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final todo = filtered[index];
                                // Dismissible to delete
                                return Dismissible(
                                  key: ValueKey(todo.id),
                                  background: Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 82, 82, 0.9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (_) => _delete(todo.id),
                                  child: ToDoItem(
                                    todo: todo,
                                    onToggle: () => _toggle(todo.id),
                                    onDelete: () => _delete(todo.id),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({Key? key, required this.title, required this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.24)),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final message = query.isEmpty
        ? 'No tasks yet.\nAdd your first task!'
        : 'No results for "$query"';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // simple large icon as illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color.fromRGBO(59, 130, 246, 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
                child: Icon(Icons.inbox, size: 52, color: Colors.indigo)),
          ),
          const SizedBox(height: 18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
