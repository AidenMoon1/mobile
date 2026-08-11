{{-- resources/views/partials/sidebar-profile.blade.php --}}
<aside class="profile-sidebar reveal">
    <div class="sidebar-title-label px-4 mb-6 text-[10px] font-bold text-slate-400 uppercase tracking-[0.2em]">
        Menu Akun
    </div>
    
    <nav class="flex-1">
        {{-- Link Detail Profil --}}
        <a href="{{ route('user.profile') }}" class="sidebar-menu-link {{ Route::is('user.profile') ? 'active' : '' }}">
            <i class="bi bi-person-fill"></i>
            <span>Detail Profil</span>
        </a>

        {{-- Link Keamanan (Ganti rute jika sudah ada) --}}
        <a href="{{ route('user.security') }}" class="sidebar-menu-link {{ Route::is('user.security') ? 'active' : '' }}">
            <i class="bi bi-shield-lock-fill"></i>
            <span>Keamanan</span>
        </a>

        {{-- Link Riwayat (Ganti rute jika sudah ada) --}}
        <a href="#" class="sidebar-menu-link {{ Request::is('user/history*') ? 'active' : '' }}">
            <i class="bi bi-clock-history"></i>
            <span>Riwayat Layanan</span>
        </a>

        {{-- Kembali ke Beranda --}}
        <a href="{{ route('home') }}" class="sidebar-menu-link">
            <i class="bi bi-house-door-fill"></i>
            <span>Kembali ke Beranda</span>
        </a>
    </nav>

    {{-- Sidebar Footer Branding --}}
    <div class="mt-auto p-5 bg-slate-50 rounded-[1.5rem] border border-slate-100 hidden lg:block">
        <div class="flex items-center gap-3 mb-3">
            <div class="w-8 h-8 rounded-lg bg-[#123457] flex items-center justify-center shrink-0 shadow-sm">
                <i class="bi bi-bank text-[#E8A33D] text-xs"></i>
            </div>
            <div class="flex flex-col leading-tight">
                <span class="text-[11px] font-black text-[#123457] tracking-tighter">SUKABUMI</span>
                <span class="text-[8px] font-bold text-[#E8A33D] uppercase tracking-[0.2em]">One Access</span>
            </div>
        </div>
        <div class="pt-3 border-t border-slate-200/50">
            <p class="text-[9px] text-slate-400 font-bold uppercase tracking-widest leading-none">
                Official Portal v2.1.0
            </p>
        </div>
    </div>
</aside>