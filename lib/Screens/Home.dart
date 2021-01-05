import 'package:flutter/material.dart';
import 'package:hkview/Test.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hkview/data.dart';
import 'package:hkview/Widgets/widgets.dart';
import 'dart:async';
import 'dart:io';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>HkView Test</title></head>
<body>
<p>
WebView, youtube web sitesinde gezinmeyi engelleyecek şekilde ayarlanmıştır.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarVisible
          ? AppBar(
              title: appBarTitleWidget(),
              centerTitle: appBarTitleCenter,
              // Bu açılır menü, Flutter widget'larının web görünümü üzerinden gösterilebileceğini gösterir.
              actions: <Widget>[
                appBarNavigationControl
                    ? NavigationControls(_controller.future)
                    : Text(''),
                IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: null),
                debugMode
                    ? IconButton(
                        icon: Icon(Icons.pest_control),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestScreen()));
                        })
                    : Text(''),
              ],
            )
          : null,
      // Burada bir Oluşturucu kullanıyoruz, bu yüzden iskelenin altında bir bağlam var
      // iskele çağrısına izin vermek için.of (bağlam) böylece bir snackbar gösterebiliriz.
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: WebView(
            initialUrl: webUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[
              _toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('Navigasyon Engellendi! ($request})');
                return NavigationDecision.prevent;
              }
              debugPrint('İzin verilen Navigasyon ($request)');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              debugPrint('Sayfa yüklenmeye başladı: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Sayfa yükleme tamamlandı: $url');
            },
            gestureNavigationEnabled: true,
          ),
        );
      }),
      floatingActionButton: floatingButton ? favoriteButton() : null,
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favori : $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Geri geçmiş öğesi yok")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("İleri geçmiş öğesi yok")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
