import 'dart:convert';
import 'dart:io';

class CameraControl {
  Socket? _socket;
  int _token = 0;

  Future<void> connect() async {
    _socket = await Socket.connect('192.168.88.1', 7878, timeout: const Duration(seconds: 3));
  }

  Future<void> _send(Map<String, dynamic> json) async {
    final payload = utf8.encode(jsonEncode(json));
    _socket?.add(payload);
    _socket?.add([0x0a]);            // protocol uses newline terminator
    await _socket?.flush();
  }

  Future<Map<String, dynamic>> _recv() async {
    final line = await _socket!.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter()).first;
    return jsonDecode(line) as Map<String, dynamic>;
  }

  Future<void> startSession() async {
    await _send({'msg_id': 257, 'token': 0});
    _token = (await _recv())['token'] as int;

    await _send({'msg_id': 259, 'param': 'none', 'token': _token});
    await _recv(); // discard rval
  }

  Future<void> stopSession() async {
    await _send({'msg_id': 260, 'token': _token});
    await _recv();
    _socket?.destroy();
  }
}
