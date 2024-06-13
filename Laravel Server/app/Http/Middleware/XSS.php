<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class XSS
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $userInput = $request->all();
        array_walk_recursive($userInput, function (&$userInput) {

            $userInput = strip_tags($userInput);
        });
        $request->merge($userInput);
        return $next($request);
    }
}
