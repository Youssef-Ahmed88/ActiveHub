<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Court;

class CourtSeeder extends Seeder
{
    public function run(): void
    {
$courts = [
    [
        'name'          => 'ملعب النصر',
        'sport_id'      => 1,
        'description'   => 'ملعب كرة قدم مجهز بالكامل',
        'address'       => 'مدينة نصر، القاهرة',
        'image'         => 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=400',
        'price_per_hour'=> 200,
        'latitude'      => 30.0444,
        'longitude'     => 31.2357,
        'rating'        => 4.5,
        'is_available'  => true,
    ],
    [
        'name'          => 'ملعب الأهلي',
        'sport_id'      => 1,
        'description'   => 'ملعب كرة قدم في قلب القاهرة',
        'address'       => 'وسط البلد، القاهرة',
        'image'         => 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=400',
        'price_per_hour'=> 250,
        'latitude'      => 30.0600,
        'longitude'     => 31.2200,
        'rating'        => 4.2,
        'is_available'  => true,
    ],
    [
        'name'          => 'ملعب بادل الرياضي',
        'sport_id'      => 2,
        'description'   => 'ملعب بادل احترافي',
        'address'       => 'المهندسين، الجيزة',
        'image'         => 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
        'price_per_hour'=> 300,
        'latitude'      => 30.0500,
        'longitude'     => 31.2400,
        'rating'        => 4.8,
        'is_available'  => true,
    ],
    [
        'name'          => 'ملعب بادل النخبة',
        'sport_id'      => 2,
        'description'   => 'ملعب بادل مكيف',
        'address'       => 'الزمالك، القاهرة',
        'image'         => 'https://images.unsplash.com/photo-1599586120429-48281b6f0ece?w=400',
        'price_per_hour'=> 350,
        'latitude'      => 30.0550,
        'longitude'     => 31.2300,
        'rating'        => 4.6,
        'is_available'  => false,
    ],
    [
        'name'          => 'ملعب السلة الذهبي',
        'sport_id'      => 3,
        'description'   => 'ملعب كرة سلة بأرضية خشبية',
        'address'       => 'مصر الجديدة، القاهرة',
        'image'         => 'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
        'price_per_hour'=> 150,
        'latitude'      => 30.0480,
        'longitude'     => 31.2450,
        'rating'        => 4.3,
        'is_available'  => true,
    ],
    [
        'name'          => 'ملعب السلة الأولمبي',
        'sport_id'      => 3,
        'description'   => 'ملعب كرة سلة في الهواء الطلق',
        'address'       => 'المعادي، القاهرة',
        'image'         => 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?w=400',
        'price_per_hour'=> 180,
        'latitude'      => 30.0420,
        'longitude'     => 31.2500,
        'rating'        => 4.1,
        'is_available'  => true,
    ],
];

        foreach ($courts as $court) {
            Court::create($court);
        }
    }
}