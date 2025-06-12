import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../providers/camera_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final player = Player();
  late final controller = VideoController(player);
  bool _connected = false;

  Future<void> _connect() async {
    final cam = ref.read(cameraControlProvider);
    await cam.connect();
    await cam.startSession();
    await player.open(Media('rtsp://192.168.88.1/livestream/12'));
    setState(() => _connected = true);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4K Cam – RTSP')),
      body: Column(
        children: [
          Expanded(child: Video(controller: controller)),
          ElevatedButton(
            onPressed: _connected ? null : _connect,
            child: const Text('Conectar'),
          ),
        ],
      ),
    );
  }
}
