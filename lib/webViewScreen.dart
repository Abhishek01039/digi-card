import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: 'https://www.google.com/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
