# -*- coding: utf-8 -*-
"""
Full report generator script for Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx
"""

import os
import sys
import docx
from docx.shared import Inches, Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

sys.stdout.reconfigure(encoding='utf-8')

NAVY = RGBColor(0, 51, 102)        # #003366 Academic UTC Navy
DARK_NAVY = RGBColor(0, 34, 68)   # #002244
RED_ACCENT = RGBColor(180, 20, 20)# Crimson Red
DARK_GRAY = RGBColor(40, 40, 40)   # #282828 Body text
BORDER_GRAY = "D0D7DE"
LIGHT_BLUE_BG = "F0F4F8"
LIGHT_GRAY_BG = "F8F9FA"
HEADER_BG = "003366"
ZEBRA_BG = "F8FAFC"
WHITE_BG = "FFFFFF"

def set_cell_background(cell, hex_color):
    tcPr = cell._tc.get_or_add_tcPr()
    for shd in tcPr.findall(qn('w:shd')):
        tcPr.remove(shd)
    shading = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    tcPr.append(shading)

def set_cell_margins(cell, top=120, bottom=120, left=180, right=180):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = parse_xml(f'''
        <w:tcMar {nsdecls("w")}>
            <w:top w:w="{top}" w:type="dxa"/>
            <w:bottom w:w="{bottom}" w:type="dxa"/>
            <w:left w:w="{left}" w:type="dxa"/>
            <w:right w:w="{right}" w:type="dxa"/>
        </w:tcMar>
    ''')
    tcPr.append(tcMar)

def set_callout_border(cell, border_color="003366", border_size="36"):
    tcPr = cell._tc.get_or_add_tcPr()
    tcBorders = parse_xml(f'''
        <w:tcBorders {nsdecls("w")}>
            <w:top w:val="single" w:sz="4" w:space="0" w:color="D0D7DE"/>
            <w:left w:val="single" w:sz="{border_size}" w:space="0" w:color="{border_color}"/>
            <w:bottom w:val="single" w:sz="4" w:space="0" w:color="D0D7DE"/>
            <w:right w:val="single" w:sz="4" w:space="0" w:color="D0D7DE"/>
        </w:tcBorders>
    ''')
    tcPr.append(tcBorders)

def set_code_border(cell):
    tcPr = cell._tc.get_or_add_tcPr()
    tcBorders = parse_xml(f'''
        <w:tcBorders {nsdecls("w")}>
            <w:top w:val="single" w:sz="6" w:space="0" w:color="D0D7DE"/>
            <w:left w:val="single" w:sz="6" w:space="0" w:color="D0D7DE"/>
            <w:bottom w:val="single" w:sz="6" w:space="0" w:color="D0D7DE"/>
            <w:right w:val="single" w:sz="6" w:space="0" w:color="D0D7DE"/>
        </w:tcBorders>
    ''')
    tcPr.append(tcBorders)

def add_callout(doc, title, paragraphs_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    set_cell_background(cell, LIGHT_BLUE_BG)
    set_callout_border(cell, "003366", "36")
    set_cell_margins(cell, top=140, bottom=140, left=220, right=200)

    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(4)
    run_icon = p.add_run(f"📌 {title}")
    run_icon.bold = True
    run_icon.font.size = Pt(11.5)
    run_icon.font.name = "Times New Roman"
    run_icon.font.color.rgb = NAVY

    for item in paragraphs_text:
        p2 = cell.add_paragraph()
        p2.paragraph_format.space_before = Pt(1)
        p2.paragraph_format.space_after = Pt(3)
        p2.paragraph_format.line_spacing = 1.2
        r = p2.add_run(item)
        r.font.size = Pt(10.5)
        r.font.name = "Times New Roman"
        r.font.color.rgb = DARK_GRAY

    doc.add_paragraph().paragraph_format.space_after = Pt(4)

def add_code_block(doc, code_str, caption=None):
    if caption:
        p_cap = doc.add_paragraph()
        p_cap.paragraph_format.space_before = Pt(6)
        p_cap.paragraph_format.space_after = Pt(3)
        p_cap.paragraph_format.keep_with_next = True
        r_cap = p_cap.add_run(f"Đoạn mã: {caption}")
        r_cap.font.name = "Times New Roman"
        r_cap.font.size = Pt(10.5)
        r_cap.italic = True
        r_cap.bold = True
        r_cap.font.color.rgb = NAVY

    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    set_cell_background(cell, LIGHT_GRAY_BG)
    set_code_border(cell)
    set_cell_margins(cell, top=120, bottom=120, left=180, right=160)

    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.line_spacing = 1.15
    run = p.add_run(code_str.strip())
    run.font.name = "Consolas"
    run.font.size = Pt(9.0)
    run.font.color.rgb = RGBColor(30, 30, 30)

    p_post = doc.add_paragraph()
    p_post.paragraph_format.space_before = Pt(0)
    p_post.paragraph_format.space_after = Pt(4)

def add_diagram_box(doc, ascii_str, caption):
    p_cap = doc.add_paragraph()
    p_cap.paragraph_format.space_before = Pt(8)
    p_cap.paragraph_format.space_after = Pt(3)
    p_cap.paragraph_format.keep_with_next = True
    r_cap = p_cap.add_run(f"Sơ đồ minh họa: {caption}")
    r_cap.font.name = "Times New Roman"
    r_cap.font.size = Pt(10.5)
    r_cap.italic = True
    r_cap.bold = True
    r_cap.font.color.rgb = NAVY

    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    set_cell_background(cell, "F4F6F9")
    set_code_border(cell)
    set_cell_margins(cell, top=130, bottom=130, left=180, right=160)

    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.line_spacing = 1.05
    run = p.add_run(ascii_str.strip())
    run.font.name = "Consolas"
    run.font.size = Pt(8.0)
    run.font.color.rgb = RGBColor(20, 30, 45)

    p_post = doc.add_paragraph()
    p_post.paragraph_format.space_before = Pt(0)
    p_post.paragraph_format.space_after = Pt(4)

def format_table(table, col_widths, col_alignments):
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    tblPr = table._tbl.tblPr
    tblBorders = parse_xml(f'''
        <w:tblBorders {nsdecls("w")}>
            <w:top w:val="single" w:sz="6" w:space="0" w:color="{BORDER_GRAY}"/>
            <w:left w:val="none"/>
            <w:bottom w:val="single" w:sz="8" w:space="0" w:color="003366"/>
            <w:right w:val="none"/>
            <w:insideH w:val="single" w:sz="4" w:space="0" w:color="{BORDER_GRAY}"/>
            <w:insideV w:val="none"/>
        </w:tblBorders>
    ''')
    tblPr.append(tblBorders)

    for i, row in enumerate(table.rows):
        trPr = row._tr.get_or_add_trPr()
        trPr.append(parse_xml(f'<w:cantSplit {nsdecls("w")}/>'))
        is_header = (i == 0)
        if is_header:
            trPr.append(parse_xml(f'<w:tblHeader {nsdecls("w")}/>'))

        bg_color = HEADER_BG if is_header else (ZEBRA_BG if i % 2 == 1 else WHITE_BG)

        for j, cell in enumerate(row.cells):
            cell.width = col_widths[j]
            set_cell_background(cell, bg_color)
            set_cell_margins(cell, top=80 if not is_header else 110,
                                   bottom=80 if not is_header else 110,
                                   left=110, right=110)
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER

            for p in cell.paragraphs:
                p.alignment = col_alignments[j]
                p.paragraph_format.space_before = Pt(1)
                p.paragraph_format.space_after = Pt(1)
                p.paragraph_format.line_spacing = 1.15
                for run in p.runs:
                    run.font.name = "Times New Roman"
                    if is_header:
                        run.font.size = Pt(10)
                        run.bold = True
                        run.font.color.rgb = RGBColor(255, 255, 255)
                    else:
                        run.font.size = Pt(9.5)
                        run.font.color.rgb = DARK_GRAY

def add_heading_1(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(18)
    p.paragraph_format.space_after = Pt(6)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Times New Roman"
    run.font.size = Pt(14)
    run.bold = True
    run.font.color.rgb = NAVY
    return p

def add_heading_2(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(12)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Times New Roman"
    run.font.size = Pt(13)
    run.bold = True
    run.font.color.rgb = NAVY
    return p

def add_heading_3(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(8)
    p.paragraph_format.space_after = Pt(2)
    p.paragraph_format.keep_with_next = True
    run = p.add_run(text)
    run.font.name = "Times New Roman"
    run.font.size = Pt(12)
    run.bold = True
    run.italic = True
    run.font.color.rgb = NAVY
    return p

def add_p(doc, text, bold_prefix=None, italic=False, bullet=False):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(0)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.line_spacing = 1.25
    p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    if bullet:
        p.paragraph_format.left_indent = Cm(0.6)
        run_bullet = p.add_run("•  ")
        run_bullet.font.name = "Times New Roman"
        run_bullet.font.size = Pt(12)
        run_bullet.font.color.rgb = NAVY

    if bold_prefix:
        r_pre = p.add_run(bold_prefix)
        r_pre.font.name = "Times New Roman"
        r_pre.font.size = Pt(12)
        r_pre.bold = True
        r_pre.font.color.rgb = DARK_GRAY

    run = p.add_run(text)
    run.font.name = "Times New Roman"
    run.font.size = Pt(12)
    run.italic = italic
    run.font.color.rgb = DARK_GRAY
    return p

print("Loaded module successfully.")

def build_cover_and_intro(doc):
    # Setup page margins
    section = doc.sections[0]
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.top_margin = Cm(2.0)
    section.bottom_margin = Cm(2.0)
    section.left_margin = Cm(3.0)
    section.right_margin = Cm(2.0)

    # 1. TRANG BÌA
    p1 = doc.add_paragraph()
    p1.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p1.paragraph_format.space_before = Pt(0)
    p1.paragraph_format.space_after = Pt(2)
    r1 = p1.add_run("BỘ GIÁO DỤC VÀ ĐÀO TẠO\nTRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI")
    r1.font.name = "Times New Roman"
    r1.font.size = Pt(13)
    r1.bold = True
    r1.font.color.rgb = DARK_NAVY

    p2 = doc.add_paragraph()
    p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p2.paragraph_format.space_before = Pt(2)
    p2.paragraph_format.space_after = Pt(12)
    r2 = p2.add_run("KHOA CÔNG NGHỆ THÔNG TIN - BỘ MÔN CÔNG NGHỆ PHẦN MỀM\n-------------------***-------------------")
    r2.font.name = "Times New Roman"
    r2.font.size = Pt(12)
    r2.bold = True
    r2.font.color.rgb = NAVY

    # UTC Logo
    logo_path = "src/main/webapp/assets/images/utc-logo.png"
    if os.path.exists(logo_path):
        p_logo = doc.add_paragraph()
        p_logo.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_logo.paragraph_format.space_before = Pt(6)
        p_logo.paragraph_format.space_after = Pt(12)
        p_logo.add_run().add_picture(logo_path, width=Inches(1.8))

    p3 = doc.add_paragraph()
    p3.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p3.paragraph_format.space_before = Pt(8)
    p3.paragraph_format.space_after = Pt(6)
    r3 = p3.add_run("BÁO CÁO BÀI TẬP NHÓM")
    r3.font.name = "Times New Roman"
    r3.font.size = Pt(20)
    r3.bold = True
    r3.font.color.rgb = RED_ACCENT

    p4 = doc.add_paragraph()
    p4.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p4.paragraph_format.space_before = Pt(0)
    p4.paragraph_format.space_after = Pt(10)
    r4 = p4.add_run("HỌC PHẦN: CÔNG NGHỆ JAVA")
    r4.font.name = "Times New Roman"
    r4.font.size = Pt(15)
    r4.bold = True
    r4.font.color.rgb = NAVY

    p5 = doc.add_paragraph()
    p5.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p5.paragraph_format.space_before = Pt(6)
    p5.paragraph_format.space_after = Pt(18)
    r5 = p5.add_run("ĐỀ TÀI:\nXÂY DỰNG HỆ THỐNG QUẢN LÝ ĐIỂM SINH VIÊN THEO HỌC CHẾ TÍN CHỈ\nTRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI (UTC)")
    r5.font.name = "Times New Roman"
    r5.font.size = Pt(15)
    r5.bold = True
    r5.font.color.rgb = DARK_NAVY

    # Metadata block
    p_meta = doc.add_paragraph()
    p_meta.paragraph_format.left_indent = Cm(3.0)
    p_meta.paragraph_format.space_before = Pt(10)
    p_meta.paragraph_format.space_after = Pt(12)
    p_meta.paragraph_format.line_spacing = 1.3
    
    runs_meta = [
        ("Giảng viên hướng dẫn: ", True), ("TS. Nguyễn Văn Hướng\n", False),
        ("Lớp học phần:          ", True), ("Công nghệ Java - Nhóm 02\n", False),
        ("Nhóm sinh viên:        ", True), ("Nhóm 05\n", False),
        ("Lớp chuyên ngành:      ", True), ("Công nghệ Thông tin 1 - K62\n", False),
        ("Cơ sở đào tạo:         ", True), ("Trường Đại học Giao thông Vận tải (Hà Nội)\n", False),
    ]
    for m_text, m_bold in runs_meta:
        rm = p_meta.add_run(m_text)
        rm.font.name = "Times New Roman"
        rm.font.size = Pt(12)
        rm.bold = m_bold
        rm.font.color.rgb = DARK_GRAY

    # Footer date
    p_foot = doc.add_paragraph()
    p_foot.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_foot.paragraph_format.space_before = Pt(18)
    p_foot.paragraph_format.space_after = Pt(8)
    r_foot = p_foot.add_run("HÀ NỘI - NĂM 2026")
    r_foot.font.name = "Times New Roman"
    r_foot.font.size = Pt(12.5)
    r_foot.bold = True
    r_foot.font.color.rgb = NAVY

    # Bảng phân công nhiệm vụ thành viên
    p_team_title = doc.add_paragraph()
    p_team_title.paragraph_format.space_before = Pt(12)
    p_team_title.paragraph_format.space_after = Pt(4)
    r_tt = p_team_title.add_run("BẢNG PHÂN CÔNG NHIỆM VỤ THÀNH VIÊN TRONG NHÓM")
    r_tt.font.name = "Times New Roman"
    r_tt.font.size = Pt(12)
    r_tt.bold = True
    r_tt.font.color.rgb = NAVY

    team_data = [
        ["STT", "Họ và tên", "Mã sinh viên", "Nhiệm vụ phân công", "Đánh giá"],
        ["1", "Nguyễn Hoàng Nam", "211200001", "Trưởng nhóm, Thiết kế kiến trúc MVC, CSDL Oracle 23ai, DBConnection, GradeDAO", "100% (Hoàn thành Xuất sắc)"],
        ["2", "Trần Thị Mai", "211200002", "Xây dựng các Servlet Controller, Bộ lọc phân quyền AuthFilter (RBAC), Quản lý tài khoản", "100% (Hoàn thành Xuất sắc)"],
        ["3", "Lê Văn Đức", "211200003", "Phát triển các DAO, PreparedStatement, SQL Transaction, Nhật ký sửa điểm Audit Log", "100% (Hoàn thành Xuất sắc)"],
        ["4", "Phạm Minh Tuấn", "211200004", "Thiết kế giao diện JSP/JSTL, Tailwind/Bootstrap UI, Xử lý Apache POI Excel, Viết Test Cases", "100% (Hoàn thành Xuất sắc)"]
    ]
    t_team = doc.add_table(rows=len(team_data), cols=5)
    for r_i, r_data in enumerate(team_data):
        for c_i, c_val in enumerate(r_data):
            t_team.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_team, [Cm(1.2), Cm(3.8), Cm(2.4), Cm(6.2), Cm(2.4)],
                 [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER])

    # End of Page 1 -> Page Break
    doc.add_page_break()

    # 2. MỤC LỤC
    p_toc = doc.add_paragraph()
    p_toc.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_toc.paragraph_format.space_before = Pt(6)
    p_toc.paragraph_format.space_after = Pt(14)
    r_toc = p_toc.add_run("MỤC LỤC TỔNG THỂ BÁO CÁO")
    r_toc.font.name = "Times New Roman"
    r_toc.font.size = Pt(16)
    r_toc.bold = True
    r_toc.font.color.rgb = NAVY

    toc_data = [
        ["NỘI DUNG BÁO CÁO", "TRANG"],
        ["PHẦN MỞ ĐẦU: TRANG BÌA & BẢNG PHÂN CÔNG NHIỆM VỤ", "1"],
        ["MỤC LỤC TỔNG THỂ BÁO CÁO", "2"],
        ["LỜI NÓI ĐẦU / LỜI CẢM ƠN", "3"],
        ["CHƯƠNG 1: KHẢO SÁT BÀI TOÁN VÀ PHÂN TÍCH YÊU CẦU", "4"],
        ["   1.1. Khảo sát hiện trạng và mô tả bài toán quản lý điểm tín chỉ UTC", "4"],
        ["        1.1.1. Bối cảnh và khó khăn khi quản lý điểm thủ công bằng Excel", "4"],
        ["        1.1.2. Mục tiêu xây dựng phần mềm Quản lý điểm UTC", "5"],
        ["        1.1.3. Liệt kê các đối tượng quản lý chính trong hệ thống", "5"],
        ["   1.2. Phân tích yêu cầu chức năng (Mô tả chi tiết từng Use Case)", "6"],
        ["        1.2.1. Biểu đồ Use Case tổng quát và phân rã các tác nhân", "6"],
        ["        1.2.2. Nhóm chức năng Quản lý hệ thống và Xác thực phân quyền", "7"],
        ["        1.2.3. Nhóm chức năng Quản lý danh mục đào tạo", "7"],
        ["        1.2.4. Nhóm chức năng Quản lý điểm số và Quy trình xét duyệt điểm", "8"],
        ["        1.2.5. Nhóm chức năng Tra cứu, Tìm kiếm và Cảnh báo học vụ", "8"],
        ["   1.3. Phân tích yêu cầu phi chức năng và công nghệ áp dụng", "9"],
        ["        1.3.1. Yêu cầu tính toàn vẹn dữ liệu và kiểm tra hợp lệ (Validation)", "9"],
        ["        1.3.2. Xử lý ngoại lệ, An toàn giao dịch SQL và Chống lỗ hổng bảo mật", "10"],
        ["        1.3.3. Công nghệ sử dụng: Java Web MVC, Oracle DB 23ai, Apache POI", "10"],
        ["CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG", "11"],
        ["   2.1. Thiết kế cơ sở dữ liệu (Database Design)", "11"],
        ["        2.1.1. Lược đồ quan hệ thực thể (ERD) hệ thống Oracle Database 23ai", "11"],
        ["        2.1.2. Đặc tả từ điển dữ liệu chi tiết các bảng trong CSDL", "12"],
        ["   2.2. Thiết kế kiến trúc phần mềm (Software Architecture)", "15"],
        ["        2.2.1. Áp dụng mô hình kiến trúc MVC trên nền Java Web Servlet/JSP", "15"],
        ["        2.2.2. Sơ đồ chu trình xử lý Request/Response và Nhiệm vụ các Package", "16"],
        ["CHƯƠNG 3: TRIỂN KHAI XÂY DỰNG CHƯƠNG TRÌNH", "17"],
        ["   3.1. Cấu trúc Project chuẩn Maven trên môi trường phát triển IDE", "17"],
        ["   3.2. Triển khai lớp kết nối và xử lý dữ liệu (DAO & PreparedStatement)", "18"],
        ["        3.2.1. Triển khai lớp DBConnection nạp cấu hình và quản lý tài nguyên", "18"],
        ["        3.2.2. Triển khai PreparedStatement và Quản lý Transaction an toàn", "19"],
        ["        3.2.3. Triển khai thuật toán quy đổi điểm GradeCalculator chuẩn UTC", "20"],
        ["        3.2.4. Triển khai xử lý file Excel bằng Apache POI trong ExcelService", "21"],
        ["   3.3. Áp dụng chuẩn lập trình Java và Nguyên tắc tách biệt trách nhiệm", "21"],
        ["CHƯƠNG 4: GIAO DIỆN VÀ KIỂM THỬ", "22"],
        ["   4.1. Kết quả thiết kế giao diện người dùng (User Interface)", "22"],
        ["        4.1.1. Màn hình Đăng nhập hiện đại, Đăng nhập 1 chạm & Thông báo lỗi", "22"],
        ["        4.1.2. Màn hình Bảng điều khiển Quản trị viên (Admin Dashboard)", "23"],
        ["        4.1.3. Màn hình Quản lý & Nhập điểm học phần trực quan của Giảng viên", "23"],
        ["        4.1.4. Modal xác nhận thao tác an toàn (Confirmation Dialog)", "24"],
        ["        4.1.5. Màn hình Tra cứu điểm sinh viên, Cảnh báo học vụ & In phiếu điểm A4", "24"],
        ["   4.2. Kiểm thử phần mềm (Testing)", "25"],
        ["        4.2.1. Phương pháp kiểm thử hộp đen và Kiểm tra tính hợp lệ dữ liệu", "25"],
        ["        4.2.2. Bảng Kịch bản kiểm thử (Test Cases) chi tiết và Kết quả thực tế", "26"],
        ["KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN", "27"],
        ["   1. Kết quả đạt được của đề tài", "27"],
        ["   2. Những mặt hạn chế còn tồn đọng", "27"],
        ["   3. Hướng nghiên cứu và phát triển trong tương lai", "28"],
        ["TÀI LIỆU THAM KHẢO", "29"]
    ]

    t_toc = doc.add_table(rows=len(toc_data), cols=2)
    for r_i, r_data in enumerate(toc_data):
        for c_i, c_val in enumerate(r_data):
            t_toc.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_toc, [Cm(14.0), Cm(2.0)], [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER])

    # End of Page 2 -> Page Break
    doc.add_page_break()

    # 3. LỜI NÓI ĐẦU / CẢM ƠN
    p_pref = doc.add_paragraph()
    p_pref.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p_pref.paragraph_format.space_before = Pt(6)
    p_pref.paragraph_format.space_after = Pt(14)
    r_pref = p_pref.add_run("LỜI NÓI ĐẦU VÀ LỜI CẢM ƠN")
    r_pref.font.name = "Times New Roman"
    r_pref.font.size = Pt(16)
    r_pref.bold = True
    r_pref.font.color.rgb = NAVY

    add_p(doc, "Trong thời đại chuyển đổi số mạnh mẽ của nền giáo dục đại học, việc ứng dụng các giải pháp công nghệ thông tin tiên tiến nhằm nâng cao chất lượng và tính minh bạch trong công tác quản lý đào tạo là một đòi hỏi vô cùng cấp thiết. Tại Trường Đại học Giao thông Vận tải (UTC), công tác quản lý điểm sinh viên theo học chế tín chỉ có quy mô rất lớn, đòi hỏi quy trình xử lý dữ liệu phức tạp, độ chính xác tuyệt đối, khả năng bảo mật cao và truy xuất lịch sử rõ ràng theo đúng Quy chế đào tạo đại học hiện hành.")
    add_p(doc, "Xuất phát từ yêu cầu thực tiễn đó, trong khuôn khổ học phần Công nghệ Java, nhóm sinh viên chúng em đã tiến hành nghiên cứu, phân tích và xây dựng hệ thống phần mềm: 'Xây dựng Hệ thống Quản lý Điểm Sinh viên theo Học chế Tín chỉ Trường Đại học Giao thông Vận tải (UTC)'. Hệ thống được phát triển hoàn toàn trên nền tảng ứng dụng Web Java tiêu chuẩn doanh nghiệp (Java EE / Jakarta Servlet, JSP, JSTL) kết hợp kiến trúc phân lớp MVC (Model - View - Controller), giao tiếp cơ sở dữ liệu Oracle Database 23ai Free qua trình điều khiển JDBC Thin Driver và tích hợp thư viện Apache POI để xử lý bảng tính Excel chuẩn UTC.")
    add_p(doc, "Để hoàn thành đề tài bài tập nhóm này một cách trọn vẹn và đạt chất lượng tốt nhất, nhóm chúng em xin được bày tỏ lòng biết ơn sâu sắc và chân thành nhất tới:")
    add_p(doc, "Ban Giám hiệu Trường Đại học Giao thông Vận tải cùng Ban Chủ nhiệm Khoa Công nghệ Thông tin đã tạo điều kiện học tập thuận lợi, trang bị hệ thống phòng thực hành máy tính và tài nguyên học liệu số hiện đại cho sinh viên.", bullet=True)
    add_p(doc, "Các Thầy, Cô giáo trong Bộ môn Công nghệ Phần mềm đã nhiệt tình truyền đạt cho chúng em những nền tảng kiến thức vững chắc về lập trình Java nâng cao, kiến trúc phần mềm, nguyên lý cơ sở dữ liệu quan hệ và kỹ năng làm việc nhóm.", bullet=True)
    add_p(doc, "Đặc biệt, nhóm chúng em xin gửi lời cảm ơn sâu sắc nhất tới Thầy giáo hướng dẫn giảng dạy học phần Công nghệ Java. Thầy đã luôn tận tâm theo sát, định hướng chuyên môn, gợi mở phương pháp giải quyết các bài toán kỹ thuật phức tạp và đưa ra những đóng góp quý báu giúp chúng em hoàn thiện sản phẩm phần mềm đúng chuẩn kỹ thuật.", bullet=True)
    add_p(doc, "Dù nhóm đã đầu tư rất nhiều thời gian, công sức và tinh thần trách nhiệm để xây dựng hệ thống một cách chỉn chu nhất, song do kiến thức và kinh nghiệm thực tế còn hạn chế nên bài báo cáo cũng như phần mềm khó tránh khỏi những thiếu sót nhất định. Nhóm chúng em rất mong nhận được những nhận xét, góp ý và chỉ dẫn quý báu từ quý Thầy/Cô và Hội đồng đánh giá để sản phẩm tiếp tục được hoàn thiện và phát triển hơn nữa.")
    add_p(doc, "Chúng em xin chân thành cảm ơn!")

    p_sig = doc.add_paragraph()
    p_sig.paragraph_format.left_indent = Cm(9.5)
    p_sig.paragraph_format.space_before = Pt(16)
    p_sig.paragraph_format.space_after = Pt(2)
    r_sig1 = p_sig.add_run("Hà Nội, ngày 04 tháng 11 năm 2026\n")
    r_sig1.italic = True
    r_sig1.font.name = "Times New Roman"
    r_sig1.font.size = Pt(11.5)
    r_sig2 = p_sig.add_run("Đại diện Nhóm sinh viên thực hiện\n")
    r_sig2.bold = True
    r_sig2.font.name = "Times New Roman"
    r_sig2.font.size = Pt(12)
    r_sig3 = p_sig.add_run("Nguyễn Hoàng Nam (Trưởng nhóm)")
    r_sig3.font.name = "Times New Roman"
    r_sig3.font.size = Pt(12)
    r_sig3.bold = True
    r_sig3.font.color.rgb = NAVY

    # End of Page 3 -> Page Break
    doc.add_page_break()

print("Appended cover and intro successfully.")

def build_chapter_1(doc):
    # CHƯƠNG 1
    add_heading_1(doc, "CHƯƠNG 1: KHẢO SÁT BÀI TOÁN VÀ PHÂN TÍCH YÊU CẦU")
    
    add_callout(doc, "TỔNG QUAN NỘI DUNG CHƯƠNG 1", [
        "Chương 1 tập trung khảo sát hiện trạng nghiệp vụ quản lý điểm tại Trường Đại học Giao thông Vận tải (UTC), phân tích những bất cập của phương pháp thủ công và xác định mục tiêu xây dựng phần mềm.",
        "Phân tích chi tiết yêu cầu chức năng thông qua các biểu đồ Use Case tổng quát và Use Case phân rã của 3 tác nhân: Quản trị viên (Admin - Phòng Đào tạo), Giảng viên và Sinh viên.",
        "Xác lập các yêu cầu phi chức năng khắt khe: Toàn vẹn dữ liệu, kiểm tra hợp lệ (Validation đa tầng), xử lý ngoại lệ an toàn, chống tấn công SQL Injection và định hình nền tảng công nghệ Java Web Servlet/JSP kết nối Oracle Database 23ai."
    ])

    # 1.1
    add_heading_2(doc, "1.1. Khảo sát hiện trạng và mô tả bài toán")
    
    add_heading_3(doc, "1.1.1. Bối cảnh và khó khăn khi quản lý điểm thủ công bằng Excel")
    add_p(doc, "Trường Đại học Giao thông Vận tải là một trong những trường đại học kỹ thuật trọng điểm hàng đầu của cả nước, áp dụng triệt để quy chế đào tạo đại học theo hệ thống tín chỉ. Với quy mô đào tạo trên 30.000 sinh viên, hàng trăm chuyên ngành và hàng ngàn lớp học phần được tổ chức giảng dạy trong mỗi năm học, khối lượng dữ liệu điểm số phát sinh là vô cùng lớn và có tính biến động cao.")
    add_p(doc, "Trước đây, tại nhiều khoa và bộ môn, công tác tổng hợp và quản lý điểm thi vẫn phụ thuộc một phần vào các bảng tính Microsoft Excel rời rạc được lưu trữ cục bộ trên máy tính cá nhân của giảng viên hoặc cán bộ quản lý. Thực trạng này đã bộc lộ nhiều khó khăn, bất cập nghiêm trọng:")
    add_p(doc, "Nguy cơ sai lệch và thất lạc dữ liệu: Việc lưu trữ phân tán khiến dữ liệu điểm dễ bị ghi đè, nhầm lẫn các phiên bản (version), thậm chí mất trắng khi xảy ra sự cố hỏng hóc phần cứng hoặc nhiễm mã độc trên máy tính cá nhân.", bullet=True)
    add_p(doc, "Sai sót trong quá trình tính toán và quy đổi điểm: Công thức tính điểm tổng kết học phần, quy đổi từ thang điểm 10 sang thang điểm chữ (A+, A, B+, B, C+, C, D+, D, F+, F) và thang điểm 4 theo Quy chế đào tạo tín chỉ UTC rất phức tạp, đặc biệt là quy định về điểm liệt khi thi kết thúc học phần dưới 4.0. Việc tính toán thủ công rất dễ xảy ra nhầm lẫn.", bullet=True)
    add_p(doc, "Thiếu tính bảo mật và không có cơ chế kiểm toán (Audit Log): Các file Excel không có cơ chế phân quyền truy cập chặt chẽ, không thể ghi nhận ai đã sửa điểm, sửa vào thời gian nào và lý do sửa là gì. Điều này tiềm ẩn nguy cơ tiêu cực và gây khó khăn cho công tác thanh tra, hậu kiểm.", bullet=True)
    add_p(doc, "Chậm trễ trong thông báo và cảnh báo học vụ: Sinh viên không thể tra cứu điểm thi kịp thời để lên kế hoạch học tập hoặc nộp đơn thắc mắc. Phòng Đào tạo mất nhiều tuần để tổng hợp CPA toàn khóa nhằm phát hiện các trường hợp sinh viên bị cảnh báo học tập hoặc có nguy cơ buộc thôi học.", bullet=True)

    add_heading_3(doc, "1.1.2. Mục tiêu xây dựng phần mềm Quản lý điểm UTC")
    add_p(doc, "Để khắc phục triệt để các hạn chế nêu trên, việc xây dựng một hệ thống phần mềm Quản lý điểm sinh viên trực tuyến theo kiến trúc tập trung, bảo mật và chuẩn hóa theo quy chế của Trường Đại học Giao thông Vận tải là yêu cầu cấp thiết. Mục tiêu cụ thể của đề tài bao gồm:")
    add_p(doc, "Tự động hóa toàn diện quy trình nhập điểm: Cung cấp cho giảng viên giao diện Web nhập điểm trực quan, hỗ trợ tính toán điểm tổng kết theo trọng số chuyên cần, giữa kỳ, thi kết thúc học phần và tự động quy đổi điểm chữ, điểm hệ 4 tức thời theo thời gian thực.", bullet=True)
    add_p(doc, "Chuẩn hóa quy trình xét duyệt điểm chặt chẽ: Thiết lập luồng trạng thái nộp điểm rõ ràng giữa Giảng viên và Phòng Đào tạo (Bản nháp -> Chờ phê duyệt -> Đã công bố), ngăn chặn việc tùy tiện sửa điểm khi chưa được cấp thẩm quyền cho phép.", bullet=True)
    add_p(doc, "Lưu vết kiểm toán lịch sử sửa điểm (Audit Trails): Mọi thao tác cập nhật, điều chỉnh điểm số sau khi đã công bố đều bắt buộc phải ghi rõ lý do và tự động lưu vào bảng nhật ký lịch sử phục vụ công tác thanh tra, hậu kiểm của Nhà trường.", bullet=True)
    add_p(doc, "Hỗ trợ Import / Export Excel thông minh: Cho phép giảng viên xuất mẫu sổ điểm lớp học phần và nhập dữ liệu điểm từ tệp Excel (.xlsx) chuẩn UTC thông qua thư viện Apache POI, giúp tiết kiệm thời gian vào điểm cho các lớp đông sinh viên.", bullet=True)
    add_p(doc, "Tra cứu điểm và tự động cảnh báo học vụ: Sinh viên có thể tra cứu chi tiết kết quả học tập mọi lúc mọi nơi; hệ thống tự động tính điểm trung bình học kỳ (GPA), điểm tích lũy toàn khóa (CPA) và tự động nhận diện, lập danh sách cảnh báo sinh viên có CPA dưới 1.00.", bullet=True)
    add_p(doc, "In ấn phiếu điểm chuẩn hóa A4: Cung cấp tính năng in bảng điểm học kỳ trực tiếp trên trình duyệt theo đúng quy cách mẫu in văn bản hành chính của Trường Đại học Giao thông Vận tải.", bullet=True)

    add_heading_3(doc, "1.1.3. Liệt kê các đối tượng quản lý chính trong hệ thống")
    add_p(doc, "Hệ thống Quản lý điểm UTC được thiết kế xoay quanh 5 nhóm đối tượng quản lý cốt lõi, phản ánh chính xác cấu trúc dữ liệu đào tạo đại học:")
    add_p(doc, "Đối tượng Tài khoản (TAI_KHOAN): Quản lý thông tin định danh người dùng trong hệ thống (Tên đăng nhập, Mật khẩu đã băm bằng thuật toán an toàn BCrypt, Vai trò người dùng gồm ADMIN, GIANG_VIEN, SINH_VIEN, và Trạng thái kích hoạt).", bullet=True)
    add_p(doc, "Đối tượng Sinh viên (SINH_VIEN): Quản lý hồ sơ học vụ của sinh viên bao gồm Mã sinh viên (Khóa chính), Họ và tên, Ngày sinh, Giới tính, Quê quán, Lớp chuyên ngành trực thuộc và liên kết khóa ngoại với tài khoản người dùng.", bullet=True)
    add_p(doc, "Đối tượng Giảng viên (GIANG_VIEN): Quản lý thông tin cán bộ giảng dạy gồm Mã giảng viên, Họ và tên, Học hàm, Học vị, Email công vụ, Khoa chuyên môn và tài khoản đăng nhập.", bullet=True)
    add_p(doc, "Đối tượng Môn học & Lớp học phần (MON_HOC, LOP_HOC_PHAN): Quản lý danh mục học phần đào tạo (Mã môn, Tên môn, Số tín chỉ, Tỷ lệ phần trăm trọng số điểm Chuyên cần, Giữa kỳ, Thi cuối kỳ) và các lớp học phần cụ thể được mở trong từng học kỳ do giảng viên phụ trách giảng dạy.", bullet=True)
    add_p(doc, "Đối tượng Kết quả học tập & Nhật ký kiểm toán (BANG_DIEM, LICHSU_SUA_DIEM): Quản lý bảng điểm chi tiết của từng sinh viên theo lớp học phần (Điểm chuyên cần, điểm giữa kỳ, điểm thi cuối kỳ, điểm tổng kết hệ 10, điểm chữ, điểm hệ 4 và trạng thái duyệt điểm); đồng thời lưu trữ toàn bộ lịch sử các lần hiệu chỉnh điểm thi phục vụ công tác thanh tra học vụ.", bullet=True)

    # 1.2
    add_heading_2(doc, "1.2. Phân tích yêu cầu chức năng (Mô tả chi tiết từng Use Case)")
    
    add_heading_3(doc, "1.2.1. Biểu đồ Use Case tổng quát và phân rã các tác nhân")
    add_p(doc, "Hệ thống Quản lý điểm UTC bao gồm 3 tác nhân người dùng (Actors) chính tham gia vào các quy trình nghiệp vụ:")
    add_p(doc, "Quản trị viên / Phòng Đào tạo (Admin): Có quyền hạn cao nhất trong hệ thống, chịu trách nhiệm quản lý danh mục đào tạo (Khoa, Ngành, Lớp chuyên ngành, Môn học, Lớp học phần, Sinh viên, Giảng viên), thực hiện phê duyệt bảng điểm học phần, xem thống kê phổ điểm toàn trường và tra cứu nhật ký kiểm toán sửa điểm.", bullet=True)
    add_p(doc, "Giảng viên (Lecturer): Được phân quyền quản lý các lớp học phần được phân công giảng dạy; nhập, hiệu chỉnh và xóa điểm thi của sinh viên; xuất/nhập bảng điểm qua file Excel (.xlsx) và gửi bảng điểm lên Phòng Đào tạo để đề nghị phê duyệt công bố.", bullet=True)
    add_p(doc, "Sinh viên (Student): Được phân quyền tra cứu thông tin học vụ cá nhân, xem bảng điểm chi tiết từng học kỳ, theo dõi điểm GPA học kỳ và CPA tích lũy toàn khóa, kiểm tra thông báo cảnh báo học vụ và thực hiện in phiếu điểm học kỳ trực tiếp định dạng chuẩn A4.", bullet=True)

    uc_ascii = """+-------------------------------------------------------------------------------------------------+
|               HỆ THỐNG QUẢN LÝ ĐIỂM UTC - MÔ HÌNH PHÂN QUYỀN VAI TRÒ (RBAC)                     |
+-------------------------------------------------------------------------------------------------+
          |
  [ SINH VIÊN ] ------------> (Đăng nhập hệ thống / Đổi mật khẩu)
          |                -> (Tra cứu bảng điểm học kỳ & điểm chi tiết CC, GK, Thi)
          |                -> (Xem kết quả GPA học kỳ & CPA tích lũy toàn khóa)
          |                -> (In phiếu điểm học kỳ trực tiếp định dạng A4 chuẩn UTC)
          |
  [ GIẢNG VIÊN ] -----------> (Đăng nhập hệ thống / Đổi mật khẩu)
          |                -> (Xem danh sách các lớp học phần được phân công giảng dạy)
          |                -> (Nhập & Hiệu chỉnh trực tiếp điểm Chuyên cần, Giữa kỳ, Cuối kỳ)
          |                -> (Import danh sách điểm tự động từ tệp Excel .xlsx qua Apache POI)
          |                -> (Export sổ điểm lớp học phần ra tệp Excel chuẩn UTC)
          |                -> (Gửi bảng điểm lên Phòng Đào tạo đề nghị phê duyệt)
          |
  [ PHÒNG ĐÀO TẠO (ADMIN) ] -> (Quản lý Lớp chuyên ngành & Danh sách sinh viên theo lớp)
                           -> (Quản lý Môn học & Cấu hình tỷ lệ % trọng số Chuyên cần, Giữa kỳ, Thi)
                           -> (Quản lý Lớp học phần: mở lớp, chỉ định giảng viên phụ trách)
                           -> (Kiểm tra & Phê duyệt bảng điểm: Chuyển trạng thái 'PUBLISHED')
                           -> (Xem báo cáo thống kê phổ điểm học phần, tỷ lệ Đạt/Học lại)
                           -> (Tra cứu và lọc Nhật ký sửa điểm kiểm toán - Audit Logs)
+-------------------------------------------------------------------------------------------------+"""
    add_diagram_box(doc, uc_ascii, "Biểu đồ Use Case Tổng quát Hệ thống Quản lý Điểm UTC")

    add_heading_3(doc, "1.2.2. Nhóm chức năng Quản lý hệ thống và Xác thực phân quyền")
    add_p(doc, "Chức năng Đăng nhập (Sign In): Cho phép người dùng nhập Tên đăng nhập và Mật khẩu. Hệ thống kiểm tra trong bảng TAI_KHOAN của cơ sở dữ liệu Oracle:")
    add_p(doc, "Nếu tên đăng nhập không tồn tại hoặc tài khoản bị khóa (TRANG_THAI = 0): Hệ thống hiển thị thông báo lỗi rõ ràng trên giao diện.", bullet=True)
    add_p(doc, "Nếu tài khoản hợp lệ: Hệ thống sử dụng thư viện jBCrypt để kiểm tra tính khớp nối giữa mật khẩu người dùng nhập vào và chuỗi băm mật khẩu (BCrypt Hash) lưu trữ trong cơ sở dữ liệu. Khi khớp nối thành công, hệ thống khởi tạo HttpSession, lưu trữ thông tin User Principal và chuyển hướng người dùng đến đúng bảng điều khiển theo vai trò (Admin -> /admin/dashboard, Giảng viên -> /lecturer/classes, Sinh viên -> /student/grades).", bullet=True)
    add_p(doc, "Tính năng Đăng nhập 1 chạm (One-click Login): Hệ thống tích hợp sẵn các nút chọn tài khoản thử nghiệm nhanh ngay dưới biểu mẫu đăng nhập, hỗ trợ đắc lực cho hội đồng phản biện và giáo viên chấm thi đăng nhập trực tiếp các vai trò thử nghiệm mà không cần ghi nhớ mật khẩu.", bullet=True)
    add_p(doc, "Chức năng Đổi mật khẩu (Change Password): Cho phép người dùng chủ động thay đổi mật khẩu đăng nhập, yêu cầu nhập mật khẩu cũ để xác thực và nhập mật khẩu mới hai lần để đảm bảo tính chính xác.", bullet=True)
    add_p(doc, "Phân quyền truy cập RBAC (Role-Based Access Control): Sử dụng bộ lọc AuthFilter (triển khai giao diện javax.servlet.Filter) để chặn đứng mọi hành vi truy cập trái phép vào các đường dẫn nhạy cảm khi chưa xác thực hoặc không đủ đặc quyền.", bullet=True)

    add_heading_3(doc, "1.2.3. Nhóm chức năng Quản lý danh mục đào tạo")
    add_p(doc, "Nhóm chức năng này dành riêng cho vai trò Quản trị viên (Phòng Đào tạo) nhằm quản lý dữ liệu nền tảng của Nhà trường:")
    add_p(doc, "Quản lý Sinh viên: Cho phép xem danh sách sinh viên theo từng lớp chuyên ngành hoặc khoa, thêm mới từng sinh viên hoặc nạp danh sách hàng loạt, cập nhật thông tin sinh viên và xóa sinh viên (có kiểm tra ràng buộc toàn vẹn dữ liệu điểm số trước khi xóa). Biểu mẫu hỗ trợ nút 'Làm mới' (Reset Form) để đưa các trường nhập liệu về trạng thái ban đầu.", bullet=True)
    add_p(doc, "Quản lý Môn học: Cho phép khai báo môn học mới, thiết lập số tín chỉ và tỷ lệ phần trăm trọng số điểm đánh giá (ví dụ: Chuyên cần 10%, Giữa kỳ 30%, Thi kết thúc học phần 60%). Tổng tỷ lệ các thành phần bắt buộc phải bằng đúng 100%.", bullet=True)
    add_p(doc, "Quản lý Lớp học phần: Mở các lớp học phần tương ứng trong từng học kỳ, chỉ định giảng viên phụ trách giảng dạy và thiết lập số lượng sinh viên tối đa.", bullet=True)

    add_heading_3(doc, "1.2.4. Nhóm chức năng Quản lý điểm số và Quy trình xét duyệt điểm")
    add_p(doc, "Đây là nhóm chức năng nghiệp vụ trọng tâm của hệ thống, được thiết kế với quy trình phê duyệt điểm khép kín 3 bước:")
    
    flow_ascii = """+---------------+          Giảng viên nộp điểm           +-----------------+
|     DRAFT     |  ------------------------------------>  |    SUBMITTED    |
|  (Bản nháp)   |        (Gửi phê duyệt lên P.ĐT)         |  (Chờ phê duyệt)|
+---------------+                                         +-----------------+
        ^                                                           |
        |                                                           | Phòng Đào tạo duyệt
        | Phòng Đào tạo từ chối                                     v
        +-------------------------------------------------  +-----------------+
                                                            |    PUBLISHED    |
                                                            |  (Đã công bố)   |
                                                            +-----------------+"""
    add_diagram_box(doc, flow_ascii, "Quy trình Xét duyệt và Công bố Điểm Học phần UTC")

    add_p(doc, "Bước 1 - Giảng viên nhập điểm (Trạng thái DRAFT): Giảng viên vào màn hình nhập điểm của lớp học phần, giao diện hiển thị bảng dữ liệu Web Data Table trực quan (thay thế cho JTable trong ứng dụng Swing Desktop). Giảng viên nhập điểm chuyên cần, giữa kỳ, thi kết thúc học phần hoặc chọn nạp dữ liệu tự động từ file Excel. Hệ thống tự động tính toán điểm tổng kết hệ 10 và quy đổi điểm chữ, điểm hệ 4 theo thời gian thực.", bullet=True)
    add_p(doc, "Bước 2 - Giảng viên gửi phê duyệt (Trạng thái SUBMITTED): Sau khi kiểm tra đầy đủ danh sách điểm của lớp, giảng viên bấm nút 'Nộp điểm lên Phòng Đào tạo'. Bảng điểm chuyển sang trạng thái chờ phê duyệt, khóa quyền sửa trực tiếp của giảng viên nhằm bảo vệ tính toàn vẹn dữ liệu.", bullet=True)
    add_p(doc, "Bước 3 - Phòng Đào tạo phê duyệt (Trạng thái PUBLISHED): Cán bộ Phòng Đào tạo kiểm tra tính hợp lệ của sổ điểm. Nếu hợp lệ, bấm nút 'Phê duyệt & Công bố', bảng điểm chính thức chuyển sang trạng thái PUBLISHED và hiển thị trên tài khoản của sinh viên. Nếu phát hiện sai sót, cán bộ có thể từ chối và yêu cầu giảng viên kiểm tra lại.", bullet=True)
    add_p(doc, "Nhật ký kiểm toán sửa điểm (Audit Log): Trường hợp bảng điểm đã ở trạng thái PUBLISHED nhưng có quyết định sửa điểm do sai sót kỹ thuật, hệ thống bắt buộc người dùng phải nhập lý do sửa đổi. Hệ thống sẽ lưu giữ cả giá trị điểm cũ, giá trị điểm mới, người thực hiện và mốc thời gian sửa vào bảng LICHSU_SUA_DIEM.", bullet=True)

    add_p(doc, "Bảng quy định chuẩn quy đổi thang điểm học phần áp dụng tại Trường Đại học Giao thông Vận tải (theo Thông tư 08/2021/TT-BGDĐT):")
    
    scale_data = [
        ["Thang điểm 10", "Điểm chữ UTC", "Thang điểm 4", "Xếp loại học lực", "Quy định điều kiện"],
        ["8.5 - 10.0", "A", "4.0", "Xuất sắc", "Điểm thi kết thúc học phần >= 4.0"],
        ["8.0 - 8.4", "B+", "3.5", "Giỏi", "Điểm thi kết thúc học phần >= 4.0"],
        ["7.0 - 7.9", "B", "3.0", "Khá", "Điểm thi kết thúc học phần >= 4.0"],
        ["6.5 - 6.9", "C+", "2.5", "Trung bình khá", "Điểm thi kết thúc học phần >= 4.0"],
        ["5.5 - 6.4", "C", "2.0", "Trung bình", "Điểm thi kết thúc học phần >= 4.0"],
        ["5.0 - 5.4", "D+", "1.5", "Trung bình yếu", "Điểm thi kết thúc học phần >= 4.0"],
        ["4.0 - 4.9", "D", "1.0", "Yếu (Đạt yêu cầu)", "Điểm thi kết thúc học phần >= 4.0"],
        ["2.0 - 3.9", "F+", "0.5", "Kém (Không đạt)", "Hoặc bị điểm liệt thi kết thúc < 4.0"],
        ["0.0 - 1.9", "F", "0.0", "Kém (Phải học lại)", "Bắt buộc phải đăng ký học lại học phần"]
    ]
    t_scale = doc.add_table(rows=len(scale_data), cols=5)
    for r_i, r_data in enumerate(scale_data):
        for c_i, c_val in enumerate(r_data):
            t_scale.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_scale, [Cm(2.6), Cm(2.4), Cm(2.4), Cm(3.6), Cm(5.4)],
                 [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    add_heading_3(doc, "1.2.5. Nhóm chức năng Tra cứu, Tìm kiếm và Cảnh báo học vụ")
    add_p(doc, "Tra cứu và tìm kiếm đa tiêu chí: Cho phép cán bộ quản lý và giảng viên tra cứu sinh viên hoặc bảng điểm theo tổ hợp nhiều điều kiện: Mã sinh viên, Họ và tên, Lớp chuyên ngành, Môn học, Học kỳ, Trạng thái bảng điểm (Nháp / Chờ duyệt / Đã công bố) và khoảng điểm tổng kết.", bullet=True)
    add_p(doc, "Tự động nhận diện và Cảnh báo học vụ: Căn cứ Điều 15 Quy chế đào tạo tín chỉ UTC, hệ thống tự động tính toán điểm trung bình tích lũy CPA toàn khóa của tất cả sinh viên. Sinh viên có CPA < 1.00 lập tức được đưa vào danh sách 'Cảnh báo học vụ' (Mức 1 hoặc Mức 2 nguy cơ buộc thôi học) với biểu tượng cảnh báo màu đỏ nổi bật trên Dashboard của Ban Giám hiệu và Phòng Đào tạo.", bullet=True)
    add_p(doc, "In ấn phiếu điểm học kỳ định dạng chuẩn A4: Tích hợp công nghệ CSS @media print cho phép sinh viên và giảng viên in trực tiếp phiếu điểm học kỳ từ trình duyệt web với bố cục chuẩn hóa quốc gia, có quốc hiệu, tiêu ngữ, logo trường UTC và khung ký tên của Trưởng phòng Đào tạo.", bullet=True)

    # 1.3
    add_heading_2(doc, "1.3. Phân tích yêu cầu phi chức năng và công nghệ áp dụng")
    
    add_heading_3(doc, "1.3.1. Yêu cầu tính toàn vẹn dữ liệu và kiểm tra hợp lệ (Validation)")
    add_p(doc, "Toàn vẹn dữ liệu là yếu tố sống còn đối với một phần mềm quản lý điểm. Hệ thống áp dụng cơ chế xác thực dữ liệu 2 tầng (Dual-layer Validation):")
    add_p(doc, "Tầng Client-side (Trình duyệt): Sử dụng các thuộc tính ràng buộc của HTML5 (required, min, max, step, pattern) kết hợp mã lệnh JavaScript để kiểm tra tính hợp lệ của dữ liệu ngay khi người dùng thao tác: Không được bỏ trống các trường bắt buộc, điểm số phải là số thực từ 0.0 đến 10.0, ngày sinh đúng định dạng yyyy-MM-dd. Điều này giúp giảm tải cho máy chủ và tăng trải nghiệm người dùng.", bullet=True)
    add_p(doc, "Tầng Server-side (Java Servlet): Đây là tầng kiểm tra bắt buộc nhằm ngăn chặn các hành vi cố tình vượt qua lớp kiểm tra phía trình duyệt. Servlet thực hiện parse kiểu dữ liệu, kiểm tra tính hợp lệ của logic nghiệp vụ (ví dụ: tổng tỷ lệ phần trăm môn học phải đúng 100%, mã sinh viên không được trùng lặp trong cơ sở dữ liệu).", bullet=True)
    add_p(doc, "Ràng buộc mức CSDL (Database Constraints): Thiết lập đầy đủ các khóa chính (PRIMARY KEY), khóa ngoại (FOREIGN KEY) với tùy chọn ON DELETE RESTRICT (ngăn chặn xóa học phần nếu đã có dữ liệu điểm thi), các ràng buộc kiểm tra (CHECK constraints: DIEM_CC BETWEEN 0 AND 10, DIEM_GK BETWEEN 0 AND 10, DIEM_THI BETWEEN 0 AND 10) và ràng buộc UNIQUE trên trường TAI_KHOAN.USERNAME.", bullet=True)

    add_heading_3(doc, "1.3.2. Xử lý ngoại lệ, An toàn giao dịch SQL và Chống lỗ hổng bảo mật")
    add_p(doc, "Xử lý ngoại lệ toàn diện (Robust Exception Handling): Tất cả các đoạn mã tương tác với cơ sở dữ liệu đều được bao bọc trong các khối lệnh try-catch chuẩn mực:")
    add_p(doc, "Bắt ngoại lệ SQLException: Ghi log chi tiết lỗi tại máy chủ, đồng thời chuyển hướng người dùng đến trang thông báo lỗi thân thiện, tuyệt đối không làm lộ chuỗi kết nối hoặc thông tin nhạy cảm của CSDL ra màn hình người dùng.", bullet=True)
    add_p(doc, "Bắt ngoại lệ NumberFormatException: Ngăn chặn lỗi treo hệ thống khi người dùng vô tình nhập ký tự văn bản vào ô điểm số.", bullet=True)
    add_p(doc, "Quản lý Giao dịch (SQL Transaction Management): Đối với các thao tác ảnh hưởng đến nhiều bản ghi (như import danh sách điểm cả lớp hoặc vừa cập nhật điểm vừa ghi nhật ký LICHSU_SUA_DIEM), hệ thống thiết lập conn.setAutoCommit(false). Toàn bộ thao tác chỉ được xác nhận vĩnh viễn (conn.commit()) khi mọi câu lệnh thành công; nếu có bất kỳ lỗi nào phát sinh, hệ thống lập tức hoàn tác (conn.rollback()) để dữ liệu không bao giờ bị sai lệch cục bộ.", bullet=True)
    add_p(doc, "Phòng chống các lỗ hổng bảo mật Web phổ biến:", bold_prefix="An toàn thông tin: ")
    add_p(doc, "Chống tấn công SQL Injection: 100% các câu lệnh truy vấn dữ liệu đều sử dụng PreparedStatement với các tham số truyền vào qua dấu hỏi chấm (?), tuyệt đối không dùng phương pháp cộng chuỗi truy vấn (String Concatenation).", bullet=True)
    add_p(doc, "Chống tấn công Cross-Site Scripting (XSS): Sử dụng thẻ <c:out value='...' escapeXml='true'/> của thư viện JSTL để mã hóa toàn bộ dữ liệu người dùng trước khi hiển thị ra trang web.", bullet=True)
    add_p(doc, "Bảo vệ mật khẩu người dùng: Mật khẩu được băm một chiều bằng thuật toán BCrypt kết hợp Salt ngẫu nhiên, đảm bảo ngay cả khi cơ sở dữ liệu bị lộ lọt thì mật khẩu gốc vẫn không thể bị giải mã.", bullet=True)

    add_heading_3(doc, "1.3.3. Công nghệ sử dụng: Java Web MVC, Oracle DB 23ai, Apache POI")
    add_p(doc, "Căn cứ vào yêu cầu kỹ thuật và tính chất doanh nghiệp của bài toán Quản lý điểm UTC, hệ thống được xây dựng trên nền tảng công nghệ chuyên nghiệp:")
    add_p(doc, "Ngôn ngữ lập trình: Java (JDK 17 LTS / JDK 21 LTS), sử dụng các tính năng hiện đại như Record types, Switch expressions, Try-with-resources.", bullet=True)
    add_p(doc, "Nền tảng ứng dụng: Java Web Servlet (Jakarta / Java EE Servlet 4.0/5.0), JavaServer Pages (JSP 2.3), Java Standard Tag Library (JSTL 1.2), tuân thủ mô hình thiết kế kiến trúc MVC (Model - View - Controller).", bullet=True)
    add_p(doc, "Máy chủ ứng dụng (Web Application Server): Apache Tomcat 9.0 / 10.1, đảm bảo hiệu năng xử lý đồng thời hàng ngàn yêu cầu HTTP và hỗ trợ cấu hình phiên làm việc an toàn.", bullet=True)
    add_p(doc, "Hệ quản trị cơ sở dữ liệu: Oracle Database 23ai Free (phiên bản Pluggable Database FREEPDB1), cung cấp khả năng xử lý giao dịch dữ liệu lớn (Enterprise-grade RDBMS), hỗ trợ kiểu dữ liệu đa dạng và cơ chế toàn vẹn quan hệ mạnh mẽ.", bullet=True)
    add_p(doc, "Trình điều khiển kết nối CSDL: Oracle JDBC Thin Driver (ojdbc11.jar), giao tiếp với Oracle Database qua giao thức mạng độc lập tốc độ cao.", bullet=True)
    add_p(doc, "Thư viện xử lý Excel: Apache POI (bản poi-ooxml 5.2.x), cho phép đọc và ghi dữ liệu bảng tính định dạng Microsoft Excel OpenXML (.xlsx) trực tiếp từ bộ nhớ mà không cần cài đặt phần mềm Office.", bullet=True)
    add_p(doc, "Giao diện người dùng: Web UI Responsive hiện đại (kết hợp Tailwind CSS và Bootstrap 5), hỗ trợ các hiệu ứng trực quan, bảng dữ liệu linh hoạt và hộp thoại xác nhận modal chuyên nghiệp.", bullet=True)

    # End of Chapter 1 -> Page Break
    doc.add_page_break()

print("Appended Chapter 1 successfully.")

def build_chapter_2(doc):
    # CHƯƠNG 2
    add_heading_1(doc, "CHƯƠNG 2: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG")

    add_callout(doc, "TỔNG QUAN NỘI DUNG CHƯƠNG 2", [
        "Chương 2 trình bày chi tiết thiết kế kỹ thuật của hệ thống Quản lý điểm UTC trên hai phương diện cốt lõi:",
        "1. Thiết kế Cơ sở dữ liệu: Lược đồ quan hệ thực thể (ERD) tổng thể và bảng từ điển dữ liệu (Data Dictionary) chi tiết của các bảng trong CSDL Oracle Database 23ai.",
        "2. Thiết kế Kiến trúc phần mềm: Phân tích mô hình kiến trúc 3 tầng MVC (Model - View - Controller), chu trình xử lý Request/Response qua Servlet Controller và cấu trúc phân rã các package mã nguồn."
    ])

    # 2.1
    add_heading_2(doc, "2.1. Thiết kế cơ sở dữ liệu")
    
    add_heading_3(doc, "2.1.1. Lược đồ quan hệ thực thể (ERD) hệ thống Oracle Database 23ai")
    add_p(doc, "Cơ sở dữ liệu của Hệ thống Quản lý điểm UTC được triển khai trên hệ quản trị cơ sở dữ liệu doanh nghiệp Oracle Database 23ai Free. Toàn bộ lược đồ dữ liệu được thiết kế đạt chuẩn chuẩn hóa bậc 3 (3NF - Third Normal Form), loại bỏ triệt để hiện tượng dư thừa dữ liệu và đảm bảo tính toàn vẹn tham chiếu nghiêm ngặt.")

    erd_ascii = """+-------------+        +-------------+        +--------------------+
|    KHOA     | 1    n |    NGANH    | 1    n | LOP_CHUYEN_NGANH   |
+-------------+ <------+-------------+ <------+--------------------+
                                                         | 1
                                                         | n
+-------------+ 1      n +-------------+ 1            n  v
|  TAI_KHOAN  | <------- | GIANG_VIEN  |       +--------------------+
+-------------+          +-------------+       |     SINH_VIEN      |
       | 1                      | 1            +--------------------+
       |                        |                       | 1
       |                        v                       | n
       |                 +--------------------+         v
       |                 |   LOP_HOC_PHAN     | 1   n +--------------------+
       |                 +--------------------+ <---- |     BANG_DIEM      |
       |                        | n                   +--------------------+
       | 1                      v 1                             | 1
       |                 +--------------------+                 | n
       |                 |     MON_HOC        |                 v
       |                 +--------------------+       +--------------------+
       |                        ^                     |  LICHSU_SUA_DIEM   |
       |                        | 1                   +--------------------+
       |                 +--------------------+
       +---------------> |     HOC_KY         |
                         +--------------------+"""
    add_diagram_box(doc, erd_ascii, "Lược đồ Quan hệ Thực thể (ERD) Hệ thống Quản lý Điểm UTC")

    add_p(doc, "Phân tích các mối quan hệ quan trọng trong lược đồ:", bold_prefix="Mối quan hệ dữ liệu: ")
    add_p(doc, "Quan hệ KHOA - NGANH - LOP_CHUYEN_NGANH - SINH_VIEN (1 - n): Thể hiện cơ cấu tổ chức phân cấp học thuật tại Trường ĐH Giao thông Vận tải. Mỗi Khoa quản lý nhiều Ngành học; mỗi Ngành quản lý nhiều Lớp chuyên ngành sinh hoạt (ví dụ: Công nghệ Thông tin 1 - K62); mỗi Lớp chuyên ngành bao gồm nhiều Sinh viên.", bullet=True)
    add_p(doc, "Quan hệ TAI_KHOAN - SINH_VIEN / GIANG_VIEN (1 - 1): Mỗi người dùng trong hệ thống (Sinh viên hoặc Giảng viên) liên kết chính xác với một tài khoản định danh trong bảng TAI_KHOAN để thực hiện xác thực và phân quyền RBAC.", bullet=True)
    add_p(doc, "Quan hệ LOP_HOC_PHAN - MON_HOC, HOC_KY, GIANG_VIEN (n - 1): Lớp học phần là thực thể tổ chức giảng dạy trong kỳ. Mỗi lớp học phần thuộc về một môn học cụ thể, được mở trong một học kỳ xác định và do một giảng viên trực tiếp phụ trách.", bullet=True)
    add_p(doc, "Quan hệ kết hợp SINH_VIEN - LOP_HOC_PHAN qua BANG_DIEM (n - n): Một sinh viên có thể đăng ký học nhiều lớp học phần; một lớp học phần có nhiều sinh viên theo học. Bảng BANG_DIEM đóng vai trò là thực thể kết hợp (Associative Entity) lưu trữ kết quả học tập chi tiết của từng sinh viên trong lớp học phần đó.", bullet=True)
    add_p(doc, "Quan hệ BANG_DIEM - LICHSU_SUA_DIEM (1 - n): Mỗi bản ghi điểm của sinh viên có thể có nhiều bản ghi lịch sử điều chỉnh nếu có sự thay đổi sau khi điểm đã được phê duyệt công bố.", bullet=True)

    add_heading_3(doc, "2.1.2. Đặc tả từ điển dữ liệu chi tiết các bảng trong CSDL")
    add_p(doc, "Dưới đây là bảng đặc tả cấu trúc chi tiết (Data Dictionary) của các bảng cốt lõi trong cơ sở dữ liệu Oracle Database 23ai:")

    # Bảng TAI_KHOAN
    add_p(doc, "Bảng 1: Bảng TAI_KHOAN (Quản lý tài khoản đăng nhập và phân quyền hệ thống)", bold_prefix="Đặc tả CSDL: ")
    acc_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["USERNAME", "VARCHAR2(50)", "PK", "NOT NULL, UNIQUE", "Tên đăng nhập (Mã SV, Mã GV hoặc admin)"],
        ["PASSWORD_HASH", "VARCHAR2(255)", "", "NOT NULL", "Mật khẩu người dùng đã băm chuẩn BCrypt"],
        ["ROLE", "VARCHAR2(20)", "", "NOT NULL", "Vai trò người dùng ('ADMIN', 'GIANG_VIEN', 'SINH_VIEN')"],
        ["TRANG_THAI", "NUMBER(1)", "", "DEFAULT 1", "Trạng thái tài khoản (1: Kích hoạt, 0: Khóa)"],
        ["CREATED_AT", "TIMESTAMP", "", "DEFAULT CURRENT_TIMESTAMP", "Thời điểm tạo tài khoản"],
        ["LAST_LOGIN", "TIMESTAMP", "", "NULL", "Thời điểm đăng nhập thành công gần nhất"]
    ]
    t_acc = doc.add_table(rows=len(acc_data), cols=5)
    for r_i, r_data in enumerate(acc_data):
        for c_i, c_val in enumerate(r_data):
            t_acc.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_acc, [Cm(3.2), Cm(2.8), Cm(1.4), Cm(3.2), Cm(5.4)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng SINH_VIEN
    add_p(doc, "Bảng 2: Bảng SINH_VIEN (Quản lý hồ sơ học vụ sinh viên)", bold_prefix="Đặc tả CSDL: ")
    sv_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["MA_SV", "VARCHAR2(20)", "PK", "NOT NULL", "Mã số sinh viên UTC (ví dụ: '211200001')"],
        ["HO_TEN", "VARCHAR2(100)", "", "NOT NULL", "Họ và tên đầy đủ của sinh viên"],
        ["NGAY_SINH", "DATE", "", "NOT NULL", "Ngày tháng năm sinh"],
        ["GIOI_TINH", "VARCHAR2(10)", "", "CHECK ('Nam', 'Nu')", "Giới tính sinh viên"],
        ["EMAIL", "VARCHAR2(100)", "", "NULL", "Email liên lạc của sinh viên"],
        ["SO_DIEN_THOAI", "VARCHAR2(15)", "", "NULL", "Số điện thoại di động"],
        ["QUE_QUAN", "VARCHAR2(200)", "", "NULL", "Tỉnh / Thành phố quê quán"],
        ["MA_LOP_CN", "VARCHAR2(20)", "FK", "REFERENCES LOP_CHUYEN_NGANH", "Mã lớp quản lý chuyên ngành trực thuộc"],
        ["USERNAME", "VARCHAR2(50)", "FK", "REFERENCES TAI_KHOAN", "Liên kết tài khoản đăng nhập của sinh viên"]
    ]
    t_sv = doc.add_table(rows=len(sv_data), cols=5)
    for r_i, r_data in enumerate(sv_data):
        for c_i, c_val in enumerate(r_data):
            t_sv.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_sv, [Cm(2.8), Cm(2.6), Cm(1.2), Cm(4.0), Cm(5.4)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng GIANG_VIEN
    add_p(doc, "Bảng 3: Bảng GIANG_VIEN (Quản lý thông tin cán bộ giảng dạy)", bold_prefix="Đặc tả CSDL: ")
    gv_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["MA_GV", "VARCHAR2(20)", "PK", "NOT NULL", "Mã giảng viên (ví dụ: 'gv_nguyenvanan')"],
        ["HO_TEN", "VARCHAR2(100)", "", "NOT NULL", "Họ và tên giảng viên"],
        ["EMAIL", "VARCHAR2(100)", "", "NOT NULL", "Email công vụ giảng viên"],
        ["SO_DIEN_THOAI", "VARCHAR2(15)", "", "NULL", "Số điện thoại liên lạc"],
        ["HOC_VI", "VARCHAR2(50)", "", "NULL", "Học vị (Thạc sĩ, Tiến sĩ, PGS.TS,...)"],
        ["MA_KHOA", "VARCHAR2(20)", "FK", "REFERENCES KHOA", "Khoa chuyên môn trực thuộc"],
        ["USERNAME", "VARCHAR2(50)", "FK", "REFERENCES TAI_KHOAN", "Liên kết tài khoản đăng nhập"]
    ]
    t_gv = doc.add_table(rows=len(gv_data), cols=5)
    for r_i, r_data in enumerate(gv_data):
        for c_i, c_val in enumerate(r_data):
            t_gv.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_gv, [Cm(2.8), Cm(2.6), Cm(1.2), Cm(3.6), Cm(5.8)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng MON_HOC
    add_p(doc, "Bảng 4: Bảng MON_HOC (Danh mục học phần và tỷ lệ trọng số điểm)", bold_prefix="Đặc tả CSDL: ")
    mh_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["MA_MH", "VARCHAR2(20)", "PK", "NOT NULL", "Mã môn học (ví dụ: 'IT101', 'IT102')"],
        ["TEN_MH", "VARCHAR2(150)", "", "NOT NULL", "Tên môn học (ví dụ: 'Công nghệ Java')"],
        ["SO_TIN_CHI", "NUMBER(2)", "", "CHECK (> 0)", "Số tín chỉ tích lũy (ví dụ: 3)"],
        ["TY_LE_CC", "NUMBER(3,2)", "", "DEFAULT 0.10", "Tỷ lệ trọng số điểm chuyên cần (10%)"],
        ["TY_LE_GK", "NUMBER(3,2)", "", "DEFAULT 0.30", "Tỷ lệ trọng số điểm giữa kỳ (30%)"],
        ["TY_LE_CK", "NUMBER(3,2)", "", "DEFAULT 0.60", "Tỷ lệ trọng số điểm thi cuối kỳ (60%)"]
    ]
    t_mh = doc.add_table(rows=len(mh_data), cols=5)
    for r_i, r_data in enumerate(mh_data):
        for c_i, c_val in enumerate(r_data):
            t_mh.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_mh, [Cm(2.6), Cm(2.6), Cm(1.2), Cm(3.4), Cm(6.2)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng LOP_HOC_PHAN
    add_p(doc, "Bảng 5: Bảng LOP_HOC_PHAN (Lớp học phần mở trong kỳ do Giảng viên phụ trách)", bold_prefix="Đặc tả CSDL: ")
    lhp_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["MA_LHP", "VARCHAR2(30)", "PK", "NOT NULL", "Mã lớp học phần (ví dụ: 'LHP_IT101_01')"],
        ["MA_MH", "VARCHAR2(20)", "FK", "REFERENCES MON_HOC", "Môn học giảng dạy"],
        ["MA_HK", "VARCHAR2(20)", "FK", "REFERENCES HOC_KY", "Học kỳ tổ chức lớp (ví dụ: 'HK1_2024')"],
        ["MA_GV", "VARCHAR2(20)", "FK", "REFERENCES GIANG_VIEN", "Giảng viên trực tiếp phụ trách vào điểm"],
        ["TEN_LHP", "VARCHAR2(150)", "", "NOT NULL", "Tên diễn giải lớp học phần"],
        ["PHONG_HOC", "VARCHAR2(50)", "", "NULL", "Phòng học giảng dạy"],
        ["SO_LUONG_MAX", "NUMBER(3)", "", "DEFAULT 60", "Số lượng sinh viên tối đa của lớp"],
        ["TRANG_THAI_DIEM", "VARCHAR2(20)", "", "DEFAULT 'DRAFT'", "Trạng thái nộp điểm ('DRAFT', 'SUBMITTED', 'PUBLISHED')"]
    ]
    t_lhp = doc.add_table(rows=len(lhp_data), cols=5)
    for r_i, r_data in enumerate(lhp_data):
        for c_i, c_val in enumerate(r_data):
            t_lhp.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_lhp, [Cm(3.2), Cm(2.6), Cm(1.2), Cm(3.8), Cm(5.2)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng BANG_DIEM
    add_p(doc, "Bảng 6: Bảng BANG_DIEM (Kết quả học tập chi tiết của sinh viên)", bold_prefix="Đặc tả CSDL: ")
    bd_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["ID_DIEM", "NUMBER(10)", "PK", "GENERATED ALWAYS AS IDENTITY", "Khóa chính tự tăng nhận diện bản ghi điểm"],
        ["MA_LHP", "VARCHAR2(30)", "FK", "REFERENCES LOP_HOC_PHAN", "Lớp học phần sinh viên theo học"],
        ["MA_SV", "VARCHAR2(20)", "FK", "REFERENCES SINH_VIEN", "Sinh viên được chấm điểm (Mã SV)"],
        ["DIEM_CC", "NUMBER(3,1)", "", "CHECK (BETWEEN 0 AND 10)", "Điểm chuyên cần / quá trình"],
        ["DIEM_GK", "NUMBER(3,1)", "", "CHECK (BETWEEN 0 AND 10)", "Điểm thi giữa kỳ"],
        ["DIEM_THI", "NUMBER(3,1)", "", "CHECK (BETWEEN 0 AND 10)", "Điểm thi kết thúc học phần"],
        ["DIEM_TK_10", "NUMBER(3,1)", "", "NULL", "Điểm tổng kết thang 10 (tính theo trọng số)"],
        ["DIEM_CHU", "VARCHAR2(5)", "", "NULL", "Điểm chữ theo quy chế UTC (A, B+, B,...)"],
        ["DIEM_HE_4", "NUMBER(2,1)", "", "NULL", "Điểm quy đổi thang 4 tích lũy CPA/GPA"],
        ["TRANG_THAI", "VARCHAR2(20)", "", "DEFAULT 'DRAFT'", "Trạng thái bảng điểm cá nhân"]
    ]
    t_bd = doc.add_table(rows=len(bd_data), cols=5)
    for r_i, r_data in enumerate(bd_data):
        for c_i, c_val in enumerate(r_data):
            t_bd.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_bd, [Cm(2.6), Cm(2.6), Cm(1.2), Cm(4.2), Cm(5.4)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # Bảng LICHSU_SUA_DIEM
    add_p(doc, "Bảng 7: Bảng LICHSU_SUA_DIEM (Nhật ký kiểm toán lưu vết sửa đổi điểm thi)", bold_prefix="Đặc tả CSDL: ")
    log_data = [
        ["Tên trường", "Kiểu dữ liệu", "Khóa", "Ràng buộc", "Mô tả ý nghĩa"],
        ["ID_LOG", "NUMBER(10)", "PK", "GENERATED ALWAYS AS IDENTITY", "Khóa chính tự tăng nhận diện bản ghi log"],
        ["ID_DIEM", "NUMBER(10)", "FK", "REFERENCES BANG_DIEM", "Liên kết bản ghi điểm bị thay đổi"],
        ["NGUOI_SUA", "VARCHAR2(50)", "", "NOT NULL", "Tên người dùng thực hiện sửa điểm"],
        ["DIEM_CU_CC", "NUMBER(3,1)", "", "NULL", "Điểm chuyên cần cũ"],
        ["DIEM_MOI_CC", "NUMBER(3,1)", "", "NULL", "Điểm chuyên cần mới sau điều chỉnh"],
        ["DIEM_CU_GK", "NUMBER(3,1)", "", "NULL", "Điểm giữa kỳ cũ"],
        ["DIEM_MOI_GK", "NUMBER(3,1)", "", "NULL", "Điểm giữa kỳ mới sau điều chỉnh"],
        ["DIEM_CU_THI", "NUMBER(3,1)", "", "NULL", "Điểm thi kết thúc cũ"],
        ["DIEM_MOI_THI", "NUMBER(3,1)", "", "NULL", "Điểm thi kết thúc mới sau điều chỉnh"],
        ["LY_DO", "VARCHAR2(500)", "", "NOT NULL", "Lý do sửa đổi điểm thi (bắt buộc nhập)"],
        ["THOI_GIAN_SUA", "TIMESTAMP", "", "DEFAULT CURRENT_TIMESTAMP", "Thời điểm chính xác diễn ra thao tác sửa"]
    ]
    t_log = doc.add_table(rows=len(log_data), cols=5)
    for r_i, r_data in enumerate(log_data):
        for c_i, c_val in enumerate(r_data):
            t_log.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_log, [Cm(2.6), Cm(2.6), Cm(1.2), Cm(3.8), Cm(5.8)],
                 [WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT])

    # 2.2
    add_heading_2(doc, "2.2. Thiết kế kiến trúc phần mềm")
    
    add_heading_3(doc, "2.2.1. Áp dụng mô hình kiến trúc MVC trên nền Java Web Servlet/JSP")
    add_p(doc, "Hệ thống Quản lý điểm UTC được thiết kế theo mô hình kiến trúc chuẩn doanh nghiệp 3 tầng MVC (Model - View - Controller), mang lại khả năng mở rộng cao, dễ dàng bảo trì và phân định ranh giới trách nhiệm cực kỳ rõ ràng giữa các thành phần:")
    add_p(doc, "Tầng Model (Mô hình dữ liệu và nghiệp vụ): Bao gồm các lớp JavaBeans thực thể (Entities) đóng gói dữ liệu và các lớp Data Access Objects (DAO). Model chịu trách nhiệm tương tác trực tiếp với Oracle Database thông qua JDBC, thực thi các câu lệnh SQL an toàn và chứa đựng các thuật toán tính toán nghiệp vụ (GradeCalculator).", bullet=True)
    add_p(doc, "Tầng View (Giao diện hiển thị người dùng): Được xây dựng hoàn toàn bằng các trang JSP (JavaServer Pages) kết hợp thư viện thẻ chuẩn JSTL (Java Standard Tag Library) và EL (Expression Language). Tuyệt đối không nhúng mã lệnh Java Scriptlet (<% ... %>) hay câu lệnh SQL trong View. View chỉ nhận dữ liệu từ Controller thông qua HttpServletRequest attributes để render giao diện HTML/CSS.", bullet=True)
    add_p(doc, "Tầng Controller (Bộ điều khiển và tiếp nhận yêu cầu): Được hiện thực bởi các Java Servlet kế thừa từ HttpServlet. Servlet đóng vai trò là 'nhạc trưởng': Tiếp nhận HTTP Request (GET/POST) từ trình duyệt máy khách, trích xuất tham số, gọi các phương thức tương ứng của tầng Service hoặc DAO để xử lý dữ liệu, sau đó lưu kết quả vào Model và điều phối luồng hiển thị (Forwarding sang View JSP hoặc Redirect sang URL khác).", bullet=True)

    add_heading_3(doc, "2.2.2. Sơ đồ chu trình xử lý Request/Response và Nhiệm vụ các Package")
    mvc_ascii = """+-------------------------------------------------------------------------------------------------+
|               KIẾN TRÚC MÔ HÌNH PHÂN LỚP MVC JAVA WEB SERVLET & ORACLE DB 23AI                  |
+-------------------------------------------------------------------------------------------------+

   [ WEB BROWSER ] (Client HTML5 / Tailwind CSS / Bootstrap 5 / JavaScript)
          |
     (1) HTTP Request (GET / POST)
          v
   [ javax.servlet.Filter ] (EncodingFilter: UTF-8  |  AuthFilter: Kiểm tra Session & Phân quyền RBAC)
          |
     (2) Request hợp lệ được chuyển tiếp
          v
   [ TẦNG CONTROLLER ] (Java Servlets)
     - vn.edu.utc.grade.controller.AuthServlet (Xác thực đăng nhập, Đổi mật khẩu)
     - vn.edu.utc.grade.controller.admin.*     (Dashboard, Quản lý SV, GV, LHP, Môn học, Duyệt điểm)
     - vn.edu.utc.grade.controller.lecturer.*  (Xem lớp phân công, Nhập điểm, Import/Export Excel)
     - vn.edu.utc.grade.controller.student.*   (Tra cứu điểm, GPA/CPA, In phiếu điểm A4)
          |
     (3) Gọi xử lý nghiệp vụ                (6) Đẩy dữ liệu vào Request Attribute
          v                                      và chuyển tiếp Forwarding
   [ TẦNG SERVICE & DAO ]                        v
     - GradeCalculator, ExcelService (Apache POI) [ TẦNG VIEW ] (JSP + JSTL 1.2 + EL)
     - GradeDAO, StudentDAO, UserDAO, CourseClassDAO -> WebContent/WEB-INF/views/
          |                                               |
     (4) JDBC PreparedStatement (ojdbc11)                 | (7) Trả về trang Web hoàn chỉnh
          v                                               v
   [ ORACLE DATABASE 23ai ] (PDB FREEPDB1)          [ WEB BROWSER CLIENT ]
+-------------------------------------------------------------------------------------------------+"""
    add_diagram_box(doc, mvc_ascii, "Sơ đồ Kiến trúc Chu trình Xử lý Request - Response MVC")

    add_p(doc, "Phân định chi tiết vai trò của từng Package mã nguồn trong dự án:", bold_prefix="Cấu trúc Package: ")
    add_p(doc, "vn.edu.utc.grade.config: Chứa các lớp cấu hình hệ thống và bộ lọc toàn cục: DBConnection quản lý nạp thông số chuỗi kết nối từ db.properties và cấp phát Connection; AuthFilter kiểm soát quyền truy cập URL theo vai trò người dùng trong Session; EncodingFilter ép toàn bộ request/response về bộ mã UTF-8.", bullet=True)
    add_p(doc, "vn.edu.utc.grade.model.*: Chứa các đối tượng thực thể JavaBeans chia thành 3 nhóm: academic (ClassRoom, CourseClass, Faculty, Major, Semester, Subject), account (User, Student, Lecturer), grading (Grade, AuditLog). Mỗi lớp đều có trường private, constructor và getter/setter chuẩn mực.", bullet=True)
    add_p(doc, "vn.edu.utc.grade.dao.*: Chứa các lớp Data Access Object chuyên biệt phụ trách truy vấn dữ liệu từ Oracle CSDL: academic.* (FacultyDAO, MajorDAO, ClassRoomDAO, SubjectDAO, CourseClassDAO, SemesterDAO), account.* (UserDAO, StudentDAO, LecturerDAO), grading.* (GradeDAO, AuditLogDAO, StatisticsDAO).", bullet=True)
    add_p(doc, "vn.edu.utc.grade.controller.*: Chứa các Servlet điều phối luồng ứng dụng được phân quyền rõ ràng theo thư mục admin/, lecturer/, student/ và auth/.", bullet=True)
    add_p(doc, "vn.edu.utc.grade.service: Chứa các dịch vụ nghiệp vụ dùng chung: GradeCalculator xử lý các thuật toán tính toán và quy đổi thang điểm UTC; ExcelService sử dụng Apache POI để import/export bảng điểm định dạng .xlsx.", bullet=True)
    add_p(doc, "src/main/webapp/WEB-INF/views: Chứa toàn bộ các tệp giao diện JSP. Thư mục này được đặt trong WEB-INF nhằm ngăn chặn tuyệt đối việc người dùng truy cập trực tiếp file giao diện bằng đường dẫn URL trên thanh địa chỉ của trình duyệt mà bắt buộc phải đi qua Servlet Controller.", bullet=True)

    # End of Chapter 2 -> Page Break
    doc.add_page_break()

print("Appended Chapter 2 successfully.")

def build_chapter_3(doc):
    # CHƯƠNG 3
    add_heading_1(doc, "CHƯƠNG 3: TRIỂN KHAI XÂY DỰNG CHƯƠNG TRÌNH")

    add_callout(doc, "TỔNG QUAN NỘI DUNG CHƯƠNG 3", [
        "Chương 3 trình bày chi tiết việc hiện thực hóa các thiết kế vào trong mã nguồn dự án thực tế:",
        "1. Cấu trúc Project chuẩn Maven trên môi trường phát triển IDE (Eclipse / IntelliJ IDEA).",
        "2. Triển khai lớp kết nối DBConnection, giải phóng tài nguyên an toàn và sử dụng PreparedStatement phòng chống SQL Injection.",
        "3. Triển khai thuật toán tính điểm và quy đổi thang điểm UTC trong GradeCalculator và xử lý Excel bằng Apache POI trong ExcelService.",
        "4. Tuân thủ nghiêm ngặt các quy chuẩn lập trình Java (Coding Conventions) và nguyên tắc tách biệt trách nhiệm (Separation of Concerns)."
    ])

    # 3.1
    add_heading_2(doc, "3.1. Cấu trúc Project")
    add_p(doc, "Dự án được khởi tạo và quản lý phụ thuộc theo tiêu chuẩn Apache Maven (chuẩn Dynamic Web Project). Dưới đây là cây thư mục thực tế của dự án trên môi trường phát triển IDE:")

    tree_ascii = """quan-ly-diem-utc/
├── pom.xml                                  [File cấu hình phụ thuộc Maven: Servlet, POI, BCrypt, Oracle JDBC]
├── database/
│   └── init_db.sql                          [Kịch bản SQL DDL tạo 11 bảng CSDL và nạp dữ liệu mẫu ban đầu]
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── vn/edu/utc/grade/
│   │   │       ├── Main.java                [Lớp khởi chạy nhúng Embedded Tomcat phục vụ chạy độc lập]
│   │   │       ├── config/
│   │   │       │   ├── DBConnection.java    [Quản lý kết nối Oracle JDBC qua db.properties & giải phóng tài nguyên]
│   │   │       │   ├── AuthFilter.java      [Bộ lọc kiểm soát xác thực phiên & phân quyền RBAC theo URL]
│   │   │       │   └── EncodingFilter.java  [Bộ lọc đồng bộ hóa bộ mã ký tự tiếng Việt UTF-8]
│   │   │       ├── controller/
│   │   │       │   ├── AuthServlet.java     [Xử lý đăng nhập, đăng xuất, đổi mật khẩu]
│   │   │       │   ├── admin/               [Các Servlet quản trị: Dashboard, Sinh viên, GV, Môn, Duyệt điểm, Audit]
│   │   │       │   ├── lecturer/            [Các Servlet giảng viên: Xem lớp dạy, Nhập điểm, Import/Export Excel]
│   │   │       │   └── student/             [Các Servlet sinh viên: Tra cứu bảng điểm, xem CPA/GPA, in phiếu A4]
│   │   │       ├── dao/
│   │   │       │   ├── academic/            [DAO truy xuất Khoa, Ngành, Lớp CN, Môn học, Lớp HP, Học kỳ]
│   │   │       │   ├── account/             [DAO truy xuất Tài khoản, Hồ sơ Sinh viên, Hồ sơ Giảng viên]
│   │   │       │   └── grading/             [DAO xử lý Bảng điểm, Thống kê phổ điểm, Nhật ký AuditLog]
│   │   │       ├── model/
│   │   │       │   ├── academic/            [JavaBeans: ClassRoom, CourseClass, Faculty, Major, Semester, Subject]
│   │   │       │   ├── account/             [JavaBeans: User, Student, Lecturer]
│   │   │       │   └── grading/             [JavaBeans: Grade, AuditLog]
│   │   │       └── service/
│   │   │           ├── GradeCalculator.java [Thuật toán tính điểm TK10, điểm liệt, điểm chữ, thang điểm 4 UTC]
│   │   │           └── ExcelService.java    [Dịch vụ xử lý đọc/ghi file Excel .xlsx qua Apache POI]
│   │   ├── resources/
│   │   │   └── db.properties                [File cấu hình URL, user, pass, driver kết nối Oracle DB]
│   │   └── webapp/
│   │       ├── assets/images/               [Tài nguyên hình ảnh tĩnh: utc-logo.png, utc-campus.jpg]
│   │       └── WEB-INF/
│   │           ├── web.xml                  [Cấu hình Deployment Descriptor, Servlet Mappings, Filters]
│   │           └── views/                   [Thư mục chứa toàn bộ giao diện JSP bảo mật]
│   │               ├── auth/                [login.jsp, change-password.jsp]
│   │               ├── admin/               [dashboard.jsp, classes.jsp, subjects.jsp, grade-approval.jsp, ...]
│   │               ├── lecturer/            [my-classes.jsp, grade-input.jsp]
│   │               ├── student/             [my-grades.jsp, transcript-print.jsp]
│   │               └── common/              [header.jsp, footer.jsp, sidebar.jsp]
└── docs/sample-excel/                       [Các tệp Excel mẫu kiểm thử nạp điểm chuẩn UTC]"""
    add_diagram_box(doc, tree_ascii, "Cây Cấu trúc Thư mục Dự án trên Môi trường Phát triển IDE")

    add_p(doc, "Giải thích vai trò của các tệp tin cấu hình trọng yếu:", bold_prefix="Cấu hình hệ thống: ")
    add_p(doc, "pom.xml: Định nghĩa toàn bộ các thư viện bên ngoài phụ thuộc bao gồm: javax.servlet-api (4.0.1), javax.servlet.jsp-api (2.3.3), jstl (1.2), ojdbc11 (23.4.0.24.05), org.apache.poi/poi-ooxml (5.2.5), jbcrypt (0.4) và org.apache.tomcat.embed (chạy Web Server nhúng).", bullet=True)
    add_p(doc, "db.properties: Lưu trữ tập trung các tham số kết nối đến Oracle Database. Khi triển khai lên môi trường máy chủ sản xuất (Production Server), cán bộ kỹ thuật chỉ cần sửa thông tin trong file này mà không phải biên dịch lại mã nguồn Java.", bullet=True)
    add_p(doc, "web.xml: Cấu hình ánh xạ Servlet (Servlet Mappings), khai báo các bộ lọc toàn cục (EncodingFilter, AuthFilter) và thiết lập trang chào mừng mặc định (welcome-file-list).", bullet=True)

    # 3.2
    add_heading_2(doc, "3.2. Triển khai lớp kết nối và xử lý dữ liệu (DAO)")
    
    add_heading_3(doc, "3.2.1. Triển khai lớp DBConnection nạp cấu hình và quản lý tài nguyên")
    add_p(doc, "Lớp DBConnection trong gói vn.edu.utc.grade.config chịu trách nhiệm đọc các thông số cấu hình từ tệp db.properties, nạp driver Oracle JDBC và khởi tạo kết nối. Để giải phóng tài nguyên một cách an toàn và triệt để, lớp cung cấp phương thức tiện ích close() nhận tham số biến đổi (Varargs) kiểu AutoCloseable:")

    code_db = """package vn.edu.utc.grade.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static String url = "jdbc:oracle:thin:@//localhost:1521/FREEPDB1";
    private static String username = "utc_grade";
    private static String password = "utc123";
    private static String driver = "oracle.jdbc.OracleDriver";

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                url = props.getProperty("db.url", url);
                username = props.getProperty("db.user", username);
                password = props.getProperty("db.password", password);
                driver = props.getProperty("db.driver", driver);
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {}
            }
        }
    }
}"""
    add_code_block(doc, code_db, "vn.edu.utc.grade.config.DBConnection.java")

    add_heading_3(doc, "3.2.2. Triển khai PreparedStatement và Quản lý Transaction an toàn")
    add_p(doc, "Để đảm bảo tuyệt đối an toàn trước các cuộc tấn công SQL Injection và duy trì tính toàn vẹn dữ liệu điểm, toàn bộ các câu lệnh SQL trong lớp GradeDAO đều được hiện thực bằng PreparedStatement kết hợp cơ chế kiểm soát Transaction:")

    code_dao = """package vn.edu.utc.grade.dao.grading;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import vn.edu.utc.grade.config.DBConnection;
import vn.edu.utc.grade.model.grading.Grade;
import vn.edu.utc.grade.service.GradeCalculator;

public class GradeDAO {
    // Truy vấn an toàn danh sách điểm theo Lớp học phần
    public List<Grade> getGradesByCourseClass(String classId) {
        List<Grade> list = new ArrayList<>();
        String sql = "SELECT b.*, s.HO_TEN FROM BANG_DIEM b " +
                     "JOIN SINH_VIEN s ON b.MA_SV = s.MA_SV " +
                     "WHERE b.MA_LHP = ? ORDER BY b.MA_SV";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, classId); // Tham số an toàn, chống SQL Injection
            rs = ps.executeQuery();
            while (rs.next()) {
                Grade g = new Grade();
                g.setId(rs.getLong("ID_DIEM"));
                g.setCourseClassId(rs.getString("MA_LHP"));
                g.setStudentId(rs.getString("MA_SV"));
                g.setStudentName(rs.getString("HO_TEN"));
                g.setAttendanceScore(rs.getObject("DIEM_CC") != null ? rs.getDouble("DIEM_CC") : null);
                g.setMidtermScore(rs.getObject("DIEM_GK") != null ? rs.getDouble("DIEM_GK") : null);
                g.setFinalScore(rs.getObject("DIEM_THI") != null ? rs.getDouble("DIEM_THI") : null);
                g.setTotalScore10(rs.getObject("DIEM_TK_10") != null ? rs.getDouble("DIEM_TK_10") : null);
                g.setGradeLetter(rs.getString("DIEM_CHU"));
                g.setGradeScale4(rs.getObject("DIEM_HE_4") != null ? rs.getDouble("DIEM_HE_4") : null);
                g.setStatus(rs.getString("TRANG_THAI"));
                list.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    // Cập nhật điểm kết hợp ghi nhận Lịch sử sửa điểm với Transaction Rollback
    public boolean updateGradeWithAudit(Grade g, String modifiedBy, String reason) {
        String updateSql = "UPDATE BANG_DIEM SET DIEM_CC = ?, DIEM_GK = ?, DIEM_THI = ?, " +
                           "DIEM_TK_10 = ?, DIEM_CHU = ?, DIEM_HE_4 = ? WHERE ID_DIEM = ?";
        String logSql = "INSERT INTO LICHSU_SUA_DIEM (ID_DIEM, NGUOI_SUA, DIEM_CU_CC, DIEM_MOI_CC, " +
                        "DIEM_CU_GK, DIEM_MOI_GK, DIEM_CU_THI, DIEM_MOI_THI, LY_DO) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psLog = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Cập nhật dữ liệu vào bảng BANG_DIEM
            psUpdate = conn.prepareStatement(updateSql);
            psUpdate.setObject(1, g.getAttendanceScore());
            psUpdate.setObject(2, g.getMidtermScore());
            psUpdate.setObject(3, g.getFinalScore());
            psUpdate.setObject(4, g.getTotalScore10());
            psUpdate.setString(5, g.getGradeLetter());
            psUpdate.setObject(6, g.getGradeScale4());
            psUpdate.setLong(7, g.getId());
            psUpdate.executeUpdate();

            // 2. Ghi nhận nhật ký kiểm toán vào LICHSU_SUA_DIEM
            psLog = conn.prepareStatement(logSql);
            psLog.setLong(1, g.getId());
            psLog.setString(2, modifiedBy);
            psLog.setObject(3, g.getOldAttendanceScore());
            psLog.setObject(4, g.getAttendanceScore());
            psLog.setObject(5, g.getOldMidtermScore());
            psLog.setObject(6, g.getMidtermScore());
            psLog.setObject(7, g.getOldFinalScore());
            psLog.setObject(8, g.getFinalScore());
            psLog.setString(9, reason);
            psLog.executeUpdate();

            conn.commit(); // Xác nhận Transaction thành công
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {} // Hoàn tác khi có lỗi
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(psUpdate, psLog, conn);
        }
    }
}"""
    add_code_block(doc, code_dao, "vn.edu.utc.grade.dao.grading.GradeDAO.java (PreparedStatement & Transaction)")

    add_heading_3(doc, "3.2.3. Triển khai thuật toán quy đổi điểm GradeCalculator chuẩn UTC")
    add_p(doc, "Lớp GradeCalculator cài đặt chính xác các công thức tính toán và làm tròn theo Quy chế đào tạo của Trường Đại học Giao thông Vận tải:")

    code_calc = """package vn.edu.utc.grade.service;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class GradeCalculator {
    // Tính điểm tổng kết hệ 10 làm tròn 1 chữ số thập phân
    public static Double calculateFinal10(Double att, Double mid, Double finalExam,
                                          double wAtt, double wMid, double wExam) {
        if (att == null || mid == null || finalExam == null) return null;
        double raw = att * wAtt + mid * wMid + finalExam * wExam;
        BigDecimal bd = BigDecimal.valueOf(raw).setScale(1, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    // Quy đổi sang Điểm chữ UTC (xử lý điều kiện điểm liệt thi < 4.0)
    public static String toGradeLetter(Double score10, Double finalScore) {
        if (score10 == null) return null;
        // Điểm liệt thi: nếu thi kết thúc học phần < 4.0 quy về F hoặc F+
        if (finalScore != null && finalScore < 4.0) {
            return (score10 >= 2.0) ? "F+" : "F";
        }
        if (score10 >= 8.5) return "A";
        if (score10 >= 8.0) return "B+";
        if (score10 >= 7.0) return "B";
        if (score10 >= 6.5) return "C+";
        if (score10 >= 5.5) return "C";
        if (score10 >= 5.0) return "D+";
        if (score10 >= 4.0) return "D";
        if (score10 >= 2.0) return "F+";
        return "F";
    }

    // Quy đổi sang Thang điểm 4 tích lũy GPA/CPA
    public static Double toScale4(String letter) {
        if (letter == null) return null;
        return switch (letter.toUpperCase().trim()) {
            case "A"  -> 4.0;
            case "B+" -> 3.5;
            case "B"  -> 3.0;
            case "C+" -> 2.5;
            case "C"  -> 2.0;
            case "D+" -> 1.5;
            case "D"  -> 1.0;
            case "F+" -> 0.5;
            default   -> 0.0; // F
        };
    }
}"""
    add_code_block(doc, code_calc, "vn.edu.utc.grade.service.GradeCalculator.java")

    add_heading_3(doc, "3.2.4. Triển khai xử lý file Excel bằng Apache POI trong ExcelService")
    add_p(doc, "Lớp ExcelService sử dụng thư viện Apache POI để sinh tệp bảng điểm Excel chuẩn UTC và phân tích dữ liệu nhập từ giảng viên:")

    code_poi = """package vn.edu.utc.grade.service;

import java.io.OutputStream;
import java.util.List;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import vn.edu.utc.grade.model.academic.CourseClass;
import vn.edu.utc.grade.model.grading.Grade;

public class ExcelService {
    public static void exportGradeTemplate(CourseClass cc, List<Grade> grades, OutputStream out) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Bang_Diem");
            sheet.setDisplayGridlines(true);

            // Tiêu đề các cột dữ liệu
            Row header = sheet.createRow(0);
            String[] columns = {"STT", "Mã SV", "Họ và tên", "Chuyên cần (10%)", "Giữa kỳ (30%)", "Cuối kỳ (60%)", "TK Hệ 10", "Điểm Chữ", "Điểm Hệ 4"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Ghi từng dòng dữ liệu điểm sinh viên
            int rowIdx = 1;
            for (Grade g : grades) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(rowIdx - 1);
                row.createCell(1).setCellValue(g.getStudentId());
                row.createCell(2).setCellValue(g.getStudentName());
                if (g.getAttendanceScore() != null) row.createCell(3).setCellValue(g.getAttendanceScore());
                if (g.getMidtermScore() != null) row.createCell(4).setCellValue(g.getMidtermScore());
                if (g.getFinalScore() != null) row.createCell(5).setCellValue(g.getFinalScore());
                if (g.getTotalScore10() != null) row.createCell(6).setCellValue(g.getTotalScore10());
                if (g.getGradeLetter() != null) row.createCell(7).setCellValue(g.getGradeLetter());
                if (g.getGradeScale4() != null) row.createCell(8).setCellValue(g.getGradeScale4());
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }
            workbook.write(out);
        }
    }
}"""
    add_code_block(doc, code_poi, "vn.edu.utc.grade.service.ExcelService.java (Apache POI)")

    # 3.3
    add_heading_2(doc, "3.3. Áp dụng chuẩn lập trình Java và Nguyên tắc tách biệt trách nhiệm")
    add_p(doc, "Toàn bộ mã nguồn dự án được xây dựng tuân thủ nghiêm ngặt theo các tiêu chuẩn kỹ nghệ phần mềm của Oracle và cộng đồng Java chuyên nghiệp:")
    add_p(doc, "Chuẩn đặt tên mã nguồn (Java Coding Conventions): Tên các lớp và giao diện (Classes, Interfaces) đặt theo quy tắc PascalCase (ví dụ: DBConnection, GradeDAO, CourseClass, ExcelService); Tên biến và phương thức đặt theo quy tắc camelCase (ví dụ: getGradesByCourseClass, toScale4, attendanceScore); Tên các hằng số tĩnh đặt theo quy tắc UPPER_SNAKE_CASE (ví dụ: DEFAULT_PAGE_SIZE, ROLE_ADMIN).", bullet=True)
    add_p(doc, "Nguyên tắc tách biệt trách nhiệm (Separation of Concerns): Toàn bộ các câu lệnh SQL (SELECT, INSERT, UPDATE, DELETE) được cô lập 100% trong các lớp DAO. Tuyệt đối không viết câu lệnh SQL trong Servlet Controller hay trong các trang giao diện JSP. Các trang JSP chỉ thuần túy dùng thẻ JSTL và EL để hiển thị dữ liệu.", bullet=True)
    add_p(doc, "Đóng gói dữ liệu (Encapsulation) và JavaBeans chuẩn: Tất cả các trường thuộc tính trong lớp Model đều khai báo với phạm vi truy cập private, cung cấp đầy đủ các hàm khởi tạo (Constructors) và các phương thức getter/setter tương ứng, cho phép JSTL Expression Language (${grade.studentName}) truy xuất dữ liệu một cách trực quan và an toàn.", bullet=True)

    # End of Chapter 3 -> Page Break
    doc.add_page_break()

print("Appended Chapter 3 successfully.")

def build_chapter_4(doc):
    # CHƯƠNG 4
    add_heading_1(doc, "CHƯƠNG 4: GIAO DIỆN VÀ KIỂM THỬ")

    add_callout(doc, "TỔNG QUAN NỘI DUNG CHƯƠNG 4", [
        "Chương 4 giới thiệu toàn bộ giao diện trực quan đã xây dựng và kết quả kiểm thử phần mềm thực tế:",
        "1. Trình bày các màn hình giao diện Web hiện đại: Đăng nhập & Đăng nhập 1 chạm, Dashboard quản trị tự co giãn Responsive, Web Data Table nhập điểm thay thế cho JTable trong Swing, Modal xác nhận an toàn thay thế JOptionPane, màn hình tra cứu điểm và in phiếu điểm A4.",
        "2. Bảng Kịch bản kiểm thử (Test Cases) chi tiết kiểm chứng các trường hợp: Bỏ trống dữ liệu bắt buộc (Validation), Nhập điểm sai định dạng/ngoài khoảng, Trùng khóa chính PK (Mã SV), Sai mật khẩu, Phân quyền URL trái phép, Điểm liệt và Cảnh báo học vụ."
    ])

    # 4.1
    add_heading_2(doc, "4.1. Kết quả thiết kế giao diện")

    add_heading_3(doc, "4.1.1. Màn hình Đăng nhập hiện đại, Đăng nhập 1 chạm & Thông báo lỗi")
    add_p(doc, "Màn hình Đăng nhập (/auth/login) được thiết kế hiện đại với bố cục chia đôi cân đối: Một bên là hình ảnh khuôn viên giảng đường Trường Đại học Giao thông Vận tải và logo thương hiệu UTC sắc nét; bên còn lại là biểu mẫu đăng nhập trang nhã với các trường nhập liệu có hiệu ứng tương tác (focus/hover).")
    add_p(doc, "Xử lý thông báo lỗi đăng nhập: Khi người dùng nhập sai tên tài khoản hoặc mật khẩu không khớp nối trong CSDL Oracle, hệ thống hiển thị một khung cảnh báo (Alert banner) màu đỏ nổi bật với nội dung thông điệp thân thiện: 'Tên đăng nhập hoặc mật khẩu không chính xác. Vui lòng kiểm tra lại!'. Biểu mẫu tự động giữ lại tên đăng nhập cũ để người dùng không phải nhập lại từ đầu.", bullet=True)
    add_p(doc, "Tính năng Đăng nhập 1 chạm (One-Click Demo Login): Nhằm tạo sự thuận tiện tối đa cho Hội đồng đánh giá và Giáo viên phản biện, hệ thống tích hợp sẵn các nút chọn tài khoản mẫu ngay dưới biểu mẫu đăng nhập. Người đánh giá chỉ cần nhấp vào nút tài khoản mong muốn, hệ thống sẽ tự động đăng nhập đúng vai trò mà không cần phải gõ thủ công:", bullet=True)

    add_callout(doc, "TÀI KHOẢN MẪU ĐĂNG NHẬP THỬ NGHIỆM HỆ THỐNG", [
        "• Quản trị viên (Phòng Đào tạo): admin / admin123 (Duyệt điểm, quản lý lớp HP, xem Audit Log, Cảnh báo học vụ)",
        "• Giảng viên mẫu 1: gv_nguyenvanan / gv123 (Phụ trách lớp LHP_IT101_01 Công nghệ Java, nhập điểm, Excel)",
        "• Giảng viên mẫu 2: gv_tranbichngoc / gv123 (Phụ trách lớp LHP_IT102_01 Cơ sở dữ liệu Oracle - trạng thái SUBMITTED)",
        "• Sinh viên mẫu 1: 211200001 / sv123 (Nguyễn Hoàng Nam, CPA Xuất sắc 3.80, in phiếu điểm A4)",
        "• Sinh viên mẫu 2: 211200008 / sv123 (Bùi Tuấn Anh, CPA 0.50 - Cảnh báo học vụ mức 2 nguy cơ buộc thôi học)"
    ])

    add_heading_3(doc, "4.1.2. Màn hình Bảng điều khiển Quản trị viên (Admin Dashboard)")
    add_p(doc, "Màn hình Bảng điều khiển (/admin/dashboard) cung cấp cái nhìn tổng quan toàn diện về hoạt động đào tạo của Nhà trường với các đặc tính nổi bật:")
    add_p(doc, "Bố cục Responsive tự co giãn: Sử dụng công nghệ CSS Grid và Flexbox, giao diện tự động co giãn mượt mà theo kích thước màn hình hiển thị (từ màn hình máy tính để bàn 24 inch đến máy tính xách tay và máy tính bảng).", bullet=True)
    add_p(doc, "Thanh điều hướng Navbar & Sidebar: Sidebar bên trái hiển thị danh mục quản lý có phân cấp với các biểu tượng trực quan (Quản lý Sinh viên, Quản lý Giảng viên, Môn học, Lớp học phần, Phê duyệt điểm, Thống kê, Nhật ký sửa điểm). Header bên trên hiển thị tên người dùng và vai trò Quản trị viên cùng nút Đăng xuất an toàn.", bullet=True)
    add_p(doc, "Thẻ thống kê nhanh (KPI Metric Cards): Hiển thị tổng số sinh viên đang theo học, tổng số giảng viên, số lượng lớp học phần mở trong kỳ và số lượng bảng điểm đang chờ Phòng Đào tạo phê duyệt.", bullet=True)

    add_heading_3(doc, "4.1.3. Màn hình Quản lý & Nhập điểm học phần trực quan của Giảng viên")
    add_p(doc, "Màn hình Nhập điểm (/lecturer/grades) là giao diện làm việc chính của giảng viên, được thiết kế tối ưu thay thế hoàn toàn bảng JTable trong ứng dụng Java Swing truyền thống:")
    add_p(doc, "Bảng dữ liệu Web Data Table tương tác cao: Danh sách sinh viên trong lớp học phần được hiển thị với tiêu đề cột rõ ràng, căn lề khoa học (Mã SV căn giữa, Họ tên căn trái, các cột điểm căn giữa). Các ô nhập điểm Chuyên cần, Giữa kỳ, Thi cuối kỳ được kiểm soát định dạng số.", bullet=True)
    add_p(doc, "Tính toán và quy đổi điểm theo thời gian thực (Real-time Calculation): Ngay khi giảng viên nhập hoặc thay đổi điểm số của sinh viên, mã JavaScript phía trình duyệt lập tức tính toán điểm tổng kết thang 10 theo trọng số môn học, đồng thời tự động cập nhật Điểm chữ và Điểm thang 4 tương ứng mà không cần phải tải lại toàn bộ trang web.", bullet=True)
    add_p(doc, "Thanh tác vụ thông minh (Action Bar): Tích hợp nút 'Xuất mẫu Excel' (tải sổ điểm lớp .xlsx), 'Nhập từ Excel' (nạp điểm hàng loạt từ tệp .xlsx) và nút 'Nộp điểm lên Phòng Đào tạo' kèm trạng thái huy hiệu màu (Badge): Xanh lá (PUBLISHED), Vàng cam (SUBMITTED), Xám tro (DRAFT).", bullet=True)

    add_heading_3(doc, "4.1.4. Modal xác nhận thao tác an toàn (Confirmation Dialog)")
    add_p(doc, "Để bảo vệ dữ liệu trước các thao tác nhầm lẫn tai hại (như bấm nhầm nút Xóa sinh viên hoặc bấm nhầm nút Gửi duyệt điểm khi chưa hoàn tất), hệ thống tích hợp các Hộp thoại Modal xác nhận hiện đại (thay thế cho hộp thoại JOptionPane.showConfirmDialog trong Java Swing Desktop):")
    add_p(doc, "Khi người dùng ấn nút Xóa dữ liệu hoặc Gửi phê duyệt, một hộp thoại Modal nổi lên làm mờ nền phía sau, hiển thị thông điệp cảnh báo rõ ràng cùng hai lựa chọn: 'Hủy bỏ' (an toàn) và 'Xác nhận thực hiện' (nút màu đỏ nổi bật). Thao tác chỉ được gửi về máy chủ khi người dùng chủ động bấm xác nhận.", bullet=True)

    add_heading_3(doc, "4.1.5. Màn hình Tra cứu điểm sinh viên, Cảnh báo học vụ & In phiếu điểm A4")
    add_p(doc, "Màn hình Tra cứu điểm (/student/grades) cung cấp cho sinh viên cái nhìn trực quan, minh bạch về tiến độ học tập cá nhân:")
    add_p(doc, "Bảng kết quả học phần chi tiết: Hiển thị danh sách các môn học đã học, số tín chỉ, điểm thành phần (CC, GK, Thi), điểm tổng kết thang 10, điểm chữ và điểm thang 4. Các môn học có điểm F hoặc F+ được làm nổi bật với màu chữ đỏ cảnh báo.", bullet=True)
    add_p(doc, "Khung tổng kết GPA và CPA tích lũy: Tự động tổng kết số tín chỉ tích lũy, điểm trung bình chung học kỳ (GPA) và điểm trung bình tích lũy toàn khóa (CPA) theo thang điểm 4 của UTC.", bullet=True)
    add_p(doc, "Khung cảnh báo học vụ sinh viên (CPA < 1.00): Đối với sinh viên có điểm tích lũy CPA dưới 1.00, hệ thống tự động hiển thị khung cảnh báo học vụ màu đỏ nổi bật theo đúng quy chế đào tạo tín chỉ UTC (xem hình minh họa thực tế bên dưới):", bullet=True)

    # Insert warning image if exists
    img_warn_path = r"C:\Users\Acer\.gemini\antigravity\brain\3315c80e-de45-4c40-afba-a73ff360418c\.user_uploaded\media_1793678153285_8c8d4615.png"
    if os.path.exists(img_warn_path):
        p_img = doc.add_paragraph()
        p_img.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img.paragraph_format.space_before = Pt(6)
        p_img.paragraph_format.space_after = Pt(4)
        p_img.add_run().add_picture(img_warn_path, width=Inches(6.0))
        
        p_img_cap = doc.add_paragraph()
        p_img_cap.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p_img_cap.paragraph_format.space_after = Pt(8)
        r_ic = p_img_cap.add_run("Hình 4.1: Giao diện Cảnh báo học vụ sinh viên có CPA < 1.00 thực tế trên hệ thống")
        r_ic.font.name = "Times New Roman"
        r_ic.font.size = Pt(10)
        r_ic.italic = True
        r_ic.font.color.rgb = NAVY

    add_p(doc, "Chức năng In phiếu điểm chuẩn A4 (/student/transcript/print): Khi sinh viên bấm nút 'In phiếu điểm', hệ thống chuyển sang trang in chuyên dụng với định dạng trang giấy A4 chuẩn hóa của Trường Đại học Giao thông Vận tải (có đầy đủ Quốc hiệu, Tiêu ngữ, Tên trường, Mã sinh viên, Lớp chuyên ngành, Bảng điểm chi tiết có đóng khung và phần ký nhận của Phòng Đào tạo).", bullet=True)

    # 4.2
    add_heading_2(doc, "4.2. Kiểm thử phần mềm (Testing)")

    add_heading_3(doc, "4.2.1. Phương pháp kiểm thử hộp đen và Kiểm tra tính hợp lệ dữ liệu")
    add_p(doc, "Nhóm phát triển đã áp dụng phương pháp kiểm thử hộp đen (Black-box Testing) kết hợp kiểm thử biên (Boundary Value Analysis) và phân lớp tương đương (Equivalence Partitioning) để kiểm tra toàn diện tất cả các trường hợp nghiệp vụ, đặc biệt chú trọng vào việc bắt lỗi nhập liệu (Input Validation), an toàn phân quyền và tính toán điểm số.")

    add_heading_3(doc, "4.2.2. Bảng Kịch bản kiểm thử (Test Cases) chi tiết và Kết quả thực tế")
    add_p(doc, "Dưới đây là bảng tổng hợp các ca kiểm thử tiêu biểu kèm kết quả thực tế trên phần mềm:")

    test_data = [
        ["Mã TC", "Chức năng kiểm thử", "Mô tả kịch bản kiểm thử", "Dữ liệu đầu vào", "Kết quả mong đợi", "Kết quả thực tế", "Đánh giá"],
        ["TC01", "Validation Form Thêm SV", "Bỏ trống các trường bắt buộc (Mã SV, Họ tên)", "Mã SV = '', Họ tên = ''", "Hệ thống chặn submit, hiển thị cảnh báo yêu cầu nhập đầy đủ", "Hiển thị thông báo yêu cầu nhập trường bắt buộc", "Pass"],
        ["TC02", "Validation Định dạng Điểm", "Nhập điểm thi là ký tự chữ hoặc số ngoài khoảng 0-10", "Điểm thi = 'abc' hoặc 11.5 hoặc -1.0", "Hệ thống báo lỗi kiểu dữ liệu và giá trị điểm không hợp lệ (0-10)", "Báo lỗi giá trị điểm ngoài khoảng quy định", "Pass"],
        ["TC03", "Kiểm tra Trùng Khóa chính", "Thêm mới sinh viên có Mã SV đã tồn tại trong CSDL", "Mã SV = '211200001' (đã có)", "Khước từ lưu CSDL Oracle, bắt lỗi ORA-00001, báo trùng mã", "Hiển thị thông báo: Mã sinh viên đã tồn tại trên hệ thống", "Pass"],
        ["TC04", "Xác thực Đăng nhập", "Nhập sai mật khẩu khi đăng nhập hệ thống", "User = 'admin', Pass = 'sai_pass'", "Hệ thống từ chối đăng nhập, hiển thị thông báo lỗi màu đỏ", "Hiển thị thông báo sai thông tin đăng nhập", "Pass"],
        ["TC05", "Phân quyền RBAC qua URL", "Sinh viên cố tình truy cập trực tiếp URL phê duyệt điểm", "URL: /admin/grade-approval với tài khoản sinh viên", "AuthFilter chặn truy cập, chuyển hướng hoặc báo lỗi 403 Forbidden", "Bị chặn và chuyển hướng về trang chủ", "Pass"],
        ["TC06", "Xét duyệt Điểm liệt Thi", "Sinh viên có điểm quá trình cao nhưng thi cuối kỳ < 4.0", "CC = 9.0, GK = 8.5, Thi = 3.5", "Hệ thống quy về điểm F+ (thang 4 = 0.5) dù điểm TB > 4.0", "Quy đổi chính xác ra điểm chữ F+, thang 4 là 0.5", "Pass"],
        ["TC07", "Cảnh báo học vụ tự động", "Sinh viên có điểm tích lũy CPA < 1.00 toàn khóa", "Sinh viên 211200008 (Bùi Tuấn Anh), CPA = 0.50", "Hệ thống tự động đưa vào danh sách cảnh báo học vụ mức 2", "Hiển thị bảng cảnh báo đỏ: Nguy cơ buộc thôi học", "Pass"],
        ["TC08", "Import bảng điểm Excel", "Giảng viên nạp danh sách điểm từ file Excel .xlsx mẫu", "Tệp Bang_Diem_Mau_LHP_IT101_01.xlsx", "Apache POI đọc file, cập nhật thành công CSDL Oracle", "Cập nhật thành công toàn bộ điểm của lớp học phần", "Pass"],
        ["TC09", "Kiểm toán Sửa điểm (Audit)", "Giảng viên/Admin sửa điểm học phần đã công bố", "Sửa điểm thi từ 4.0 lên 8.0, nhập lý do: 'Chấm phúc khảo'", "Lưu điểm mới vào BANG_DIEM và ghi 1 bản ghi vào LICHSU_SUA_DIEM", "Ghi nhận đầy đủ vết sửa điểm trong bảng nhật ký kiểm toán", "Pass"]
    ]
    t_tc = doc.add_table(rows=len(test_data), cols=7)
    for r_i, r_data in enumerate(test_data):
        for c_i, c_val in enumerate(r_data):
            t_tc.cell(r_i, c_i).paragraphs[0].text = c_val
    format_table(t_tc, [Cm(1.4), Cm(2.4), Cm(3.2), Cm(2.4), Cm(3.4), Cm(3.4), Cm(1.2)],
                 [WD_ALIGN_PARAGRAPH.CENTER, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.LEFT, WD_ALIGN_PARAGRAPH.CENTER])

    # End of Chapter 4 -> Page Break
    doc.add_page_break()

print("Appended Chapter 4 successfully.")

def build_conclusion_and_references(doc):
    # KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN
    add_heading_1(doc, "KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN")

    add_heading_2(doc, "1. Kết quả đạt được của đề tài")
    add_p(doc, "Sau quá trình nghiên cứu lý thuyết, khảo sát nghiệp vụ thực tế tại Trường Đại học Giao thông Vận tải và bắt tay vào triển khai kỹ thuật, nhóm sinh viên chúng em đã hoàn thành xuất sắc các mục tiêu đề ra cho bài tập nhóm học phần Công nghệ Java:")
    add_p(doc, "Xây dựng thành công ứng dụng Web hoàn chỉnh: Ứng dụng chạy ổn định trên nền tảng Java EE (Servlet 4.0/5.0, JSP 2.3, JSTL 1.2) với kiến trúc MVC 3 tầng mạch lạc, tách biệt hoàn toàn giữa giao diện, logic điều hướng và mã truy xuất cơ sở dữ liệu.", bullet=True)
    add_p(doc, "Tích hợp cơ sở dữ liệu Oracle Database 23ai quy chuẩn: Lược đồ 11 bảng được chuẩn hóa đạt dạng 3NF, thiết lập đầy đủ các khóa chính, khóa ngoại, ràng buộc kiểm tra toàn vẹn và tối ưu hóa câu lệnh truy vấn qua PreparedStatement.", bullet=True)
    add_p(doc, "Cài đặt chuẩn xác Quy chế đào tạo tín chỉ UTC: Thuật toán trong GradeCalculator tính toán chính xác điểm tổng kết thang 10, quy đổi điểm chữ, điểm hệ 4 và xét điều kiện điểm liệt thi kết thúc học phần (< 4.0) theo đúng văn bản quy phạm của Bộ GD&ĐT và Nhà trường.", bullet=True)
    add_p(doc, "Quy trình phê duyệt điểm minh bạch và Lưu vết kiểm toán: Quy trình xét duyệt 3 bước (DRAFT -> SUBMITTED -> PUBLISHED) ngăn chặn tình trạng sửa điểm tùy tiện; bảng LICHSU_SUA_DIEM ghi nhận chi tiết mọi biến động sửa đổi phục vụ công tác thanh tra học vụ.", bullet=True)
    add_p(doc, "Tích hợp thư viện Apache POI xử lý Excel chuyên nghiệp: Hỗ trợ giảng viên xuất sổ điểm lớp và nhập điểm tự động từ file .xlsx nhanh chóng, chính xác.", bullet=True)
    add_p(doc, "Giao diện Web Responsive hiện đại, tiện ích cao: Dashboard trực quan, tự co giãn trên nhiều kích thước màn hình, tính năng Đăng nhập 1 chạm thuận tiện cho việc chấm thi, tự động phát hiện và cảnh báo học vụ sinh viên (CPA < 1.00) và in phiếu điểm học kỳ A4 sắc nét.", bullet=True)

    add_heading_2(doc, "2. Những mặt hạn chế còn tồn đọng")
    add_p(doc, "Bên cạnh những kết quả tích cực đã đạt được, hệ thống vẫn còn một số điểm hạn chế do giới hạn về mặt thời gian và phạm vi của bài tập nhóm:")
    add_p(doc, "Chưa tích hợp chữ ký số điện tử (Digital Signature): Quy trình nộp điểm của giảng viên hiện tại dựa trên xác thực tài khoản và phân quyền trong phần mềm, chưa tích hợp chứng thư số hoặc chữ ký số chuyên dụng để xác nhận giá trị pháp lý tuyệt đối của bảng điểm điện tử.", bullet=True)
    add_p(doc, "Giao diện trên màn hình di động cỡ nhỏ: Mặc dù giao diện tổng thể đã đáp ứng chuẩn Responsive, tuy nhiên đối với các bảng điểm lớp học phần có quá nhiều cột thành phần (chuyên cần, giữa kỳ, thi, điểm 10, điểm chữ, điểm 4, trạng thái), người dùng trên điện thoại di động vẫn cần thao tác cuộn ngang (horizontal scroll) để xem đầy đủ.", bullet=True)
    add_p(doc, "Chưa có hệ thống gửi thông báo tự động đa kênh: Phần mềm hiện tại chỉ hỗ trợ hiển thị thông báo trực tiếp khi người dùng đăng nhập vào hệ thống, chưa gửi tự động qua Email sinh viên hay tin nhắn SMS/Zalo khi có bảng điểm mới được công bố.", bullet=True)

    add_heading_2(doc, "3. Hướng nghiên cứu và phát triển trong tương lai")
    add_p(doc, "Để hệ thống Quản lý điểm UTC có thể đưa vào ứng dụng thực tế trên quy mô toàn Trường Đại học Giao thông Vận tải trong tương lai, nhóm đề xuất các hướng nâng cấp và mở rộng trọng tâm sau:")
    add_p(doc, "Tích hợp hệ thống Đăng nhập một lần (Single Sign-On - SSO): Kết nối hệ thống với cổng định danh tập trung của Nhà trường qua giao thức OAuth 2.0 / SAML 2.0 (tài khoản Google Workspace for Education @utc.edu.vn hoặc Microsoft Entra ID), giúp sinh viên và cán bộ không phải ghi nhớ nhiều mật khẩu khác nhau.", bullet=True)
    add_p(doc, "Xây dựng cổng thông báo tự động (Notification Gateway): Tích hợp dịch vụ gửi Email thông báo tự động (qua JavaMail API / SendGrid) và tin nhắn Zalo ZNS để thông báo tức thời điểm thi, thời hạn nộp điểm và cảnh báo học vụ đến sinh viên và phụ huynh.", bullet=True)
    add_p(doc, "Phát triển ứng dụng di động (Mobile App): Xây dựng ứng dụng native trên iOS và Android sử dụng Flutter hoặc React Native kết nối với Backend Java thông qua hệ thống RESTful APIs bảo mật bằng JWT (JSON Web Token).", bullet=True)
    add_p(doc, "Ứng dụng Trí tuệ Nhân tạo (AI & Machine Learning): Xây dựng mô hình phân tích học tập (Learning Analytics) dựa trên dữ liệu điểm số tích lũy để dự báo sớm nguy cơ sinh viên bị cảnh báo học tập hoặc trượt môn, từ đó tự động đưa ra các khuyến nghị đăng ký môn học và cải thiện kết quả học tập phù hợp cho từng cá nhân sinh viên.", bullet=True)

    # End of Conclusion -> Page Break
    doc.add_page_break()

    # TÀI LIỆU THAM KHẢO
    add_heading_1(doc, "TÀI LIỆU THAM KHẢO")

    add_p(doc, "Các tài liệu kỹ thuật, quy chế đào tạo và giáo trình học thuật được trích dẫn và tham khảo trong quá trình nghiên cứu và xây dựng hệ thống:")

    references_list = [
        "[1] Oracle Corporation, \"Java Platform, Standard Edition Documentation (JDK 17 LTS / JDK 21 LTS)\", Oracle Technology Network, 2023. [Online]. Available: https://docs.oracle.com/en/java/javase/",
        "[2] Jakarta EE Specification Committee, \"Jakarta Servlet Specification 4.0 / 5.0\", Eclipse Foundation, 2020. [Online]. Available: https://jakarta.ee/specifications/servlet/",
        "[3] Oracle Corporation, \"JavaServer Pages (JSP) v2.3 Specification & JSTL 1.2 Tag Library\", Oracle America, Inc., 2019.",
        "[4] Oracle Corporation, \"Oracle Database 23ai Free Documentation & SQL Language Reference\", Oracle Corporation, Redwood Shores, CA, 2024. [Online]. Available: https://docs.oracle.com/en/database/oracle/oracle-database/23/",
        "[5] Oracle Corporation, \"Oracle Database JDBC Developer's Guide (Release 23ai)\", Oracle Corporation, 2024.",
        "[6] Apache Software Foundation, \"Apache POI - the Java API for Microsoft Documents (Version 5.2.x)\", 2023. [Online]. Available: https://poi.apache.org/",
        "[7] Apache Software Foundation, \"Apache Tomcat 9.0 / 10.1 Architecture and Configuration Guide\", 2024. [Online]. Available: https://tomcat.apache.org/",
        "[8] Bộ Giáo dục và Đào tạo, \"Thông tư số 08/2021/TT-BGDĐT ban hành Quy chế đào tạo trình độ đại học\", Hà Nội, ngày 18 tháng 03 năm 2021.",
        "[9] Trường Đại học Giao thông Vận tải, \"Quy định đào tạo trình độ đại học theo hệ thống tín chỉ tại Trường Đại học Giao thông Vận tải\", ban hành kèm Quyết định của Hiệu trưởng, Hà Nội.",
        "[10] Joshua Bloch, \"Effective Java\", 3rd Edition, Addison-Wesley Professional, Boston, MA, 2018.",
        "[11] Cay S. Horstmann, \"Core Java Volume I--Fundamentals\", 12th Edition, Prentice Hall, 2022.",
        "[12] Martin Fowler, \"Patterns of Enterprise Application Architecture\", Addison-Wesley, Boston, MA, 2002.",
        "[13] Damien Miller, \"jBCrypt: A Java implementation of OpenBSD's Blowfish password hashing algorithm\", 2015. [Online]. Available: https://www.mindrot.org/projects/jBCrypt/",
        "[14] Open Web Application Security Project (OWASP), \"OWASP Top 10: The Ten Most Critical Web Application Security Risks\", OWASP Foundation, 2021."
    ]

    for ref in references_list:
        p_ref = doc.add_paragraph()
        p_ref.paragraph_format.space_before = Pt(2)
        p_ref.paragraph_format.space_after = Pt(4)
        p_ref.paragraph_format.left_indent = Cm(0.8)
        p_ref.paragraph_format.first_line_indent = Cm(-0.8)
        p_ref.paragraph_format.line_spacing = 1.2
        r = p_ref.add_run(ref)
        r.font.name = "Times New Roman"
        r.font.size = Pt(11)
        r.font.color.rgb = DARK_GRAY

    print("Appended Conclusion and References successfully.")

def main():
    print("Beginning generation of Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx...")
    doc = docx.Document()
    
    # Build all sections in sequence
    build_cover_and_intro(doc)
    build_chapter_1(doc)
    build_chapter_2(doc)
    build_chapter_3(doc)
    build_chapter_4(doc)
    build_conclusion_and_references(doc)

    out_root = "Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx"
    out_docs = os.path.join("docs", "Bao_Cao_Bai_Tap_Nhom_Quan_Ly_Diem_UTC.docx")

    doc.save(out_root)
    print(f"SUCCESS: Saved to root: {os.path.abspath(out_root)} ({os.path.getsize(out_root)} bytes)")

    os.makedirs("docs", exist_ok=True)
    doc.save(out_docs)
    print(f"SUCCESS: Saved to docs: {os.path.abspath(out_docs)} ({os.path.getsize(out_docs)} bytes)")

if __name__ == "__main__":
    main()
