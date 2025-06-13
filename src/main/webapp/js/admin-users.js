// 搜索过滤功能
function filterUsers() {
  const input = document.getElementById("searchInput");
  const filter = input.value.toLowerCase();
  const table = document.getElementById("usersTable");
  const rows = table.getElementsByTagName("tr");

  for (let i = 1; i < rows.length; i++) {
    const cells = rows[i].getElementsByTagName("td");
    let match = false;

    // 检查用户名和邮箱列
    if (cells.length > 0) {
      const username = cells[1].textContent.toLowerCase();
      const email = cells[3].textContent.toLowerCase();

      if (username.includes(filter) || email.includes(filter)) {
        match = true;
      }
    }

    rows[i].style.display = match ? "" : "none";
  }
}

// 删除用户确认
function deleteUser(userId, userName) {
  if (
    confirm(
      '确定要删除用户 "' +
        userName +
        '" 吗？\n\n此操作将同时删除该用户的所有课程数据，且无法恢复！'
    )
  ) {
    // 创建表单并提交
    const form = document.createElement("form");
    form.method = "POST";
    form.action = "<%= request.getContextPath() %>/admin/users";

    const actionInput = document.createElement("input");
    actionInput.type = "hidden";
    actionInput.name = "action";
    actionInput.value = "delete";

    const userIdInput = document.createElement("input");
    userIdInput.type = "hidden";
    userIdInput.name = "userId";
    userIdInput.value = userId;

    form.appendChild(actionInput);
    form.appendChild(userIdInput);
    document.body.appendChild(form);
    form.submit();
  }
}

// 高亮当前用户行
document.addEventListener("DOMContentLoaded", function () {
  const currentUserId = parseInt(
    '<%= ((User)session.getAttribute("user")).getUserId() %>'
  );
  const rows = document.querySelectorAll("#usersTable tbody tr");

  rows.forEach((row) => {
    const userIdCell = row.querySelector("td:first-child");
    if (userIdCell && parseInt(userIdCell.textContent) === currentUserId) {
      row.style.backgroundColor = "#e3f2fd";
    }
  });
});
