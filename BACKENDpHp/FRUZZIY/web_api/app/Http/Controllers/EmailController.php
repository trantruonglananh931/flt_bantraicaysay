<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\SendOtpMail;
use App\Mail\OrderConfirmationMail;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;
use App\Models\User;

class EmailController extends Controller
{
    public function sendOtp(Request $request)
    {
        if (!User::where('email', $request->email)->exists()) {
            return response()->json(['error' => 'Email không tồn tại'], 404);
        }

        $otp = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        Cache::put($request->email, $otp, 2*60);

        try {
            Mail::to($request->email)->send(new SendOtpMail($otp));
        } catch (\Exception $e) {
            return response()->json(['error' => 'Không thể gửi email, vui lòng thử lại sau.'], 500);
        }

        return response()->json(['message' => 'OTP sent successfully!', 'otp' => $otp], 200);
    }

    public function verifyOtp(Request $request)
    {
        $otpData = Cache::get($request->email);

        if ($otpData && $otpData == $request->otp) {
            Cache::forget($request->email);
            $resetToken = Str::random(60);
            Cache::put('password-reset-' . $request->email, $resetToken, 5*60);
            return response()->json([
                'message' => 'OTP hợp lệ.',
                'reset_token' => $resetToken,  // Trả về mã resetToken
            ]);
        }

        return response()->json(['message' => 'OTP không chính xác hoặc đã hết hạn.'], 400);
    }

    public function sendOrderEmail(Request $request)
    {
        // Gửi email xác nhận đơn hàng
        
        try {
            // Gửi email
            Mail::to($request->customerEmail)->send(new OrderConfirmationMail($request->orderId));

            // Nếu không có lỗi, trả về thông báo thành công
            return response()->json(['message' => 'Email đã được gửi thành công!'], 200);
        } catch (\Exception $e) {
            // Nếu có lỗi, trả về thông báo lỗi
            return response()->json(['error' => 'Không thể gửi email. Lỗi: ' . $e->getMessage()], 500);
        }
    }
}