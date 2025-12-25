import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final String planName; // e.g., "MORNING", "WEIGHT", "BEGINNER"

  const WorkoutDetailsScreen({super.key, required this.planName});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  // --- TIMER LOGIC ---
  int _seconds = 0;
  Timer? _timer;
  bool _isTimerRunning = false;

  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // --- DATA MAPPING ---
  final Map<String, List<Map<String, dynamic>>> _workoutData = {
    // 1. DASHBOARD PLAN: MORNING
    "MORNING": [
      {"name": "Sun Salutation", "sets": "5 mins warm up", "image": "assets/images/exercise.png", "isDone": false},
      {"name": "Downward Dog", "sets": "3 sets x 30 sec", "image": "assets/images/exercise.png", "isDone": false},
      {"name": "Child's Pose", "sets": "3 sets x 1 min", "image": "assets/images/exercise.png", "isDone": false},
    ],
    // 2. DASHBOARD PLAN: WEIGHT TRAINING
    "WEIGHT": [
      {"name": "Bench Press", "sets": "4 sets x 12 reps", "image": "assets/images/push-up.png", "isDone": false},
      {"name": "Deadlift", "sets": "4 sets x 10 reps", "image": "assets/images/body-weight.png", "isDone": false},
      {"name": "Shoulder Press", "sets": "3 sets x 12 reps", "image": "assets/images/push-up.png", "isDone": false},
    ],
    // 3. REGULAR PLANS
    "BEGINNER": [
      {"name": "Jumping Jacks", "sets": "3 sets x 30 sec", "image": "assets/images/jumping-jack.png", "isDone": false},
      {"name": "High Knees", "sets": "3 sets x 30 sec", "image": "assets/images/exercise.png", "isDone": false},
      {"name": "Push Ups", "sets": "3 sets x 10 reps", "image": "assets/images/push-up.png", "isDone": false},
    ],
    "INTERMEDIATE": [
      {"name": "Burpees", "sets": "3 sets x 12 reps", "image": "assets/images/burpees.png", "isDone": false},
      {"name": "Squat Jumps", "sets": "3 sets x 15 reps", "image": "assets/images/exercise.png", "isDone": false},
      {"name": "Push Ups", "sets": "3 sets x 15 reps", "image": "assets/images/push-up.png", "isDone": false},
    ],
    "ADVANCED": [
      {"name": "Pull Ups", "sets": "3 sets x 12 reps", "image": "assets/images/body-weight.png", "isDone": false},
      {"name": "Pistol Squats", "sets": "3 sets x 8 reps", "image": "assets/images/pistol.png", "isDone": false},
      {"name": "Diamond Push Ups", "sets": "4 sets x 20 reps", "image": "assets/images/push-up.png", "isDone": false},
    ],
  };

  List<Map<String, dynamic>> currentExercises = [];

  @override
  void initState() {
    super.initState();
    // Logic: Grab the first word of the plan name to find the key
    // e.g. "MORNING YOGA" -> "MORNING"
    // e.g. "BEGINNER: CARDIO" -> "BEGINNER"
    String key = widget.planName.toUpperCase().split(" ")[0].replaceAll(":", "");

    // Safety check: If key doesn't exist, default to Beginner
    if (!_workoutData.containsKey(key)) {
      key = "BEGINNER";
    }
    currentExercises = _workoutData[key]!;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(
              'assets/images/back_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          widget.planName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- TIMER CARD ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF152A45).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Session Timer", style: TextStyle(color: Colors.white70)),
                        Text(
                          _formatTime(_seconds),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "monospace",
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _toggleTimer,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: _isTimerRunning ? Colors.redAccent : Colors.cyan,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isTimerRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // --- EXERCISE LIST ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: currentExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = currentExercises[index];
                    final bool isDone = exercise["isDone"];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/grey_buttion.png'),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          leading: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              exercise["image"],
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: Text(
                            exercise["name"],
                            style: TextStyle(
                              color: isDone ? Colors.green : Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(
                            exercise["sets"],
                            style: TextStyle(color: Colors.black.withValues(alpha: 0.6)),
                          ),
                          trailing: Checkbox(
                            value: isDone,
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            onChanged: (bool? value) {
                              setState(() {
                                exercise["isDone"] = value;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- FINISH BUTTON ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Workout Saved!"), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/buuton.png'),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Finish Workout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}