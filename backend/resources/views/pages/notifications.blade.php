@extends('layouts.app')

@section('title', 'Notifikasi')

@section('content')

@php
    use App\Models\Notification;
    $notifications = Notification::latest()->get();

    $today = now()->startOfDay();
    $yesterday = now()->subDay()->startOfDay();

    $grouped = $notifications->groupBy(function($item) use ($today, $yesterday) {
        $date = $item->created_at->startOfDay();
        if ($date->equalTo($today)) return 'Hari Ini';
        if ($date->equalTo($yesterday)) return 'Kemarin';
        return $date->translatedFormat('F Y');
    });
@endphp

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
    .notif-card {
        background: white;
        border-radius: 16px;
        padding: 16px;
        margin-bottom: 12px;
        border: 1px solid rgba(0,0,0,0.05);
        display: flex;
        gap: 12px;
    }
</style>

<div class="max-w-3xl mx-auto min-h-screen bg-[#F5F8FB] pb-20">

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
            <i class="bi bi-search text-slate-400 mr-3"></i>
            <input type="text" placeholder="Cari Notifikasi..." class="flex-1 bg-transparent border-none outline-none text-sm font-medium">
        </div>

        <div class="notif-body">
            <div class="flex justify-between items-center">
                <div class="filter-pill cursor-pointer">
                    <span>Semua Notifikasi</span>
                    <i class="bi bi-chevron-right text-accent"></i>
                </div>
                <div class="flex gap-4">
                    <i class="bi bi-sliders text-white/70 text-xl cursor-pointer"></i>
                    <i class="bi bi-three-dots-vertical text-accent text-xl cursor-pointer"></i>
                </div>
            </div>
        </div>
    </div>

    {{-- 2. NOTIFICATION LIST --}}
    <div class="px-6 py-8">
        @if($notifications->isEmpty())
            <div class="py-20 flex flex-col items-center justify-center text-center opacity-40">
                <i class="bi bi-bell-slash text-7xl mb-4"></i>
                <p class="font-bold text-slate-500">Belum ada notifikasi baru</p>
            </div>
        @else
            @foreach($grouped as $group => $items)
                <div class="mb-6">
                    <h5 class="text-primary font-bold text-sm mb-4">{{ $group }}</h5>
                    @foreach($items as $notif)
                        <div class="notif-card">
                            <div class="w-10 h-10 rounded-xl bg-primary/5 flex items-center justify-center shrink-0">
                                @if($notif->category == 'feedback')
                                    <i class="bi bi-chat-left-text text-primary"></i>
                                @elseif($notif->category == 'disaster')
                                    <i class="bi bi-exclamation-triangle text-primary"></i>
                                @else
                                    <i class="bi bi-bell text-primary"></i>
                                @endif
                            </div>
                            <div class="flex-1">
                                <div class="flex justify-between items-start gap-4">
                                    <h6 class="text-slate-800 font-bold text-sm leading-tight">{{ $notif->title }}</h6>
                                    <span class="text-[10px] text-slate-400 font-bold">{{ $notif->created_at->format('H.i') }}</span>
                                </div>
                                <p class="text-slate-500 text-xs mt-1 leading-relaxed">{{ $notif->description }}</p>
                            </div>
                        </div>
                    @endforeach
                </div>
            @endforeach
        @endif
    </div>

</div>

@endsection
