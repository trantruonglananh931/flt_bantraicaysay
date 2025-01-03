document.addEventListener("DOMContentLoaded", () => {
    const token = localStorage.getItem("token"); // Lấy token từ localStorage

    if (token) {
        // Nếu có token, hiển thị nút Đăng Xuất
        document.getElementById("logout").addEventListener("click", () => {
            localStorage.removeItem("token"); // Xóa token khỏi localStorage
            window.location.href = "/admin/login"; // Chuyển hướng về trang Đăng Nhập admin
        });
    } else {
        // Nếu không có token, có thể hiển thị thông báo hoặc không làm gì
        console.log("Vui lòng đăng nhập");
    }
});
