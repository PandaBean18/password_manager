import 'package:postgres/postgres.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void main() async {
  final String jsonString = await File('./database_params.json').readAsString();
  final params = json.decode(jsonString);
  final host = params['host'];
  final port = params['port'];
  final database = params['databaseName'];
  final username = params['username'];
  final password = params['password'];
  final createDatabaseQuery = "CREATE DATABASE password_manager;";

  // Connect to the PostgreSQL server
  var process = await Process.start(
      'psql', ['-h', host, '-p', port.toString(), '-U', username],
      runInShell: true, mode: ProcessStartMode.detached);
  sleep(const Duration(seconds: 2));

  simulateUserInput(password);

  sleep(Duration(seconds: 1));
  simulateUserInput(createDatabaseQuery);
  sleep(Duration(seconds: 2));
  simulateUserInput("\\q");
  sleep(Duration(seconds: 2));

  var connection = PostgreSQLConnection(
      params['host'], params['port'], params['databaseName'],
      username: params['username'], password: params['password']);
  await connection.open();

  try {
    await connection.query('''
    CREATE TABLE users(
      username VARCHAR(256), 
      password_digest VARCHAR(256)
    )
    ''');

    await connection.query('''
    CREATE TABLE user_data(
      platform_name VARCHAR(256), 
      password_digest VARCHAR(256)
    )
    ''');

    print('Database(s) created successfully. Exiting');
    exit(0);
  } catch (e) {
    print(e);
    exit(0);
  }
}

void simulateUserInput(String str) {
  int i = 0;
  final kbd = calloc<INPUT>();
  kbd.ref.type = INPUT_KEYBOARD;
  kbd.ref.ki.dwFlags = KEYEVENTF_UNICODE;

  while (i < str.length) {
    String c = str[i];

    kbd.ref.ki.wScan = c.codeUnitAt(0);
    var result = SendInput(1, kbd, sizeOf<INPUT>());
    if (result != TRUE) print('Error: ${GetLastError()}');

    i++;
  }

  kbd.ref.ki.wVk = VK_RETURN;
  var result = SendInput(1, kbd, sizeOf<INPUT>());
  if (result != TRUE) print('Error: ${GetLastError()}');

  free(kbd);
}
