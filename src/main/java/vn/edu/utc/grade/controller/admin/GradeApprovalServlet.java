package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.CourseClassDAO;
import vn.edu.utc.grade.dao.grading.AppealDAO;
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.account.User;
import vn.edu.utc.grade.model.grading.Appeal;
import vn.edu.utc.grade.model.grading.Grade;

/**
 * Phê duyệt bảng điểm học phần và xử lý đơn phúc khảo trực tuyến
 */
@WebServlet(urlPatterns = {
    "/admin/grade-approval",
    "/admin/appeals"
})
public class GradeApprovalServlet extends HttpServlet {

    private CourseClassDAO courseClassDAO;
    private GradeDAO gradeDAO;
    private AppealDAO appealDAO;

    @Override
    public void init() throws ServletException {
        courseClassDAO = new CourseClassDAO();
        gradeDAO = new GradeDAO();
        appealDAO = new AppealDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");

        if ("/admin/appeals".equals(path)) {
            handleAppeals(req, resp);
        } else {
            handleGradeApproval(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");

        if ("/admin/grade-approval".equals(path)) {
            String action = req.getParameter("action");
            String classId = req.getParameter("classId");
            if ("remove_student".equals(action)) {
                String studentId = req.getParameter("studentId");
                CourseClass cc = courseClassDAO.getCourseClassById(classId);
                if (cc != null && !"PUBLISHED".equalsIgnoreCase(cc.getGradeStatus())) {
                    gradeDAO.removeStudentFromCourseClass(classId, studentId);
                    resp.sendRedirect(req.getContextPath() + "/admin/grade-approval?classId=" + classId + "&msg=student_withdrawn");
                    return;
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/grade-approval?classId=" + classId + "&error=cannot_withdraw_published");
                    return;
                }
            }
            String newStatus = req.getParameter("status"); // PUBLISHED hoặc DRAFT
            courseClassDAO.updateGradeStatus(classId, newStatus);
            resp.sendRedirect(req.getContextPath() + "/admin/grade-approval?classId=" + classId + "&msg=" + newStatus);
            return;
        }

        if ("/admin/appeals".equals(path)) {
            int appealId = Integer.parseInt(req.getParameter("appealId"));
            String status = req.getParameter("status"); // APPROVED hoặc REJECTED
            String newScoreStr = req.getParameter("newFinalScore");
            Double newScore = (newScoreStr != null && !newScoreStr.trim().isEmpty()) ? Double.parseDouble(newScoreStr) : null;
            String note = req.getParameter("note");
            User currentUser = (User) req.getSession().getAttribute("currentUser");
            String processedBy = (currentUser != null) ? currentUser.getFullName() : "Phòng Đào Tạo";

            appealDAO.processAppeal(appealId, status, newScore, note, processedBy);
            resp.sendRedirect(req.getContextPath() + "/admin/appeals?msg=processed");
            return;
        }

        doGet(req, resp);
    }

    private void handleGradeApproval(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String classId = req.getParameter("classId");
        List<CourseClass> classes = courseClassDAO.getAllCourseClasses(null);
        req.setAttribute("classes", classes);

        if (classId != null && !classId.trim().isEmpty()) {
            CourseClass targetClass = courseClassDAO.getCourseClassById(classId);
            List<Grade> grades = gradeDAO.getGradesByCourseClass(classId);
            Map<String, Integer> dist = gradeDAO.getGradeDistribution(classId);

            req.setAttribute("targetClass", targetClass);
            req.setAttribute("grades", grades);
            req.setAttribute("dist", dist);
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/grade-approval.jsp").forward(req, resp);
    }

    private void handleAppeals(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Appeal> appeals = appealDAO.getAllAppeals();
        req.setAttribute("appeals", appeals);
        req.getRequestDispatcher("/WEB-INF/views/admin/appeals.jsp").forward(req, resp);
    }
}
