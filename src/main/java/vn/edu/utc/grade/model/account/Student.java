package vn.edu.utc.grade.model.account;

import java.io.Serializable;
import java.sql.Date;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private String studentId;     // MA_SV
    private String fullName;      // HO_TEN
    private Date dateOfBirth;     // NGAY_SINH
    private String gender;        // GIOI_TINH
    private String hometown;      // QUE_QUAN
    private String classId;       // MA_LOP
    private String className;     // TEN_LOP
    private String majorName;     // TEN_NGANH
    private String facultyName;   // TEN_KHOA
    private Integer userId;       // TAI_KHOAN_ID
    private Double gpa;           // GPA kỳ
    private Double cpa;           // CPA tích lũy
    private Integer totalCredits; // Tổng số tín chỉ tích lũy
    private String email;
    private String phone;
    private Integer status;

    public Student() {
    }

    public Student(String studentId, String fullName, Date dateOfBirth, String gender, String hometown, String classId) {
        this.studentId = studentId;
        this.fullName = fullName;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.hometown = hometown;
        this.classId = classId;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getHometown() {
        return hometown;
    }

    public void setHometown(String hometown) {
        this.hometown = hometown;
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

    public String getMajorName() {
        return majorName;
    }

    public void setMajorName(String majorName) {
        this.majorName = majorName;
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

    public Double getGpa() {
        return gpa;
    }

    public void setGpa(Double gpa) {
        this.gpa = gpa;
    }

    public Double getCpa() {
        return cpa;
    }

    public void setCpa(Double cpa) {
        this.cpa = cpa;
    }

    public Integer getTotalCredits() {
        return totalCredits;
    }

    public void setTotalCredits(Integer totalCredits) {
        this.totalCredits = totalCredits;
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

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
