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
                'price_per_hour'=> 200,
                'latitude'      => 30.0444,
                'longitude'     => 31.2357,
            ],
            [
                'name'          => 'ملعب الأهلي',
                'sport_id'      => 1,
                'description'   => 'ملعب كرة قدم في قلب القاهرة',
                'address'       => 'وسط البلد، القاهرة',
                'price_per_hour'=> 250,
                'latitude'      => 30.0600,
                'longitude'     => 31.2200,
            ],
            [
                'name'          => 'ملعب بادل الرياضي',
                'sport_id'      => 2,
                'description'   => 'ملعب بادل احترافي',
                'address'       => 'المهندسين، الجيزة',
                'price_per_hour'=> 300,
                'latitude'      => 30.0500,
                'longitude'     => 31.2400,
            ],
            [
                'name'          => 'ملعب بادل النخبة',
                'sport_id'      => 2,
                'description'   => 'ملعب بادل مكيف',
                'address'       => 'الزمالك، القاهرة',
                'price_per_hour'=> 350,
                'latitude'      => 30.0550,
                'longitude'     => 31.2300,
            ],
            [
                'name'          => 'ملعب السلة الذهبي',
                'sport_id'      => 3,
                'description'   => 'ملعب كرة سلة بأرضية خشبية',
                'address'       => 'مصر الجديدة، القاهرة',
                'price_per_hour'=> 150,
                'latitude'      => 30.0480,
                'longitude'     => 31.2450,
            ],
            [
                'name'          => 'ملعب السلة الأولمبي',
                'sport_id'      => 3,
                'description'   => 'ملعب كرة سلة في الهواء الطلق',
                'address'       => 'المعادي، القاهرة',
                'price_per_hour'=> 180,
                'latitude'      => 30.0420,
                'longitude'     => 31.2500,
            ],
        ];

        foreach ($courts as $court) {
            Court::create($court);
        }
    }
}