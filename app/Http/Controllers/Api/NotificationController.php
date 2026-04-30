<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\Notification as NotificationModel;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        return ApiResponse::success(
            NotificationModel::where('user_id', $request->user()->id)->get(),
            'Notifications retrieved successfully'
        );
    }

    public function markAsRead(NotificationModel $notification)
    {
        $notification->update(['is_read' => true]);
        return ApiResponse::success($notification, 'Notification marked as read');
    }

    public function destroy(NotificationModel $notification)
    {
        $notification->delete();
        return ApiResponse::success([], 'Notification deleted successfully');
    }
}