package vn.edu.utc.grade.config;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import vn.edu.utc.grade.model.account.User;

/**
 * Bộ lọc xác thực và phân quyền RBAC (Admin, Giảng viên, Sinh viên)
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        String path = (servletPath != null ? servletPath : "") + (pathInfo != null ? pathInfo : "");
        String contextPath = req.getContextPath();

        // Cho phép truy cập tài nguyên tĩnh và các trang công khai
        if (path.startsWith("/assets/") || path.equals("/login") || path.equals("/logout") || 
            path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Thiết lập tiêu đề HTTP bảo mật chống lưu bộ nhớ đệm (Cache-Control) cho các trang dữ liệu nhạy cảm
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        // Kiểm tra phân quyền truy cập theo vai trò
        if ((path.equals("/admin") || path.startsWith("/admin/")) && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực Quản trị!");
            return;
        }

        if ((path.equals("/lecturer") || path.startsWith("/lecturer/")) && !user.isLecturer() && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực Giảng viên!");
            return;
        }

        if ((path.equals("/student") || path.startsWith("/student/")) && !user.isStudent() && !user.isAdmin()) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập khu vực Sinh viên!");
            return;
        }

        // Nếu truy cập trang chủ "/", chuyển hướng tương ứng vai trò
        if (path.equals("/") || path.isEmpty()) {
            if (user.isAdmin()) {
                res.sendRedirect(contextPath + "/admin/dashboard");
            } else if (user.isLecturer()) {
                res.sendRedirect(contextPath + "/lecturer/classes");
            } else if (user.isStudent()) {
                res.sendRedirect(contextPath + "/student/grades");
            } else {
                res.sendRedirect(contextPath + "/login");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
