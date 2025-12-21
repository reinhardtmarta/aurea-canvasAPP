enum BootIntentType {
  translate,
  export,
  analyze,
}

class BootIntent {
  final BootIntentType type;
  final String targetFormat;

  BootIntent({
    required this.type,
    required this.targetFormat,
  });
}
