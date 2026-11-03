package vn.edu.utc.grade.model.grading;

import java.io.Serializable;

public class Grade implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String courseClassId;
    private String courseClassName;
    private String subjectId;
    private String subjectName;
    private int credits;
    private String semesterId;
    private String semesterName;
    private String academicYear;

    private String studentId;
    private String studentName;
    private String className;

    private Double scoreAttendance;   // Điểm chuyên cần (thang 10)
    private Double scoreMidterm;      // Điểm giữa kỳ (thang 10)
    private Double scoreFinal;        // Điểm thi kết thúc (thang 10)
    private Double scoreTotal10;      // Điểm tổng kết thang 10
    private String scoreLetter;       // Điểm chữ: A+, A, B+, B, C+, C, D+, D, F+, F
    private Double scoreScale4;       // Điểm thang 4: 4.0, 3.8, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.5, 0.0
    private String result;            // 'DAT' hoặc 'KHONG_DAT'
    private String note;
    private String gradeStatus;       // 'DRAFT', 'SUBMITTED', 'PUBLISHED'

    public Grade() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCourseClassId() {
        return courseClassId;
    }

    public void setCourseClassId(String courseClassId) {
        this.courseClassId = courseClassId;
    }

    public String getCourseClassName() {
        return courseClassName;
    }

    public void setCourseClassName(String courseClassName) {
        this.courseClassName = courseClassName;
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

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public Double getScoreAttendance() {
        return scoreAttendance;
    }

    public void setScoreAttendance(Double scoreAttendance) {
        this.scoreAttendance = scoreAttendance;
    }

    public Double getScoreMidterm() {
        return scoreMidterm;
    }

    public void setScoreMidterm(Double scoreMidterm) {
        this.scoreMidterm = scoreMidterm;
    }

    public Double getScoreFinal() {
        return scoreFinal;
    }

    public void setScoreFinal(Double scoreFinal) {
        this.scoreFinal = scoreFinal;
    }

    public Double getScoreTotal10() {
        return scoreTotal10;
    }

    public void setScoreTotal10(Double scoreTotal10) {
        this.scoreTotal10 = scoreTotal10;
    }

    public String getScoreLetter() {
        return scoreLetter;
    }

    public void setScoreLetter(String scoreLetter) {
        this.scoreLetter = scoreLetter;
    }

    public Double getScoreScale4() {
        return scoreScale4;
    }

    public void setScoreScale4(Double scoreScale4) {
        this.scoreScale4 = scoreScale4;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getGradeStatus() {
        return gradeStatus;
    }

    public void setGradeStatus(String gradeStatus) {
        this.gradeStatus = gradeStatus;
    }

    public String getBadgeClass() {
        if (scoreLetter == null) return "bg-gray-100 text-gray-700";
        switch (scoreLetter.toUpperCase()) {
            case "A+":
            case "A":
                return "bg-emerald-100 text-emerald-800 font-bold";
            case "B+":
            case "B":
                return "bg-blue-100 text-blue-800 font-bold";
            case "C+":
            case "C":
                return "bg-amber-100 text-amber-800";
            case "D+":
            case "D":
                return "bg-orange-100 text-orange-800";
            default:
                return "bg-rose-100 text-rose-800 font-bold";
        }
    }

    public String getResultBadge() {
        if ("DAT".equalsIgnoreCase(result)) {
            return "<span class=\"px-2 py-0.5 rounded text-[11px] font-bold bg-emerald-100 text-emerald-800\">ĐẠT</span>";
        } else if ("KHONG_DAT".equalsIgnoreCase(result)) {
            return "<span class=\"px-2 py-0.5 rounded text-[11px] font-bold bg-rose-100 text-rose-800\">HỌC LẠI</span>";
        }
        return "<span class=\"text-slate-400 text-xs\">--</span>";
    }

    public String getLetterBadge() {
        if (scoreLetter == null || scoreLetter.trim().isEmpty()) {
            return "<span class=\"text-slate-400\">--</span>";
        }
        return "<span class=\"px-2 py-0.5 rounded text-xs font-bold " + getBadgeClass() + "\">" + scoreLetter + "</span>";
    }
}
