@extends('layouts.app')

@section('title', 'KIA Hilang - Sukabumi One Access')

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
                <a href="{{ route('layanan.kia') }}" class="hover:text-white transition">KIA</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>KIA Hilang</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Pembaruan Kartu Identitas Anak Karena Kehilangan</p>
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
                    <h3 class="text-lg font-bold text-primary">Data Orang Tua & Anak</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom md:col-span-2">
                        <label>Nama Lengkap Orang Tua</label>
                        <input type="text" name="nama_ortu" placeholder="Masukkan nama sesuai KTP" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Orang Tua (16 Digit)</label>
                        <input type="text" name="nik_ortu" id="nik_ortu" maxlength="16" inputmode="numeric" placeholder="3277xxxxxxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga (16 Digit)</label>
                        <input type="text" name="no_kk" id="no_kk" maxlength="16" inputmode="numeric" placeholder="3277xxxxxxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Orang Tua</label>
                        <input type="email" name="email" placeholder="contoh@mail.com" required>
                    </div>
                    <div class="input-group-custom">
                        <label>No. Handphone Orang Tua (WhatsApp)</label>
                        <input type="text" name="phone" placeholder="08xxxxxxxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nama Anak yang Diajukan KIA</label>
                        <input type="text" name="nama_anak" placeholder="Nama sesuai Akta Kelahiran" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Anak yang Diajukan KIA</label>
                        <input type="text" name="nik_anak" id="nik_anak" maxlength="16" inputmode="numeric" placeholder="3277xxxxxxxx" required>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Penjelasan Permohonan Jika Diperlukan</label>
                        <textarea name="keterangan" rows="3" placeholder="Tuliskan alasan pengajuan atau keterangan tambahan"></textarea>
                    </div>
                </div>
            </div>

            {{-- CARD 2: DATA ALAMAT --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-geo-alt-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Alamat Lengkap</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom">
                        <label>Provinsi</label>
                        <select name="provinsi" id="provinsi" required>
                            <option value="">Pilih Provinsi</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kabupaten / Kota</label>
                        <select name="kota" id="kota" required disabled>
                            <option value="">Pilih Kota</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kecamatan</label>
                        <select name="kecamatan" id="kecamatan" required disabled>
                            <option value="">Pilih Kecamatan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kelurahan / Desa</label>
                        <select name="kelurahan" id="kelurahan" required disabled>
                            <option value="">Pilih Kelurahan</option>
                        </select>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Alamat Lengkap</label>
                        <input type="text" name="alamat_lengkap" placeholder="Nama jalan, nomor rumah" required>
                    </div>
                    <div class="input-group-custom">
                        <label>RT</label>
                        <input type="text" name="rt" id="rt" maxlength="3" inputmode="numeric" placeholder="001" required>
                    </div>
                    <div class="input-group-custom">
                        <label>RW</label>
                        <input type="text" name="rw" id="rw" maxlength="3" inputmode="numeric" placeholder="001" required>
                    </div>
                </div>
            </div>

            {{-- CARD 3: UPLOAD PERSYARATAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal" style="transition-delay: 200ms">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-cloud-arrow-up-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Upload Dokumen Persyaratan</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {{-- File 1 --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Surat Kehilangan dari Kepolisian</p>
                        <div class="upload-box" onclick="document.getElementById('file_kehilangan').click()">
                            <input type="file" id="file_kehilangan" name="file_kehilangan" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="placeholder1">
                                <i class="bi bi-shield-lock-fill text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Foto Surat Kehilangan</span>
                            </div>
                            <div id="previewWrap1" class="preview-wrap mx-auto">
                                <img id="preview1" class="preview-img">
                                <button type="button" class="remove-preview-btn"
                                        onclick="removePreview(event, 'file_kehilangan', 1)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 2 --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Dokumen Pendukung Lainnya (Jika Ada)</p>
                        <div class="upload-box" onclick="document.getElementById('file_pendukung').click()">
                            <input type="file" id="file_pendukung" name="file_pendukung" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="placeholder2">
                                <i class="bi bi-file-earmark-plus-fill text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Dokumen Pendukung</span>
                            </div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn"
                                        onclick="removePreview(event, 'file_pendukung', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SUBMIT --}}
            <div class="flex flex-col gap-4 reveal" style="transition-delay: 300ms">
                <button type="submit" class="w-full py-5 bg-primary text-white rounded-2xl font-black text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all uppercase tracking-[0.2em]">
                    Kirim Permohonan <i class="bi bi-send-fill ml-2"></i>
                </button>
                <a href="{{ route('layanan.kia') }}" class="text-center py-4 font-bold text-xs text-slate-400 hover:text-primary transition-all">
                    Batalkan Pengajuan
                </a>
            </div>

        </form>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. LIMIT 16 DIGIT & NUMERIC ONLY
    const limitDigit = (id) => {
        const el = document.getElementById(id);
        if(el) {
            el.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '').slice(0, 16);
            });
        }
    };
    limitDigit('nik_ortu');
    limitDigit('no_kk');
    limitDigit('nik_anak');
    limitDigit('rt');
    limitDigit('rw');

    // 2. PREVIEW FILE
    function previewFile(input, index) {
        const file = input.files[0];
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

        if (file) {
            if (!file.type.startsWith('image/')) {
                Swal.fire('Error', 'Hanya gambar yang diperbolehkan!', 'error');
                input.value = '';
                return;
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

    // 2b. HAPUS PREVIEW: kosongkan file input & balik ke tampilan placeholder
    function removePreview(event, inputId, index) {
        event.stopPropagation(); // biar nggak sekalian buka file dialog lagi

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

        input.value = '';
        preview.src = '';
        previewWrap.style.display = 'none';
        placeholder.style.display = 'block';
    }

    // 3. API WILAYAH INDONESIA
    const provSel = document.getElementById('provinsi'),
          kotaSel = document.getElementById('kota'),
          kecSel = document.getElementById('kecamatan'),
          kelSel = document.getElementById('kelurahan');

    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json`)
        .then(r => r.json()).then(data => data.forEach(p => provSel.add(new Option(p.name, p.id))));

    provSel.addEventListener('change', function() {
        kotaSel.disabled = false; kotaSel.innerHTML = '<option value="">Pilih Kota</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kotaSel.add(new Option(k.name, k.id))));
    });

    kotaSel.addEventListener('change', function() {
        kecSel.disabled = false; kecSel.innerHTML = '<option value="">Pilih Kecamatan</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kecSel.add(new Option(k.name, k.id))));
    });

    kecSel.addEventListener('change', function() {
        kelSel.disabled = false; kelSel.innerHTML = '<option value="">Pilih Kelurahan</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kelSel.add(new Option(k.name, k.id))));
    });
</script>
@endpush