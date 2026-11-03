package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.CourseClassDAO;
import vn.edu.utc.grade.dao.academic.LeaveRequestDAO;
import vn.edu.utc.grade.dao.academic.ScheduleDAO;
import vn.edu.utc.grade.dao.academic.SemesterDAO;
import vn.edu.utc.grade.dao.account.LecturerDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.academic.LeaveRequest;
import vn.edu.utc.grade.model.academic.Schedule;
import vn.edu.utc.grade.model.academic.Semester;
import vn.edu.utc.grade.model.account.Lecturer;
import vn.edu.utc.grade.model.account.User;

/**
 * Quản trị Thời Khóa Biểu & Lịch Học / Lịch Thi:
 * Toàn quyền: Thêm, sửa, xóa, phân công giảng viên, gán phòng học.
 * Kiểm tra và cảnh báo đỏ tự động nếu trùng phòng, trùng giảng viên.
 * Phê duyệt đơn xin báo nghỉ & lịch dạy bù của Giảng viên.
 */
@WebServlet("/admin/schedules")
public class AdminScheduleServlet extends HttpServlet {

    private ScheduleDAO scheduleDAO;
    private CourseClassDAO courseClassDAO;
    private LecturerDAO lecturerDAO;
    private SemesterDAO semesterDAO;
    private LeaveRequestDAO leaveRequestDAO;

    @Override
    public void init() throws ServletException {
        scheduleDAO = new ScheduleDAO();
        courseClassDAO = new CourseClassDAO();
        lecturerDAO = new LecturerDAO();
        semesterDAO = new SemesterDAO();
        leaveRequestDAO = new LeaveRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tab = req.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "schedules";
        }

        String semesterId = req.getParameter("semesterId");
        String dayStr = req.getParameter("dayOfWeek");
        Integer dayOfWeek = (dayStr != null && !dayStr.trim().isEmpty()) ? Integer.parseInt(dayStr.trim()) : null;

        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<CourseClass> classes = courseClassDAO.getAllCourseClasses(semesterId);
        List<Lecturer> lecturers = lecturerDAO.getAllLecturers();
        List<Schedule> schedules = scheduleDAO.getAllSchedules(semesterId, dayOfWeek);

        String leaveStatus = req.getParameter("leaveStatus");
        List<LeaveRequest> leaveRequests = leaveRequestDAO.getAllLeaveRequests(leaveStatus);
        int pendingLeavesCount = leaveRequestDAO.countPendingLeaveRequests();

        req.setAttribute("currentTab", tab);
        req.setAttribute("semesters", semesters);
        req.setAttribute("classes", classes);
        req.setAttribute("lecturers", lecturers);
        req.setAttribute("schedules", schedules);
        req.setAttribute("leaveRequests", leaveRequests);
        req.setAttribute("pendingLeavesCount", pendingLeavesCount);
        req.setAttribute("leaveStatus", leaveStatus);
        req.setAttribute("selectedSemester", semesterId);
        req.setAttribute("selectedDay", dayOfWeek);

        req.getRequestDispatcher("/WEB-INF/views/admin/schedules.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                String courseClassId = req.getParameter("courseClassId");
                int dayOfWeek = Integer.parseInt(req.getParameter("dayOfWeek"));
                int startPeriod = Integer.parseInt(req.getParameter("startPeriod"));
                int periodCount = Integer.parseInt(req.getParameter("periodCount"));
                String room = req.getParameter("room");
                String lecturerId = req.getParameter("lecturerId");
                String scheduleType = req.getParameter("scheduleType");
                String note = req.getParameter("note");

                // 1. Kiểm tra trùng phòng học
                Schedule roomConflict = scheduleDAO.checkRoomConflict(room, dayOfWeek, startPeriod, periodCount, 0);
                if (roomConflict != null) {
                    String msg = "CẢNH BÁO TRÙNG PHÒNG HỌC: Phòng " + room.toUpperCase() + " đã có ca dạy của lớp " +
                                 roomConflict.getCourseClassName() + " (" + roomConflict.getCourseClassId() + ") vào " +
                                 roomConflict.getDayOfWeekText() + ", " + roomConflict.getPeriodText() + "!";
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules?error=" + URLEncoder.encode(msg, "UTF-8"));
                    return;
                }

                // 2. Kiểm tra trùng giảng viên
                Schedule gvConflict = scheduleDAO.checkLecturerConflict(lecturerId, dayOfWeek, startPeriod, periodCount, 0);
                if (gvConflict != null) {
                    String msg = "CẢNH BÁO TRÙNG GIẢNG VIÊN: Giảng viên " + gvConflict.getLecturerName() +
                                 " đã có lịch dạy lớp " + gvConflict.getCourseClassName() + " (" + gvConflict.getCourseClassId() + ") vào " +
                                 gvConflict.getDayOfWeekText() + ", " + gvConflict.getPeriodText() + "!";
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules?error=" + URLEncoder.encode(msg, "UTF-8"));
                    return;
                }

                Schedule s = new Schedule(0, courseClassId, dayOfWeek, startPeriod, periodCount, room.trim(), lecturerId, scheduleType, note);
                scheduleDAO.insertSchedule(s);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules?msg=schedule_added");
                return;

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String courseClassId = req.getParameter("courseClassId");
                int dayOfWeek = Integer.parseInt(req.getParameter("dayOfWeek"));
                int startPeriod = Integer.parseInt(req.getParameter("startPeriod"));
                int periodCount = Integer.parseInt(req.getParameter("periodCount"));
                String room = req.getParameter("room");
                String lecturerId = req.getParameter("lecturerId");
                String scheduleType = req.getParameter("scheduleType");
                String note = req.getParameter("note");

                Schedule roomConflict = scheduleDAO.checkRoomConflict(room, dayOfWeek, startPeriod, periodCount, id);
                if (roomConflict != null) {
                    String msg = "CẢNH BÁO TRÙNG PHÒNG HỌC: Phòng " + room.toUpperCase() + " đã có lớp " +
                                 roomConflict.getCourseClassName() + " học vào " + roomConflict.getDayOfWeekText() + ", " + roomConflict.getPeriodText() + "!";
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules?error=" + URLEncoder.encode(msg, "UTF-8"));
                    return;
                }

                Schedule gvConflict = scheduleDAO.checkLecturerConflict(lecturerId, dayOfWeek, startPeriod, periodCount, id);
                if (gvConflict != null) {
                    String msg = "CẢNH BÁO TRÙNG GIẢNG VIÊN: Giảng viên " + gvConflict.getLecturerName() +
                                 " đã có ca dạy lớp " + gvConflict.getCourseClassName() + " vào " + gvConflict.getDayOfWeekText() + ", " + gvConflict.getPeriodText() + "!";
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules?error=" + URLEncoder.encode(msg, "UTF-8"));
                    return;
                }

                Schedule s = new Schedule(id, courseClassId, dayOfWeek, startPeriod, periodCount, room.trim(), lecturerId, scheduleType, note);
                scheduleDAO.updateSchedule(s);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules?msg=schedule_updated");
                return;

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                scheduleDAO.deleteSchedule(id);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules?msg=schedule_deleted");
                return;

            } else if ("approve_leave".equals(action)) {
                int requestId = Integer.parseInt(req.getParameter("requestId"));
                String feedback = req.getParameter("feedback");
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                String adminName = (currentUser != null) ? currentUser.getFullName() : "Phòng Đào Tạo";

                leaveRequestDAO.updateStatus(requestId, "APPROVED", adminName, feedback);

                // Tự động tạo ca học bù vào bảng LICH_HOC để Giảng viên và Sinh viên theo dõi trên TKB
                LeaveRequest lr = leaveRequestDAO.getLeaveRequestById(requestId);
                if (lr != null && "DAY_BU".equalsIgnoreCase(lr.getLeaveType()) && lr.getMakeupDate() != null) {
                    Schedule s = new Schedule();
                    s.setCourseClassId(lr.getCourseClassId());

                    int dow = 2;
                    if (lr.getMakeupDayOfWeek() != null && lr.getMakeupDayOfWeek() >= 2 && lr.getMakeupDayOfWeek() <= 8) {
                        dow = lr.getMakeupDayOfWeek();
                    } else {
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(lr.getMakeupDate());
                        int calDow = cal.get(java.util.Calendar.DAY_OF_WEEK);
                        dow = (calDow == java.util.Calendar.SUNDAY) ? 8 : calDow;
                    }
                    s.setDayOfWeek(dow);
                    s.setStartPeriod(lr.getMakeupStartPeriod() != null ? lr.getMakeupStartPeriod() : 1);
                    s.setPeriodCount(lr.getMakeupPeriodCount() != null ? lr.getMakeupPeriodCount() : 3);
                    s.setRoom(lr.getMakeupRoom() != null && !lr.getMakeupRoom().trim().isEmpty() ? lr.getMakeupRoom().trim() : "P.201-A1");
                    s.setLecturerId(lr.getLecturerId());
                    s.setScheduleType("DAY_BU");
                    s.setScheduleDate(lr.getMakeupDate());
                    s.setNote("Dạy bù ca ngày " + lr.getLeaveDateFormatted() + " (Đơn #" + lr.getId() + ")");
                    scheduleDAO.insertSchedule(s);
                }

                resp.sendRedirect(req.getContextPath() + "/admin/schedules?tab=leaves&msg=leave_approved");
                return;

            } else if ("reject_leave".equals(action)) {
                int requestId = Integer.parseInt(req.getParameter("requestId"));
                String feedback = req.getParameter("feedback");
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                String adminName = (currentUser != null) ? currentUser.getFullName() : "Phòng Đào Tạo";

                leaveRequestDAO.updateStatus(requestId, "REJECTED", adminName, feedback);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules?tab=leaves&msg=leave_rejected");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/schedules?error=operation_failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/schedules");
    }
}
