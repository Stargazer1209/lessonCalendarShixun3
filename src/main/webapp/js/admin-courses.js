// 管理员课程管理页面 JavaScript

// 存储课程数据
let coursesData = {};

/**
 * 筛选课程
 */
function filterCourses() {
    const userFilter = document.getElementById('userFilter').value;
    const dayFilter = document.getElementById('dayFilter').value;
    const rows = document.querySelectorAll('#coursesTable tbody tr');
    
    rows.forEach(row => {
        const userId = row.getAttribute('data-user-id');
        const dayOfWeek = row.getAttribute('data-day');
        
        let showRow = true;
        
        // 按用户筛选
        if (userFilter && userId !== userFilter) {
            showRow = false;
        }
        
        // 按星期筛选
        if (dayFilter && dayOfWeek !== dayFilter) {
            showRow = false;
        }
        
        row.style.display = showRow ? '' : 'none';
    });
}

/**
 * 清除筛选条件
 */
function clearFilters() {
    document.getElementById('userFilter').value = '';
    document.getElementById('dayFilter').value = '';
    filterCourses();
}

/**
 * 查看课程详情
 */
function viewCourse(courseId) {
    // 使用AJAX获取课程详情
    fetch(`${window.location.pathname}?action=getCourseDetails&courseId=${courseId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showCourseDetails(data.course, data.owner);
            } else {
                alert('获取课程信息失败：' + (data.message || '未知错误'));
            }
        })
        .catch(error => {
            console.error('获取课程详情失败:', error);
            alert('获取课程信息失败，请稍后重试');
        });
}

/**
 * 显示课程详情
 */
function showCourseDetails(course, owner) {
    const dayNames = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    const detailsHtml = `
        <div class="detail-item">
            <div class="detail-label">课程名称:</div>
            <div class="detail-value">${course.courseName}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">授课教师:</div>
            <div class="detail-value">${course.instructor || '-'}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">教室:</div>
            <div class="detail-value">${course.classroom || '-'}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">上课时间:</div>
            <div class="detail-value">${dayNames[course.dayOfWeek]} ${course.startTime} - ${course.endTime}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">周次:</div>
            <div class="detail-value">${course.weekStart && course.weekEnd ? `第${course.weekStart}-${course.weekEnd}周` : '-'}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">课程类型:</div>
            <div class="detail-value">${course.courseType || '-'}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">学分:</div>
            <div class="detail-value">${course.credits > 0 ? course.credits + '学分' : '-'}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">所属用户:</div>
            <div class="detail-value">${owner ? `${owner.fullName} (${owner.email})` : '未知用户'}</div>
        </div>
        ${course.description ? `
        <div class="detail-item">
            <div class="detail-label">课程描述:</div>
            <div class="detail-value">${course.description}</div>
        </div>
        ` : ''}
    `;
    
    document.getElementById('viewCourseDetails').innerHTML = detailsHtml;
    openModal('viewModal');
}

/**
 * 编辑课程
 */
function editCourse(courseId) {
    // 使用AJAX获取课程详情
    fetch(`${window.location.pathname}?action=getCourseDetails&courseId=${courseId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showEditForm(data.course);
            } else {
                alert('获取课程信息失败：' + (data.message || '未知错误'));
            }
        })
        .catch(error => {
            console.error('获取课程详情失败:', error);
            alert('获取课程信息失败，请稍后重试');
        });
}

/**
 * 显示编辑表单
 */
function showEditForm(course) {
    // 填充表单数据
    document.getElementById('editCourseId').value = course.courseId;
    document.getElementById('editCourseName').value = course.courseName;
    document.getElementById('editInstructor').value = course.instructor || '';
    document.getElementById('editClassroom').value = course.classroom || '';
    document.getElementById('editDayOfWeek').value = course.dayOfWeek;
    document.getElementById('editStartTime').value = course.startTime;
    document.getElementById('editEndTime').value = course.endTime;
    document.getElementById('editWeekStart').value = course.weekStart || '';
    document.getElementById('editWeekEnd').value = course.weekEnd || '';
    document.getElementById('editCredits').value = course.credits || '';
    document.getElementById('editCourseType').value = course.courseType || '';
    document.getElementById('editDescription').value = course.description || '';
    
    openModal('editModal');
}

/**
 * 提交编辑表单
 */
function submitEditForm(event) {
    event.preventDefault();
    
    const form = document.getElementById('editCourseForm');
    const formData = new FormData(form);
    
    // 验证时间
    const startTime = formData.get('startTime');
    const endTime = formData.get('endTime');
    if (startTime >= endTime) {
        alert('开始时间必须早于结束时间！');
        return;
    }
    
    // 显示提交状态
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.textContent;
    submitBtn.textContent = '保存中...';
    submitBtn.disabled = true;
    
    // 提交表单
    fetch(window.location.pathname, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.redirected) {
            // 如果服务器返回重定向，直接跳转
            window.location.href = response.url;
        } else {
            return response.text();
        }
    })
    .then(data => {
        if (data) {
            // 如果有返回数据，说明可能有错误
            console.log('Response:', data);
        }
        // 正常情况下会重定向，这里作为备用
        window.location.reload();
    })
    .catch(error => {
        console.error('提交失败:', error);
        alert('保存失败，请稍后重试');
    })
    .finally(() => {
        submitBtn.textContent = originalText;
        submitBtn.disabled = false;
    });
}

/**
 * 打开弹窗
 */
function openModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
    document.body.style.overflow = 'hidden'; // 禁止背景滚动
}

/**
 * 关闭弹窗
 */
function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
    document.body.style.overflow = 'auto'; // 恢复背景滚动
}

/**
 * 删除课程
 */
function deleteCourse(courseId, courseName) {
    if (confirm(`确定要删除课程"${courseName}"吗？\n\n此操作不可撤销！`)) {
        // 创建表单并提交
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const courseIdInput = document.createElement('input');
        courseIdInput.type = 'hidden';
        courseIdInput.name = 'courseId';
        courseIdInput.value = courseId;
        
        form.appendChild(actionInput);
        form.appendChild(courseIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

/**
 * 页面加载完成后的初始化
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('管理员课程管理页面已加载');
    
    // 自动隐藏提示消息
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.style.display = 'none';
            }, 300);
        }, 5000);
    });
    
    // 为表格行添加点击效果
    const tableRows = document.querySelectorAll('#coursesTable tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#f8f9fa';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '';
        });
    });
    
    // 点击弹窗外部关闭弹窗
    window.addEventListener('click', function(event) {
        const modals = document.querySelectorAll('.modal');
        modals.forEach(modal => {
            if (event.target === modal) {
                closeModal(modal.id);
            }
        });
    });
    
    // ESC键关闭弹窗
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const openModals = document.querySelectorAll('.modal[style*="block"]');
            openModals.forEach(modal => {
                closeModal(modal.id);
            });
        }
    });
});

/**
 * 导出课程数据为CSV
 */
function exportCoursesCSV() {
    const table = document.getElementById('coursesTable');
    if (!table) {
        alert('没有可导出的数据');
        return;
    }
    
    let csv = [];
    const rows = table.querySelectorAll('tr');
    
    for (let i = 0; i < rows.length; i++) {
        const row = rows[i];
        const cols = row.querySelectorAll('td, th');
        let csvRow = [];
        
        for (let j = 0; j < cols.length - 1; j++) { // 排除最后一列（操作列）
            let cellText = cols[j].innerText.replace(/"/g, '""');
            csvRow.push('"' + cellText + '"');
        }
        
        csv.push(csvRow.join(','));
    }
    
    const csvString = csv.join('\n');
    const blob = new Blob(['\ufeff' + csvString], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    
    if (link.download !== undefined) {
        const url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', '课程数据_' + new Date().toISOString().slice(0, 10) + '.csv');
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

/**
 * 搜索课程
 */
function searchCourses() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;
    
    const searchTerm = searchInput.value.toLowerCase();
    const rows = document.querySelectorAll('#coursesTable tbody tr');
    
    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        let found = false;
        
        cells.forEach(cell => {
            if (cell.textContent.toLowerCase().includes(searchTerm)) {
                found = true;
            }
        });
        
        row.style.display = found ? '' : 'none';
    });
}

/**
 * 删除指定用户的所有课程
 */
function deleteUserCourses(userId, userName) {
    if (confirm(`确定要删除用户"${userName}"的所有课程吗？\n\n此操作不可撤销！`)) {
        // 创建表单并提交
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.location.pathname;
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteUserCourses';
        
        const userIdInput = document.createElement('input');
        userIdInput.type = 'hidden';
        userIdInput.name = 'userId';
        userIdInput.value = userId;
        
        form.appendChild(actionInput);
        form.appendChild(userIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

/**
 * 批量操作功能
 */
function initBatchOperations() {
    // 添加全选功能
    const selectAllCheckbox = document.getElementById('selectAll');
    const courseCheckboxes = document.querySelectorAll('.course-checkbox');
    
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            courseCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            updateBatchButtons();
        });
    }
    
    courseCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateBatchButtons);
    });
}

/**
 * 更新批量操作按钮状态
 */
function updateBatchButtons() {
    const checkedBoxes = document.querySelectorAll('.course-checkbox:checked');
    const batchButtons = document.querySelectorAll('.batch-action');
    
    batchButtons.forEach(button => {
        button.disabled = checkedBoxes.length === 0;
    });
}

/**
 * 显示加载状态
 */
function showLoading(message = '加载中...') {
    const loading = document.createElement('div');
    loading.id = 'loadingOverlay';
    loading.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 10000;
        color: white;
        font-size: 1.2rem;
    `;
    loading.innerHTML = `
        <div style="text-align: center;">
            <div style="margin-bottom: 1rem;">⏳</div>
            <div>${message}</div>
        </div>
    `;
    document.body.appendChild(loading);
}

/**
 * 隐藏加载状态
 */
function hideLoading() {
    const loading = document.getElementById('loadingOverlay');
    if (loading) {
        document.body.removeChild(loading);
    }
}
