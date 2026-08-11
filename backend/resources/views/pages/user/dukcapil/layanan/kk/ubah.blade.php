@extends('layouts.app')

@section('title', 'Perubahan Data KK - Sukabumi One Access')

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
                <a href="{{ route('layanan.kk') }}" class="hover:text-white transition">Kartu Keluarga</a>
                <i class="bi bi-chevron-right text-[8px]"></i>
                <span>Ubah Data KK</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Penerbitan KK Baru Karena Perubahan Elemen Data</p>
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
                        <input type="text" name="nama" placeholder="Sesuai KTP" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Pemohon</label>
                        <input type="text" name="nik" id="nik" maxlength="16" inputmode="numeric" placeholder="3277..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga</label>
                        <input type="text" name="no_kk" id="no_kk" maxlength="16" inputmode="numeric" placeholder="3277..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Email Pemohon</label>
                        <input type="email" name="email" placeholder="contoh@mail.com" required>
                    </div>
                    <div class="input-group-custom">
                        <label>No. Handphone (WhatsApp)</label>
                        <input type="text" name="phone" placeholder="08xxxx" required>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Penjelasan Permohonan</label>
                        <textarea name="keterangan" rows="2" placeholder="Contoh: Perubahan gelar pendidikan dan status pekerjaan"></textarea>
                    </div>
                </div>
            </div>

            {{-- CARD 2: DATA ALAMAT --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-geo-alt-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Alamat</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom">
                        <label>Provinsi</label>
                        <select name="provinsi" id="provinsi" required><option value="">Pilih</option></select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kabupaten / Kota</label>
                        <select name="kota" id="kota" required disabled><option value="">Pilih</option></select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kecamatan</label>
                        <select name="kecamatan" id="kecamatan" required disabled><option value="">Pilih</option></select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kelurahan / Desa</label>
                        <select name="kelurahan" id="kelurahan" required disabled><option value="">Pilih</option></select>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Alamat Lengkap</label>
                        <input type="text" name="alamat_lengkap" placeholder="Jalan, No Rumah" required>
                    </div>
                    <div class="input-group-custom">
                        <label>RT</label>
                        <input type="text" name="rt" id="rt" maxlength="3" placeholder="000" required>
                    </div>
                    <div class="input-group-custom">
                        <label>RW</label>
                        <input type="text" name="rw" id="rw" maxlength="3" placeholder="000" required>
                    </div>
                </div>
            </div>

            {{-- CARD 3: FORM 106 --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
                    <div class="flex items-center gap-4">
                        <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-bold text-primary">Formulir F-1.06</h3>
                            <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Rincian Perubahan Data</p>
                        </div>
                    </div>
                    <button type="button" onclick="addRow()" class="btn-add-row">
                        <i class="bi bi-plus-lg mr-1"></i> Tambah Data
                    </button>
                </div>

                <div class="overflow-x-auto">
                    <table class="table-custom" id="table106">
                        <thead>
                            <tr>
                                <th>Rincian (Nama/Elemen)</th>
                                <th>Pendidikan / Pekerjaan</th>
                                <th>Agama / Lainnya</th>
                                <th width="50"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="text" name="rincian[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Masukkan rincian" required></td>
                                <td><input type="text" name="pendidikan_pekerjaan[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Data baru"></td>
                                <td><input type="text" name="agama_lainnya[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Data baru"></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <p class="mt-4 text-[11px] text-slate-400 italic">* Klik tombol "Tambah Data" jika terdapat lebih dari satu perubahan elemen data.</p>
            </div>

            {{-- CARD 4: UPLOAD --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-cloud-arrow-up-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Upload Dokumen Persyaratan</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {{-- File 1: KK Lama --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Kartu Keluarga Lama</p>
                        <div class="upload-box" onclick="document.getElementById('file_kk_lama').click()">
                            <input type="file" id="file_kk_lama" name="file_kk_lama" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="placeholder1"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto KK Lama</span></div>
                            <div id="previewWrap1" class="preview-wrap mx-auto">
                                <img id="preview1" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'file_kk_lama', 1)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 2: Pendukung --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Dokumen Pendukung (Ijazah/SK/dll)</p>
                        <div class="upload-box" onclick="document.getElementById('file_pendukung_data').click()">
                            <input type="file" id="file_pendukung_data" name="file_pendukung_data" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="placeholder2"><i class="bi bi-file-earmark-medical text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Dokumen Pendukung</span></div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'file_pendukung_data', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 3: F-1.06 --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Formulir F-1.06</p>
                        <div class="upload-box" onclick="document.getElementById('file_f106').click()">
                            <input type="file" id="file_f106" name="file_f106" accept="image/*" class="hidden" onchange="previewFile(this, 3)">
                            <div id="placeholder3"><i class="bi bi-file-earmark-text text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto F-1.06</span></div>
                            <div id="previewWrap3" class="preview-wrap mx-auto">
                                <img id="preview3" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'file_f106', 3)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 4: Lainnya 1 --}}
                    <div class="space-y-3">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Dokumen Lainnya 1 (Opsional)</p>
                        <div class="upload-box" onclick="document.getElementById('file_other1').click()">
                            <input type="file" id="file_other1" name="file_other1" accept="image/*" class="hidden" onchange="previewFile(this, 4)">
                            <div id="placeholder4"><i class="bi bi-plus-circle text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Tambah File</span></div>
                            <div id="previewWrap4" class="preview-wrap mx-auto">
                                <img id="preview4" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'file_other1', 4)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    {{-- File 5: Lainnya 2 --}}
                    <div class="space-y-3 md:col-span-2">
                        <p class="text-xs font-bold text-slate-500 uppercase tracking-widest ml-1">Dokumen Lainnya 2 (Opsional)</p>
                        <div class="upload-box" onclick="document.getElementById('file_other2').click()">
                            <input type="file" id="file_other2" name="file_other2" accept="image/*" class="hidden" onchange="previewFile(this, 5)">
                            <div id="placeholder5"><i class="bi bi-plus-circle text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Tambah File</span></div>
                            <div id="previewWrap5" class="preview-wrap mx-auto">
                                <img id="preview5" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'file_other2', 5)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SUBMIT --}}
            <div class="flex flex-col gap-4 reveal">
                <button type="submit" class="w-full py-5 bg-primary text-white rounded-2xl font-black text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all uppercase tracking-[0.2em]">
                    Kirim Permohonan <i class="bi bi-send-fill ml-2"></i>
                </button>
                <a href="{{ route('layanan.kk') }}" class="text-center py-4 font-bold text-xs text-slate-400 hover:text-primary transition-all">Batalkan</a>
            </div>
        </form>
    </div>
</section>

@endsection

@push('scripts')
<script>
    // 1. DYNAMIC TABLE FORM 1.06
    function addRow() {
        const table = document.getElementById('table106').getElementsByTagName('tbody')[0];
        const newRow = table.insertRow();
        newRow.innerHTML = `
            <td><input type="text" name="rincian[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Masukkan rincian" required></td>
            <td><input type="text" name="pendidikan_pekerjaan[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Data baru"></td>
            <td><input type="text" name="agama_lainnya[]" class="w-full bg-transparent border-none outline-none text-sm font-bold text-primary" placeholder="Data baru"></td>
            <td class="text-center"><button type="button" onclick="removeRow(this)" class="text-red-400 hover:text-red-600"><i class="bi bi-trash3-fill"></i></button></td>
        `;
    }
    function removeRow(btn) {
        btn.closest('tr').remove();
    }

    // 2. LIMIT DIGITS
    const limitDigit = (id, length) => {
        const el = document.getElementById(id);
        if(el) el.addEventListener('input', function() { this.value = this.value.replace(/[^0-9]/g, '').slice(0, length); });
    };
    limitDigit('nik', 16); limitDigit('no_kk', 16); limitDigit('rt', 3); limitDigit('rw', 3);

    // 2. PREVIEW FILE (Updated)
    function previewFile(input, index) {
        const file = input.files[0];
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

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
        event.stopPropagation(); // Mencegah picker file terbuka kembali

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('placeholder' + index);

        input.value = ''; // Reset input file
        preview.src = ''; // Hapus gambar
        previewWrap.style.display = 'none'; // Sembunyikan wrapper preview
        placeholder.style.display = 'block'; // Munculkan kembali icon placeholder
    }

    // 4. API WILAYAH
    const provSel = document.getElementById('provinsi'), kotaSel = document.getElementById('kota'), kecSel = document.getElementById('kecamatan'), kelSel = document.getElementById('kelurahan');
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json`).then(r => r.json()).then(data => data.forEach(p => provSel.add(new Option(p.name, p.id))));
    provSel.addEventListener('change', function() {
        kotaSel.disabled = false; kotaSel.innerHTML = '<option value="">Pilih</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${this.value}.json`).then(r => r.json()).then(data => data.forEach(k => kotaSel.add(new Option(k.name, k.id))));
    });
    kotaSel.addEventListener('change', function() {
        kecSel.disabled = false; kecSel.innerHTML = '<option value="">Pilih</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/${this.value}.json`).then(r => r.json()).then(data => data.forEach(k => kecSel.add(new Option(k.name, k.id))));
    });
    kecSel.addEventListener('change', function() {
        kelSel.disabled = false; kelSel.innerHTML = '<option value="">Pilih</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${this.value}.json`).then(r => r.json()).then(data => data.forEach(k => kelSel.add(new Option(k.name, k.id))));
    });
</script>
@endpush