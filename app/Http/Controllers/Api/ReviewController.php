<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        return ApiResponse::success(
            Review::with(['user', 'court'])->get(),
            'Reviews retrieved successfully'
        );
    }

    public function show(Review $review)
    {
        return ApiResponse::success(
            $review->load(['user', 'court']),
            'Review retrieved successfully'
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'court_id' => 'required|exists:courts,id',
            'rating'   => 'required|integer|min:1|max:5',
            'comment'  => 'nullable|string',
        ]);

        $validated['user_id'] = $request->user()->id;

        $review = Review::create($validated);
        return ApiResponse::success($review, 'Review created successfully', 201);
    }

    public function destroy(Review $review)
    {
        $review->delete();
        return ApiResponse::success([], 'Review deleted successfully');
    }
}