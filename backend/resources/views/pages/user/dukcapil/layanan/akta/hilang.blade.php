@extends('layouts.app')

@section('title', 'Akta Kelahiran Hilang - Sukabumi One Access')

@section('content')

<style>
    .form-header {
        background-color: #0A1E33;
        padding: 3rem 1.5rem 6rem;
        position: relative;
        overflow: hidden;
        border-bottom: 4px solid #E8A33D;
    }

    .bg-dot-matrix {
        position: absolute;
        inset: 0;
        opacity: 0.1;
        background-image: radial-gradient(#E8A33D 1px, transparent 0);
        background-size: 30px 30px;
    }

    .form-container {
        margin-top: -4rem;
        position: relative;
        z-index: 20;
    }

    .input-group-custom {
        background: #f8fafc;
        border: 1.5px solid #e2e8f0;
        border-radius: 1rem;
        padding: 0.75rem 1rem;
        transition: all 0.3s ease;
    }

    .input-group-custom:focus-within {
        border-color: #E8A33D;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(232, 163, 61, 0.05);
    }

    .input-group-custom label {
        display: block;
        font-size: 0.65rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: #94a3b8;
        margin-bottom: 0.25rem;
    }

    .input-group-custom input, 
    .input-group-custom select, 
    .input-group-custom textarea {
        width: 100%;
        background: transparent;
        border: none;
        outline: none;
        font-size: 0.9rem;
        font-weight: 700;
        color: #123457;
    }

    /* Upload Area Styling */
    .upload-box {
        border: 2px dashed #e2e8f0;
        border-radius: 1.5rem;
        padding: 2rem;
        text-align: center;
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
        background: #f8fafc;
    }

    .upload-box:hover {
        border-color: #E8A33D;
        background: #fffef9;
    }

    /* wrapper preview supaya tombol hapus bisa diposisikan relatif terhadap gambar */
    .preview-wrap {
        position: relative;
        display: none;
    }

    .preview-img {
        width: 100%;
        max-height: 200px;
        object-fit: contain;
        border-radius: 1rem;
        display: block;
    }

    .remove-preview-btn {
        position: absolute;
        top: -8px;
        right: -8px;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background: #ef4444;
        color: #ffffff;
        border: 3px solid #ffffff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.8rem;
        cursor: pointer;
        box-shadow: 0 6px 14px rgba(0,0,0,0.18);
        transition: background 0.2s ease, transform 0.2s ease;
        z-index: 5;
    }

    .remove-preview-btn:hover {
        background: #dc2626;
        transform: scale(1.08);
    }
</style>

{{-- 1. HEADER --}}
<section class="form-header">
    <div class="bg-dot-matrix"></div>
    <div class="max-w-4xl mx-auto relative z-10 text-center text-white">
        <div class="reveal">
            <nav class="flex justify-center items-center gap-2 text-accent text-[10px] font-bold uppercase tracking-[0.2em] mb-4">
                <a href="{{ route('disdukcapil') }}" class="hover:text-white transition">Disdukcapil</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <a href="{{ route('layanan.akta') }}" class="hover:text-white transition">Akta Kelahiran</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Hilang</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Penerbitan Akta Kelahiran Karena Kehilangan Dokumen</p>
        </div>
    </div>
</section>

{{-- 2. FORM SECTION --}}
<section class="pb-24 bg-slate-50 min-h-screen">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 form-container">
        
        <form action="#" method="POST" enctype="multipart/form-data" class="space-y-6">
            @csrf

            {{-- CARD 1: DATA PEMOHON --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Pemohon</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom md:col-span-2">
                        <label>Nama Lengkap Pemohon</label>
                        <input type="text" name="nama_pemohon" placeholder="Nama sesuai KTP" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Pemohon (16 Digit)</label>
                        <input type="text" name="nik_pemohon" id="nik_pemohon" maxlength="16" placeholder="3272..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga (16 Digit)</label>
                        <input type="text" name="no_kk_pemohon" id="no_kk_pemohon" maxlength="16" placeholder="3272..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Kecamatan</label>
                        <select name="kecamatan_pemohon" id="kecamatan_pemohon" required>
                            <option value="">Pilih Kecamatan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kelurahan / Desa</label>
                        <select name="kelurahan_pemohon" id="kelurahan_pemohon" required disabled>
                            <option value="">Pilih Kelurahan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Pemohon</label>
                        <input type="email" name="email_pemohon" placeholder="contoh@mail.com" required>
                    </div>
                    <div class="input-group-custom">
                        <label>No. Handphone Pemohon (WhatsApp)</label>
                        <input type="text" name="phone_pemohon" placeholder="08xxxx" required>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Penjelasan Permohonan Jika Diperlukan</label>
                        <textarea name="keterangan" rows="2" placeholder="Tuliskan keterangan tambahan jika ada"></textarea>
                    </div>
                </div>
            </div>

            {{-- CARD 2: DATA AKTA KELAHIRAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-file-earmark-person"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Akta Kelahiran yang Hilang</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom">
                        <label>NIK Pemilik Akta Kelahiran</label>
                        {{-- Tambahkan maxlength dan inputmode --}}
                        <input type="text" name="nik_pemilik" id="nik_pemilik" 
                            maxlength="16" inputmode="numeric" 
                            placeholder="3272xxxxxxxxxxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nama Lengkap Pemilik Akta</label>
                        <input type="text" name="nama_pemilik" placeholder="Sesuai data Akta/KK" required>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Nomor Kartu Keluarga Pemilik</label>
                        {{-- Tambahkan maxlength dan inputmode --}}
                        <input type="text" name="no_kk_pemilik" id="no_kk_pemilik" 
                            maxlength="16" inputmode="numeric" 
                            placeholder="3272xxxxxxxxxxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Tempat Kelahiran (Kota/Kabupaten)</label>
                        <input type="text" name="tempat_lahir" placeholder="Contoh: Kota Sukabumi" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Tanggal Kelahiran</label>
                        <input type="date" name="tgl_lahir" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nama Lengkap Ayah</label>
                        <input type="text" name="nama_ayah" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nama Lengkap Ibu</label>
                        <input type="text" name="nama_ibu" required>
                    </div>
                </div>
            </div>

            {{-- CARD 3: UPLOAD PERSYARATAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-cloud-arrow-up-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Upload Dokumen Persyaratan</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {{-- File 1 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Surat Kehilangan Kepolisian</p>
                        <div class="upload-box" onclick="document.getElementById('f1').click()">
                            <input type="file" id="f1" name="file_kehilangan" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="ph1">
                                <i class="bi bi-shield-lock text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Foto Surat Kehilangan</span>
                            </div>
                            <div id="previewWrap1" class="preview-wrap mx-auto">
                                <img id="preview1" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f1', 1)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 2 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Dokumen Pendukung Lainnya (Jika Ada)</p>
                        <div class="upload-box" onclick="document.getElementById('f2').click()">
                            <input type="file" id="f2" name="file_pendukung" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="ph2">
                                <i class="bi bi-file-earmark-plus text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Dokumen (KK/KTP/Ijazah)</span>
                            </div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f2', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SUBMIT --}}
            <div class="flex flex-col gap-4 reveal">
                <button type="submit" class="w-full py-5 bg-primary text-white rounded-2xl font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all">
                    Kirim Permohonan <i class="bi bi-send-fill ml-2"></i>
                </button>
                <a href="{{ route('layanan.akta') }}" class="text-center py-4 font-bold text-xs text-slate-400 hover:text-primary transition-all">Batalkan</a>
            </div>

        </form>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. LIMIT DIGIT
    const limitIds = ['nik_pemohon','no_kk_pemohon','nik_pemilik','no_kk_pemilik'];
    limitIds.forEach(id => {
        const el = document.getElementById(id);
        if(el) el.addEventListener('input', function() { this.value = this.value.replace(/[^0-9]/g, '').slice(0, 16); });
    });

    // 2. PREVIEW FILE (Updated)
    function previewFile(input, index) {
        const file = input.files[0];
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('ph' + index);

        if (file) {
            if (!file.type.startsWith('image/')) {
                Swal.fire('Error', 'Hanya gambar yang diperbolehkan!', 'error');
                input.value = ''; return;
            }
            const reader = new FileReader();
            reader.onload = (e) => {
                preview.src = e.target.result;
                previewWrap.style.display = 'block';
                placeholder.style.display = 'none';
            }
            reader.readAsDataURL(file);
        }
    }

    // 3. REMOVE PREVIEW (New)
    function removePreview(event, inputId, index) {
        event.stopPropagation(); // Mencegah picker file terbuka kembali secara otomatis

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('ph' + index);

        input.value = ''; // Reset input file
        preview.src = ''; // Hapus tampilan gambar
        previewWrap.style.display = 'none'; // Sembunyikan wrapper preview
        placeholder.style.display = 'block'; // Munculkan kembali icon placeholder
    }

    // 3. API WILAYAH (Sukabumi Kota Context)
    const kecSel = document.getElementById('kecamatan_pemohon'), 
          kelSel = document.getElementById('kelurahan_pemohon');

    // Fetch Sukabumi Kota (32.72)
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/3272.json`)
        .then(r => r.json()).then(data => data.forEach(k => kecSel.add(new Option(k.name, k.id))));

    kecSel.addEventListener('change', function() {
        kelSel.disabled = false; kelSel.innerHTML = '<option value="">Pilih Kelurahan</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kelSel.add(new Option(k.name, k.id))));
    });
</script>
@endpush