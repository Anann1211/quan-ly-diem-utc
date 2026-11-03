package vn.edu.utc.grade.dao.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.account.Student;

public class StudentDAO {

    public Student getStudentByUserId(int userId) {
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "l.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, s.TAI_KHOAN_ID " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH l ON s.MA_LOP = l.MA_LOP " +
                     "LEFT JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "WHERE s.TAI_KHOAN_ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Student st = new Student();
                st.setStudentId(rs.getString("MA_SV"));
                st.setFullName(rs.getString("HO_TEN"));
                st.setDateOfBirth(rs.getDate("NGAY_SINH"));
                st.setGender(rs.getString("GIOI_TINH"));
                st.setHometown(rs.getString("QUE_QUAN"));
                st.setClassId(rs.getString("MA_LOP"));
                st.setClassName(rs.getString("TEN_LOP"));
                st.setMajorName(rs.getString("TEN_NGANH"));
                st.setFacultyName(rs.getString("TEN_KHOA"));
                st.setUserId(rs.getInt("TAI_KHOAN_ID"));
                return st;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public Student getStudentById(String studentId) {
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "l.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, s.TAI_KHOAN_ID " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH l ON s.MA_LOP = l.MA_LOP " +
                     "LEFT JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "WHERE s.MA_SV = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Student st = new Student();
                st.setStudentId(rs.getString("MA_SV"));
                st.setFullName(rs.getString("HO_TEN"));
                st.setDateOfBirth(rs.getDate("NGAY_SINH"));
                st.setGender(rs.getString("GIOI_TINH"));
                st.setHometown(rs.getString("QUE_QUAN"));
                st.setClassId(rs.getString("MA_LOP"));
                st.setClassName(rs.getString("TEN_LOP"));
                st.setMajorName(rs.getString("TEN_NGANH"));
                st.setFacultyName(rs.getString("TEN_KHOA"));
                st.setUserId(rs.getInt("TAI_KHOAN_ID"));
                return st;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "l.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, s.TAI_KHOAN_ID " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH l ON s.MA_LOP = l.MA_LOP " +
                     "LEFT JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "ORDER BY s.MA_SV ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student st = new Student();
                st.setStudentId(rs.getString("MA_SV"));
                st.setFullName(rs.getString("HO_TEN"));
                st.setDateOfBirth(rs.getDate("NGAY_SINH"));
                st.setGender(rs.getString("GIOI_TINH"));
                st.setHometown(rs.getString("QUE_QUAN"));
                st.setClassId(rs.getString("MA_LOP"));
                st.setClassName(rs.getString("TEN_LOP"));
                st.setMajorName(rs.getString("TEN_NGANH"));
                st.setFacultyName(rs.getString("TEN_KHOA"));
                st.setUserId(rs.getInt("TAI_KHOAN_ID"));
                list.add(st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Tính tổng số tín chỉ tích lũy và CPA của sinh viên.
     * Giải quyết câu hỏi số 2: Khi sinh viên học lại một môn, chỉ lấy điểm cao nhất của môn đó
     * để tính CPA, không cộng dồn môn trượt đã học lại theo Quy chế đào tạo tín chỉ UTC!
     */
    public void calculateCPA(Student student) {
        String sql = "SELECT m.MA_MON, m.SO_TIN_CHI, MAX(b.DIEM_THANG_4) AS MAX_DIEM_4 " +
                     "FROM BANG_DIEM b " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "WHERE b.MA_SV = ? AND lhp.TRANG_THAI_DIEM = 'PUBLISHED' " +
                     "AND b.DIEM_THANG_4 IS NOT NULL AND m.LOAI_MON = 'TIN_CHI' " +
                     "GROUP BY m.MA_MON, m.SO_TIN_CHI";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, student.getStudentId());
            rs = ps.executeQuery();

            double totalWeighted = 0.0;
            int totalCreditsAccumulated = 0; // Tín chỉ tích lũy (chỉ tính môn đạt >= 1.0)
            int totalCreditsAttempted = 0;   // Tín chỉ tính CPA (mỗi môn chỉ tính 1 lần điểm cao nhất)

            while (rs.next()) {
                double scale4 = rs.getDouble("MAX_DIEM_4");
                int credits = rs.getInt("SO_TIN_CHI");
                if (scale4 >= 1.0) { // Đạt từ D trở lên thì tính vào tín chỉ tích lũy
                    totalCreditsAccumulated += credits;
                }
                totalCreditsAttempted += credits;
                totalWeighted += scale4 * credits;
            }

            student.setTotalCredits(totalCreditsAccumulated);
            if (totalCreditsAttempted > 0) {
                double cpa = totalWeighted / totalCreditsAttempted;
                student.setCpa(java.math.BigDecimal.valueOf(cpa).setScale(2, java.math.RoundingMode.HALF_UP).doubleValue());
            } else {
                student.setCpa(0.0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
    }

    public List<Student> getStudentsByClass(String classId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "l.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, s.TAI_KHOAN_ID, " +
                     "u.EMAIL, u.SO_DIEN_THOAI, u.TRANG_THAI " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH l ON s.MA_LOP = l.MA_LOP " +
                     "LEFT JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "LEFT JOIN TAI_KHOAN u ON s.TAI_KHOAN_ID = u.ID " +
                     "WHERE s.MA_LOP = ? " +
                     "ORDER BY s.MA_SV ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student st = new Student();
                st.setStudentId(rs.getString("MA_SV"));
                st.setFullName(rs.getString("HO_TEN"));
                st.setDateOfBirth(rs.getDate("NGAY_SINH"));
                st.setGender(rs.getString("GIOI_TINH"));
                st.setHometown(rs.getString("QUE_QUAN"));
                st.setClassId(rs.getString("MA_LOP"));
                st.setClassName(rs.getString("TEN_LOP"));
                st.setMajorName(rs.getString("TEN_NGANH"));
                st.setFacultyName(rs.getString("TEN_KHOA"));
                st.setUserId(rs.getInt("TAI_KHOAN_ID"));
                st.setEmail(rs.getString("EMAIL"));
                st.setPhone(rs.getString("SO_DIEN_THOAI"));
                list.add(st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean insertStudent(Student st, String password) throws Exception {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psStudent = null;
        ResultSet rsUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert TAI_KHOAN
            String sqlUser = "INSERT INTO TAI_KHOAN (TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI) " +
                             "VALUES (?, ?, 'SINH_VIEN', ?, ?, ?, 1)";
            String[] generatedCols = {"ID"};
            psUser = conn.prepareStatement(sqlUser, generatedCols);
            psUser.setString(1, st.getStudentId());
            psUser.setString(2, (password != null && !password.trim().isEmpty()) ? password : "sv123");
            psUser.setString(3, st.getFullName());
            psUser.setString(4, st.getEmail());
            psUser.setString(5, st.getPhone());
            psUser.executeUpdate();

            int userId = -1;
            rsUser = psUser.getGeneratedKeys();
            if (rsUser.next()) {
                userId = rsUser.getInt(1);
            }

            // 2. Insert SINH_VIEN
            String sqlStudent = "INSERT INTO SINH_VIEN (MA_SV, HO_TEN, NGAY_SINH, GIOI_TINH, QUE_QUAN, MA_LOP, TAI_KHOAN_ID) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?)";
            psStudent = conn.prepareStatement(sqlStudent);
            psStudent.setString(1, st.getStudentId());
            psStudent.setString(2, st.getFullName());
            if (st.getDateOfBirth() != null) {
                psStudent.setDate(3, new java.sql.Date(st.getDateOfBirth().getTime()));
            } else {
                psStudent.setNull(3, java.sql.Types.DATE);
            }
            psStudent.setString(4, st.getGender() != null ? st.getGender() : "Nam");
            psStudent.setString(5, st.getHometown());
            psStudent.setString(6, st.getClassId());
            if (userId > 0) {
                psStudent.setInt(7, userId);
            } else {
                psStudent.setNull(7, java.sql.Types.INTEGER);
            }
            psStudent.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rsUser != null) rsUser.close();
            if (psUser != null) psUser.close();
            if (psStudent != null) psStudent.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean updateStudent(Student st) throws Exception {
        Connection conn = null;
        PreparedStatement psStudent = null;
        PreparedStatement psUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlStudent = "UPDATE SINH_VIEN SET HO_TEN = ?, NGAY_SINH = ?, GIOI_TINH = ?, QUE_QUAN = ?, MA_LOP = ? " +
                                "WHERE MA_SV = ?";
            psStudent = conn.prepareStatement(sqlStudent);
            psStudent.setString(1, st.getFullName());
            if (st.getDateOfBirth() != null) {
                psStudent.setDate(2, new java.sql.Date(st.getDateOfBirth().getTime()));
            } else {
                psStudent.setNull(2, java.sql.Types.DATE);
            }
            psStudent.setString(3, st.getGender());
            psStudent.setString(4, st.getHometown());
            psStudent.setString(5, st.getClassId());
            psStudent.setString(6, st.getStudentId());
            psStudent.executeUpdate();

            // Đồng bộ tên và thông tin liên lạc sang TAI_KHOAN nếu có TAI_KHOAN_ID
            if (st.getUserId() > 0) {
                String sqlUser = "UPDATE TAI_KHOAN SET HO_TEN = ?, EMAIL = ?, SO_DIEN_THOAI = ? WHERE ID = ?";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setString(1, st.getFullName());
                psUser.setString(2, st.getEmail());
                psUser.setString(3, st.getPhone());
                psUser.setInt(4, st.getUserId());
                psUser.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psStudent != null) psStudent.close();
            if (psUser != null) psUser.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public int countGradesOfStudent(String studentId) {
        String sql = "SELECT COUNT(*) FROM BANG_DIEM WHERE MA_SV = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
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

    public boolean deleteStudent(String studentId) throws Exception {
        if (countGradesOfStudent(studentId) > 0) {
            throw new IllegalStateException("Sinh viên đã có điểm học phần trong hệ thống, không thể xóa!");
        }

        Student st = getStudentById(studentId);
        if (st == null) return false;

        Connection conn = null;
        PreparedStatement psStudent = null;
        PreparedStatement psUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlStudent = "DELETE FROM SINH_VIEN WHERE MA_SV = ?";
            psStudent = conn.prepareStatement(sqlStudent);
            psStudent.setString(1, studentId);
            psStudent.executeUpdate();

            if (st.getUserId() > 0) {
                String sqlUser = "DELETE FROM TAI_KHOAN WHERE ID = ?";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setInt(1, st.getUserId());
                psUser.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (psStudent != null) psStudent.close();
            if (psUser != null) psUser.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public int batchInsertStudents(List<Student> list, String classId, String defaultPassword) {
        int successCount = 0;
        for (Student st : list) {
            try {
                st.setClassId(classId);
                if (insertStudent(st, defaultPassword)) {
                    successCount++;
                }
            } catch (Exception e) {
                // Tiếp tục xử lý các sinh viên khác
                e.printStackTrace();
            }
        }
        return successCount;
    }

    /**
     * Thêm danh sách sinh viên theo lô với Transaction an toàn (nguyên khối).
     * Nếu có bất kỳ lỗi nào, toàn bộ giao dịch sẽ rollback để đảm bảo toàn vẹn dữ liệu.
     */
    public int insertStudentsTransaction(List<Student> list, String classId, String defaultPassword) throws Exception {
        if (list == null || list.isEmpty()) return 0;
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psStudent = null;
        ResultSet rsUser = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlUser = "INSERT INTO TAI_KHOAN (TEN_DANG_NHAP, MAT_KHAU, VAI_TRO, HO_TEN, EMAIL, SO_DIEN_THOAI, TRANG_THAI) " +
                             "VALUES (?, ?, 'SINH_VIEN', ?, ?, ?, 1)";
            String[] generatedCols = {"ID"};
            psUser = conn.prepareStatement(sqlUser, generatedCols);

            String sqlStudent = "INSERT INTO SINH_VIEN (MA_SV, HO_TEN, NGAY_SINH, GIOI_TINH, QUE_QUAN, MA_LOP, TAI_KHOAN_ID) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?)";
            psStudent = conn.prepareStatement(sqlStudent);

            int count = 0;
            for (Student st : list) {
                // 1. Thêm TAI_KHOAN
                psUser.setString(1, st.getStudentId());
                psUser.setString(2, (defaultPassword != null && !defaultPassword.trim().isEmpty()) ? defaultPassword : "sv123");
                psUser.setString(3, st.getFullName());
                psUser.setString(4, st.getEmail());
                psUser.setString(5, st.getPhone());
                psUser.executeUpdate();

                int userId = -1;
                rsUser = psUser.getGeneratedKeys();
                if (rsUser.next()) {
                    userId = rsUser.getInt(1);
                }
                rsUser.close();

                // 2. Thêm SINH_VIEN
                psStudent.setString(1, st.getStudentId());
                psStudent.setString(2, st.getFullName());
                if (st.getDateOfBirth() != null) {
                    psStudent.setDate(3, new java.sql.Date(st.getDateOfBirth().getTime()));
                } else {
                    psStudent.setNull(3, java.sql.Types.DATE);
                }
                psStudent.setString(4, st.getGender() != null ? st.getGender() : "Nam");
                psStudent.setString(5, st.getHometown());
                psStudent.setString(6, classId);
                if (userId > 0) {
                    psStudent.setInt(7, userId);
                } else {
                    psStudent.setNull(7, java.sql.Types.INTEGER);
                }
                psStudent.executeUpdate();
                count++;
            }

            conn.commit();
            return count;
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (rsUser != null) rsUser.close();
            if (psUser != null) psUser.close();
            if (psStudent != null) psStudent.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Tự động sinh Mã Sinh Viên theo Khóa học (chuẩn UTC: [YY]12[STT 5 số])
     */
    public String generateNextStudentId(String classId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            int yearPrefix = 21; // Mặc định K62 (2021)
            if (classId != null && !classId.trim().isEmpty()) {
                String sqlKhoa = "SELECT KHOA_HOC FROM LOP_CHUYEN_NGANH WHERE MA_LOP = ?";
                ps = conn.prepareStatement(sqlKhoa);
                ps.setString(1, classId.trim());
                rs = ps.executeQuery();
                if (rs.next()) {
                    int khoaHoc = rs.getInt("KHOA_HOC");
                    yearPrefix = khoaHoc - 41; // Ví dụ: K62 -> 21, K63 -> 22, K64 -> 23
                }
                rs.close();
                ps.close();
            }

            String prefix = String.format("%02d12", yearPrefix);
            String sqlMax = "SELECT MAX(MA_SV) FROM SINH_VIEN WHERE MA_SV LIKE ? AND LENGTH(MA_SV) = 9";
            ps = conn.prepareStatement(sqlMax);
            ps.setString(1, prefix + "%");
            rs = ps.executeQuery();
            if (rs.next()) {
                String maxId = rs.getString(1);
                if (maxId != null && maxId.length() == 9) {
                    try {
                        long currentNum = Long.parseLong(maxId);
                        return String.valueOf(currentNum + 1);
                    } catch (NumberFormatException ignored) {}
                }
            }
            return prefix + "00001";
        } catch (Exception e) {
            e.printStackTrace();
            return "211200001";
        } finally {
            DBConnection.close(rs, ps, conn);
        }
    }

    /**
     * Lấy toàn bộ danh sách sinh viên theo Khoa (để xuất Excel và quản lý hồ sơ theo Khoa)
     */
    public List<Student> getStudentsByFaculty(String facultyId) {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
            "l.TEN_LOP, n.TEN_NGANH, k.MA_KHOA, k.TEN_KHOA, u.EMAIL, u.SO_DIEN_THOAI, u.TRANG_THAI " +
            "FROM SINH_VIEN s " +
            "LEFT JOIN LOP_CHUYEN_NGANH l ON s.MA_LOP = l.MA_LOP " +
            "LEFT JOIN NGANH n ON l.MA_NGANH = n.MA_NGANH " +
            "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
            "LEFT JOIN TAI_KHOAN u ON s.TAI_KHOAN_ID = u.ID " +
            "WHERE 1=1 "
        );
        if (facultyId != null && !facultyId.trim().isEmpty()) {
            sql.append("AND k.MA_KHOA = ? ");
        }
        sql.append("ORDER BY s.MA_LOP ASC, s.MA_SV ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            if (facultyId != null && !facultyId.trim().isEmpty()) {
                ps.setString(1, facultyId.trim());
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Student st = new Student();
                st.setStudentId(rs.getString("MA_SV"));
                st.setFullName(rs.getString("HO_TEN"));
                st.setDateOfBirth(rs.getDate("NGAY_SINH"));
                st.setGender(rs.getString("GIOI_TINH"));
                st.setHometown(rs.getString("QUE_QUAN"));
                st.setClassId(rs.getString("MA_LOP"));
                st.setClassName(rs.getString("TEN_LOP"));
                st.setMajorName(rs.getString("TEN_NGANH"));
                st.setFacultyName(rs.getString("TEN_KHOA"));
                st.setEmail(rs.getString("EMAIL"));
                st.setPhone(rs.getString("SO_DIEN_THOAI"));
                st.setStatus(rs.getInt("TRANG_THAI"));
                list.add(st);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }
}
