<?php

namespace App\Models;

use Auth;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var string[]
     */
    protected $fillable = [
        'name',
        'email',
        'password',

        'credit_card_number',
        'credit_card_pass'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'credit_card_number',
        'credit_card_pass'
    ];

    public function Product()
    {
        return $this->hasMany('App\Models\Product', 'user_id', 'id');
    }
    public function Review()
    {
        return $this->hasMany('App\Models\Review', 'user_id', 'id');
    }
    public function Order()
    {
        return $this->hasMany('App\Models\Order', 'user_id', 'id');
    }
    /**
     * The attributes that should be cast.
     *
     * @var array
     */
}
