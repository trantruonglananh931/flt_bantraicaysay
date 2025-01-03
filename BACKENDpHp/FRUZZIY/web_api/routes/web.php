<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmailController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderTrackingController;

Route::get('/', function () {
    return view('index');
});

Route::get('about', function () {
    return view('about');
});

Route::get('contact', function () {
    return view('contact');
});

Route::get('term', function () {
    return view('term');
});

Route::get('shop', function () {
    return view('shop');
});

Route::get('detail-shop/{id}', function ($id) {
    return view('detail-shop', ['id' => $id]);
});


Route::get('blog', function () {
    return view('blog');
});
Route::get('blog_detail_1', function () {
    return view('blog_detail_1');
});
Route::get('blog_detail_2', function () {
    return view('blog_detail_2');
});
Route::get('blog_detail_3', function () {
    return view('blog_detail_3');
});
Route::get('blog_detail_4', function () {
    return view('blog_detail_4');
});

Route::get('404', function () {
    return view('404');
});

Route::get('wishlist', function () {
    return view('wishlist');
});

Route::get('cart', function () {
    return view('cart');
});

Route::get('check-out', function () {
    return view('check-out');
});

Route::get('thank-you', function () {
    return view('thank-you');
});

Route::get('login', function () {
    return view('auth.login');
})->name('login');

Route::get('register', function () {
    return view('auth.register');
})->name('register');

Route::get('forgot-password', function () {
    return view('auth.forgot-password'); // Giao diện quên mật khẩu
})->name('forgot-password');

Route::get('change-password', function () {
    return view('auth.change-password'); // Giao diện quên mật khẩu
})->name('change-password');

Route::get('profile', function () {
    return view('profile.profile');
})->name('profile');

Route::get('track-order', function () {
    return view('track-order');
})->name('track-order');
Route::get('my-orders', [OrderTrackingController::class, 'trackOrders'])->name('my-orders')->middleware('auth');

Route::prefix('product')->group(function () {
    // Lấy danh sách sản phẩm
    Route::get('get', function () {
        return view('admin.product.show');
    })->name('get');

    // Tạo sản phẩm mới
    Route::get('add', function () {
        return view('admin.product.create');
    })->name('add');

    // Cập nhật sản phẩm
    Route::get('update/{id}', function ($id) {
        return view('admin.product.update', ['id' => $id]);
    })->name('update');

});

Route::get('orders', function () {
    return view('admin.orders.index');
})->name('orders');

Route::get('detail-orders/{id}', function ($id) {
    return view('admin.orders.detail-orders', ['id' => $id]);
})->name('detail-orders');

Route::prefix('admin')->group(function () {

Route::get('getusers', function () {
    return view('admin.getusers');
})->name('getusers');

Route::get('login', function () {
    return view('admin.login_admin.login_admin');
})->name('login');

Route::get('dashboard', function () {
    return view('admin.login_admin.dashboard');
})->name('dashboard');
});

//Warehouse

Route::prefix('warehouse')->group(function () {
    // Hiển thị hàng tồn kho
    Route::get('show', function () {
        return view('admin.warehouse.warehouse');
    })->name('show');
    // Cập nhật hàng tồn kho
    Route::get('update/{id}', function ($id) {
        return view('admin.warehouse.updatewh', ['id' => $id]);
    })->name('update');
});

Route::get('vnpay_return', function () {
    return view('vnpay.vnpay_return');
})->name('vnpay_return');

