package vn.edu.utc.grade.dao.grading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.grading.Grade;

public class GradeDAO {

    public List<Grade> getGradesByCourseClass(String courseClassId) {
        List<Grade> list = new ArrayList<>();
        String sql = "SELECT b.ID, b.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, m.SO_TIN_CHI, " +
                     "lhp.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, b.MA_SV, s.HO_TEN AS TEN_SV, lop.TEN_LOP, " +
                     "b.DIEM_CC, b.DIEM_GK, b.DIEM_THI, b.DIEM_TK_10, b.DIEM_CHU, b.DIEM_THANG_4, b.KET_QUA, b.GHI_CHU, lhp.TRANG_THAI_DIEM " +
                     "FROM BANG_DIEM b " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
                     "JOIN SINH_VIEN s ON b.MA_SV = s.MA_SV " +
                     "LEFT JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
                     "WHERE b.MA_LHP = ? " +
                     "ORDER BY s.MA_SV ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, courseClassId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractGrade(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<Grade> getGradesByClassAndSubject(String classId, String subjectId) {
        List<Grade> list = new ArrayList<>();
        String sql = "SELECT b.ID, b.MA_LHP, b.TEN_LHP, " +
                     "COALESCE(b.MA_MON, ?) AS MA_MON, " +
                     "COALESCE(m.TEN_MON, (SELECT TEN_MON FROM MON_HOC WHERE MA_MON = ?)) AS TEN_MON, " +
                     "COALESCE(m.SO_TIN_CHI, (SELECT SO_TIN_CHI FROM MON_HOC WHERE MA_MON = ?)) AS SO_TIN_CHI, " +
                     "b.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, " +
                     "s.MA_SV, s.HO_TEN AS TEN_SV, lop.TEN_LOP, " +
                     "b.DIEM_CC, b.DIEM_GK, b.DIEM_THI, b.DIEM_TK_10, b.DIEM_CHU, b.DIEM_THANG_4, b.KET_QUA, b.GHI_CHU, " +
                     "COALESCE(b.TRANG_THAI_DIEM, 'CHUA_CO_DIEM') AS TRANG_THAI_DIEM " +
                     "FROM SINH_VIEN s " +
                     "JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
                     "LEFT JOIN ( " +
                     "    SELECT bd.*, l.MA_MON, l.TEN_LHP, l.MA_HOC_KY, l.TRANG_THAI_DIEM " +
                     "    FROM BANG_DIEM bd " +
                     "    JOIN LOP_HOC_PHAN l ON bd.MA_LHP = l.MA_LHP " +
                     "    WHERE l.MA_MON = ? " +
                     ") b ON s.MA_SV = b.MA_SV " +
                     "LEFT JOIN MON_HOC m ON b.MA_MON = m.MA_MON " +
                     "LEFT JOIN HOC_KY h ON b.MA_HOC_KY = h.MA_HOC_KY " +
                     "WHERE s.MA_LOP = ? " +
                     "ORDER BY s.MA_SV ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, subjectId);
            ps.setString(2, subjectId);
            ps.setString(3, subjectId);
            ps.setString(4, subjectId);
            ps.setString(5, classId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractGrade(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Grade getGradeById(int id) {
        String sql = "SELECT b.ID, b.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, m.SO_TIN_CHI, " +
                     "lhp.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, b.MA_SV, s.HO_TEN AS TEN_SV, lop.TEN_LOP, " +
                     "b.DIEM_CC, b.DIEM_GK, b.DIEM_THI, b.DIEM_TK_10, b.DIEM_CHU, b.DIEM_THANG_4, b.KET_QUA, b.GHI_CHU, lhp.TRANG_THAI_DIEM " +
                     "FROM BANG_DIEM b " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
                     "JOIN SINH_VIEN s ON b.MA_SV = s.MA_SV " +
                     "LEFT JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
                     "WHERE b.ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractGrade(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Grade> getGradesByStudent(String studentId, String semesterId) {
        List<Grade> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.ID, b.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, m.SO_TIN_CHI, " +
            "lhp.MA_HOC_KY, h.TEN_HOC_KY, h.NAM_HOC, b.MA_SV, s.HO_TEN AS TEN_SV, lop.TEN_LOP, " +
            "b.DIEM_CC, b.DIEM_GK, b.DIEM_THI, b.DIEM_TK_10, b.DIEM_CHU, b.DIEM_THANG_4, b.KET_QUA, b.GHI_CHU, lhp.TRANG_THAI_DIEM " +
            "FROM BANG_DIEM b " +
            "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
            "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
            "JOIN SINH_VIEN s ON b.MA_SV = s.MA_SV " +
            "LEFT JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
            "WHERE b.MA_SV = ? AND lhp.TRANG_THAI_DIEM = 'PUBLISHED' "
        );
        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("AND lhp.MA_HOC_KY = ? ");
        }
        sql.append("ORDER BY lhp.MA_HOC_KY DESC, m.MA_MON ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, studentId);
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(2, semesterId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractGrade(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean updateGrade(Grade g) {
        String sql = "UPDATE BANG_DIEM SET DIEM_CC = ?, DIEM_GK = ?, DIEM_THI = ?, " +
                     "DIEM_TK_10 = ?, DIEM_CHU = ?, DIEM_THANG_4 = ?, KET_QUA = ?, GHI_CHU = ? " +
                     "WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            setDoubleOrNull(ps, 1, g.getScoreAttendance());
            setDoubleOrNull(ps, 2, g.getScoreMidterm());
            setDoubleOrNull(ps, 3, g.getScoreFinal());
            setDoubleOrNull(ps, 4, g.getScoreTotal10());
            ps.setString(5, g.getScoreLetter());
            setDoubleOrNull(ps, 6, g.getScoreScale4());
            ps.setString(7, g.getResult());
            ps.setString(8, g.getNote());
            ps.setInt(9, g.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean updateBatchGrades(List<Grade> grades) {
        String sql = "UPDATE BANG_DIEM SET DIEM_CC = ?, DIEM_GK = ?, DIEM_THI = ?, " +
                     "DIEM_TK_10 = ?, DIEM_CHU = ?, DIEM_THANG_4 = ?, KET_QUA = ?, GHI_CHU = ? " +
                     "WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            ps = conn.prepareStatement(sql);
            for (Grade g : grades) {
                setDoubleOrNull(ps, 1, g.getScoreAttendance());
                setDoubleOrNull(ps, 2, g.getScoreMidterm());
                setDoubleOrNull(ps, 3, g.getScoreFinal());
                setDoubleOrNull(ps, 4, g.getScoreTotal10());
                ps.setString(5, g.getScoreLetter());
                setDoubleOrNull(ps, 6, g.getScoreScale4());
                ps.setString(7, g.getResult());
                ps.setString(8, g.getNote());
                ps.setInt(9, g.getId());
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignored) {}
            }
            DBConnection.close(ps, conn);
        }
    }

    public Map<String, Integer> getGradeDistribution(String courseClassId) {
        Map<String, Integer> map = new HashMap<>();
        map.put("A+", 0); map.put("A", 0); map.put("B+", 0); map.put("B", 0);
        map.put("C+", 0); map.put("C", 0); map.put("D+", 0); map.put("D", 0);
        map.put("F+", 0); map.put("F", 0);

        String sql = "SELECT DIEM_CHU, COUNT(*) AS CNT FROM BANG_DIEM " +
                     "WHERE MA_LHP = ? AND DIEM_CHU IS NOT NULL GROUP BY DIEM_CHU";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, courseClassId);
            rs = ps.executeQuery();
            while (rs.next()) {
                String letter = rs.getString("DIEM_CHU");
                int cnt = rs.getInt("CNT");
                if (map.containsKey(letter)) {
                    map.put(letter, cnt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return map;
    }

    private Grade extractGrade(ResultSet rs) throws Exception {
        Grade g = new Grade();
        g.setId(rs.getInt("ID"));
        g.setCourseClassId(rs.getString("MA_LHP"));
        g.setCourseClassName(rs.getString("TEN_LHP"));
        g.setSubjectId(rs.getString("MA_MON"));
        g.setSubjectName(rs.getString("TEN_MON"));
        g.setCredits(rs.getInt("SO_TIN_CHI"));
        g.setSemesterId(rs.getString("MA_HOC_KY"));
        g.setSemesterName(rs.getString("TEN_HOC_KY"));
        g.setAcademicYear(rs.getString("NAM_HOC"));
        g.setStudentId(rs.getString("MA_SV"));
        g.setStudentName(rs.getString("TEN_SV"));
        g.setClassName(rs.getString("TEN_LOP"));

        g.setScoreAttendance(getDoubleOrNull(rs, "DIEM_CC"));
        g.setScoreMidterm(getDoubleOrNull(rs, "DIEM_GK"));
        g.setScoreFinal(getDoubleOrNull(rs, "DIEM_THI"));
        g.setScoreTotal10(getDoubleOrNull(rs, "DIEM_TK_10"));
        g.setScoreLetter(rs.getString("DIEM_CHU"));
        g.setScoreScale4(getDoubleOrNull(rs, "DIEM_THANG_4"));
        g.setResult(rs.getString("KET_QUA"));
        g.setNote(rs.getString("GHI_CHU"));
        g.setGradeStatus(rs.getString("TRANG_THAI_DIEM"));
        return g;
    }

    private Double getDoubleOrNull(ResultSet rs, String col) throws Exception {
        double val = rs.getDouble(col);
        return rs.wasNull() ? null : val;
    }

    private void setDoubleOrNull(PreparedStatement ps, int idx, Double val) throws Exception {
        if (val == null) {
            ps.setNull(idx, java.sql.Types.DOUBLE);
        } else {
            ps.setDouble(idx, val);
        }
    }

    /**
     * Rút học phần: Xóa sinh viên khỏi lớp học phần và tự động cập nhật lại sĩ số
     */
    public boolean removeStudentFromCourseClass(String classId, String studentId) {
        Connection conn = null;
        PreparedStatement psDelete = null;
        PreparedStatement psUpdateCount = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlDelete = "DELETE FROM BANG_DIEM WHERE MA_LHP = ? AND MA_SV = ?";
            psDelete = conn.prepareStatement(sqlDelete);
            psDelete.setString(1, classId);
            psDelete.setString(2, studentId);
            int affected = psDelete.executeUpdate();

            if (affected > 0) {
                String sqlUpdate = "UPDATE LOP_HOC_PHAN SET SI_SO = (SELECT COUNT(*) FROM BANG_DIEM WHERE MA_LHP = ?) WHERE MA_LHP = ?";
                psUpdateCount = conn.prepareStatement(sqlUpdate);
                psUpdateCount.setString(1, classId);
                psUpdateCount.setString(2, classId);
                psUpdateCount.executeUpdate();
            }

            conn.commit();
            return affected > 0;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(null, psDelete, null);
            DBConnection.close(null, psUpdateCount, conn);
        }
    }

    /**
     * Thêm sinh viên vào lớp học phần (Học bù / Học ghép / Đăng ký bổ sung)
     */
    public boolean addStudentToCourseClass(String classId, String studentId) {
        Connection conn = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdateCount = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlInsert = "INSERT INTO BANG_DIEM (MA_LHP, MA_SV) VALUES (?, ?)";
            psInsert = conn.prepareStatement(sqlInsert);
            psInsert.setString(1, classId);
            psInsert.setString(2, studentId);
            int affected = psInsert.executeUpdate();

            if (affected > 0) {
                String sqlUpdate = "UPDATE LOP_HOC_PHAN SET SI_SO = (SELECT COUNT(*) FROM BANG_DIEM WHERE MA_LHP = ?) WHERE MA_LHP = ?";
                psUpdateCount = conn.prepareStatement(sqlUpdate);
                psUpdateCount.setString(1, classId);
                psUpdateCount.setString(2, classId);
                psUpdateCount.executeUpdate();
            }

            conn.commit();
            return affected > 0;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(null, psInsert, null);
            DBConnection.close(null, psUpdateCount, conn);
        }
    }

    /**
     * Kiểm tra sinh viên đã có trong lớp học phần chưa
     */
    public boolean isStudentEnrolledInCourseClass(String classId, String studentId) {
        String sql = "SELECT COUNT(*) FROM BANG_DIEM WHERE MA_LHP = ? AND MA_SV = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            ps.setString(2, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return false;
    }

    /**
     * Nạp toàn bộ sinh viên của một Lớp Chuyên Ngành vào Lớp Học Phần (1-click)
     */
    public int batchEnrollClassRoom(String courseClassId, String classRoomId) {
        String sql = "INSERT INTO BANG_DIEM (MA_LHP, MA_SV) " +
                     "SELECT ?, s.MA_SV FROM SINH_VIEN s " +
                     "WHERE s.MA_LOP = ? " +
                     "AND NOT EXISTS (SELECT 1 FROM BANG_DIEM b WHERE b.MA_LHP = ? AND b.MA_SV = s.MA_SV)";
        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement psCount = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sql);
            ps.setString(1, courseClassId);
            ps.setString(2, classRoomId);
            ps.setString(3, courseClassId);
            int enrolled = ps.executeUpdate();

            // Cập nhật lại sĩ số lớp học phần
            String sqlUpdate = "UPDATE LOP_HOC_PHAN SET SI_SO = (SELECT COUNT(*) FROM BANG_DIEM WHERE MA_LHP = ?) WHERE MA_LHP = ?";
            psCount = conn.prepareStatement(sqlUpdate);
            psCount.setString(1, courseClassId);
            psCount.setString(2, courseClassId);
            psCount.executeUpdate();

            conn.commit();
            return enrolled;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return 0;
        } finally {
            DBConnection.close(null, ps, null);
            DBConnection.close(null, psCount, conn);
        }
    }
}
