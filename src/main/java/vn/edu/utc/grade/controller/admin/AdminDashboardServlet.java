package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.LeaveRequestDAO;
import vn.edu.utc.grade.dao.grading.AppealDAO;
import vn.edu.utc.grade.dao.grading.StatisticsDAO;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.grading.Appeal;

/**
 * Điều hướng Bảng điều khiển (Dashboard) và Thống kê tổng quan đào tạo UTC
 */
@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/statistics"
})
public class AdminDashboardServlet extends HttpServlet {

    private StatisticsDAO statisticsDAO;
    private AppealDAO appealDAO;
    private LeaveRequestDAO leaveRequestDAO;

    @Override
    public void init() throws ServletException {
        statisticsDAO = new StatisticsDAO();
        appealDAO = new AppealDAO();
        leaveRequestDAO = new LeaveRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");

        if ("/admin/statistics".equals(path)) {
            handleStatistics(req, resp);
        } else {
            handleDashboard(req, resp);
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Integer> summary = statisticsDAO.getDashboardSummary();
        Map<String, Integer> dist = statisticsDAO.getOverallGradeDistribution();
        List<Student> topStudents = statisticsDAO.getTopStudents(5);
        List<Appeal> recentAppeals = appealDAO.getAllAppeals();
        if (recentAppeals.size() > 5) {
            recentAppeals = recentAppeals.subList(0, 5);
        }

        int pendingLeavesCount = leaveRequestDAO.countPendingLeaveRequests();

        req.setAttribute("summary", summary);
        req.setAttribute("gradeDist", dist);
        req.setAttribute("topStudents", topStudents);
        req.setAttribute("recentAppeals", recentAppeals);
        req.setAttribute("pendingLeavesCount", pendingLeavesCount);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void handleStatistics(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Integer> summary = statisticsDAO.getDashboardSummary();
        Map<String, Integer> dist = statisticsDAO.getOverallGradeDistribution();
        List<Student> topStudents = statisticsDAO.getTopStudents(10);
        List<Student> warningStudents = statisticsDAO.getWarningStudents();

        req.setAttribute("summary", summary);
        req.setAttribute("dist", dist);
        req.setAttribute("topStudents", topStudents);
        req.setAttribute("warningStudents", warningStudents);
        req.getRequestDispatcher("/WEB-INF/views/admin/statistics.jsp").forward(req, resp);
    }
}
