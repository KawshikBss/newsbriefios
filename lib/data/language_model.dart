class LanguageModel {
  String name;
  String? code;
  LanguageModel({required this.name, this.code});
  @override
  String toString() {
    return '{"name": "$name", "code": "$code"}';
  }
}

List<LanguageModel> languageList = [
  LanguageModel(name: 'English', code: 'en'),
  LanguageModel(name: '中文', code: 'cn'),
  LanguageModel(name: '繁體中文', code: 'tc'),
  LanguageModel(name: '한국어', code: 'kor'),
  LanguageModel(name: '日本語', code: 'jap'),
  LanguageModel(name: 'Español', code: 'spa'),
];
