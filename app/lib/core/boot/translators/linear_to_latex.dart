import '../../copilot/copilot_context.dart';
import '../intent_parser.dart';

class LinearToLatexTranslator {
  DerivedFile? translate(
    BootIntent intent,
    CopilotContext context,
  ) {
    final text = intent.raw.toLowerCase();

    if (!_looksLikeLatex(text)) return null;

    final buffer = StringBuffer();

    buffer.writeln(r'\begin{align}');

    if (text.contains('x^2') || text.contains('x²')) {
      buffer.writeln(r'f(x) = x^2');
    }

    if (text.contains('derivada')) {
      buffer.writeln(r'\frac{d}{dx} f(x)');
    }

    if (text.contains('integral')) {
      buffer.writeln(r'\int f(x)\,dx');
    }

    if (text.contains('círculo')) {
      buffer.writeln(r'x^2 + y^2 = r^2');
    }

    buffer.writeln(r'\end{align}');

    return DerivedFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      format: DerivedFormat.latex,
      content: buffer.toString(),
      sourceId: 'boot',
    );
  }

  bool _looksLikeLatex(String text) {
    return text.contains('latex') ||
        text.contains('equação') ||
        text.contains('equacao') ||
        text.contains('f(x)') ||
        text.contains('derivada') ||
        text.contains('integral');
  }
}
