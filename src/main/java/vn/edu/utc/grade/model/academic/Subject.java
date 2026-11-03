package vn.edu.utc.grade.model.academic;

import java.io.Serializable;

public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private String subjectId;          // MA_MON
    private String subjectName;        // TEN_MON
    private int credits;               // SO_TIN_CHI
    private double weightAttendance;   // TY_LE_CC (ví dụ 0.10)
    private double weightMidterm;      // TY_LE_GK (ví dụ 0.20)
    private double weightFinal;        // TY_LE_THI (ví dụ 0.70)
    private String subjectType;        // TIN_CHI hoặc DIEU_KIEN

    public Subject() {
        this.weightAttendance = 0.10;
        this.weightMidterm = 0.20;
        this.weightFinal = 0.70;
        this.subjectType = "TIN_CHI";
    }

    public Subject(String subjectId, String subjectName, int credits, double weightAttendance, double weightMidterm, double weightFinal, String subjectType) {
        this.subjectId = subjectId;
        this.subjectName = subjectName;
        this.credits = credits;
        this.weightAttendance = weightAttendance;
        this.weightMidterm = weightMidterm;
        this.weightFinal = weightFinal;
        this.subjectType = subjectType;
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

    public String getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(String subjectType) {
        this.subjectType = subjectType;
    }

    public int getPercentAttendance() {
        return (int) Math.round(weightAttendance * 100);
    }

    public int getPercentMidterm() {
        return (int) Math.round(weightMidterm * 100);
    }

    public int getPercentFinal() {
        return (int) Math.round(weightFinal * 100);
    }
}
