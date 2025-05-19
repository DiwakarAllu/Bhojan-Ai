import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BhojanWebScreen extends StatefulWidget {
  const BhojanWebScreen({super.key});

  @override
  _BhojanWebScreenState createState() => _BhojanWebScreenState();
}

class _BhojanWebScreenState extends State<BhojanWebScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
          Uri.parse("https://cutiepi3-bhojan-ai.hf.space/?__theme=system"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Bhojan AI Web"), backgroundColor: Colors.teal),
      body: WebViewWidget(controller: _controller),
    );
  }
}
