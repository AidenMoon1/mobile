@auth
<div id="jkhLogoutConfirm" class="jkh-modal-overlay">
    <div class="jkh-modal-container">
        <!-- Handle Slider khusus Mobile -->
        <div class="jkh-mobile-handle"></div>

        <div class="jkh-modal-body-compact">
            <!-- Icon Section -->
            <div class="jkh-icon-warning-wrapper">
                <div class="jkh-icon-circle-premium">
                    <i class="bi bi-box-arrow-right"></i>
                </div>
            </div>
            
            <!-- Text Content -->
            <div class="jkh-text-content">
                <h3>Konfirmasi Keluar?</h3>
                <p>Apakah Anda yakin ingin keluar dari sistem sebagai <span class="jkh-highlight-name">{{ Auth::user()->name }}</span>? Sesi Anda akan diakhiri.</p>
            </div>

            <!-- Form Logout Tersembunyi -->
            <form id="jkh-logout-form-modal" action="{{ route('logout') }}" method="POST" style="display: none;">
                @csrf
            </form>
        </div>

        <!-- Footer: Buttons -->
        <div class="jkh-modal-footer-compact">
            <button type="button" class="jkh-btn-cancel" onclick="closeLogoutModal()">Batalkan</button>
            <button type="button" class="jkh-btn-confirm-logout" onclick="document.getElementById('jkh-logout-form-modal').submit()">
                Ya, Keluar
            </button>
        </div>
    </div>
</div>

<style>
    :root {
        --soa-navy: #123457;
        --soa-navy-dark: #0A1E33;
        --soa-gold: #E8A33D; 
        --soa-gold-soft: rgba(232, 163, 61, 0.1);
        --soa-red: #EF4444;  /* Warna Merah untuk tombol keluar */
        --soa-red-dark: #DC2626; /* Merah gelap untuk hover */
        --soa-gray: #64748B;
        --soa-transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .jkh-modal-overlay {
        position: fixed; inset: 0;
        background: rgba(10, 30, 51, 0); 
        backdrop-filter: blur(0px);
        display: flex; align-items: center; justify-content: center;
        z-index: 9999; visibility: hidden; pointer-events: none;
        transition: var(--soa-transition);
    }

    .jkh-modal-overlay.jkh-active { 
        background: rgba(10, 30, 51, 0.7); 
        backdrop-filter: blur(10px); 
        visibility: visible; 
        pointer-events: auto; 
    }

    .jkh-modal-container {
        background: #ffffff;
        width: 92%;
        max-width: 360px; 
        border-radius: 30px;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        transform: scale(0.9) translateY(20px);
        opacity: 0;
        transition: var(--soa-transition);
        overflow: hidden;
        border-top: 6px solid var(--soa-gold); 
    }

    .jkh-modal-overlay.jkh-active .jkh-modal-container { 
        transform: scale(1) translateY(0); 
        opacity: 1; 
    }

    .jkh-modal-body-compact {
        padding: 40px 30px 20px;
        text-align: center;
    }

    .jkh-icon-circle-premium {
        width: 70px; height: 70px;
        background: var(--soa-gold-soft); 
        color: var(--soa-gold); 
        border-radius: 24px;
        display: flex; align-items: center; justify-content: center;
        font-size: 28px;
        margin: 0 auto 20px;
        border: 1px solid rgba(232, 163, 61, 0.2);
        animation: soaPulseGold 2s infinite;
    }

    @keyframes soaPulseGold {
        0% { box-shadow: 0 0 0 0 rgba(232, 163, 61, 0.4); }
        70% { box-shadow: 0 0 0 15px rgba(232, 163, 61, 0); }
        100% { box-shadow: 0 0 0 0 rgba(232, 163, 61, 0); }
    }

    .jkh-text-content h3 { 
        margin: 0; font-size: 20px; color: var(--soa-navy); font-weight: 800; 
        letter-spacing: -0.02em;
    }

    .jkh-text-content p { 
        margin: 12px 0 0; font-size: 14px; color: var(--soa-gray); line-height: 1.6; 
    }

    /* NAMA USER WARNA BIRU */
    .jkh-highlight-name { color: var(--soa-navy); font-weight: 800; }

    .jkh-modal-footer-compact {
        padding: 10px 30px 35px;
        display: flex; gap: 12px;
    }

    .jkh-btn-cancel {
        flex: 1; height: 48px;
        background: #F1F5F9; border: none;
        color: var(--soa-navy); font-weight: 700;
        border-radius: 15px; cursor: pointer; transition: 0.3s;
        font-size: 13px;
    }
    .jkh-btn-cancel:hover { background: #E2E8F0; }

    /* TOMBOL KELUAR WARNA MERAH */
    .jkh-btn-confirm-logout {
        flex: 1; height: 48px;
        background: var(--soa-red); /* Warna Merah */
        color: white; border: none;
        border-radius: 15px; font-weight: 700;
        cursor: pointer; transition: 0.3s;
        font-size: 13px;
        box-shadow: 0 10px 15px -3px rgba(239, 68, 68, 0.3);
    }
    
    /* HOVER TOMBOL KELUAR MERAH GELAP */
    .jkh-btn-confirm-logout:hover { 
        background: var(--soa-red-dark); 
        transform: translateY(-2px); 
        box-shadow: 0 12px 20px -3px rgba(239, 68, 68, 0.4);
    }

    .jkh-mobile-handle { 
        display: none; width: 40px; height: 5px; background: #E2E8F0; 
        border-radius: 10px; margin: 15px auto 0; 
    }

    @media (max-width: 768px) {
        .jkh-modal-overlay { align-items: flex-end; }
        .jkh-modal-container {
            width: 100%; max-width: 100%;
            border-radius: 30px 30px 0 0;
            transform: translateY(100%); opacity: 1;
            border-top: 5px solid var(--soa-gold);
        }
        .jkh-modal-overlay.jkh-active .jkh-modal-container { transform: translateY(0); }
        .jkh-mobile-handle { display: block; }
        .jkh-modal-footer-compact { 
            flex-direction: column-reverse; 
            padding-bottom: 40px;
        }
    }
</style>
@endauth

<script>
    function openLogoutModal() {
        const overlay = document.getElementById('jkhLogoutConfirm');
        if(overlay) {
            overlay.classList.add('jkh-active');

        }
    }

    function closeLogoutModal() {
        const overlay = document.getElementById('jkhLogoutConfirm');
        if(overlay) {
            overlay.classList.remove('jkh-active');
            document.body.style.overflow = 'auto';
        }
    }

    window.addEventListener('click', function(event) {
        const overlay = document.getElementById('jkhLogoutConfirm');
        if (event.target == overlay) { closeLogoutModal(); }
    });
</script>