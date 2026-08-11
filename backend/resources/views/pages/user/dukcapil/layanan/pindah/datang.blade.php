@extends('layouts.app')

@section('title', 'Pindah Datang Luar Kota - Sukabumi One Access')

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
                <a href="{{ route('layanan.pindah') }}" class="hover:text-white transition">Surat Pindah</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Pindah Datang</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Pengajuan Kedatangan Penduduk dari Luar Kota Sukabumi</p>
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
                        <input type="text" name="nama_pemohon" placeholder="Sesuai KTP/SKPWNI" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Pemohon (16 Digit)</label>
                        <input type="text" name="nik_pemohon" id="nik_pemohon" maxlength="16" placeholder="3272..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Jenis Permohonan</label>
                        <select name="jenis_permohonan" required>
                            <option value="Surat Keterangan Pindah">Surat Keterangan Pindah</option>
                            <option value="Surat Keterangan Pindah">Surat Keterangan Pindah Luar Negeri (SKPLN)</option>
                            <option value="Surat Keterangan Pindah">Surat Keterangan Tempat Tinggal (SKTT) Bagi Orang Asing Terbatas</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga (16 Digit)</label>
                        <input type="text" name="no_kk" id="no_kk" maxlength="16" placeholder="3272..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Pemohon</label>
                        <input type="email" name="email" placeholder="mail@example.com" required>
                    </div>
                    <div class="input-group-custom">
                        <label>No. Handphone (WhatsApp)</label>
                        <input type="text" name="phone" placeholder="08xxxx" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Jenis Perpindahan</label>
                        <select name="jenis_perpindahan" required>
                            <option value="Kepala Keluarga">Kepala Keluarga</option>
                            <option value="Kepala Keluarga dan Seluruh Anggota">Kepala Keluarga dan Seluruh Anggota</option>
                            <option value="Kepala Keluarga dan Sebagian Anggota">Kepala Keluarga dan Sebagian Anggota</option>
                            <option value="Anggota Keluarga">Anggota Keluarga</option>
                        </select>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Klasifikasi Pindah</label>
                        <select name="klasifikasi_pindah" required>
                            <option value="Antar Kabupaten/Kota dalam satu provinsi">Antar Kabupaten/Kota dalam satu provinsi</option>
                            <option value="Antar Provinsi">Antar Provinsi</option>
                        </select>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Penjelasan Permohonan</label>
                        <textarea name="keterangan" rows="2" placeholder="Tuliskan alasan pindah datang"></textarea>
                    </div>
                    <div class="input-group-custom">
                        <label>Anggota Keluarga yang Pindah</label>
                        <select name="status_pindah" required>
                            <option value="Numpang Kartu Keluarga">Numpang Kartu Keluarga</option>
                            <option value="Membuat KK Baru">Membuat KK Baru</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Anggota Keluarga yang Tidak Pindah</label>
                        <select name="status_tidak_pindah" required>
                            <option value="Numpang Kartu Keluarga">Numpang Kartu Keluarga</option>
                            <option value="Tetap di KK Lama">Tetap di KK Lama</option>
                        </select>
                    </div>
                </div>
            </div>

            {{-- CARD 2: ALAMAT ASAL --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-geo-alt-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Alamat Asal (Luar Kota)</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom"><label>Provinsi</label><select name="prov_asal" id="prov_asal" required><option value="">Pilih</option></select></div>
                    <div class="input-group-custom"><label>Kota</label><select name="kota_asal" id="kota_asal" required disabled></select></div>
                    <div class="input-group-custom"><label>Kecamatan</label><select name="kec_asal" id="kec_asal" required disabled></select></div>
                    <div class="input-group-custom"><label>Kelurahan</label><select name="kel_asal" id="kel_asal" required disabled></select></div>
                    <div class="input-group-custom md:col-span-2"><label>Alamat Lengkap Asal</label><input type="text" name="alamat_asal" required></div>
                    <div class="input-group-custom"><label>RT</label><input type="text" name="rt_asal" id="rt_asal" maxlength="3"></div>
                    <div class="input-group-custom"><label>RW</label><input type="text" name="rw_asal" id="rw_asal" maxlength="3"></div>
                </div>
            </div>

            {{-- CARD 3: ALAMAT TUJUAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-house-door-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Alamat Tujuan (Kota Sukabumi)</h3>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom"><label>Provinsi</label><select name="prov_tujuan" id="prov_tujuan" required><option value="">Pilih</option></select></div>
                    <div class="input-group-custom"><label>Kota</label><select name="kota_tujuan" id="kota_tujuan" required disabled></select></div>
                    <div class="input-group-custom"><label>Kecamatan</label><select name="kec_tujuan" id="kec_tujuan" required disabled></select></div>
                    <div class="input-group-custom"><label>Kelurahan</label><select name="kel_tujuan" id="kel_tujuan" required disabled></select></div>
                    <div class="input-group-custom md:col-span-2"><label>Alamat Lengkap Tujuan</label><input type="text" name="alamat_tujuan" required></div>
                    <div class="input-group-custom"><label>RT</label><input type="text" name="rt_tujuan" id="rt_tujuan" maxlength="3"></div>
                    <div class="input-group-custom"><label>RW</label><input type="text" name="rw_tujuan" id="rw_tujuan" maxlength="3"></div>
                </div>
            </div>

            {{-- CARD 4: UPLOAD PERSYARATAN --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-cloud-arrow-up-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Upload Dokumen Persyaratan</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {{-- File 1: SKPWNI --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Surat Pindah WNI (SKPWNI)</p>
                        <div class="upload-box" onclick="document.getElementById('f1').click()">
                            <input type="file" id="f1" name="file_skpwni" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="placeholder1">
                                <i class="bi bi-file-earmark-arrow-down text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Foto SKPWNI</span>
                            </div>
                            <div id="previewWrap1" class="preview-wrap mx-auto">
                                <img id="preview1" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f1', 1)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 2: KTP --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto KTP-el (Opsional)</p>
                        <div class="upload-box" onclick="document.getElementById('f2').click()">
                            <input type="file" id="f2" name="file_ktp" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="placeholder2">
                                <i class="bi bi-person-vcard text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Foto KTP</span>
                            </div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f2', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 3: Pendukung --}}
                    <div class="space-y-3 md:col-span-2">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Dokumen Pendukung Lainnya</p>
                        <div class="upload-box" onclick="document.getElementById('f3').click()">
                            <input type="file" id="f3" name="file_pendukung" accept="image/*" class="hidden" onchange="previewFile(this, 3)">
                            <div id="placeholder3">
                                <i class="bi bi-file-earmark-plus text-3xl text-slate-300 block mb-2"></i>
                                <span class="text-[10px] font-bold text-slate-400">Pilih Dokumen Tambahan</span>
                            </div>
                            <div id="previewWrap3" class="preview-wrap mx-auto">
                                <img id="preview3" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f3', 3)">
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
                <a href="{{ route('disdukcapil') }}" class="text-center py-4 font-bold text-xs text-slate-400 hover:text-primary transition-all">Batalkan Pengajuan</a>
            </div>

        </form>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. LIMIT DIGIT
    const applyLimit = (id, len) => {
        const el = document.getElementById(id);
        if(el) el.addEventListener('input', function() { this.value = this.value.replace(/[^0-9]/g, '').slice(0, len); });
    };
    ['nik_pemohon','no_kk'].forEach(id => applyLimit(id, 16));
    ['rt_asal','rw_asal','rt_tujuan','rw_tujuan'].forEach(id => applyLimit(id, 3));

    // 2. PREVIEW FILE
    function previewFile(input, index) {
        const file = input.files[0];
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

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

    // 3. REMOVE PREVIEW (Reset Input)
    function removePreview(event, inputId, index) {
        event.stopPropagation(); // Mencegah picker file terbuka kembali

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

        input.value = ''; // Kosongkan file di sistem
        preview.src = ''; 
        previewWrap.style.display = 'none';
        placeholder.style.display = 'block';
    }

    // 3. API WILAYAH (REUSABLE)
    function setupWilayah(pId, kId, kecId, kelId) {
        const p = document.getElementById(pId), k = document.getElementById(kId), kec = document.getElementById(kecId), kel = document.getElementById(kelId);
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json`).then(r => r.json()).then(d => d.forEach(x => p.add(new Option(x.name, x.id))));
        
        p.onchange = () => {
            k.disabled = false; k.innerHTML = '<option>Pilih Kota</option>';
            fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${p.value}.json`).then(r => r.json()).then(d => d.forEach(x => k.add(new Option(x.name, x.id))));
        };
        k.onchange = () => {
            kec.disabled = false; kec.innerHTML = '<option>Pilih Kecamatan</option>';
            fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${k.value}.json`).then(r => r.json()).then(d => d.forEach(x => kec.add(new Option(x.name, x.id))));
        };
        kec.onchange = () => {
            kel.disabled = false; kel.innerHTML = '<option>Pilih Kelurahan</option>';
            fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${kec.value}.json`).then(r => r.json()).then(d => d.forEach(x => kel.add(new Option(x.name, x.id))));
        };
    }
    setupWilayah('prov_asal', 'kota_asal', 'kec_asal', 'kel_asal');
    setupWilayah('prov_tujuan', 'kota_tujuan', 'kec_tujuan', 'kel_tujuan');
</script>
@endpush