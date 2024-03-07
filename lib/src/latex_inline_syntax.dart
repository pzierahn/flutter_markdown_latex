import 'package:markdown/markdown.dart';

const _latexPattern = r'\$\$(.+?)\$\$|\\\[(.+?)\\\]|\$(.+?)\$|\((.+?)\)';

class LatexInlineSyntax extends InlineSyntax {
  LatexInlineSyntax() : super(_latexPattern);

  @override
  bool onMatch(InlineParser parser, Match match) {
    String? equation;
    String? mathStyle;

    for (int inx = 1; inx <= match.groupCount; inx++) {
      equation = match.group(inx);

      if (equation != null) {
        equation = equation.trim();

        // If the equation is wrapped in double dollar signs, it is a display equation
        mathStyle = (inx == 1) ? 'display' : 'inline';

        break;
      }
    }

    if (equation == null) {
      return false;
    }

    final element = Element.text('latex', equation);
    element.attributes['MathStyle'] = mathStyle!;
    parser.addNode(element);

    return true;
  }
}
