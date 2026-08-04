@extends('layouts.app')

@section('title', 'Kritik dan Saran')

@section('content')

<style>
    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: center;
        gap: 10px;
    }
    .star-rating input { display: none; }
    .star-rating label {
        cursor: pointer;
        width: 50px;
        height: 50px;
        background: #f1f5f9;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        font-weight: bold;
        color: #94a3b8;
        transition: all 0.2s ease;
    }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        background: rgba(232, 163, 61, 0.1);
        border-color: #E8A33D;
        color: #E8A33D;
    }
    .star-rating input:checked ~ label::before {
        content: "\F586";
        font-family: "bootstrap-icons";
    }
    .star-rating label::after {
        content: attr(data-value);
    }
    .star-rating input:checked ~ label::after {
        display: none;
    }
</style>

<div class="max-w-3xl mx-auto min-h-screen bg-[#F5F8FB] pb-20">
    <div class="bg-primary p-8 rounded-b-[40px] text-white text-center">
        <h1 class="text-2xl font-black mb-2">Kritik dan Saran</h1>
        <p class="text-white/70 text-sm">Pendapat Anda sangat berarti untuk meningkatkan layanan kami.</p>
    </div>

    <div class="px-6 -mt-8">
        <form action="{{ route('feedback.store') }}" method="POST" class="bg-white rounded-3xl shadow-xl p-8 border border-slate-100">
            @csrf

            <div class="mb-8">
                <label class="block text-primary font-bold text-sm mb-4 text-center">
                    1. Bagaimana penilaian Anda terhadap aplikasi? *
                </label>

                <div class="star-rating">
                    <input type="radio" id="star5" name="rating" value="5" required />
                    <label for="star5" data-value="5"></label>
                    <input type="radio" id="star4" name="rating" value="4" />
                    <label for="star4" data-value="4"></label>
                    <input type="radio" id="star3" name="rating" value="3" />
                    <label for="star3" data-value="3"></label>
                    <input type="radio" id="star2" name="rating" value="2" />
                    <label for="star2" data-value="2"></label>
                    <input type="radio" id="star1" name="rating" value="1" />
                    <label for="star1" data-value="1"></label>
                </div>
            </div>

            <div class="mb-8">
                <label class="block text-primary font-bold text-sm mb-3">
                    2. Faktor apa saja yang perlu ditingkatkan? *
                </label>
                <select name="factor" required class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:border-accent outline-none transition-all">
                    <option value="" disabled selected>Pilih faktor yang relevan</option>
                    <option value="Kecepatan Layanan">Kecepatan Layanan</option>
                    <option value="Kemudahan Penggunaan">Kemudahan Penggunaan</option>
                    <option value="Kelengkapan Fitur">Kelengkapan Fitur</option>
                    <option value="Desain Antarmuka">Desain Antarmuka</option>
                    <option value="Kestabilan Aplikasi">Kestabilan Aplikasi</option>
                </select>
            </div>

            <div class="mb-10">
                <label class="block text-primary font-bold text-sm mb-3">
                    3. Mengapa hal tersebut perlu ditingkatkan? (Opsional)
                </label>
                <textarea name="reason" rows="4" placeholder="Masukkan alasan Anda di sini..." class="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm focus:border-accent outline-none transition-all resize-none"></textarea>
            </div>

            <button type="submit" class="w-full bg-primary text-white font-bold py-4 rounded-xl shadow-lg shadow-primary/20 hover:bg-primary-dark transition-all active:scale-[0.98]">
                Kirim Masukan
            </button>
        </form>
    </div>
</div>

@if(session('success'))
<script>
    alert('Terima kasih! Kritik dan saran Anda telah kami terima.');
</script>
@endif

@endsection
