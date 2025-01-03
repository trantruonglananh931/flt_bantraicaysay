document.addEventListener("DOMContentLoaded", function () {
    // Lắng nghe sự kiện click vào tất cả các nút xóa
    document.querySelectorAll(".remove-btn").forEach((button) => {
        button.addEventListener("click", function () {
            // Tìm dòng sản phẩm chứa nút xóa
            const row = this.closest("tr");

            // Kiểm tra nếu dòng tồn tại thì xóa nó
            if (row) {
                row.remove(); // Loại bỏ dòng khỏi bảng
                alert("Sản phẩm đã bị xóa khỏi danh sách");
            }
        });
    });
});
