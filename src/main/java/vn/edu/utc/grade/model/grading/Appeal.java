package vn.edu.utc.grade.model.grading;

import java.io.Serializable;
import java.sql.Timestamp;

public class Appeal implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int gradeId;
    private String studentId;
    private String studentName;
    private String courseClassId;
    private String courseClassName;
    private String subjectName;
    private String reason;
    private Double oldFinalScore;
    private Double newFinalScore;
    private String status; // 'PENDING', 'APPROVED', 'REJECTED'
    private Timestamp submissionDate;
    private Timestamp processedDate;
    private String note;
    private String processedBy;

    public Appeal() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getGradeId() {
        return gradeId;
    }

    public void setGradeId(int gradeId) {
        this.gradeId = gradeId;
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

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Double getOldFinalScore() {
        return oldFinalScore;
    }

    public void setOldFinalScore(Double oldFinalScore) {
        this.oldFinalScore = oldFinalScore;
    }

    public Double getNewFinalScore() {
        return newFinalScore;
    }

    public void setNewFinalScore(Double newFinalScore) {
        this.newFinalScore = newFinalScore;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(Timestamp submissionDate) {
        this.submissionDate = submissionDate;
    }

    public Timestamp getProcessedDate() {
        return processedDate;
    }

    public void setProcessedDate(Timestamp processedDate) {
        this.processedDate = processedDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(String processedBy) {
        this.processedBy = processedBy;
    }

    public String getStatusBadge() {
        if ("APPROVED".equalsIgnoreCase(status)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-3 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 shadow-sm\"><i class=\"fa-solid fa-check mr-1.5 text-emerald-600\"></i>Đã duyệt</span>";
        } else if ("REJECTED".equalsIgnoreCase(status)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-3 py-1 rounded-full text-xs font-semibold bg-rose-100 text-rose-800 shadow-sm\"><i class=\"fa-solid fa-xmark mr-1.5 text-rose-600\"></i>Từ chối</span>";
        } else {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-3 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 shadow-sm\"><i class=\"fa-solid fa-clock mr-1.5 text-amber-600\"></i>Chờ xử lý</span>";
        }
    }
}
