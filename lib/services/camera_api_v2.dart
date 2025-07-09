import 'dart:convert';
import 'dart:io';
import 'package:media_kit/media_kit.dart';
import 'camera_api.dart';

class CameraApiV2 implements CameraAPI {
  Socket? _socket;
  int _token = 0;
  final String host = '192.168.88.1';

  @override
  Future<void> connect() async {
    _socket = await Socket.connect(host, 7878);
    await _send({'msg_id': 257, 'token': 0});
    final response = await _recv();
    _token = response['token'] as int;

    await _send({'msg_id': 259, 'param': 'none', 'token': _token});
    await _recv();

    await _send({'msg_id': 268, 'type': 'live', 'token': _token});
    await _recv();
  }

  @override
  Future<void> startPreview(Player player) async {
    await player.open(
      Media(
        'rtsp://$host/livestream/12',
        extras: {'rtsp_transport': 'tcp'},
      ),
    );
  }

  @override
  Future<void> startRecord() async {
    await _send({'msg_id': 513, 'token': _token});
    await _recv();
  }

  @override
  Future<void> stopRecord() async {
    await _send({'msg_id': 514, 'token': _token});
    await _recv();
  }

  Future<void> _send(Map<String, dynamic> payload) async {
    final data = utf8.encode(jsonEncode(payload));
    _socket?.add(data);
    _socket?.add([0x0a]);
    await _socket?.flush();
  }

  Future<Map<String, dynamic>> _recv() async {
    final line = await _socket!
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first;
    return jsonDecode(line) as Map<String, dynamic>;
  }
}
