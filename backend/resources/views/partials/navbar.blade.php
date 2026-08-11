{{-- resources/views/partials/navbar.blade.php --}}

<header class="sticky top-0 z-40 w-full bg-white/80 backdrop-blur-md border-b border-slate-100 transition-all duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-8 py-3 flex justify-between items-center lg:grid lg:grid-cols-[300px_1fr_300px]">
        
        <!-- Brand Logo Area -->
        <a href="{{ route('home') }}" class="flex items-center gap-3 group lg:justify-self-start">
            <div class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center shadow-lg shadow-primary/20 group-hover:scale-105 transition-transform">
                <i class="bi bi-bank text-accent text-lg"></i>
            </div>
            <div class="flex flex-col">
                <span class="font-extrabold text-primary leading-none tracking-tighter text-base sm:text-lg">SUKABUMI</span>
                <span class="text-[10px] font-bold text-accent uppercase tracking-[0.2em] leading-none mt-1">One Access</span>
            </div>
        </a>

        <!-- Desktop Navigation -->
        <nav class="hidden lg:flex items-center justify-center justify-self-center gap-8">
            @php
                $navLinks = [
                    ['name' => 'Beranda', 'route' => 'home', 'url' => route('home')],
                    ['name' => 'Layanan', 'route' => 'layanan', 'url' => route('layanan') ?? '#'],
                    ['name' => 'Pengaduan', 'route' => 'pengaduan', 'url' => route('pengaduan') ?? '#'],
                ];
            @endphp
            @foreach($navLinks as $link)
                <a href="{{ $link['url'] }}" 
                   class="relative text-sm font-bold tracking-wide transition-colors duration-200 py-2
                          {{ Route::is($link['route']) ? 'text-primary' : 'text-slate-500 hover:text-primary' }}">
                    {{ $link['name'] }}
                    @if(Route::is($link['route']))
                        <span class="absolute bottom-0 left-0 w-full h-0.5 bg-accent rounded-full"></span>
                    @endif
                </a>
            @endforeach
            {{-- Cari baris "Tentang" dan ganti href-nya --}}
            <a href="{{ route('about') }}" 
            class="relative text-sm font-bold tracking-wide transition-colors duration-200 py-2 
            {{ Route::is('about') ? 'text-primary' : 'text-slate-500 hover:text-primary' }}">
                Tentang
                
                {{-- Garis bawah otomatis muncul jika sedang di halaman Tentang --}}
                @if(Route::is('about'))
                    <span class="absolute bottom-0 left-0 w-full h-0.5 bg-accent rounded-full"></span>
                @endif
            </a>
        </nav>

        <!-- Right Side: Actions -->
        <div class="flex items-center justify-end gap-3 sm:gap-5 lg:justify-self-end">
            <button class="relative group p-2 rounded-xl hover:bg-slate-50 transition-colors text-slate-500 hover:text-primary">
                <i class="bi bi-bell text-xl"></i>
                <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
            </button>

            <div class="h-8 w-[1px] bg-slate-200 mx-1 hidden md:block"></div>
            
            @auth
                <!-- User Dropdown Desktop -->
                <div class="relative" id="user-menu-wrapper">
                    {{-- Ganti bagian button dropdown desktop --}}
                    <button onclick="toggleUserDropdown()" 
                    class="inline-flex items-center gap-3 bg-primary hover:bg-primary-dark text-white text-xs sm:text-sm font-bold px-4 py-2 rounded-xl shadow-md transition-all active:scale-95">
                        
                        {{-- Foto Profil / Icon --}}
                        <div class="w-7 h-7 rounded-lg overflow-hidden border border-accent/30 flex items-center justify-center bg-white/10">
                            @if(Auth::user()->profile_photo)
                                <img src="{{ asset('storage/' . Auth::user()->profile_photo) }}" class="w-full h-full object-cover">
                            @else
                                <i class="bi bi-person-circle text-base text-accent"></i>
                            @endif
                        </div>

                        <span class="max-w-[100px] truncate">{{ Auth::user()->name }}</span>
                        <i class="bi bi-chevron-down text-[10px]"></i>
                    </button>

                    <!-- Dropdown Menu -->
                    <div id="user-dropdown-menu" class="hidden absolute right-0 mt-3 w-48 bg-white rounded-2xl shadow-2xl border border-slate-100 py-2 z-50 animate__animated animate__fadeInUp animate__faster">
                        <div class="px-4 py-2 border-b border-slate-50 mb-1">
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Menu Akun</p>
                        </div>
                        <a href="{{ route('user.profile') }}" class="flex items-center gap-3 px-4 py-2.5 text-sm font-semibold text-slate-600 hover:bg-slate-50 hover:text-primary transition-all">
                            <i class="bi bi-person-badge text-accent"></i> Lihat Profil
                        </a>
                        <div class="border-t border-slate-50 my-1"></div>
                        <form action="{{ route('logout') }}" method="POST">
                            @csrf
                            <!-- Logout Button di Dropdown -->
                            <button type="button" onclick="openLogoutModal()" class="group w-full flex items-center gap-3 px-4 py-2.5 rounded-xl hover:bg-red-50 transition-all duration-200">
                                <div class="w-8 h-8 rounded-lg bg-red-50 text-red-500 flex items-center justify-center group-hover:bg-red-500 group-hover:text-white transition-all">
                                    <i class="bi bi-power text-lg"></i>
                                </div>
                                <div class="flex flex-col text-left">
                                    <span class="text-xs font-bold text-red-500">Keluar Sesi</span>
                                    <span class="text-[10px] text-red-300">Akhiri akses login</span>
                                </div>
                            </button>
                        </form>
                    </div>
                </div>
            @else
                <!-- Tombol Masuk yang lama biarkan tetap di sini -->
                <a href="{{ route('login') }}" 
                class="inline-flex items-center bg-primary hover:bg-primary-dark text-white text-xs sm:text-sm font-bold px-6 py-2.5 rounded-xl shadow-md shadow-primary/10 transition-all active:scale-95">
                    Masuk
                </a>
            @endauth

            <!-- HAMBURGER MENU (Mobile) -->
            <button onclick="toggleSidebar(true)" class="md:hidden p-2 text-primary hover:bg-slate-50 rounded-xl transition">
                <i class="bi bi-list text-2xl"></i>
            </button>
        </div>
    </div>
</header>

<!-- ================= SIDEBAR MOBILE ================= -->
<div id="sidebar-overlay" onclick="toggleSidebar(false)" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] hidden opacity-0 transition-opacity duration-300"></div>

<aside id="mobile-sidebar" class="fixed top-0 right-0 h-full w-[300px] bg-white z-[101] shadow-2xl translate-x-full transition-transform duration-500 cubic-bezier(0.16, 1, 0.3, 1) flex flex-col">
    <!-- Header Sidebar -->
    <div class="p-6 flex items-center justify-between border-b border-slate-50">
        <div class="flex items-center gap-2">
            <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
                <i class="bi bi-bank text-accent text-sm"></i>
            </div>
            <span class="font-black text-primary tracking-tighter">SUKABUMI</span>
        </div>
        <button onclick="toggleSidebar(false)" class="w-10 h-10 flex items-center justify-center bg-slate-50 text-slate-500 rounded-full">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <!-- Navigasi Sidebar -->
    <div class="flex-1 py-8 px-6 space-y-2 overflow-y-auto">
        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-[0.2em] mb-4">Menu</p>
        <a href="{{ route('home') }}" class="flex items-center gap-4 py-3.5 px-4 rounded-2xl font-bold {{ Route::is('home') ? 'bg-primary/5 text-primary' : 'text-slate-500' }}">
            <i class="bi bi-house-door text-lg"></i> Beranda
        </a>
        <a href="{{ route('layanan') }}" class="flex items-center gap-4 py-3.5 px-4 rounded-2xl font-bold text-slate-500">
            <i class="bi bi-grid text-lg"></i> Layanan
        </a>
        <a href="#" class="flex items-center gap-4 py-3.5 px-4 rounded-2xl font-bold text-slate-500">
            <i class="bi bi-chat-dots text-lg"></i> Pengaduan
        </a>
    </div>

    <!-- Footer Sidebar (Login/Profil & Logout) -->
    <div class="p-6 border-t border-slate-50 bg-slate-50/50">
        @auth
            <div class="space-y-3">
                <div class="p-4 bg-primary/5 rounded-2xl border border-primary/10">
                    <div class="flex items-center gap-3 mb-4">
                        <div class="w-12 h-12 rounded-2xl bg-primary flex items-center justify-center text-white font-bold border-2 border-accent overflow-hidden">
                            @if(Auth::user()->profile_photo)
                                <img src="{{ asset('storage/' . Auth::user()->profile_photo) }}" class="w-full h-full object-cover">
                            @else
                                {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                            @endif
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xs text-slate-400 font-bold uppercase tracking-widest">Akun Saya</span>
                            <span class="font-black text-primary truncate max-w-[150px]">{{ Auth::user()->name }}</span>
                        </div>
                    </div>
                    <nav class="space-y-1">
                        <a href="#" class="flex items-center gap-3 py-2 text-sm font-bold text-slate-600">
                            <i class="bi bi-person-badge text-accent"></i> Profil
                        </a>
                    </nav>
                </div>
                
                {{-- Tombol Logout Sidebar (Trigger Modal Konfirmasi) --}}
                <button type="button" onclick="toggleSidebar(false); openLogoutModal()" class="w-full flex items-center justify-center gap-2 bg-red-50 text-red-600 py-4 rounded-2xl font-bold text-sm transition active:scale-95">
                    Keluar Sesi <i class="bi bi-power"></i>
                </button>
            </div>
        @endauth
    </div>
</aside>

<style>
    /* Memastikan gambar profil di navbar tetap proporsional */
    .w-7 img, .w-12 img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
</style>

<script>
    function toggleSidebar(show) {
        const sidebar = document.getElementById('mobile-sidebar');
        const overlay = document.getElementById('sidebar-overlay');
        if (show) {
            overlay.classList.remove('hidden');
            setTimeout(() => { overlay.classList.add('opacity-100'); sidebar.classList.remove('translate-x-full'); }, 10);
            document.body.style.overflow = 'hidden';
        } else {
            sidebar.classList.add('translate-x-full');
            overlay.classList.remove('opacity-100');
            setTimeout(() => { overlay.classList.add('hidden'); }, 300);
            document.body.style.overflow = 'auto';
        }
    }

    function toggleUserDropdown() {
        const menu = document.getElementById('user-dropdown-menu');
        menu.classList.toggle('hidden');
    }

    // Menutup dropdown jika klik di luar area profil
    window.addEventListener('click', function(e) {
        const wrapper = document.getElementById('user-menu-wrapper');
        const menu = document.getElementById('user-dropdown-menu');
        if (wrapper && !wrapper.contains(e.target)) {
            menu.classList.add('hidden');
        }
    });
</script>
