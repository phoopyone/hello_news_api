class SourceModel {
  String name;
  String id;

  SourceModel(this.name, this.id);
  SourceModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        id = json["id"].toString();
}
