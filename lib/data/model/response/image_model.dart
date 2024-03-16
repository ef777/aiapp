class ImageModel {
  int _id;
  String _prompt;
  String _url;
  String _userId;

  ImageModel({
    int id,
    String prompt,
    String url,
    String userId,
  }) {
    this._id = id;
    this._prompt = prompt;
    this._url = url;
    this._userId = userId;
  }

  int get id => _id;
  String get prompt => _prompt;
  String get url => _url;
  String get userId => _userId;

  ImageModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _prompt = json['prompt'];
    _url = json['url'];
    _userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['prompt'] = this._prompt;
    data['url'] = this._url;
    data['user_id'] = this._userId;
    return data;
  }
}
