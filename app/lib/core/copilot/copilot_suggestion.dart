enum CopilotSuggestionType {
  translate,
  export,
  refine,
  analyze,
  hint,
}

class CopilotSuggestion {
  final CopilotSuggestionType type;
  final String message;
  final Map<String, dynamic>? payload;

  CopilotSuggestion({
    required this.type,
    required this.message,
    this.payload,
  });
}
