import 'dart:io';
import 'src/server/server.dart';

main() {
  Server server = new Server(InternetAddress.LOOPBACK_IP_V4, 1337)..run();
}
