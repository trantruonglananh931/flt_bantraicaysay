<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function getTotalRevenue()
    {
        // Lấy tổng doanh thu từ các đơn hàng có status là 'Hoàn tất'
        $totalRevenue = Order::where('status', 'Hoàn tất')->sum('total_price');

        // Trả về response dưới dạng JSON
        return response()->json([
            'total_revenue' => $totalRevenue,
        ], 200);
    }

    public function getTodayRevenue()
    {
        // Lấy doanh thu từ các đơn hàng có status là 'Hoàn tất' và ngày tạo là hôm nay
        $todayRevenue = Order::where('status', 'Hoàn tất')
            ->whereDate('created_at', Carbon::today())
            ->sum('total_price');

        // Trả về response dưới dạng JSON
        return response()->json([
            'today_revenue' => $todayRevenue,
        ], 200);
    }

    public function getOrderStatusPercentages()
    {
        // Lấy tổng số đơn hàng
        $totalOrders = Order::whereMonth('created_at', Carbon::now()->month)
                            ->whereYear('created_at', Carbon::now()->year)
                            ->count();

        // Nếu không có đơn hàng nào, trả về 0% cho tất cả các trạng thái
        if ($totalOrders === 0) {
            return response()->json([
                'Chưa xác nhận' => 0,
                'Đã xác nhận' => 0,
                'Đang vận chuyển' => 0,
                'Hoàn tất' => 0,
                'Đã hủy' => 0,
            ], 200);
        }

        // Tính số lượng đơn hàng theo từng trạng thái
        $unconfirmed = Order::where('status', 'Chưa xác nhận')
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->count();

        $confirmed = Order::where('status', 'Đã xác nhận')
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->count();

        $shipping = Order::where('status', 'Đang vận chuyển')
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->count();

        $completed = Order::where('status', 'Hoàn tất')
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->count();

        $canceled = Order::where('status', 'Đã hủy')
            ->whereMonth('created_at', Carbon::now()->month)
            ->whereYear('created_at', Carbon::now()->year)
            ->count();

        // Tính tỷ lệ phần trăm cho từng trạng thái
        $percentages = [
            'Chưa xác nhận' => ($unconfirmed / $totalOrders) * 100,
            'Đã xác nhận' => ($confirmed / $totalOrders) * 100,
            'Đang vận chuyển' => ($shipping / $totalOrders) * 100,
            'Hoàn tất' => ($completed / $totalOrders) * 100,
            'Đã hủy' => ($canceled / $totalOrders) * 100,
        ];

        // Trả về response dưới dạng JSON
        return response()->json($percentages, 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
