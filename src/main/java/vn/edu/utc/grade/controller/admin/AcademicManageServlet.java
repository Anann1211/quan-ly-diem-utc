package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.ClassRoomDAO;
import vn.edu.utc.grade.dao.academic.CourseClassDAO;
import vn.edu.utc.grade.dao.academic.SemesterDAO;
import vn.edu.utc.grade.dao.academic.SubjectDAO;
import vn.edu.utc.grade.dao.account.LecturerDAO;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.ClassRoom;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.academic.Semester;
import vn.edu.utc.grade.model.academic.Subject;
import vn.edu.utc.grade.model.account.Lecturer;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.grading.Grade;

/**
 * Quản lý học phần môn học, lớp học phần và cấu hình học kỳ
 */
@WebServlet(urlPatterns = {
    "/admin/subjects",
    "/admin/classes"
})
public class AcademicManageServlet extends HttpServlet {

    private SubjectDAO subjectDAO;
    private CourseClassDAO courseClassDAO;
    private LecturerDAO lecturerDAO;
    private SemesterDAO semesterDAO;
    private GradeDAO gradeDAO;
    private StudentDAO studentDAO;
    private ClassRoomDAO classRoomDAO;

    @Override
    public void init() throws ServletException {
        subjectDAO = new SubjectDAO();
        courseClassDAO = new CourseClassDAO();
        lecturerDAO = new LecturerDAO();
        semesterDAO = new SemesterDAO();
        gradeDAO = new GradeDAO();
        studentDAO = new StudentDAO();
        classRoomDAO = new ClassRoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");

        if ("/admin/classes".equals(path)) {
            handleClasses(req, resp);
        } else {
            handleSubjects(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String path = req.getServletPath() + (req.getPathInfo() != null ? req.getPathInfo() : "");

        if ("/admin/subjects".equals(path)) {
            try {
                if ("add".equals(action) || "edit".equals(action)) {
                    String subjectId = req.getParameter("subjectId");
                    String subjectName = req.getParameter("subjectName");
                    int credits = Integer.parseInt(req.getParameter("credits"));
                    double wCC = Double.parseDouble(req.getParameter("weightAttendance"));
                    double wGK = Double.parseDouble(req.getParameter("weightMidterm"));
                    double wThi = Double.parseDouble(req.getParameter("weightFinal"));
                    String subjectType = req.getParameter("subjectType");

                    if (subjectId == null || subjectId.trim().isEmpty() || subjectName == null || subjectName.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=empty_fields");
                        return;
                    }

                    if (credits <= 0) {
                        resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=invalid_credits");
                        return;
                    }

                    // Validate tổng trọng số phải chính xác 100%
                    if (Math.round(wCC + wGK + wThi) != 100) {
                        resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=invalid_weights");
                        return;
                    }

                    Subject s = new Subject(subjectId.trim(), subjectName.trim(), credits, wCC / 100.0, wGK / 100.0, wThi / 100.0, subjectType);
                    if ("add".equals(action)) {
                        subjectDAO.insertSubject(s);
                    } else {
                        subjectDAO.updateSubject(s);
                    }
                } else if ("delete".equals(action)) {
                    subjectDAO.deleteSubject(req.getParameter("subjectId"));
                }
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/subjects?error=operation_failed");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/subjects");
            return;
        }

        if ("/admin/classes".equals(path)) {
            try {
                if ("add".equals(action)) {
                    String classId = req.getParameter("classId");
                    String className = req.getParameter("className");
                    String subjectId = req.getParameter("subjectId");
                    String semesterId = req.getParameter("semesterId");
                    String lecturerId = req.getParameter("lecturerId");
                    String room = req.getParameter("room");
                    int enrolledCount = Integer.parseInt(req.getParameter("enrolledCount"));

                    if (classId == null || classId.trim().isEmpty() || className == null || className.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?error=empty_fields");
                        return;
                    }

                    CourseClass cc = new CourseClass();
                    cc.setClassId(classId.trim());
                    cc.setClassName(className.trim());
                    cc.setSubjectId(subjectId);
                    cc.setSemesterId(semesterId);
                    cc.setLecturerId(lecturerId);
                    cc.setRoom(room);
                    cc.setEnrolledCount(Math.max(0, enrolledCount));
                    cc.setGradeStatus("DRAFT");
                    courseClassDAO.insertCourseClass(cc);
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?msg=class_added");
                    return;
                } else if ("edit".equals(action)) {
                    String classId = req.getParameter("classId");
                    String className = req.getParameter("className");
                    String subjectId = req.getParameter("subjectId");
                    String semesterId = req.getParameter("semesterId");
                    String lecturerId = req.getParameter("lecturerId");
                    String room = req.getParameter("room");
                    int enrolledCount = Integer.parseInt(req.getParameter("enrolledCount"));

                    CourseClass cc = new CourseClass();
                    cc.setClassId(classId.trim());
                    cc.setClassName(className.trim());
                    cc.setSubjectId(subjectId);
                    cc.setSemesterId(semesterId);
                    cc.setLecturerId(lecturerId);
                    cc.setRoom(room);
                    cc.setEnrolledCount(Math.max(0, enrolledCount));
                    courseClassDAO.updateCourseClass(cc);
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?msg=class_updated");
                    return;
                } else if ("delete".equals(action)) {
                    String classId = req.getParameter("classId");
                    courseClassDAO.deleteCourseClass(classId);
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?msg=class_deleted");
                    return;
                } else if ("remove_student".equals(action)) {
                    String classId = req.getParameter("classId");
                    String studentId = req.getParameter("studentId");
                    CourseClass cc = courseClassDAO.getCourseClassById(classId);
                    if (cc == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?error=not_found");
                        return;
                    }
                    if ("PUBLISHED".equalsIgnoreCase(cc.getGradeStatus())) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&error=class_published");
                        return;
                    }
                    gradeDAO.removeStudentFromCourseClass(classId, studentId);
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&msg=student_withdrawn");
                    return;
                } else if ("add_student_to_class".equals(action)) {
                    String classId = req.getParameter("classId");
                    String studentId = req.getParameter("studentId");
                    if (studentId == null || studentId.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&error=empty_student_id");
                        return;
                    }
                    studentId = studentId.trim();
                    Student st = studentDAO.getStudentById(studentId);
                    if (st == null) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&error=student_not_found");
                        return;
                    }
                    if (gradeDAO.isStudentEnrolledInCourseClass(classId, studentId)) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&error=student_already_enrolled");
                        return;
                    }
                    gradeDAO.addStudentToCourseClass(classId, studentId);
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&msg=student_enrolled");
                    return;
                } else if ("batch_enroll_class".equals(action)) {
                    String classId = req.getParameter("classId");
                    String classRoomId = req.getParameter("classRoomId");
                    if (classRoomId == null || classRoomId.trim().isEmpty()) {
                        resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&error=empty_classroom");
                        return;
                    }
                    int enrolledCount = gradeDAO.batchEnrollClassRoom(classId, classRoomId.trim());
                    resp.sendRedirect(req.getContextPath() + "/admin/classes?action=students&classId=" + classId + "&msg=batch_enrolled&count=" + enrolledCount);
                    return;
                }
            } catch (IllegalStateException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/classes?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
                return;
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/classes?error=operation_failed");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        doGet(req, resp);
    }

    private void handleSubjects(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Subject> subjects = subjectDAO.getAllSubjects();
        req.setAttribute("subjects", subjects);
        req.getRequestDispatcher("/WEB-INF/views/admin/subjects.jsp").forward(req, resp);
    }

    private void handleClasses(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("students".equals(action)) {
            String classId = req.getParameter("classId");
            CourseClass targetClass = courseClassDAO.getCourseClassById(classId);
            if (targetClass == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/classes?error=not_found");
                return;
            }
            List<Grade> roster = gradeDAO.getGradesByCourseClass(classId);
            List<ClassRoom> classRooms = classRoomDAO.getAllClassRooms();
            req.setAttribute("targetClass", targetClass);
            req.setAttribute("roster", roster);
            req.setAttribute("classRooms", classRooms);
            req.getRequestDispatcher("/WEB-INF/views/admin/course-class-roster.jsp").forward(req, resp);
            return;
        }

        String semesterId = req.getParameter("semesterId");
        List<Semester> semesters = semesterDAO.getAllSemesters();
        List<CourseClass> classes = courseClassDAO.getAllCourseClasses(semesterId);
        List<Subject> subjects = subjectDAO.getAllSubjects();
        List<Lecturer> lecturers = lecturerDAO.getAllLecturers();

        req.setAttribute("semesters", semesters);
        req.setAttribute("classes", classes);
        req.setAttribute("subjects", subjects);
        req.setAttribute("lecturers", lecturers);
        req.setAttribute("selectedSemester", semesterId);
        req.getRequestDispatcher("/WEB-INF/views/admin/classes.jsp").forward(req, resp);
    }
}
