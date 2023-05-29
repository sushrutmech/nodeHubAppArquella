

import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   TextEditingController _messageController = TextEditingController();
  WebSocketChannel? _channel;

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  void _connectToWebSocket() {
    final channel = IOWebSocketChannel.connect('ws://192.168.1.5:8080');
    setState(() {
      _channel = channel;
    });
  }

  void _disconnectWebSocket() {
    _channel?.sink.close();
    setState(() {
      _channel = null;
    });
  }

  void _sendMessage() {
    final message = {'message': _messageController.text};
     final jsonMessage = json.encode(message);
    print("for send mess $jsonMessage");
    _channel?.sink.add(jsonMessage);
    _messageController.clear();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Client'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter a message',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _channel != null ? _disconnectWebSocket : _connectToWebSocket,
              child: Text(_channel != null ? 'Disconnect' : 'Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
