class SubjectList {
  String id;
  String subjectName;
  String subjectCourseCode;
  String subjectCourseType;
  String subjectDay;
  int subjectStartTime;
  int subjectEndTime;
  String subjectDay_1;
  int subjectStartTime_1;
  int subjectEndTime_1;
  String subjectLecturer;
  String subjectSectionNumber;
  int subjectCreditHours;
  int maxStudents;
  int currentStudents;
  String semester;

  SubjectList(
      this.id,
      this.subjectName,
      this.subjectCourseCode,
      this.subjectCourseType,
      this.subjectDay,
      this.subjectStartTime,
      this.subjectEndTime,
      this.subjectDay_1,
      this.subjectStartTime_1,
      this.subjectEndTime_1,
      this.subjectLecturer,
      this.subjectSectionNumber,
      this.subjectCreditHours,
      this.maxStudents,
      this.semester,
      this.currentStudents);
}