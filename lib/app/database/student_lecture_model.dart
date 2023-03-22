class StudentLectureModel {
  String? lectureCourseCode;
  String? lectureCourseTitle;
  DateTime? lectureDate;
  String? department;
  String? lecturer;
  String? level;
  String? status;
  String? theater;
  String? time;
  String? long;
  String? lat;
  String? uuid;

  StudentLectureModel(
      {this.department,
      this.lat,
      this.lectureCourseCode,
      this.lectureCourseTitle,
      this.lectureDate,
      this.lecturer,
      this.level,
      this.long,
      this.uuid,
      this.status,
      this.theater,
      this.time});

  factory StudentLectureModel.fromJson(Map<String, dynamic> data) {
    return StudentLectureModel(
        department: data['department'],
        lat: data['lat'],
        lectureCourseCode: data['lectureCode'],
        lectureCourseTitle: data['lectureTitle'],
        lectureDate:
            DateTime.fromMillisecondsSinceEpoch(int.parse(data['date'])),
        lecturer: data['lecturer'],
        level: data['level'],
        long: data['long'],
        status: data['status'],
        theater: data['theater'],
        time: data['time'],
        uuid: data['uuid']);
  }

  factory StudentLectureModel.fromDatabase(Map<String, dynamic> data) {
    return StudentLectureModel(
        department: data['department'],
        lat: data['lat'],
        lectureCourseCode: data['lectureCode'],
        lectureCourseTitle: data['lectureTitle'],
        lectureDate: DateTime.fromMillisecondsSinceEpoch(data['date'] as int),
        lecturer: data['lecturer'],
        level: data['level'],
        long: data['long'],
        status: data['status'],
        theater: data['theater'],
        time: data['time'],
        uuid: data['uuid']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "lectureTitle": lectureCourseTitle,
      "lectureCode": lectureCourseCode,
      "date": lectureDate?.millisecondsSinceEpoch,
      "time": time,
      "theater": theater,
      "department": department,
      "level": level,
      "status": status,
      "lecturer": lecturer,
      "uuid": uuid,
      "long": long,
      "lat": lat,
    };

    return data;
  }
}
