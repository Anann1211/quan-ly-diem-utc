package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.CourseClass;

public class CourseClassDAO {

    public List<CourseClass> getAllCourseClasses(String semesterId) {
        List<CourseClass> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.MA_LHP, l.TEN_LHP, l.MA_MON, m.TEN_MON, m.SO_TIN_CHI, m.TY_LE_CC, m.TY_LE_GK, m.TY_LE_THI, " +
            "l.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, l.MA_GV, g.HO_TEN AS TEN_GV, l.PHONG_HOC, l.SI_SO, l.TRANG_THAI_DIEM " +
            "FROM LOP_HOC_PHAN l " +
            "JOIN MON_HOC m ON l.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON l.MA_HOC_KY = h.MA_HOC_KY " +
            "LEFT JOIN GIANG_VIEN g ON l.MA_GV = g.MA_GV "
        );
        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("WHERE l.MA_HOC_KY = ? ");
        }
        sql.append("ORDER BY l.MA_LHP ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(1, semesterId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                CourseClass cc = extractCourseClass(rs);
                list.add(cc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<CourseClass> getCourseClassesByLecturer(String lecturerId, String semesterId) {
        List<CourseClass> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.MA_LHP, l.TEN_LHP, l.MA_MON, m.TEN_MON, m.SO_TIN_CHI, m.TY_LE_CC, m.TY_LE_GK, m.TY_LE_THI, " +
            "l.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, l.MA_GV, g.HO_TEN AS TEN_GV, l.PHONG_HOC, l.SI_SO, l.TRANG_THAI_DIEM " +
            "FROM LOP_HOC_PHAN l " +
            "JOIN MON_HOC m ON l.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON l.MA_HOC_KY = h.MA_HOC_KY " +
            "JOIN GIANG_VIEN g ON l.MA_GV = g.MA_GV " +
            "WHERE l.MA_GV = ? "
        );
        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("AND l.MA_HOC_KY = ? ");
        }
        sql.append("ORDER BY l.MA_LHP ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, lecturerId);
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(2, semesterId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                CourseClass cc = extractCourseClass(rs);
                list.add(cc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public CourseClass getCourseClassById(String classId) {
        String sql = "SELECT l.MA_LHP, l.TEN_LHP, l.MA_MON, m.TEN_MON, m.SO_TIN_CHI, m.TY_LE_CC, m.TY_LE_GK, m.TY_LE_THI, " +
                     "l.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, l.MA_GV, g.HO_TEN AS TEN_GV, l.PHONG_HOC, l.SI_SO, l.TRANG_THAI_DIEM " +
                     "FROM LOP_HOC_PHAN l " +
                     "JOIN MON_HOC m ON l.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON l.MA_HOC_KY = h.MA_HOC_KY " +
                     "LEFT JOIN GIANG_VIEN g ON l.MA_GV = g.MA_GV " +
                     "WHERE l.MA_LHP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractCourseClass(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public boolean updateGradeStatus(String classId, String status) {
        String sql = "UPDATE LOP_HOC_PHAN SET TRANG_THAI_DIEM = ? WHERE MA_LHP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, classId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean insertCourseClass(CourseClass c) {
        String sql = "INSERT INTO LOP_HOC_PHAN (MA_LHP, TEN_LHP, MA_MON, MA_HOC_KY, MA_GV, PHONG_HOC, SI_SO, TRANG_THAI_DIEM) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, c.getClassId());
            ps.setString(2, c.getClassName());
            ps.setString(3, c.getSubjectId());
            ps.setString(4, c.getSemesterId());
            ps.setString(5, c.getLecturerId());
            ps.setString(6, c.getRoom());
            ps.setInt(7, c.getEnrolledCount());
            ps.setString(8, c.getGradeStatus() != null ? c.getGradeStatus() : "DRAFT");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public int countGrades(String classId) {
        String sql = "SELECT COUNT(*) FROM BANG_DIEM WHERE MA_LHP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return 0;
    }

    public int countPendingAppeals(String classId) {
        String sql = "SELECT COUNT(*) FROM PHUC_KHAO pk " +
                     "JOIN BANG_DIEM bd ON pk.BANG_DIEM_ID = bd.ID " +
                     "WHERE bd.MA_LHP = ? AND pk.TRANG_THAI = 'PENDING'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return 0;
    }

    public boolean updateCourseClass(CourseClass c) {
        String sql = "UPDATE LOP_HOC_PHAN SET TEN_LHP = ?, MA_MON = ?, MA_HOC_KY = ?, MA_GV = ?, " +
                     "PHONG_HOC = ?, SI_SO = ? WHERE MA_LHP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, c.getClassName());
            ps.setString(2, c.getSubjectId());
            ps.setString(3, c.getSemesterId());
            ps.setString(4, c.getLecturerId());
            ps.setString(5, c.getRoom());
            ps.setInt(6, c.getEnrolledCount());
            ps.setString(7, c.getClassId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean deleteCourseClass(String classId) throws Exception {
        CourseClass cc = getCourseClassById(classId);
        if (cc == null) {
            return false;
        }

        if ("PUBLISHED".equalsIgnoreCase(cc.getGradeStatus())) {
            throw new IllegalStateException("Không thể xóa lớp học phần đã công bố điểm chính thức!");
        }

        if (countPendingAppeals(classId) > 0) {
            throw new IllegalStateException("Lớp học phần đang có đơn phúc khảo chưa giải quyết, không thể xóa!");
        }

        String sql = "DELETE FROM LOP_HOC_PHAN WHERE MA_LHP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    private CourseClass extractCourseClass(ResultSet rs) throws Exception {
        CourseClass cc = new CourseClass();
        cc.setClassId(rs.getString("MA_LHP"));
        cc.setClassName(rs.getString("TEN_LHP"));
        cc.setSubjectId(rs.getString("MA_MON"));
        cc.setSubjectName(rs.getString("TEN_MON"));
        cc.setCredits(rs.getInt("SO_TIN_CHI"));
        cc.setWeightAttendance(rs.getDouble("TY_LE_CC"));
        cc.setWeightMidterm(rs.getDouble("TY_LE_GK"));
        cc.setWeightFinal(rs.getDouble("TY_LE_THI"));
        cc.setSemesterId(rs.getString("MA_HOC_KY"));
        cc.setSemesterName(rs.getString("TEN_HOC_KY"));
        cc.setAcademicYear(rs.getString("NAM_HOC"));
        cc.setLecturerId(rs.getString("MA_GV"));
        cc.setLecturerName(rs.getString("TEN_GV"));
        cc.setRoom(rs.getString("PHONG_HOC"));
        cc.setEnrolledCount(rs.getInt("SI_SO"));
        cc.setGradeStatus(rs.getString("TRANG_THAI_DIEM"));
        return cc;
    }
}
