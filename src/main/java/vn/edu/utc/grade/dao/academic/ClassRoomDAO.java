package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.ClassRoom;

public class ClassRoomDAO {

    public List<ClassRoom> getAllClassRooms() {
        return getClassRoomsByFilters(null, null, null);
    }

    public List<ClassRoom> getClassRoomsByFilters(Integer intakeYear, String facultyId, String majorId) {
        List<ClassRoom> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.MA_LOP, l.TEN_LOP, l.KHOA_HOC, l.MA_NGANH, n.TEN_NGANH, n.MA_KHOA, k.TEN_KHOA, " +
            "(SELECT COUNT(*) FROM SINH_VIEN s WHERE s.MA_LOP = l.MA_LOP) AS SI_SO " +
            "FROM LOP_CHUYEN_NGANH l " +
            "JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
            "JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (intakeYear != null && intakeYear > 0) {
            sql.append("AND l.KHOA_HOC = ? ");
            params.add(intakeYear);
        }
        if (facultyId != null && !facultyId.trim().isEmpty()) {
            sql.append("AND k.MA_KHOA = ? ");
            params.add(facultyId.trim());
        }
        if (majorId != null && !majorId.trim().isEmpty()) {
            sql.append("AND l.MA_NGANH = ? ");
            params.add(majorId.trim());
        }
        sql.append("ORDER BY l.KHOA_HOC DESC, l.MA_LOP ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                ClassRoom cr = new ClassRoom();
                cr.setClassId(rs.getString("MA_LOP"));
                cr.setClassName(rs.getString("TEN_LOP"));
                cr.setIntakeYear(rs.getInt("KHOA_HOC"));
                cr.setMajorId(rs.getString("MA_NGANH"));
                cr.setMajorName(rs.getString("TEN_NGANH"));
                cr.setFacultyId(rs.getString("MA_KHOA"));
                cr.setFacultyName(rs.getString("TEN_KHOA"));
                cr.setStudentCount(rs.getInt("SI_SO"));
                list.add(cr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public ClassRoom getClassRoomById(String classId) {
        String sql = "SELECT l.MA_LOP, l.TEN_LOP, l.KHOA_HOC, l.MA_NGANH, n.TEN_NGANH, n.MA_KHOA, k.TEN_KHOA, " +
                     "(SELECT COUNT(*) FROM SINH_VIEN s WHERE s.MA_LOP = l.MA_LOP) AS SI_SO " +
                     "FROM LOP_CHUYEN_NGANH l " +
                     "JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
                     "JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "WHERE l.MA_LOP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            rs = ps.executeQuery();
            if (rs.next()) {
                ClassRoom cr = new ClassRoom();
                cr.setClassId(rs.getString("MA_LOP"));
                cr.setClassName(rs.getString("TEN_LOP"));
                cr.setIntakeYear(rs.getInt("KHOA_HOC"));
                cr.setMajorId(rs.getString("MA_NGANH"));
                cr.setMajorName(rs.getString("TEN_NGANH"));
                cr.setFacultyId(rs.getString("MA_KHOA"));
                cr.setFacultyName(rs.getString("TEN_KHOA"));
                cr.setStudentCount(rs.getInt("SI_SO"));
                return cr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Integer> getIntakeYears() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT DISTINCT KHOA_HOC FROM LOP_CHUYEN_NGANH ORDER BY KHOA_HOC DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("KHOA_HOC"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public int countStudentsInClass(String classId) {
        String sql = "SELECT COUNT(*) FROM SINH_VIEN WHERE MA_LOP = ?";
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

    public boolean insertClassRoom(ClassRoom cr) {
        String sql = "INSERT INTO LOP_CHUYEN_NGANH (MA_LOP, TEN_LOP, KHOA_HOC, MA_NGANH) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, cr.getClassId());
            ps.setString(2, cr.getClassName());
            ps.setInt(3, cr.getIntakeYear());
            ps.setString(4, cr.getMajorId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean updateClassRoom(ClassRoom cr) {
        String sql = "UPDATE LOP_CHUYEN_NGANH SET TEN_LOP = ?, KHOA_HOC = ?, MA_NGANH = ? WHERE MA_LOP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, cr.getClassName());
            ps.setInt(2, cr.getIntakeYear());
            ps.setString(3, cr.getMajorId());
            ps.setString(4, cr.getClassId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean deleteClassRoom(String classId) throws Exception {
        if (countStudentsInClass(classId) > 0) {
            throw new IllegalStateException("Lớp học đang có sinh viên theo học, không thể xóa!");
        }
        String sql = "DELETE FROM LOP_CHUYEN_NGANH WHERE MA_LOP = ?";
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
}
