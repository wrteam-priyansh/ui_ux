import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MathsEquation extends StatelessWidget {
  const MathsEquation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TeXView(
          renderingEngine: TeXViewRenderingEngine.mathjax(),
          child: TeXViewDocument(
            r"""$${\tanθ=\frac{\sinθ}{\cosθ}}$$""",
            style: TeXViewStyle(textAlign: TeXViewTextAlign.Center, backgroundColor: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ),
    );
  }
}
