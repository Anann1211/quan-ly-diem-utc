package vn.edu.utc.grade.model.academic;

import java.io.Serializable;

public class Semester implements Serializable {
    private static final long serialVersionUID = 1L;

    private String semesterId;
    private String semesterName;
    private String academicYear;
    private String status; // 'MO', 'KHOA'
    private int isActive;  // 1, 0

    public Semester() {
    }

    public Semester(String semesterId, String semesterName, String academicYear, String status, int isActive) {
        this.semesterId = semesterId;
        this.semesterName = semesterName;
        this.academicYear = academicYear;
        this.status = status;
        this.isActive = isActive;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public String getDisplayName() {
        return semesterName + " (" + academicYear + ")";
    }
}
