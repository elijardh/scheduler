class LectureTheaterModel {
  String? value;
  String? lat;
  String? long;

  LectureTheaterModel({this.lat, this.long, this.value});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {"lat": lat, "long": long};

    return data;
  }
}
