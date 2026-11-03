package vn.edu.utc.grade.dao.grading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.grading.AuditLog;

public class AuditLogDAO {

    public List<AuditLog> getAllLogs() {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT a.ID, a.BANG_DIEM_ID, b.MA_SV, s.HO_TEN AS TEN_SV, " +
                     "b.MA_LHP, lhp.TEN_LHP, a.NGUOI_SUA, a.THOI_GIAN, a.DIEM_CU, a.DIEM_MOI, a.LY_DO " +
                     "FROM LICHSU_SUA_DIEM a " +
                     "JOIN BANG_DIEM b ON a.BANG_DIEM_ID = b.ID " +
                     "JOIN SINH_VIEN s ON b.MA_SV = s.MA_SV " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "ORDER BY a.THOI_GIAN DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setId(rs.getInt("ID"));
                log.setGradeId(rs.getInt("BANG_DIEM_ID"));
                log.setStudentId(rs.getString("MA_SV"));
                log.setStudentName(rs.getString("TEN_SV"));
                log.setCourseClassId(rs.getString("MA_LHP"));
                log.setCourseClassName(rs.getString("TEN_LHP"));
                log.setModifiedBy(rs.getString("NGUOI_SUA"));
                log.setModifiedTime(rs.getTimestamp("THOI_GIAN"));
                log.setOldScore(rs.getString("DIEM_CU"));
                log.setNewScore(rs.getString("DIEM_MOI"));
                log.setReason(rs.getString("LY_DO"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean logChange(int gradeId, String modifiedBy, String oldScore, String newScore, String reason) {
        String sql = "INSERT INTO LICHSU_SUA_DIEM (BANG_DIEM_ID, NGUOI_SUA, DIEM_CU, DIEM_MOI, LY_DO) " +
                     "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, gradeId);
            ps.setString(2, modifiedBy);
            ps.setString(3, oldScore);
            ps.setString(4, newScore);
            ps.setString(5, reason);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }
}
