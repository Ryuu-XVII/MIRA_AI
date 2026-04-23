import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import 'dart:js' as js;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MiraSystemState(),
      child: const MiraFlutterApp(),
    ),
  );
}

class MiraFlutterApp extends StatelessWidget {
  const MiraFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIRA_SYSTEM_OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Start polling bridge status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MiraSystemState>().startPolling();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          ControlDeck(),
          Expanded(child: MainSoulViewport()),
          NeuralFeedSidebar(),
        ],
      ),
    );
  }
}

// --- 1. LEFT: Control Deck ---
class ControlDeck extends StatelessWidget {
  const ControlDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(right: BorderSide(color: Color(0xFF222222), width: 1)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHudHeader('SYSTEM MONITOR'),
          const SizedBox(height: 24),
          _buildTelemetryRow('CPU_CORE', '12_ACTIVE'),
          _buildTelemetryRow('THR_LOAD', 'OPTIMAL', color: Colors.greenAccent),
          _buildTelemetryRow('LATENCY', '140ms'),
          _buildTelemetryRow('BUFFER', 'PIPELINED', color: const Color(0xFFFFC000)),
          const Spacer(),
          _buildCriticalZone(context),
          const SizedBox(height: 24),
          _buildSensorStatus(),
        ],
      ),
    );
  }

  Widget _buildHudHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF333333))),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFC000),
          letterSpacing: 2,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value, {Color color = Colors.white54}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'monospace')),
          Text(value, style: TextStyle(color: color, fontSize: 10, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildCriticalZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CRITICAL_CONTROLS', style: TextStyle(color: Colors.redAccent, fontSize: 8, letterSpacing: 1)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.read<MiraSystemState>().shutdown(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
              ),
              child: const Text('SHUTDOWN_KRNL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorStatus() {
    return Consumer<MiraSystemState>(
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SENSOR_LINK', style: TextStyle(color: Colors.white10, fontSize: 8, letterSpacing: 1)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: const Color(0xFF222222)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              state.status == 'speaking' ? '> RECORDING_ACTIVE...' : '> SCANNING_ENV...',
              style: const TextStyle(color: Colors.white24, fontSize: 9, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. CENTER: Main Soul Viewport ---
class MainSoulViewport extends StatelessWidget {
  const MainSoulViewport({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: SoulOrbVisualization()),
        Positioned(
          bottom: 40,
          left: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MIRA_V0.1.0_PROTOTYPE',
                style: TextStyle(color: const Color(0xFFFFC000).withOpacity(0.8), letterSpacing: 2, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'SECURE_CONNECTION_ESTABLISHED // TARGET: WEB_PLATFORM',
                style: TextStyle(color: Colors.white10, fontSize: 8, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SoulOrbVisualization extends StatefulWidget {
  const SoulOrbVisualization({super.key});

  @override
  State<SoulOrbVisualization> createState() => _SoulOrbVisualizationState();
}

class _SoulOrbVisualizationState extends State<SoulOrbVisualization> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MiraSystemState>(
      builder: (context, state, _) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: OrbPainter(_controller.value, state.status == 'thinking'),
        ),
      ),
    );
  }
}

class OrbPainter extends CustomPainter {
  final double animationValue;
  final bool isThinking;
  OrbPainter(this.animationValue, this.isThinking);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFFFFC000).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw HUD Rings
    for (int i = 1; i <= 3; i++) {
      double radius = 100.0 * i + (math.sin(animationValue * math.pi * 2 + i) * 10);
      canvas.drawCircle(center, radius, paint);
    }

    // Draw Particle Soul
    final particlePaint = Paint()
      ..color = const Color(0xFFFFC000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    int count = isThinking ? 100 : 50;
    for (int i = 0; i < count; i++) {
      double angle = (2 * math.pi / count) * i + (animationValue * math.pi * 2);
      double dist = 80 + math.sin(animationValue * 5 + i) * 20;
      if (isThinking) dist += math.Random().nextDouble() * 50;
      
      Offset p = center + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
      canvas.drawCircle(p, 2, particlePaint);
    }
  }

  @override
  bool shouldRepaint(OrbPainter oldDelegate) => true;
}

// --- 3. RIGHT: Neural Feed Sidebar ---
class NeuralFeedSidebar extends StatelessWidget {
  const NeuralFeedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(left: BorderSide(color: Color(0xFF222222), width: 1)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SidebarHeader(),
          const SizedBox(height: 24),
          const Expanded(child: MessageList()),
          const MessageInput(), // Added Input Field
          const SizedBox(height: 24),
          const SystemDiagnosticFooter(),
        ],
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    context.read<MiraSystemState>().sendMessage(_controller.text.trim());
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MiraSystemState>(
      builder: (context, state, _) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF050505),
          border: Border.all(color: const Color(0xFF222222)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                enabled: state.isReady && state.status != 'thinking',
                style: const TextStyle(fontSize: 12, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'TRANSMIT_DATA...',
                  hintStyle: TextStyle(color: Colors.white10, fontSize: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, size: 16, color: Color(0xFFFFC000)),
              onPressed: (state.isReady && state.status != 'thinking') ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MiraSystemState>(
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC000),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [BoxShadow(color: Color(0xFFFFC000), blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('MIRA_SYSTEM_OS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13)),
                ],
              ),
              const Text('NODE_01', style: TextStyle(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'CORE_STATUS: ${state.status.toUpperCase()}',
            style: const TextStyle(color: Color(0xFFFFC000), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          _buildBootstrapSection(state),
        ],
      ),
    );
  }

  Widget _buildBootstrapSection(MiraSystemState state) {
    if (state.isReady) {
      return Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.white.withOpacity(0.05))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('NEURAL_LINK_ACTIVE', style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('ENCRYPTION: AES-256-GCM', style: TextStyle(color: Colors.white10, fontSize: 8)),
          ],
        ),
      );
    }
    
    return ElevatedButton(
      onPressed: state.isInitializing ? null : () => state.initialize(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFC000),
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(
        state.isInitializing ? 'INITIALIZING...' : 'ESTABLISH_NEURAL_LINK',
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 11),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0, // Since we are using reverse: true, 0 is the bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MiraSystemState>(
      builder: (context, state, _) {
        // Scroll whenever messages change
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NEURAL_FEED_STREAM', style: TextStyle(color: Colors.white10, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF222222), height: 1),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true, // Newest at bottom
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final msg = state.messages[state.messages.length - 1 - index];
                  return MessageCard(msg: msg);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MessageCard extends StatelessWidget {
  final Map<String, dynamic> msg;
  const MessageCard({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final bool isMira = msg['role'] == 'assistant';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMira ? const Color(0xFF121212) : const Color(0xFF1A1A1A),
        border: Border.all(color: isMira ? const Color(0xFFFFC000).withOpacity(0.5) : const Color(0xFF222222)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${msg['role'].toString().toUpperCase()} // TSTAMP_SEQ',
            style: TextStyle(color: isMira ? const Color(0xFFFFC000) : Colors.white24, fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            msg['content'],
            style: TextStyle(color: isMira ? Colors.white : Colors.white60, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class SystemDiagnosticFooter extends StatelessWidget {
  const SystemDiagnosticFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        border: Border.all(color: const Color(0xFF111111)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Text(
        'SYSTEM_ID: MIRA_ALPHA_BETA_99\nENCRYPTION_LAYER: 7_SOLID\nLINK_STABILITY: 99.8%',
        style: TextStyle(color: Colors.white10, fontSize: 9, fontFamily: 'monospace', height: 1.6),
      ),
    );
  }
}

// --- 4. DATA & STATE MANAGEMENT ---
// --- RESTORING SENSORS (MIC/CAMERA) ---
class SensorService {
  html.VideoElement? _video;
  html.MediaStream? _stream;
  html.CanvasElement? _canvas;
  dynamic _recognition;
  String _lastFrame = "";

  String get lastFrame => _lastFrame;

  Future<void> startVision() async {
    try {
      _video ??= html.VideoElement();
      _stream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true});
      _video!.srcObject = _stream;
      _video!.play();
      
      _canvas = html.CanvasElement(width: 320, height: 240);
      
      // Periodic Capture
      Timer.periodic(const Duration(seconds: 2), (timer) {
        if (_stream == null) {
          timer.cancel();
          return;
        }
        _captureFrame();
      });
    } catch (e) {
      print("Vision Error: $e");
    }
  }

  void _captureFrame() {
    if (_video == null || _canvas == null) return;
    final ctx = _canvas!.context2D;
    ctx.drawImageScaled(_video!, 0, 0, 320, 240);
    _lastFrame = _canvas!.toDataUrl('image/jpeg', 0.5);
  }

  void startVoice(Function(String) onResult) {
    try {
      // Using JS interop for SpeechRecognition
      js.context.callMethod('eval', ["""
        window.startMiraSTT = function(callback) {
          var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
          if (!SpeechRecognition) return;
          var recognition = new SpeechRecognition();
          recognition.continuous = true;
          recognition.interimResults = false;
          recognition.onresult = function(event) {
            var text = event.results[event.results.length - 1][0].transcript;
            callback(text);
          };
          recognition.onend = function() { recognition.start(); }; // Keep alive
          recognition.start();
          window.miraRecognition = recognition;
        }
      """]);

      js.context.callMethod('startMiraSTT', [js.allowInterop(onResult)]);
    } catch (e) {
      print("Voice Error: $e");
    }
  }

  void stopAll() {
    _stream?.getTracks().forEach((t) => t.stop());
    js.context.callMethod('eval', ["window.miraRecognition && window.miraRecognition.stop()"]);
  }
}

class MiraSystemState extends ChangeNotifier {
  String _status = 'idle';
  final List<Map<String, dynamic>> _messages = [];
  bool _isInitializing = false;
  bool _isReady = false;
  final SensorService _sensors = SensorService();

  String get status => _status;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isInitializing => _isInitializing;
  bool get isReady => _isReady;

  final String bridgeUrl = 'http://localhost:3002';

  void startPolling() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final res = await http.get(Uri.parse('$bridgeUrl/status'));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          
          final bridgeStatus = data['status'] ?? 'idle';
          // Sync speaking state from bridge
          if (bridgeStatus == 'speaking') {
            _status = 'speaking';
          } else if (_status == 'speaking') {
             _status = 'idle';
          }
          
          _isReady = data['miraReady'] ?? false;
          notifyListeners();
        }
      } catch (e) {
        _status = 'offline';
        notifyListeners();
      }
    });
  }

  Future<void> initialize() async {
    _isInitializing = true;
    notifyListeners();
    try {
      await http.post(Uri.parse('$bridgeUrl/initialize'));
      
      // Start Sensors locally
      await _sensors.startVision();
      _sensors.startVoice((text) {
        sendMessage(text);
      });
      
    } catch (e) {
      _status = 'error';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> shutdown() async {
    try {
      _sensors.stopAll();
      await http.post(Uri.parse('$bridgeUrl/shutdown'));
    } catch (e) {
      // Offline
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Selective Vision: Only attach a frame if explicitly asked to "see/look/capture"
    final perceptionKeywords = ['look at', 'see me', 'describe what you see', 'vision mode', 'camera feed', 'identify this', 'what is this', 'am i holding'];
    bool shouldSendImage = perceptionKeywords.any((k) => text.toLowerCase().contains(k));

    Object content = text;
    if (shouldSendImage && _sensors.lastFrame.isNotEmpty) {
       content = [
         {'type': 'text', 'text': text},
         {'type': 'image_url', 'image_url': {'url': _sensors.lastFrame}}
       ];
    }
    _messages.add({'role': 'user', 'content': content});
    
    // Add empty Assistant Message to be filled by stream
    final assistantMsg = {'role': 'assistant', 'content': ''};
    _messages.add(assistantMsg);
    
    _status = 'thinking';
    notifyListeners();

    try {
      final request = http.Request('POST', Uri.parse('$bridgeUrl/chat'));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'messages': _messages.sublist(0, _messages.length - 1)});

      final response = await http.Client().send(request);
      
      if (response.statusCode == 200) {
        String accumulated = "";
        await for (var chunk in response.stream.transform(utf8.decoder)) {
          if (_status == 'thinking') _status = 'idle'; // Reset as soon as text flows
          accumulated += chunk;
          assistantMsg['content'] = accumulated;
          notifyListeners();
        }
      } else {
        assistantMsg['content'] = 'SYSTEM_ERROR: PACKET_LOSS.';
      }
    } catch (e) {
      assistantMsg['content'] = 'CRITICAL_ERROR: LINK_TERMINATED.';
    } finally {
      if (_status == 'thinking') _status = 'idle';
      notifyListeners();
    }
  }
}
