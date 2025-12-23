import 'package:flutter/material.dart';
import '../../core/copilot/copilot_suggestion.dart';

class CopilotSuggestionTile extends StatelessWidget {
  final CopilotSuggestion suggestion;
  final VoidCallback onTap;

  const CopilotSuggestionTile({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(suggestion.message),
        subtitle: Text(suggestion.type.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
