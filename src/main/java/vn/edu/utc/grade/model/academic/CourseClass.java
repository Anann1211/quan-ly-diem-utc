package vn.edu.utc.grade.model.academic;

import java.io.Serializable;

public class CourseClass implements Serializable {
    private static final long serialVersionUID = 1L;

    private String classId;        // MA_LHP
    private String className;      // TEN_LHP
    private String subjectId;      // MA_MON
    private String subjectName;    // TEN_MON
    private int credits;           // SO_TIN_CHI
    private double weightAttendance;
    private double weightMidterm;
    private double weightFinal;
    private String semesterId;     // MA_HOC_KY
    private String semesterName;   // TEN_HOC_KY
    private String academicYear;   // NAM_HOC
    private String lecturerId;     // MA_GV
    private String lecturerName;   // HO_TEN GV
    private String room;           // PHONG_HOC
    private int enrolledCount;     // SI_SO
    private String gradeStatus;    // TRANG_THAI_DIEM: 'DRAFT', 'SUBMITTED', 'PUBLISHED'

    public CourseClass() {
    }

    public CourseClass(String classId, String className, String subjectId, String semesterId, String lecturerId, String room, int enrolledCount, String gradeStatus) {
        this.classId = classId;
        this.className = className;
        this.subjectId = subjectId;
        this.semesterId = semesterId;
        this.lecturerId = lecturerId;
        this.room = room;
        this.enrolledCount = enrolledCount;
        this.gradeStatus = gradeStatus;
    }

    public String getClassId() {
        return classId;
    }

    public void setClassId(String classId) {
        this.classId = classId;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(String subjectId) {
        this.subjectId = subjectId;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getCredits() {
        return credits;
    }

    public void setCredits(int credits) {
        this.credits = credits;
    }

    public double getWeightAttendance() {
        return weightAttendance;
    }

    public void setWeightAttendance(double weightAttendance) {
        this.weightAttendance = weightAttendance;
    }

    public double getWeightMidterm() {
        return weightMidterm;
    }

    public void setWeightMidterm(double weightMidterm) {
        this.weightMidterm = weightMidterm;
    }

    public double getWeightFinal() {
        return weightFinal;
    }

    public void setWeightFinal(double weightFinal) {
        this.weightFinal = weightFinal;
    }

    public String getSemesterId() {
        return semesterId;
    }

    public void setSemesterId(String semesterId) {
        this.semesterId = semesterId;
    }

    public String getSemesterName() {
        return semesterName;
    }

    public void setSemesterName(String semesterName) {
        this.semesterName = semesterName;
    }

    public String getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(String academicYear) {
        this.academicYear = academicYear;
    }

    public String getLecturerId() {
        return lecturerId;
    }

    public void setLecturerId(String lecturerId) {
        this.lecturerId = lecturerId;
    }

    public String getLecturerName() {
        return lecturerName;
    }

    public void setLecturerName(String lecturerName) {
        this.lecturerName = lecturerName;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public int getEnrolledCount() {
        return enrolledCount;
    }

    public void setEnrolledCount(int enrolledCount) {
        this.enrolledCount = enrolledCount;
    }

    public String getGradeStatus() {
        return gradeStatus;
    }

    public void setGradeStatus(String gradeStatus) {
        this.gradeStatus = gradeStatus;
    }

    public String getStatusBadge() {
        if ("PUBLISHED".equalsIgnoreCase(gradeStatus)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 shadow-sm\"><i class=\"fa-solid fa-circle-check mr-1.5 text-emerald-600\"></i>Đã công bố</span>";
        } else if ("SUBMITTED".equalsIgnoreCase(gradeStatus)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 shadow-sm\"><i class=\"fa-solid fa-clock mr-1.5 text-amber-600\"></i>Chờ duyệt</span>";
        } else {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-700 shadow-sm\"><i class=\"fa-solid fa-pen mr-1.5 text-slate-500\"></i>Đang nhập (Nháp)</span>";
        }
    }
}
