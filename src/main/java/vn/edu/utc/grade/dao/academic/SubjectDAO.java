package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.Subject;

public class SubjectDAO {

    public List<Subject> getAllSubjects() {
        List<Subject> list = new ArrayList<>();
        String sql = "SELECT MA_MON, TEN_MON, SO_TIN_CHI, TY_LE_CC, TY_LE_GK, TY_LE_THI, LOAI_MON " +
                     "FROM MON_HOC ORDER BY MA_MON ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Subject s = new Subject();
                s.setSubjectId(rs.getString("MA_MON"));
                s.setSubjectName(rs.getString("TEN_MON"));
                s.setCredits(rs.getInt("SO_TIN_CHI"));
                s.setWeightAttendance(rs.getDouble("TY_LE_CC"));
                s.setWeightMidterm(rs.getDouble("TY_LE_GK"));
                s.setWeightFinal(rs.getDouble("TY_LE_THI"));
                s.setSubjectType(rs.getString("LOAI_MON"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Subject getSubjectById(String subjectId) {
        String sql = "SELECT MA_MON, TEN_MON, SO_TIN_CHI, TY_LE_CC, TY_LE_GK, TY_LE_THI, LOAI_MON " +
                     "FROM MON_HOC WHERE MA_MON = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, subjectId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Subject s = new Subject();
                s.setSubjectId(rs.getString("MA_MON"));
                s.setSubjectName(rs.getString("TEN_MON"));
                s.setCredits(rs.getInt("SO_TIN_CHI"));
                s.setWeightAttendance(rs.getDouble("TY_LE_CC"));
                s.setWeightMidterm(rs.getDouble("TY_LE_GK"));
                s.setWeightFinal(rs.getDouble("TY_LE_THI"));
                s.setSubjectType(rs.getString("LOAI_MON"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public boolean insertSubject(Subject s) {
        String sql = "INSERT INTO MON_HOC (MA_MON, TEN_MON, SO_TIN_CHI, TY_LE_CC, TY_LE_GK, TY_LE_THI, LOAI_MON) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getSubjectId());
            ps.setString(2, s.getSubjectName());
            ps.setInt(3, s.getCredits());
            ps.setDouble(4, s.getWeightAttendance());
            ps.setDouble(5, s.getWeightMidterm());
            ps.setDouble(6, s.getWeightFinal());
            ps.setString(7, s.getSubjectType());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean updateSubject(Subject s) {
        String sql = "UPDATE MON_HOC SET TEN_MON = ?, SO_TIN_CHI = ?, TY_LE_CC = ?, TY_LE_GK = ?, TY_LE_THI = ?, LOAI_MON = ? " +
                     "WHERE MA_MON = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getSubjectName());
            ps.setInt(2, s.getCredits());
            ps.setDouble(3, s.getWeightAttendance());
            ps.setDouble(4, s.getWeightMidterm());
            ps.setDouble(5, s.getWeightFinal());
            ps.setString(6, s.getSubjectType());
            ps.setString(7, s.getSubjectId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean deleteSubject(String subjectId) {
        String sql = "DELETE FROM MON_HOC WHERE MA_MON = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, subjectId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }
}
