package vn.edu.utc.grade.dao.grading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.dao.academic.CourseClassDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.grading.Appeal;
import vn.edu.utc.grade.model.grading.Grade;
import vn.edu.utc.grade.service.GradeCalculator;

public class AppealDAO {

    public List<Appeal> getAllAppeals() {
        List<Appeal> list = new ArrayList<>();
        String sql = "SELECT p.ID, p.BANG_DIEM_ID, p.MA_SV, s.HO_TEN AS TEN_SV, " +
                     "lhp.MA_LHP, lhp.TEN_LHP, m.TEN_MON, p.LY_DO, p.DIEM_THI_CU, p.DIEM_THI_MOI, " +
                     "p.TRANG_THAI, p.NGAY_NOP, p.NGAY_XU_LY, p.GHI_CHU, p.NGUOI_XU_LY " +
                     "FROM PHUC_KHAO p " +
                     "JOIN BANG_DIEM b ON p.BANG_DIEM_ID = b.ID " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN SINH_VIEN s ON p.MA_SV = s.MA_SV " +
                     "ORDER BY p.NGAY_NOP DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppeal(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<Appeal> getAppealsByStudent(String studentId) {
        List<Appeal> list = new ArrayList<>();
        String sql = "SELECT p.ID, p.BANG_DIEM_ID, p.MA_SV, s.HO_TEN AS TEN_SV, " +
                     "lhp.MA_LHP, lhp.TEN_LHP, m.TEN_MON, p.LY_DO, p.DIEM_THI_CU, p.DIEM_THI_MOI, " +
                     "p.TRANG_THAI, p.NGAY_NOP, p.NGAY_XU_LY, p.GHI_CHU, p.NGUOI_XU_LY " +
                     "FROM PHUC_KHAO p " +
                     "JOIN BANG_DIEM b ON p.BANG_DIEM_ID = b.ID " +
                     "JOIN LOP_HOC_PHAN lhp ON b.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN SINH_VIEN s ON p.MA_SV = s.MA_SV " +
                     "WHERE p.MA_SV = ? " +
                     "ORDER BY p.NGAY_NOP DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAppeal(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean hasPendingAppeal(int gradeId) {
        String sql = "SELECT COUNT(*) FROM PHUC_KHAO WHERE BANG_DIEM_ID = ? AND TRANG_THAI = 'PENDING'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, gradeId);
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

    public boolean insertAppeal(Appeal a) {
        String sql = "INSERT INTO PHUC_KHAO (BANG_DIEM_ID, MA_SV, LY_DO, DIEM_THI_CU, TRANG_THAI, NGAY_NOP, GHI_CHU) " +
                     "VALUES (?, ?, ?, ?, 'PENDING', CURRENT_TIMESTAMP, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, a.getGradeId());
            ps.setString(2, a.getStudentId());
            ps.setString(3, a.getReason());
            if (a.getOldFinalScore() != null) {
                ps.setDouble(4, a.getOldFinalScore());
            } else {
                ps.setNull(4, java.sql.Types.DOUBLE);
            }
            ps.setString(5, a.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean processAppeal(int appealId, String status, Double newFinalScore, String note, String processedBy) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Cập nhật đơn phúc khảo
            String updateAppealSql = "UPDATE PHUC_KHAO SET TRANG_THAI = ?, DIEM_THI_MOI = ?, " +
                                     "GHI_CHU = ?, NGUOI_XU_LY = ?, NGAY_XU_LY = CURRENT_TIMESTAMP " +
                                     "WHERE ID = ?";
            ps = conn.prepareStatement(updateAppealSql);
            ps.setString(1, status);
            if (newFinalScore != null) {
                ps.setDouble(2, newFinalScore);
            } else {
                ps.setNull(2, java.sql.Types.DOUBLE);
            }
            ps.setString(3, note);
            ps.setString(4, processedBy);
            ps.setInt(5, appealId);
            ps.executeUpdate();
            ps.close();

            // 2. Nếu chấp thuận (APPROVED) và có điểm thi mới, cập nhật bảng điểm và ghi Audit Log
            if ("APPROVED".equalsIgnoreCase(status) && newFinalScore != null) {
                GradeDAO gradeDAO = new GradeDAO();
                CourseClassDAO ccDAO = new CourseClassDAO();

                // Lấy thông tin điểm cũ
                String getGradeIdSql = "SELECT BANG_DIEM_ID FROM PHUC_KHAO WHERE ID = ?";
                ps = conn.prepareStatement(getGradeIdSql);
                ps.setInt(1, appealId);
                ResultSet rs = ps.executeQuery();
                int gradeId = 0;
                if (rs.next()) {
                    gradeId = rs.getInt("BANG_DIEM_ID");
                }
                rs.close();
                ps.close();

                if (gradeId > 0) {
                    Grade oldGrade = gradeDAO.getGradeById(gradeId);
                    CourseClass cc = ccDAO.getCourseClassById(oldGrade.getCourseClassId());

                    // Tính lại điểm tổng kết
                    Double newTotal10 = GradeCalculator.calculateTotal10(
                        oldGrade.getScoreAttendance(),
                        oldGrade.getScoreMidterm(),
                        newFinalScore,
                        cc.getWeightAttendance(),
                        cc.getWeightMidterm(),
                        cc.getWeightFinal()
                    );
                    String newLetter = GradeCalculator.toLetterScore(newTotal10);
                    Double newScale4 = GradeCalculator.toScale4(newLetter);
                    String newResult = GradeCalculator.getResult(newTotal10);

                    // Cập nhật bảng điểm
                    String updateGradeSql = "UPDATE BANG_DIEM SET DIEM_THI = ?, DIEM_TK_10 = ?, " +
                                            "DIEM_CHU = ?, DIEM_THANG_4 = ?, KET_QUA = ?, " +
                                            "GHI_CHU = N'Hiệu chỉnh sau phúc khảo' WHERE ID = ?";
                    ps = conn.prepareStatement(updateGradeSql);
                    ps.setDouble(1, newFinalScore);
                    ps.setDouble(2, newTotal10);
                    ps.setString(3, newLetter);
                    ps.setDouble(4, newScale4);
                    ps.setString(5, newResult);
                    ps.setInt(6, gradeId);
                    ps.executeUpdate();
                    ps.close();

                    // Ghi Audit Log
                    String logSql = "INSERT INTO LICHSU_SUA_DIEM (BANG_DIEM_ID, NGUOI_SUA, DIEM_CU, DIEM_MOI, LY_DO) " +
                                    "VALUES (?, ?, ?, ?, ?)";
                    ps = conn.prepareStatement(logSql);
                    ps.setInt(1, gradeId);
                    ps.setString(2, processedBy);
                    ps.setString(3, "Điểm thi: " + oldGrade.getScoreFinal() + ", TK10: " + oldGrade.getScoreTotal10());
                    ps.setString(4, "Điểm thi: " + newFinalScore + ", TK10: " + newTotal10 + " (" + newLetter + ")");
                    ps.setString(5, "Chấp thuận đơn phúc khảo: " + note);
                    ps.executeUpdate();
                    ps.close();
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (Exception ignored) {}
            }
            DBConnection.close(ps, conn);
        }
    }

    private Appeal extractAppeal(ResultSet rs) throws Exception {
        Appeal a = new Appeal();
        a.setId(rs.getInt("ID"));
        a.setGradeId(rs.getInt("BANG_DIEM_ID"));
        a.setStudentId(rs.getString("MA_SV"));
        a.setStudentName(rs.getString("TEN_SV"));
        a.setCourseClassId(rs.getString("MA_LHP"));
        a.setCourseClassName(rs.getString("TEN_LHP"));
        a.setSubjectName(rs.getString("TEN_MON"));
        a.setReason(rs.getString("LY_DO"));
        double oldScore = rs.getDouble("DIEM_THI_CU");
        a.setOldFinalScore(rs.wasNull() ? null : oldScore);
        double newScore = rs.getDouble("DIEM_THI_MOI");
        a.setNewFinalScore(rs.wasNull() ? null : newScore);
        a.setStatus(rs.getString("TRANG_THAI"));
        a.setSubmissionDate(rs.getTimestamp("NGAY_NOP"));
        a.setProcessedDate(rs.getTimestamp("NGAY_XU_LY"));
        a.setNote(rs.getString("GHI_CHU"));
        a.setProcessedBy(rs.getString("NGUOI_XU_LY"));
        return a;
    }
}
