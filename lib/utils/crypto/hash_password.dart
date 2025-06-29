import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert to bytes
  final hash = sha256.convert(bytes); // Hash using SHA-256
  return hash.toString();
}