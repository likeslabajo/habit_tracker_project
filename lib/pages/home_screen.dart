import 'package:flutter/material.dart';
import 'package:habit_tracker_project/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker_project/auth.dart';
import 'login_screen.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String name = '';
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    name = widget.username;
  }

  Future<void> _saveHabits() async {
    // save habits to preferences in the future
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try {
        return _getColorFromHex(colorHex);
      } catch (e) {
        print('Error parsing color for $habit: $e');
      }
    }
    return Colors.blue;
  }

  // --- Core toggle action logic ---
  void _completeHabit(String habit) {
    setState(() {
      String color = selectedHabitsMap.remove(habit)!;
      completedHabitsMap[habit] = color;
      _saveHabits();
    });
  }

  void _undoHabit(String habit) {
    setState(() {
      String color = completedHabitsMap.remove(habit)!;
      selectedHabitsMap[habit] = color;
      _saveHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          'Streakly',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: NavigationDrawer(
        selectedHabitsMap: selectedHabitsMap,
        onHabitsUpdated: (updatedHabits) {
          setState(() {
            selectedHabitsMap = updatedHabits;
          });
        },
      ),
      // Switch from Multiple Expanded lists to a Single unified ListView
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Greeting Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today is $formattedDate',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMedium,
                      ),
                    ),
                    Text(
                      'Hey, ${widget.username}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const Text('👋', style: TextStyle(fontSize: 36)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- TODAY'S HABITS SECTION HEADER ---
          _buildSectionHeader("TODAY'S HABITS"),

          if (selectedHabitsMap.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  Text(
                    'No habits yet',
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Add your habits to start your streak',
                    style: TextStyle(fontSize: 14, color: AppColors.textMedium),
                  ),
                ],
              ),
            )
          else
            ...selectedHabitsMap.keys.map((habit) {
              Color habitColor = _getHabitColor(habit, selectedHabitsMap);
              return _buildHabitCard(
                habit,
                habitColor,
                isCompleted: false,
                onTapCircle: () => _completeHabit(habit),
              );
            }),

          const SizedBox(height: 16),

          // --- COMPLETED SECTION HEADER ---
          _buildSectionHeader("COMPLETED"),

          if (completedHabitsMap.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Tap on an activity circle to mark as done.',
                style: TextStyle(fontSize: 14, color: AppColors.textMedium),
              ),
            )
          else
            ...completedHabitsMap.keys.map((habit) {
              Color habitColor = _getHabitColor(habit, completedHabitsMap);
              return _buildHabitCard(
                habit,
                habitColor,
                isCompleted: true,
                onTapCircle: () => _undoHabit(habit),
              );
            }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedHabits = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddHabitScreen(initialHabits: selectedHabitsMap),
            ),
          );
          if (updatedHabits != null) {
            setState(() {
              selectedHabitsMap = updatedHabits;
            });
          }
        },
        backgroundColor: AppColors.primary,
        tooltip: 'Add Habits',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
        ),
        const Divider(),
      ],
    );
  }
  Widget _buildHabitCard(
    String title,
    Color leadingDotColor, {
    bool isCompleted = false,
    required VoidCallback onTapCircle,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.textLight, // Change your border color here
          width: 1.0, // Change border thickness
        ),
      ),
      color: Colors.grey[50],
      child: Container(
        height: 64,
        alignment: Alignment.center,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: leadingDotColor, radius: 8),
          title: Text(
            title,
            style: TextStyle(
              color: isCompleted ? Colors.grey : AppColors.textDark,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: GestureDetector(
            onTap: onTapCircle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? const Color.fromARGB(255, 90, 83, 164)
                      : AppColors.textLight.withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final Map<String, String> selectedHabitsMap;
  final Function(Map<String, String>) onHabitsUpdated;

  NavigationDrawer({
    Key? key,
    required this.selectedHabitsMap,
    required this.onHabitsUpdated,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[buildHeader(context), buildMenuItems(context)],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  );

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    child: Wrap(
      runSpacing: 16,
      children: [
        ListTile(
          leading: const Icon(Icons.checklist),
          title: const Text('Habits'),
          onTap: () async {
            final updatedHabits = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddHabitScreen(initialHabits: selectedHabitsMap),
              ),
            );
            if (updatedHabits != null) {
              onHabitsUpdated(updatedHabits);
            }
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart_rounded),
          title: const Text('Reports'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          onTap: () {
            _signOut(context);
          },
        ),
      ],
    ),
  );
}
