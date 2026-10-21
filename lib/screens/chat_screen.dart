import 'package:flutter/material.dart';
import '../services/groq_service.dart';

class ChatScreen extends StatefulWidget {
  final double electricityUsage;
  final double carbonFootprint;

  const ChatScreen({
    super.key,
    required this.electricityUsage,
    required this.carbonFootprint,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<Map<String, String>> messages = [];

  void sendMessage() async {

    String userMessage = messageController.text.trim();

    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    messageController.clear();
    scrollToBottom();

    /// ✅ REAL-TIME DATA USED HERE
    String botReply = await GroqService.sendMessage(
      userMessage,
      widget.electricityUsage,
      widget.carbonFootprint,
    );

    setState(() {
      messages.add({"role": "bot", "text": botReply});
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget buildMessage(Map<String, String> message) {

    bool isUser = message["role"] == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message["text"]!,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Dwindle AI Assistant"),
        backgroundColor: Color(0xFF339966),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Ask about energy usage...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),

                SizedBox(width: 8),

                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF339966)),
                  onPressed: sendMessage,
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}