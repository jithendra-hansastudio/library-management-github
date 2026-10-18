@php
    use Illuminate\Support\Facades\Auth;

    $userSetting = Auth::user()->setting ?? null;
    $isDark = $userSetting->is_dark_mode ?? false;
    $presetKey = $userSetting->theme_preset ?? 'ocean';
    $cornerKey = $userSetting->corner_style ?? 'smooth';
    $fontScale = $userSetting->font_scale ?? 1.0;
    $shadowLevel = $userSetting->shadow_level ?? 1;

    // Server-side Palettes
    $palettes = [
        'ocean'  => ['light' => ['primary' => '#0d6efd', 'bg' => '#f4f6f9', 'card' => '#ffffff', 'text' => '#212529', 'border' => '#dee2e6', 'muted' => '#6c757d'], 'dark' => ['primary' => '#3b82f6', 'bg' => '#141218', 'card' => '#1d1b20', 'text' => '#e6e1e5', 'border' => '#49454f', 'muted' => '#cac4d0']],
        'emerald'=> ['light' => ['primary' => '#059669', 'bg' => '#f0fdf4', 'card' => '#ffffff', 'text' => '#064e3b', 'border' => '#bbf7d0', 'muted' => '#4b5563'], 'dark' => ['primary' => '#10b981', 'bg' => '#061a14', 'card' => '#0f2922', 'text' => '#ecfdf5', 'border' => '#134e4a', 'muted' => '#94a3b8']],
        'sunset' => ['light' => ['primary' => '#7c3aed', 'bg' => '#faf5ff', 'card' => '#ffffff', 'text' => '#4c1d95', 'border' => '#e9d5ff', 'muted' => '#6b7280'], 'dark' => ['primary' => '#8b5cf6', 'bg' => '#120f18', 'card' => '#1c1724', 'text' => '#f3e8ff', 'border' => '#4c3f61', 'muted' => '#a78bfa']],
        'slate'  => ['light' => ['primary' => '#334155', 'bg' => '#f8fafc', 'card' => '#ffffff', 'text' => '#0f172a', 'border' => '#e2e8f0', 'muted' => '#64748b'], 'dark' => ['primary' => '#94a3b8', 'bg' => '#0b0f19', 'card' => '#111827', 'text' => '#f8fafc', 'border' => '#334155', 'muted' => '#94a3b8']],
        'amber'  => ['light' => ['primary' => '#d97706', 'bg' => '#fffbeb', 'card' => '#ffffff', 'text' => '#451a03', 'border' => '#fde68a', 'muted' => '#78350f'], 'dark' => ['primary' => '#f59e0b', 'bg' => '#18140c', 'card' => '#252014', 'text' => '#fef3c7', 'border' => '#57451c', 'muted' => '#d97706']],
        'cyber'  => ['light' => ['primary' => '#06b6d4', 'bg' => '#ecfeff', 'card' => '#ffffff', 'text' => '#0e7490', 'border' => '#a5f3fc', 'muted' => '#475569'], 'dark' => ['primary' => '#22d3ee', 'bg' => '#081014', 'card' => '#101c24', 'text' => '#cffafe', 'border' => '#164e63', 'muted' => '#67e8f9']],
    ];

    $corners = ['sharp' => '0px', 'smooth' => '10px', 'pill' => '30px'];
    $shadows = [
        0 => 'none',
        1 => '0 1px 3px 1px rgba(0, 0, 0, 0.15), 0 1px 2px 0 rgba(0, 0, 0, 0.3)',
        2 => '0 4px 8px 3px rgba(0, 0, 0, 0.15), 0 1px 3px 0 rgba(0, 0, 0, 0.3)',
        3 => '0 8px 16px 4px rgba(0, 0, 0, 0.15), 0 3px 6px 0 rgba(0, 0, 0, 0.3)'
    ];

    $mode = $isDark ? 'dark' : 'light';
    $activePalette = $palettes[$presetKey][$mode] ?? $palettes['ocean'][$mode];

    $hex = $activePalette['primary'];
    $hexClean = ltrim($hex, '#');
    $r = hexdec(substr($hexClean, 0, 2));
    $g = hexdec(substr($hexClean, 2, 2));
    $b = hexdec(substr($hexClean, 4, 2));
    $rgb = "$r, $g, $b";
@endphp

@charset "UTF-8";

<!-- 1. FIRST: Load the raw Bootstrap 5.3 CSS -->
<style>
/*!
 * Bootstrap  v5.3.3 (https://getbootstrap.com/)
 * Copyright 2011-2024 The Bootstrap Authors
 * Licensed under MIT (https://github.com/twbs/bootstrap/blob/main/LICENSE)
 */
:root,
[data-bs-theme=light] {
    --bs-blue: #0d6efd;
    --bs-indigo: #6610f2;
    --bs-purple: #6f42c1;
    --bs-pink: #d63384;
    --bs-red: #dc3545;
    --bs-orange: #fd7e14;
    --bs-yellow: #ffc107;
    --bs-green: #198754;
    --bs-teal: #20c997;
    --bs-cyan: #0dcaf0;
    --bs-black: #000;
    --bs-white: #fff;
    --bs-gray: #6c757d;
    --bs-gray-dark: #343a40;
    --bs-gray-100: #f8f9fa;
    --bs-gray-200: #e9ecef;
    --bs-gray-300: #dee2e6;
    --bs-gray-400: #ced4da;
    --bs-gray-500: #adb5bd;
    --bs-gray-600: #6c757d;
    --bs-gray-700: #495057;
    --bs-gray-800: #343a40;
    --bs-gray-900: #212529;
    --bs-primary: #0d6efd;
    --bs-secondary: #6c757d;
    --bs-success: #198754;
    --bs-info: #0dcaf0;
    --bs-warning: #ffc107;
    --bs-danger: #dc3545;
    --bs-light: #f8f9fa;
    --bs-dark: #212529;
    --bs-primary-rgb: 13, 110, 253;
    --bs-secondary-rgb: 108, 117, 125;
    --bs-success-rgb: 25, 135, 84;
    --bs-info-rgb: 13, 202, 240;
    --bs-warning-rgb: 255, 193, 7;
    --bs-danger-rgb: 220, 53, 69;
    --bs-light-rgb: 248, 249, 250;
    --bs-dark-rgb: 33, 37, 41;
    --bs-body-font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", "Liberation Sans", Arial, sans-serif;
    --bs-body-font-size: 1rem;
    --bs-body-font-weight: 400;
    --bs-body-line-height: 1.5;
    --bs-body-color: #212529;
    --bs-body-color-rgb: 33, 37, 41;
    --bs-body-bg: #fff;
    --bs-body-bg-rgb: 255, 255, 255;
    --bs-link-color: #0d6efd;
    --bs-link-color-rgb: 13, 110, 253;
    --bs-link-decoration: underline;
    --bs-link-hover-color: #0a58ca;
    --bs-border-width: 1px;
    --bs-border-style: solid;
    --bs-border-color: #dee2e6;
    --bs-border-radius: 0.375rem;
}

[data-bs-theme=dark] {
    color-scheme: dark;
    --bs-body-color: #dee2e6;
    --bs-body-color-rgb: 222, 226, 230;
    --bs-body-bg: #212529;
    --bs-body-bg-rgb: 33, 37, 41;
    --bs-link-color: #6ea8fe;
    --bs-border-color: #495057;
}

/* 2. SECOND: Override Bootstrap and apply your Database dynamic properties with high specificity */
:root,
[data-bs-theme="{{ $mode }}"] {
    --app-primary: {{ $hex }};
    --app-bg: {{ $activePalette['bg'] }};
    --app-card-bg: {{ $activePalette['card'] }};
    --app-text: {{ $activePalette['text'] }};
    --app-border: {{ $activePalette['border'] }};
    --app-muted: {{ $activePalette['muted'] }};
    --app-radius: {{ $corners[$cornerKey] ?? '10px' }};
    --app-font-scale: {{ $fontScale }};
    --app-shadow: {{ $shadows[$shadowLevel] ?? $shadows[1] }};

    /* Bootstrap Variable Bridge overrides */
    --bs-primary: {{ $hex }};
    --bs-primary-rgb: {{ $rgb }};
    --bs-btn-bg: {{ $hex }};
    --bs-btn-border-color: {{ $hex }};
    --bs-btn-hover-bg: rgba({{ $rgb }}, 0.85);
    --bs-btn-hover-border-color: rgba({{ $rgb }}, 0.8);
    --bs-link-color: {{ $hex }};
    
    --bs-body-bg: {{ $activePalette['bg'] }};
    --bs-body-color: {{ $activePalette['text'] }};
    --bs-border-color: {{ $activePalette['border'] }};
}

body {
    background-color: var(--app-bg) !important;
    color: var(--app-text) !important;
    font-size: calc(1rem * var(--app-font-scale));
}

.card {
    background-color: var(--app-card-bg) !important;
    color: var(--app-text) !important;
    border-color: var(--app-border) !important;
    border-radius: var(--app-radius) !important;
    box-shadow: var(--app-shadow) !important;
}

.text-muted, .form-text {
    color: var(--app-muted) !important;
}

.btn-check:checked + .btn-outline-secondary {
    background-color: var(--app-primary) !important;
    border-color: var(--app-primary) !important;
    color: #ffffff !important;
}

.btn-check:checked + .btn-outline-secondary * {
    color: #ffffff !important;
}

.btn, .form-control, .form-select {
    border-radius: var(--app-radius) !important;
}
/* 1. Solid Primary Buttons */
.btn-primary {
    --bs-btn-bg: var(--app-primary) !important;
    --bs-btn-border-color: var(--app-primary) !important;
    --bs-btn-hover-bg: rgba({{ $rgb }}, 0.85) !important;
    --bs-btn-hover-border-color: rgba({{ $rgb }}, 0.8) !important;
    --bs-btn-focus-shadow-rgb: {{ $rgb }} !important;
    --bs-btn-active-bg: rgba({{ $rgb }}, 0.75) !important;
    --bs-btn-active-border-color: rgba({{ $rgb }}, 0.7) !important;
}

/* 2. Outlined Primary Buttons (e.g. "Browse Books") */
.btn-outline-primary {
    --bs-btn-color: var(--app-primary) !important;
    --bs-btn-border-color: var(--app-primary) !important;
    --bs-btn-hover-bg: var(--app-primary) !important;
    --bs-btn-hover-border-color: var(--app-primary) !important;
    --bs-btn-hover-color: #ffffff !important;
    --bs-btn-active-bg: rgba({{ $rgb }}, 0.85) !important;
    --bs-btn-active-border-color: rgba({{ $rgb }}, 0.8) !important;
    --bs-btn-active-color: #ffffff !important;
}

/* 3. Outlined Secondary / Theme State Toggles */
.btn-check:checked + .btn-outline-secondary,
.btn-outline-secondary:hover {
    background-color: var(--app-primary) !important;
    border-color: var(--app-primary) !important;
    color: #ffffff !important;
}

/* 4. Navbar Toggler Border Accent */
.navbar-toggler {
    border-color: rgba({{ $rgb }}, 0.3) !important;
}
/* Cards, Headers & Footers */
    .card, 
    .card-header, 
    .card-footer {
        background-color: var(--app-card-bg) !important;
        color: var(--app-text) !important;
        border-color: var(--app-border) !important;
        border-radius: var(--app-radius) !important;
        box-shadow: var(--app-shadow) !important;
    }

    /* List Groups & Items (Fixes profile details and transaction boxes) */
    .list-group {
        background-color: transparent !important;
    }
    
    .list-group-item {
        background-color: var(--app-card-bg) !important;
        color: var(--app-text) !important;
        border-color: var(--app-border) !important;
    }

    /* Tables & Responsive Containers */
    .table-responsive {
        background-color: var(--app-card-bg) !important;
        border-color: var(--app-border) !important;
    }

    .table {
        color: var(--app-text) !important;
        border-color: var(--app-border) !important;
        background-color: transparent !important;
    }

    .table th, 
    .table td {
        background-color: transparent !important;
        color: var(--app-text) !important;
        border-color: var(--app-border) !important;
    }

    .table thead, 
    .table-light {
        background-color: rgba(0, 0, 0, 0.03) !important;
        color: var(--app-text) !important;
        border-color: var(--app-border) !important;
    }

    /* Buttons & Controls */
    .btn-primary {
        --bs-btn-bg: var(--app-primary) !important;
        --bs-btn-border-color: var(--app-primary) !important;
        --bs-btn-hover-bg: rgba({{ $rgb }}, 0.85) !important;
        --bs-btn-hover-border-color: rgba({{ $rgb }}, 0.8) !important;
    }

    .btn-outline-primary {
        --bs-btn-color: var(--app-primary) !important;
        --bs-btn-border-color: var(--app-primary) !important;
        --bs-btn-hover-bg: var(--app-primary) !important;
        --bs-btn-hover-border-color: var(--app-primary) !important;
        --bs-btn-hover-color: #ffffff !important;
    }

    .text-muted, .form-text {
        color: var(--app-muted) !important;
    }

    .btn, .form-control, .form-select {
        border-radius: var(--app-radius) !important;
    }
</style>