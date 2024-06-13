<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'title', 'description', 'image', "price", "count"];
    public function User()
    {

        return $this->belongsTo('App\Models\User', 'id', 'user_id');
    }
    public function Review()
    {
        return $this->hasMany('App\Models\Review', 'product_id', 'id');
    }
    public function Order()
    {
        return $this->hasMany('App\Models\Order', 'product_id', 'id');
    }
}
