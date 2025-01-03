<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function getUsers($role_id)
    {
        $users = User::where('role_id', $role_id)
                    ->paginate(10, ['id', 'full_name', 'username', 'email', 'birth_year', 'phone_number', 'address','gender']);

        return response()->json($users);
    }
}
