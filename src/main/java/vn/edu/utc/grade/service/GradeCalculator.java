package vn.edu.utc.grade.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import vn.edu.utc.grade.model.grading.Grade;

/**
 * Bộ máy tính toán và quy đổi điểm chuẩn Trường Đại học Giao thông Vận tải (UTC)
 */
public class GradeCalculator {

    /**
     * Tính điểm tổng kết thang 10 theo trọng số môn học, làm tròn 1 chữ số thập phân
     */
    public static Double calculateTotal10(Double cc, Double gk, Double thi,
                                          double wCC, double wGK, double wThi) {
        if (thi == null) {
            return null;
        }
        double valCC = (cc != null) ? cc : 0.0;
        double valGK = (gk != null) ? gk : 0.0;
        double valThi = thi;

        BigDecimal bCC = BigDecimal.valueOf(valCC);
        BigDecimal bGK = BigDecimal.valueOf(valGK);
        BigDecimal bThi = BigDecimal.valueOf(valThi);
        BigDecimal bWCC = BigDecimal.valueOf(wCC);
        BigDecimal bWGK = BigDecimal.valueOf(wGK);
        BigDecimal bWThi = BigDecimal.valueOf(wThi);

        BigDecimal total = bCC.multiply(bWCC)
                              .add(bGK.multiply(bWGK))
                              .add(bThi.multiply(bWThi));
        return total.setScale(1, RoundingMode.HALF_UP).doubleValue();
    }

    /**
     * Quy đổi điểm thang 10 sang Điểm chữ (A+, A, B+, B, C+, C, D+, D, F+, F)
     * Có xét điều kiện điểm liệt thi kết thúc học phần (< 4.0 theo Quy chế đào tạo UTC)
     */
    public static String toLetterScore(Double score10, Double finalScore) {
        if (score10 == null) return null;

        // Quy tắc điểm liệt: Nếu điểm thi kết thúc học phần < 4.0 thì kết quả là F hoặc F+
        if (finalScore != null && finalScore < 4.0) {
            return (score10 >= 2.0) ? "F+" : "F";
        }

        if (score10 >= 9.5) return "A+";
        if (score10 >= 8.5) return "A";
        if (score10 >= 8.0) return "B+";
        if (score10 >= 7.0) return "B";
        if (score10 >= 6.0) return "C+";
        if (score10 >= 5.5) return "C";
        if (score10 >= 4.5) return "D+";
        if (score10 >= 4.0) return "D";
        if (score10 >= 2.0) return "F+";
        return "F";
    }

    public static String toLetterScore(Double score10) {
        return toLetterScore(score10, null);
    }

    /**
     * Quy đổi từ điểm chữ sang Điểm thang 4 chuẩn UTC
     */
    public static Double toScale4(String letter) {
        if (letter == null) return null;
        switch (letter.toUpperCase().trim()) {
            case "A+": return 4.0;
            case "A":  return 3.8;
            case "B+": return 3.5;
            case "B":  return 3.0;
            case "C+": return 2.5;
            case "C":  return 2.0;
            case "D+": return 1.5;
            case "D":  return 1.0;
            case "F+": return 0.5;
            case "F":  return 0.0;
            default:   return 0.0;
        }
    }

    /**
     * Xác định kết quả học phần: 'DAT' (>= 4.0 thang 10 và thi >= 4.0) hoặc 'KHONG_DAT'
     */
    public static String getResult(Double score10, Double finalScore) {
        if (score10 == null) return null;
        if (finalScore != null && finalScore < 4.0) {
            return "KHONG_DAT";
        }
        return (score10 >= 4.0) ? "DAT" : "KHONG_DAT";
    }

    public static String getResult(Double score10) {
        return getResult(score10, null);
    }

    /**
     * Tính điểm trung bình GPA/CPA theo danh sách điểm các môn học
     */
    public static Double calculateAverageScale4(List<Grade> grades) {
        if (grades == null || grades.isEmpty()) return 0.0;

        double totalWeightedScore = 0.0;
        int totalCredits = 0;

        for (Grade g : grades) {
            if (g.getScoreScale4() != null && g.getCredits() > 0) {
                totalWeightedScore += g.getScoreScale4() * g.getCredits();
                totalCredits += g.getCredits();
            }
        }

        if (totalCredits == 0) return 0.0;

        double avg = totalWeightedScore / totalCredits;
        return BigDecimal.valueOf(avg).setScale(2, RoundingMode.HALF_UP).doubleValue();
    }

    /**
     * Xếp loại học lực theo điểm tích lũy thang 4
     */
    public static String getAcademicRank(Double gpa) {
        if (gpa == null) return "Chưa xếp loại";
        if (gpa >= 3.60) return "Xuất sắc";
        if (gpa >= 3.20) return "Giỏi";
        if (gpa >= 2.50) return "Khá";
        if (gpa >= 2.00) return "Trung bình";
        if (gpa >= 1.00) return "Yếu";
        return "Kém";
    }

    /**
     * Kiểm tra trạng thái cảnh báo học vụ
     */
    public static String getAcademicWarning(Double cpa) {
        if (cpa == null) return "Bình thường";
        if (cpa < 0.8) return "Cảnh báo mức 2 (Nguy cơ buộc thôi học)";
        if (cpa < 1.0) return "Cảnh báo mức 1";
        return "Bình thường";
    }
}
