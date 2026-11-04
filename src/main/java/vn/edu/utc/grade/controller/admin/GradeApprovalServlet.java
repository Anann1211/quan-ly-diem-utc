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
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.grading.Grade;

/**
 * Phê duyệt bảng điểm học phần và công bố điểm
 */
@WebServlet("/admin/grade-approval")
public class GradeApprovalServlet extends HttpServlet {

    private CourseClassDAO courseClassDAO;
    private GradeDAO gradeDAO;

    @Override
    public void init() throws ServletException {
        courseClassDAO = new CourseClassDAO();
        gradeDAO = new GradeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
    }
}
