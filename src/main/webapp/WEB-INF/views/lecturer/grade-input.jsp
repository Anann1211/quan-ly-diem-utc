<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sổ Điểm Điện Tử - ${courseClass.className}" />
<c:set var="activeMenu" value="classes" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header Toolbar -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div>
            <div class="flex items-center space-x-2">
                <a href="${pageContext.request.contextPath}/lecturer/classes" class="text-slate-400 hover:text-slate-600 transition">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
                <span class="text-xs font-bold px-2 py-0.5 rounded bg-blue-100 text-utc-blue">${courseClass.classId}</span>
                <h1 class="text-lg font-bold text-slate-800">${courseClass.className}</h1>
                <div>${courseClass.statusBadge}</div>
            </div>
            <div class="text-xs text-slate-500 mt-1 flex flex-wrap gap-x-4 gap-y-1">
                <span>Môn: <strong>${courseClass.subjectName}</strong> (${courseClass.credits} TC)</span>
                <span>Trọng số: CC <strong>${courseClass.weightAttendance * 100}%</strong> - GK <strong>${courseClass.weightMidterm * 100}%</strong> - Thi <strong>${courseClass.weightFinal * 100}%</strong></span>
                <span>Phòng: <strong>${courseClass.room}</strong></span>
                <span>Sĩ số: <strong>${courseClass.enrolledCount}</strong></span>
            </div>
        </div>

        <!-- Excel Action Buttons -->
        <div class="flex flex-wrap items-center gap-2 w-full lg:w-auto">
            <a href="${pageContext.request.contextPath}/lecturer/export-excel?classId=${courseClass.classId}"
               class="flex-1 sm:flex-initial px-3.5 py-2 rounded-xl border border-emerald-600 text-emerald-700 hover:bg-emerald-50 text-xs font-bold flex items-center justify-center space-x-1.5 transition shadow-2xs">
                <i class="fa-solid fa-file-arrow-down text-sm"></i>
                <span>Xuất Mẫu Excel</span>
            </a>

            <c:choose>
                <c:when test="${courseClass.gradeStatus != 'PUBLISHED'}">
                    <button type="button" onclick="openImportModal()"
                            class="flex-1 sm:flex-initial px-3.5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
                        <i class="fa-solid fa-file-arrow-up text-sm"></i>
                        <span>Nhập Từ Excel</span>
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="button" disabled title="Bảng điểm đã được Phòng Đào Tạo phê duyệt và công bố"
                            class="flex-1 sm:flex-initial px-3.5 py-2 rounded-xl bg-slate-300 text-slate-500 text-xs font-bold shadow cursor-not-allowed flex items-center justify-center space-x-1.5">
                        <i class="fa-solid fa-lock text-sm"></i>
                        <span>Nhập Từ Excel (Đã công bố)</span>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <c:if test="${param.msg == 'saved'}">
        <div class="p-3.5 rounded-xl bg-blue-50 border border-blue-200 text-blue-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-circle-check text-blue-600"></i>
            <span>Đã lưu bản nháp điểm thành công! Điểm số đã được ghi vào hệ thống.</span>
        </div>
    </c:if>

    <c:if test="${param.msg == 'submitted'}">
        <div class="p-3.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-paper-plane text-amber-600"></i>
            <span>Bảng điểm đã được nộp lên Phòng Đào Tạo! Sổ điểm đã tạm khóa chờ phê duyệt.</span>
        </div>
    </c:if>

    <c:if test="${param.msg == 'imported'}">
        <div class="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-file-circle-check text-emerald-600"></i>
            <span>Đã import và đồng bộ dữ liệu điểm từ file Excel thành công!</span>
        </div>
    </c:if>

    <c:if test="${not empty param.errorMsg}">
        <div class="p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-triangle-exclamation text-rose-600"></i>
            <span><strong>Lỗi file Excel:</strong> ${param.errorMsg}</span>
        </div>
    </c:if>

    <!-- Class Histogram Chart -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm">
        <div class="flex items-center justify-between mb-2">
            <div class="text-xs font-bold text-slate-700 uppercase tracking-wider flex items-center">
                <i class="fa-solid fa-chart-column mr-1.5 text-utc-blue"></i>Phổ điểm hiện tại của lớp (A+ đến F)
            </div>
            <span class="text-[11px] text-slate-400">Tự động cập nhật theo kết quả nhập liệu</span>
        </div>
        <div class="h-28">
            <canvas id="gradeInputDistChart"></canvas>
        </div>
    </div>

    <!-- Grading Grid Form -->
    <form id="gradeForm" action="${pageContext.request.contextPath}/lecturer/save-grades" method="POST">
        <input type="hidden" name="classId" value="${courseClass.classId}">

        <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-4 bg-slate-50 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div class="text-xs text-slate-600">
                    <span class="font-bold text-slate-800"><i class="fa-solid fa-keyboard mr-1 text-slate-400"></i>Nhập điểm trực tiếp:</span>
                    Nhập điểm từ 0 đến 10 (hỗ trợ dấu chấm hoặc phẩy). Hệ thống sẽ tự động tính ngay điểm TK 10, Điểm Chữ và Thang 4.
                </div>

                <!-- Form Action Buttons -->
                <c:if test="${courseClass.gradeStatus != 'PUBLISHED'}">
                    <div class="flex flex-wrap items-center gap-2 w-full sm:w-auto">
                        <button type="submit" formaction="${pageContext.request.contextPath}/lecturer/save-grades"
                                class="flex-1 sm:flex-initial px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold border border-slate-300 transition flex items-center justify-center space-x-1 shadow-2xs">
                            <i class="fa-solid fa-floppy-disk text-slate-500"></i>
                            <span>Lưu Nháp</span>
                        </button>
                        <button type="submit" formaction="${pageContext.request.contextPath}/lecturer/submit-grades"
                                onclick="return confirm('Bạn có chắc chắn muốn NỘP ĐIỂM và KHÓA SỔ gửi lên Phòng Đào Tạo không?');"
                                class="flex-1 sm:flex-initial px-4 py-2 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1">
                            <i class="fa-solid fa-paper-plane"></i>
                            <span>Nộp Điểm & Khóa</span>
                        </button>
                    </div>
                </c:if>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left text-xs text-slate-600" id="gradeTable">
                    <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                        <tr>
                            <th class="px-3 py-3 text-center">STT</th>
                            <th class="px-3 py-3">Mã SV</th>
                            <th class="px-3 py-3">Họ và tên</th>
                            <th class="px-3 py-3">Lớp</th>
                            <th class="px-3 py-3 text-center w-24">CC (${courseClass.weightAttendance * 100}%)</th>
                            <th class="px-3 py-3 text-center w-24">GK (${courseClass.weightMidterm * 100}%)</th>
                            <th class="px-3 py-3 text-center w-24">Thi (${courseClass.weightFinal * 100}%)</th>
                            <th class="px-3 py-3 text-center w-20 bg-slate-100/70 text-slate-900 font-extrabold">TK 10</th>
                            <th class="px-3 py-3 text-center w-16">Chữ</th>
                            <th class="px-3 py-3 text-center w-16">Thang 4</th>
                            <th class="px-3 py-3 text-center w-20">Kết quả</th>
                            <th class="px-3 py-3">Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200 font-medium">
                        <c:forEach var="g" items="${grades}" varStatus="loop">
                            <tr class="hover:bg-slate-50/70 grade-row" 
                                data-id="${g.id}"
                                data-w-cc="${courseClass.weightAttendance}"
                                data-w-gk="${courseClass.weightMidterm}"
                                data-w-thi="${courseClass.weightFinal}">
                                <td class="px-3 py-2 text-center text-slate-400">${loop.index + 1}</td>
                                <td class="px-3 py-2 font-bold text-slate-800">${g.studentId}</td>
                                <td class="px-3 py-2 font-semibold text-slate-900">${g.studentName}</td>
                                <td class="px-3 py-2 text-slate-500">${g.className}</td>

                                <!-- Chuyên cần -->
                                <td class="px-2 py-1.5 text-center">
                                    <input type="number" step="0.1" min="0" max="10" name="cc_${g.id}" value="${g.scoreAttendance}"
                                           ${courseClass.gradeStatus == 'PUBLISHED' ? 'disabled' : ''}
                                           class="score-input input-cc w-16 px-2 py-1 rounded-lg border border-slate-300 text-xs text-center font-bold focus:ring-1 focus:ring-utc-blue">
                                </td>

                                <!-- Giữa kỳ -->
                                <td class="px-2 py-1.5 text-center">
                                    <input type="number" step="0.1" min="0" max="10" name="gk_${g.id}" value="${g.scoreMidterm}"
                                           ${courseClass.gradeStatus == 'PUBLISHED' ? 'disabled' : ''}
                                           class="score-input input-gk w-16 px-2 py-1 rounded-lg border border-slate-300 text-xs text-center font-bold focus:ring-1 focus:ring-utc-blue">
                                </td>

                                <!-- Thi cuối kỳ -->
                                <td class="px-2 py-1.5 text-center">
                                    <input type="number" step="0.1" min="0" max="10" name="thi_${g.id}" value="${g.scoreFinal}"
                                           ${courseClass.gradeStatus == 'PUBLISHED' ? 'disabled' : ''}
                                           class="score-input input-thi w-16 px-2 py-1 rounded-lg border border-slate-300 text-xs text-center font-bold focus:ring-1 focus:ring-utc-blue">
                                </td>

                                <!-- Điểm tổng kết 10 (Live computed) -->
                                <td class="px-3 py-2 text-center font-black text-slate-900 bg-slate-50 val-tk10">
                                    ${g.scoreTotal10 != null ? g.scoreTotal10 : '-'}
                                </td>

                                <!-- Điểm chữ (Live computed) -->
                                <td class="px-3 py-2 text-center text-sm font-bold val-letter">
                                    ${g.scoreLetter != null ? g.scoreLetter : '-'}
                                </td>

                                <!-- Điểm thang 4 (Live computed) -->
                                <td class="px-3 py-2 text-center font-bold text-slate-700 val-scale4">
                                    ${g.scoreScale4 != null ? g.scoreScale4 : '-'}
                                </td>

                                <!-- Kết quả đạt / học lại (Live computed) -->
                                <td class="px-3 py-2 text-center val-result">
                                    ${g.resultBadge}
                                </td>

                                <!-- Ghi chú -->
                                <td class="px-2 py-1.5">
                                    <input type="text" name="note_${g.id}" value="${g.note}"
                                           ${courseClass.gradeStatus == 'PUBLISHED' ? 'disabled' : ''}
                                           class="w-full px-2 py-1 rounded-lg border border-slate-200 text-xs text-slate-600 focus:ring-1 focus:ring-utc-blue"
                                           placeholder="Ghi chú...">
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Bottom Action Footer -->
            <c:if test="${courseClass.gradeStatus != 'PUBLISHED'}">
                <div class="p-4 bg-slate-50 border-t border-slate-200 flex flex-wrap items-center justify-end gap-2">
                    <button type="submit" formaction="${pageContext.request.contextPath}/lecturer/save-grades"
                            class="flex-1 sm:flex-initial px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold border border-slate-300 transition flex items-center justify-center space-x-1.5 shadow-2xs">
                        <i class="fa-solid fa-floppy-disk text-slate-500"></i>
                        <span>Lưu Bản Nháp</span>
                    </button>
                    <button type="submit" formaction="${pageContext.request.contextPath}/lecturer/submit-grades"
                            onclick="return confirm('Bạn có chắc chắn muốn NỘP ĐIỂM và KHÓA SỔ gửi lên Phòng Đào Tạo không?');"
                            class="flex-1 sm:flex-initial px-6 py-2.5 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs transition flex items-center justify-center space-x-1.5">
                        <i class="fa-solid fa-paper-plane"></i>
                        <span>Nộp Điểm & Khóa Sổ</span>
                    </button>
                </div>
            </c:if>
        </div>
    </form>

</div>

<!-- Modal Upload Excel -->
<div id="importModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-file-excel text-emerald-600 mr-2 text-base"></i>Nhập Điểm Từ File Excel (.xlsx)
            </h3>
            <button type="button" onclick="closeImportModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/lecturer/import-excel" method="POST" enctype="multipart/form-data" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" name="classId" value="${courseClass.classId}">

            <div class="text-xs text-slate-600 space-y-1 bg-emerald-50/60 p-3.5 rounded-xl border border-emerald-100">
                <div class="font-bold text-emerald-900 text-xs">Hướng dẫn tải file:</div>
                <p>1. Hãy bấm <a href="${pageContext.request.contextPath}/lecturer/export-excel?classId=${courseClass.classId}" class="underline font-bold text-emerald-700">Xuất Mẫu Excel</a> để có file đúng cấu trúc.</p>
                <p>2. Nhập điểm vào cột <strong>Điểm CC, Điểm GK, Điểm Thi</strong>.</p>
                <p>3. Chọn file vừa nhập và bấm "Tải Lên & Cập Nhật".</p>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-2">Chọn file Excel (.xlsx)</label>
                <input type="file" name="excelFile" accept=".xlsx" required
                       class="w-full text-xs text-slate-500 file:mr-3 file:py-2 file:px-3 file:rounded-xl file:border-0 file:text-xs file:font-semibold file:bg-emerald-50 file:text-emerald-700 hover:file:bg-emerald-100">
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-200">
                <button type="button" onclick="closeImportModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-xs transition text-center">
                    Tải Lên & Cập Nhật
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Realtime Client-side Grade Calculation & Chart Script -->
<script>
    function openImportModal() {
        document.getElementById('importModal').classList.remove('hidden');
    }
    function closeImportModal() {
        document.getElementById('importModal').classList.add('hidden');
    }

    // Client-side realtime calculation
    document.addEventListener("DOMContentLoaded", function () {
        const rows = document.querySelectorAll('.grade-row');

        rows.forEach(row => {
            const inputCC = row.querySelector('.input-cc');
            const inputGK = row.querySelector('.input-gk');
            const inputThi = row.querySelector('.input-thi');

            const wCC = parseFloat(row.getAttribute('data-w-cc'));
            const wGK = parseFloat(row.getAttribute('data-w-gk'));
            const wThi = parseFloat(row.getAttribute('data-w-thi'));

            function recalculateRow() {
                const valCC = parseFloat(inputCC.value) || 0;
                const valGK = parseFloat(inputGK.value) || 0;
                const strThi = inputThi.value.trim();

                const cellTK10 = row.querySelector('.val-tk10');
                const cellLetter = row.querySelector('.val-letter');
                const cellScale4 = row.querySelector('.val-scale4');
                const cellResult = row.querySelector('.val-result');

                if (strThi === '') {
                    cellTK10.textContent = '-';
                    cellLetter.textContent = '-';
                    cellLetter.className = 'px-3 py-2 text-center text-sm font-bold val-letter text-slate-400';
                    cellScale4.textContent = '-';
                    cellResult.innerHTML = '<span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-slate-100 text-slate-600">Chưa xét</span>';
                    return;
                }

                const valThi = parseFloat(strThi);
                if (isNaN(valThi)) return;

                // Công thức tính tổng kết 10 chuẩn UTC
                let total10 = valCC * wCC + valGK * wGK + valThi * wThi;
                total10 = Math.round(total10 * 10) / 10;

                // Quy đổi sang điểm chữ UTC
                let letter = "F";
                let scale4 = 0.0;
                let colorClass = "text-rose-600";

                if (total10 >= 9.5) { letter = "A+"; scale4 = 4.0; colorClass = "text-emerald-600"; }
                else if (total10 >= 8.5) { letter = "A"; scale4 = 3.8; colorClass = "text-emerald-600"; }
                else if (total10 >= 8.0) { letter = "B+"; scale4 = 3.5; colorClass = "text-blue-600"; }
                else if (total10 >= 7.0) { letter = "B"; scale4 = 3.0; colorClass = "text-blue-600"; }
                else if (total10 >= 6.0) { letter = "C+"; scale4 = 2.5; colorClass = "text-amber-600"; }
                else if (total10 >= 5.5) { letter = "C"; scale4 = 2.0; colorClass = "text-amber-600"; }
                else if (total10 >= 4.5) { letter = "D+"; scale4 = 1.5; colorClass = "text-orange-600"; }
                else if (total10 >= 4.0) { letter = "D"; scale4 = 1.0; colorClass = "text-orange-600"; }
                else if (total10 >= 2.0) { letter = "F+"; scale4 = 0.5; colorClass = "text-rose-600"; }
                else { letter = "F"; scale4 = 0.0; colorClass = "text-rose-600"; }

                cellTK10.textContent = total10.toFixed(1);
                cellLetter.textContent = letter;
                cellLetter.className = 'px-3 py-2 text-center text-sm font-bold val-letter ' + colorClass;
                cellScale4.textContent = scale4.toFixed(1);

                if (total10 >= 4.0) {
                    cellResult.innerHTML = '<span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-emerald-100 text-emerald-800"><i class="fa-solid fa-check mr-1"></i>Đạt</span>';
                } else {
                    cellResult.innerHTML = '<span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-rose-100 text-rose-800"><i class="fa-solid fa-xmark mr-1"></i>Học lại</span>';
                }
            }

            inputCC.addEventListener('input', recalculateRow);
            inputGK.addEventListener('input', recalculateRow);
            inputThi.addEventListener('input', recalculateRow);
        });

        // Initialize histogram chart
        const ctx = document.getElementById('gradeInputDistChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F+', 'F'],
                datasets: [{
                    label: 'Sinh viên',
                    data: [
                        ${dist['A+'] != null ? dist['A+'] : 0},
                        ${dist['A'] != null ? dist['A'] : 0},
                        ${dist['B+'] != null ? dist['B+'] : 0},
                        ${dist['B'] != null ? dist['B'] : 0},
                        ${dist['C+'] != null ? dist['C+'] : 0},
                        ${dist['C'] != null ? dist['C'] : 0},
                        ${dist['D+'] != null ? dist['D+'] : 0},
                        ${dist['D'] != null ? dist['D'] : 0},
                        ${dist['F+'] != null ? dist['F+'] : 0},
                        ${dist['F'] != null ? dist['F'] : 0}
                    ],
                    backgroundColor: '#003366',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
