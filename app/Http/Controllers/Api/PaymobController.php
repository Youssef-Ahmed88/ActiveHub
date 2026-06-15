<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PaymobController extends Controller
{
    private string $apiKey;
    private string $secretKey;
    private int $integrationId;
    private int $iframeId;
    private string $baseUrl;

    public function __construct()
    {
        $this->apiKey        = config('services.paymob.api_key');
        $this->secretKey     = config('services.paymob.secret_key');
        $this->integrationId = (int) config('services.paymob.integration_id');
        $this->iframeId      = (int) config('services.paymob.iframe_id');
        $this->baseUrl       = config('services.paymob.base_url');
    }

    public function createPayment(Request $request)
    {
        $request->validate([
            'booking_id' => 'required|exists:bookings,id',
        ]);

        $booking = Booking::with(['court', 'user'])->findOrFail($request->booking_id);

        if ($booking->user_id !== Auth::id()) {
            return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
        }

        // ✅ الـ deposit = 30% من الـ total_price
        $depositAmount = $booking->total_price * 0.30;
        $amountCents   = (int) ($depositAmount * 100);

        $user = Auth::user();

        try {
            // Step 1: Get auth token
            $authResponse = Http::withOptions(['verify' => false])
                ->post("{$this->baseUrl}/api/auth/tokens", [
                    'api_key' => $this->apiKey,
                ]);

            if ($authResponse->failed()) {
                Log::error('Paymob auth failed: ' . $authResponse->body());
                return response()->json(['success' => false, 'message' => 'Payment service unavailable'], 503);
            }

            $authToken = $authResponse->json()['token'];

            // Step 2: Create order
            $orderResponse = Http::withOptions(['verify' => false])
                ->withToken($authToken)
                ->post("{$this->baseUrl}/api/ecommerce/orders", [
                    'auth_token'      => $authToken,
                    'delivery_needed' => false,
                    'amount_cents'    => $amountCents,
                    'currency'        => 'EGP',
                    'items'           => [
                        [
                            'name'         => 'Court Booking - ' . $booking->court->name,
                            'amount_cents' => $amountCents,
                            'description'  => 'Sports court booking deposit (30%)',
                            'quantity'     => 1,
                        ]
                    ],
                ]);

            if ($orderResponse->failed()) {
                Log::error('Paymob order failed: ' . $orderResponse->body());
                return response()->json(['success' => false, 'message' => 'Failed to create order'], 503);
            }

            $orderId = $orderResponse->json()['id'];

            // حفظ رقم Order الخاص بـ Paymob
            $booking->update([
                'paymob_order_id' => $orderId,
            ]);

            // Step 3: Get payment key
            $paymentKeyResponse = Http::withOptions(['verify' => false])
                ->withToken($authToken)
                ->post("{$this->baseUrl}/api/acceptance/payment_keys", [
                    'auth_token'           => $authToken,
                    'amount_cents'         => $amountCents,
                    'expiration'           => 3600,
                    'order_id'             => $orderId,
                    'billing_data'         => [
                        'apartment'       => 'NA',
                        'email'           => $user->email,
                        'floor'           => 'NA',
                        'first_name'      => explode(' ', $user->full_name)[0] ?? 'User',
                        'last_name'       => explode(' ', $user->full_name)[1] ?? 'ActiveHub',
                        'street'          => 'NA',
                        'building'        => 'NA',
                        'phone_number'    => $user->phone ?? '+201000000000',
                        'shipping_method' => 'NA',
                        'postal_code'     => 'NA',
                        'city'            => 'Cairo',
                        'country'         => 'EG',
                        'state'           => 'Cairo',
                    ],
                    'currency'             => 'EGP',
                    'integration_id'       => $this->integrationId,
                    'lock_order_when_paid' => true,
                ]);

            if ($paymentKeyResponse->failed()) {
                Log::error('Paymob payment key failed: ' . $paymentKeyResponse->body());
                return response()->json(['success' => false, 'message' => 'Failed to get payment key'], 503);
            }

            $paymentKey = $paymentKeyResponse->json()['token'];
            $iframeUrl  = "{$this->baseUrl}/api/acceptance/iframes/{$this->iframeId}?payment_token={$paymentKey}";

            return response()->json([
                'success' => true,
                'data'    => [
                    'iframe_url'  => $iframeUrl,
                    'payment_key' => $paymentKey,
                    'order_id'    => $orderId,
                    // ✅ بيرجع الـ deposit مش الـ total
                    'amount'      => $depositAmount,
                ],
            ]);

        } catch (\Exception $e) {
            Log::error('Paymob exception: ' . $e->getMessage());
            return response()->json(['success' => false, 'message' => 'Payment error: ' . $e->getMessage()], 500);
        }
    }

    public function callback(Request $request)
    {
        $data = $request->all();
        Log::info('Paymob callback received', $data);

        $hmac = $data['hmac'] ?? '';
        if (!$this->verifyHmac($data, $hmac)) {
            Log::warning('Paymob HMAC verification failed');
            return response()->json(['success' => false], 400);
        }

        $transactionData = $data['obj'] ?? [];
        $success         = $transactionData['success'] ?? false;
        $orderId         = $transactionData['order']['id'] ?? null;

        if ($success && $orderId) {
            $booking = Booking::where('paymob_order_id', $orderId)->first();

            if ($booking) {
                $booking->update(['status' => 'confirmed']);
                Log::info("Booking {$booking->id} confirmed successfully");
            }

            Log::info("Paymob payment successful for order: {$orderId}");
        }
    }

    private function verifyHmac(array $data, string $hmac): bool
    {
        $obj = $data['obj'] ?? [];
        $concatenated = implode('', [
            $obj['amount_cents'] ?? '',
            $obj['created_at'] ?? '',
            $obj['currency'] ?? '',
            $obj['error_occured'] ?? '',
            $obj['has_parent_transaction'] ?? '',
            $obj['id'] ?? '',
            $obj['integration_id'] ?? '',
            $obj['is_3d_secure'] ?? '',
            $obj['is_auth'] ?? '',
            $obj['is_capture'] ?? '',
            $obj['is_refunded'] ?? '',
            $obj['is_standalone_payment'] ?? '',
            $obj['is_voided'] ?? '',
            $obj['order']['id'] ?? '',
            $obj['owner'] ?? '',
            $obj['pending'] ?? '',
            $obj['source_data']['pan'] ?? '',
            $obj['source_data']['sub_type'] ?? '',
            $obj['source_data']['type'] ?? '',
            $obj['success'] ?? '',
        ]);

        $expectedHmac = hash_hmac('sha512', $concatenated, $this->secretKey);
        return hash_equals($expectedHmac, $hmac);
    }
}