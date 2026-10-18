<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Setting extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'is_dark_mode',
        'theme_preset',
        'corner_style',
        'shadow_level',
        'font_scale',
        'is_compact_density',
    ];

    protected $casts = [
        'is_dark_mode' => 'boolean',
        'is_compact_density' => 'boolean',
        'shadow_level' => 'integer',
        'font_scale' => 'float',
    ];

    public function user()
    {
        return $this->belongsTo(LibUser::class, 'user_id');
    }
}