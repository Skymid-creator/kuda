import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'registration_controller.dart';
import 'relationship_preference_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen>
    with SingleTickerProviderStateMixin {
  final RegistrationController _registrationController = Get.find<RegistrationController>();
  final TextEditingController _heightController = TextEditingController();
  final Map<String, String> _personalityAnswers = {};

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  // Define personality questions as a static const for better memory usage
  static const List<Map<String, dynamic>> _personalityQuestions = [
    {
      'id': 'q1',
      'question': 'Are you more introverted or extroverted?',
      'options': ['Introverted', 'Extroverted', 'Ambiverted'],
    },
    {
      'id': 'q2',
      'question': 'Do you prefer planning or spontaneity?',
      'options': ['Planning', 'Spontaneity', 'A mix of both'],
    },
    {
      'id': 'q3',
      'question': 'In social situations, I tend to be',
      'options': [
        'Outgoing and talkative',
        'Reserved and observant',
        'Somewhere in between'
      ],
    },
    {
      'id': 'q4',
      'question': 'When faced with a challenge, I usually',
      'options': [
        'Analyze and strategize',
        'Take action immediately',
        'Seek advice from others'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize personality answers map
    for (var question in _personalityQuestions) {
      _personalityAnswers[question['id']] = '';
    }

    // Initialize height controller with existing value if available
    if (_registrationController.height.value.isNotEmpty) {
      _heightController.text = _registrationController.height.value;
    }

    // Setup animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    // Add listener to scroll controller to trigger rebuilds on scroll
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextScreen() {
    // Validate height input
    if (_heightController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your height.');
      return;
    }

    // Validate all questions answered
    if (_personalityAnswers.values.any((answer) => answer.isEmpty)) {
      _showErrorSnackBar('Please answer all personality questions.');
      return;
    }

    // Save data and navigate
    _registrationController.updatePersonalDetails(
      _heightController.text.trim(),
      _personalityAnswers,
    );

    Get.to(() => const RelationshipPreferencesScreen());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  double _calculateAnimationValue(BuildContext context, int index) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return 0.0;

    final position = box.localToGlobal(Offset.zero);
    final itemTop = position.dy;
    final screenHeight = MediaQuery.of(context).size.height;
    final scrollPosition = _scrollController.hasClients ? _scrollController.offset : 0.0;
    final visibleHeight = screenHeight - itemTop + scrollPosition;

    // Calculate animation value based on visibility
    return (visibleHeight / screenHeight * 2).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Details"),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            controller: _scrollController,
            clipBehavior: Clip.none,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildHeightInput(theme),
              const SizedBox(height: 30),
              const Text(
                "Personality Snapshot",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._buildPersonalityQuestions(theme),
              const SizedBox(height: 30),
              _buildContinueButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Text(
          "Tell Us More About You",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'LoveDays',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "These details will help us find better matches for you.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHeightInput(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _heightController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Your Height (cm)',
          prefixIcon: Icon(Icons.height),
          border: InputBorder.none,
        ),
      ),
    );
  }

  List<Widget> _buildPersonalityQuestions(ThemeData theme) {
    return _personalityQuestions.asMap().entries.map((entry) {
      final index = entry.key;
      final question = entry.value;

      return LayoutBuilder(
          builder: (context, _) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final itemAnimationValue = _calculateAnimationValue(context, index);

                return Transform.scale(
                  scale: 0.8 + (0.2 * itemAnimationValue),
                  child: Opacity(
                    opacity: itemAnimationValue,
                    child: child,
                  ),
                );
              },
              child: _buildQuestionCard(theme, question),
            );
          }
      );
    }).toList();
  }

  Widget _buildQuestionCard(ThemeData theme, Map<String, dynamic> question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['question'], style: const TextStyle(fontSize: 16)),
          ...(question['options'] as List<String>).map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _personalityAnswers[question['id']],
              onChanged: (value) {
                setState(() {
                  _personalityAnswers[question['id']] = value!;
                });
              },
              activeColor: theme.colorScheme.primary,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildContinueButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _nextScreen,
      style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          elevation: 5
      ),
      child: const Text(
          "Continue",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
    );
  }
}