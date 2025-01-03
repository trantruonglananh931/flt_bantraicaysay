<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id(); // Tự động tạo khoá chính (id)
            // Thiết lập khoá ngoại category_id
            $table->foreignId('category_id')
                ->constrained('categories') // Liên kết với bảng categories
                ->onDelete('cascade'); // Khi xoá danh mục, sản phẩm liên quan cũng bị xoá
            $table->string('name'); // Tên sản phẩm
            $table->decimal('price', 10, 2); // Giá sản phẩm
            $table->string('thumbnail')->nullable(); // Hình ảnh sản phẩm (cho phép null)
            $table->text('description')->nullable(); // Mô tả sản phẩm (cho phép null)
            $table->timestamps(); // Tự động tạo created_at và updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
