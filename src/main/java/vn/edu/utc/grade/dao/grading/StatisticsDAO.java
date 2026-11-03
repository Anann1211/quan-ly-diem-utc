package vn.edu.utc.grade.dao.grading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.model.account.Student;

public class StatisticsDAO {

    public Map<String, Integer> getDashboardSummary() {
        Map<String, Integer> map = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();

            // Tổng sinh viên
            ps = conn.prepareStatement("SELECT COUNT(*) FROM SINH_VIEN");
            rs = ps.executeQuery();
            if (rs.next()) map.put("totalStudents", rs.getInt(1));
            rs.close(); ps.close();

            // Tổng giảng viên
            ps = conn.prepareStatement("SELECT COUNT(*) FROM GIANG_VIEN");
            rs = ps.executeQuery();
            if (rs.next()) map.put("totalLecturers", rs.getInt(1));
            rs.close(); ps.close();

            // Tổng lớp học phần
            ps = conn.prepareStatement("SELECT COUNT(*) FROM LOP_HOC_PHAN");
            rs = ps.executeQuery();
            if (rs.next()) map.put("totalClasses", rs.getInt(1));
            rs.close(); ps.close();

            // Tổng đơn phúc khảo chờ xử lý
            ps = conn.prepareStatement("SELECT COUNT(*) FROM PHUC_KHAO WHERE TRANG_THAI = 'PENDING'");
            rs = ps.executeQuery();
            if (rs.next()) map.put("pendingAppeals", rs.getInt(1));
            rs.close(); ps.close();

            // Lớp HP đã công bố điểm
            ps = conn.prepareStatement("SELECT COUNT(*) FROM LOP_HOC_PHAN WHERE TRANG_THAI_DIEM = 'PUBLISHED'");
            rs = ps.executeQuery();
            if (rs.next()) map.put("publishedClasses", rs.getInt(1));
            rs.close(); ps.close();

            // Lớp HP chờ duyệt điểm
            ps = conn.prepareStatement("SELECT COUNT(*) FROM LOP_HOC_PHAN WHERE TRANG_THAI_DIEM = 'SUBMITTED'");
            rs = ps.executeQuery();
            if (rs.next()) map.put("submittedClasses", rs.getInt(1));
            rs.close(); ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return map;
    }

    public Map<String, Integer> getOverallGradeDistribution() {
        Map<String, Integer> map = new LinkedHashMap<>();
        map.put("A+", 0); map.put("A", 0); map.put("B+", 0); map.put("B", 0);
        map.put("C+", 0); map.put("C", 0); map.put("D+", 0); map.put("D", 0);
        map.put("F+", 0); map.put("F", 0);

        String sql = "SELECT DIEM_CHU, COUNT(*) AS CNT FROM BANG_DIEM " +
                     "WHERE DIEM_CHU IS NOT NULL GROUP BY DIEM_CHU";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
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

    public List<Student> getTopStudents(int limit) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "lop.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, " +
                     "ROUND(SUM(b.DIEM_THANG_4 * m.SO_TIN_CHI) / NULLIF(SUM(m.SO_TIN_CHI), 0), 2) AS CPA, " +
                     "SUM(CASE WHEN b.DIEM_THANG_4 >= 1.0 THEN m.SO_TIN_CHI ELSE 0 END) AS TIN_CHI_DAT " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
                     "LEFT JOIN NGANH n ON lop.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "JOIN BANG_DIEM b ON s.MA_SV = b.MA_SV " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "WHERE lhp.TRANG_THAI_DIEM = 'PUBLISHED' AND m.LOAI_MON = 'TIN_CHI' AND b.DIEM_THANG_4 IS NOT NULL " +
                     "GROUP BY s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, lop.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA " +
                     "ORDER BY CPA DESC, TIN_CHI_DAT DESC " +
                     "FETCH FIRST ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setStudentId(rs.getString("MA_SV"));
                s.setFullName(rs.getString("HO_TEN"));
                s.setDateOfBirth(rs.getDate("NGAY_SINH"));
                s.setGender(rs.getString("GIOI_TINH"));
                s.setHometown(rs.getString("QUE_QUAN"));
                s.setClassId(rs.getString("MA_LOP"));
                s.setClassName(rs.getString("TEN_LOP"));
                s.setMajorName(rs.getString("TEN_NGANH"));
                s.setFacultyName(rs.getString("TEN_KHOA"));
                s.setCpa(rs.getDouble("CPA"));
                s.setTotalCredits(rs.getInt("TIN_CHI_DAT"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<Student> getWarningStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, " +
                     "lop.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA, " +
                     "ROUND(SUM(b.DIEM_THANG_4 * m.SO_TIN_CHI) / NULLIF(SUM(m.SO_TIN_CHI), 0), 2) AS CPA, " +
                     "SUM(CASE WHEN b.DIEM_THANG_4 >= 1.0 THEN m.SO_TIN_CHI ELSE 0 END) AS TIN_CHI_DAT " +
                     "FROM SINH_VIEN s " +
                     "LEFT JOIN LOP_CHUYEN_NGANH lop ON s.MA_LOP = lop.MA_LOP " +
                     "LEFT JOIN NGANH n ON lop.MA_NGANH = n.MA_NGANH " +
                     "LEFT JOIN KHOA k ON n.MA_KHOA = k.MA_KHOA " +
                     "JOIN BANG_DIEM b ON s.MA_SV = b.MA_SV " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "WHERE lhp.TRANG_THAI_DIEM = 'PUBLISHED' AND m.LOAI_MON = 'TIN_CHI' AND b.DIEM_THANG_4 IS NOT NULL " +
                     "GROUP BY s.MA_SV, s.HO_TEN, s.NGAY_SINH, s.GIOI_TINH, s.QUE_QUAN, s.MA_LOP, lop.TEN_LOP, n.TEN_NGANH, k.TEN_KHOA " +
                     "HAVING ROUND(SUM(b.DIEM_THANG_4 * m.SO_TIN_CHI) / NULLIF(SUM(m.SO_TIN_CHI), 0), 2) < 1.0 " +
                     "ORDER BY CPA ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setStudentId(rs.getString("MA_SV"));
                s.setFullName(rs.getString("HO_TEN"));
                s.setDateOfBirth(rs.getDate("NGAY_SINH"));
                s.setGender(rs.getString("GIOI_TINH"));
                s.setHometown(rs.getString("QUE_QUAN"));
                s.setClassId(rs.getString("MA_LOP"));
                s.setClassName(rs.getString("TEN_LOP"));
                s.setMajorName(rs.getString("TEN_NGANH"));
                s.setFacultyName(rs.getString("TEN_KHOA"));
                s.setCpa(rs.getDouble("CPA"));
                s.setTotalCredits(rs.getInt("TIN_CHI_DAT"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }
}
