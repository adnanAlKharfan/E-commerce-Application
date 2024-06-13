<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\Validator as Validate;

class ProductController extends Controller
{
    //
    public function index()
    {
        return response()->json(["data" => Product::all()]);
    }
    public function store(Request $request)
    {
        $request->validate([
            "count" => 'required|regex:/[1-9]([0-9])*/',
            "image" => 'required|image',
            "title" => 'required|regex:/^[a-zA-Z]([a-zA-Z])*/',
            "description" => 'required',
            "price" => 'required|regex:/[1-9]([0-9])*.[0-9]([0-9])*/'
        ]);

        $file = $request->file('image');
        $data = $request;

        $name = time() . $file->getClientOriginalName();


        $file->move("images", $name);

        $data = ["image" => "http://localhost:8000/images/" . $name, "title" => $data["title"], "description" => $data["description"], "price" => $data["price"], "count" => $data["count"]];

        return response()->json(["data" => $request->user()->Product()->create($data)]);
    }
    public function update(Request $request, $id)
    {
        $v = Validate::make(["id" => $id], [
            "id" => "required|numeric",

        ]);
        if ($v->fails()) {
            return response()->json(["msg" => "the id must be a number"], 400);
        }
        $file = $request->file('image');
        $data = $request;

        if ($file) {
            $request->validate([
                "count" => 'required|regex:/[1-9]([0-9])*/',
                "image" => 'required|image',
                "title" => 'required|regex:/^[a-zA-Z]([a-zA-Z])*/',
                "description" => 'required',
                "price" => 'required|regex:/[1-9]([0-9])*.[0-9]([0-9])*/'
            ]);
            $name = time() . $file->getClientOriginalName();


            $file->move("images", $name);

            $data = ["image" => "http://localhost:8000/images/" . $name, "title" => $data["title"], "description" => $data["description"], "price" => $data["price"], "count" => $data["count"]];
        } else {
            $request->validate([
                "count" => 'required|regex:/[1-9]([0-9])*/',

                "title" => 'required|regex:/^[a-zA-Z]([a-zA-Z])*/',
                "description" => 'required',
                "price" => 'required|regex:/[1-9]([0-9])*.[0-9]([0-9])*/'
            ]);
            $data = ["title" => $data["title"], "description" => $data["description"], "price" => $data["price"], "count" => $data["count"]];
        }
        $request->user()->Product()->where("id", "=", $id)->update($data);
        return response()->json(["data" => Product::where("id", "=", $id)->first()]);
    }
    public function Destroy($id)
    {

        Validate::make(["id" => $id], [
            "id" => "required|numeric"
        ]);


        $product = Product::find($id);
        if ($product) {
            $product->delete();
            return response()->json(["msg" => "success"]);
        } else {
            return response()->json(["msg" => "product not found"], $status = 400);
        }
    }
}
