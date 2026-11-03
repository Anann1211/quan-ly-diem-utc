<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Đơn Phúc Khảo Điểm" />
<c:set var="activeMenu" value="appeals" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-file-pen text-amber-500 mr-2.5"></i>Đơn Đề Nghị Phúc Khảo Điểm Học Phần
            </h1>
            <p class="text-xs text-slate-500 mt-1">Nộp đơn phúc khảo trực tuyến trong thời hạn 7 ngày kể từ khi công bố kết quả điểm thi chính thức</p>
        </div>

        <button type="button" onclick="openNewAppealModal()"
                class="w-full sm:w-auto px-4 py-2.5 bg-amber-500 hover:bg-amber-600 text-white rounded-xl text-xs font-bold shadow flex items-center justify-center gap-1.5 transition">
            <i class="fa-solid fa-plus"></i>
            <span>Tạo Đơn Phúc Khảo Mới</span>
        </button>
    </div>

    <!-- Alert -->
    <c:if test="${param.msg == 'submitted'}">
        <div class="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-circle-check text-emerald-600"></i>
            <span>Đơn phúc khảo đã được gửi thành công đến Phòng Đào Tạo! Vui lòng theo dõi trạng thái tại bảng dưới.</span>
        </div>
    </c:if>
    <c:if test="${param.error == 'duplicate'}">
        <div class="p-3.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-triangle-exclamation text-amber-600"></i>
            <span>Môn học này đã có đơn phúc khảo đang chờ Phòng Đào Tạo xử lý. Bạn không thể nộp đơn trùng lặp!</span>
        </div>
    </c:if>
    <c:if test="${param.error == 'short_reason'}">
        <div class="p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center space-x-2">
            <i class="fa-solid fa-circle-exclamation text-rose-600"></i>
            <span>Lý do phúc khảo quá ngắn! Vui lòng mô tả chi tiết lý do đề nghị phúc khảo (ít nhất 5 ký tự).</span>
        </div>
    </c:if>

    <!-- Appeals Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">Mã Đơn</th>
                        <th class="px-4 py-3.5">Môn Học / Lớp HP</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Điểm Thi Cũ</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Điểm Thi Mới</th>
                        <th class="px-4 py-3.5">Lý do đề nghị phúc khảo</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Trạng thái</th>
                        <th class="px-4 py-3.5">Ngày nộp</th>
                        <th class="px-4 py-3.5">Phản hồi của Hội đồng</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="ap" items="${appeals}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 font-semibold text-slate-400">#${ap.id}</td>
                            <td class="px-4 py-3">
                                <div class="font-bold text-utc-blue">${ap.subjectName}</div>
                                <div class="text-[10px] text-slate-400">${ap.courseClassId}</div>
                            </td>
                            <td class="px-4 py-3 text-center font-bold text-slate-700">${ap.oldFinalScore}</td>
                            <td class="px-4 py-3 text-center font-bold text-emerald-600">
                                ${ap.newFinalScore != null ? ap.newFinalScore : '-'}
                            </td>
                            <td class="px-4 py-3 max-w-xs" title="${ap.reason}">
                                <div class="line-clamp-2">${ap.reason}</div>
                            </td>
                            <td class="px-4 py-3 whitespace-nowrap text-center">${ap.statusBadge}</td>
                            <td class="px-4 py-3 text-slate-500 whitespace-nowrap">
                                ${ap.submissionDate}
                            </td>
                            <td class="px-4 py-3 text-slate-500">
                                <c:choose>
                                    <c:when test="${not empty ap.note}">
                                        <div>${ap.note}</div>
                                        <div class="text-[10px] text-slate-400">Xử lý bởi: ${ap.processedBy}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-400 italic">Đang chờ giải quyết</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appeals}">
                        <tr>
                            <td colspan="8" class="px-4 py-10 text-center text-slate-400">Bạn chưa gửi đơn phúc khảo nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Nộp Đơn Phúc Khảo -->
<div id="appealModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-sm flex items-center">
                <i class="fa-solid fa-file-pen text-amber-500 mr-2"></i>Tạo Đơn Phúc Khảo Trực Tuyến
            </h3>
            <button type="button" onclick="closeNewAppealModal()" class="text-slate-400 hover:text-slate-600">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/student/submit-appeal" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Chọn Học phần cần phúc khảo</label>
                <select name="gradeId" id="selectGradeId" required class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-sm focus:ring-2 focus:ring-utc-blue">
                    <c:forEach var="ag" items="${availableGrades}">
                        <option value="${ag.id}" ${param.gradeId == ag.id ? 'selected' : ''}>
                            ${ag.subjectName} (Điểm thi: ${ag.scoreFinal != null ? ag.scoreFinal : 'Chưa có'})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Lý do đề nghị chấm lại chi tiết</label>
                <textarea name="reason" required rows="4"
                          class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-sm focus:ring-2 focus:ring-utc-blue"
                          placeholder="Nêu rõ câu hỏi, nội dung bài làm và lý do bạn cho rằng điểm số chưa chính xác..."></textarea>
            </div>

            <div class="p-3 bg-amber-50 rounded-xl border border-amber-200 text-[11px] text-amber-900 leading-relaxed">
                <i class="fa-solid fa-circle-exclamation mr-1 text-amber-600"></i>
                <strong>Lưu ý:</strong> Điểm sau khi chấm phúc khảo có thể tăng, giữ nguyên hoặc giảm tùy theo kết quả thẩm định thực tế của Hội đồng chấm thi UTC.
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-100">
                <button type="button" onclick="closeNewAppealModal()"
                        class="px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition flex-1 sm:flex-initial text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="px-5 py-2 rounded-xl bg-amber-500 hover:bg-amber-600 text-white text-xs font-bold shadow transition flex-1 sm:flex-initial text-center">
                    Gửi Đơn Phúc Khảo
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openNewAppealModal() {
        document.getElementById('appealModal').classList.remove('hidden');
    }
    function closeNewAppealModal() {
        document.getElementById('appealModal').classList.add('hidden');
    }

    // Auto open modal if gradeId passed in URL
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('gradeId')) {
            openNewAppealModal();
        }
    });
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
