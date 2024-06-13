<?php

namespace App\Http\Controllers;

use App\Models\Review;
use App\Models\Product;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator as Validate;

class ReviewController extends Controller
{
    //
    public function get($id)
    {
        $v = Validate::make(["id" => $id], [
            "id" => "required|numeric"
        ]);
        if ($v->fails()) {
            return response()->json(["msg" => "the id must be a number"], 400);
        }
        $product = Product::find($id);
        if ($product == null) {
            return response()->json(["msg" => "product not found"]);
        }

        return response()->json(["data" => $product->Review()->get()]);
    }

    public function post(request $request, $id, $oId)
    {
        $v = Validate::make(["id" => $id, "oId" => $oId], [
            "id" => "required|numeric",
            "oId" => "required|numeric"
        ]);
        if ($v->fails()) {
            return response()->json(["msg" => "the id must be a number"], 400);
        }

        $request->validate([
            "comment" => "required"


        ]);

        $data = ["comment" => $request->comment, "user_id" => $request->user()->currentAccessToken()->tokenable->id];
        Order::find($oId)->update(["feedback" => $request->comment]);
        $product = Product::find($id);
        if ($product == null) {
            return response()->json(["msg" => "product not found"]);
        }
        return response()->json(["data" => $product->Review()->create($data)]);
    }
}
