<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Quản Lý Môn Học" />
<c:set var="activeMenu" value="subjects" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />

<div class="space-y-6">

    <!-- Header & Action -->
    <div class="bg-white rounded-xl border border-slate-200 p-5 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h1 class="text-xl font-bold text-slate-800 flex items-center">
                <i class="fa-solid fa-book-bookmark text-sky-600 mr-2.5"></i>Danh Mục Môn Học & Trọng Số Điểm
            </h1>
            <p class="text-xs text-slate-500 mt-1">Cấu hình linh hoạt trọng số % Chuyên cần, Giữa kỳ, Cuối kỳ theo từng đề cương môn học UTC</p>
        </div>

        <button type="button" onclick="openAddSubjectModal()"
                class="w-full sm:w-auto px-4 py-2.5 bg-utc-blue hover:bg-utc-dark text-white rounded-xl text-xs font-bold shadow-xs flex items-center justify-center space-x-1.5 transition">
            <i class="fa-solid fa-plus"></i>
            <span>Thêm Môn Học Mới</span>
        </button>
    </div>

    <!-- Subjects Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-xs text-slate-600">
                <thead class="bg-slate-50 text-slate-700 uppercase font-bold text-[11px] border-b border-slate-200">
                    <tr>
                        <th class="px-4 py-3.5">Mã Môn</th>
                        <th class="px-4 py-3.5">Tên Môn Học</th>
                        <th class="px-4 py-3.5 text-center">Số TC</th>
                        <th class="px-4 py-3.5 text-center">Chuyên cần (%)</th>
                        <th class="px-4 py-3.5 text-center">Giữa kỳ (%)</th>
                        <th class="px-4 py-3.5 text-center">Thi Cuối kỳ (%)</th>
                        <th class="px-4 py-3.5 text-center">Loại môn</th>
                        <th class="px-4 py-3.5 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="s" items="${subjects}">
                        <tr class="hover:bg-slate-50/80">
                            <td class="px-4 py-3 font-bold text-slate-800">${s.subjectId}</td>
                            <td class="px-4 py-3 font-medium text-slate-800">${s.subjectName}</td>
                            <td class="px-4 py-3 text-center font-bold text-utc-blue">${s.credits}</td>
                            <td class="px-4 py-3 text-center font-semibold text-slate-700">${s.percentAttendance}%</td>
                            <td class="px-4 py-3 text-center font-semibold text-slate-700">${s.percentMidterm}%</td>
                            <td class="px-4 py-3 text-center font-semibold text-slate-700">${s.percentFinal}%</td>
                            <td class="px-4 py-3 text-center">
                                <span class="px-2 py-0.5 rounded text-[11px] font-medium ${s.subjectType == 'TIN_CHI' ? 'bg-blue-50 text-utc-blue' : 'bg-slate-100 text-slate-600'}">
                                    ${s.subjectType == 'TIN_CHI' ? 'Tính Tín Chỉ' : 'Điều kiện (Không tính GPA)'}
                                </span>
                            </td>
                            <td class="px-4 py-3 text-center space-x-2">
                                <button type="button" 
                                        onclick="openEditSubjectModal('${s.subjectId}', '${s.subjectName}', '${s.credits}', '${s.percentAttendance}', '${s.percentMidterm}', '${s.percentFinal}', '${s.subjectType}')"
                                        class="p-1.5 rounded-lg text-slate-500 hover:text-utc-blue hover:bg-slate-100 transition" title="Chỉnh sửa">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <form action="${pageContext.request.contextPath}/admin/subjects" method="POST" class="inline" onsubmit="return confirm('Bạn có chắc muốn xóa môn học này?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="subjectId" value="${s.subjectId}">
                                    <button type="submit" class="p-1.5 rounded-lg text-slate-500 hover:text-rose-600 hover:bg-slate-100 transition" title="Xóa môn">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- Modal Thêm / Sửa Môn Học -->
<div id="subjectModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 hidden flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl max-w-md w-full shadow-2xl border border-slate-200 overflow-hidden max-h-[92vh] flex flex-col">
        <div class="p-4 sm:p-5 bg-slate-50 border-b border-slate-200 flex items-center justify-between flex-shrink-0">
            <h3 id="modalTitle" class="font-bold text-slate-800 text-xs sm:text-sm flex items-center">
                <i class="fa-solid fa-book text-utc-blue mr-2 text-base"></i>Thêm Môn Học Mới
            </h3>
            <button type="button" onclick="closeSubjectModal()" class="text-slate-400 hover:text-slate-600 p-1">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/subjects" method="POST" class="p-4 sm:p-6 space-y-4 overflow-y-auto flex-1">
            <input type="hidden" id="formAction" name="action" value="add">

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Mã môn học</label>
                <input type="text" id="modalSubjectId" name="subjectId" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue"
                       placeholder="Ví dụ: IT101">
            </div>

            <div>
                <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Tên môn học</label>
                <input type="text" id="modalSubjectName" name="subjectName" required
                       class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue"
                       placeholder="Ví dụ: Lập trình Java Cơ bản">
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Số tín chỉ</label>
                    <input type="number" id="modalCredits" name="credits" min="1" max="15" value="3" required
                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                </div>
                <div>
                    <label class="block text-xs font-semibold uppercase text-slate-600 mb-1.5">Loại môn</label>
                    <select id="modalSubjectType" name="subjectType" class="w-full px-3.5 py-2.5 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-utc-blue">
                        <option value="TIN_CHI">Tính Tín Chỉ</option>
                        <option value="DIEU_KIEN">Môn Điều Kiện</option>
                    </select>
                </div>
            </div>

            <div class="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-2">
                <div class="text-[11px] font-bold text-slate-700 uppercase tracking-wider">Cấu hình Trọng số % (Tổng phải = 100%)</div>
                <div class="grid grid-cols-3 gap-2">
                    <div>
                        <label class="block text-[10px] text-slate-500 font-medium mb-1">% Chuyên cần</label>
                        <input type="number" id="modalWeightCC" name="weightAttendance" min="0" max="100" value="10" required
                               class="w-full px-2 py-1.5 rounded-lg border border-slate-300 text-xs text-center font-bold">
                    </div>
                    <div>
                        <label class="block text-[10px] text-slate-500 font-medium mb-1">% Giữa kỳ</label>
                        <input type="number" id="modalWeightGK" name="weightMidterm" min="0" max="100" value="20" required
                               class="w-full px-2 py-1.5 rounded-lg border border-slate-300 text-xs text-center font-bold">
                    </div>
                    <div>
                        <label class="block text-[10px] text-slate-500 font-medium mb-1">% Thi cuối kỳ</label>
                        <input type="number" id="modalWeightThi" name="weightFinal" min="0" max="100" value="70" required
                               class="w-full px-2 py-1.5 rounded-lg border border-slate-300 text-xs text-center font-bold">
                    </div>
                </div>
            </div>

            <div class="flex flex-wrap items-center justify-end gap-2 pt-2 border-t border-slate-200">
                <button type="button" onclick="closeSubjectModal()"
                        class="flex-1 sm:flex-initial px-4 py-2 rounded-xl border border-slate-300 text-slate-700 text-xs font-semibold hover:bg-slate-100 transition text-center">
                    Hủy bỏ
                </button>
                <button type="submit"
                        class="flex-1 sm:flex-initial px-5 py-2 rounded-xl bg-utc-blue hover:bg-utc-dark text-white text-xs font-bold shadow-xs transition text-center">
                    Lưu Thông Tin
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddSubjectModal() {
        document.getElementById('formAction').value = 'add';
        document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-plus text-utc-blue mr-2"></i>Thêm Môn Học Mới';
        document.getElementById('modalSubjectId').value = '';
        document.getElementById('modalSubjectId').removeAttribute('readonly');
        document.getElementById('modalSubjectName').value = '';
        document.getElementById('modalCredits').value = 3;
        document.getElementById('modalWeightCC').value = 10;
        document.getElementById('modalWeightGK').value = 20;
        document.getElementById('modalWeightThi').value = 70;
        document.getElementById('modalSubjectType').value = 'TIN_CHI';
        document.getElementById('subjectModal').classList.remove('hidden');
    }

    function openEditSubjectModal(id, name, credits, cc, gk, thi, type) {
        document.getElementById('formAction').value = 'edit';
        document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-pen text-utc-blue mr-2"></i>Chỉnh Sửa Môn Học';
        document.getElementById('modalSubjectId').value = id;
        document.getElementById('modalSubjectId').setAttribute('readonly', 'readonly');
        document.getElementById('modalSubjectName').value = name;
        document.getElementById('modalCredits').value = credits;
        document.getElementById('modalWeightCC').value = cc;
        document.getElementById('modalWeightGK').value = gk;
        document.getElementById('modalWeightThi').value = thi;
        document.getElementById('modalSubjectType').value = type;
        document.getElementById('subjectModal').classList.remove('hidden');
    }

    function closeSubjectModal() {
        document.getElementById('subjectModal').classList.add('hidden');
    }
</script>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
