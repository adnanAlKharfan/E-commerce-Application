<?php

use App\Http\Controllers\UserController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\OrderController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(['middleware' => 'XSS'], function () {
    Route::post('/sign_up', [UserController::class, 'sign_up']);
    Route::post('/sign_in', [UserController::class, 'sign_in']);
});
Route::group(['middleware' => 'auth:sanctum'], function () {
    Route::group(['middleware' => 'XSS'], function () {
        Route::post('/sign_out', [UserController::class, 'sign_out']);
        Route::post('/products', [ProductController::class, 'store']);
         Route::post('/reviews/{id}/{oId}', [ReviewController::class, 'post']);

        Route::post('/orders/{id}', [OrderController::class, 'post']);
        Route::put('/orders/{id}', [OrderController::class, 'put']);
    });
    Route::get('/orders', [UserController::class, 'getUserOrders']);
    Route::get('/userProducts', [UserController::class, 'getUserProducts']);
  Route::resource('products', ProductController::class);

    Route::get('/reviews/{id}', [ReviewController::class, 'get']);

    Route::get('/shippment', [OrderController::class, 'get']);
});
