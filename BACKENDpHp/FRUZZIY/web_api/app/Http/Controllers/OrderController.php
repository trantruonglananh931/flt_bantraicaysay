<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\Warehouse;
use App\Models\Cart;
use App\Models\CartItem;
use App\Models\OrderDetail;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Lấy tất cả đơn hàng
        $orders = Order::all();
    
        // Duyệt qua từng đơn hàng để thêm username
        foreach ($orders as $order) {
            $order->username = $order->user ? $order->user->username : null;
            unset($order->user); // Loại bỏ thông tin user nếu không cần
        }
    
        // Trả về danh sách đơn hàng
        return response()->json($orders);
    }
    

    public function checkStockAvailability($orderDetails)
    {
        foreach ($orderDetails as $detail) {
            $warehouse = Warehouse::where('product_id', $detail['product_id'])->first();

            if (!$warehouse || $warehouse->quantity < $detail['quantity']) {
                return "Sản phẩm ID {$detail['product_id']} không đủ trong kho.";
            }
        }
        return true; // Nếu tất cả sản phẩm đều đủ trong kho
    }

    public function updateStockQuantities($orderDetails)
    {
        foreach ($orderDetails as $detail) {
            $warehouse = Warehouse::where('product_id', $detail['product_id'])->first();

            // Trừ số lượng trong kho
            if ($warehouse) {
                $warehouse->quantity -= $detail['quantity'];
                $warehouse->save();
            }
        }
    }

    public function removeProductsFromCart($cartId, $orderDetails)
    {
        foreach ($orderDetails as $detail) {
            // Kiểm tra xem sản phẩm có trong cart_items không
            $cartItem = CartItem::where('cart_id', $cartId)
                ->where('product_id', $detail['product_id'])
                ->first();

            // Nếu sản phẩm tồn tại trong giỏ hàng, xóa nó
            if ($cartItem) {
                $cartItem->delete();
            }
            // Nếu không tìm thấy sản phẩm, có thể log hoặc xử lý tùy ý
            else {
                // Bạn có thể log hoặc thực hiện hành động khác nếu cần
                // ví dụ: Log::info("Sản phẩm ID {$detail['product_id']} không có trong giỏ hàng với cart ID {$cartId}.");
            }
        }
    }

    public function store(Request $request)
    {
        $user = auth('api')->user();

        // Xác thực các trường cần thiết
        $validator = Validator::make($request->all(), [
            'address_ship' => 'required|string',
            'total_price' => 'required|numeric|min:0',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Lấy giỏ hàng của người dùng
        $cart = Cart::where('user_id', $user->id)->with('items.product')->first();

        if (!$cart || $cart->items->isEmpty()) {
            return response()->json(['error' => 'Giỏ hàng của bạn đang trống.'], 422);
        }

        // Chuẩn bị dữ liệu chi tiết đơn hàng từ giỏ hàng
        $orderDetails = [];
        foreach ($cart->items as $item) {
            $orderDetails[] = [
                'product_id' => $item->product_id,
                'quantity' => $item->quantity,
                'price' => $item->product->price,
            ];
        }

        // Kiểm tra tính khả dụng của sản phẩm trong kho
        $checkResult = $this->checkStockAvailability($orderDetails);
        if ($checkResult !== true) {
            return response()->json(['error' => $checkResult], 422);
        }

        // Tạo đơn hàng
        $order = Order::create([
            'user_id' => $user->id,
            'address_ship' => $request->address_ship,
            'total_price' => $request->total_price,
            'status'=>"Hoàn tất",
            'payment_method' =>  '1', 
        ]);

        // Tạo chi tiết đơn hàng
        foreach ($orderDetails as $detail) {
            $order->orderDetails()->create($detail);
        }

        // Cập nhật số lượng tồn kho
        $this->updateStockQuantities($orderDetails);

        // Xóa các sản phẩm đã thanh toán khỏi giỏ hàng
        $this->removeProductsFromCart($cart->id, $orderDetails);

        $emailController = new EmailController();
        $emailController->sendOrderEmail($order->id,$user->email);

        return response()->json($order->load('orderDetails'), 201);
    }



    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        // Tìm trong bảng OrderDetail dựa trên product_id
        $orderDetail = OrderDetail::where('order_id', $id)->get();

        // Kiểm tra nếu không tìm thấy
        if (!$orderDetail) {
            return response()->json(['message' => 'Order detail not found'], 404);
        }

        // Trả về thông tin chi tiết đơn hàng
        return response()->json($orderDetail, 200);
    }

    public function myOrder()
{
    $user = auth('api')->user();

    // Tìm tất cả đơn hàng của người dùng, kèm theo chi tiết sản phẩm
    $orders = Order::where('user_id', $user->id)->get();

    // Kiểm tra nếu không có đơn hàng nào
    if ($orders->isEmpty()) {
        return response()->json(['message' => 'Order not found'], 404);
    }

    // Trả về thông tin đơn hàng
    return response()->json($orders, 200);
}


}
