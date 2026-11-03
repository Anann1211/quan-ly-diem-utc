package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.grading.AuditLogDAO;
import vn.edu.utc.grade.model.grading.AuditLog;

/**
 * Tra cứu nhật ký chỉnh sửa điểm (Audit Logs) và giám sát tính toàn vẹn hệ thống
 */
@WebServlet(urlPatterns = {
    "/admin/audit-logs"
})
public class AuditLogServlet extends HttpServlet {

    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<AuditLog> logs = auditLogDAO.getAllLogs();
        req.setAttribute("logs", logs);
        req.getRequestDispatcher("/WEB-INF/views/admin/audit-logs.jsp").forward(req, resp);
    }
}
