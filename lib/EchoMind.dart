import 'package:flutter/material.dart';
import 'custom_side_menu.dart';

class EchoMind extends StatefulWidget {
  const EchoMind({Key? key}) : super(key: key);
  static const id = "EchoMind";

  @override
  State<EchoMind> createState() => _EchoMindState();
}

class _EchoMindState extends State<EchoMind> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool showChat = false;

  final List<Map<String, dynamic>> messages = [
    {"sender": "bot", "text": "Hi there! I'm Echo Mind. How can I help you today? 💬"},
  ];

  late AnimationController _animationController;
  late Animation<double> _robotAnimation;
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat(reverse: true);

    _robotAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutQuad),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    _textAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": input});
      _controller.clear();
      messages.add({"sender": "bot", "widget": const PulsingCircle()}); // pulsing indicator
    });
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.removeLast(); // remove PulsingCircle
        messages.add({"sender": "bot", "text": _generateBotReply(input)});
      });
      _scrollToBottom();
    });
  }

  String _generateBotReply(String input) {
    input = input.toLowerCase();

    if (input.contains("stressed") || input.contains("work")) {
      return "Work stress can be overwhelming. Try taking a few deep breaths and prioritizing one small task. 🌿";
    } else if (input.contains("overwhelmed")) {
      return "It’s okay to feel overwhelmed. Give yourself permission to pause, even for a few minutes. You’re doing great. 💜";
    } else if (input.contains("can't sleep") || input.contains("sleep")) {
      return "Trouble sleeping is common when your mind is busy. Try writing your thoughts down or doing a short breathing exercise. 😴";
    } else if (input.contains("sad") || input.contains("down")) {
      return "I’m sorry you’re feeling this way. Remember, it’s okay to have bad days. You're not alone. 💛";
    } else if (input.contains("anxious") || input.contains("panic")) {
      return "Anxiety can feel heavy. Ground yourself with 5-4-3-2-1: 5 things you see, 4 you can touch, 3 you hear, 2 you smell, 1 you taste. 🧘";
    } else if (input.contains("happy") || input.contains("great")) {
      return "That’s wonderful to hear! Keep holding onto that positivity. 🌟";
    } else if (input.contains("thanks") || input.contains("thank you")) {
      return "You’re very welcome. You’re doing better than you think. 🌈";
    } else {
      return "Tell me more about how you’re feeling. I’m here to listen. 💬";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomSideMenu(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF734F7C),
                  Color(0xFFA272A9),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState?.openDrawer();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textAnimation.value,
                              child: Transform.scale(
                                scale: _textAnimation.value,
                                child: const Text(
                                  "Meet the\nEcho Mind!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _robotAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _robotAnimation.value),
                              child: Container(
                                width: 250,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/robot.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Meet MindSync Chatbot: Powered by AI for Emotional Support",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 15),
                        AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white,
                                    Colors.white.withOpacity(0.3),
                                  ],
                                  stops: [
                                    _shimmerAnimation.value - 0.3,
                                    _shimmerAnimation.value,
                                    _shimmerAnimation.value + 0.3,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds);
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showChat = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D3E6A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  elevation: 5,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.arrow_forward, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat Popup
          if (showChat)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 320,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/robot.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Echo Mind",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showChat = false;
                            });
                          },
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Messages
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isUser = msg["sender"] == "user";
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser ? const Color(0xFF734F7C) : const Color(0xFFE9D7F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: msg.containsKey("widget")
                                  ? msg["widget"]
                                  : Text(
                                      msg["text"] ?? "",
                                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Type something...",
                              filled: true,
                              fillColor: const Color(0xFFF1E6F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: Color(0xFF734F7C)),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 🔵 ChatGPT-like pulsing loading circle
class PulsingCircle extends StatefulWidget {
  const PulsingCircle({Key? key}) : super(key: key);

  @override
  _PulsingCircleState createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<PulsingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF734F7C),
              ),
            ),
          ),
        );
      },
    );
  }
}
