<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Tra Cứu Bảng Điểm Theo Khoa & Lớp" />
<c:set var="activeMenu" value="faculty-grades" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-layer-group text-utc-blue mr-2.5"></i>Tra Cứu Bảng Điểm Theo Khoa, Khóa & Lớp Chuyên Ngành
            </h1>
            <p class="text-xs text-slate-500 mt-1">
                Lọc phân cấp 4 bước: <b>Khóa học</b> &rarr; <b>Khoa quản lý</b> &rarr; <b>Lớp chuyên ngành</b> &rarr; <b>Môn học</b> để xem toàn bộ sổ điểm cả lớp
            </p>
        </div>

        <c:if test="${not empty grades && not empty selectedClassId && not empty selectedSubjectId}">
            <div class="w-full sm:w-auto">
                <a href="${pageContext.request.contextPath}/admin/faculty-grades?intakeYear=${selectedIntakeYear}&facultyId=${selectedFaculty}&classId=${selectedClassId}&subjectId=${selectedSubjectId}&export=excel"
                   class="w-full sm:w-auto px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold shadow flex items-center justify-center gap-1.5 transition">
                    <i class="fa-solid fa-file-excel"></i>
                    <span>Xuất Sổ Điểm Excel</span>
                </a>
            </div>
        </c:if>
    </div>

    <!-- 4-Step Filter Bar -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm p-5">
        <form action="${pageContext.request.contextPath}/admin/faculty-grades" method="GET" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <!-- Bước 1: Khóa học -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center">
                        <span class="w-5 h-5 rounded-full bg-utc-blue text-white text-[10px] inline-flex items-center justify-center mr-1.5 font-bold">1</span>
                        Chọn Khóa học
                    </label>
                    <select name="intakeYear" onchange="this.form.submit()"
                            class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                        <option value="">-- Tất cả các Khóa --</option>
                        <c:forEach var="yr" items="${intakeYears}">
                            <option value="${yr}" ${selectedIntakeYear == yr ? 'selected' : ''}>Khóa K${yr}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Bước 2: Khoa -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center">
                        <span class="w-5 h-5 rounded-full bg-utc-blue text-white text-[10px] inline-flex items-center justify-center mr-1.5 font-bold">2</span>
                        Chọn Khoa / Viện
                    </label>
                    <select name="facultyId" onchange="this.form.submit()"
                            class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                        <option value="">-- Chọn Khoa quản lý --</option>
                        <c:forEach var="f" items="${faculties}">
                            <option value="${f.facultyId}" ${selectedFaculty == f.facultyId ? 'selected' : ''}>${f.facultyName}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Bước 3: Lớp chuyên ngành -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center">
                        <span class="w-5 h-5 rounded-full bg-utc-blue text-white text-[10px] inline-flex items-center justify-center mr-1.5 font-bold">3</span>
                        Chọn Lớp chuyên ngành
                    </label>
                    <select name="classId" onchange="this.form.submit()"
                            class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                        <option value="">-- Chọn Lớp --</option>
                        <c:forEach var="cl" items="${classes}">
                            <option value="${cl.classId}" ${selectedClassId == cl.classId ? 'selected' : ''}>
                                ${cl.classId} (${cl.className})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Bước 4: Môn học -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5 flex items-center">
                        <span class="w-5 h-5 rounded-full bg-utc-blue text-white text-[10px] inline-flex items-center justify-center mr-1.5 font-bold">4</span>
                        Chọn Môn học
                    </label>
                    <select name="subjectId" onchange="this.form.submit()"
                            class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                        <option value="">-- Chọn Môn học --</option>
                        <c:forEach var="s" items="${subjects}">
                            <option value="${s.subjectId}" ${selectedSubjectId == s.subjectId ? 'selected' : ''}>
                                ${s.subjectId} - ${s.subjectName} (${s.credits} TC)
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </form>
    </div>

    <!-- Results Section -->
    <c:choose>
        <c:when test="${not empty grades && not empty selectedClassId && not empty selectedSubjectId}">
            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div class="bg-white rounded-xl border border-slate-200 p-4 shadow-sm flex items-center space-x-3.5">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 text-utc-blue flex items-center justify-center font-bold text-lg">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <div>
                        <div class="text-[11px] font-semibold uppercase text-slate-400">Sĩ số lớp</div>
                        <div class="text-lg font-bold text-slate-800">${totalStudents} sinh viên</div>
                    </div>
                </div>

                <div class="bg-white rounded-xl border border-slate-200 p-4 shadow-sm flex items-center space-x-3.5">
                    <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-lg">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div>
                        <div class="text-[11px] font-semibold uppercase text-slate-400">Đạt học phần</div>
                        <div class="text-lg font-bold text-emerald-600">${passCount} SV (${passRate}%)</div>
                    </div>
                </div>

                <div class="bg-white rounded-xl border border-slate-200 p-4 shadow-sm flex items-center space-x-3.5">
                    <div class="w-10 h-10 rounded-xl bg-rose-50 text-rose-600 flex items-center justify-center font-bold text-lg">
                        <i class="fa-solid fa-circle-xmark"></i>
                    </div>
                    <div>
                        <div class="text-[11px] font-semibold uppercase text-slate-400">Không đạt / Học lại</div>
                        <div class="text-lg font-bold text-rose-600">${failCount} SV (${failRate}%)</div>
                    </div>
                </div>

                <div class="bg-white rounded-xl border border-slate-200 p-4 shadow-sm flex items-center space-x-3.5">
                    <div class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center font-bold text-lg">
                        <i class="fa-solid fa-calculator"></i>
                    </div>
                    <div>
                        <div class="text-[11px] font-semibold uppercase text-slate-400">Điểm TB Lớp (Hệ 10)</div>
                        <div class="text-lg font-bold text-amber-600">${averageScore10} / 10.0</div>
                    </div>
                </div>
            </div>

            <!-- Grade Table -->
            <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-4 bg-slate-50 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <h3 class="font-bold text-slate-800 text-xs uppercase flex items-center">
                        <i class="fa-solid fa-table-list mr-2 text-utc-blue"></i>
                        Bảng Điểm Chi Tiết: ${selectedClass.className} - Môn: ${selectedSubject.subjectName} (${selectedSubject.subjectId})
                    </h3>
                    <span class="text-[11px] text-slate-500">Cập nhật theo dữ liệu thực tế UTC</span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full text-left text-xs text-slate-600">
                        <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                            <tr>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">STT</th>
                                <th class="px-4 py-3.5 whitespace-nowrap">Mã SV</th>
                                <th class="px-4 py-3.5 whitespace-nowrap">Họ và tên</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Chuyên cần (10%)</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Giữa kỳ (30%)</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Cuối kỳ (60%)</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Điểm TK (Hệ 10)</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Điểm Chữ</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Hệ 4</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Kết quả</th>
                                <th class="px-4 py-3.5 text-center whitespace-nowrap">Trạng thái điểm</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <c:forEach var="g" items="${grades}" varStatus="loop">
                                <tr class="hover:bg-slate-50/80">
                                    <td class="px-4 py-3 text-center text-slate-400 font-medium">${loop.index + 1}</td>
                                    <td class="px-4 py-3 font-bold text-slate-800 font-mono">${g.studentId}</td>
                                    <td class="px-4 py-3 font-semibold text-slate-800">${g.studentName}</td>
                                    <td class="px-4 py-3 text-center font-mono">
                                        <c:choose>
                                            <c:when test="${not empty g.scoreAttendance}">${g.scoreAttendance}</c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center font-mono">
                                        <c:choose>
                                            <c:when test="${not empty g.scoreMidterm}">${g.scoreMidterm}</c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center font-mono">
                                        <c:choose>
                                            <c:when test="${not empty g.scoreFinal}">${g.scoreFinal}</c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center font-bold text-slate-900 font-mono">
                                        <c:choose>
                                            <c:when test="${not empty g.scoreTotal10}">${g.scoreTotal10}</c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center font-bold">
                                        <c:choose>
                                            <c:when test="${g.scoreLetter == 'A' || g.scoreLetter == 'A+'}">
                                                <span class="text-emerald-600 font-bold">${g.scoreLetter}</span>
                                            </c:when>
                                            <c:when test="${g.scoreLetter == 'B' || g.scoreLetter == 'B+'}">
                                                <span class="text-blue-600 font-bold">${g.scoreLetter}</span>
                                            </c:when>
                                            <c:when test="${g.scoreLetter == 'C' || g.scoreLetter == 'C+'}">
                                                <span class="text-amber-600 font-bold">${g.scoreLetter}</span>
                                            </c:when>
                                            <c:when test="${g.scoreLetter == 'D' || g.scoreLetter == 'D+'}">
                                                <span class="text-orange-600 font-bold">${g.scoreLetter}</span>
                                            </c:when>
                                            <c:when test="${g.scoreLetter == 'F' || g.scoreLetter == 'F+'}">
                                                <span class="text-rose-600 font-bold">${g.scoreLetter}</span>
                                            </c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center font-mono">
                                        <c:choose>
                                            <c:when test="${not empty g.scoreScale4}">${g.scoreScale4}</c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${g.result == 'DAT'}">
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                                    Đạt
                                                </span>
                                            </c:when>
                                            <c:when test="${g.result == 'KHONG_DAT'}">
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800">
                                                    Học lại
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-slate-300">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-4 py-3 text-center whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${g.gradeStatus == 'PUBLISHED'}">
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800">
                                                    Đã công bố
                                                </span>
                                            </c:when>
                                            <c:when test="${g.gradeStatus == 'SUBMITTED'}">
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">
                                                    Chờ duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${g.gradeStatus == 'DRAFT'}">
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 text-slate-700">
                                                    Bản nháp
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center whitespace-nowrap px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 text-slate-400">
                                                    Chưa có điểm
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Guide Box when no class or subject selected -->
            <div class="bg-white rounded-xl border border-slate-200 p-12 text-center shadow-sm">
                <i class="fa-solid fa-arrow-pointer text-4xl text-slate-300 mb-3 block"></i>
                <h3 class="font-bold text-slate-700 text-sm">Vui lòng chọn đầy đủ 4 bước lọc ở trên</h3>
                <p class="text-xs text-slate-400 mt-1 max-w-md mx-auto">
                    Chọn <b>Khóa học</b> &rarr; <b>Khoa</b> &rarr; <b>Lớp chuyên ngành</b> &rarr; <b>Môn học</b> để hệ thống tự động tải bảng điểm của cả lớp theo học chế tín chỉ.
                </p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
