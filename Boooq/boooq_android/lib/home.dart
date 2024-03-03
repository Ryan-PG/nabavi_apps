import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controller;
  double webProgress = 0;

  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.green),
      // height: screenSafeAreaHeight,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: [
          WillPopScope(
            onWillPop: () => _goBack(context),
            child: Scaffold(
              body: Center(
                child: WebView(
                  initialUrl: 'https://boooq.ir',
                  // javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controllerCompleter.future
                        .then((value) => _controller = value);
                    _controllerCompleter.complete(webViewController);
                  },
                  onProgress: (progress) => setState(() {
                    webProgress = progress / 100;
                  }),
                ),
              ),
            ),
          ),
          webProgress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: webProgress,
                    color: Colors.green.shade100,
                    backgroundColor: Colors.green,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'میخوای از برنامه خارج بشی؟',
                  textDirection: TextDirection.rtl,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('نه'),
                  ),
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('آره'),
                  ),
                ],
              ));
      return Future.value(true);
    }
  }
}
