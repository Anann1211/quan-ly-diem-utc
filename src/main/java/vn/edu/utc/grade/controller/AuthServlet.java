package vn.edu.utc.grade.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import vn.edu.utc.grade.dao.account.LecturerDAO;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.account.UserDAO;
import vn.edu.utc.grade.model.account.Lecturer;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.account.User;

@WebServlet(urlPatterns = {"/login", "/logout", "/change-password"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private LecturerDAO lecturerDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        lecturerDAO = new LecturerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
        } else if ("/change-password".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
        } else {
            // /login
            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("currentUser") != null) {
                User user = (User) session.getAttribute("currentUser");
                redirectByRole(user, req, resp);
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/change-password".equals(path)) {
            handleChangePassword(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu!");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.login(username.trim(), password.trim());
        if (user == null) {
            req.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        // Phòng chống tấn công Session Fixation: Hủy session cũ trước khi cấp session mới
        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);

        // Lưu thông tin chi tiết vai trò
        if (user.isStudent()) {
            Student student = studentDAO.getStudentByUserId(user.getId());
            session.setAttribute("currentStudent", student);
        } else if (user.isLecturer()) {
            Lecturer lecturer = lecturerDAO.getLecturerByUserId(user.getId());
            session.setAttribute("currentLecturer", lecturer);
        }

        redirectByRole(user, req, resp);
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        if (newPass == null || !newPass.equals(confirmPass)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
            return;
        }

        boolean success = userDAO.changePassword(user.getId(), oldPass, newPass);
        if (success) {
            req.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            req.setAttribute("error", "Mật khẩu cũ không chính xác!");
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/change-password.jsp").forward(req, resp);
    }

    private void redirectByRole(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if (user.isLecturer()) {
            resp.sendRedirect(req.getContextPath() + "/lecturer/classes");
        } else if (user.isStudent()) {
            resp.sendRedirect(req.getContextPath() + "/student/grades");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
