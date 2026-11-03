package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.ClassRoomDAO;
import vn.edu.utc.grade.dao.academic.FacultyDAO;
import vn.edu.utc.grade.dao.account.LecturerDAO;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.account.UserDAO;
import vn.edu.utc.grade.model.academic.ClassRoom;
import vn.edu.utc.grade.model.academic.Faculty;
import vn.edu.utc.grade.model.account.Lecturer;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.account.User;
import vn.edu.utc.grade.service.ExcelService;

@WebServlet("/admin/users")
public class UserManageServlet extends HttpServlet {

    private UserDAO userDAO;
    private StudentDAO studentDAO;
    private LecturerDAO lecturerDAO;
    private ClassRoomDAO classRoomDAO;
    private FacultyDAO facultyDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        studentDAO = new StudentDAO();
        lecturerDAO = new LecturerDAO();
        classRoomDAO = new ClassRoomDAO();
        facultyDAO = new FacultyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("generate_msv".equals(action)) {
            String classId = req.getParameter("classId");
            String nextId = studentDAO.generateNextStudentId(classId);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"nextId\": \"" + nextId + "\"}");
            return;
        }

        if ("export_faculty".equals(action)) {
            String facultyId = req.getParameter("facultyId");
            try {
                List<Student> students = studentDAO.getStudentsByFaculty(facultyId);
                Faculty f = (facultyId != null && !facultyId.trim().isEmpty()) ? facultyDAO.getFacultyById(facultyId.trim()) : null;
                String facultyName = (f != null) ? f.getFacultyName() : "ToanTruong";

                resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                String filename = "DanhSach_SinhVien_" + (facultyId != null && !facultyId.trim().isEmpty() ? facultyId : "All") + ".xlsx";
                resp.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

                ExcelService.exportStudentsByFaculty(facultyName, students, resp.getOutputStream());
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=export_failed");
                return;
            }
        }

        String tab = req.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "student";
        }

        String keyword = req.getParameter("keyword");
        String statusStr = req.getParameter("status");
        Integer status = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (Exception ignored) {}
        }

        String role = "SINH_VIEN";
        if ("lecturer".equalsIgnoreCase(tab)) {
            role = "GIANG_VIEN";
        } else if ("admin".equalsIgnoreCase(tab)) {
            role = "ADMIN";
        }

        List<User> users = userDAO.getAllUsers(role, keyword, status);
        List<ClassRoom> classRooms = classRoomDAO.getAllClassRooms();
        List<Faculty> faculties = facultyDAO.getAllFaculties();

        req.setAttribute("users", users);
        req.setAttribute("currentTab", tab);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", statusStr);
        req.setAttribute("classRooms", classRooms);
        req.setAttribute("faculties", faculties);

        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String tab = req.getParameter("tab");
        if (tab == null) tab = "student";

        try {
            if ("add_student".equals(action)) {
                String studentId = req.getParameter("studentId");
                String fullName = req.getParameter("fullName");
                String dobStr = req.getParameter("dateOfBirth");
                String gender = req.getParameter("gender");
                String hometown = req.getParameter("hometown");
                String classId = req.getParameter("classId");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String password = req.getParameter("password");

                if (fullName == null || fullName.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?tab=student&error=empty_fields");
                    return;
                }

                // Tự động sinh Mã SV nếu để trống hoặc chọn Tự sinh
                if (studentId == null || studentId.trim().isEmpty() || "AUTO".equalsIgnoreCase(studentId.trim())) {
                    studentId = studentDAO.generateNextStudentId(classId);
                }

                if (userDAO.isUsernameExists(studentId.trim())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?tab=student&error=user_exists");
                    return;
                }

                Student st = new Student();
                st.setStudentId(studentId.trim());
                st.setFullName(fullName.trim());
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        st.setDateOfBirth(new Date(sdf.parse(dobStr.trim()).getTime()));
                    } catch (Exception ignored) {}
                }
                st.setGender(gender != null ? gender : "Nam");
                st.setHometown(hometown != null ? hometown.trim() : "");
                st.setClassId(classId);
                st.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : studentId.trim() + "@sv.utc.edu.vn");
                st.setPhone(phone != null ? phone.trim() : "");

                studentDAO.insertStudent(st, password);
                resp.sendRedirect(req.getContextPath() + "/admin/users?tab=student&msg=student_added");
                return;

            } else if ("add_lecturer".equals(action)) {
                String lecturerId = req.getParameter("lecturerId");
                String fullName = req.getParameter("fullName");
                String academicRank = req.getParameter("academicRank");
                String facultyId = req.getParameter("facultyId");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String password = req.getParameter("password");

                if (lecturerId == null || lecturerId.trim().isEmpty() || fullName == null || fullName.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?tab=lecturer&error=empty_fields");
                    return;
                }

                if (userDAO.isUsernameExists(lecturerId.trim())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?tab=lecturer&error=user_exists");
                    return;
                }

                Lecturer gv = new Lecturer();
                gv.setLecturerId(lecturerId.trim());
                gv.setFullName(fullName.trim());
                gv.setAcademicRank(academicRank != null ? academicRank.trim() : "Giảng viên");
                gv.setFacultyId(facultyId);
                gv.setEmail(email != null ? email.trim() : "");
                gv.setPhone(phone != null ? phone.trim() : "");

                lecturerDAO.insertLecturer(gv, password);
                resp.sendRedirect(req.getContextPath() + "/admin/users?tab=lecturer&msg=lecturer_added");
                return;

            } else if ("reset_password".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String newPass = req.getParameter("newPassword");
                if (newPass == null || newPass.trim().isEmpty()) {
                    newPass = "123456";
                }
                userDAO.resetPassword(userId, newPass.trim());
                resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab + "&msg=pwd_reset");
                return;

            } else if ("toggle_status".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                int currentStatus = Integer.parseInt(req.getParameter("currentStatus"));
                userDAO.updateUserStatus(userId, currentStatus == 1 ? 0 : 1);
                resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab + "&msg=status_updated");
                return;

            } else if ("delete_user".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                User u = userDAO.getUserById(userId);
                if (u != null) {
                    if (u.isStudent()) {
                        studentDAO.deleteStudent(u.getUsername());
                    } else if (u.isLecturer()) {
                        lecturerDAO.deleteLecturer(u.getUsername());
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab + "&msg=user_deleted");
                return;
            }
        } catch (IllegalStateException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab + "&error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
            return;
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab + "&error=operation_failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users?tab=" + tab);
    }
}
