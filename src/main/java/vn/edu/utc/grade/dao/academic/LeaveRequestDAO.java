package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.LeaveRequest;

public class LeaveRequestDAO {

    public boolean insertLeaveRequest(LeaveRequest r) {
        String sql = "INSERT INTO DON_XIN_NGHI (MA_GV, LICH_HOC_ID, NGAY_NGHI, LY_DO, HINH_THUC, MA_GV_DAY_THAY, " +
                     "NGAY_BU, THU_BU, TIET_BAT_DAU_BU, SO_TIET_BU, PHONG_BU, TRANG_THAI) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, r.getLecturerId());
            if (r.getScheduleId() != null && r.getScheduleId() > 0) {
                ps.setInt(2, r.getScheduleId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            if (r.getLeaveDate() != null) {
                ps.setDate(3, r.getLeaveDate());
            } else {
                ps.setDate(3, new java.sql.Date(System.currentTimeMillis()));
            }
            ps.setString(4, r.getReason());
            ps.setString(5, r.getLeaveType() != null ? r.getLeaveType() : "DAY_BU");
            
            if (r.getSubstituteLecturerId() != null && !r.getSubstituteLecturerId().trim().isEmpty()) {
                ps.setString(6, r.getSubstituteLecturerId().trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }

            if (r.getMakeupDate() != null) {
                ps.setDate(7, r.getMakeupDate());
            } else {
                ps.setNull(7, java.sql.Types.DATE);
            }

            if (r.getMakeupDayOfWeek() != null) {
                ps.setInt(8, r.getMakeupDayOfWeek());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            if (r.getMakeupStartPeriod() != null) {
                ps.setInt(9, r.getMakeupStartPeriod());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }

            if (r.getMakeupPeriodCount() != null) {
                ps.setInt(10, r.getMakeupPeriodCount());
            } else {
                ps.setNull(10, java.sql.Types.INTEGER);
            }

            if (r.getMakeupRoom() != null && !r.getMakeupRoom().trim().isEmpty()) {
                ps.setString(11, r.getMakeupRoom().trim());
            } else {
                ps.setNull(11, java.sql.Types.VARCHAR);
            }

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(ps, conn);
        }
        return false;
    }

    public List<LeaveRequest> getAllLeaveRequests(String statusFilter) {
        List<LeaveRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT d.ID, d.MA_GV, gv.HO_TEN AS TEN_GV, gv.HOC_HAM_HOC_VI, k.TEN_KHOA, " +
            "d.LICH_HOC_ID, lh.MA_LHP, lhp.TEN_LHP, m.TEN_MON, " +
            "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, " +
            "d.NGAY_NGHI, d.LY_DO, d.HINH_THUC, " +
            "d.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_THAY, gv_thay.HOC_HAM_HOC_VI AS HOC_HAM_GV_THAY, " +
            "d.NGAY_BU, d.THU_BU, d.TIET_BAT_DAU_BU, d.SO_TIET_BU, d.PHONG_BU, " +
            "d.TRANG_THAI, d.NGAY_TAO, d.NGAY_DUYET, d.NGUOI_DUYET, d.PHAN_HOI " +
            "FROM DON_XIN_NGHI d " +
            "JOIN GIANG_VIEN gv ON d.MA_GV = gv.MA_GV " +
            "LEFT JOIN KHOA k ON gv.MA_KHOA = k.MA_KHOA " +
            "LEFT JOIN GIANG_VIEN gv_thay ON d.MA_GV_DAY_THAY = gv_thay.MA_GV " +
            "LEFT JOIN LICH_HOC lh ON d.LICH_HOC_ID = lh.ID " +
            "LEFT JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
            "LEFT JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON "
        );
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("WHERE d.TRANG_THAI = ? ");
        }
        sql.append("ORDER BY CASE WHEN d.TRANG_THAI = 'PENDING' THEN 1 ELSE 2 END, d.NGAY_TAO DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(1, statusFilter.trim());
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractLeaveRequest(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<LeaveRequest> getLeaveRequestsByLecturer(String lecturerId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT d.ID, d.MA_GV, gv.HO_TEN AS TEN_GV, gv.HOC_HAM_HOC_VI, k.TEN_KHOA, " +
                     "d.LICH_HOC_ID, lh.MA_LHP, lhp.TEN_LHP, m.TEN_MON, " +
                     "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, " +
                     "d.NGAY_NGHI, d.LY_DO, d.HINH_THUC, " +
                     "d.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_THAY, gv_thay.HOC_HAM_HOC_VI AS HOC_HAM_GV_THAY, " +
                     "d.NGAY_BU, d.THU_BU, d.TIET_BAT_DAU_BU, d.SO_TIET_BU, d.PHONG_BU, " +
                     "d.TRANG_THAI, d.NGAY_TAO, d.NGAY_DUYET, d.NGUOI_DUYET, d.PHAN_HOI " +
                     "FROM DON_XIN_NGHI d " +
                     "JOIN GIANG_VIEN gv ON d.MA_GV = gv.MA_GV " +
                     "LEFT JOIN KHOA k ON gv.MA_KHOA = k.MA_KHOA " +
                     "LEFT JOIN GIANG_VIEN gv_thay ON d.MA_GV_DAY_THAY = gv_thay.MA_GV " +
                     "LEFT JOIN LICH_HOC lh ON d.LICH_HOC_ID = lh.ID " +
                     "LEFT JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
                     "LEFT JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "WHERE d.MA_GV = ? OR d.MA_GV_DAY_THAY = ? " +
                     "ORDER BY d.NGAY_TAO DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, lecturerId);
            ps.setString(2, lecturerId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractLeaveRequest(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public int countPendingLeaveRequests() {
        String sql = "SELECT COUNT(*) FROM DON_XIN_NGHI WHERE TRANG_THAI = 'PENDING'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
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

    public boolean updateStatus(int id, String status, String adminUser, String feedback) {
        String sql = "UPDATE DON_XIN_NGHI SET TRANG_THAI = ?, NGUOI_DUYET = ?, PHAN_HOI = ?, NGAY_DUYET = CURRENT_TIMESTAMP WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, adminUser);
            ps.setString(3, feedback);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(ps, conn);
        }
        return false;
    }

    public LeaveRequest getLeaveRequestById(int id) {
        String sql = "SELECT d.ID, d.MA_GV, gv.HO_TEN AS TEN_GV, gv.HOC_HAM_HOC_VI, k.TEN_KHOA, " +
                     "d.LICH_HOC_ID, lh.MA_LHP, lhp.TEN_LHP, m.TEN_MON, " +
                     "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, " +
                     "d.NGAY_NGHI, d.LY_DO, d.HINH_THUC, " +
                     "d.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_THAY, gv_thay.HOC_HAM_HOC_VI AS HOC_HAM_GV_THAY, " +
                     "d.NGAY_BU, d.THU_BU, d.TIET_BAT_DAU_BU, d.SO_TIET_BU, d.PHONG_BU, " +
                     "d.TRANG_THAI, d.NGAY_TAO, d.NGAY_DUYET, d.NGUOI_DUYET, d.PHAN_HOI " +
                     "FROM DON_XIN_NGHI d " +
                     "JOIN GIANG_VIEN gv ON d.MA_GV = gv.MA_GV " +
                     "LEFT JOIN KHOA k ON gv.MA_KHOA = k.MA_KHOA " +
                     "LEFT JOIN GIANG_VIEN gv_thay ON d.MA_GV_DAY_THAY = gv_thay.MA_GV " +
                     "LEFT JOIN LICH_HOC lh ON d.LICH_HOC_ID = lh.ID " +
                     "LEFT JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
                     "LEFT JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "WHERE d.ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractLeaveRequest(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    private LeaveRequest extractLeaveRequest(ResultSet rs) throws Exception {
        LeaveRequest r = new LeaveRequest();
        r.setId(rs.getInt("ID"));
        r.setLecturerId(rs.getString("MA_GV"));
        r.setLecturerName(rs.getString("TEN_GV"));
        r.setAcademicRank(rs.getString("HOC_HAM_HOC_VI"));
        r.setFacultyName(rs.getString("TEN_KHOA"));
        
        int schedId = rs.getInt("LICH_HOC_ID");
        if (!rs.wasNull()) {
            r.setScheduleId(schedId);
        }
        r.setCourseClassId(rs.getString("MA_LHP"));
        r.setCourseClassName(rs.getString("TEN_LHP"));
        r.setSubjectName(rs.getString("TEN_MON"));

        int thu = rs.getInt("THU");
        if (!rs.wasNull()) {
            String thuStr = (thu == 8) ? "Chủ Nhật" : ("Thứ " + thu);
            int tietBatDau = rs.getInt("TIET_BAT_DAU");
            int soTiet = rs.getInt("SO_TIET");
            int tietKetThuc = tietBatDau + soTiet - 1;
            String phong = rs.getString("PHONG_HOC");
            r.setScheduleInfo(thuStr + ", Tiết " + tietBatDau + "-" + tietKetThuc + " (" + phong + ")");
        } else {
            r.setScheduleInfo("-");
        }

        r.setLeaveDate(rs.getDate("NGAY_NGHI"));
        r.setReason(rs.getString("LY_DO"));
        r.setLeaveType(rs.getString("HINH_THUC"));
        r.setSubstituteLecturerId(rs.getString("MA_GV_DAY_THAY"));
        r.setSubstituteLecturerName(rs.getString("TEN_GV_THAY"));
        r.setSubstituteAcademicRank(rs.getString("HOC_HAM_GV_THAY"));
        r.setMakeupDate(rs.getDate("NGAY_BU"));

        int thuBu = rs.getInt("THU_BU");
        if (!rs.wasNull()) {
            r.setMakeupDayOfWeek(thuBu);
        }

        int tietBu = rs.getInt("TIET_BAT_DAU_BU");
        if (!rs.wasNull()) {
            r.setMakeupStartPeriod(tietBu);
        }

        int soTietBu = rs.getInt("SO_TIET_BU");
        if (!rs.wasNull()) {
            r.setMakeupPeriodCount(soTietBu);
        }

        r.setMakeupRoom(rs.getString("PHONG_BU"));
        r.setStatus(rs.getString("TRANG_THAI"));
        r.setCreatedAt(rs.getTimestamp("NGAY_TAO"));
        r.setReviewedAt(rs.getTimestamp("NGAY_DUYET"));
        r.setReviewedBy(rs.getString("NGUOI_DUYET"));
        r.setFeedback(rs.getString("PHAN_HOI"));
        return r;
    }
}
