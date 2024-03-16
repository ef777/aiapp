class ShowcaseModel {
  int _id;
  String _prompt;
  String _url;

  ShowcaseModel({
    int id,
    String prompt,
    String url,
  }) {
    this._id = id;
    this._prompt = prompt;
    this._url = url;
  }

  int get id => _id;
  String get prompt => _prompt;
  String get url => _url;

  ShowcaseModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _prompt = json['prompt'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['prompt'] = this._prompt;
    data['url'] = this._url;
    return data;
  }
}
