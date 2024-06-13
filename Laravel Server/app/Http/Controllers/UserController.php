<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Auth;


class UserController extends Controller
{
    //
    public function sign_up(Request $request)
    {

        $request->validate([
            'email' => 'bail|required|unique:users,email|email',
            'password' => array('bail', 'required', 'regex:/((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9]))(?=.{6,})/'),
            "name" => "bail|required|regex:/(^[a-zA-Z ]{2,30}$)/u",
            'credit_card_number' => array('bail', 'required', 'regex:/(^5[1-5][0-9]{14}$|^2(?:2(?:2[1-9]|[3-9][0-9])|[3-6][0-9][0-9]|7(?:[01][0-9]|20))[0-9]{12}$)|(^3[47][0-9]{13}$)|(^4[0-9]{12}(?:[0-9]{3})?$)|(^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$)|(^(?:2131|1800|35[0-9]{3})[0-9]{11}$)|(^3(?:0[0-5]|[68][0-9])[0-9]{11}$)|(^(5018|5081|5044|5020|5038|603845|6304|6759|676[1-3]|6799|6220|504834|504817|504645)[0-9]{8,15}$)/'),
            'credit_card_pass' => 'bail|required|regex:/([0-9]{3,4})/'

        ]);
        $data = $request->all();


        $currentUser =    User::create($data);
        $token = $currentUser->createToken("myapp")->plainTextToken;
        return response()->json(["data" => $currentUser, "token" => $token]);
    }
    public function sign_in(Request $request)
    {


        $request->validate([
            'email' => 'bail|required|email',
            'password' => 'bail|required'
        ]);
        $request->validate(['email' => 'required', 'password' => 'required']);
        $data = $request->all();
        $currentUser = User::where('email', '=', $data['email'], 'and', 'password', '=', $data['password'])->first();
        if ($currentUser) {

            $token = $currentUser->createToken("myapp")->plainTextToken;
            return response()->json(["data" => $currentUser, "token" => $token]);
        }
        return response()->json(["msg" => "check your email and password then try again"]);
    }
    public function sign_out(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(["msg" => "succesfully logged out"]);
    }

    public function getUserOrders(Request $request)
    {
        $data = $request->user()->currentAccessToken()->tokenable;

        return response()->json(["data" => User::find($data["id"])->Order()->get()]);
    }
    public function getUserProducts(Request $request)
    {
        $data = $request->user()->currentAccessToken()->tokenable;

        return response()->json(["data" => User::find($data["id"])->Product()->get()]);
    }
}
