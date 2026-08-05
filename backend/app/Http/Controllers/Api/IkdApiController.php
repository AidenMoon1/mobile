<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class IkdApiController extends Controller
{
    /**
     * Redirect to IKD Official OIDC Provider.
     */
    public function redirect()
    {
        // Integration with Socialite / OpenID Connect logic
        return response()->json(['url' => 'https://sso.dukcapil.go.id/auth/...']);
    }

    /**
     * Handle callback from IKD.
     */
    public function callback(Request $request)
    {
        // Extract NIK and profile from the token
        return response()->json([
            'status' => 'success',
            'user' => [
                'nik' => '3272xxxxxxxxxxxx',
                'name' => 'Warga Sukabumi'
            ]
        ]);
    }
}
