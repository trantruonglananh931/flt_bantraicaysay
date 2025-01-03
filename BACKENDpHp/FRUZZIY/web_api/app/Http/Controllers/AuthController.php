<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use App\Models\User;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('username', 'password');
        try {
            if (!$token = JWTAuth::attempt($credentials)) {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }
            $user = auth('api')->user();

            $role = $user->role->name;
        } catch (JWTException $e) {
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        return response()->json([
            'token' => $token,
            'role' => $role,
            'username' => $user->username
        ]);
    }

    public function logout()
    {
        JWTAuth::invalidate(JWTAuth::getToken());
        return response()->json(['message' => 'Successfully logged out']);
    }

    public function profile()
    {
        return response()->json(auth('api')->User());
    }

    public function updateProfile(Request $request)
    {
        // Lấy người dùng hiện tại
        $user = auth('api')->user();

        // Cập nhật thông tin người dùng
        $user->full_name = $request->full_name;
        $user->username = $request->username;
        $user->email = $request->email;
        $user->phone_number = $request->phone_number;
        $user->address = $request->address;
        $user->gender = $request->gender;

        $result = $user->save();

        if($result)
        {
            return response()->json(['message' => 'Hồ sơ cá nhân đã được cập nhật thành công.', 'user' => $user],201);
        }
        else{
            return response()->json(['error' => 'Không cập nhật thành công người dùng', 'user' => $user],500);
        }

    }

    public function registerUser(Request $request)
    {
        if (User::where('username', $request->name)->exists()) {
            return response()->json(['error' => 'Username đã tồn tại'], 400);
        }
        if (User::where('email', $request->email)->exists()) {
            return response()->json(['error' => 'Email đã tồn tại'], 400);
        }

        if (User::where('phone_number', $request->phone_number)->exists()) {
            return response()->json(['error' => 'Sdt đã tồn tại'], 400);
        }

        // Tạo người dùng với role_id là 2 (user)
        $user = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role_id' => 2,
            'full_name' => $request->full_name,
            'birth_year' => $request->birth_year,
            'phone_number' => $request->phone_number,
            'address' => $request->address,
            'gender'=> $request->gender,
        ]);

        return response()->json(['user' => $user], 201);
    }

    public function registerAdmin(Request $request)
    {
        // Kiểm tra quyền đăng ký admin (chỉ admin mới có thể tạo tài khoản admin)
        if (auth('api')->User()->role_id != 1) {
            return response()->json(['error' => 'Không có quyền tạo admin, ktra lại thông tin người dùng trong data'], 403);
        }

        if (User::where('username', $request->name)->exists()) {
            return response()->json(['error' => 'Username đã tồn tại'], 400);
        }
        if (User::where('email', $request->email)->exists()) {
            return response()->json(['error' => 'Email đã tồn tại'], 400);
        }

        // Tạo người dùng với role_id là 1 (admin)
        $admin = User::create([
            'username' => $request->username,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role_id' => 1,
            'full_name' => $request->full_name,
            'birth_year' => $request->birth_year,
            'phone_number' => $request->phone_number,
            'address' => $request->address,
            'gender'=> $request->gender,
        ]);

        return response()->json(['user' => $admin], 201);
    }

    public function resetPassword(Request $request)
    {
        $resetData = Cache::get('password-reset-' . $request->email);

        if (!$resetData || $resetData != $request->reset_token) {
            return response()->json(['error' => 'Token không hợp lệ'], 400);
        }
        // Cập nhật mật khẩu mới
        $user = User::where('email', $request->email)->first();

        $user->password = Hash::make($request->password);
        $user->save();
        Cache::forget('password-reset-' . $request->email);

        return response()->json(['message' => 'Mật khẩu đã được thay đổi thành công']);
    }

    public function changePassword(Request $request){
        $user = auth('api')->user();

        if (!Hash::check($request->old_password, $user->password)) {
            return response()->json(['error' => 'Mật khẩu cũ không chính xác'], 400);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Đổi mật khẩu thành công']);
    }

}
