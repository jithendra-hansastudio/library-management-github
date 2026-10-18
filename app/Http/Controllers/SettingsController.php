<?php
namespace App\Http\Controllers;

use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SettingsController extends Controller
{
   public function edit()
{
    // Change this line to query the Setting table directly using the user's ID
    $setting = Setting::where('user_id', Auth::id())->first() ?? new Setting();
    
    return view('settings.edit', compact('setting'));
}

    public function api_index()
    {
        return response()->json(Setting::get());
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'is_dark_mode'       => 'sometimes|boolean',
            'theme_preset'       => 'required|string|in:ocean,emerald,sunset,slate,amber,cyber',
            'corner_style'       => 'required|string|in:sharp,smooth,pill',
            'shadow_level'       => 'required|integer|min:0|max:3',
            'font_scale'         => 'required|numeric|min:0.8|max:1.3',
            'is_compact_density' => 'sometimes|boolean',
        ]);

        $user = Auth::user();

        Setting::updateOrCreate(
            ['user_id' => $user->id],
            [
                'is_dark_mode'       => $request->boolean('is_dark_mode'),
                'theme_preset'       => $validated['theme_preset'],
                'corner_style'       => $validated['corner_style'],
                'shadow_level'       => $validated['shadow_level'],
                'font_scale'         => $validated['font_scale'],
                'is_compact_density' => $request->boolean('is_compact_density'),
            ]
        );

        return redirect()->back()->with('success', 'UI preferences updated successfully!');
    }
}