import 'package:flutter/material.dart';
import '../../core/copilot/copilot_suggestion.dart';

class CopilotPanel extends StatelessWidget {
  final List<CopilotSuggestion> suggestions;
  final void Function(CopilotSuggestion)? onSelect;

  const CopilotPanel({
    super.key,
    required this.suggestions,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Copiloto',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          for (final s in suggestions)
            ListTile(
              dense: true,
              title: Text(s.message),
              onTap: () => onSelect?.call(s),
            ),
        ],
      ),
    );
  }
}
