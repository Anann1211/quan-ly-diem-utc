package vn.edu.utc.grade.model.academic;

import java.io.Serializable;

public class Major implements Serializable {
    private static final long serialVersionUID = 1L;

    private String majorId;
    private String majorName;
    private String facultyId;
    private String facultyName;

    public Major() {
    }

    public Major(String majorId, String majorName, String facultyId) {
        this.majorId = majorId;
        this.majorName = majorName;
        this.facultyId = facultyId;
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
}
