<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Warehouse;

class WarehouseController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $warehouses = Warehouse::with(['product', 'product.category'])->paginate(10);

        // Thêm thông tin tên sản phẩm và danh mục vào từng kho hàng
        foreach ($warehouses as $warehouse) {
            $warehouse->product_name = $warehouse->product ? $warehouse->product->name : null;
            $warehouse->category_name = $warehouse->product && $warehouse->product->category ? $warehouse->product->category->name : null;
            unset($warehouse->product); // Loại bỏ thông tin sản phẩm nếu không cần
        }

        // Trả về response dưới dạng JSON
        return response()->json($warehouses);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'quantity' => 'required|integer|min:0',
            'product_id' => 'required|exists:products,id', // Kiểm tra sản phẩm có tồn tại
        ]);

        // Tạo mới kho hàng
        $warehouse = Warehouse::create([
            'quantity' => $validatedData['quantity'],
            'product_id' => $validatedData['product_id'], // Giả sử bạn có trường product_id trong bảng warehouses
        ]);

        // Trả về response dưới dạng JSON
        return response()->json($warehouse, 201); // Trả về mã trạng thái 201 (Created)
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $warehouse = Warehouse::where('product_id', $id)->firstOrFail();

        // Cập nhật số lượng
        $warehouse->quantity = $warehouse->quantity + $request->quantity;
        $warehouse->save(); // Lưu thay đổi

        // Trả về response dưới dạng JSON
        return response()->json($warehouse, 200); // Trả về mã trạng thái 200 (OK)
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
