package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.Faculty;

public class FacultyDAO {

    public List<Faculty> getAllFaculties() {
        List<Faculty> list = new ArrayList<>();
        String sql = "SELECT MA_KHOA, TEN_KHOA FROM KHOA ORDER BY MA_KHOA ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Faculty(rs.getString("MA_KHOA"), rs.getString("TEN_KHOA")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Faculty getFacultyById(String facultyId) {
        String sql = "SELECT MA_KHOA, TEN_KHOA FROM KHOA WHERE MA_KHOA = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, facultyId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Faculty(rs.getString("MA_KHOA"), rs.getString("TEN_KHOA"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }
}
