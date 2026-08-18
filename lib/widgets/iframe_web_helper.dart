// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

void registerIframeViewFactory(String viewId, String url) {
  final String cleanUrl = (url.startsWith('http://') || url.startsWith('https://'))
      ? url
      : 'https://$url';

  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int id) {
      final element = html.IFrameElement()
        ..src = cleanUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      return element;
    },
  );
}

Widget getIframeWebWidget(String viewId, String url) {
  registerIframeViewFactory(viewId, url);
  return HtmlElementView(viewType: viewId);
}
