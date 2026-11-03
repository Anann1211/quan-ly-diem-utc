package vn.edu.utc.grade.controller.admin;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import vn.edu.utc.grade.dao.academic.ClassRoomDAO;
import vn.edu.utc.grade.dao.academic.FacultyDAO;
import vn.edu.utc.grade.dao.academic.SubjectDAO;
import vn.edu.utc.grade.dao.grading.GradeDAO;
import vn.edu.utc.grade.model.academic.ClassRoom;
import vn.edu.utc.grade.model.academic.Faculty;
import vn.edu.utc.grade.model.academic.Subject;
import vn.edu.utc.grade.model.grading.Grade;
import vn.edu.utc.grade.service.ExcelService;

@WebServlet("/admin/faculty-grades")
public class FacultyGradeServlet extends HttpServlet {

    private ClassRoomDAO classRoomDAO;
    private FacultyDAO facultyDAO;
    private SubjectDAO subjectDAO;
    private GradeDAO gradeDAO;

    @Override
    public void init() throws ServletException {
        classRoomDAO = new ClassRoomDAO();
        facultyDAO = new FacultyDAO();
        subjectDAO = new SubjectDAO();
        gradeDAO = new GradeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String intakeYearStr = req.getParameter("intakeYear");
        Integer intakeYear = null;
        if (intakeYearStr != null && !intakeYearStr.trim().isEmpty()) {
            try {
                intakeYear = Integer.parseInt(intakeYearStr);
            } catch (Exception ignored) {}
        }

        String facultyId = req.getParameter("facultyId");
        String classId = req.getParameter("classId");
        String subjectId = req.getParameter("subjectId");
        String export = req.getParameter("export");

        List<Integer> intakeYears = classRoomDAO.getIntakeYears();
        List<Faculty> faculties = facultyDAO.getAllFaculties();
        List<ClassRoom> classes = classRoomDAO.getClassRoomsByFilters(intakeYear, facultyId, null);
        List<Subject> subjects = subjectDAO.getAllSubjects();

        List<Grade> grades = null;
        int totalStudents = 0;
        int passCount = 0;
        int failCount = 0;
        double passRate = 0.0;
        double failRate = 0.0;
        double averageScore10 = 0.0;

        ClassRoom selectedClass = null;
        Subject selectedSubject = null;
        Faculty selectedFaculty = null;

        if (classId != null && !classId.trim().isEmpty() && subjectId != null && !subjectId.trim().isEmpty()) {
            selectedClass = classRoomDAO.getClassRoomById(classId);
            selectedSubject = subjectDAO.getSubjectById(subjectId);
            if (facultyId != null && !facultyId.trim().isEmpty()) {
                selectedFaculty = facultyDAO.getFacultyById(facultyId);
            }

            grades = gradeDAO.getGradesByClassAndSubject(classId, subjectId);
            totalStudents = grades.size();

            double sumScore = 0.0;
            int scoredCount = 0;

            for (Grade g : grades) {
                if ("DAT".equalsIgnoreCase(g.getResult())) {
                    passCount++;
                } else if ("KHONG_DAT".equalsIgnoreCase(g.getResult())) {
                    failCount++;
                }

                if (g.getScoreTotal10() != null) {
                    sumScore += g.getScoreTotal10();
                    scoredCount++;
                }
            }

            if (scoredCount > 0) {
                averageScore10 = Math.round((sumScore / scoredCount) * 100.0) / 100.0;
            }
            if (totalStudents > 0) {
                passRate = Math.round(((double) passCount / totalStudents * 100.0) * 10.0) / 10.0;
                failRate = Math.round(((double) failCount / totalStudents * 100.0) * 10.0) / 10.0;
            }

            // Export Excel
            if ("excel".equalsIgnoreCase(export)) {
                resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                resp.setHeader("Content-Disposition", "attachment; filename=\"Bang_Diem_" + classId + "_" + subjectId + ".xlsx\"");
                try (OutputStream out = resp.getOutputStream()) {
                    ExcelService.exportClassroomGradeSheet(
                        classId,
                        selectedClass != null ? selectedClass.getClassName() : classId,
                        selectedSubject != null ? selectedSubject.getSubjectName() : subjectId,
                        selectedFaculty != null ? selectedFaculty.getFacultyName() : "",
                        grades,
                        out
                    );
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return;
            }
        }

        req.setAttribute("intakeYears", intakeYears);
        req.setAttribute("faculties", faculties);
        req.setAttribute("classes", classes);
        req.setAttribute("subjects", subjects);

        req.setAttribute("selectedIntakeYear", intakeYear);
        req.setAttribute("selectedFaculty", facultyId);
        req.setAttribute("selectedClassId", classId);
        req.setAttribute("selectedSubjectId", subjectId);

        req.setAttribute("selectedClass", selectedClass);
        req.setAttribute("selectedSubject", selectedSubject);
        req.setAttribute("selectedFacultyObj", selectedFaculty);

        req.setAttribute("grades", grades);
        req.setAttribute("totalStudents", totalStudents);
        req.setAttribute("passCount", passCount);
        req.setAttribute("failCount", failCount);
        req.setAttribute("passRate", passRate);
        req.setAttribute("failRate", failRate);
        req.setAttribute("averageScore10", averageScore10);

        req.getRequestDispatcher("/WEB-INF/views/admin/faculty-grades.jsp").forward(req, resp);
    }
}
