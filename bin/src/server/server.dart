import 'dart:io';

import '../router/router.dart';

class Server {
  final InternetAddress _hostname;
  final int _port;
  HttpServer _server;
  Router _router;

  Server(InternetAddress hostname, int port)
      : _hostname = hostname,
        _port = port;

  get hostname {
    return _hostname;
  }

  get port {
    return _port;
  }

  get server {
    return _server;
  }

  run() async {
    _server = await _setupServer();
    print("Serving at ${_server.address}:${_server.port}");
    _router.addRoute('/ws', () => _websocket);
    print(_router.routingPatterns);

    await for (var request in _server) {
      _router.handleRequest(request);
    }
  }

  _websocket() {
  }

  _setupServer() {
    try {
      _router = new Router(new File(Platform.script.toFilePath()).parent.parent.path + '/web');
      return HttpServer.bind(this._hostname, this._port);
    } catch (e) {
      print(e);
      exit(-1);
    }
  }
}
