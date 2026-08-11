@extends('layouts.app')

@section('title', 'Profil Saya - Sukabumi One Access')

@section('content')

<style>
    /* =========================================
       1. SIDEBAR DASHBOARD LAYOUT
       ========================================= */
    .dashboard-wrapper {
        display: flex;
        min-height: calc(100vh - 80px); /* Kurangi tinggi navbar utama */
        background-color: #F8FAFC;
    }

    /* SIDEBAR STYLING */
    .profile-sidebar {
        width: 280px;
        background: #ffffff;
        border-right: 1px solid #e2e8f0;
        padding: 2rem 1.5rem;
        display: flex;
        flex-direction: column;
        transition: all 0.3s ease;
    }

    .sidebar-menu-link {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 1rem 1.25rem;
        border-radius: 14px;
        font-size: 0.9rem;
        font-weight: 700;
        color: #64748b;
        transition: all 0.3s ease;
        margin-bottom: 0.5rem;
    }

    .sidebar-menu-link i { font-size: 1.2rem; }

    .sidebar-menu-link:hover {
        background: #f1f5f9;
        color: #123457;
    }

    .sidebar-menu-link.active {
        background: #123457;
        color: #f1f5f9;
        box-shadow: 0 10px 20px -5px rgba(18, 52, 87, 0.2);
    }

    /* CONTENT AREA */
    .profile-content {
        flex: 1;
        padding: 3rem;
    }

    .profile-card-premium {
        background: #ffffff;
        border-radius: 30px;
        border: 1px solid #f1f5f9;
        box-shadow: 0 10px 40px rgba(0,0,0,0.02);
        overflow: hidden;
    }

    .profile-cover {
        height: 120px;
        background: linear-gradient(135deg, #123457 0%, #0A1E33 100%);
        position: relative;
    }

    .avatar-dashboard {
        width: 100px;
        height: 100px;
        background: #ffffff;
        border-radius: 28px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        font-weight: 900;
        color: #123457;
        border: 4px solid #fff;
        position: absolute;
        bottom: -50px;
        left: 40px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }

    .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 2.5rem;
    }

    .data-item label {
        display: block;
        font-size: 0.7rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        color: #94a3b8;
        margin-bottom: 0.5rem;
    }

    .data-value {
        font-weight: 700;
        color: #1e293b;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .avatar-dashboard img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: inherit;
    }

    /* RESPONSIVE */
    @media (max-width: 1024px) {
        .profile-sidebar { width: 80px; padding: 2rem 0.75rem; align-items: center; }
        .sidebar-menu-link span, .sidebar-title-label { display: none; }
        .profile-content { padding: 1.5rem; }
    }

    @media (max-width: 640px) {
        .dashboard-wrapper { flex-direction: column; }
        .profile-sidebar { width: 100%; border-right: none; border-bottom: 1px solid #e2e8f0; flex-direction: row; overflow-x: auto; padding: 0.75rem; }
        .sidebar-menu-link { margin-bottom: 0; white-space: nowrap; }
        .info-grid { grid-template-columns: 1fr; gap: 1.5rem; }
    }
</style>

<div class="dashboard-wrapper">
    
    {{-- 1. PANGGIL SIDEBAR PARTIAL --}}
    @include('partials.sidebar-profile')

    {{-- 2. MAIN CONTENT AREA --}}
    <main class="profile-content">
        <div class="max-w-4xl mx-auto">
            
            {{-- Profile Card Premium --}}
            <div class="profile-card-premium reveal" style="transition-delay: 100ms">
                <div class="profile-cover">
                    <div class="avatar-dashboard">
                        @if(Auth::user()->profile_photo)
                            {{-- Jika User sudah upload foto --}}
                            <img src="{{ asset('storage/' . Auth::user()->profile_photo) }}" alt="Foto Profil">
                        @else
                            {{-- Jika belum ada foto, tampilkan inisial nama --}}
                            {{ strtoupper(substr(Auth::user()->name, 0, 1)) }}
                        @endif
                    </div>
                </div>

                <div class="px-10 pt-20 pb-12">
                    <div class="flex justify-between items-start mb-12">
                        <div>
                            <h1 class="text-3xl font-black text-primary">{{ Auth::user()->name }}</h1>
                            <p class="text-slate-400 text-sm font-medium mt-1">Warga Terverifikasi • ID-{{ Auth::user()->id + 1000 }}</p>
                        </div>
                        <!-- Tombol di Halaman Profile -->
                        <button onclick="openEditProfileModal()" class="bg-white border border-slate-200 text-primary px-6 py-2.5 rounded-xl font-bold text-xs hover:bg-slate-50 transition active:scale-95 shadow-sm">
                            Edit Profil
                        </button>
                    </div>

                    {{-- Data Information --}}
                    <div class="info-grid border-t border-slate-50 pt-10">
                        
                        <div class="data-item">
                            <label>Nama Lengkap</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center text-sm"><i class="bi bi-person"></i></div>
                                <span>{{ Auth::user()->name }}</span>
                            </div>
                        </div>

                        <div class="data-item">
                            <label>Alamat Email</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center text-sm"><i class="bi bi-envelope"></i></div>
                                <span>{{ Auth::user()->email }}</span>
                            </div>
                        </div>

                        <div class="data-item">
                            <label>Username Utama</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center text-sm"><i class="bi bi-at"></i></div>
                                <span>{{ Auth::user()->username }}</span>
                            </div>
                        </div>

                        <div class="data-item">
                            <label>Nomor WhatsApp</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-sky-50 text-sky-600 flex items-center justify-center text-sm"><i class="bi bi-whatsapp"></i></div>
                                <span>{{ Auth::user()->phone ?? 'Belum diatur' }}</span>
                            </div>
                        </div>

                        <div class="data-item">
                            <label>Status Kependudukan</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center text-sm"><i class="bi bi-geo-alt"></i></div>
                                <span>Kota Sukabumi</span>
                            </div>
                        </div>

                        <div class="data-item">
                            <label>Tanggal Bergabung</label>
                            <div class="data-value">
                                <div class="w-8 h-8 rounded-lg bg-rose-50 text-rose-600 flex items-center justify-center text-sm"><i class="bi bi-calendar-event"></i></div>
                                <span>{{ Auth::user()->created_at->translatedFormat('d M Y') }}</span>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            {{-- Info Alert --}}
            <div class="mt-8 bg-[#123457] rounded-[2rem] p-8 text-white relative overflow-hidden reveal" style="transition-delay: 200ms">
                
                {{-- Dekorasi Lingkaran Samar --}}
                <div class="absolute right-0 top-0 w-48 h-48 bg-white/5 rounded-full -mr-20 -mt-20"></div>
                <div class="absolute left-10 bottom-0 w-24 h-24 bg-accent/5 rounded-full -mb-10"></div>

                <div class="relative z-10 flex items-center gap-6">
                    {{-- Ikon dengan Backdrop Blur & Aksen Gold --}}
                    <div class="w-14 h-14 rounded-2xl bg-white/10 backdrop-blur-md flex items-center justify-center text-2xl shadow-xl border border-white/10">
                        <i class="bi bi-info-circle text-[#E8A33D]"></i>
                    </div>
                    
                    <div>
                        <h4 class="text-lg font-extrabold tracking-tight">Lengkapi Data Anda</h4>
                        <p class="text-slate-400 text-xs sm:text-sm mt-1 leading-relaxed">
                            Gunakan fitur <span class="text-white font-bold">Edit Profil</span> untuk memperbarui foto atau informasi kontak agar pelayanan lebih optimal.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

@endsection