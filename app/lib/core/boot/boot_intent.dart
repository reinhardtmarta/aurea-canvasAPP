enum BootIntentType {
  translate,
  export,
  analyze,
  unknown,
}

class BootIntent {
  final BootIntentType type;
  final String? targetFormat;
  final bool needsConfirmation;

  BootIntent({
    required this.type,
    this.targetFormat,
    this.needsConfirmation = false,
  });
}
