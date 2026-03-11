/// AI API 提供商类型
enum AiApiType {
  /// OpenAI 兼容 API
  openai,

  /// Anthropic Claude API
  anthropic;

  /// 获取显示名称
  String get displayName {
    switch (this) {
      case AiApiType.openai:
        return 'OpenAI';
      case AiApiType.anthropic:
        return 'Anthropic';
    }
  }

  /// 从字符串解析
  static AiApiType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'openai':
        return AiApiType.openai;
      case 'anthropic':
        return AiApiType.anthropic;
      default:
        return AiApiType.openai;
    }
  }
}
