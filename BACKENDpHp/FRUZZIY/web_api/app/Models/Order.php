<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'address_ship',
        'total_price',
        'status',
        'payment_method'
    ];

    // Quan hệ với bảng order_details
    public function orderDetails()
    {
        return $this->hasMany(OrderDetail::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function paymentMethod()
    {
        return $this->belongsTo(PaymentMethod::class);
    }

    const STATUS_PENDING = 'Chưa xác nhận';
    const STATUS_CONFIRMED = 'Đã xác nhận';
    const STATUS_SHIPPING = 'Đang vận chuyển';
    const STATUS_COMPLETED = 'Hoàn tất';
    const STATUS_CANCEL = "Đã hủy";

    public static $validStatuses = [
        self::STATUS_PENDING,
        self::STATUS_CONFIRMED,
        self::STATUS_SHIPPING,
        self::STATUS_COMPLETED,
    ];

    public function setStatus($status)
    {
        if (in_array($status, self::$validStatuses)) {
            $this->status = $status;
            $this->save();
        } else {
            throw new \InvalidArgumentException("Trạng thái không hợp lệ.");
        }
    }
}
