import 'package:web_socket_client/web_socket_client.dart' as ws;

bool isWebSocketConnected(ws.ConnectionState state) =>
    state is ws.Connected || state is ws.Reconnected;

bool isWebSocketConnecting(ws.ConnectionState state) =>
    state is ws.Connecting || state is ws.Reconnecting;
