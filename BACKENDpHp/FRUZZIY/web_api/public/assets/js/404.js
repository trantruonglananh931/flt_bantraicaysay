document.addEventListener("DOMContentLoaded", async () => {
    try {
        // Kiểm tra trạng thái trang bằng cách gửi request HEAD đến URL hiện tại
        const response = await fetch(window.location.href, { method: "HEAD" });

        // Nếu response trả về status 404, chuyển hướng đến trang /404
        if (response.status === 404) {
            window.location.href = "/404";
        }
    } catch (error) {
        console.error("Lỗi khi kiểm tra trang:", error);
        // Phòng trường hợp lỗi mạng hoặc server, chuyển hướng tới trang lỗi chung
        window.location.href = "/404";
    }
});
