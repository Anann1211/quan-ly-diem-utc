package vn.edu.utc.grade.dao.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.account.Lecturer;

public class LecturerDAO {

    public Lecturer getLecturerByUserId(int userId) {
        String sql = "SELECT g.MA_GV, g.HO_TEN, g.HOC_HAM_HOC_VI, g.EMAIL, g.DIEN_THOAI, " +
                     "g.MA_KHOA, k.TEN_KHOA, g.TAI_KHOAN_ID " +
                     "FROM GIANG_VIEN g " +
                     "LEFT JOIN KHOA k ON g.MA_KHOA = k.MA_KHOA " +
                     "WHERE g.TAI_KHOAN_ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Lecturer gv = new Lecturer();
                gv.setLecturerId(rs.getString("MA_GV"));
                gv.setFullName(rs.getString("HO_TEN"));
                gv.setAcademicRank(rs.getString("HOC_HAM_HOC_VI"));
                gv.setEmail(rs.getString("EMAIL"));
                gv.setPhone(rs.getString("DIEN_THOAI"));
                gv.setFacultyId(rs.getString("MA_KHOA"));
                gv.setFacultyName(rs.getString("TEN_KHOA"));
                gv.setUserId(rs.getInt("TAI_KHOAN_ID"));
                return gv;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Lecturer> getAllLecturers() {
        List<Lecturer> list = new ArrayList<>();
        String sql = "SELECT g.MA_GV, g.HO_TEN, g.HOC_HAM_HOC_VI, g.EMAIL, g.DIEN_THOAI, " +
                     "g.MA_KHOA, k.TEN_KHOA, g.TAI_KHOAN_ID " +
                     "FROM GIANG_VIEN g " +
                     "LEFT JOIN KHOA k ON g.MA_KHOA = k.MA_KHOA " +
                     "ORDER BY g.MA_GV ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Lecturer gv = new Lecturer();
                gv.setLecturerId(rs.getString("MA_GV"));
                gv.setFullName(rs.getString("HO_TEN"));
                gv.setAcademicRank(rs.getString("HOC_HAM_HOC_VI"));
                gv.setEmail(rs.getString("EMAIL"));
                gv.setPhone(rs.getString("DIEN_THOAI"));
                gv.setFacultyId(rs.getString("MA_KHOA"));
                gv.setFacultyName(rs.getString("TEN_KHOA"));
                gv.setUserId(rs.getInt("TAI_KHOAN_ID"));
                list.add(gv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public int countCourseClassesOfLecturer(String lecturerId) {
        String sql = "SELECT COUNT(*) FROM LOP_HOC_PHAN WHERE MA_GV = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, lecturerId);
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

    public boolean insertLecturer(Lecturer gv, String password) throws Exception {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psLecturer = null;
        ResultSet rsUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert TAI_KHOAN
            String sqlUser = "INSERT INTO TAI_KHOAN (TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI) " +
                             "VALUES (?, ?, 'GIANG_VIEN', ?, ?, ?, 1)";
            String[] generatedCols = {"ID"};
            psUser = conn.prepareStatement(sqlUser, generatedCols);
            psUser.setString(1, gv.getLecturerId());
            psUser.setString(2, (password != null && !password.trim().isEmpty()) ? password : "gv123");
            psUser.setString(3, gv.getFullName());
            psUser.setString(4, gv.getEmail());
            psUser.setString(5, gv.getPhone());
            psUser.executeUpdate();

            int userId = -1;
            rsUser = psUser.getGeneratedKeys();
            if (rsUser.next()) {
                userId = rsUser.getInt(1);
            }

            // 2. Insert GIANG_VIEN
            String sqlLecturer = "INSERT INTO GIANG_VIEN (MA_GV, HO_TEN, HOC_HAM_HOC_VI, EMAIL, DIEN_THOAI, MA_KHOA, TAI_KHOAN_ID) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?)";
            psLecturer = conn.prepareStatement(sqlLecturer);
            psLecturer.setString(1, gv.getLecturerId());
            psLecturer.setString(2, gv.getFullName());
            psLecturer.setString(3, gv.getAcademicRank());
            psLecturer.setString(4, gv.getEmail());
            psLecturer.setString(5, gv.getPhone());
            psLecturer.setString(6, gv.getFacultyId());
            if (userId > 0) {
                psLecturer.setInt(7, userId);
            } else {
                psLecturer.setNull(7, java.sql.Types.INTEGER);
            }
            psLecturer.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rsUser != null) rsUser.close();
            if (psUser != null) psUser.close();
            if (psLecturer != null) psLecturer.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean updateLecturer(Lecturer gv) throws Exception {
        Connection conn = null;
        PreparedStatement psLecturer = null;
        PreparedStatement psUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlLecturer = "UPDATE GIANG_VIEN SET HO_TEN = ?, HOC_HAM_HOC_VI = ?, EMAIL = ?, DIEN_THOAI = ?, MA_KHOA = ? " +
                                 "WHERE MA_GV = ?";
            psLecturer = conn.prepareStatement(sqlLecturer);
            psLecturer.setString(1, gv.getFullName());
            psLecturer.setString(2, gv.getAcademicRank());
            psLecturer.setString(3, gv.getEmail());
            psLecturer.setString(4, gv.getPhone());
            psLecturer.setString(5, gv.getFacultyId());
            psLecturer.setString(6, gv.getLecturerId());
            psLecturer.executeUpdate();

            // Đồng bộ sang TAI_KHOAN
            if (gv.getUserId() > 0) {
                String sqlUser = "UPDATE TAI_KHOAN SET HO_TEN = ?, EMAIL = ?, SO_DIEN_THOAI = ? WHERE ID = ?";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setString(1, gv.getFullName());
                psUser.setString(2, gv.getEmail());
                psUser.setString(3, gv.getPhone());
                psUser.setInt(4, gv.getUserId());
                psUser.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psLecturer != null) psLecturer.close();
            if (psUser != null) psUser.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean deleteLecturer(String lecturerId) throws Exception {
        if (countCourseClassesOfLecturer(lecturerId) > 0) {
            throw new IllegalStateException("Giảng viên đang phụ trách lớp học phần, không thể xóa!");
        }

        Lecturer gv = null;
        String sqlFind = "SELECT TAI_KHOAN_ID FROM GIANG_VIEN WHERE MA_GV = ?";
        Connection conn = null;
        PreparedStatement psFind = null;
        ResultSet rsFind = null;
        int userId = -1;
        try {
            conn = DBConnection.getConnection();
            psFind = conn.prepareStatement(sqlFind);
            psFind.setString(1, lecturerId);
            rsFind = psFind.executeQuery();
            if (rsFind.next()) {
                userId = rsFind.getInt(1);
            }
        } finally {
            DBConnection.close(rsFind, psFind, null);
        }

        PreparedStatement psLecturer = null;
        PreparedStatement psUser = null;
        try {
            conn.setAutoCommit(false);

            String sqlLecturer = "DELETE FROM GIANG_VIEN WHERE MA_GV = ?";
            psLecturer = conn.prepareStatement(sqlLecturer);
            psLecturer.setString(1, lecturerId);
            psLecturer.executeUpdate();

            if (userId > 0) {
                String sqlUser = "DELETE FROM TAI_KHOAN WHERE ID = ?";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setInt(1, userId);
                psUser.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psLecturer != null) psLecturer.close();
            if (psUser != null) psUser.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}
