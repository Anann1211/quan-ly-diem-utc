package vn.edu.utc.grade.controller.student;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.ScheduleDAO;
import vn.edu.utc.grade.dao.academic.SemesterDAO;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.grading.AppealDAO;
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.Schedule;
import vn.edu.utc.grade.model.academic.Semester;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.grading.Appeal;
import vn.edu.utc.grade.model.grading.Grade;
import vn.edu.utc.grade.service.GradeCalculator;

@WebServlet(urlPatterns = {
    "/student/grades",
    "/student/appeals",
    "/student/submit-appeal",
    "/student/print-transcript",
    "/student/schedule"
})
public class StudentServlet extends HttpServlet {

    private StudentDAO studentDAO;
    private GradeDAO gradeDAO;
    private SemesterDAO semesterDAO;
    private AppealDAO appealDAO;
    private ScheduleDAO scheduleDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        gradeDAO = new GradeDAO();
        semesterDAO = new SemesterDAO();
        appealDAO = new AppealDAO();
        scheduleDAO = new ScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");
        Student student = (Student) req.getSession().getAttribute("currentStudent");
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (path) {
            case "/student/grades":
                handleGrades(req, resp, student);
                break;
            case "/student/appeals":
                handleAppeals(req, resp, student);
                break;
            case "/student/print-transcript":
                handlePrintTranscript(req, resp, student);
                break;
            case "/student/schedule":
                handleSchedule(req, resp, student);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/student/grades");
                break;
        }
    }

    private void handleSchedule(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        String semesterId = req.getParameter("semesterId");
        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<Schedule> schedules = scheduleDAO.getSchedulesByStudent(student.getStudentId(), semesterId);

        req.setAttribute("semesters", semesters);
        req.setAttribute("schedules", schedules);
        req.setAttribute("selectedSemester", semesterId);
        req.getRequestDispatcher("/WEB-INF/views/student/schedule.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");
        Student student = (Student) req.getSession().getAttribute("currentStudent");
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/student/submit-appeal".equals(path)) {
            String gradeIdStr = req.getParameter("gradeId");
            String reason = req.getParameter("reason");

            int gradeId;
            try {
                gradeId = Integer.parseInt(gradeIdStr);
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/student/appeals?error=invalid_grade");
                return;
            }

            if (reason == null || reason.trim().length() < 5) {
                resp.sendRedirect(req.getContextPath() + "/student/appeals?error=short_reason");
                return;
            }

            // Kiểm tra chống nộp trùng: Nếu đã có đơn PENDING thì không cho nộp thêm
            if (appealDAO.hasPendingAppeal(gradeId)) {
                resp.sendRedirect(req.getContextPath() + "/student/appeals?error=duplicate");
                return;
            }

            Grade g = gradeDAO.getGradeById(gradeId);
            if (g != null && g.getStudentId().equalsIgnoreCase(student.getStudentId())) {
                Appeal appeal = new Appeal();
                appeal.setGradeId(gradeId);
                appeal.setStudentId(student.getStudentId());
                appeal.setReason(reason.trim());
                appeal.setOldFinalScore(g.getScoreFinal());
                appeal.setNote("Sinh viên nộp đơn trực tuyến");
                appealDAO.insertAppeal(appeal);
                resp.sendRedirect(req.getContextPath() + "/student/appeals?msg=submitted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/appeals?error=forbidden");
            }
        } else {
            doGet(req, resp);
        }
    }

    private void handleGrades(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        String semesterId = req.getParameter("semesterId");
        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<Grade> grades = gradeDAO.getGradesByStudent(student.getStudentId(), semesterId);

        // Tính GPA của học kỳ được chọn
        Double semesterGpa = GradeCalculator.calculateAverageScale4(grades);

        // Tính CPA toàn khóa
        studentDAO.calculateCPA(student);

        // Xếp loại học lực
        String academicRank = GradeCalculator.getAcademicRank(student.getCpa());
        String academicWarning = GradeCalculator.getAcademicWarning(student.getCpa());

        req.setAttribute("semesters", semesters);
        req.setAttribute("grades", grades);
        req.setAttribute("selectedSemester", semesterId);
        req.setAttribute("semesterGpa", semesterGpa);
        req.setAttribute("academicRank", academicRank);
        req.setAttribute("academicWarning", academicWarning);
        req.getRequestDispatcher("/WEB-INF/views/student/my-grades.jsp").forward(req, resp);
    }

    private void handleAppeals(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        List<Appeal> appeals = appealDAO.getAppealsByStudent(student.getStudentId());
        // Lấy danh sách điểm các môn đã công bố để sinh viên chọn phúc khảo
        List<Grade> availableGrades = gradeDAO.getGradesByStudent(student.getStudentId(), null);

        req.setAttribute("appeals", appeals);
        req.setAttribute("availableGrades", availableGrades);
        req.getRequestDispatcher("/WEB-INF/views/student/appeals.jsp").forward(req, resp);
    }

    private void handlePrintTranscript(HttpServletRequest req, HttpServletResponse resp, Student student)
            throws ServletException, IOException {
        studentDAO.calculateCPA(student);
        List<Grade> allGrades = gradeDAO.getGradesByStudent(student.getStudentId(), null);
        String academicRank = GradeCalculator.getAcademicRank(student.getCpa());

        req.setAttribute("student", student);
        req.setAttribute("allGrades", allGrades);
        req.setAttribute("academicRank", academicRank);
        req.getRequestDispatcher("/WEB-INF/views/student/transcript-print.jsp").forward(req, resp);
    }
}
