document.addEventListener("DOMContentLoaded", () => {
    const userMenu = document.querySelector(".dropdown-menu"); // Chọn dropdown menu
    const token = localStorage.getItem("token"); // Lấy token từ localStorage

    if (token) {
        // Nếu có token, người dùng đã đăng nhập
        userMenu.innerHTML = `
        <li><a class="dropdown-item" href="/profile">Tài Khoản</a></li>
        <li><a class="dropdown-item" href="#" id="logout">Đăng Xuất</a></li>
      `;

        // Xử lý nút Đăng Xuất
        document.getElementById("logout").addEventListener("click", () => {
            localStorage.removeItem("token"); // Xóa token khỏi localStorage
            window.location.href = "/login"; // Chuyển hướng về trang Đăng Nhập
        });
    } else {
        // Nếu không có token, người dùng chưa đăng nhập
        userMenu.innerHTML = `
        <li><a class="dropdown-item" href="/login">Đăng Nhập</a></li>
        <li><a class="dropdown-item" href="/register">Đăng Ký</a></li>
      `;
    }
});
