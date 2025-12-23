class NullAiAdapter implements AiAdapter {
  @override
  Future<AiResponse> suggest(AiRequest request) async {
    return AiResponse(message: 'IA desativada');
  }
}
