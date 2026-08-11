@extends('layouts.app')

@section('title', 'Akta Kematian Baru - Sukabumi One Access')

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

    .upload-box {
        border: 2px dashed #e2e8f0;
        border-radius: 1.5rem;
        padding: 1.5rem;
        text-align: center;
        transition: all 0.3s ease;
        cursor: pointer;
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

    /* Sub-section Heading */
    .sub-label {
        font-size: 10px;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.15em;
        color: #E8A33D;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .sub-label::after { content: ""; height: 1px; flex-grow: 1; background: #f1f5f9; }
</style>

{{-- 1. HEADER --}}
<section class="form-header">
    <div class="bg-dot-matrix"></div>
    <div class="max-w-4xl mx-auto relative z-10 text-center text-white">
        <div class="reveal">
            <nav class="flex justify-center items-center gap-2 text-accent text-[10px] font-bold uppercase tracking-[0.2em] mb-4">
                <a href="{{ route('disdukcapil') }}" class="hover:text-white transition">Disdukcapil</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <a href="{{ route('layanan.kematian') }}" class="hover:text-white transition">Akta Kematian</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Baru</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Pelaporan Kematian & Penerbitan Akta</p>
        </div>
    </div>
</section>

{{-- 2. FORM SECTION --}}
<section class="pb-24 bg-slate-50 min-h-screen">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 form-container">
        
        <form action="#" method="POST" enctype="multipart/form-data" class="space-y-8">
            @csrf

            {{-- CARD 1: DATA PELAPOR --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-person-lines-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Pemohon (Pelapor)</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom md:col-span-2">
                        <label>Nama Lengkap Pemohon</label>
                        <input type="text" name="nama_pemohon" placeholder="Nama sesuai KTP" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Pemohon</label>
                        <input type="text" name="nik_pemohon" id="nik_pemohon" maxlength="16" placeholder="3277..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga</label>
                        <input type="text" name="no_kk_pemohon" id="no_kk_pemohon" maxlength="16" placeholder="3277..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Kecamatan</label>
                        <select name="kecamatan_pemohon" id="kecamatan" required>
                            <option value="">Pilih Kecamatan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kelurahan</label>
                        <select name="kelurahan_pemohon" id="kelurahan" required disabled>
                            <option value="">Pilih Kelurahan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Pemohon</label>
                        <input type="email" name="email_pemohon" placeholder="contoh@mail.com" required>
                    </div>
                    <div class="input-group-custom">
                        <label>No. Handphone (WhatsApp)</label>
                        <input type="text" name="phone_pemohon" placeholder="08xxxxxxxxx" required>
                    </div>
                </div>
            </div>

            {{-- CARD 2: DATA YANG MENINGGAL --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-person-x-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Yang Meninggal</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom">
                        <label>NIK Yang Meninggal</label>
                        <input type="text" name="nik_meninggal" id="nik_meninggal" maxlength="16" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nama Yang Meninggal</label>
                        <input type="text" name="nama_meninggal" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Tanggal Kematian</label>
                        <input type="date" name="tgl_kematian" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Pukul Kematian</label>
                        <input type="time" name="jam_kematian" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Sebab Kematian</label>
                        <select name="sebab_kematian" required>
                            <option value="Sakit Biasa/Tua">Sakit Biasa/Tua</option>
                            <option value="Wabah Penyakit">Wabah Penyakit</option>
                            <option value="Kecelakaan">Kecelakaan</option>
                            <option value="Kriminalitas">Kriminalitas</option>
                            <option value="Bunuh Diri">Bunuh Diri</option>
                            <option value="Lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Yang Menerangkan</label>
                        <select name="penerang_kematian" required>
                            <option value="Kelurahan">Kelurahan</option>
                            <option value="Dokter">Dokter</option>
                            <option value="Tenaga Kesehatan">Tenaga Kesehatan</option>
                            <option value="Kepolisian">Kepolisian</option>
                        </select>
                    </div>
                </div>
            </div>

            {{-- CARD 3: DATA ORANG TUA --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Orang Tua (Yang Meninggal)</h3>
                </div>

                <div class="space-y-10">
                    {{-- Ayah --}}
                    <div class="space-y-4">
                        <div class="sub-label">Informasi Ayah</div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom md:col-span-2"><label>Nama Ayah</label><input type="text" name="nama_ayah"></div>
                            <div class="input-group-custom"><label>NIK Ayah</label><input type="text" name="nik_ayah" id="nik_ayah" maxlength="16"></div>
                            <div class="input-group-custom"><label>Tempat Lahir Ayah</label><input type="text" name="tmp_lahir_ayah"></div>
                            <div class="input-group-custom"><label>Tanggal Lahir Ayah</label><input type="date" name="tgl_lahir_ayah"></div>
                            <div class="input-group-custom"><label>Kewarganegaraan</label><select name="wn_ayah"><option value="WNI">WNI</option><option value="WNA">WNA</option></select></div>
                        </div>
                    </div>
                    {{-- Ibu --}}
                    <div class="space-y-4">
                        <div class="sub-label">Informasi Ibu</div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom md:col-span-2"><label>Nama Ibu</label><input type="text" name="nama_ibu"></div>
                            <div class="input-group-custom"><label>NIK Ibu</label><input type="text" name="nik_ibu" id="nik_ibu" maxlength="16"></div>
                            <div class="input-group-custom"><label>Tempat Lahir Ibu</label><input type="text" name="tmp_lahir_ibu"></div>
                            <div class="input-group-custom"><label>Tanggal Lahir Ibu</label><input type="date" name="tgl_lahir_ibu"></div>
                            <div class="input-group-custom"><label>Kewarganegaraan</label><select name="wn_ibu"><option value="WNI">WNI</option><option value="WNA">WNA</option></select></div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- CARD 4: DATA SAKSI --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-eye-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Saksi-Saksi</h3>
                </div>
                <div class="grid md:grid-cols-2 gap-8">
                    {{-- Saksi I --}}
                    <div class="space-y-4">
                        <h4 class="font-bold text-primary flex items-center gap-2 text-sm"><i class="bi bi-1-circle-fill text-accent"></i> SAKSI I</h4>
                        <div class="input-group-custom"><label>Nama Lengkap</label><input type="text" name="nama_saksi1"></div>
                        <div class="input-group-custom"><label>NIK</label><input type="text" name="nik_saksi1" id="nik_saksi1" maxlength="16"></div>
                        <div class="input-group-custom"><label>No. Kartu Keluarga</label><input type="text" name="kk_saksi1" id="kk_saksi1" maxlength="16"></div>
                    </div>
                    {{-- Saksi II --}}
                    <div class="space-y-4">
                        <h4 class="font-bold text-primary flex items-center gap-2 text-sm"><i class="bi bi-2-circle-fill text-accent"></i> SAKSI II</h4>
                        <div class="input-group-custom"><label>Nama Lengkap</label><input type="text" name="nama_saksi2"></div>
                        <div class="input-group-custom"><label>NIK</label><input type="text" name="nik_saksi2" id="nik_saksi2" maxlength="16"></div>
                        <div class="input-group-custom"><label>No. Kartu Keluarga</label><input type="text" name="kk_saksi2" id="kk_saksi2" maxlength="16"></div>
                    </div>
                </div>
            </div>

            {{-- CARD 5: UPLOAD PERSYARATAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg"><i class="bi bi-cloud-arrow-up-fill"></i></div>
                    <h3 class="text-lg font-bold text-primary">Upload Berkas Pendukung</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {{-- File 1 --}}
                    <div class="space-y-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Ket. Kematian</p>
                        <div class="upload-box" onclick="document.getElementById('f1').click()">
                            <input type="file" id="f1" name="file_ket_kematian" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="ph1"><i class="bi bi-image text-2xl text-slate-300 block mb-1"></i><span class="text-[9px] font-bold text-slate-400">PILIH FOTO</span></div>
                            <div id="previewWrap1" class="preview-wrap mx-auto">
                                <img id="preview1" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f1', 1)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 2 --}}
                    <div class="space-y-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">KK Yang Meninggal</p>
                        <div class="upload-box" onclick="document.getElementById('f2').click()">
                            <input type="file" id="f2" name="file_kk_meninggal" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="ph2"><i class="bi bi-image text-2xl text-slate-300 block mb-1"></i><span class="text-[9px] font-bold text-slate-400">PILIH FOTO</span></div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f2', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 3 --}}
                    <div class="space-y-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">KTP Yang Meninggal</p>
                        <div class="upload-box" onclick="document.getElementById('f3').click()">
                            <input type="file" id="f3" name="file_ktp_meninggal" accept="image/*" class="hidden" onchange="previewFile(this, 3)">
                            <div id="ph3"><i class="bi bi-image text-2xl text-slate-300 block mb-1"></i><span class="text-[9px] font-bold text-slate-400">PILIH FOTO</span></div>
                            <div id="previewWrap3" class="preview-wrap mx-auto">
                                <img id="preview3" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f3', 3)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 4 --}}
                    <div class="space-y-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Formulir F201</p>
                        <div class="upload-box" onclick="document.getElementById('f4').click()">
                            <input type="file" id="f4" name="file_f201" accept="image/*" class="hidden" onchange="previewFile(this, 4)">
                            <div id="ph4"><i class="bi bi-image text-2xl text-slate-300 block mb-1"></i><span class="text-[9px] font-bold text-slate-400">PILIH FOTO</span></div>
                            <div id="previewWrap4" class="preview-wrap mx-auto">
                                <img id="preview4" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f4', 4)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 5 --}}
                    <div class="space-y-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Pendukung Lainnya</p>
                        <div class="upload-box" onclick="document.getElementById('f5').click()">
                            <input type="file" id="f5" name="file_pendukung" accept="image/*" class="hidden" onchange="previewFile(this, 5)">
                            <div id="ph5"><i class="bi bi-plus-circle text-2xl text-slate-300 block mb-1"></i><span class="text-[9px] font-bold text-slate-400">TAMBAH</span></div>
                            <div id="previewWrap5" class="preview-wrap mx-auto">
                                <img id="preview5" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f5', 5)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SUBMIT BUTTON --}}
            <div class="flex flex-col gap-4 reveal">
                <button type="submit" class="w-full py-5 bg-primary text-white rounded-2xl font-black text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all uppercase tracking-[0.2em]">
                    Kirim Pelaporan <i class="bi bi-send-fill ml-2"></i>
                </button>
            </div>

        </form>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. LIMIT 16 DIGIT
    const limit16 = (ids) => {
        ids.forEach(id => {
            const el = document.getElementById(id);
            if(el) {
                el.addEventListener('input', function() {
                    this.value = this.value.replace(/[^0-9]/g, '').slice(0, 16);
                });
            }
        });
    };
    limit16(['nik_pemohon', 'no_kk_pemohon', 'nik_meninggal', 'nik_ayah', 'nik_ibu', 'nik_saksi1', 'kk_saksi1', 'nik_saksi2', 'kk_saksi2']);

    // 2. PREVIEW FILE (Dengan Filter & Index)
    function previewFile(input, index) {
        const file = input.files[0];
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('ph' + index);

        if (file) {
            // Filter 1: Harus Gambar
            if (!file.type.startsWith('image/')) {
                Swal.fire('Error', 'Hanya gambar yang diperbolehkan!', 'error');
                input.value = ''; return;
            }
            // Filter 2: Maksimal 2MB
            if (file.size > 2 * 1024 * 1024) {
                Swal.fire('File Terlalu Besar', 'Ukuran gambar maksimal adalah 2MB', 'warning');
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

    // 3. REMOVE PREVIEW
    function removePreview(event, inputId, index) {
        event.stopPropagation(); // Biar picker file gak kebuka lagi

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('ph' + index);

        input.value = ''; 
        preview.src = ''; 
        previewWrap.style.display = 'none'; 
        placeholder.style.display = 'block'; 
    }

    // 3. API WILAYAH (KOTA SUKABUMI)
    const kecSel = document.getElementById('kecamatan'), kelSel = document.getElementById('kelurahan');

    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/3272.json`)
        .then(r => r.json()).then(data => data.forEach(k => kecSel.add(new Option(k.name, k.id))));

    kecSel.addEventListener('change', function() {
        kelSel.disabled = false; kelSel.innerHTML = '<option value="">Pilih Kelurahan</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kelSel.add(new Option(k.name, k.name))));
    });
</script>
@endpush