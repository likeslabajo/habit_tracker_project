import 'package:flutter/material.dart';
import 'package:habit_tracker_project/app_colors.dart';

class AddHabitScreen extends StatefulWidget {
  final Map<String, String> initialHabits;

  const AddHabitScreen({super.key, this.initialHabits = const {}});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber; // Default color
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  final Map<String, Color> _habitColors = {
    'High': AppColors.prioHigh,
    'Medium': AppColors.prioMid,
    'Low': AppColors.prioLow,
  };
  String selectedColorName = 'Low';

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() {
      selectedHabitsMap = Map.from(widget.initialHabits);
      completedHabitsMap = {};
    });
  }

  /*Future<void> _saveHabits() async {

  }*/

  @override
  Widget build(BuildContext context) {
    Map<String, String> allHabitsMap = {
      ...selectedHabitsMap,
      ...completedHabitsMap,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Habits', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, selectedHabitsMap);
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
                    onPressed: () {
                      if (_habitController.text.isNotEmpty) {
                        setState(() {
                          String colorHex = selectedColor.value
                              .toRadixString(16)
                              .padLeft(8, '0')
                              .toUpperCase();
                          selectedHabitsMap[_habitController.text] = colorHex;
                          _habitController.clear();
                          selectedColorName = 'Low';
                          selectedColor = _habitColors[selectedColorName]!;
                        });
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
              child: ListView(
                children: allHabitsMap.entries.map((entry) {
                  final habitName = entry.key;
                  final habitColor = _getColorFromHex(entry.value);
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: habitColor, radius: 12.0,),
                    title: Text(habitName, style: TextStyle( fontSize: 14),),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          selectedHabitsMap.remove(habitName);
                          completedHabitsMap.remove(habitName);
                        });
                      },
                    ),
                  );
                }).toList(),
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
