package vn.edu.utc.grade.model.account;

import java.io.Serializable;

public class Lecturer implements Serializable {
    private static final long serialVersionUID = 1L;

    private String lecturerId;    // MA_GV
    private String fullName;      // HO_TEN
    private String academicRank;  // HOC_HAM_HOC_VI
    private String email;         // EMAIL
    private String phone;         // DIEN_THOAI
    private String facultyId;     // MA_KHOA
    private String facultyName;   // TEN_KHOA
    private Integer userId;       // TAI_KHOAN_ID

    public Lecturer() {
    }

    public Lecturer(String lecturerId, String fullName, String academicRank, String email, String phone, String facultyId) {
        this.lecturerId = lecturerId;
        this.fullName = fullName;
        this.academicRank = academicRank;
        this.email = email;
        this.phone = phone;
        this.facultyId = facultyId;
    }

    public String getLecturerId() {
        return lecturerId;
    }

    public void setLecturerId(String lecturerId) {
        this.lecturerId = lecturerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAcademicRank() {
        return academicRank;
    }

    public void setAcademicRank(String academicRank) {
        this.academicRank = academicRank;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}
