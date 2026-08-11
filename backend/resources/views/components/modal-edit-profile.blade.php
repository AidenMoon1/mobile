@auth
<!-- Modal Edit Profil (Wide & Compact Premium) -->
<div id="modalEditProfile" class="soa-modal-overlay">
    <div class="soa-modal-container max-w-[500px]">
        <!-- Handle khusus Mobile (Indikator bisa ditarik) -->
        <div class="soa-mobile-handle"></div>

        <div class="p-5 sm:p-6">
            <!-- Header Ringkas -->
            <div class="flex justify-between items-center mb-5">
                <div class="flex items-center gap-2">
                    <div class="w-1.5 h-4 bg-accent rounded-full"></div>
                    <h3 class="text-sm font-bold text-primary uppercase tracking-wider">Perbarui Profil</h3>
                </div>
                <button onclick="closeEditProfileModal()" class="w-7 h-7 flex items-center justify-center rounded-full bg-slate-50 text-slate-400 hover:bg-red-50 hover:text-red-500 transition-all">
                    <i class="bi bi-x-lg text-[10px]"></i>
                </button>
            </div>

            <form action="{{ route('user.profile.update') }}" method="POST" enctype="multipart/form-data">
                @csrf
                
                <div class="flex flex-col sm:flex-row gap-6 items-start">
                    <!-- SISI KIRI: Avatar Section -->
                    <div class="flex flex-col items-center shrink-0 w-full sm:w-auto">
                        <div class="relative group">
                            <div class="w-20 h-20 rounded-2xl overflow-hidden border-2 border-slate-100 shadow-sm bg-slate-50">
                                <img id="imagePreview" 
                                     src="{{ Auth::user()->profile_photo ? asset('storage/' . Auth::user()->profile_photo) : asset('image/default-avatar.png') }}" 
                                     class="w-full h-full object-cover">
                            </div>
                            <label for="profile_photo_input" class="absolute -bottom-1 -right-1 w-7 h-7 bg-primary text-accent rounded-lg border-2 border-white shadow-md flex items-center justify-center cursor-pointer hover:scale-110 transition-all">
                                <i class="bi bi-camera-fill text-[10px]"></i>
                            </label>
                            <input type="file" id="profile_photo_input" name="profile_photo" accept="image/*" class="hidden" onchange="previewProfileImage(this)">
                        </div>
                        <p class="text-[8px] font-bold text-slate-300 uppercase tracking-widest mt-3">Maks 2MB</p>
                    </div>

                    <!-- SISI KANAN: Inputs -->
                    <div class="flex-1 w-full space-y-3">
                        <div class="space-y-1">
                            <label class="text-[9px] font-black text-slate-400 uppercase ml-1">Nama Lengkap</label>
                            <input type="text" name="name" value="{{ Auth::user()->name }}" required
                                class="w-full p-2 bg-slate-50 border border-slate-200 rounded-lg text-xs focus:outline-none focus:border-accent transition-all font-bold text-primary">
                        </div>
                        
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                            <div class="space-y-1">
                                <label class="text-[9px] font-black text-slate-400 uppercase ml-1">WhatsApp</label>
                                <input type="text" name="phone" value="{{ Auth::user()->phone }}" required
                                    class="w-full p-2 bg-slate-50 border border-slate-200 rounded-lg text-xs focus:outline-none focus:border-accent transition-all font-bold text-primary">
                            </div>
                            <div class="space-y-1">
                                <label class="text-[9px] font-black text-slate-400 uppercase ml-1">Username</label>
                                <input type="text" value="{{ Auth::user()->username }}" disabled
                                    class="w-full p-2 bg-slate-100 border border-slate-200 rounded-lg text-xs font-bold text-slate-400 cursor-not-allowed">
                            </div>
                        </div>

                        <div class="space-y-1">
                            <label class="text-[9px] font-black text-slate-400 uppercase ml-1">Email</label>
                            <input type="email" name="email" value="{{ Auth::user()->email }}" required
                                class="w-full p-2 bg-slate-50 border border-slate-200 rounded-lg text-xs focus:outline-none focus:border-accent transition-all font-bold text-primary">
                        </div>
                    </div>
                </div>

                <!-- Footer Buttons -->
                <div class="flex gap-2 mt-8 pt-5 border-t border-slate-50">
                    <button type="button" onclick="closeEditProfileModal()" 
                        class="flex-1 py-2.5 rounded-lg font-bold text-[10px] text-slate-400 hover:bg-slate-50 transition-all uppercase tracking-widest">
                        Batal
                    </button>
                    <button type="submit" 
                        class="flex-1 py-2.5 bg-primary text-white rounded-lg font-bold text-[10px] shadow-lg shadow-primary/20 hover:bg-primary-dark transition-all uppercase tracking-widest active:scale-95">
                        Simpan
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .soa-modal-overlay {
        position: fixed; inset: 0;
        background: rgba(10, 30, 51, 0); 
        backdrop-filter: blur(0px);
        display: none; align-items: center; justify-content: center;
        z-index: 10000; transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .soa-modal-overlay.active { 
        display: flex;
        background: rgba(10, 30, 51, 0.75); 
        backdrop-filter: blur(8px); 
    }

    .soa-modal-container {
        background: #ffffff;
        width: 95%;
        border-radius: 24px;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        border-top: 4px solid #E8A33D;
        transform: scale(0.9) translateY(20px);
        opacity: 0;
        transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        overflow: hidden;
    }

    .soa-modal-overlay.active .soa-modal-container { transform: scale(1) translateY(0); opacity: 1; }

    .soa-mobile-handle { 
        display: none; width: 35px; height: 4px; background: #E2E8F0; 
        border-radius: 10px; margin: 12px auto 5px; 
    }

    /* Mobile Style */
    @media (max-width: 1024px) {
        .dashboard-wrapper {
            flex-direction: column; /* Stack vertikal: Sidebar di atas, Konten di bawah */
        }

        .profile-sidebar {
            width: 100%;
            border-right: none;
            border-bottom: 1px solid #e2e8f0;
            flex-direction: row; /* Ubah ke Samping (Horizontal) */
            padding: 0.75rem 1rem;
            overflow-x: auto; /* Agar bisa di-swipe kiri-kanan */
            white-space: nowrap;
            gap: 8px;
            position: sticky;
            top: 80px; /* Menempel di bawah Navbar Utama */
            z-index: 20;
        }

        /* Hilangkan scrollbar tapi tetap bisa di-scroll */
        .profile-sidebar::-webkit-scrollbar {
            display: none;
        }

        .sidebar-menu-link {
            margin-bottom: 0;
            padding: 0.6rem 1.25rem;
            flex-shrink: 0; /* Mencegah menu gepeng */
            font-size: 0.8rem;
        }

        .sidebar-menu-link span {
            display: inline-block !important; /* PAKSA MUNCULKAN TEKS */
        }

        .sidebar-title-label, .mt-auto {
            display: none !important; /* Sembunyikan label judul & branding bawah di mobile */
        }
        
        .profile-content {
            padding: 1.5rem 1rem;
        }
    }

    @media (max-width: 640px) {
        .avatar-dashboard {
            width: 80px;
            height: 80px;
            left: 20px;
            bottom: -40px;
            font-size: 2rem;
        }
        .info-grid {
            grid-template-columns: 1fr; /* 1 Kolom info di HP */
            gap: 1.5rem;
        }
    }
</style>

<script>
    function openEditProfileModal() {
        const modal = document.getElementById('modalEditProfile');
        modal.style.display = 'flex';
        setTimeout(() => { modal.classList.add('active'); }, 10);
    }

    function closeEditProfileModal() {
        const modal = document.getElementById('modalEditProfile');
        modal.classList.remove('active');
        setTimeout(() => { modal.style.display = 'none'; }, 500);
        document.body.style.overflow = 'auto';
    }

    /* SCRIPT KLIK LUAR UNTUK TUTUP MODAL */
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('modalEditProfile');
        if (event.target == modal) {
            closeEditProfileModal();
        }
    });

    function previewProfileImage(input) {
        const file = input.files[0];
        const preview = document.getElementById('imagePreview');
        if (file) {
            if (!file.type.startsWith('image/')) {
                Swal.fire('Oops!', 'Hanya boleh file gambar ya.', 'error');
                input.value = "";
                return;
            }
            const reader = new FileReader();
            reader.onload = (e) => preview.src = e.target.result;
            reader.readAsDataURL(file);
        }
    }
</script>
@endauth