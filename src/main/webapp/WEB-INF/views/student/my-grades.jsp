<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Tra Cứu Bảng Điểm Cá Nhân" />
<c:set var="activeMenu" value="grades" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Student Info & Summary Card -->
    <div class="bg-gradient-to-r from-utc-blue via-utc-dark to-slate-900 rounded-2xl p-6 text-white shadow-md">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-white/10">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 rounded-2xl bg-white/10 border border-white/20 flex items-center justify-center text-3xl text-amber-400">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <div>
                    <div class="flex items-center space-x-2">
                        <h1 class="text-2xl font-bold">${sessionScope.currentStudent.fullName}</h1>
                        <span class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-amber-400/20 text-amber-300 border border-amber-400/30">
                            ${academicRank}
                        </span>
                    </div>
                    <div class="text-xs text-slate-300 mt-1 flex flex-wrap gap-x-4 gap-y-1">
                        <span>Mã SV: <strong>${sessionScope.currentStudent.studentId}</strong></span>
                        <span>Lớp: <strong>${sessionScope.currentStudent.className}</strong></span>
                        <span>Ngành: <strong>${sessionScope.currentStudent.majorName}</strong></span>
                        <span>Khoa: <strong>${sessionScope.currentStudent.facultyName}</strong></span>
                    </div>
                </div>
            </div>

            <div class="flex flex-wrap items-center gap-2 w-full md:w-auto">
                <a href="${pageContext.request.contextPath}/student/print-transcript" target="_blank"
                   class="flex-1 sm:flex-initial px-4 py-2 bg-white/10 hover:bg-white/20 border border-white/20 text-white rounded-xl text-xs font-semibold backdrop-blur-sm transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-print"></i>
                    <span>In Bảng Điểm</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/appeals"
                   class="flex-1 sm:flex-initial px-4 py-2 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs font-semibold shadow-xs transition flex items-center justify-center space-x-1.5">
                    <i class="fa-solid fa-file-pen"></i>
                    <span>Đơn Phúc Khảo</span>
                </a>
            </div>
        </div>

        <!-- Metric KPI Cards -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 pt-6">
            <div class="bg-white/5 rounded-xl p-3 border border-white/10">
                <div class="text-[11px] text-slate-300 uppercase tracking-wider">GPA Học Kỳ Này</div>
                <div class="text-2xl font-black text-white mt-1">${semesterGpa != null ? semesterGpa : '0.0'}</div>
                <div class="text-[10px] text-slate-400">Thang điểm 4.0</div>
            </div>

            <div class="bg-white/5 rounded-xl p-3 border border-white/10">
                <div class="text-[11px] text-slate-300 uppercase tracking-wider">Điểm Tích Lũy (CPA)</div>
                <div class="text-2xl font-black text-amber-400 mt-1">${sessionScope.currentStudent.cpa != null ? sessionScope.currentStudent.cpa : '0.0'}</div>
                <div class="text-[10px] text-slate-400">Toàn khóa học</div>
            </div>

            <div class="bg-white/5 rounded-xl p-3 border border-white/10">
                <div class="text-[11px] text-slate-300 uppercase tracking-wider">Số Tín Chỉ Tích Lũy</div>
                <div class="text-2xl font-black text-emerald-400 mt-1">${sessionScope.currentStudent.totalCredits != null ? sessionScope.currentStudent.totalCredits : 0} TC</div>
                <div class="text-[10px] text-slate-400">Học phần đạt (D trở lên)</div>
            </div>

            <div class="bg-white/5 rounded-xl p-3 border border-white/10">
                <div class="text-[11px] text-slate-300 uppercase tracking-wider">Tình Trạng Học Vụ</div>
                <div class="text-sm font-bold text-white mt-2 truncate" title="${academicWarning}">
                    <c:choose>
                        <c:when test="${academicWarning == 'Bình thường'}">
                            <span class="text-emerald-400"><i class="fa-solid fa-circle-check mr-1"></i>Bình thường</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-rose-400"><i class="fa-solid fa-triangle-exclamation mr-1"></i>${academicWarning}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="text-[10px] text-slate-400">Chuẩn quy chế UTC</div>
            </div>
        </div>
    </div>

    <!-- Filter by Semester -->
    <div class="bg-white rounded-xl border border-slate-200 p-4 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div class="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center">
            <i class="fa-solid fa-filter mr-1.5 text-utc-blue"></i>Lọc kết quả theo học kỳ:
        </div>

        <form action="${pageContext.request.contextPath}/student/grades" method="GET" class="w-full sm:w-auto">
            <select name="semesterId" onchange="this.form.submit()"
                    class="w-full sm:w-auto px-3.5 py-1.5 rounded-xl border border-slate-300 text-xs font-semibold focus:ring-2 focus:ring-utc-blue bg-slate-50">
                <option value="">Toàn bộ quá trình học tập</option>
                <c:forEach var="sem" items="${semesters}">
                    <option value="${sem.semesterId}" ${selectedSemester == sem.semesterId ? 'selected' : ''}>
                        ${sem.displayName}
                    </option>
                </c:forEach>
            </select>
        </form>
    </div>

    <!-- Grades Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5 text-center">STT</th>
                        <th class="px-4 py-3.5">Mã Môn</th>
                        <th class="px-4 py-3.5">Tên Học Phần</th>
                        <th class="px-4 py-3.5 text-center">Số TC</th>
                        <th class="px-4 py-3.5 text-center">Học Kỳ</th>
                        <th class="px-4 py-3.5 text-center">Điểm CC</th>
                        <th class="px-4 py-3.5 text-center">Điểm GK</th>
                        <th class="px-4 py-3.5 text-center">Điểm Thi</th>
                        <th class="px-4 py-3.5 text-center bg-slate-100/70 text-slate-900 font-extrabold">Tổng kết 10</th>
                        <th class="px-4 py-3.5 text-center">Điểm Chữ</th>
                        <th class="px-4 py-3.5 text-center">Thang 4</th>
                        <th class="px-4 py-3.5 text-center">Kết Quả</th>
                        <th class="px-4 py-3.5 text-center no-print">Phúc Khảo</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="g" items="${grades}" varStatus="loop">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 text-center text-slate-400">${loop.index + 1}</td>
                            <td class="px-4 py-3 font-bold text-slate-800">${g.subjectId}</td>
                            <td class="px-4 py-3 font-semibold text-slate-900">${g.subjectName}</td>
                            <td class="px-4 py-3 text-center font-bold text-utc-blue">${g.credits}</td>
                            <td class="px-4 py-3 text-center text-slate-500">${g.semesterName}</td>
                            <td class="px-4 py-3 text-center">${g.scoreAttendance != null ? g.scoreAttendance : '-'}</td>
                            <td class="px-4 py-3 text-center">${g.scoreMidterm != null ? g.scoreMidterm : '-'}</td>
                            <td class="px-4 py-3 text-center font-bold ${g.scoreFinal != null && g.scoreFinal < 4.0 ? 'text-rose-600' : 'text-slate-800'}">
                                ${g.scoreFinal != null ? g.scoreFinal : '-'}
                            </td>
                            <td class="px-4 py-3 text-center font-black text-slate-900 bg-slate-50">
                                ${g.scoreTotal10 != null ? g.scoreTotal10 : '-'}
                            </td>
                            <td class="px-4 py-3 text-center text-sm">${g.letterBadge}</td>
                            <td class="px-4 py-3 text-center font-bold text-slate-700">${g.scoreScale4 != null ? g.scoreScale4 : '-'}</td>
                            <td class="px-4 py-3 text-center">${g.resultBadge}</td>
                            <td class="px-4 py-3 text-center no-print">
                                <a href="${pageContext.request.contextPath}/student/appeals?gradeId=${g.id}"
                                   class="px-2.5 py-1 rounded-lg bg-amber-50 hover:bg-amber-100 text-amber-800 font-semibold text-[11px] transition inline-flex items-center">
                                    <i class="fa-solid fa-file-pen mr-1"></i>Phúc khảo
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty grades}">
                        <tr>
                            <td colspan="13" class="px-4 py-12 text-center text-slate-400">
                                Chưa có dữ liệu bảng điểm nào cho học kỳ được chọn.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
