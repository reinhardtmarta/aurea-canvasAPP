import 'package:flutter/material.dart';
import '../../core/ui/copilot_ui_contract.dart';
import '../../core/copilot/copilot_suggestion.dart';

class CopilotPanel extends StatefulWidget {
  final CopilotUIContract controller;

  const CopilotPanel({super.key, required this.controller});

  @override
  State<CopilotPanel> createState() => _CopilotPanelState();
}

class _CopilotPanelState extends State<CopilotPanel> {
  final TextEditingController _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final suggestions = widget.controller.getSuggestions();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo linear
          TextField(
            controller: _input,
            decoration: const InputDecoration(
              hintText: 'Escreva em modo linear (opcional)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (text) {
              widget.controller.submitLinearInput(text);
              _input.clear();
              setState(() {});
            },
          ),

          const SizedBox(height: 12),

          // Sugestões do Copilot
          if (suggestions.isNotEmpty)
            const Text(
              'Sugestões',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

          for (final s in suggestions)
            CopilotSuggestionTile(
              suggestion: s,
              onTap: () {
                // A UI decide o que fazer com a sugestão
                // O Copilot nunca executa ações
              },
            ),
        ],
      ),
    );
  }
}
