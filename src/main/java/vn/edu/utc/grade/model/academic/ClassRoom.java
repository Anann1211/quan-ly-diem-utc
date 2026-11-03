package vn.edu.utc.grade.model.academic;

import java.io.Serializable;

public class ClassRoom implements Serializable {
    private static final long serialVersionUID = 1L;

    private String classId;
    private String className;
    private int intakeYear; // KHOA_HOC (ví dụ 62, 63)
    private String majorId;
    private String majorName;

    private String facultyId;
    private String facultyName;
    private int studentCount;

    public ClassRoom() {
    }

    public ClassRoom(String classId, String className, int intakeYear, String majorId) {
        this.classId = classId;
        this.className = className;
        this.intakeYear = intakeYear;
        this.majorId = majorId;
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

    public int getIntakeYear() {
        return intakeYear;
    }

    public void setIntakeYear(int intakeYear) {
        this.intakeYear = intakeYear;
    }

    public String getMajorId() {
        return majorId;
    }

    public void setMajorId(String majorId) {
        this.majorId = majorId;
    }

    public String getMajorName() {
        return majorName;
    }

    public void setMajorName(String majorName) {
        this.majorName = majorName;
    }

    public String getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(String facultyId) {
        this.facultyId = facultyId;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public int getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(int studentCount) {
        this.studentCount = studentCount;
    }
}
