import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MathsEquation extends StatelessWidget {
  const MathsEquation({Key? key}) : super(key: key);

  final String equation = r"\[\tanθ=\frac{\cosθ}{\sinθ​}\]";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TeXView(
        renderingEngine: TeXViewRenderingEngine.mathjax(),
        child: TeXViewDocument(
          r"$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$",
          style: TeXViewStyle(textAlign: TeXViewTextAlign.Center, backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        ),
      )),
    );
  }
}
//Uri.dataFromString('<html><body>hello world</body></html>', mimeType: 'text/html').toString()