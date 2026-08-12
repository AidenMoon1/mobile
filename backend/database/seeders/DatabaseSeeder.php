<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Akun Super Admin (Akses Penuh)
        User::factory()->create([
            'name' => 'Sakalangit Super Admin',
            'username' => 'superadmin',
            'email' => 'sakalangit112@gmail.com',
            'phone' => '081234567891',
            'role' => 'super_admin',
            'password' => bcrypt('saka334'),
        ]);

        // 2. Akun Admin Dinas (Akses Terbatas)
        User::factory()->create([
            'name' => 'Admin Diskominfo',
            'username' => 'admin_kominfo',
            'email' => 'admin@sukabumi.go.id',
            'phone' => '081234567890',
            'role' => 'admin_dinas',
            'password' => bcrypt('diskominfo224'),
        ]);
    }
}
