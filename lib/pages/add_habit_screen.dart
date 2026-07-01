import 'package:flutter/material.dart';
import 'package:habit_tracker_project/app_colors.dart';
import 'package:habit_tracker_project/firestore_service.dart';

class AddHabitScreen extends StatefulWidget {
  final FirestoreService service;

  const AddHabitScreen({super.key, required this.service});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber;
  final Map<String, Color> _habitColors = {
    'High': AppColors.prioHigh,
    'Medium': AppColors.prioMid,
    'Low': AppColors.prioLow,
  };
  String selectedColorName = 'Low';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedColor = _habitColors[selectedColorName]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Habits',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ADD HABIT",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _habitController,
                    decoration: const InputDecoration(
                      hintText: 'Enter habit name',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black54, width: 1.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black54),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_habitController.text.isNotEmpty) {
                              setState(() => isLoading = true);
                              try {
                                String colorHex = selectedColor.value
                                    .toRadixString(16)
                                    .padLeft(8, '0')
                                    .toUpperCase();
                                await widget.service.addHabit(
                                  _habitController.text,
                                  colorHex,
                                );
                                _habitController.clear();
                                selectedColorName = 'Low';
                                selectedColor =
                                    _habitColors[selectedColorName]!;
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error adding habit: $e'),
                                  ),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _habitColors.keys.map((String colorName) {
                bool isSelected = selectedColorName == colorName;
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorName = colorName;
                        selectedColor = _habitColors[selectedColorName]!;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _habitColors[colorName],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "YOUR HABITS",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                  ),
                ),
                const Divider(),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<Habit>>(
                stream: widget.service.habitsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final habits = snapshot.data ?? [];
                  if (habits.isEmpty) {
                    return const Center(
                      child: Text('No habits yet. Add one above!'),
                    );
                  }
                  return ListView(
                    children: habits.map((habit) {
                      final habitColor = _getColorFromHex(habit.colorHex);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: habitColor,
                          radius: 12.0,
                        ),
                        title: Text(
                          habit.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await widget.service.deleteHabit(habit.id);
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }
}
