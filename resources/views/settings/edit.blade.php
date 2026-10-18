<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UI & Theme Customizer</title>

    <link rel="stylesheet" href="{{ asset('css/bootstrap.min.css') }}">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    <!-- Active User Theme Styles -->
    @include('partials.theme-styles')
</head>
<body>

    @include('partials.navbar')

    <main class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="h3 fw-bold mb-1">UI & Theme Preferences</h1>
                <p class="text-muted small mb-0">Choose your workspace theme preset, corner style, and density in real-time.</p>
            </div>
            <a href="{{ route('homescreen') }}" class="btn btn-outline-secondary btn-sm">&larr; Back to Dashboard</a>
        </div>

        @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                <strong>Success!</strong> {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endif

        <div class="row g-4">
            <!-- Settings Form Column -->
            <div class="col-lg-6">
                <form action="{{ route('settings.update') }}" method="POST">
                    @csrf

                    <!-- Theme Mode & Density -->
                    <!-- <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-transparent fw-bold border-bottom py-3">
                            ⚙️ Interface Toggles
                        </div>
                        <div class="card-body p-4">
                            <div class="form-check form-switch fs-5 mb-3">
                                <input class="form-check-input" type="checkbox" role="switch" id="is_dark_mode" name="is_dark_mode" 
                                    {{ old('is_dark_mode', $setting->is_dark_mode ?? false) ? 'checked' : '' }} onchange="previewTheme()">
                                <label class="form-check-label fs-6 fw-semibold align-middle" for="is_dark_mode">
                                    🌙 Dark Mode
                                </label>
                                <div class="form-text mt-0">Switch to M3 dark tonal surfaces.</div>
                            </div>

                            <hr class="my-3">

                            <div class="form-check form-switch fs-5 mb-2">
                                <input class="form-check-input" type="checkbox" role="switch" id="is_compact_density" name="is_compact_density" 
                                    {{ old('is_compact_density', $setting->is_compact_density ?? false) ? 'checked' : '' }} onchange="previewTheme()">
                                <label class="form-check-label fs-6 fw-semibold align-middle" for="is_compact_density">
                                    📐 Compact UI Density
                                </label>
                                <div class="form-text mt-0">Reduce padding to display more data on screen.</div>
                            </div>
                        </div>
                    </div> -->

                    <!-- Curated Theme Presets (6 Options) -->
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-transparent fw-bold border-bottom py-3">
                            🎨 Color Theme Presets
                        </div>
                        <div class="card-body p-4">
                            <div class="row g-3">
                                @php
                                    $presets = [
                                        'ocean' => ['label' => 'Ocean Breeze', 'color' => '#0d6efd'],
                                        'emerald' => ['label' => 'Emerald Forest', 'color' => '#059669'],
                                        'sunset' => ['label' => 'Sunset Violet', 'color' => '#7c3aed'],
                                        'slate' => ['label' => 'Slate Minimal', 'color' => '#334155'],
                                        'amber' => ['label' => 'Warm Amber', 'color' => '#d97706'],
                                        'cyber' => ['label' => 'Cyber Neon', 'color' => '#06b6d4'],
                                    ];
                                    $currentPreset = old('theme_preset', $setting->theme_preset ?? 'ocean');
                                @endphp

                                @foreach($presets as $key => $preset)
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="theme_preset" id="preset_{{ $key }}" value="{{ $key }}" 
                                            {{ $currentPreset == $key ? 'checked' : '' }} onchange="previewTheme()">
                                        <label class="btn btn-outline-secondary w-100 text-start py-2 px-3 d-flex align-items-center gap-2" for="preset_{{ $key }}">
                                            <span class="rounded-circle d-inline-block" style="width: 16px; height: 16px; background-color: {{ $preset['color'] }};"></span>
                                            <span class="small fw-semibold">{{ $preset['label'] }}</span>
                                        </label>
                                    </div>
                                @endforeach
                            </div>
                        </div>
                    </div>

                    <!-- Corner Styles & Metrics -->
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-transparent fw-bold border-bottom py-3">
                            📏 Shape & Scaling
                        </div>
                        <div class="card-body p-4">
                            <!-- Corner Style Radio Selector -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Corner Radius Style</label>
                                @php
                                    $corners = [
                                        'sharp' => 'Sharp (0px)',
                                        'smooth' => 'Smooth (10px)',
                                        'pill' => 'Pill Rounded (30px)'
                                    ];
                                    $currentCorner = old('corner_style', $setting->corner_style ?? 'smooth');
                                @endphp
                                <div class="btn-group w-100" role="group">
                                    @foreach($corners as $key => $label)
                                        <input type="radio" class="btn-check" name="corner_style" id="corner_{{ $key }}" value="{{ $key }}" 
                                            {{ $currentCorner == $key ? 'checked' : '' }} onchange="previewTheme()">
                                        <label class="btn btn-outline-secondary btn-sm" for="corner_{{ $key }}">{{ $label }}</label>
                                    @endforeach
                                </div>
                            </div>

                            <!-- Font Scaling -->
                            <div class="mb-4">
                                <div class="d-flex justify-content-between">
                                    <label for="font_scale" class="form-label fw-semibold small">Font Scale</label>
                                    <span class="small text-muted" id="font_scale_val">{{ old('font_scale', $setting->font_scale ?? 1.0) }}x</span>
                                </div>
                                <input type="range" class="form-range" min="0.8" max="1.3" step="0.05" id="font_scale" name="font_scale" 
                                    value="{{ old('font_scale', $setting->font_scale ?? 1.0) }}" oninput="previewTheme()">
                            </div>

                            <!-- Shadow Level -->
                            <div>
                                <label for="shadow_level" class="form-label fw-semibold small">Shadow & Elevation Level</label>
                                <select class="form-select" id="shadow_level" name="shadow_level" onchange="previewTheme()">
                                    <option value="0" {{ old('shadow_level', $setting->shadow_level ?? 1) == 0 ? 'selected' : '' }}>0 - Flat (No Shadow)</option>
                                    <option value="1" {{ old('shadow_level', $setting->shadow_level ?? 1) == 1 ? 'selected' : '' }}>1 - Subtle Elevation</option>
                                    <option value="2" {{ old('shadow_level', $setting->shadow_level ?? 1) == 2 ? 'selected' : '' }}>2 - Medium Elevation</option>
                                    <option value="3" {{ old('shadow_level', $setting->shadow_level ?? 1) == 3 ? 'selected' : '' }}>3 - Deep Elevation</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg fw-bold">💾 Save Preferences</button>
                    </div>
                </form>
            </div>

            <!-- Live Preview Sandbox Column -->
            <div class="col-lg-6">
                <div class="sticky-top" style="top: 20px;">
                    <h2 class="h5 fw-bold mb-3">👁️ Live Sandbox Preview</h2>

                    <!-- Interactive Preview Card -->
                    <div class="card p-4 border mb-4" id="preview_card">
                        <span class="badge bg-primary w-25 mb-2" id="preview_badge">Active Preview</span>
                        <h3 class="h4 fw-bold" id="preview_title">Material Design 3 Theme</h3>
                        <p class="text-muted small" id="preview_text">
                            A curated preset component showcase demonstrating how background surfaces, typography, and elevation respond instantly.
                        </p>

                        <div class="d-flex gap-2 mt-2">
                            <button class="btn btn-primary btn-sm" id="preview_btn_1">Primary Action</button>
                            <button class="btn btn-outline-secondary btn-sm" id="preview_btn_2">Secondary Action</button>
                        </div>
                    </div>

                    <!-- Component Test Suite -->
                    <div class="card p-4 border">
                        <h4 class="h6 fw-bold mb-3">UI Element Showcase</h4>
                        <div class="mb-3">
                            <input type="text" class="form-control form-control-sm" placeholder="Sample Input Field..." disabled>
                        </div>
                        <div class="progress mb-3" style="height: 10px;">
                            <div class="progress-bar bg-primary" role="progressbar" style="width: 65%;"></div>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="badge bg-secondary">System Status</span>
                            <span class="text-muted small">v1.3.0-m3</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" defer></script>
    <script>
    // Preset definitions
    const presetPalettes = {
        ocean: { primary: '#0d6efd', secondary: '#6c757d', bg: '#f4f6f9', card: '#ffffff', text: '#212529', border: '#dee2e6' },
        emerald: { primary: '#059669', secondary: '#64748b', bg: '#f0fdf4', card: '#ffffff', text: '#064e3b', border: '#bbf7d0' },
        sunset: { primary: '#7c3aed', secondary: '#db2777', bg: '#faf5ff', card: '#ffffff', text: '#4c1d95', border: '#e9d5ff' },
        slate: { primary: '#334155', secondary: '#64748b', bg: '#f8fafc', card: '#ffffff', text: '#0f172a', border: '#e2e8f0' },
        amber: { primary: '#d97706', secondary: '#78350f', bg: '#fffbeb', card: '#ffffff', text: '#451a03', border: '#fde68a' },
        cyber: { primary: '#06b6d4', secondary: '#f43f5e', bg: '#ecfeff', card: '#ffffff', text: '#0e7490', border: '#a5f3fc' }
    };

    const cornerRadii = {
        sharp: '0px',
        smooth: '10px',
        pill: '30px'
    };

    function previewTheme() {
        const presetKey = document.querySelector('input[name="theme_preset"]:checked')?.value || 'ocean';
        const cornerKey = document.querySelector('input[name="corner_style"]:checked')?.value || 'smooth';
        const scale = document.getElementById('font_scale').value;
        const shadowLevel = document.getElementById('shadow_level').value;

        // Update slider label
        document.getElementById('font_scale_val').innerText = scale + 'x';

        // Get colors for preset (Light mode only now)
        const palette = presetPalettes[presetKey];
        const radius = cornerRadii[cornerKey];

        // Shadows mapping
        const shadows = {
            0: 'none',
            1: '0 1px 3px 1px rgba(0, 0, 0, 0.15), 0 1px 2px 0 rgba(0, 0, 0, 0.3)',
            2: '0 4px 8px 3px rgba(0, 0, 0, 0.15), 0 1px 3px 0 rgba(0, 0, 0, 0.3)',
            3: '0 8px 16px 4px rgba(0, 0, 0, 0.15), 0 3px 6px 0 rgba(0, 0, 0, 0.3)'
        };

        // Apply to CSS variables on root
        const root = document.documentElement;
        root.style.setProperty('--app-primary', palette.primary);
        root.style.setProperty('--app-secondary', palette.secondary);
        root.style.setProperty('--app-bg', palette.bg);
        root.style.setProperty('--app-card-bg', palette.card);
        root.style.setProperty('--app-text', palette.text);
        root.style.setProperty('--app-border', palette.border);
        root.style.setProperty('--app-radius', radius);
        root.style.setProperty('--app-font-scale', scale);
        root.style.setProperty('--app-shadow', shadows[shadowLevel]);
    }

    document.addEventListener('DOMContentLoaded', previewTheme);
</script>
</body>
</html>