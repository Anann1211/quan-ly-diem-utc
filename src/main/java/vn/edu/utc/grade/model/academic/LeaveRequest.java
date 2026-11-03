package vn.edu.utc.grade.model.academic;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class LeaveRequest implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String lecturerId;
    private String lecturerName;
    private String academicRank;
    private String facultyName;
    private Integer scheduleId;
    private String courseClassId;
    private String courseClassName;
    private String subjectName;
    private String scheduleInfo;
    private Date leaveDate;
    private String reason;
    private String leaveType; // DAY_BU, DAY_THAY, NGHI_LUON
    private String substituteLecturerId;
    private String substituteLecturerName;
    private String substituteAcademicRank;
    private Date makeupDate;
    private Integer makeupDayOfWeek;
    private Integer makeupStartPeriod;
    private Integer makeupPeriodCount;
    private String makeupRoom;
    private String status; // PENDING, APPROVED, REJECTED
    private Timestamp createdAt;
    private Timestamp reviewedAt;
    private String reviewedBy;
    private String feedback;

    public LeaveRequest() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLecturerId() { return lecturerId; }
    public void setLecturerId(String lecturerId) { this.lecturerId = lecturerId; }

    public String getLecturerName() { return lecturerName; }
    public void setLecturerName(String lecturerName) { this.lecturerName = lecturerName; }

    public String getAcademicRank() { return academicRank; }
    public void setAcademicRank(String academicRank) { this.academicRank = academicRank; }

    public String getFacultyName() { return facultyName; }
    public void setFacultyName(String facultyName) { this.facultyName = facultyName; }

    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }

    public String getCourseClassId() { return courseClassId; }
    public void setCourseClassId(String courseClassId) { this.courseClassId = courseClassId; }

    public String getCourseClassName() { return courseClassName; }
    public void setCourseClassName(String courseClassName) { this.courseClassName = courseClassName; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getScheduleInfo() { return scheduleInfo; }
    public void setScheduleInfo(String scheduleInfo) { this.scheduleInfo = scheduleInfo; }

    public Date getLeaveDate() { return leaveDate; }
    public void setLeaveDate(Date leaveDate) { this.leaveDate = leaveDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }

    public String getSubstituteLecturerId() { return substituteLecturerId; }
    public void setSubstituteLecturerId(String substituteLecturerId) { this.substituteLecturerId = substituteLecturerId; }

    public String getSubstituteLecturerName() { return substituteLecturerName; }
    public void setSubstituteLecturerName(String substituteLecturerName) { this.substituteLecturerName = substituteLecturerName; }

    public String getSubstituteAcademicRank() { return substituteAcademicRank; }
    public void setSubstituteAcademicRank(String substituteAcademicRank) { this.substituteAcademicRank = substituteAcademicRank; }

    public Date getMakeupDate() { return makeupDate; }
    public void setMakeupDate(Date makeupDate) { this.makeupDate = makeupDate; }

    public Integer getMakeupDayOfWeek() { return makeupDayOfWeek; }
    public void setMakeupDayOfWeek(Integer makeupDayOfWeek) { this.makeupDayOfWeek = makeupDayOfWeek; }

    public Integer getMakeupStartPeriod() { return makeupStartPeriod; }
    public void setMakeupStartPeriod(Integer makeupStartPeriod) { this.makeupStartPeriod = makeupStartPeriod; }

    public Integer getMakeupPeriodCount() { return makeupPeriodCount; }
    public void setMakeupPeriodCount(Integer makeupPeriodCount) { this.makeupPeriodCount = makeupPeriodCount; }

    public String getMakeupRoom() { return makeupRoom; }
    public void setMakeupRoom(String makeupRoom) { this.makeupRoom = makeupRoom; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }

    public String getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(String reviewedBy) { this.reviewedBy = reviewedBy; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public String getLeaveDateFormatted() {
        return (leaveDate != null) ? new SimpleDateFormat("dd/MM/yyyy").format(leaveDate) : "-";
    }

    public String getMakeupDateFormatted() {
        return (makeupDate != null) ? new SimpleDateFormat("dd/MM/yyyy").format(makeupDate) : "-";
    }

    public String getFormOfWorkBadge() {
        if ("DAY_THAY".equalsIgnoreCase(leaveType)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-purple-100 text-purple-800 border border-purple-200\"><i class=\"fa-solid fa-user-clock mr-1 text-purple-600\"></i>Dạy Thay</span>";
        } else if ("DAY_BU".equalsIgnoreCase(leaveType)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-teal-100 text-teal-800 border border-teal-200\"><i class=\"fa-solid fa-calendar-plus mr-1 text-teal-600\"></i>Dạy Bù</span>";
        } else {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200\"><i class=\"fa-solid fa-circle-xmark mr-1 text-rose-600\"></i>Nghỉ Hẳn</span>";
        }
    }

    public String getStatusBadge() {
        if ("APPROVED".equalsIgnoreCase(status)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800\"><i class=\"fa-solid fa-circle-check mr-1 text-emerald-500\"></i>Đã Duyệt</span>";
        } else if ("REJECTED".equalsIgnoreCase(status)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800\"><i class=\"fa-solid fa-circle-xmark mr-1 text-rose-500\"></i>Từ Chối</span>";
        } else {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800\"><i class=\"fa-solid fa-clock mr-1 text-amber-500\"></i>Chờ Duyệt</span>";
        }
    }

    public String getPlanDetailText() {
        if ("DAY_THAY".equalsIgnoreCase(leaveType)) {
            String gv = (substituteLecturerName != null) ? (substituteAcademicRank != null ? substituteAcademicRank + " " : "") + substituteLecturerName : substituteLecturerId;
            return "Người dạy thay: " + gv;
        } else if ("DAY_BU".equalsIgnoreCase(leaveType)) {
            if (makeupDate != null) {
                String thuStr = (makeupDayOfWeek != null && makeupDayOfWeek == 8) ? "Chủ Nhật" : ("Thứ " + (makeupDayOfWeek != null ? makeupDayOfWeek : ""));
                return getMakeupDateFormatted() + " (" + thuStr + "), Tiết " + (makeupStartPeriod != null ? makeupStartPeriod : "") + " (" + (makeupPeriodCount != null ? makeupPeriodCount : "") + " tiết), Phòng " + (makeupRoom != null ? makeupRoom : "");
            }
            return "Chưa đề xuất lịch bù cụ thể";
        }
        return "Nghỉ không bố trí bù";
    }
}
