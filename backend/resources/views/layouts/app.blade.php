<!DOCTYPE html>
<html lang="id" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title') - Sukabumi One Access</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: { DEFAULT: '#123457', dark: '#0A1E33' },
                        accent: { DEFAULT: '#E8A33D', dark: '#3A2205' },
                    },
                }
            }
        }
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .bg-hero-gradient { background: linear-gradient(135deg, #123457 0%, #0A1E33 100%); }
        .category-chip { transition: all 0.2s ease; }
        .service-card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .service-card:hover { transform: translateY(-3px); box-shadow: 0 10px 24px rgba(14, 42, 71, 0.1); }

    </style>
    @stack('styles')
</head>
<body class="bg-white min-h-screen text-slate-600 antialiased">

    @include('partials.navbar')

    <main>
        @yield('content')
    </main>

    @include('components.modal-logout-confirm')
    @include('partials.footer')

    {{-- Load Modals as Components --}}
    @include('components.modal-edit-profile')
    @include('components.modal-status')
    @include('components.modal-auth-alert')

    {{-- Global Scripts (Modal Logic) --}}
    <script>
        function openAuthAlertModal() {
            const modal = document.getElementById('modalAuthAlert');

            modal.classList.remove('hidden');
            modal.classList.add('flex');

            requestAnimationFrame(() => {
                modal.classList.add('show');
            });

        }

        function closeAuthAlertModal() {
            const modal = document.getElementById('modalAuthAlert');

            modal.classList.remove('show');

            setTimeout(() => {
                modal.classList.remove('flex');
                modal.classList.add('hidden');
                document.body.style.overflow = 'auto';
            }, 350);
        }

        // Tutup modal ketika klik area luar (overlay)
        document.addEventListener('DOMContentLoaded', () => {
            const modal = document.getElementById('modalAuthAlert');

            modal.addEventListener('click', function (e) {
                if (e.target === modal || e.target.id === 'modalAuthOverlay') {
                    closeAuthAlertModal();
                }
            });
        });
    </script>
    @stack('scripts')
</body>
</html>