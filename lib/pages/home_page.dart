import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../providers/camera_provider.dart';
import '../services/camera_api.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final player = Player();
  late final controller = VideoController(player);
  CameraAPI? api;
  bool _connected = false;

  Future<void> _connect() async {
    final result = await ref.read(cameraProvider.future);
    api = result;
    await api?.connect();
    await api?.startPreview(player);
    setState(() {
      _connected = true;
    });
  }

  Future<void> _startRecording() async {
    await api?.startRecord();
  }

  Future<void> _stopRecording() async {
    await api?.stopRecord();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4K Cam')),
      body: Column(
        children: [
          Expanded(
            child: Video(controller: controller),
          ),
          ElevatedButton(
            onPressed: _connected ? null : _connect,
            child: const Text('Conectar'),
          ),
          ElevatedButton(
            onPressed: !_connected ? null : _startRecording,
            child: const Text('Start Record'),
          ),
          ElevatedButton(
            onPressed: !_connected ? null : _stopRecording,
            child: const Text('Stop Record'),
          ),
        ],
      ),
    );
  }
}
