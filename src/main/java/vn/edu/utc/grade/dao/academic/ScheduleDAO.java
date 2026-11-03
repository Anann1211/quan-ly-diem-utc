package vn.edu.utc.grade.dao.academic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.academic.Schedule;

public class ScheduleDAO {

    public List<Schedule> getAllSchedules(String semesterId, Integer dayOfWeek) {
        List<Schedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
            "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
            "lh.LOAI_LICH, lh.GHI_CHU, lh.NGAY_HOC, " +
            "dx.HINH_THUC AS LEAVE_TYPE, dx.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_DAY_THAY, " +
            "dx.NGAY_NGHI, dx.NGAY_BU " +
            "FROM LICH_HOC lh " +
            "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
            "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
            "LEFT JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
            "LEFT JOIN ( " +
            "    SELECT LICH_HOC_ID, HINH_THUC, MA_GV_DAY_THAY, NGAY_NGHI, NGAY_BU, " +
            "           ROW_NUMBER() OVER (PARTITION BY LICH_HOC_ID ORDER BY ID DESC) as rn " +
            "    FROM DON_XIN_NGHI " +
            "    WHERE TRANG_THAI = 'APPROVED' " +
            ") dx ON lh.ID = dx.LICH_HOC_ID AND dx.rn = 1 " +
            "LEFT JOIN GIANG_VIEN gv_thay ON dx.MA_GV_DAY_THAY = gv_thay.MA_GV " +
            "WHERE 1=1 "
        );

        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("AND lhp.MA_HOC_KY = ? ");
        }
        if (dayOfWeek != null && dayOfWeek > 0) {
            sql.append("AND lh.THU = ? ");
        }
        sql.append("ORDER BY lh.THU ASC, lh.TIET_BAT_DAU ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(idx++, semesterId);
            }
            if (dayOfWeek != null && dayOfWeek > 0) {
                ps.setInt(idx++, dayOfWeek);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractSchedule(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public Schedule getScheduleById(int id) {
        String sql = "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
                     "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
                     "lh.LOAI_LICH, lh.GHI_CHU, lh.NGAY_HOC, " +
                     "dx.HINH_THUC AS LEAVE_TYPE, dx.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_DAY_THAY, " +
                     "dx.NGAY_NGHI, dx.NGAY_BU " +
                     "FROM LICH_HOC lh " +
                     "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
                     "LEFT JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
                     "LEFT JOIN ( " +
                     "    SELECT LICH_HOC_ID, HINH_THUC, MA_GV_DAY_THAY, NGAY_NGHI, NGAY_BU, " +
                     "           ROW_NUMBER() OVER (PARTITION BY LICH_HOC_ID ORDER BY ID DESC) as rn " +
                     "    FROM DON_XIN_NGHI " +
                     "    WHERE TRANG_THAI = 'APPROVED' " +
                     ") dx ON lh.ID = dx.LICH_HOC_ID AND dx.rn = 1 " +
                     "LEFT JOIN GIANG_VIEN gv_thay ON dx.MA_GV_DAY_THAY = gv_thay.MA_GV " +
                     "WHERE lh.ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractSchedule(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    public List<Schedule> getSchedulesByLecturer(String lecturerId, String semesterId) {
        List<Schedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
            "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
            "lh.LOAI_LICH, lh.GHI_CHU, lh.NGAY_HOC, " +
            "dx.HINH_THUC AS LEAVE_TYPE, dx.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_DAY_THAY, " +
            "dx.NGAY_NGHI, dx.NGAY_BU " +
            "FROM LICH_HOC lh " +
            "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
            "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
            "JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
            "LEFT JOIN ( " +
            "    SELECT LICH_HOC_ID, HINH_THUC, MA_GV_DAY_THAY, NGAY_NGHI, NGAY_BU, " +
            "           ROW_NUMBER() OVER (PARTITION BY LICH_HOC_ID ORDER BY ID DESC) as rn " +
            "    FROM DON_XIN_NGHI " +
            "    WHERE TRANG_THAI = 'APPROVED' " +
            ") dx ON lh.ID = dx.LICH_HOC_ID AND dx.rn = 1 " +
            "LEFT JOIN GIANG_VIEN gv_thay ON dx.MA_GV_DAY_THAY = gv_thay.MA_GV " +
            "WHERE (lh.MA_GV = ? OR (dx.MA_GV_DAY_THAY = ? AND dx.HINH_THUC = 'DAY_THAY')) "
        );
        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("AND lhp.MA_HOC_KY = ? ");
        }
        sql.append("ORDER BY lh.THU ASC, lh.TIET_BAT_DAU ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, lecturerId);
            ps.setString(2, lecturerId);
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(3, semesterId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractSchedule(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public List<Schedule> getSchedulesByStudent(String studentId, String semesterId) {
        List<Schedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
            "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
            "lh.LOAI_LICH, lh.GHI_CHU, lh.NGAY_HOC, " +
            "dx.HINH_THUC AS LEAVE_TYPE, dx.MA_GV_DAY_THAY, gv_thay.HO_TEN AS TEN_GV_DAY_THAY, " +
            "dx.NGAY_NGHI, dx.NGAY_BU " +
            "FROM LICH_HOC lh " +
            "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
            "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
            "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
            "JOIN BANG_DIEM b ON lhp.MA_LHP = b.MA_LHP " +
            "LEFT JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
            "LEFT JOIN ( " +
            "    SELECT LICH_HOC_ID, HINH_THUC, MA_GV_DAY_THAY, NGAY_NGHI, NGAY_BU, " +
            "           ROW_NUMBER() OVER (PARTITION BY LICH_HOC_ID ORDER BY ID DESC) as rn " +
            "    FROM DON_XIN_NGHI " +
            "    WHERE TRANG_THAI = 'APPROVED' " +
            ") dx ON lh.ID = dx.LICH_HOC_ID AND dx.rn = 1 " +
            "LEFT JOIN GIANG_VIEN gv_thay ON dx.MA_GV_DAY_THAY = gv_thay.MA_GV " +
            "WHERE b.MA_SV = ? "
        );
        if (semesterId != null && !semesterId.trim().isEmpty()) {
            sql.append("AND lhp.MA_HOC_KY = ? ");
        }
        sql.append("ORDER BY lh.THU ASC, lh.TIET_BAT_DAU ASC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setString(1, studentId);
            if (semesterId != null && !semesterId.trim().isEmpty()) {
                ps.setString(2, semesterId);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractSchedule(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    public boolean insertSchedule(Schedule s) {
        String sql = "INSERT INTO LICH_HOC (MA_LHP, THU, TIET_BAT_DAU, SO_TIET, PHONG_HOC, MA_GV, LOAI_LICH, GHI_CHU, NGAY_HOC) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getCourseClassId());
            ps.setInt(2, s.getDayOfWeek());
            ps.setInt(3, s.getStartPeriod());
            ps.setInt(4, s.getPeriodCount());
            ps.setString(5, s.getRoom());
            ps.setString(6, s.getLecturerId());
            ps.setString(7, s.getScheduleType() != null ? s.getScheduleType() : "LY_THUYET");
            ps.setString(8, s.getNote());
            if (s.getScheduleDate() != null) {
                ps.setDate(9, s.getScheduleDate());
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean updateSchedule(Schedule s) {
        String sql = "UPDATE LICH_HOC SET MA_LHP = ?, THU = ?, TIET_BAT_DAU = ?, SO_TIET = ?, " +
                     "PHONG_HOC = ?, MA_GV = ?, LOAI_LICH = ?, GHI_CHU = ?, NGAY_HOC = ? WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getCourseClassId());
            ps.setInt(2, s.getDayOfWeek());
            ps.setInt(3, s.getStartPeriod());
            ps.setInt(4, s.getPeriodCount());
            ps.setString(5, s.getRoom());
            ps.setString(6, s.getLecturerId());
            ps.setString(7, s.getScheduleType());
            ps.setString(8, s.getNote());
            if (s.getScheduleDate() != null) {
                ps.setDate(9, s.getScheduleDate());
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }
            ps.setInt(10, s.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    public boolean deleteSchedule(int id) {
        String sql = "DELETE FROM LICH_HOC WHERE ID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    /**
     * Kiểm tra xung đột phòng học:
     * Trả về Schedule bị trùng phòng nếu có, hoặc null nếu an toàn.
     */
    public Schedule checkRoomConflict(String room, int dayOfWeek, int startPeriod, int periodCount, int excludeScheduleId) {
        int endPeriod = startPeriod + periodCount - 1;
        String sql = "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
                     "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
                     "lh.LOAI_LICH, lh.GHI_CHU " +
                     "FROM LICH_HOC lh " +
                     "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
                     "LEFT JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
                     "WHERE UPPER(lh.PHONG_HOC) = UPPER(?) AND lh.THU = ? " +
                     "AND lh.TIET_BAT_DAU <= ? AND (lh.TIET_BAT_DAU + lh.SO_TIET - 1) >= ? " +
                     "AND lh.ID != ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, room.trim());
            ps.setInt(2, dayOfWeek);
            ps.setInt(3, endPeriod);
            ps.setInt(4, startPeriod);
            ps.setInt(5, excludeScheduleId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractSchedule(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    /**
     * Kiểm tra xung đột giảng viên:
     * Trả về Schedule bị trùng giảng viên nếu có, hoặc null nếu an toàn.
     */
    public Schedule checkLecturerConflict(String lecturerId, int dayOfWeek, int startPeriod, int periodCount, int excludeScheduleId) {
        int endPeriod = startPeriod + periodCount - 1;
        String sql = "SELECT lh.ID, lh.MA_LHP, lhp.TEN_LHP, lhp.MA_MON, m.TEN_MON, lhp.MA_HOC_KY, h.TEN_HOC_KY, " +
                     "lh.THU, lh.TIET_BAT_DAU, lh.SO_TIET, lh.PHONG_HOC, lh.MA_GV, g.HO_TEN AS TEN_GV, " +
                     "lh.LOAI_LICH, lh.GHI_CHU " +
                     "FROM LICH_HOC lh " +
                     "JOIN LOP_HOC_PHAN lhp ON lh.MA_LHP = lhp.MA_LHP " +
                     "JOIN MON_HOC m ON lhp.MA_MON = m.MA_MON " +
                     "JOIN HOC_KY h ON lhp.MA_HOC_KY = h.MA_HOC_KY " +
                     "LEFT JOIN GIANG_VIEN g ON lh.MA_GV = g.MA_GV " +
                     "WHERE lh.MA_GV = ? AND lh.THU = ? " +
                     "AND lh.TIET_BAT_DAU <= ? AND (lh.TIET_BAT_DAU + lh.SO_TIET - 1) >= ? " +
                     "AND lh.ID != ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, lecturerId);
            ps.setInt(2, dayOfWeek);
            ps.setInt(3, endPeriod);
            ps.setInt(4, startPeriod);
            ps.setInt(5, excludeScheduleId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractSchedule(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    private Schedule extractSchedule(ResultSet rs) throws Exception {
        Schedule s = new Schedule();
        s.setId(rs.getInt("ID"));
        s.setCourseClassId(rs.getString("MA_LHP"));
        s.setCourseClassName(rs.getString("TEN_LHP"));
        s.setSubjectId(rs.getString("MA_MON"));
        s.setSubjectName(rs.getString("TEN_MON"));
        s.setSemesterId(rs.getString("MA_HOC_KY"));
        s.setSemesterName(rs.getString("TEN_HOC_KY"));
        s.setDayOfWeek(rs.getInt("THU"));
        s.setStartPeriod(rs.getInt("TIET_BAT_DAU"));
        s.setPeriodCount(rs.getInt("SO_TIET"));
        s.setRoom(rs.getString("PHONG_HOC"));
        s.setLecturerId(rs.getString("MA_GV"));
        s.setLecturerName(rs.getString("TEN_GV"));
        s.setScheduleType(rs.getString("LOAI_LICH"));
        s.setNote(rs.getString("GHI_CHU"));

        try {
            s.setScheduleDate(rs.getDate("NGAY_HOC"));
        } catch (Exception ignore) {}

        try {
            String leaveType = rs.getString("LEAVE_TYPE");
            if (leaveType != null) {
                s.setHasApprovedLeave(true);
                s.setLeaveType(leaveType);
                s.setSubstituteLecturerId(rs.getString("MA_GV_DAY_THAY"));
                s.setSubstituteLecturerName(rs.getString("TEN_GV_DAY_THAY"));
                s.setLeaveDate(rs.getDate("NGAY_NGHI"));
                s.setMakeupDate(rs.getDate("NGAY_BU"));
            }
        } catch (Exception ignore) {}

        return s;
    }
}
