import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Constants ────────────────────────────────────────────────────────────────
const kNavy   = Color(0xFF1A2D5A);
const kBgGrey = Color(0xFFF0F3FA);
const kBorder = Color(0xFFDDE2EF);
const kGrey   = Color(0xFF9AA3B8);
const kBubbleIn = Color(0xFFEEF1FA);

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    ));

// ─── Message Model ────────────────────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// ─── Chat Page ────────────────────────────────────────────────────────────────
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: "Hello, I'm Dr. Rahman. How can I help you today?",
      isMe: false,
      time: '15:42PM',
    ),
    const ChatMessage(
      text: "Hi Doctor, I've been having a sore throat and slight fever for the past 3 days.",
      isMe: true,
      time: '15:42PM',
    ),
    const ChatMessage(
      text: 'I see. Do you have any other symptoms like cough, body ache, or difficulty swallowing?',
      isMe: false,
      time: '15:42PM',
    ),
    const ChatMessage(
      text: 'Yes, I have a mild dry cough and a bit of pain while swallowing.',
      isMe: true,
      time: '15:42PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final h = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr = '$h:$m$period';

    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true, time: timeStr));
    });

    _inputController.clear();
    _focusNode.requestFocus();

    // Give the list time to render then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(child: _buildMessageList()),
          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kNavy,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: kNavy,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      leading: GestureDetector(
        onTap: () => Navigator.maybePop(context),
        child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
      ),
      title: Row(
        children: [
          // Avatar circle
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(.18),
              border: Border.all(
                  color: Colors.white.withOpacity(.35), width: 1.5),
            ),
            child: const Icon(Icons.person_outline_rounded,
                color: Colors.white70, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'Student Name',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  // ─── Message List ─────────────────────────────────────────────────────────
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _MessageBubble(message: _messages[i]),
    );
  }

  // ─── Input Bar ────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: kBgGrey,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: kBorder),
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                style: const TextStyle(fontSize: 13, color: kNavy),
                decoration: const InputDecoration(
                  hintText: 'Tye Message',
                  hintStyle: TextStyle(color: kGrey, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  isDense: true,
                ),
                onSubmitted: (_) => _sendMessage(),
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kNavy,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble Widget ────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: message.isMe ? _buildOutgoing() : _buildIncoming(),
      ),
    );
  }

  List<Widget> _buildIncoming() => [
        // Avatar
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBorder,
            border: Border.all(color: const Color(0xFFD4D9EA)),
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: kGrey, size: 16),
        ),
        // Bubble + time
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: const BoxDecoration(
                    color: kBubbleIn,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0F1A2D5A),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                        fontSize: 13,
                        color: kNavy,
                        height: 1.55),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    message.time,
                    style: const TextStyle(fontSize: 10, color: kGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ];

  List<Widget> _buildOutgoing() => [
        // Bubble + time
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 11),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0F1A2D5A),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Text(
                    message.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13,
                        color: kNavy,
                        height: 1.55),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Text(
                    message.time,
                    style: const TextStyle(fontSize: 10, color: kGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Avatar
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBorder,
            border: Border.all(color: const Color(0xFFD4D9EA)),
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: kGrey, size: 16),
        ),
      ];
}