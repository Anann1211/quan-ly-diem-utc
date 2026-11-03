package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.Semester;

public class SemesterDAO {

    public List<Semester> getAllSemesters() {
        List<Semester> list = new ArrayList<>();
        String sql = "SELECT MA_HOC_KY, TEN_HOC_KY, NAM_HOC, TRANG_THAI, DANG_HOAT_DONG " +
                     "FROM HOC_KY ORDER BY NAM_HOC DESC, MA_HOC_KY DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Semester sem = new Semester();
                sem.setSemesterId(rs.getString("MA_HOC_KY"));
                sem.setSemesterName(rs.getString("TEN_HOC_KY"));
                sem.setAcademicYear(rs.getString("NAM_HOC"));
                sem.setStatus(rs.getString("TRANG_THAI"));
                sem.setIsActive(rs.getInt("DANG_HOAT_DONG"));
                list.add(sem);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Semester getActiveSemester() {
        String sql = "SELECT MA_HOC_KY, TEN_HOC_KY, NAM_HOC, TRANG_THAI, DANG_HOAT_DONG " +
                     "FROM HOC_KY WHERE DANG_HOAT_DONG = 1 FETCH FIRST 1 ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                Semester sem = new Semester();
                sem.setSemesterId(rs.getString("MA_HOC_KY"));
                sem.setSemesterName(rs.getString("TEN_HOC_KY"));
                sem.setAcademicYear(rs.getString("NAM_HOC"));
                sem.setStatus(rs.getString("TRANG_THAI"));
                sem.setIsActive(rs.getInt("DANG_HOAT_DONG"));
                return sem;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }
}
