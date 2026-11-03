package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import vn.edu.utc.grade.dao.academic.ClassRoomDAO;
import vn.edu.utc.grade.dao.academic.FacultyDAO;
import vn.edu.utc.grade.dao.academic.MajorDAO;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.account.UserDAO;
import vn.edu.utc.grade.model.academic.ClassRoom;
import vn.edu.utc.grade.model.academic.Faculty;
import vn.edu.utc.grade.model.academic.Major;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.service.ExcelService;

@WebServlet("/admin/academic-classes")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AcademicClassServlet extends HttpServlet {

    private ClassRoomDAO classRoomDAO;
    private FacultyDAO facultyDAO;
    private MajorDAO majorDAO;
    private StudentDAO studentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        classRoomDAO = new ClassRoomDAO();
        facultyDAO = new FacultyDAO();
        majorDAO = new MajorDAO();
        studentDAO = new StudentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("download_template".equals(action)) {
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=\"Mau_Nhap_Sinh_Vien_UTC.xlsx\"");
            try (OutputStream out = resp.getOutputStream()) {
                ExcelService.exportStudentTemplate(out);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        if ("detail".equals(action)) {
            String classId = req.getParameter("classId");
            ClassRoom cr = classRoomDAO.getClassRoomById(classId);
            if (cr == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?error=not_found");
                return;
            }
            List<Student> students = studentDAO.getStudentsByClass(classId);
            req.setAttribute("classRoom", cr);
            req.setAttribute("students", students);
            req.setAttribute("isDetailView", true);
            req.getRequestDispatcher("/WEB-INF/views/admin/academic-classes.jsp").forward(req, resp);
            return;
        }

        // List view
        String intakeYearStr = req.getParameter("intakeYear");
        Integer intakeYear = null;
        if (intakeYearStr != null && !intakeYearStr.trim().isEmpty()) {
            try {
                intakeYear = Integer.parseInt(intakeYearStr);
            } catch (Exception ignored) {}
        }
        String facultyId = req.getParameter("facultyId");
        String majorId = req.getParameter("majorId");

        List<ClassRoom> classes = classRoomDAO.getClassRoomsByFilters(intakeYear, facultyId, majorId);
        List<Integer> intakeYears = classRoomDAO.getIntakeYears();
        List<Faculty> faculties = facultyDAO.getAllFaculties();
        List<Major> majors = (facultyId != null && !facultyId.trim().isEmpty()) 
                             ? majorDAO.getMajorsByFaculty(facultyId) 
                             : majorDAO.getAllMajors();

        req.setAttribute("classes", classes);
        req.setAttribute("intakeYears", intakeYears);
        req.setAttribute("faculties", faculties);
        req.setAttribute("majors", majors);
        req.setAttribute("selectedIntakeYear", intakeYear);
        req.setAttribute("selectedFaculty", facultyId);
        req.setAttribute("selectedMajor", majorId);
        req.setAttribute("isDetailView", false);

        req.getRequestDispatcher("/WEB-INF/views/admin/academic-classes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add_class".equals(action)) {
                String classId = req.getParameter("classId");
                String className = req.getParameter("className");
                int intakeYear = Integer.parseInt(req.getParameter("intakeYear"));
                String majorId = req.getParameter("majorId");

                if (classId == null || classId.trim().isEmpty() || className == null || className.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?error=empty_fields");
                    return;
                }

                ClassRoom existing = classRoomDAO.getClassRoomById(classId.trim());
                if (existing != null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?error=class_exists");
                    return;
                }

                ClassRoom cr = new ClassRoom(classId.trim(), className.trim(), intakeYear, majorId);
                classRoomDAO.insertClassRoom(cr);
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?msg=class_added");
                return;

            } else if ("edit_class".equals(action)) {
                String classId = req.getParameter("classId");
                String className = req.getParameter("className");
                int intakeYear = Integer.parseInt(req.getParameter("intakeYear"));
                String majorId = req.getParameter("majorId");

                ClassRoom cr = new ClassRoom(classId.trim(), className.trim(), intakeYear, majorId);
                classRoomDAO.updateClassRoom(cr);
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?msg=class_updated");
                return;

            } else if ("delete_class".equals(action)) {
                String classId = req.getParameter("classId");
                classRoomDAO.deleteClassRoom(classId);
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?msg=class_deleted");
                return;

            } else if ("add_student".equals(action)) {
                String classId = req.getParameter("classId");
                String studentId = req.getParameter("studentId");
                String fullName = req.getParameter("fullName");
                String dobStr = req.getParameter("dateOfBirth");
                String gender = req.getParameter("gender");
                String hometown = req.getParameter("hometown");
                String email = req.getParameter("email");
                String phone = req.getParameter("phone");
                String password = req.getParameter("password");

                if (studentId == null || studentId.trim().isEmpty() || fullName == null || fullName.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId + "&error=empty_fields");
                    return;
                }

                if (userDAO.isUsernameExists(studentId.trim())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId + "&error=user_exists");
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
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId + "&msg=student_added");
                return;

            } else if ("import_excel".equals(action)) {
                String classId = req.getParameter("classId");
                Part filePart = req.getPart("excelFile");
                if (filePart == null || filePart.getSize() == 0) {
                    req.getSession().setAttribute("importErrors", java.util.Collections.singletonList("Vui lòng chọn tệp Excel (.xlsx hoặc .xls) có dữ liệu để tải lên!"));
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId);
                    return;
                }

                String fileName = filePart.getSubmittedFileName();
                if (fileName == null || (!fileName.toLowerCase().endsWith(".xlsx") && !fileName.toLowerCase().endsWith(".xls"))) {
                    req.getSession().setAttribute("importErrors", java.util.Collections.singletonList("Tệp tải lên không đúng định dạng. Hệ thống chỉ hỗ trợ tệp Excel đuôi .xlsx hoặc .xls!"));
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId);
                    return;
                }

                ExcelService.StudentImportResult result;
                try (InputStream is = filePart.getInputStream()) {
                    result = ExcelService.parseAndValidateStudents(is, fileName, classId, studentDAO, userDAO);
                }

                if (result.hasErrors()) {
                    req.getSession().setAttribute("importErrors", result.getErrorMessages());
                    resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId);
                    return;
                }

                // Thực hiện lưu an toàn bằng Transaction
                int success = studentDAO.insertStudentsTransaction(result.getValidStudents(), classId, "sv123");
                req.getSession().setAttribute("importSuccessMsg", 
                    "Thêm danh sách sinh viên từ Excel thành công! Đã thêm thành công " + success + " sinh viên vào lớp " + classId + ".");
                resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?action=detail&classId=" + classId);
                return;
            }
        } catch (IllegalStateException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?error=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
            return;
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/academic-classes?error=operation_failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/academic-classes");
    }
}
