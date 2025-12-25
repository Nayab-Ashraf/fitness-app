import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// --- Import navigation screens ---
import 'dashboard.dart';
import 'schedule.dart';
import 'profile.dart';
import 'settings.dart';
import 'notifications.dart';
import 'workoutplan.dart';
import 'nutrition.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // --- STATE VARIABLES (Real Data Holders) ---
  int _workoutsDone = 2;
  int _workoutTarget = 3;

  int _caloriesBurned = 450;
  int _caloriesTarget = 600;

  int _activeMinutes = 45;
  int _activeTarget = 60;

  @override
  Widget build(BuildContext context) {
    double workoutPercent = _workoutsDone / _workoutTarget;
    double caloriePercent = _caloriesBurned / _caloriesTarget;
    double timePercent = _activeMinutes / _activeTarget;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0A1E35), // Dark Blue Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // --- Custom Back Button ---
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/images/back_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          // --- FIXED NOTIFICATION ICON ---
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 10),
              height: 40,
              width: 40,
              // Removed the blue color decoration and padding
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/notification_icon.png',
                fit: BoxFit.contain,
                // Removed color: Colors.white so the real icon shows
              ),
            ),
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // --- 1. DYNAMIC HEADER STATS CARD ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF64C8D6), // Cyan/Teal color
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's Progress",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // --- Row of Interactive Stats ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatItem(
                                  label: "Workout",
                                  value: "$_workoutsDone/$_workoutTarget",
                                  percent: workoutPercent
                              ),
                              _StatItem(
                                  label: "Calories",
                                  value: "$_caloriesBurned/$_caloriesTarget",
                                  percent: caloriePercent
                              ),
                              _StatItem(
                                  label: "Active time",
                                  value: "${_activeMinutes}min",
                                  percent: timePercent
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- 2. Menu Grid (The 4 Big Buttons) ---
                    Row(
                      children: [
                        // Button 1: Workout
                        Expanded(
                          child: _MenuCard(
                            title: "Workout",
                            iconPath: 'assets/images/workout_icon.png',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const WorkoutPlanScreen())
                              ).then((_) {
                                setState(() {
                                  _workoutsDone = 3;
                                  _activeMinutes += 30;
                                });
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Button 2: Nutrition
                        Expanded(
                          child: _MenuCard(
                            title: "Nutrition",
                            iconPath: 'assets/images/nutrition icon.png',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NutritionScreen())
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        // Button 3: Track Progress
                        Expanded(
                          child: _MenuCard(
                            title: "Track\nProgress",
                            iconPath: 'assets/images/progress_icon.png',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Button 4: My Schedule
                        Expanded(
                          child: _MenuCard(
                            title: "My\nSchedule",
                            iconPath: 'assets/images/schedule_icon.png',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- 3. Bottom Navigation Bar ---
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF0A1E35),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, Icons.fitness_center, "Dashboard", false),
                  _buildNavItem(context, Icons.settings, "Setting", false),
                  _buildNavItem(context, Icons.calendar_month, "Schedule", false),
                  _buildNavItem(context, Icons.person, "Your Profile", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper: Bottom Nav Item ---
  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == "Dashboard") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (label == "Your Profile") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (label == "Setting") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        } else if (label == "Schedule") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScheduleScreen()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? Colors.cyan : Colors.grey,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.cyan : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget: Header Stat Item ---
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final double percent;

  const _StatItem({
    required this.label,
    required this.value,
    required this.percent
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

// --- Widget: Big Menu Card ---
class _MenuCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFB0C9D9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                iconPath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}