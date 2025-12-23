import '../../copilot/copilot_context.dart';
import '../intent_parser.dart';

class LinearToPlotTranslator {
  DerivedFile? translate(
    BootIntent intent,
    CopilotContext context,
  ) {
    final text = intent.raw.toLowerCase();

    // Heurística mínima e segura
    if (!_looksLikePlot(text)) return null;

    final function = _extractFunction(text) ?? 'x';
    final range = _extractRange(text) ?? [-10, 10];

    final code = _generatePythonPlot(
      function: function,
      min: range[0],
      max: range[1],
    );

    return DerivedFile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      format: DerivedFormat.analysis,
      content: code,
      sourceId: 'boot',
    );
  }

  bool _looksLikePlot(String text) {
    return text.contains('plot') ||
        text.contains('gráfico') ||
        text.contains('grafico') ||
        text.contains('curve') ||
        text.contains('função') ||
        text.contains('function');
  }

  String? _extractFunction(String text) {
    // Casos simples primeiro (extensível depois)
    if (text.contains('x^2') || text.contains('x²')) return 'x**2';
    if (text.contains('x^3')) return 'x**3';
    if (text.contains('sin')) return 'np.sin(x)';
    if (text.contains('cos')) return 'np.cos(x)';
    if (text.contains('log')) return 'np.log(x)';

    // fallback
    return null;
  }

  List<int>? _extractRange(String text) {
    // Ex: "de -5 a 5"
    final regex = RegExp(r'(-?\d+)\s*a\s*(-?\d+)');
    final match = regex.firstMatch(text);
    if (match == null) return null;

    return [
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
    ];
  }

  String _generatePythonPlot({
    required String function,
    required int min,
    required int max,
  }) {
    return '''
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace($min, $max, 400)
y = $function

plt.figure()
plt.plot(x, y)
plt.xlabel("x")
plt.ylabel("y")
plt.grid(True)
plt.show()
''';
  }
}
