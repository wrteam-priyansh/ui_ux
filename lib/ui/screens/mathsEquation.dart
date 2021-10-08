import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MathsEquation extends StatelessWidget {
  MathsEquation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String equation = r"$a=3\sqrt{4}$";

    return Scaffold(
      body: Center(
          child: TeXView(
        renderingEngine: TeXViewRenderingEngine.mathjax(),
        child: TeXViewDocument(
          "$equation",
          style: TeXViewStyle(textAlign: TeXViewTextAlign.Center, backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        ),
      )),
    );
  }
}
//Uri.dataFromString('<html><body>hello world</body></html>', mimeType: 'text/html').toString()