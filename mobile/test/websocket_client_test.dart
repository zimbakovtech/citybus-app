import 'dart:io';

import 'package:citybus/core/errors/failures.dart';
import 'package:citybus/core/network/websocket_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'connection failure surfaces as a typed stream error, not a crash',
    () async {
      // bind and immediately release a port so connecting to it is refused
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = server.port;
      await server.close();

      final socket = RealtimeSocket(url: 'ws://127.0.0.1:$port/ws/realtime');
      await expectLater(socket.messages, emitsError(isA<NetworkFailure>()));
      socket.close();
    },
  );
}
