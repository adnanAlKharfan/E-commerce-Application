<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        "product_name",
        "feedback",
        'product_id', 'number',
        "total", "status"
    ];
    public function Product()
    {
        return $this->belongsTo('App\Models\Product', 'id', 'product_id');
    }
    public function User()
    {
        return $this->belongsTo('App\Models\User', 'id', 'user_id');
    }
}
