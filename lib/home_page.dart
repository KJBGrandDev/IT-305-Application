import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'items_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _newHabitController = TextEditingController();

  List<Map<String, dynamic>> habits = [
    {
      'id': 'task_1',
      'name': 'Purify Water (Drink 2L)',
      'reward': '+10 Hydration',
      'icon': Icons.water_drop,
      'isDone': false,
    },
    {
      'id': 'task_2',
      'name': 'Scavenge for Supplies (Workout)',
      'reward': '+15 Strength',
      'icon': Icons.fitness_center,
      'isDone': false,
    },
  ];

  void _addNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF181A12),
          title: const Text(
            'Log New Survival Task',
            style: TextStyle(color: Color(0xFFC6CC7D)),
          ),
          content: TextField(
            controller: _newHabitController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter task name...',
              hintStyle: TextStyle(color: Color(0xFF8D9352)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF515525)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 130, 217, 103),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _newHabitController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF8E5139)),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_newHabitController.text.isNotEmpty) {
                  setState(() {
                    habits.add({
                      'id': DateTime.now().toString(),
                      'name': _newHabitController.text,
                      'reward': '+5 Survival Points',
                      'icon': Icons.explore,
                      'isDone': false,
                    });
                  });
                  Navigator.pop(context);
                  _newHabitController.clear();
                }
              },
              child: const Text(
                'Add Task',
                style: TextStyle(color: Color.fromARGB(255, 130, 217, 103)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A12),
      appBar: AppBar(
        title: Text(
          "Base Camp",
          style: GoogleFonts.bebasNeue(
            fontSize: 36,
            color: const Color(0xFFC6CC7D),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 19, 13),
        iconTheme: const IconThemeData(color: Color(0xFFC6CC7D)),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 17, 19, 13),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 17, 19, 13),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monitor_heart_outlined,
                    color: Color(0xFF8E5139),
                    size: 40,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Survivor:\n${FirebaseAuth.instance.currentUser?.email ?? 'Unknown'}',
                      style: const TextStyle(color: Color(0xFFC6CC7D)),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF8E5139),
              ),
              title: const Text(
                'List of Survival Loots',
                style: TextStyle(color: Color(0xFFC6CC7D)),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ItemsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Color(0xFF8E5139)),
              title: const Text(
                'Evacuate (Sign out)',
                style: TextStyle(color: Color(0xFFC6CC7D)),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(habits[index]['id']),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF8E5139).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete,
                color: Color(0xFF181A12),
                size: 30,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                habits.removeAt(index);
              });
            },
            child: Card(
              color: const Color(0xFF515525),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  habits[index]['icon'],
                  color: habits[index]['isDone']
                      ? const Color(0xFFC6CC7D).withOpacity(0.4)
                      : const Color(0xFFC6CC7D),
                ),
                title: Text(
                  habits[index]['name'],
                  style: TextStyle(
                    color: habits[index]['isDone']
                        ? const Color(0xFF8D9352)
                        : const Color.fromARGB(255, 130, 217, 103),
                    fontWeight: FontWeight.bold,
                    decoration: habits[index]['isDone']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: const Color(0xFF8D9352),
                  ),
                ),
                subtitle: Text(
                  habits[index]['reward'],
                  style: TextStyle(
                    color: habits[index]['isDone']
                        ? const Color(0xFF8D9352).withOpacity(0.5)
                        : const Color(0xFF8D9352),
                    decoration: habits[index]['isDone']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Checkbox(
                  value: habits[index]['isDone'],
                  onChanged: (bool? newValue) {
                    setState(() {
                      habits[index]['isDone'] = newValue!;
                    });
                  },
                  activeColor: const Color.fromARGB(255, 130, 217, 103),
                  checkColor: const Color(0xFF181A12),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 130, 217, 103),
                    width: 2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewHabit,
        backgroundColor: const Color(0xFF8E5139),
        child: const Icon(Icons.add, color: Color(0xFF181A12)),
      ),
    );
  }
}
