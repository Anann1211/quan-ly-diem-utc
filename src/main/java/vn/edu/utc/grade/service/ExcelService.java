package vn.edu.utc.grade.service;

import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import vn.edu.utc.grade.dao.account.StudentDAO;
import vn.edu.utc.grade.dao.account.UserDAO;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.account.Student;
import vn.edu.utc.grade.model.grading.Grade;

public class ExcelService {

    /**
     * Lớp đóng gói kết quả phân tích và kiểm tra tính hợp lệ dữ liệu sinh viên nhập từ Excel
     */
    public static class StudentImportResult {
        private List<Student> validStudents = new ArrayList<>();
        private List<String> errorMessages = new ArrayList<>();
        private int totalRows = 0;

        public List<Student> getValidStudents() { return validStudents; }
        public List<String> getErrorMessages() { return errorMessages; }
        public boolean hasErrors() { return !errorMessages.isEmpty(); }
        public int getTotalRows() { return totalRows; }
        public void setTotalRows(int totalRows) { this.totalRows = totalRows; }
    }

    /**
     * Xuất file Excel danh sách bảng điểm mẫu chuẩn UTC
     */
    public static void exportGradeTemplate(CourseClass cc, List<Grade> grades, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Bang_Diem");
            sheet.setDisplayGridlines(true);

            // Font & Styles
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleFont.setColor(IndexedColors.DARK_BLUE.getIndex());

            CellStyle titleStyle = workbook.createCellStyle();
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);

            Font subTitleFont = workbook.createFont();
            subTitleFont.setBold(true);
            subTitleFont.setFontHeightInPoints((short) 11);

            CellStyle subTitleStyle = workbook.createCellStyle();
            subTitleStyle.setFont(subTitleFont);

            // Header Column Style
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            // Data Cell Styles
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);
            dataStyle.setAlignment(HorizontalAlignment.CENTER);

            CellStyle textLeftStyle = workbook.createCellStyle();
            textLeftStyle.cloneStyleFrom(dataStyle);
            textLeftStyle.setAlignment(HorizontalAlignment.LEFT);

            // 1. Tiêu đề trường
            Row r0 = sheet.createRow(0);
            Cell c0 = r0.createCell(0);
            c0.setCellValue("TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI - PHÒNG ĐÀO TẠO");
            c0.setCellStyle(subTitleStyle);

            Row r1 = sheet.createRow(1);
            Cell c1 = r1.createCell(0);
            c1.setCellValue("BẢNG ĐIỂM LỚP HỌC PHẦN: " + cc.getClassName().toUpperCase());
            c1.setCellStyle(titleStyle);

            // 2. Thông tin lớp học phần
            Row r2 = sheet.createRow(3);
            r2.createCell(0).setCellValue("Mã lớp HP: " + cc.getClassId());
            r2.createCell(3).setCellValue("Môn học: " + cc.getSubjectName() + " (" + cc.getCredits() + " TC)");

            Row r3 = sheet.createRow(4);
            r3.createCell(0).setCellValue("Giảng viên: " + (cc.getLecturerName() != null ? cc.getLecturerName() : ""));
            r3.createCell(3).setCellValue("Trọng số: Chuyên cần " + (int)Math.round(cc.getWeightAttendance() * 100) + "% - Giữa kỳ " + 
                                          (int)Math.round(cc.getWeightMidterm() * 100) + "% - Thi " + (int)Math.round(cc.getWeightFinal() * 100) + "%");

            // 3. Header bảng điểm
            String[] headers = {"STT", "Mã SV", "Họ và tên", "Lớp", "Điểm CC", "Điểm GK", "Điểm Thi", "Điểm TK 10", "Điểm Chữ", "Thang 4", "Kết quả", "Ghi chú"};
            Row headerRow = sheet.createRow(6);
            headerRow.setHeightInPoints(25);
            for (int i = 0; i < headers.length; i++) {
                Cell ch = headerRow.createCell(i);
                ch.setCellValue(headers[i]);
                ch.setCellStyle(headerStyle);
            }

            // 4. Data rows
            int rowIdx = 7;
            int stt = 1;
            for (Grade g : grades) {
                Row row = sheet.createRow(rowIdx++);
                Cell cSTT = row.createCell(0); cSTT.setCellValue(stt++); cSTT.setCellStyle(dataStyle);
                Cell cMSV = row.createCell(1); cMSV.setCellValue(g.getStudentId()); cMSV.setCellStyle(dataStyle);
                Cell cTen = row.createCell(2); cTen.setCellValue(g.getStudentName()); cTen.setCellStyle(textLeftStyle);
                Cell cLop = row.createCell(3); cLop.setCellValue(g.getClassName() != null ? g.getClassName() : ""); cLop.setCellStyle(dataStyle);

                Cell cCC = row.createCell(4);
                if (g.getScoreAttendance() != null) cCC.setCellValue(g.getScoreAttendance());
                cCC.setCellStyle(dataStyle);

                Cell cGK = row.createCell(5);
                if (g.getScoreMidterm() != null) cGK.setCellValue(g.getScoreMidterm());
                cGK.setCellStyle(dataStyle);

                Cell cThi = row.createCell(6);
                if (g.getScoreFinal() != null) cThi.setCellValue(g.getScoreFinal());
                cThi.setCellStyle(dataStyle);

                Cell cTK = row.createCell(7);
                if (g.getScoreTotal10() != null) cTK.setCellValue(g.getScoreTotal10());
                cTK.setCellStyle(dataStyle);

                Cell cChu = row.createCell(8);
                cChu.setCellValue(g.getScoreLetter() != null ? g.getScoreLetter() : "");
                cChu.setCellStyle(dataStyle);

                Cell cT4 = row.createCell(9);
                if (g.getScoreScale4() != null) cT4.setCellValue(g.getScoreScale4());
                cT4.setCellStyle(dataStyle);

                Cell cKQ = row.createCell(10);
                cKQ.setCellValue("DAT".equalsIgnoreCase(g.getResult()) ? "Đạt" : ("KHONG_DAT".equalsIgnoreCase(g.getResult()) ? "Học lại" : ""));
                cKQ.setCellStyle(dataStyle);

                Cell cNote = row.createCell(11);
                cNote.setCellValue(g.getNote() != null ? g.getNote() : "");
                cNote.setCellStyle(textLeftStyle);
            }

            // Tự động căn chỉnh độ rộng cột
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(out);
        }
    }

    /**
     * Đọc và phân tích file Excel do Giảng viên tải lên để cập nhật điểm.
     * Hỗ trợ tự động cả 2 định dạng .xls và .xlsx cũng như ô tính có công thức (Formula).
     */
    public static List<Grade> importGradesFromExcel(InputStream in, CourseClass cc, List<Grade> currentGrades) throws Exception {
        List<Grade> updatedGrades = new ArrayList<>();
        DataFormatter formatter = new DataFormatter();

        // WorkbookFactory tự động nhận diện cả XLS lẫn XLSX an toàn
        try (Workbook workbook = WorkbookFactory.create(in)) {
            FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
            Sheet sheet = workbook.getSheetAt(0);

            // Bắt đầu đọc từ dòng thứ 7 (dòng 0-indexed: row index 7 là dữ liệu)
            for (int r = 7; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                Cell cellMSV = row.getCell(1);
                if (cellMSV == null) continue;
                String msv = getCellString(cellMSV, formatter);
                if (msv.isEmpty()) continue;

                // Tìm sinh viên trong danh sách hiện tại của lớp
                Grade targetGrade = null;
                for (Grade g : currentGrades) {
                    if (g.getStudentId().equalsIgnoreCase(msv)) {
                        targetGrade = g;
                        break;
                    }
                }

                if (targetGrade == null) continue;

                // Đọc điểm CC, GK, Thi (hỗ trợ cả ô chứa công thức toán)
                Double ccScore = getCellDouble(row.getCell(4), evaluator);
                Double gkScore = getCellDouble(row.getCell(5), evaluator);
                Double thiScore = getCellDouble(row.getCell(6), evaluator);

                // Validate điểm trong khoảng 0.0 - 10.0
                validateScore(ccScore, "Chuyên cần", msv, r + 1);
                validateScore(gkScore, "Giữa kỳ", msv, r + 1);
                validateScore(thiScore, "Thi", msv, r + 1);

                targetGrade.setScoreAttendance(ccScore);
                targetGrade.setScoreMidterm(gkScore);
                targetGrade.setScoreFinal(thiScore);

                // Tự động tính điểm tổng kết 10, điểm chữ và thang 4 chuẩn UTC (kèm điểm liệt thi)
                if (thiScore != null) {
                    Double tk10 = GradeCalculator.calculateTotal10(
                        ccScore, gkScore, thiScore,
                        cc.getWeightAttendance(), cc.getWeightMidterm(), cc.getWeightFinal()
                    );
                    String letter = GradeCalculator.toLetterScore(tk10, thiScore);
                    Double scale4 = GradeCalculator.toScale4(letter);
                    String res = GradeCalculator.getResult(tk10, thiScore);

                    targetGrade.setScoreTotal10(tk10);
                    targetGrade.setScoreLetter(letter);
                    targetGrade.setScoreScale4(scale4);
                    targetGrade.setResult(res);
                } else {
                    targetGrade.setScoreTotal10(null);
                    targetGrade.setScoreLetter(null);
                    targetGrade.setScoreScale4(null);
                    targetGrade.setResult(null);
                }

                Cell cellNote = row.getCell(11);
                if (cellNote != null) {
                    targetGrade.setNote(getCellString(cellNote, formatter));
                }

                updatedGrades.add(targetGrade);
            }
        }
        return updatedGrades;
    }

    private static String getCellString(Cell cell, DataFormatter formatter) {
        if (cell == null) return "";
        return formatter.formatCellValue(cell).trim();
    }

    private static Double getCellDouble(Cell cell, FormulaEvaluator evaluator) {
        if (cell == null) return null;
        CellType type = cell.getCellType();

        // Xử lý ô tính chứa công thức Excel
        if (type == CellType.FORMULA && evaluator != null) {
            try {
                CellValue cellValue = evaluator.evaluate(cell);
                if (cellValue != null) {
                    if (cellValue.getCellType() == CellType.NUMERIC) {
                        return cellValue.getNumberValue();
                    } else if (cellValue.getCellType() == CellType.STRING) {
                        String s = cellValue.getStringValue().trim();
                        if (s.isEmpty()) return null;
                        return Double.parseDouble(s.replace(',', '.'));
                    }
                }
            } catch (Exception ignored) {}
            type = cell.getCachedFormulaResultType();
        }

        if (type == CellType.NUMERIC) {
            return cell.getNumericCellValue();
        } else if (type == CellType.STRING) {
            String str = cell.getStringCellValue().trim();
            if (str.isEmpty()) return null;
            try {
                return Double.parseDouble(str.replace(',', '.'));
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }

    private static void validateScore(Double score, String scoreName, String msv, int rowNum) throws Exception {
        if (score != null && (score < 0.0 || score > 10.0)) {
            throw new IllegalArgumentException("Dòng " + rowNum + " (SV: " + msv + "): Điểm " + scoreName + 
                                               " không hợp lệ (" + score + "). Điểm phải từ 0.0 đến 10.0!");
        }
    }

    /**
     * Xuất file Excel mẫu để nhập danh sách sinh viên vào lớp chuyên ngành
     */
    public static void exportStudentTemplate(OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh_Sach_Sinh_Vien");
            sheet.setDisplayGridlines(true);

            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            CellStyle textStyle = workbook.createCellStyle();
            textStyle.setBorderBottom(BorderStyle.THIN);
            textStyle.setBorderTop(BorderStyle.THIN);
            textStyle.setBorderLeft(BorderStyle.THIN);
            textStyle.setBorderRight(BorderStyle.THIN);

            Row r0 = sheet.createRow(0);
            String[] headers = {"STT", "Mã SV (*)", "Họ và tên (*)", "Ngày sinh (dd/MM/yyyy)", "Giới tính", "Quê quán", "Email", "Số điện thoại"};
            for (int i = 0; i < headers.length; i++) {
                Cell c = r0.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(headerStyle);
            }

            // Dòng dữ liệu mẫu 1: Nam
            Row r1 = sheet.createRow(1);
            r1.createCell(0).setCellValue(1);
            r1.createCell(1).setCellValue("211200101");
            r1.createCell(2).setCellValue("Nguyễn Văn An");
            r1.createCell(3).setCellValue("15/05/2003");
            r1.createCell(4).setCellValue("Nam");
            r1.createCell(5).setCellValue("Hà Nội");
            r1.createCell(6).setCellValue("an.nv@sv.utc.edu.vn");
            r1.createCell(7).setCellValue("0912345678");
            for (int i = 0; i < headers.length; i++) {
                r1.getCell(i).setCellStyle(textStyle);
            }

            // Dòng dữ liệu mẫu 2: Nữ
            Row r2 = sheet.createRow(2);
            r2.createCell(0).setCellValue(2);
            r2.createCell(1).setCellValue("211200102");
            r2.createCell(2).setCellValue("Trần Thị Mai");
            r2.createCell(3).setCellValue("20/10/2003");
            r2.createCell(4).setCellValue("Nữ");
            r2.createCell(5).setCellValue("Hải Phòng");
            r2.createCell(6).setCellValue("mai.tt@sv.utc.edu.vn");
            r2.createCell(7).setCellValue("0987654321");
            for (int i = 0; i < headers.length; i++) {
                r2.getCell(i).setCellStyle(textStyle);
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(out);
        }
    }

    /**
     * Xuất danh sách sinh viên theo Khoa ra file Excel chuẩn khung dữ liệu để quản lý và import vào lớp học phần
     */
    public static void exportStudentsByFaculty(String facultyName, List<vn.edu.utc.grade.model.account.Student> students, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("DS_Sinh_Vien");
            sheet.setDisplayGridlines(true);

            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);
            headerStyle.setBorderTop(BorderStyle.THIN);
            headerStyle.setBorderLeft(BorderStyle.THIN);
            headerStyle.setBorderRight(BorderStyle.THIN);

            CellStyle textStyle = workbook.createCellStyle();
            textStyle.setBorderBottom(BorderStyle.THIN);
            textStyle.setBorderTop(BorderStyle.THIN);
            textStyle.setBorderLeft(BorderStyle.THIN);
            textStyle.setBorderRight(BorderStyle.THIN);

            CellStyle centerStyle = workbook.createCellStyle();
            centerStyle.cloneStyleFrom(textStyle);
            centerStyle.setAlignment(HorizontalAlignment.CENTER);

            Row r0 = sheet.createRow(0);
            String[] headers = {"STT", "Mã SV (*)", "Họ và tên (*)", "Ngày sinh (dd/MM/yyyy)", "Giới tính", "Quê quán", "Email", "Số điện thoại", "Lớp Chuyên Ngành", "Khoa / Ngành"};
            for (int i = 0; i < headers.length; i++) {
                Cell c = r0.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(headerStyle);
            }

            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
            int rowIdx = 1;
            for (vn.edu.utc.grade.model.account.Student st : students) {
                Row row = sheet.createRow(rowIdx);
                Cell c0 = row.createCell(0); c0.setCellValue(rowIdx); c0.setCellStyle(centerStyle);
                Cell c1 = row.createCell(1); c1.setCellValue(st.getStudentId()); c1.setCellStyle(centerStyle);
                Cell c2 = row.createCell(2); c2.setCellValue(st.getFullName()); c2.setCellStyle(textStyle);
                Cell c3 = row.createCell(3); c3.setCellValue(st.getDateOfBirth() != null ? sdf.format(st.getDateOfBirth()) : ""); c3.setCellStyle(centerStyle);
                Cell c4 = row.createCell(4); c4.setCellValue(st.getGender() != null ? st.getGender() : ""); c4.setCellStyle(centerStyle);
                Cell c5 = row.createCell(5); c5.setCellValue(st.getHometown() != null ? st.getHometown() : ""); c5.setCellStyle(textStyle);
                Cell c6 = row.createCell(6); c6.setCellValue(st.getEmail() != null ? st.getEmail() : ""); c6.setCellStyle(textStyle);
                Cell c7 = row.createCell(7); c7.setCellValue(st.getPhone() != null ? st.getPhone() : ""); c7.setCellStyle(centerStyle);
                Cell c8 = row.createCell(8); c8.setCellValue(st.getClassName() != null ? st.getClassName() : (st.getClassId() != null ? st.getClassId() : "")); c8.setCellStyle(centerStyle);
                Cell c9 = row.createCell(9); c9.setCellValue(st.getFacultyName() != null ? st.getFacultyName() : ""); c9.setCellStyle(textStyle);
                rowIdx++;
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(out);
        }
    }

    /**
     * Phân tích và kiểm tra tính hợp lệ toàn diện dữ liệu sinh viên từ file Excel tải lên.
     * Phát hiện và báo cáo cụ thể từng lỗi do thao tác người dùng (theo từng dòng).
     */
    public static StudentImportResult parseAndValidateStudents(
            InputStream is,
            String fileName,
            String classId,
            StudentDAO studentDAO,
            UserDAO userDAO) {

        StudentImportResult result = new StudentImportResult();
        DataFormatter formatter = new DataFormatter();

        SimpleDateFormat sdfStrict = new SimpleDateFormat("dd/MM/yyyy");
        sdfStrict.setLenient(false);
        SimpleDateFormat sdfBackup = new SimpleDateFormat("yyyy-MM-dd");
        sdfBackup.setLenient(false);

        // 1. Kiểm tra định dạng tệp
        if (fileName != null && !fileName.trim().isEmpty()) {
            String lower = fileName.toLowerCase().trim();
            if (!lower.endsWith(".xlsx") && !lower.endsWith(".xls")) {
                result.getErrorMessages().add("Tệp tải lên ('" + fileName + "') không đúng định dạng. Hệ thống chỉ hỗ trợ tệp Excel đuôi .xlsx hoặc .xls!");
                return result;
            }
        }

        Workbook workbook = null;
        try {
            workbook = WorkbookFactory.create(is);
        } catch (Exception e) {
            result.getErrorMessages().add("Không thể đọc tệp Excel (tệp có thể bị hỏng hoặc sai cấu trúc: " + e.getMessage() + "). Vui lòng tải lại tệp mẫu và nhập dữ liệu!");
            return result;
        }

        try {
            if (workbook.getNumberOfSheets() == 0 || workbook.getSheetAt(0) == null) {
                result.getErrorMessages().add("Tệp Excel không chứa bất kỳ trang tính (sheet) nào!");
                return result;
            }

            Sheet sheet = workbook.getSheetAt(0);
            if (sheet.getLastRowNum() < 1) {
                result.getErrorMessages().add("Tệp Excel không chứa bất kỳ dòng dữ liệu sinh viên nào (dữ liệu phải bắt đầu từ dòng số 2)!");
                return result;
            }

            Map<String, Integer> seenStudentIdsInFile = new HashMap<>();
            Map<String, Integer> seenEmailsInFile = new HashMap<>();
            int dataRowCount = 0;

            for (int r = 1; r <= sheet.getLastRowNum(); r++) {
                Row row = sheet.getRow(r);
                if (row == null) continue;

                // Kiểm tra dòng hoàn toàn rỗng
                boolean allEmpty = true;
                for (int c = 0; c <= 7; c++) {
                    Cell cell = row.getCell(c);
                    if (cell != null && !getCellString(cell, formatter).isEmpty()) {
                        allEmpty = false;
                        break;
                    }
                }
                if (allEmpty) continue;

                dataRowCount++;
                int rowNum = r + 1; // Số thứ tự dòng hiển thị trong Excel

                String msv = getCellString(row.getCell(1), formatter);
                String hoTen = getCellString(row.getCell(2), formatter);
                Cell cellDob = row.getCell(3);
                String gender = getCellString(row.getCell(4), formatter);
                String hometown = getCellString(row.getCell(5), formatter);
                String email = getCellString(row.getCell(6), formatter);
                String phone = getCellString(row.getCell(7), formatter);

                String displayName = !hoTen.isEmpty() ? hoTen : (!msv.isEmpty() ? "Mã " + msv : "Dòng " + rowNum);

                // --- 1. Kiểm tra Họ và tên (*) (Bắt buộc) ---
                if (hoTen.isEmpty()) {
                    result.getErrorMessages().add("Dòng " + rowNum + ": Thiếu Họ và tên sinh viên (thông tin bắt buộc có dấu *).");
                } else if (hoTen.length() < 2) {
                    result.getErrorMessages().add("Dòng " + rowNum + ": Họ và tên '" + hoTen + "' quá ngắn (tối thiểu 2 ký tự).");
                } else if (hoTen.matches("^[0-9]+$")) {
                    result.getErrorMessages().add("Dòng " + rowNum + ": Họ và tên '" + hoTen + "' không hợp lệ (không thể chỉ chứa chữ số).");
                }

                // --- 2. Kiểm tra Mã sinh viên (*) (Bắt buộc) ---
                if (msv.isEmpty()) {
                    result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Thiếu Mã sinh viên (thông tin bắt buộc có dấu *).");
                } else {
                    if (msv.contains(" ") || !msv.matches("^[A-Za-z0-9_.-]+$") || msv.length() < 4 || msv.length() > 20) {
                        result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Mã sinh viên '" + msv + "' không hợp lệ (độ dài 4-20 ký tự, không chứa khoảng trắng hoặc ký tự đặc biệt).");
                    } else {
                        String msvUpper = msv.toUpperCase();
                        if (seenStudentIdsInFile.containsKey(msvUpper)) {
                            int prevRow = seenStudentIdsInFile.get(msvUpper);
                            result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Mã sinh viên '" + msv + "' bị trùng lặp với dòng " + prevRow + " trong tệp Excel.");
                        } else {
                            seenStudentIdsInFile.put(msvUpper, rowNum);
                            // Kiểm tra trùng lặp với Cơ sở dữ liệu
                            if (studentDAO != null) {
                                Student existing = studentDAO.getStudentById(msv);
                                if (existing != null) {
                                    String existingClass = existing.getClassName() != null ? existing.getClassName() : existing.getClassId();
                                    result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Mã sinh viên '" + msv + "' đã tồn tại trong hệ thống (Họ tên: " + existing.getFullName() + " - Lớp: " + existingClass + ").");
                                } else if (userDAO != null && userDAO.isUsernameExists(msv)) {
                                    result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Mã sinh viên '" + msv + "' đã được sử dụng làm tên đăng nhập của tài khoản khác trong hệ thống.");
                                }
                            }
                        }
                    }
                }

                // --- 3. Kiểm tra Ngày sinh (dd/MM/yyyy) ---
                java.sql.Date sqlDob = null;
                if (cellDob != null) {
                    if (cellDob.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(cellDob)) {
                        java.util.Date d = cellDob.getDateCellValue();
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(d);
                        int yr = cal.get(Calendar.YEAR);
                        if (yr < 1960 || yr > 2018) {
                            result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Năm sinh (" + yr + ") không hợp lệ đối với sinh viên.");
                        } else {
                            sqlDob = new java.sql.Date(d.getTime());
                        }
                    } else {
                        String dobStr = getCellString(cellDob, formatter);
                        if (!dobStr.isEmpty()) {
                            java.util.Date parsedDate = null;
                            try {
                                parsedDate = sdfStrict.parse(dobStr);
                            } catch (Exception e1) {
                                try {
                                    parsedDate = sdfBackup.parse(dobStr);
                                } catch (Exception e2) {
                                    result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Ngày sinh '" + dobStr + "' không đúng định dạng chuẩn ngày tháng (phải là ngày hợp lệ dạng dd/MM/yyyy, ví dụ: 15/05/2003).");
                                }
                            }
                            if (parsedDate != null) {
                                Calendar cal = Calendar.getInstance();
                                cal.setTime(parsedDate);
                                int yr = cal.get(Calendar.YEAR);
                                if (yr < 1960 || yr > 2018) {
                                    result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Năm sinh (" + yr + ") không hợp lý đối với sinh viên.");
                                } else {
                                    sqlDob = new java.sql.Date(parsedDate.getTime());
                                }
                            }
                        }
                    }
                }

                // --- 4. Kiểm tra Giới tính ---
                String cleanGender = "Nam";
                if (!gender.isEmpty()) {
                    if (gender.equalsIgnoreCase("Nam")) {
                        cleanGender = "Nam";
                    } else if (gender.equalsIgnoreCase("Nữ") || gender.equalsIgnoreCase("Nu")) {
                        cleanGender = "Nữ";
                    } else if (gender.equalsIgnoreCase("Khác") || gender.equalsIgnoreCase("Khac")) {
                        cleanGender = "Khác";
                    } else {
                        result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Giới tính '" + gender + "' không hợp lệ (chỉ chấp nhận 'Nam', 'Nữ' hoặc 'Khác').");
                    }
                }

                // --- 5. Kiểm tra Email ---
                String cleanEmail = !email.isEmpty() ? email.trim() : (msv + "@sv.utc.edu.vn");
                if (!email.isEmpty()) {
                    if (!cleanEmail.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
                        result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Email '" + email + "' không đúng định dạng thư điện tử (ví dụ: an.nv@sv.utc.edu.vn).");
                    } else {
                        String emailUpper = cleanEmail.toUpperCase();
                        if (seenEmailsInFile.containsKey(emailUpper)) {
                            int prevRow = seenEmailsInFile.get(emailUpper);
                            result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Email '" + email + "' bị trùng lặp với dòng " + prevRow + " trong tệp Excel.");
                        } else {
                            seenEmailsInFile.put(emailUpper, rowNum);
                        }
                    }
                }

                // --- 6. Kiểm tra Số điện thoại ---
                String cleanPhone = "";
                if (!phone.isEmpty()) {
                    cleanPhone = phone.replaceAll("[\\s.-]", "");
                    if (!cleanPhone.matches("^0[0-9]{9,10}$")) {
                        result.getErrorMessages().add("Dòng " + rowNum + " (SV: " + displayName + "): Số điện thoại '" + phone + "' không hợp lệ (phải gồm 10 chữ số và bắt đầu bằng số 0, ví dụ: 0912345678).");
                    }
                }

                // Đóng gói đối tượng Student hợp lệ
                Student st = new Student();
                st.setStudentId(msv);
                st.setFullName(hoTen);
                st.setDateOfBirth(sqlDob);
                st.setGender(cleanGender);
                st.setHometown(hometown);
                st.setClassId(classId);
                st.setEmail(cleanEmail);
                st.setPhone(cleanPhone);

                result.getValidStudents().add(st);
            }

            if (dataRowCount == 0) {
                result.getErrorMessages().add("Tệp Excel không chứa bất kỳ dòng dữ liệu sinh viên nào (dữ liệu phải bắt đầu từ dòng số 2)!");
            }
            result.setTotalRows(dataRowCount);

        } finally {
            try {
                if (workbook != null) workbook.close();
            } catch (Exception ignored) {}
        }

        return result;
    }

    /**
     * Đọc danh sách sinh viên từ file Excel (.xlsx) tải lên (hàm tương thích ngược)
     */
    public static List<vn.edu.utc.grade.model.account.Student> readStudentsFromExcel(InputStream is) throws Exception {
        StudentImportResult result = parseAndValidateStudents(is, "data.xlsx", null, null, null);
        if (result.hasErrors()) {
            throw new IllegalArgumentException(String.join("\n", result.getErrorMessages()));
        }
        return result.getValidStudents();
    }

    /**
     * Xuất sổ điểm toàn bộ một lớp chuyên ngành theo môn học
     */
    public static void exportClassroomGradeSheet(String classId, String className, String subjectName, 
                                                 String facultyName, List<Grade> grades, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Bang_Diem_" + classId);
            sheet.setDisplayGridlines(true);

            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 13);
            titleFont.setColor(IndexedColors.DARK_BLUE.getIndex());

            CellStyle titleStyle = workbook.createCellStyle();
            titleStyle.setFont(titleFont);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);

            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());

            CellStyle headerStyle = workbook.createCellStyle();
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            CellStyle textStyle = workbook.createCellStyle();
            textStyle.setBorderBottom(BorderStyle.THIN);
            textStyle.setBorderTop(BorderStyle.THIN);
            textStyle.setBorderLeft(BorderStyle.THIN);
            textStyle.setBorderRight(BorderStyle.THIN);

            CellStyle centerStyle = workbook.createCellStyle();
            centerStyle.cloneStyleFrom(textStyle);
            centerStyle.setAlignment(HorizontalAlignment.CENTER);

            // Tiêu đề
            Row r0 = sheet.createRow(0);
            r0.createCell(0).setCellValue("TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI - PHÒNG ĐÀO TẠO");
            Row r1 = sheet.createRow(1);
            r1.createCell(0).setCellValue("BẢNG ĐIỂM HỌC PHẦN THEO LỚP CHUYÊN NGÀNH");
            r1.getCell(0).setCellStyle(titleStyle);

            Row r3 = sheet.createRow(3);
            r3.createCell(0).setCellValue("Khoa: " + (facultyName != null ? facultyName : ""));
            r3.createCell(3).setCellValue("Lớp: " + className + " (" + classId + ")");

            Row r4 = sheet.createRow(4);
            r4.createCell(0).setCellValue("Môn học: " + (subjectName != null ? subjectName : ""));
            r4.createCell(3).setCellValue("Tổng sinh viên: " + grades.size());

            // Header bảng
            Row r6 = sheet.createRow(6);
            String[] headers = {"STT", "Mã SV", "Họ và tên", "Chuyên cần (10%)", "Giữa kỳ (30%)", "Thi cuối kỳ (60%)", 
                                "Điểm TK (Hệ 10)", "Điểm Chữ", "Điểm Hệ 4", "Kết quả", "Trạng thái"};
            for (int i = 0; i < headers.length; i++) {
                Cell c = r6.createCell(i);
                c.setCellValue(headers[i]);
                c.setCellStyle(headerStyle);
            }

            int rowIdx = 7;
            int stt = 1;
            for (Grade g : grades) {
                Row r = sheet.createRow(rowIdx++);
                r.createCell(0).setCellValue(stt++);
                r.getCell(0).setCellStyle(centerStyle);

                r.createCell(1).setCellValue(g.getStudentId());
                r.getCell(1).setCellStyle(centerStyle);

                r.createCell(2).setCellValue(g.getStudentName());
                r.getCell(2).setCellStyle(textStyle);

                if (g.getScoreAttendance() != null) r.createCell(3).setCellValue(g.getScoreAttendance()); else r.createCell(3).setCellValue("-");
                if (g.getScoreMidterm() != null) r.createCell(4).setCellValue(g.getScoreMidterm()); else r.createCell(4).setCellValue("-");
                if (g.getScoreFinal() != null) r.createCell(5).setCellValue(g.getScoreFinal()); else r.createCell(5).setCellValue("-");
                if (g.getScoreTotal10() != null) r.createCell(6).setCellValue(g.getScoreTotal10()); else r.createCell(6).setCellValue("-");

                r.createCell(7).setCellValue(g.getScoreLetter() != null ? g.getScoreLetter() : "-");
                if (g.getScoreScale4() != null) r.createCell(8).setCellValue(g.getScoreScale4()); else r.createCell(8).setCellValue("-");

                String kq = "DAT".equalsIgnoreCase(g.getResult()) ? "Đạt" : ("KHONG_DAT".equalsIgnoreCase(g.getResult()) ? "Học lại" : "-");
                r.createCell(9).setCellValue(kq);

                String tt = "PUBLISHED".equalsIgnoreCase(g.getGradeStatus()) ? "Đã công bố" : 
                            ("SUBMITTED".equalsIgnoreCase(g.getGradeStatus()) ? "Chờ duyệt" : 
                            ("DRAFT".equalsIgnoreCase(g.getGradeStatus()) ? "Bản nháp" : "Chưa có điểm"));
                r.createCell(10).setCellValue(tt);

                for (int c = 3; c <= 10; c++) {
                    r.getCell(c).setCellStyle(centerStyle);
                }
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(out);
        }
    }
}
