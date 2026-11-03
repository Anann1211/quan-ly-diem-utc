package vn.edu.utc.grade.model.academic;

import java.sql.Date;
import java.text.SimpleDateFormat;

public class Schedule {
    private int id;
    private String courseClassId;
    private String courseClassName;
    private String subjectId;
    private String subjectName;
    private String semesterId;
    private String semesterName;
    private int dayOfWeek;       // 2: Thứ 2, ..., 7: Thứ 7, 8: Chủ Nhật
    private int startPeriod;     // 1 .. 12
    private int periodCount;     // Số tiết (2, 3, 4)
    private String room;
    private String lecturerId;
    private String lecturerName;
    private String scheduleType; // LY_THUYET, THUC_HANH, THI, DAY_BU
    private String note;
    private Date scheduleDate;   // NGAY_HOC (áp dụng cho ca dạy bù)

    // Các trường phản ánh trạng thái nghỉ / dạy thay / dạy bù
    private boolean hasApprovedLeave;
    private String leaveType;              // DAY_BU, DAY_THAY, NGHI_LUON
    private String substituteLecturerId;
    private String substituteLecturerName;
    private Date leaveDate;
    private Date makeupDate;

    public Schedule() {}

    public Schedule(int id, String courseClassId, int dayOfWeek, int startPeriod, int periodCount,
                    String room, String lecturerId, String scheduleType, String note) {
        this.id = id;
        this.courseClassId = courseClassId;
        this.dayOfWeek = dayOfWeek;
        this.startPeriod = startPeriod;
        this.periodCount = periodCount;
        this.room = room;
        this.lecturerId = lecturerId;
        this.scheduleType = scheduleType;
        this.note = note;
    }

    public int getEndPeriod() {
        return startPeriod + periodCount - 1;
    }

    public String getDayOfWeekText() {
        switch (dayOfWeek) {
            case 2: return "Thứ Hai";
            case 3: return "Thứ Ba";
            case 4: return "Thứ Tư";
            case 5: return "Thứ Năm";
            case 6: return "Thứ Sáu";
            case 7: return "Thứ Bảy";
            case 8: return "Chủ Nhật";
            default: return "Thứ " + dayOfWeek;
        }
    }

    public String getPeriodText() {
        if (periodCount <= 1) {
            return "Tiết " + startPeriod;
        }
        return "Tiết " + startPeriod + " - " + getEndPeriod();
    }

    public String getTimeRangeText() {
        String startTime = getPeriodStartTime(startPeriod);
        String endTime = getPeriodEndTime(getEndPeriod());
        return startTime + " - " + endTime;
    }

    private String getPeriodStartTime(int period) {
        switch (period) {
            case 1: return "07:00";
            case 2: return "07:50";
            case 3: return "08:40";
            case 4: return "09:35";
            case 5: return "10:25";
            case 6: return "11:15";
            case 7: return "13:00";
            case 8: return "13:50";
            case 9: return "14:40";
            case 10: return "15:35";
            case 11: return "16:25";
            case 12: return "17:15";
            default: return "07:00";
        }
    }

    private String getPeriodEndTime(int period) {
        switch (period) {
            case 1: return "07:45";
            case 2: return "08:35";
            case 3: return "09:25";
            case 4: return "10:20";
            case 5: return "11:10";
            case 6: return "12:00";
            case 7: return "13:45";
            case 8: return "14:35";
            case 9: return "15:25";
            case 10: return "16:20";
            case 11: return "17:10";
            case 12: return "18:00";
            default: return "18:00";
        }
    }

    public String getScheduleTypeBadge() {
        if ("DAY_BU".equalsIgnoreCase(scheduleType)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-[10px] font-bold bg-teal-100 text-teal-800 border border-teal-200\"><i class=\"fa-solid fa-calendar-plus mr-1 text-teal-600\"></i>Dạy Bù</span>";
        } else if ("THI".equalsIgnoreCase(scheduleType)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-[10px] font-bold bg-rose-100 text-rose-700 border border-rose-200\"><i class=\"fa-solid fa-pen mr-1\"></i>Lịch Thi</span>";
        } else if ("THUC_HANH".equalsIgnoreCase(scheduleType)) {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-700 border border-emerald-200\"><i class=\"fa-solid fa-flask mr-1\"></i>Thực Hành</span>";
        } else {
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2.5 py-1 rounded-full text-[10px] font-bold bg-blue-100 text-blue-700 border border-blue-200\"><i class=\"fa-solid fa-book-open mr-1\"></i>Lý Thuyết</span>";
        }
    }

    public String getLiveStatusBadge() {
        if ("DAY_BU".equalsIgnoreCase(scheduleType)) {
            String dateStr = (scheduleDate != null) ? " (" + new SimpleDateFormat("dd/MM/yyyy").format(scheduleDate) + ")" : "";
            return "<span class=\"inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-[10px] font-bold bg-teal-100 text-teal-800 border border-teal-200\"><i class=\"fa-solid fa-calendar-check mr-1 text-teal-600\"></i>Ca Dạy Bù" + dateStr + "</span>";
        }
        if (hasApprovedLeave) {
            if ("DAY_THAY".equalsIgnoreCase(leaveType)) {
                return "<span class=\"inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-[10px] font-bold bg-purple-100 text-purple-800 border border-purple-200\"><i class=\"fa-solid fa-user-clock mr-1 text-purple-600\"></i>Dạy Thay: " + (substituteLecturerName != null ? substituteLecturerName : "Đã gán GV") + "</span>";
            } else if ("DAY_BU".equalsIgnoreCase(leaveType)) {
                String makeupInfo = (makeupDate != null) ? " (Bù ngày " + new SimpleDateFormat("dd/MM/yyyy").format(makeupDate) + ")" : "";
                return "<span class=\"inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200\"><i class=\"fa-solid fa-circle-pause mr-1 text-amber-600\"></i>Báo Nghỉ" + makeupInfo + "</span>";
            } else {
                return "<span class=\"inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200\"><i class=\"fa-solid fa-circle-xmark mr-1 text-rose-600\"></i>Nghỉ Ca Này</span>";
            }
        }
        return "<span class=\"inline-flex items-center whitespace-nowrap px-2 py-0.5 rounded-full text-[10px] font-medium bg-emerald-50 text-emerald-700 border border-emerald-100\"><i class=\"fa-solid fa-circle-check mr-1 text-emerald-500\"></i>Bình Thường</span>";
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCourseClassId() { return courseClassId; }
    public void setCourseClassId(String courseClassId) { this.courseClassId = courseClassId; }

    public String getCourseClassName() { return courseClassName; }
    public void setCourseClassName(String courseClassName) { this.courseClassName = courseClassName; }

    public String getSubjectId() { return subjectId; }
    public void setSubjectId(String subjectId) { this.subjectId = subjectId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSemesterId() { return semesterId; }
    public void setSemesterId(String semesterId) { this.semesterId = semesterId; }

    public String getSemesterName() { return semesterName; }
    public void setSemesterName(String semesterName) { this.semesterName = semesterName; }

    public int getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(int dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public int getStartPeriod() { return startPeriod; }
    public void setStartPeriod(int startPeriod) { this.startPeriod = startPeriod; }

    public int getPeriodCount() { return periodCount; }
    public void setPeriodCount(int periodCount) { this.periodCount = periodCount; }

    public String getRoom() { return room; }
    public void setRoom(String room) { this.room = room; }

    public String getLecturerId() { return lecturerId; }
    public void setLecturerId(String lecturerId) { this.lecturerId = lecturerId; }

    public String getLecturerName() { return lecturerName; }
    public void setLecturerName(String lecturerName) { this.lecturerName = lecturerName; }

    public String getScheduleType() { return scheduleType; }
    public void setScheduleType(String scheduleType) { this.scheduleType = scheduleType; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Date getScheduleDate() { return scheduleDate; }
    public void setScheduleDate(Date scheduleDate) { this.scheduleDate = scheduleDate; }

    public boolean isHasApprovedLeave() { return hasApprovedLeave; }
    public void setHasApprovedLeave(boolean hasApprovedLeave) { this.hasApprovedLeave = hasApprovedLeave; }

    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }

    public String getSubstituteLecturerId() { return substituteLecturerId; }
    public void setSubstituteLecturerId(String substituteLecturerId) { this.substituteLecturerId = substituteLecturerId; }

    public String getSubstituteLecturerName() { return substituteLecturerName; }
    public void setSubstituteLecturerName(String substituteLecturerName) { this.substituteLecturerName = substituteLecturerName; }

    public Date getLeaveDate() { return leaveDate; }
    public void setLeaveDate(Date leaveDate) { this.leaveDate = leaveDate; }

    public Date getMakeupDate() { return makeupDate; }
    public void setMakeupDate(Date makeupDate) { this.makeupDate = makeupDate; }
}
