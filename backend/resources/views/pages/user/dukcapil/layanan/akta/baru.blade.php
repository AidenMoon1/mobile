@extends('layouts.app')

@section('title', 'Penerbitan Akta Kelahiran Baru - Sukabumi One Access')

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
                <span>Baru</span>
            </nav>
            <h1 class="text-3xl md:text-4xl font-extrabold tracking-tighter">Formulir Pengajuan</h1>
            <p class="text-slate-400 mt-2 text-sm">Penerbitan Akta Kelahiran Baru</p>
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
                    <h3 class="text-lg font-bold text-primary">Data Pemohon (Orang Tua/Wali)</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom md:col-span-2">
                        <label>Nama Lengkap Pemohon</label>
                        <input type="text" name="nama_pemohon" placeholder="Masukkan nama sesuai KTP" required>
                    </div>
                    <div class="input-group-custom">
                        <label>NIK Pemohon (16 Digit)</label>
                        <input type="text" name="nik_pemohon" id="nik_pemohon" maxlength="16" placeholder="3277..." required>
                    </div>
                    <div class="input-group-custom">
                        <label>Nomor Kartu Keluarga (16 Digit)</label>
                        <input type="text" name="no_kk_pemohon" id="no_kk_pemohon" maxlength="16" placeholder="3277..." required>
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
                        <label>No. Handphone (WhatsApp)</label>
                        <input type="text" name="phone_pemohon" placeholder="08xxxx" required>
                    </div>
                    <div class="input-group-custom md:col-span-2">
                        <label>Penjelasan Permohonan Jika Diperlukan</label>
                        <textarea name="keterangan" rows="2" placeholder="Tambahkan informasi jika ada"></textarea>
                    </div>
                </div>
            </div>

            {{-- CARD 2: DATA BAYI --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-accent text-primary flex items-center justify-center shadow-lg">
                        <i class="bi bi-balloon-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Bayi</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="input-group-custom md:col-span-2">
                        <label>Nama Bayi</label>
                        <input type="text" name="nama_bayi" placeholder="Nama lengkap bayi" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Jenis Kelamin</label>
                        <select name="jk_bayi" required>
                            <option value="Laki-Laki">Laki-Laki</option>
                            <option value="Perempuan">Perempuan</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Tempat Dilahirkan</label>
                        <select name="tempat_dilahirkan" required>
                            <option value="Rumah Sakit / Rumah Bersalin">Rumah Sakit / Rumah Bersalin</option>
                            <option value="Puskesmas">Puskesmas</option>
                            <option value="Polindes">Polindes</option>
                            <option value="Rumah">Rumah</option>
                            <option value="Lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Tempat Kelahiran (Kota/Kabupaten)</label>
                        <input type="text" name="kota_lahir_bayi" placeholder="Contoh: Kota Sukabumi" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Tanggal Kelahiran</label>
                        <input type="date" name="tgl_lahir_bayi" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Pukul</label>
                        <input type="time" name="jam_lahir_bayi" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Jenis Kelahiran</label>
                        <select name="jenis_kelahiran" required>
                            <option value="Tunggal">Tunggal</option>
                            <option value="Kembar 2">Kembar 2</option>
                            <option value="Kembar 3">Kembar 3</option>
                            <option value="Lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Kelahiran Ke (Angka)</label>
                        <input type="number" name="kelahiran_ke" placeholder="1" min="1" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Penolong Kelahiran</label>
                        <select name="penolong_kelahiran" required>
                            <option value="Dokter">Dokter</option>
                            <option value="Bidan">Bidan</option>
                            <option value="Perawat">Perawat</option>
                            <option value="Dukun">Dukun</option>
                            <option value="Lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div class="input-group-custom">
                        <label>Berat Bayi (Kg)</label>
                        <input type="number" step="0.01" name="berat_bayi" placeholder="3.5" required>
                    </div>
                    <div class="input-group-custom">
                        <label>Panjang Bayi (Cm)</label>
                        <input type="number" step="0.1" name="panjang_bayi" placeholder="50" required>
                    </div>
                </div>
            </div>

            {{-- CARD 3: DATA ORANG TUA --}}
            <div class="bg-white rounded-[2.5rem] p-6 sm:p-10 shadow-xl shadow-slate-200/50 reveal">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-10 h-10 rounded-xl bg-primary text-accent flex items-center justify-center shadow-lg">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <h3 class="text-lg font-bold text-primary">Data Orang Tua</h3>
                </div>

                <div class="space-y-8">
                    {{-- AYAH --}}
                    <div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4">Informasi Ayah</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom md:col-span-2"><label>Nama Ayah</label><input type="text" name="nama_ayah" required></div>
                            <div class="input-group-custom"><label>NIK Ayah</label><input type="text" name="nik_ayah" id="nik_ayah" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Tempat Lahir Ayah</label><input type="text" name="tempat_lahir_ayah" required></div>
                            <div class="input-group-custom"><label>Tanggal Lahir Ayah</label><input type="date" name="tgl_lahir_ayah" required></div>
                            <div class="input-group-custom">
                                <label>Kewarganegaraan</label>
                                <select name="wn_ayah">
                                    <option value="WNI">WNI</option>
                                    <option value="WNA">WNA</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="section-divider"></div>

                    {{-- IBU --}}
                    <div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4">Informasi Ibu</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom md:col-span-2"><label>Nama Ibu</label><input type="text" name="nama_ibu" required></div>
                            <div class="input-group-custom"><label>NIK Ibu</label><input type="text" name="nik_ibu" id="nik_ibu" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Tempat Lahir Ibu</label><input type="text" name="tempat_lahir_ibu" required></div>
                            <div class="input-group-custom"><label>Tanggal Lahir Ibu</label><input type="date" name="tgl_lahir_ibu" required></div>
                            <div class="input-group-custom">
                                <label>Kewarganegaraan</label>
                                <select name="wn_ibu">
                                    <option value="WNI">WNI</option>
                                    <option value="WNA">WNA</option>
                                </select>
                            </div>
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
                    <h3 class="text-lg font-bold text-primary">Data Saksi</h3>
                </div>

                <div class="space-y-8">
                    {{-- Saksi I --}}
                    <div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4">Saksi I</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom"><label>Nama Saksi I</label><input type="text" name="nama_saksi1" required></div>
                            <div class="input-group-custom"><label>NIK Saksi I</label><input type="text" name="nik_saksi1" id="nik_saksi1" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Nomor KK Saksi I</label><input type="text" name="no_kk_saksi1" id="kk_saksi1" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Kewarganegaraan</label><select name="wn_saksi1"><option value="WNI">WNI</option><option value="WNA">WNA</option></select></div>
                        </div>
                    </div>
                    
                    <div class="section-divider"></div>

                    {{-- Saksi II --}}
                    <div>
                        <p class="text-xs font-black text-slate-400 uppercase tracking-widest mb-4">Saksi II</p>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="input-group-custom"><label>Nama Saksi II</label><input type="text" name="nama_saksi2" required></div>
                            <div class="input-group-custom"><label>NIK Saksi II</label><input type="text" name="nik_saksi2" id="nik_saksi2" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Nomor KK Saksi II</label><input type="text" name="no_kk_saksi2" id="kk_saksi2" maxlength="16" required></div>
                            <div class="input-group-custom"><label>Kewarganegaraan</label><select name="wn_saksi2"><option value="WNI">WNI</option><option value="WNA">WNA</option></select></div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- CARD 5: UPLOAD PERSYARATAN --}}
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
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Surat Keterangan Lahir (Faskes) / SPTJM</p>
                        <div class="upload-box" onclick="document.getElementById('f1').click()">
                            <input type="file" id="f1" name="file_lahir" accept="image/*" class="hidden" onchange="previewFile(this, 1)">
                            <div id="ph1"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
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
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Kartu Keluarga</p>
                        <div class="upload-box" onclick="document.getElementById('f2').click()">
                            <input type="file" id="f2" name="file_kk" accept="image/*" class="hidden" onchange="previewFile(this, 2)">
                            <div id="ph2"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
                            <div id="previewWrap2" class="preview-wrap mx-auto">
                                <img id="preview2" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f2', 2)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 3 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Buku Nikah / SPTJM Kebenaran Pasutri</p>
                        <div class="upload-box" onclick="document.getElementById('f3').click()">
                            <input type="file" id="f3" name="file_nikah" accept="image/*" class="hidden" onchange="previewFile(this, 3)">
                            <div id="ph3"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
                            <div id="previewWrap3" class="preview-wrap mx-auto">
                                <img id="preview3" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f3', 3)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 4 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto Formulir F-2.01 Kelahiran</p>
                        <div class="upload-box" onclick="document.getElementById('f4').click()">
                            <input type="file" id="f4" name="file_f201" accept="image/*" class="hidden" onchange="previewFile(this, 4)">
                            <div id="ph4"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
                            <div id="previewWrap4" class="preview-wrap mx-auto">
                                <img id="preview4" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f4', 4)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 5 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Foto KTP Orang Tua</p>
                        <div class="upload-box" onclick="document.getElementById('f5').click()">
                            <input type="file" id="f5" name="file_ktp_ortu" accept="image/*" class="hidden" onchange="previewFile(this, 5)">
                            <div id="ph5"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
                            <div id="previewWrap5" class="preview-wrap mx-auto">
                                <img id="preview5" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f5', 5)">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    {{-- File 6 --}}
                    <div class="space-y-3">
                        <p class="text-[10px] font-bold text-slate-500 uppercase tracking-widest ml-1">Dokumen Pendukung Lainnya</p>
                        <div class="upload-box" onclick="document.getElementById('f6').click()">
                            <input type="file" id="f6" name="file_pendukung" accept="image/*" class="hidden" onchange="previewFile(this, 6)">
                            <div id="ph6"><i class="bi bi-image text-3xl text-slate-300 block mb-2"></i><span class="text-[10px] font-bold text-slate-400">Pilih Foto</span></div>
                            <div id="previewWrap6" class="preview-wrap mx-auto">
                                <img id="preview6" class="preview-img">
                                <button type="button" class="remove-preview-btn" onclick="removePreview(event, 'f6', 6)">
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
    const ids = ['nik_pemohon','no_kk_pemohon','nik_ayah','nik_ibu','nik_saksi1','kk_saksi1','nik_saksi2','kk_saksi2'];
    ids.forEach(id => {
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
        event.stopPropagation(); // Biar picker file gak kebuka lagi

        const input = document.getElementById(inputId);
        const preview = document.getElementById('preview' + index);
        const previewWrap = document.getElementById('previewWrap' + index);
        const placeholder = document.getElementById('ph' + index);

        input.value = ''; // Reset input file
        preview.src = ''; // Hapus tampilan gambar
        previewWrap.style.display = 'none'; // Sembunyikan wrapper preview
        placeholder.style.display = 'block'; // Munculkan kembali icon placeholder
    }

    // 3. API WILAYAH (Sukabumi City Only context for better performance, but using general API)
    const kecSel = document.getElementById('kecamatan_pemohon'), 
          kelSel = document.getElementById('kelurahan_pemohon');

    // Fetching Sukabumi Kota Districts (ID: 32.72)
    fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/districts/3272.json`)
        .then(r => r.json()).then(data => data.forEach(k => kecSel.add(new Option(k.name, k.id))));

    kecSel.addEventListener('change', function() {
        kelSel.disabled = false; kelSel.innerHTML = '<option value="">Pilih Kelurahan</option>';
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/villages/${this.value}.json`)
            .then(r => r.json()).then(data => data.forEach(k => kelSel.add(new Option(k.name, k.id))));
    });
</script>
@endpush