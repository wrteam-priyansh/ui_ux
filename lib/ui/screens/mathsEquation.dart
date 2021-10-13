import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class MathsEquation extends StatelessWidget {
  MathsEquation({Key? key}) : super(key: key);

  Future<String> getEquations() async {
    try {
      return "<p><span class=\"math-tex\">\$\$x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}\$\$</span></p>\r\n";
      //print("In math equation");
      //final result = await http.post(Uri.parse("http://math.mirzapar.com/api.php/get_question"), body: {"get_question": "1"});
      //print(result.body);
      //final jsonResult = json.decode(result.body);

      //return (jsonResult['data'] as List).first['question'];
    } catch (e) {
      throw Exception("Unable to load question");
    }
  }

  @override
  Widget build(BuildContext context) {
    String equation = "<p><span class=\"math-tex\">\$\$x = {-b \\pm \\sqrt{b^2-4ac} \\over 2a}\$\$</span></p>\r\n";

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(border: Border.all()),
          height: MediaQuery.of(context).size.height * (0.5),
          child: TeXView(
            child: TeXViewDocument(equation),
            style: TeXViewStyle(backgroundColor: Theme.of(context).scaffoldBackgroundColor, sizeUnit: TeXViewSizeUnit.Pixels, fontStyle: TeXViewFontStyle(fontSize: 25)),
          ),
        ),
      ),
    );
  }
}
