import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// --- Import all navigation screens ---
import 'profile.dart';
import 'schedule.dart';
import 'settings.dart';
import 'notifications.dart';
import 'progress.dart';
import 'workout_details.dart'; // <--- Needed to open the workout

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- REAL DATA FOR GRAPH ---
  final List<double> weeklyActivity = [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.2];

  // --- LOGIC: Get Next Session based on Real Time ---
  Map<String, String> _getNextSession() {
    final now = DateTime.now();
    final int hour = now.hour;

    // Logic:
    // Before 10 AM -> Morning Yoga
    // 10 AM to 5 PM -> Weight Training
    // After 5 PM -> Rest
    if (hour < 10) {
      return {
        "time": "10:00 AM",
        "title": "Morning Yoga",
        "duration": "45 min session",
        "status": "UPCOMING"
      };
    } else if (hour < 17) {
      return {
        "time": "05:00 PM",
        "title": "Weight Training",
        "duration": "1 Hour session",
        "status": "UPCOMING"
      };
    } else {
      return {
        "time": "Tomorrow",
        "title": "Rest & Recovery",
        "duration": "Good Sleep",
        "status": "COMPLETED"
      };
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final sessionData = _getNextSession(); // Get real-time data

    return Scaffold(
      backgroundColor: const Color(0xFF0A1E35), // Dark Blue Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 10),
              height: 45,
              width: 45,
              child: Image.asset(
                'assets/images/notification_icon.png',
                fit: BoxFit.contain,
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
                    // --- Dynamic Date ---
                    Text(
                      _getTodayDate(),
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- CLICKABLE NEXT SESSION CARD ---
                    GestureDetector(
                      onTap: () {
                        // 1. Check status. If completed, just show a message.
                        if (sessionData["status"] == "COMPLETED") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Rest day! No more sessions today.")),
                          );
                          return;
                        }

                        // 2. Navigate to Workout Details with the Title (e.g., "Morning Yoga")
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailsScreen(planName: sessionData["title"]!),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF152A45),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    sessionData["status"] == "COMPLETED"
                                        ? "Next Session:"
                                        : "Next Session at",
                                    style: const TextStyle(color: Colors.white54, fontSize: 14)
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  sessionData["time"]!,
                                  style: TextStyle(
                                    color: sessionData["time"] == "Tomorrow" ? Colors.cyan : Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  sessionData["title"]!.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                        sessionData["duration"]!,
                                        style: const TextStyle(color: Colors.white54, fontSize: 14)
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 12),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- START TRAINING BUTTON ---
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/images/new_button.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'START YOUR TRAINING NOW',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- ACTIVITY GRAPH ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF152A45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your activity',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'This Week',
                                style: TextStyle(color: Colors.cyan, fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _ActivityGraph(data: weeklyActivity),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- BOTTOM NAVIGATION BAR ---
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF0A1E35),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, Icons.fitness_center, "Dashboard", true),
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

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (label == "Setting") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
        } else if (label == "Schedule") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScheduleScreen()));
        } else if (label == "Your Profile") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: isActive ? Colors.cyan : Colors.grey),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: isActive ? Colors.cyan : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActivityGraph extends StatelessWidget {
  final List<double> data;
  const _ActivityGraph({required this.data});

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 12,
                height: 100 * data[index],
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.cyan, Colors.blue],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                days[index],
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          );
        }),
      ),
    );
  }
}