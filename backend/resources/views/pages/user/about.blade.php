@extends('layouts.app')

@section('title', 'Tentang Kami - Sukabumi One Access')

@section('content')

<style>
    /* 1. HERO ABOUT STYLING */
    .about-hero {
        background-color: #0A1E33;
        position: relative;
        overflow: hidden;
        padding: 5rem 1.5rem 8rem;
        border-bottom: 4px solid #E8A33D;
    }

    .bg-dot-matrix {
        position: absolute;
        inset: 0;
        opacity: 0.12;
        background-image: radial-gradient(#E8A33D 1px, transparent 0);
        background-size: 30px 30px;
    }

/* 2. VISION CARD STYLING — Mengadaptasi gaya premium E-KTP */
    .vision-card {
        background: #ffffff;
        border: 1px solid #f1f5f9;
        border-radius: 2rem;
        transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        padding: 2.5rem;
        height: 100%;
        position: relative;
        overflow: hidden;
        isolation: isolate; /* Agar elemen di dalam tidak keluar jalur */
    }

    .vision-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 24px 48px rgba(10, 30, 51, 0.1);
        border-color: #E8A33D;
    }

    /* Garis aksen kiri (Side Indicator) */
    .side-indicator {
        position: absolute;
        top: 0;
        left: 0;
        width: 5px;
        height: 0;
        background: #E8A33D;
        transition: height 0.4s ease;
        z-index: 3;
    }

    .vision-card:hover .side-indicator {
        height: 100%;
    }

    /* Nomor urut raksasa samar (Ghost Number) */
    .option-ghost-number {
        position: absolute;
        top: -0.5rem;
        right: 0.5rem;
        font-size: 6rem;
        font-weight: 900;
        line-height: 1;
        color: #0F2A4A;
        opacity: 0.04;
        z-index: 0;
        pointer-events: none;
        transition: opacity 0.4s ease;
    }

    .vision-card:hover .option-ghost-number {
        opacity: 0.07;
    }

    /* Efek pendaran (Blob Glow) */
    .vision-card::before {
        content: '';
        position: absolute;
        top: -40%;
        right: -30%;
        width: 220px;
        height: 220px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(232,163,61,0.15) 0%, transparent 70%);
        opacity: 0;
        transition: opacity 0.5s ease;
        z-index: 0;
        pointer-events: none;
    }

    .vision-card:hover::before {
        opacity: 1;
    }

    /* Box Icon */
    .icon-box-about {
        width: 60px;
        height: 60px;
        border-radius: 18px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        background: #f8fafc;
        color: #123457;
        margin-bottom: 1.5rem;
        position: relative;
        z-index: 2;
        transition: all 0.4s ease;
    }

    .vision-card:hover .icon-box-about {
        background: #123457;
        color: #E8A33D;
        box-shadow: 0 10px 24px rgba(18, 52, 87, 0.2);
    }

    .vision-card h3, .vision-card p {
        position: relative;
        z-index: 2;
    }

    /* 3. LOGO DECORATION */
    .huge-logo-bg {
        position: absolute;
        right: -5%;
        top: 10%;
        font-size: 25rem;
        color: #fff;
        opacity: 0.03;
        pointer-events: none;
        z-index: 0;
    }

    /* Tambahkan animasi mengambang untuk pattern */
    @keyframes floatPattern {
        0% { background-position: 0 0; }
        100% { background-position: 30px 30px; }
    }

    .bg-dot-matrix {
        position: absolute;
        inset: 0;
        opacity: 0.12;
        background-image: radial-gradient(#E8A33D 1px, transparent 0);
        background-size: 30px 30px;
        animation: floatPattern 10s linear infinite; /* Pattern bergerak pelan */
    }

    /* Update style background logo agar siap untuk parallax */
    .huge-logo-bg {
        position: absolute;
        right: -5%;
        top: 15%; /* turunkan sedikit */
        font-size: 25rem;
        color: #fff;
        opacity: 0.03;
        pointer-events: none;
        z-index: 0;
        will-change: transform; /* optimasi performa */
    }
</style>

{{-- 1. HERO SECTION --}}
<section class="about-hero">
    <div class="bg-dot-matrix"></div>
    <div class="huge-logo-bg">
        <img src="{{ asset('image/maskot.webp') }}" alt="Logo SOA">
    </div>
    
    <div class="max-w-7xl mx-auto relative z-10">
        <div class="text-center reveal">
            <nav class="flex justify-center items-center gap-2 text-accent text-[10px] font-bold uppercase tracking-[0.3em] mb-6">
                <a href="{{ route('home') }}" class="hover:text-white transition">Beranda</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Tentang SOA</span>
            </nav>
            <h1 class="text-4xl md:text-7xl font-extrabold text-white leading-tight tracking-tighter">
                Satu Akses untuk <br>
                <span class="text-accent italic">Sukabumi Masa Depan.</span>
            </h1>
            <p class="text-slate-400 mt-8 max-w-2xl mx-auto text-sm sm:text-lg leading-relaxed">
                Sukabumi One Access (SOA) adalah inisiatif strategis Diskominfo Kota Sukabumi untuk menyatukan seluruh birokrasi ke dalam satu genggaman tangan warga.
            </p>
        </div>
    </div>
</section>

{{-- 2. FILOSOFI SECTION --}}
<section class="py-20 sm:py-32 bg-white relative overflow-hidden">
    <div class="max-w-7xl mx-auto px-4 sm:px-8">
        <div class="grid lg:grid-cols-2 gap-16 items-center">
            
            <div class="relative reveal">
                {{-- Ilustrasi Visual --}}
                <div class="relative w-full aspect-square max-w-md mx-auto">
                    <div class="absolute inset-0 bg-primary rounded-[3rem] rotate-6"></div>
                    <div class="absolute inset-0 bg-accent rounded-[3rem] -rotate-3 opacity-20"></div>
                    <div class="absolute inset-0 bg-slate-100 rounded-[3rem] flex items-center justify-center overflow-hidden border-8 border-white shadow-2xl">
                        <img src="{{ asset('image/walikota.webp') }}" alt="Sukabumi Digital" class="w-full h-full object-cover">
                    </div>
                </div>
            </div>

            <div class="reveal" style="transition-delay: 200ms">
                <p class="text-accent font-black text-xs uppercase tracking-[0.3em] mb-4">Visi & Misi</p>
                <h2 class="text-3xl sm:text-5xl font-extrabold text-primary-dark mb-8 tracking-tight leading-tight">Mendigitalkan Tradisi, Memudahkan Akselerasi.</h2>
                <div class="space-y-6 text-slate-500 text-sm sm:text-base leading-relaxed">
                    <p>
                        Kami percaya bahwa pelayanan publik tidak seharusnya melelahkan. SOA lahir dari kegelisahan akan antrean panjang dan prosedur birokrasi yang berbelit. 
                    </p>
                    <p>
                        Melalui teknologi, kami memotong jarak antara pemerintah dan masyarakat. Setiap baris kode yang kami bangun didedikasikan untuk transparansi, efisiensi, dan akuntabilitas bagi seluruh warga Kota Sukabumi.
                    </p>
                </div>
                
                <div class="grid grid-cols-2 gap-8 mt-12" id="statsCounterAbout">
                    <div>
                        <span class="text-primary font-black text-4xl block roll-number-about" data-final="100%">0%</span>
                        <span class="text-slate-400 text-[10px] font-bold uppercase tracking-widest">Transparansi</span>
                    </div>
                    <div>
                        <span class="text-primary font-black text-4xl block roll-number-about" data-final="24/7">00/0</span>
                        <span class="text-slate-400 text-[10px] font-bold uppercase tracking-widest">Akses Layanan</span>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

{{-- 3. VALUES GRID --}}
<section class="py-20 sm:py-32 bg-slate-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-8">
        <div class="text-center mb-20 reveal">
            <p class="text-accent text-[10px] font-black uppercase tracking-[0.3em] mb-3">Nilai Utama</p>
            <h2 class="text-3xl sm:text-5xl font-extrabold text-primary-dark tracking-tight">Pilar Pelayanan Kami</h2>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            
            {{-- Value 1 --}}
            <div class="reveal">
                <div class="vision-card group">
                    <div class="side-indicator"></div>
                    <span class="option-ghost-number">01</span>
                    <div class="icon-box-about">
                        <i class="bi bi-lightning-charge-fill"></i>
                    </div>
                    <h3 class="text-xl font-bold text-primary mb-4">Kecepatan Tinggi</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">
                        Kami meminimalisir proses manual yang lambat. Dengan SOA, pengajuan dokumen dilakukan secara instan dari perangkat Anda.
                    </p>
                </div>
            </div>

            {{-- Value 2 --}}
            <div class="reveal" style="transition-delay: 150ms">
                <div class="vision-card group">
                    <div class="side-indicator"></div>
                    <span class="option-ghost-number">02</span>
                    <div class="icon-box-about">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h3 class="text-xl font-bold text-primary mb-4">Keamanan Data</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">
                        Data kependudukan Anda adalah aset berharga. Kami menggunakan enkripsi standar industri untuk menjaga privasi warga.
                    </p>
                </div>
            </div>

            {{-- Value 3 --}}
            <div class="reveal" style="transition-delay: 300ms">
                <div class="vision-card group">
                    <div class="side-indicator"></div>
                    <span class="option-ghost-number">03</span>
                    <div class="icon-box-about">
                        <i class="bi bi-eye-fill"></i>
                    </div>
                    <h3 class="text-xl font-bold text-primary mb-4">Transparansi Total</h3>
                    <p class="text-sm text-slate-400 leading-relaxed">
                        Warga berhak tahu posisi berkas mereka. Pantau setiap tahap proses verifikasi melalui fitur Lacak Berkas kami.
                    </p>
                </div>
            </div>

        </div>
    </div>
</section>

{{-- 4. DISKOMINFO BANNER --}}
<section class="py-20 bg-white">
    <div class="max-w-5xl mx-auto px-6 reveal">
        <div class="bg-primary rounded-[3rem] p-10 sm:p-20 text-center relative overflow-hidden shadow-3xl">
            <div class="absolute inset-0 bg-dot-matrix opacity-10"></div>
            
            <div class="relative z-10">
                <img src="{{ asset('image/logo.webp') }}" alt="Logo" class="w-60 mx-auto mb-10">
                <h4 class="text-2xl sm:text-4xl font-bold text-white mb-6">Membangun Sukabumi yang <br> Cerdas & Berdaya Saing.</h4>
                <p class="text-slate-400 text-sm sm:text-base max-w-2xl mx-auto mb-12">
                    SOA dikelola sepenuhnya oleh Dinas Komunikasi dan Informatika Kota Sukabumi untuk mewujudkan Smart City yang berkelanjutan.
                </p>
                <div class="flex flex-wrap justify-center gap-4">
                    <a href="https://sukabumikota.go.id" target="_blank" class="bg-white text-primary px-8 py-4 rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-accent transition-all">
                        Website Pemerintah Kota
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    // Fungsi untuk memutar angka secara acak sebelum berhenti di angka tujuan
    function rollNumber(el, finalText, totalFrames = 20, frameDuration = 50) {
        const chars = finalText.split('');
        let frame = 0;

        const timer = setInterval(() => {
            frame++;
            const display = chars.map((char, i) => {
                if (!/[0-9]/.test(char)) return char; // Abaikan simbol seperti % atau /
                
                const lockAt = Math.round(((i + 1) / chars.length) * totalFrames);
                if (frame >= lockAt) return char;
                return Math.floor(Math.random() * 10);
            }).join('');

            el.textContent = display;

            if (frame >= totalFrames) {
                el.textContent = finalText;
                clearInterval(timer);
            }
        }, frameDuration);
    }

    // Jalankan animasi hanya saat elemen terlihat di layar (scrolled into view)
    document.addEventListener('DOMContentLoaded', () => {
        const statsSection = document.getElementById('statsCounterAbout');
        if (!statsSection) return;

        let played = false;
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !played) {
                    played = true;
                    document.querySelectorAll('.roll-number-about').forEach(el => {
                        rollNumber(el, el.dataset.final);
                    });
                    observer.disconnect();
                }
            });
        }, { threshold: 0.5 });

        observer.observe(statsSection);
    });

    // Tambahkan fungsi parallax untuk background icon di Hero
    window.addEventListener('scroll', () => {
        const hugeLogo = document.querySelector('.huge-logo-bg');
        let scrollValue = window.scrollY;
        
        // Gerakkan logo ke atas lebih lambat dari scroll (efek parallax)
        if (hugeLogo) {
            hugeLogo.style.transform = `translateY(${scrollValue * 0.2}px) rotate(${scrollValue * 0.02}deg)`;
        }
    });
</script>
@endsection