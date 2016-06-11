import 'dart:io';

import '../router/router.dart';

class Server {
  final InternetAddress _hostname;
  final int _port;
  HttpServer _server;
  Router router;

  Server(InternetAddress hostname, int port)
      : _hostname = hostname,
        _port = port {
    router = new Router(new File(Platform.script.toFilePath()).parent.parent.path + '/web');
  }

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

    await for (var request in _server) {
      router.handleRequest(request);
    }
  }

  _setupServer() {
    try {
      return HttpServer.bind(this._hostname, this._port);
    } catch (e) {
      print(e);
      exit(-1);
    }
  }
}
