class StyleGroupModel {
  String _title;

  StyleGroupModel({
    String title,
  }) {
    this._title = title;
  }

  String get title => _title;

  StyleGroupModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    return data;
  }
}

class StyleModel {
  int _id;
  String _name;
  String _image;
  String _title;
  String _prompt;
  int _titleSort;

  StyleModel({
    int id,
    String name,
    String image,
    String title,
    String prompt,
    int titleSort,
  }) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._title = title;
    this._prompt = prompt;
    this._titleSort = titleSort;
  }

  int get id => _id;
  String get name => _name;
  String get image => _image;
  String get title => _title;
  String get prompt => _prompt;
  int get titleSort => _titleSort;

  StyleModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _title = json['title'];
    _prompt = json['prompt'];
    _titleSort = int.parse(json['title_sort']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['image'] = this._image;
    data['title'] = this.title;
    data['prompt'] = this.prompt;
    data['title_sort'] = this.titleSort;
    return data;
  }
}
