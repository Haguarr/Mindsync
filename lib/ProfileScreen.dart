import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const id = "ProfileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, String> _userData = {};
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _simulateFirebaseFetch();
  }

  void _simulateFirebaseFetch() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _userData = {
          'Full Name': 'Haguar El Mallawany',
          'Birthday': 'October 15, 2003',
          'Gender': 'Female',
          'Favourites': 'Meditation, Journaling, Music',
          'Settings': 'Notifications On, Light Mode',
        };
        _isLoading = false;
        _controller.forward();
      });
    }
  }

  void _toggleTheme(bool darkMode) {
    setState(() {
      _themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _userData['Full Name']);
    final favouritesController = TextEditingController(text: _userData['Favourites']);
    String selectedGender = _userData['Gender'] ?? 'Female';
    DateTime selectedDate = DateFormat('MMMM d, yyyy').parse(_userData['Birthday'] ?? 'October 15, 2003');
    bool notificationsOn = _userData['Settings']?.contains('Notifications On') ?? true;
    bool darkMode = _themeMode == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.deepPurple),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        SizedBox(width: 36),
                      ],
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          prefixIcon: Icon(Icons.cake, color: Colors.deepPurple),
                        ),
                        child: Text(DateFormat('MMMM d, yyyy').format(selectedDate)),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.transgender, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: selectedGender,
                                onChanged: (value) => setModalState(() => selectedGender = value!),
                                activeColor: Colors.deepPurple,
                              ),
                              Text('Male'),
                              Radio<String>(
                                value: 'Female',
                                groupValue: selectedGender,
                                onChanged: (value) => setModalState(() => selectedGender = value!),
                                activeColor: Colors.deepPurple,
                              ),
                              Text('Female'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: favouritesController,
                      decoration: InputDecoration(
                        labelText: 'Favourites',
                        prefixIcon: Icon(Icons.star, color: Colors.deepPurple),
                      ),
                    ),
                    SwitchListTile(
                      value: notificationsOn,
                      onChanged: (value) => setModalState(() => notificationsOn = value),
                      title: Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('Notifications'),
                        ],
                      ),
                    ),
                    SwitchListTile(
                      value: darkMode,
                      onChanged: (value) => setModalState(() => darkMode = value),
                      title: Row(
                        children: [
                          Icon(Icons.dark_mode, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(darkMode ? 'Dark Mode' : 'Light Mode'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          _userData['Full Name'] = nameController.text;
                          _userData['Birthday'] = DateFormat('MMMM d, yyyy').format(selectedDate);
                          _userData['Gender'] = selectedGender;
                          _userData['Favourites'] = favouritesController.text;
                          _userData['Settings'] = '${notificationsOn ? 'Notifications On' : 'Notifications Off'}, ${darkMode ? 'Dark Mode' : 'Light Mode'}';
                          _themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _themeMode == ThemeMode.dark
                  ? [Colors.black87, Colors.grey[900]!, Colors.black54]
                  : [Color(0xFF5A2E6E), Color(0xFF8B5FBF), Color(0xFFD3A8E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 24),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/images/profile.png'),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _userData['Full Name'] ?? '',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 6),
                          Text('Member since 2025', style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 24),
                          _buildInfoRow('Full Name', _userData['Full Name'] ?? '', Icons.person),
                          _buildInfoRow('Birthday', _userData['Birthday'] ?? '', Icons.cake),
                          _buildInfoRow('Gender', _userData['Gender'] ?? '', Icons.transgender),
                          _buildInfoRow('Favourites', _userData['Favourites'] ?? '', Icons.star),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.dark_mode, color: Colors.white),
                              Switch(
                                value: _themeMode == ThemeMode.dark,
                                onChanged: _toggleTheme,
                                activeColor: Colors.deepPurpleAccent,
                              ),
                              Text(
                                _themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 218, 168, 219),
                    highlightColor: Color.fromARGB(255, 166, 126, 179),
                    period: Duration(seconds: 2),
                    child: FloatingActionButton(
                      onPressed: _editProfile,
                      backgroundColor: Color.fromARGB(255, 233, 229, 238),
                      shape: CircleBorder(),
                      child: Icon(Icons.edit, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_themeMode == ThemeMode.dark ? 0.1 : 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (_themeMode != ThemeMode.dark)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: _themeMode == ThemeMode.dark ? Colors.white70 : Color(0xFF5A2E6E), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 12,
                        color: _themeMode == ThemeMode.dark ? Colors.white70 : Colors.grey[600])),
                Text(value,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _themeMode == ThemeMode.dark ? Colors.white : Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}