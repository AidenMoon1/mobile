{{-- resources/views/components/modal-auth.blade.php --}}

<style>
    #modalAuthOverlay{opacity:0;transition:opacity .35s ease;}
    #modalAuthContent{opacity:0;transform:scale(.92) translateY(20px);transition:opacity .35s ease,transform .35s cubic-bezier(.16,1,.3,1);}
    #modalAuthAlert.show #modalAuthOverlay{opacity:1;}
    #modalAuthAlert.show #modalAuthContent{opacity:1;transform:scale(1) translateY(0);}
    /* Animasi Denyut untuk Icon */
    @keyframes pulse-warning {
        0% {
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(232, 163, 61, 0.4);
        }
        70% {
            transform: scale(1.05);
            box-shadow: 0 0 0 15px rgba(232, 163, 61, 0);
        }
        100% {
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(232, 163, 61, 0);
        }
    }

    .animate-pulse-warning {
        animation: pulse-warning 2s infinite;
    }
</style>

<div id="modalAuthAlert" class="fixed inset-0 z-50 hidden items-center justify-center p-4 sm:p-6" onclick="if(event.target===this) closeAuthAlertModal()">
    <div id="modalAuthOverlay" class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm"></div>
    <div id="modalAuthContent" class="relative bg-white rounded-3xl p-6 sm:p-8 w-full max-w-sm shadow-2xl border border-slate-100 z-10 text-center mx-2">
        
        <!-- Icon dengan Animasi Denyut -->
        <div class="w-16 h-16 bg-amber-50 text-accent border border-amber-100 text-3xl rounded-2xl flex items-center justify-center mx-auto mb-4 animate-pulse-warning">
            <i class="bi bi-shield-lock-fill"></i>
        </div>

        <h5 class="font-extrabold text-lg sm:text-xl text-slate-900 mb-2">Akses terbatas</h5>
        <p class="text-xs sm:text-sm text-slate-500 leading-relaxed px-2">Anda diwajibkan untuk masuk akun terlebih dahulu agar dapat menggunakan sistem pengajuan layanan mandiri ini.</p>
        
        <div class="flex flex-col gap-2 mt-6">
            <a href="{{ route('login') }}" class="w-full bg-primary hover:bg-primary-dark text-white py-3 rounded-xl font-bold transition text-sm">
                Login sekarang
            </a>
            <button onclick="closeAuthAlertModal()" class="w-full bg-slate-100 hover:bg-slate-200 text-slate-600 py-3 rounded-xl font-semibold transition text-sm">
                Kembali
            </button>
        </div>
    </div>
</div>
