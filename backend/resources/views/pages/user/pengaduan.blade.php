@extends('layouts.app')

@section('title', 'Pusat Pengaduan - Sukabumi One Access')

@section('content')

<style>
    /* 1. HERO PENGADUAN */
    .complaint-hero {
        background-color: #0A1E33;
        position: relative;
        overflow: hidden;
        padding: 5rem 1.5rem 8rem;
        border-bottom: 4px solid #E8A33D;
    }

    .bg-dot-matrix {
        position: absolute; inset: 0; opacity: 0.12;
        background-image: radial-gradient(#E8A33D 1px, transparent 0);
        background-size: 30px 30px;
    }

    /* 2. STATS CARD */
    .stats-box {
        background: #ffffff;
        border-radius: 2rem;
        margin-top: -5rem;
        position: relative;
        z-index: 30;
        box-shadow: 0 20px 50px rgba(10, 30, 51, 0.1);
        border: 1px solid #f1f5f9;
    }

    /* 3. STEPPER ALUR */
    .step-item {
        position: relative;
        text-align: center;
    }

    .step-number {
        width: 40px; height: 40px;
        background: #123457;
        color: #E8A33D;
        border-radius: 12px;
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto 1rem;
        font-weight: 800;
        box-shadow: 0 10px 20px rgba(18, 52, 87, 0.2);
    }

    /* 4. FORM STYLING */
    .complaint-form-card {
        background: #ffffff;
        border-radius: 2.5rem;
        border: 1px solid #f1f5f9;
        padding: 3rem;
    }

    .input-custom {
        width: 100%;
        padding: 1rem 1.25rem;
        background: #F8FAFC;
        border: 1.5px solid #E2E8F0;
        border-radius: 14px;
        font-size: 0.9rem;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .input-custom:focus {
        outline: none;
        border-color: #E8A33D;
        background: #ffffff;
        box-shadow: 0 0 0 4px rgba(232, 163, 61, 0.05);
    }

    .upload-area {
        border: 2px dashed #E2E8F0;
        border-radius: 1.5rem;
        padding: 2rem;
        text-align: center;
        background: #F8FAFC;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .upload-area:hover {
        border-color: #E8A33D;
        background: #fffef9;
    }

    /* Style tambahan untuk Step Item agar bagus saat jadi 2 kolom */
    .step-item {
        background: #ffffff;
        border: 1px solid #f1f5f9;
        border-radius: 1.5rem;
        padding: 1.5rem 1rem;
        height: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        transition: all 0.3s ease;
    }

    .step-item:hover {
        border-color: #E8A33D;
        transform: translateY(-5px);
    }

    @media (max-width: 640px) {
        .step-number {
            width: 32px; height: 32px;
            font-size: 0.8rem;
            border-radius: 10px;
        }
        .step-item h4 { font-size: 0.75rem; }
        .step-item p { font-size: 10px; line-height: 1.4; padding: 0 !important; }
    }
</style>

{{-- 1. HERO SECTION --}}
<section class="complaint-hero">
    <div class="bg-dot-matrix"></div>
    <div class="max-w-7xl mx-auto relative z-10 text-center">
        <div class="reveal">
            <nav class="flex justify-center items-center gap-2 text-accent text-[10px] font-bold uppercase tracking-[0.2em] mb-4">
                <a href="{{ route('home') }}" class="hover:text-white transition">Beranda</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Pusat Pengaduan</span>
            </nav>
            <h1 class="text-4xl md:text-6xl font-extrabold text-white leading-tight tracking-tighter">
                Suara Anda, <br>
                <span class="text-accent italic">Membangun Sukabumi.</span>
            </h1>
            <p class="text-slate-400 mt-6 max-w-2xl mx-auto text-sm sm:text-base leading-relaxed">
                Laporkan kendala pelayanan publik atau gangguan fasilitas kota secara cepat, transparan, dan terintegrasi dengan instansi terkait.
            </p>
        </div>
    </div>
</section>

{{-- 2. STATS SECTION --}}
<section class="max-w-5xl mx-auto px-4 sm:px-8">
    <div class="stats-box grid grid-cols-2 md:grid-cols-4 divide-x divide-slate-100 reveal" id="complaintStatsBar">
        <div class="p-6 text-center">
            {{-- Angka akan berputar dari 0 ke 1.240+ --}}
            <span class="block text-2xl font-black text-primary roll-number" data-final="1.240+">0</span>
            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Total Laporan</span>
        </div>
        <div class="p-6 text-center">
            {{-- Angka akan berputar dari 0 ke 98% --}}
            <span class="block text-2xl font-black text-emerald-500 roll-number" data-final="98%">0%</span>
            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Terselesaikan</span>
        </div>
        <div class="p-6 text-center">
            {{-- Angka akan berputar dari 0 ke 24h --}}
            <span class="block text-2xl font-black text-primary roll-number" data-final="24h">0h</span>
            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Waktu Respon</span>
        </div>
        <div class="p-6 text-center">
            <span class="block text-2xl font-black text-amber-500">Live</span>
            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Monitoring</span>
        </div>
    </div>
</section>

{{-- 3. ALUR PENGADUAN --}}
<section class="py-16 sm:py-24 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-8">
        <div class="text-center mb-12 sm:mb-16 reveal">
            <p class="text-accent text-[10px] font-black uppercase tracking-[0.3em] mb-2">Prosedur Laporan</p>
            <h2 class="text-2xl sm:text-3xl font-extrabold text-primary-dark tracking-tight leading-tight">Bagaimana Alurnya?</h2>
        </div>

        {{-- Grid: grid-cols-2 untuk mobile, md:grid-cols-4 untuk desktop --}}
        <div class="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-8">
            
            <div class="reveal">
                <div class="step-item">
                    <div class="step-number shadow-primary/20">1</div>
                    <h4 class="font-bold text-primary mb-2 text-center leading-tight">Kirim Laporan</h4>
                    <p class="text-slate-400 text-center">Isi formulir pengaduan dengan data yang valid.</p>
                </div>
            </div>

            <div class="reveal" style="transition-delay: 100ms">
                <div class="step-item">
                    <div class="step-number shadow-primary/20">2</div>
                    <h4 class="font-bold text-primary mb-2 text-center leading-tight">Verifikasi</h4>
                    <p class="text-slate-400 text-center">Admin akan memeriksa keabsahan laporan Anda.</p>
                </div>
            </div>

            <div class="reveal" style="transition-delay: 200ms">
                <div class="step-item">
                    <div class="step-number shadow-primary/20">3</div>
                    <h4 class="font-bold text-primary mb-2 text-center leading-tight">Tindak Lanjut</h4>
                    <p class="text-slate-400 text-center">Laporan diteruskan ke dinas terkait.</p>
                </div>
            </div>

            <div class="reveal" style="transition-delay: 300ms">
                <div class="step-item">
                    <div class="step-number shadow-primary/20">4</div>
                    <h4 class="font-bold text-primary mb-2 text-center leading-tight">Selesai</h4>
                    <p class="text-slate-400 text-center">Warga mendapat notifikasi penyelesaian.</p>
                </div>
            </div>

        </div>
    </div>
</section>

{{-- 4. FORM PENGADUAN --}}
<section class="py-20 bg-slate-50">
    <div class="max-w-4xl mx-auto px-4 sm:px-8">
        <div class="complaint-form-card shadow-xl shadow-slate-200/50 reveal">
            <div class="flex items-center gap-4 mb-10">
                <div class="w-12 h-12 rounded-2xl bg-primary text-accent flex items-center justify-center shadow-lg">
                    <i class="bi bi-megaphone-fill text-xl"></i>
                </div>
                <div>
                    <h3 class="text-2xl font-black text-primary">Buat Laporan</h3>
                    <p class="text-slate-400 text-xs">Identitas pelapor akan kami rahasiakan (Anonim).</p>
                </div>
            </div>

            <form action="#" method="POST" enctype="multipart/form-data" class="space-y-6">
                @csrf
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Judul Laporan</label>
                        <input type="text" class="input-custom" placeholder="Contoh: Lampu Jalan Mati" required>
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Kategori</label>
                        <select class="input-custom" required>
                            <option value="">Pilih Kategori</option>
                            <option value="Infrastruktur">Infrastruktur (Jalan, Jembatan)</option>
                            <option value="Kesehatan">Kesehatan</option>
                            <option value="Pelayanan">Pelayanan Kedinasan</option>
                            <option value="Lingkungan">Kebersihan & Lingkungan</option>
                        </select>
                    </div>
                </div>

                <div class="space-y-2">
                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Isi Laporan / Keluhan</label>
                    <textarea class="input-custom" rows="5" placeholder="Ceritakan detail kendala yang Anda alami..." required></textarea>
                </div>

                <div class="space-y-2">
                    <label class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Lampiran Foto Bukti</label>
                    <div class="upload-area" onclick="document.getElementById('file_bukti').click()">
                        <input type="file" id="file_bukti" class="hidden" accept="image/*" onchange="previewFile(this)">
                        <div id="placeholder">
                            <i class="bi bi-cloud-arrow-up text-4xl text-slate-300"></i>
                            <p class="text-xs text-slate-400 mt-2">Klik untuk unggah foto (Maks. 2MB)</p>
                        </div>
                        <img id="preview" class="hidden w-full max-h-48 object-contain rounded-xl">
                    </div>
                </div>

                <div class="pt-6">
                    <button type="submit" class="w-full bg-primary text-white py-4 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95">
                        Kirim Laporan Sekarang
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. FUNGSI ROLL NUMBER (ANIMASI DIGIT ACAK)
    function rollNumber(el, finalText, totalFrames = 25, frameDuration = 40) {
        const chars = finalText.split('');
        let frame = 0;

        const timer = setInterval(() => {
            frame++;
            const display = chars.map((char, i) => {
                // Jika bukan angka (seperti %, +, atau h), biarkan saja
                if (!/[0-9]/.test(char)) return char; 
                
                // Logika "Locking" digit satu per satu dari kiri ke kanan
                const lockAt = Math.round(((i + 1) / chars.length) * totalFrames);
                if (frame >= lockAt) return char;
                
                // Tampilkan angka acak 0-9
                return Math.floor(Math.random() * 10);
            }).join('');

            el.textContent = display;

            if (frame >= totalFrames) {
                el.textContent = finalText;
                clearInterval(timer);
            }
        }, frameDuration);
    }

    document.addEventListener('DOMContentLoaded', () => {
        // 2. TRIGGER ANIMASI SAAT SCROLL (Intersection Observer)
        const statsBar = document.getElementById('complaintStatsBar');
        if (statsBar) {
            let played = false;
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    // Jika elemen terlihat di layar (minimal 40%)
                    if (entry.isIntersecting && !played) {
                        played = true;
                        document.querySelectorAll('.roll-number').forEach(el => {
                            rollNumber(el, el.dataset.final);
                        });
                        observer.disconnect(); // Stop memantau setelah jalan sekali
                    }
                });
            }, { threshold: 0.4 });

            observer.observe(statsBar);
        }

        // 3. LOGIC PREVIEW FILE (Yang sudah ada)
        window.previewFile = function(input) {
            const file = input.files[0];
            const preview = document.getElementById('preview');
            const placeholder = document.getElementById('placeholder');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.classList.remove('hidden');
                    placeholder.classList.add('hidden');
                }
                reader.readAsDataURL(file);
            }
        }
    });
</script>
@endpush