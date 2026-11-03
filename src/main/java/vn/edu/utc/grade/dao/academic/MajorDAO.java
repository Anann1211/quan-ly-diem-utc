package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.Major;

public class MajorDAO {

    public List<Major> getAllMajors() {
        List<Major> list = new ArrayList<>();
        String sql = "SELECT m.MA_NGANH, m.TEN_NGANH, m.MA_KHOA, k.TEN_KHOA " +
                     "FROM NGANH m " +
                     "LEFT JOIN KHOA k ON m.MA_KHOA = k.MA_KHOA " +
                     "ORDER BY m.MA_NGANH ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Major m = new Major(rs.getString("MA_NGANH"), rs.getString("TEN_NGANH"), rs.getString("MA_KHOA"));
                m.setFacultyName(rs.getString("TEN_KHOA"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<Major> getMajorsByFaculty(String facultyId) {
        List<Major> list = new ArrayList<>();
        String sql = "SELECT m.MA_NGANH, m.TEN_NGANH, m.MA_KHOA, k.TEN_KHOA " +
                     "FROM NGANH m " +
                     "LEFT JOIN KHOA k ON m.MA_KHOA = k.MA_KHOA " +
                     "WHERE m.MA_KHOA = ? " +
                     "ORDER BY m.MA_NGANH ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, facultyId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Major m = new Major(rs.getString("MA_NGANH"), rs.getString("TEN_NGANH"), rs.getString("MA_KHOA"));
                m.setFacultyName(rs.getString("TEN_KHOA"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Major getMajorById(String majorId) {
        String sql = "SELECT m.MA_NGANH, m.TEN_NGANH, m.MA_KHOA, k.TEN_KHOA " +
                     "FROM NGANH m " +
                     "LEFT JOIN KHOA k ON m.MA_KHOA = k.MA_KHOA " +
                     "WHERE m.MA_NGANH = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, majorId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Major m = new Major(rs.getString("MA_NGANH"), rs.getString("TEN_NGANH"), rs.getString("MA_KHOA"));
                m.setFacultyName(rs.getString("TEN_KHOA"));
                return m;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }
}
