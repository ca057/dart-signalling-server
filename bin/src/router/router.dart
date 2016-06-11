import 'dart:io';

class Router {
  String _baseDir;

  Router(String webDirectory) {
    if (webDirectory.isEmpty) {
      throw new ArgumentError('The passed webDirectory is empty.');
    }
    _baseDir = webDirectory;
  }

  get baseDirectory {
    return _baseDir;
  }

  set baseDirectory(String baseDirectory) {
    if (baseDirectory.isEmpty) {
      throw new ArgumentError('passed baseDirectory is empty');
    }
    _baseDir = baseDirectory;
  }

  handleRequest(HttpRequest req) async {
    String reqPath = req.uri.path;
    // check the path and what to do, if no pattern is matching, serve static files
    await _serveStaticFiles(req);
  }

  _serveStaticFiles(req) async {
    File file = new File(_baseDir + req.uri.path);
    if (await file.exists()) {
      _serveFile(req, file);
    } else {
      file = new File(file.path + "/index.html");
      if (await file.exists()) {
        _serveFile(req, file);
      } else {
        _fileNotFound(req);
      }
    }
  }

  _serveFile(HttpRequest req, File file) async {
    print("Serving ${await file.path}.");
    req.response.headers.contentType = ContentType.HTML;
    try {
      await file.openRead().pipe(req.response).then((req) => req.close());
    } catch (e) {
      print("Couldn't read file: $e");
      exit(-1);
    }
  }

  _fileNotFound(HttpRequest req) {
    req.response
      ..statusCode = HttpStatus.NOT_FOUND
      ..write('Sorry, can`t handle your request.')
      ..close();
  }
}
