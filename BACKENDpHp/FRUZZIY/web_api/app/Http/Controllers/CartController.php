<?php

namespace App\Http\Controllers;

use App\Models\Cart;
use App\Models\CartItem;
use Illuminate\Http\Request;

class CartController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = auth('api')->user();

        // Lấy giỏ hàng của người dùng
        $cart = Cart::with('items.product')->where('user_id', $user->id)->first();

        if (!$cart) {
            return response()->json(['message' => 'Cart is empty'], 404);
        }

        return response()->json($cart);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $user = auth('api')->user();

        // Tìm giỏ hàng của người dùng hoặc tạo mới
        $cart = Cart::firstOrCreate(['user_id' => $user->id]);

        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        $cartItem = CartItem::where('cart_id', $cart->id)
                            ->where('product_id', $request->product_id)
                            ->first();

        if ($cartItem) {
            // Nếu sản phẩm đã tồn tại, tăng số lượng
            $cartItem->quantity += $request->quantity;
            $cartItem->save();
        } else {
            // Nếu sản phẩm chưa có, thêm mới
            CartItem::create([
                'cart_id' => $cart->id,
                'product_id' => $request->product_id,
                'quantity' => $request->quantity,
                'price' => $request->price,
            ]);
        }

        return response()->json(['message' => 'Product added to cart successfully']);
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
    public function update(Request $request)
    {
        $user = auth('api')->user();

        // Tìm giỏ hàng của người dùng
        $cart = Cart::where('user_id', $user->id)->first();

        if (!$cart) {
            return response()->json(['message' => 'Cart not found'], 404);
        }

        // Tìm sản phẩm trong giỏ hàng và cập nhật số lượng
        $cartItem = CartItem::where('cart_id', $cart->id)
                            ->where('product_id', $request->product_id)
                            ->first();

        if ($cartItem) {
            $cartItem->quantity = $request->quantity;
            $cartItem->save();
            return response()->json(['message' => 'Cart updated successfully']);
        }

        return response()->json(['message' => 'Product not found in cart'], 404);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $user = auth('api')->user();

        // Tìm giỏ hàng của người dùng
        $cart = Cart::where('user_id', $user->id)->first();

        if (!$cart) {
            return response()->json(['message' => 'Cart not found'], 404);
        }

        // Tìm và xóa sản phẩm trong giỏ hàng
        $cartItem = CartItem::where('cart_id', $cart->id)
                            ->where('product_id', $id)
                            ->first();

        if ($cartItem) {
            $cartItem->delete();
            return response()->json(['message' => 'Product removed from cart successfully']);
        }

        return response()->json(['message' => 'Product not found in cart'], 404);
    }
}
