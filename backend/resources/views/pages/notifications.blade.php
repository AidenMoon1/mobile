@extends('layouts.app')

@section('title', 'Notifikasi')

@section('content')

<style>
    .notif-header {
        background-color: #C5D9ED;
        padding: 40px 24px;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 12px;
    }
    .notif-body {
        background-color: #123457;
        border-radius: 0 0 30px 30px;
        padding: 40px 24px 20px 24px;
    }
    .yellow-divider {
        height: 4px;
        background-color: #E8A33D;
        width: 100%;
    }
    .floating-search {
        background: white;
        height: 44px;
        border-radius: 22px;
        display: flex;
        align-items: center;
        padding: 0 20px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        margin-top: -22px;
        width: 90%;
        max-width: 500px;
        margin-left: auto;
        margin-right: auto;
        z-index: 10;
        position: relative;
    }
    .filter-pill {
        background: white;
        padding: 6px 12px;
        border-radius: 8px;
        color: #123457;
        font-weight: bold;
        font-size: 11px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
</style>

<div class="max-w-3xl mx-auto min-h-screen bg-[#F5F8FB]">

    {{-- 1. LAYERED HEADER --}}
    <div class="relative">
        <div class="notif-header">
            <div class="flex items-center gap-3">
                <i class="bi bi-bell text-primary text-3xl"></i>
                <h1 class="text-primary text-2xl font-black">Notifikasi</h1>
            </div>
        </div>

        <div class="yellow-divider"></div>

        <div class="floating-search">
            <input type="text" placeholder="Cari Notifikasi..." class="flex-1 bg-transparent border-none outline-none text-sm font-medium">
        </div>

        <div class="notif-body">
            <div class="flex justify-between items-center">
                <div class="filter-pill">
                    <span>Semua Notifikasi</span>
                    <i class="bi bi-chevron-right text-accent"></i>
                </div>
                <div class="flex gap-4">
                    <i class="bi bi-sliders text-white/70 text-xl"></i>
                    <i class="bi bi-three-dots-vertical text-accent text-xl"></i>
                </div>
            </div>
        </div>
    </div>

    {{-- 2. NOTIFICATION LIST (EMPTY STATE) --}}
    <div class="py-20 flex flex-col items-center justify-center text-center opacity-40">
        <i class="bi bi-bell-slash text-7xl mb-4"></i>
        <p class="font-bold text-slate-500">Belum ada notifikasi baru</p>
    </div>

</div>

@endsection
