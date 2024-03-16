class ConfigModel {
  int api;
  double appMinimumVersionAndroid;
  String appUrlAndroid;
  double appMinimumVersionIos;
  String appUrlIos;
  bool maintenanceMode;
  String slide1;
  String slide2;
  String slide3;
  String slide4;
  String prompt1;
  String prompt2;
  String prompt3;

  ConfigModel({
    this.api,
    this.appMinimumVersionAndroid,
    this.appUrlAndroid,
    this.appMinimumVersionIos,
    this.appUrlIos,
    this.maintenanceMode,
    this.slide1,
    this.slide2,
    this.slide3,
    this.slide4,
    this.prompt1,
    this.prompt2,
    this.prompt3,
  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    api = json['api'];
    appMinimumVersionAndroid = json['app_minimum_version_android'].toDouble();
    appUrlAndroid = json['app_url_android'];
    appMinimumVersionIos = json['app_minimum_version_ios'].toDouble();
    appUrlIos = json['app_url_ios'];
    maintenanceMode = json['maintenance_mode'];
    slide1 = json['slide1'];
    slide2 = json['slide2'];
    slide3 = json['slide3'];
    slide4 = json['slide4'];
    prompt1 = json['prompt_1'];
    prompt2 = json['prompt_2'];
    prompt3 = json['prompt_3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api'] = this.api;
    data['app_minimum_version_android'] = this.appMinimumVersionAndroid;
    data['app_url_android'] = this.appUrlAndroid;
    data['app_minimum_version_ios'] = this.appMinimumVersionIos;
    data['app_url_ios'] = this.appUrlIos;
    data['maintenance_mode'] = this.maintenanceMode;
    data['slide1'] = this.slide1;
    data['slide2'] = this.slide2;
    data['slide3'] = this.slide3;
    data['slide4'] = this.slide4;
    return data;
  }
}
