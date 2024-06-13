<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Validator as Validate;

class OrderController extends Controller
{
    //
    public function post(Request $request, $id)
    {
        $v = Validate::make(["id" => $id], [
            "id" => "required|numeric",

        ]);
        if ($v->fails()) {
            return response()->json(["msg" => "the id must be a number"], 400);
        }
        $request->validate([
            "total" => 'required|regex:/[1-9]([0-9])*.[0-9]([0-9])*/',
            "number" => "required|regex:/[1-9]([0-9])*/",
            "product_name" => "required|regex:/^[a-zA-Z]([a-zA-Z])*/"
        ]);
        $data = $request;

        $data = ["product_id" => $id, "total" => $data["total"], "number" => $data["number"], "product_name" => $data["product_name"]];
        return  response()->json(["data" => $request->user()->Order()->create($data)]);
    }
    public function put(request $request, $id)
    {
        $v = Validate::make(["id" => $id], [
            "id" => "required|numeric",

        ]);
        if ($v->fails()) {
            return response()->json(["msg" => "the id must be a number"], 400);
        }
        $request->validate([

            "status" => array("required", "regex:/accept|decline|pending/")
        ]);

        $data = $request;
        $data = ["status" => $data["status"]];
        $order = Order::find($id);
        if ($order == null) {
            return  response()->json(["msg" => "order not found"]);
        }

        return  response()->json(["data" => $order->update($data)]);
    }
    public function get(request $request)
    {
        $products = $request->user()->Product()->get();

        $data = [];
        foreach ($products as $product) {

            array_push($data, $product->Order()->get());
        }
        return response()->json(["data" => $data]);
    }
}
