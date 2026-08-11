<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Aduan extends Model
{
    protected $fillable = [
        'user_id', 'title', 'category', 'description', 'status'
    ];
}
