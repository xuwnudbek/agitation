class Version {
  String? appName;
  String? about;
  String? url;
  String? codeSum;
  String? version;

  Version({this.appName, this.about, this.url, this.codeSum, this.version});

  Version.fromJson(json) {
    appName = json['app_name'];
    about = json['about'];
    url = json['url'];
    codeSum = json['code_sum'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['about'] = this.about;
    data['url'] = this.url;
    data['code_sum'] = this.codeSum;
    data['version'] = this.version;
    return data;
  }
}
