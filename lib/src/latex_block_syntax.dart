import 'package:markdown/markdown.dart';

class LatexBlockSyntax extends BlockSyntax {
  LatexBlockSyntax() : super();

  /// Latex block start patterns.
  @override
  RegExp get pattern => RegExp(
        r'^\${1,2}$|^\\\[$',
        multiLine: true,
      );

  /// Map of start and end symbols for latex blocks.
  // ignore:
  static const _blockSymbols = <String, String>{
    '\\[': '\\]',
    '\\(': '\\)',
    '\$': '\$',
  };

  @override
  List<Line> parseChildLines(BlockParser parser) {
    final lines = <Line>[];

    String startSymbol = '';
    String endSymbol = '';

    while (!parser.isDone) {
      final content = parser.current.content;
      if (endSymbol == content) {
        // Reached end of latex block
        parser.advance();
        break;
      }

      if (startSymbol.isEmpty) {
        // Begin of latex block
        startSymbol = content;
        endSymbol = _blockSymbols[startSymbol] ?? '';
      } else {
        // Inside latex block
        lines.add(parser.current);
      }

      // Advance to next line
      parser.advance();
    }

    return lines;
  }

  @override
  Node parse(BlockParser parser) {
    final lines = parseChildLines(parser);
    final content = lines.map((e) => e.content).join('\n').trim();
    final textElement = Element.text('latex', content);
    textElement.attributes['MathStyle'] = 'display';

    return Element('p', [textElement]);
  }
}
