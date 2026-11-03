<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Quản Lý Đơn Phúc Khảo" />
<c:set var="activeMenu" value="appeals" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-file-pen text-amber-500 mr-2.5"></i>Tiếp Nhận & Xử Lý Đơn Phúc Khảo
            </h1>
            <p class="text-xs text-slate-500 mt-1">Xử lý các đề nghị chấm phúc khảo học phần từ sinh viên trong thời hạn quy định</p>
        </div>
    </div>

    <!-- Feedback alert -->
    <c:if test="${param.msg == 'processed'}">
        <div class="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-sm flex items-center space-x-2">
            <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
            <span>Đã xử lý đơn phúc khảo thành công! Điểm mới đã được tính toán lại và lưu vào nhật ký Audit Log.</span>
        </div>
    </c:if>

    <!-- Appeals Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">Mã Đơn</th>
                        <th class="px-4 py-3.5">Mã SV & Họ Tên</th>
                        <th class="px-4 py-3.5">Môn Học / Lớp HP</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Điểm Thi Cũ</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Điểm Thi Mới</th>
                        <th class="px-4 py-3.5">Lý do phúc khảo</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Trạng thái</th>
                        <th class="px-4 py-3.5">Ghi chú xử lý</th>
                        <th class="px-4 py-3.5 whitespace-nowrap text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="ap" items="${appeals}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 font-semibold text-slate-500">#${ap.id}</td>
                            <td class="px-4 py-3">
                                <div class="font-bold text-slate-800">${ap.studentName}</div>
                                <div class="text-[10px] text-slate-500">${ap.studentId}</div>
                            </td>
                            <td class="px-4 py-3">
                                <div class="font-semibold text-utc-blue">${ap.subjectName}</div>
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
                            <td class="px-4 py-3 text-slate-500 text-[11px]">
                                <c:choose>
                                    <c:when test="${not empty ap.processedBy}">
                                        <div>${ap.note}</div>
                                        <div class="text-[10px] text-slate-400">Người duyệt: ${ap.processedBy}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-slate-400 italic">Chưa xử lý</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-4 py-3 text-center">
                                <c:if test="${ap.status == 'PENDING'}">
                                    <button type="button" 
                                            onclick="openProcessModal('${ap.id}', '${ap.studentName}', '${ap.subjectName}', '${ap.oldFinalScore}')"
                                            class="px-3 py-1.5 rounded-lg bg-utc-blue hover:bg-utc-dark text-white text-xs font-semibold shadow transition">
                                        Xử lý
                                    </button>
                                </c:if>
                                <c:if test="${ap.status != 'PENDING'}">
                                    <span class="text-slate-400 text-xs italic">Đã đóng</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appeals}">
                        <tr>
                            <td colspan="9" class="px-4 py-10 text-center text-slate-400">Chưa có đơn phúc khảo nào trong hệ thống.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Xử lý Phúc khảo -->
<div id="processModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-gavel text-utc-blue mr-2 text-base"></i>Quyết Định Xử Lý Phúc Khảo
            </h3>
            <button type="button" onclick="closeProcessModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/appeals" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" id="modalAppealId" name="appealId">

            <div class="bg-blue-50/70 p-3.5 rounded-xl border border-blue-100 text-xs space-y-1">
                <div>Sinh viên: <strong id="modalStudentName" class="text-slate-800"></strong></div>
                <div>Môn học: <strong id="modalSubjectName" class="text-slate-800"></strong></div>
                <div>Điểm thi cũ: <strong id="modalOldScore" class="text-amber-600 text-sm"></strong></div>
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Quyết định kết quả</label>
                <select name="status" id="modalStatus" onchange="toggleNewScoreInput()" required
                        class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs sm:text-sm focus:ring-2 focus:ring-utc-blue">
                    <option value="APPROVED">Chấp thuận (Thay đổi điểm)</option>
                    <option value="REJECTED">Từ chối (Giữ nguyên điểm cũ)</option>
                </select>
            </div>

            <div id="newScoreGroup">
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Điểm thi mới (Thang 10)</label>
                <input type="number" step="0.1" min="0" max="10" name="newFinalScore" id="modalNewFinalScore"
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs sm:text-sm focus:ring-2 focus:ring-utc-blue"
                       placeholder="Nhập điểm thi sau chấm lại...">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Ghi chú / Kết luận của Hội đồng</label>
                <textarea name="note" required rows="3"
                          class="w-full px-3.5 py-2 rounded-xl border border-slate-300 text-xs sm:text-sm focus:ring-2 focus:ring-utc-blue"
                          placeholder="Lý do điều chỉnh hoặc từ chối..."></textarea>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-200">
                <button type="button" onclick="closeProcessModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 rounded-xl bg-utc-blue hover:bg-utc-dark text-white text-xs font-bold shadow-xs transition text-center">
                    Lưu Quyết Định
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openProcessModal(id, stName, subName, oldScore) {
        document.getElementById('modalAppealId').value = id;
        document.getElementById('modalStudentName').textContent = stName;
        document.getElementById('modalSubjectName').textContent = subName;
        document.getElementById('modalOldScore').textContent = oldScore;
        document.getElementById('processModal').classList.remove('hidden');
    }

    function closeProcessModal() {
        document.getElementById('processModal').classList.add('hidden');
    }

    function toggleNewScoreInput() {
        const status = document.getElementById('modalStatus').value;
        const group = document.getElementById('newScoreGroup');
        const input = document.getElementById('modalNewFinalScore');
        if (status === 'REJECTED') {
            group.classList.add('hidden');
            input.removeAttribute('required');
        } else {
            group.classList.remove('hidden');
            input.setAttribute('required', 'required');
        }
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
