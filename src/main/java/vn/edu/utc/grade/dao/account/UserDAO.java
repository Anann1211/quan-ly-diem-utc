package vn.edu.utc.grade.dao.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.account.User;

public class UserDAO {

    public User login(String username, String password) throws java.sql.SQLException {
        String sql = "SELECT ID, TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI " +
                     "FROM TAI_KHOAN WHERE TEN_DANG_NHAP = ? AND MAT_KHAU = ? AND TRANG_THAI = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("ID"),
                    rs.getString("TEN_DANG_NHAP"),
                    rs.getString("MAT_KHAU"),
                    rs.getString("VAI_TRO"),
                    rs.getString("HO_TEN"),
                    rs.getString("EMAIL"),
                    rs.getString("SO_DIEN_THOAI"),
                    rs.getInt("TRANG_THAI")
                );
            }
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT ID, TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI " +
                     "FROM TAI_KHOAN WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("ID"),
                    rs.getString("TEN_DANG_NHAP"),
                    rs.getString("MAT_KHAU"),
                    rs.getString("VAI_TRO"),
                    rs.getString("HO_TEN"),
                    rs.getString("EMAIL"),
                    rs.getString("SO_DIEN_THOAI"),
                    rs.getInt("TRANG_THAI")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<User> getAllUsers(String role, String keyword, Integer status) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT ID, TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI " +
            "FROM TAI_KHOAN WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND VAI_TRO = ? ");
            params.add(role.trim());
        }
        if (status != null) {
            sql.append("AND TRANG_THAI = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (LOWER(TEN_DANG_NHAP) LIKE ? OR LOWER(HO_TEN) LIKE ? OR LOWER(EMAIL) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        sql.append("ORDER BY ID DESC");

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
                list.add(new User(
                    rs.getInt("ID"),
                    rs.getString("TEN_DANG_NHAP"),
                    rs.getString("MAT_KHAU"),
                    rs.getString("VAI_TRO"),
                    rs.getString("HO_TEN"),
                    rs.getString("EMAIL"),
                    rs.getString("SO_DIEN_THOAI"),
                    rs.getInt("TRANG_THAI")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM TAI_KHOAN WHERE TEN_DANG_NHAP = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
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

    public int createUser(User user) {
        String sql = "INSERT INTO TAI_KHOAN (TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String[] generatedColumns = {"ID"};
            ps = conn.prepareStatement(sql, generatedColumns);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getPhone());
            ps.setInt(7, user.getStatus());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return -1;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE TAI_KHOAN SET HO_TEN = ?, EMAIL = ?, SO_DIEN_THOAI = ?, TRANG_THAI = ? WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getStatus());
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean updateUserStatus(int userId, int status) {
        String sql = "UPDATE TAI_KHOAN SET TRANG_THAI = ? WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean resetPassword(int userId, String newPassword) {
        String sql = "UPDATE TAI_KHOAN SET MAT_KHAU = ? WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String sql = "UPDATE TAI_KHOAN SET MAT_KHAU = ? WHERE ID = ? AND MAT_KHAU = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            ps.setString(3, oldPassword);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }
}
