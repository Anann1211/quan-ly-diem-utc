package vn.edu.utc.grade.controller.lecturer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import vn.edu.utc.grade.dao.academic.CourseClassDAO;
import vn.edu.utc.grade.dao.academic.LeaveRequestDAO;
import vn.edu.utc.grade.dao.academic.ScheduleDAO;
import vn.edu.utc.grade.dao.academic.SemesterDAO;
import vn.edu.utc.grade.dao.account.LecturerDAO;
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.academic.LeaveRequest;
import vn.edu.utc.grade.model.academic.Schedule;
import vn.edu.utc.grade.model.academic.Semester;
import vn.edu.utc.grade.model.account.Lecturer;
import vn.edu.utc.grade.model.grading.Grade;
import vn.edu.utc.grade.service.ExcelService;
import vn.edu.utc.grade.service.GradeCalculator;

@WebServlet(urlPatterns = {
    "/lecturer/classes",
    "/lecturer/grade-input",
    "/lecturer/save-grades",
    "/lecturer/submit-grades",
    "/lecturer/export-excel",
    "/lecturer/import-excel",
    "/lecturer/schedule",
    "/lecturer/request-leave"
})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class LecturerServlet extends HttpServlet {

    private CourseClassDAO courseClassDAO;
    private GradeDAO gradeDAO;
    private SemesterDAO semesterDAO;
    private ScheduleDAO scheduleDAO;
    private LeaveRequestDAO leaveRequestDAO;
    private LecturerDAO lecturerDAO;

    @Override
    public void init() throws ServletException {
        courseClassDAO = new CourseClassDAO();
        gradeDAO = new GradeDAO();
        semesterDAO = new SemesterDAO();
        scheduleDAO = new ScheduleDAO();
        leaveRequestDAO = new LeaveRequestDAO();
        lecturerDAO = new LecturerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");
        Lecturer lecturer = (Lecturer) req.getSession().getAttribute("currentLecturer");
        if (lecturer == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (path) {
            case "/lecturer/classes":
                handleClasses(req, resp, lecturer);
                break;
            case "/lecturer/grade-input":
                handleGradeInput(req, resp, lecturer);
                break;
            case "/lecturer/export-excel":
                handleExportExcel(req, resp, lecturer);
                break;
            case "/lecturer/schedule":
                handleSchedule(req, resp, lecturer);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/lecturer/classes");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");
        Lecturer lecturer = (Lecturer) req.getSession().getAttribute("currentLecturer");
        if (lecturer == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/lecturer/save-grades".equals(path)) {
            handleSaveGrades(req, resp, lecturer, false);
        } else if ("/lecturer/submit-grades".equals(path)) {
            handleSaveGrades(req, resp, lecturer, true);
        } else if ("/lecturer/import-excel".equals(path)) {
            handleImportExcel(req, resp, lecturer);
        } else if ("/lecturer/request-leave".equals(path)) {
            req.setCharacterEncoding("UTF-8");
            String schedIdStr = req.getParameter("scheduleId");
            String leaveDateStr = req.getParameter("leaveDate");
            String reason = req.getParameter("reason");
            String leaveType = req.getParameter("leaveType");
            String substituteLecturerId = req.getParameter("substituteLecturerId");
            String makeupDateStr = req.getParameter("makeupDate");
            String makeupStartPeriodStr = req.getParameter("makeupStartPeriod");
            String makeupPeriodCountStr = req.getParameter("makeupPeriodCount");
            String makeupRoom = req.getParameter("makeupRoom");

            LeaveRequest lr = new LeaveRequest();
            lr.setLecturerId(lecturer.getLecturerId());
            if (schedIdStr != null && !schedIdStr.trim().isEmpty()) {
                try {
                    lr.setScheduleId(Integer.parseInt(schedIdStr.trim()));
                } catch (Exception ignored) {}
            }
            if (leaveDateStr != null && !leaveDateStr.trim().isEmpty()) {
                try {
                    lr.setLeaveDate(java.sql.Date.valueOf(leaveDateStr.trim()));
                } catch (Exception ignored) {}
            }
            lr.setReason(reason != null ? reason.trim() : "");
            lr.setLeaveType(leaveType != null && !leaveType.trim().isEmpty() ? leaveType.trim() : "DAY_BU");

            if ("DAY_THAY".equalsIgnoreCase(lr.getLeaveType())) {
                lr.setSubstituteLecturerId(substituteLecturerId != null && !substituteLecturerId.trim().isEmpty() ? substituteLecturerId.trim() : null);
            } else if ("DAY_BU".equalsIgnoreCase(lr.getLeaveType())) {
                if (makeupDateStr != null && !makeupDateStr.trim().isEmpty()) {
                    try {
                        java.sql.Date mDate = java.sql.Date.valueOf(makeupDateStr.trim());
                        lr.setMakeupDate(mDate);
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(mDate);
                        int dow = cal.get(java.util.Calendar.DAY_OF_WEEK);
                        int thuBu = (dow == java.util.Calendar.SUNDAY) ? 8 : dow;
                        lr.setMakeupDayOfWeek(thuBu);
                    } catch (Exception ignored) {}
                }
                if (makeupStartPeriodStr != null && !makeupStartPeriodStr.trim().isEmpty()) {
                    try {
                        lr.setMakeupStartPeriod(Integer.parseInt(makeupStartPeriodStr.trim()));
                    } catch (Exception ignored) {}
                }
                if (makeupPeriodCountStr != null && !makeupPeriodCountStr.trim().isEmpty()) {
                    try {
                        lr.setMakeupPeriodCount(Integer.parseInt(makeupPeriodCountStr.trim()));
                    } catch (Exception ignored) {}
                }
                lr.setMakeupRoom(makeupRoom != null && !makeupRoom.trim().isEmpty() ? makeupRoom.trim() : null);
            }

            leaveRequestDAO.insertLeaveRequest(lr);
            resp.sendRedirect(req.getContextPath() + "/lecturer/schedule?msg=leave_submitted");
        } else {
            doGet(req, resp);
        }
    }

    private void handleSchedule(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer)
            throws ServletException, IOException {
        String semesterId = req.getParameter("semesterId");
        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<Schedule> schedules = scheduleDAO.getSchedulesByLecturer(lecturer.getLecturerId(), semesterId);
        List<LeaveRequest> myLeaveRequests = leaveRequestDAO.getLeaveRequestsByLecturer(lecturer.getLecturerId());
        List<Lecturer> lecturers = lecturerDAO.getAllLecturers();

        req.setAttribute("semesters", semesters);
        req.setAttribute("schedules", schedules);
        req.setAttribute("myLeaveRequests", myLeaveRequests);
        req.setAttribute("lecturers", lecturers);
        req.setAttribute("selectedSemester", semesterId);
        req.getRequestDispatcher("/WEB-INF/views/lecturer/schedule.jsp").forward(req, resp);
    }

    private void handleClasses(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer)
            throws ServletException, IOException {
        String semesterId = req.getParameter("semesterId");
        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<CourseClass> classes = courseClassDAO.getCourseClassesByLecturer(lecturer.getLecturerId(), semesterId);

        req.setAttribute("semesters", semesters);
        req.setAttribute("classes", classes);
        req.setAttribute("selectedSemester", semesterId);
        req.getRequestDispatcher("/WEB-INF/views/lecturer/my-classes.jsp").forward(req, resp);
    }

    private void handleGradeInput(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer)
            throws ServletException, IOException {
        String classId = req.getParameter("classId");
        if (classId == null || classId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/lecturer/classes");
            return;
        }

        CourseClass cc = courseClassDAO.getCourseClassById(classId);
        if (cc == null || !cc.getLecturerId().equalsIgnoreCase(lecturer.getLecturerId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không được phân công giảng dạy lớp học phần này!");
            return;
        }

        List<Grade> grades = gradeDAO.getGradesByCourseClass(classId);
        Map<String, Integer> dist = gradeDAO.getGradeDistribution(classId);

        req.setAttribute("courseClass", cc);
        req.setAttribute("grades", grades);
        req.setAttribute("dist", dist);
        req.getRequestDispatcher("/WEB-INF/views/lecturer/grade-input.jsp").forward(req, resp);
    }

    private void handleSaveGrades(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer, boolean isSubmit)
            throws ServletException, IOException {
        String classId = req.getParameter("classId");
        CourseClass cc = courseClassDAO.getCourseClassById(classId);

        if (cc == null || !cc.getLecturerId().equalsIgnoreCase(lecturer.getLecturerId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Nếu lớp đã nộp chờ duyệt hoặc đã công bố thì không thể sửa điểm
        if ("PUBLISHED".equalsIgnoreCase(cc.getGradeStatus()) || "SUBMITTED".equalsIgnoreCase(cc.getGradeStatus())) {
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&error=locked");
            return;
        }

        List<Grade> grades = gradeDAO.getGradesByCourseClass(classId);
        try {
            for (Grade g : grades) {
                String ccStr = req.getParameter("cc_" + g.getId());
                String gkStr = req.getParameter("gk_" + g.getId());
                String thiStr = req.getParameter("thi_" + g.getId());
                String note = req.getParameter("note_" + g.getId());

                Double dCC = parseScore(ccStr);
                Double dGK = parseScore(gkStr);
                Double dThi = parseScore(thiStr);

                g.setScoreAttendance(dCC);
                g.setScoreMidterm(dGK);
                g.setScoreFinal(dThi);
                g.setNote(note);

                if (dThi != null) {
                    Double tk10 = GradeCalculator.calculateTotal10(dCC, dGK, dThi,
                        cc.getWeightAttendance(), cc.getWeightMidterm(), cc.getWeightFinal());
                    String letter = GradeCalculator.toLetterScore(tk10, dThi);
                    Double scale4 = GradeCalculator.toScale4(letter);
                    String result = GradeCalculator.getResult(tk10, dThi);

                    g.setScoreTotal10(tk10);
                    g.setScoreLetter(letter);
                    g.setScoreScale4(scale4);
                    g.setResult(result);
                } else {
                    g.setScoreTotal10(null);
                    g.setScoreLetter(null);
                    g.setScoreScale4(null);
                    g.setResult(null);
                }
            }
        } catch (IllegalArgumentException e) {
            String err = URLEncoder.encode(e.getMessage(), "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&errorMsg=" + err);
            return;
        }

        gradeDAO.updateBatchGrades(grades);

        if (isSubmit) {
            courseClassDAO.updateGradeStatus(classId, "SUBMITTED");
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&msg=submitted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&msg=saved");
        }
    }

    private void handleExportExcel(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer)
            throws ServletException, IOException {
        String classId = req.getParameter("classId");
        CourseClass cc = courseClassDAO.getCourseClassById(classId);
        if (cc == null || !cc.getLecturerId().equalsIgnoreCase(lecturer.getLecturerId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<Grade> grades = gradeDAO.getGradesByCourseClass(classId);

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String filename = "BangDiem_" + cc.getClassId() + ".xlsx";
        resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (OutputStream out = resp.getOutputStream()) {
            ExcelService.exportGradeTemplate(cc, grades, out);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleImportExcel(HttpServletRequest req, HttpServletResponse resp, Lecturer lecturer)
            throws ServletException, IOException {
        String classId = req.getParameter("classId");
        CourseClass cc = courseClassDAO.getCourseClassById(classId);
        if (cc == null || !cc.getLecturerId().equalsIgnoreCase(lecturer.getLecturerId())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Khóa không cho Import Excel nếu lớp đã nộp hoặc đã công bố
        if ("PUBLISHED".equalsIgnoreCase(cc.getGradeStatus()) || "SUBMITTED".equalsIgnoreCase(cc.getGradeStatus())) {
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&error=locked");
            return;
        }

        Part filePart = req.getPart("excelFile");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&error=empty_file");
            return;
        }

        try (InputStream in = filePart.getInputStream()) {
            List<Grade> currentGrades = gradeDAO.getGradesByCourseClass(classId);
            List<Grade> updatedGrades = ExcelService.importGradesFromExcel(in, cc, currentGrades);
            gradeDAO.updateBatchGrades(updatedGrades);

            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&msg=imported");
        } catch (IllegalArgumentException e) {
            String err = URLEncoder.encode(e.getMessage(), "UTF-8");
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&errorMsg=" + err);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/lecturer/grade-input?classId=" + classId + "&error=import_failed");
        }
    }

    private Double parseScore(String s) throws IllegalArgumentException {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            double v = Double.parseDouble(s.trim().replace(',', '.'));
            if (v < 0.0 || v > 10.0) {
                throw new IllegalArgumentException("Điểm '" + s + "' không hợp lệ! Điểm phải từ 0.0 đến 10.0.");
            }
            return v;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Định dạng điểm '" + s + "' không đúng số thực!");
        }
    }
}
