# API Specifications

## Overview

Room Booking System API menggunakan RESTful architecture dengan JSON response format. Semua endpoint memerlukan authentication kecuali login/register.

**Base URL:** `http://localhost:5000/api/v1`  
**Response Format:** JSON  
**Authentication:** Bearer JWT Token  
**Rate Limit:** 100 requests/minute per user

---

## Authentication Endpoints

### 1. User Login
```
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "user-001",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "employee"
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "error": "Invalid credentials",
  "message": "Email or password is incorrect"
}
```

---

### 2. User Registration
```
POST /auth/register
```

**Request Body:**
```json
{
  "email": "newuser@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "department": "IT"
}
```

**Success Response (201 Created):**
```json
{
  "id": "user-002",
  "email": "newuser@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "employee",
  "createdAt": "2024-02-17T10:30:00Z"
}
```

---

## Room Endpoints

### 3. Get All Rooms
```
GET /rooms?page=1&pageSize=10&status=active
```

**Query Parameters:**
- `page` (optional): Page number, default 1
- `pageSize` (optional): Items per page, default 10
- `status` (optional): Filter by status (active, maintenance, archived)
- `capacity` (optional): Filter by minimum capacity
- `amenities` (optional): Comma-separated amenities filter

**Success Response (200 OK):**
```json
{
  "data": [
    {
      "id": "room-001",
      "name": "Meeting Room A",
      "location": "Building 1, Floor 2",
      "capacity": 10,
      "amenities": ["projector", "whiteboard", "ac"],
      "status": "active",
      "photoUrl": "https://example.com/rooms/room-001.jpg",
      "createdAt": "2024-01-15T08:00:00Z",
      "updatedAt": "2024-02-17T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "totalItems": 25,
    "totalPages": 3
  }
}
```

---

### 4. Get Room Details
```
GET /rooms/{roomId}
```

**Path Parameters:**
- `roomId` (required): Room ID

**Success Response (200 OK):**
```json
{
  "id": "room-001",
  "name": "Meeting Room A",
  "location": "Building 1, Floor 2",
  "capacity": 10,
  "amenities": ["projector", "whiteboard", "ac"],
  "status": "active",
  "photoUrl": "https://example.com/rooms/room-001.jpg",
  "description": "Spacious meeting room with modern facilities",
  "createdAt": "2024-01-15T08:00:00Z",
  "updatedAt": "2024-02-17T10:00:00Z",
  "bookings": [
    {
      "id": "booking-001",
      "startTime": "2024-02-18T09:00:00Z",
      "endTime": "2024-02-18T10:00:00Z",
      "status": "confirmed"
    }
  ]
}
```

---

### 5. Create Room (Admin Only)
```
POST /rooms
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "Meeting Room B",
  "location": "Building 1, Floor 3",
  "capacity": 15,
  "amenities": ["projector", "whiteboard", "ac", "coffee_machine"],
  "description": "Conference room for large meetings",
  "photoUrl": "https://example.com/rooms/room-002.jpg"
}
```

**Success Response (201 Created):**
```json
{
  "id": "room-002",
  "name": "Meeting Room B",
  "location": "Building 1, Floor 3",
  "capacity": 15,
  "amenities": ["projector", "whiteboard", "ac", "coffee_machine"],
  "status": "active",
  "createdAt": "2024-02-17T10:30:00Z"
}
```

---

## Booking Endpoints

### 6. Create Booking
```
POST /bookings
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "roomId": "room-001",
  "startTime": "2024-02-18T14:00:00Z",
  "endTime": "2024-02-18T15:00:00Z",
  "title": "Team Meeting",
  "description": "Weekly team sync",
  "attendeeCount": 5,
  "specialRequirements": "Need extra whiteboard markers"
}
```

**Success Response (201 Created):**
```json
{
  "id": "booking-001",
  "roomId": "room-001",
  "userId": "user-001",
  "startTime": "2024-02-18T14:00:00Z",
  "endTime": "2024-02-18T15:00:00Z",
  "title": "Team Meeting",
  "status": "confirmed",
  "createdAt": "2024-02-17T11:00:00Z"
}
```

**Error Response (409 Conflict):**
```json
{
  "error": "Room unavailable",
  "message": "Room is already booked for the selected time",
  "suggestedTimes": [
    "2024-02-18T15:00:00Z - 2024-02-18T16:00:00Z",
    "2024-02-18T16:00:00Z - 2024-02-18T17:00:00Z"
  ]
}
```

---

### 7. Get User Bookings
```
GET /bookings?status=confirmed&from=2024-02-17&to=2024-03-17
Authorization: Bearer {token}
```

**Query Parameters:**
- `status` (optional): Filter by status (confirmed, pending, cancelled)
- `from` (optional): Start date (YYYY-MM-DD)
- `to` (optional): End date (YYYY-MM-DD)

**Success Response (200 OK):**
```json
{
  "data": [
    {
      "id": "booking-001",
      "roomId": "room-001",
      "roomName": "Meeting Room A",
      "startTime": "2024-02-18T14:00:00Z",
      "endTime": "2024-02-18T15:00:00Z",
      "title": "Team Meeting",
      "status": "confirmed",
      "createdAt": "2024-02-17T11:00:00Z"
    }
  ],
  "pagination": {
    "totalItems": 1,
    "page": 1
  }
}
```

---

### 8. Cancel Booking
```
DELETE /bookings/{bookingId}
Authorization: Bearer {token}
```

**Success Response (200 OK):**
```json
{
  "message": "Booking cancelled successfully",
  "bookingId": "booking-001",
  "status": "cancelled",
  "cancelledAt": "2024-02-17T11:15:00Z"
}
```

**Error Response (400 Bad Request):**
```json
{
  "error": "Cannot cancel booking",
  "message": "Booking start time is less than 1 hour away"
}
```

---

## Analytics Endpoints (Admin Only)

### 9. Get Room Statistics
```
GET /analytics/rooms/{roomId}/stats?from=2024-01-17&to=2024-02-17
Authorization: Bearer {token}
```

**Success Response (200 OK):**
```json
{
  "roomId": "room-001",
  "roomName": "Meeting Room A",
  "totalBookings": 45,
  "utilizationRate": 0.72,
  "peakHours": "14:00 - 16:00",
  "averageAttendees": 6,
  "averageDuration": 60,
  "revenueGenerated": 0,
  "bookingsByStatusp": {
    "confirmed": 40,
    "cancelled": 5
  }
}
```

---

### 10. Get Booking Summary
```
GET /analytics/bookings/summary?period=month
Authorization: Bearer {token}
```

**Query Parameters:**
- `period` (optional): day, week, month, year

**Success Response (200 OK):**
```json
{
  "period": "month",
  "totalBookings": 250,
  "confirmedBookings": 220,
  "cancelledBookings": 30,
  "pendingBookings": 0,
  "activeUsers": 45,
  "topRooms": [
    {
      "roomId": "room-001",
      "name": "Meeting Room A",
      "bookingCount": 50
    }
  ]
}
```

---

## Error Handling

### Error Response Format
```json
{
  "error": "Error Type",
  "message": "Detailed error message",
  "statusCode": 400,
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

### Common Status Codes
| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created |
| 204 | No Content - Successful with no content |
| 400 | Bad Request - Invalid request data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Permission denied |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource conflict (e.g., double booking) |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server error |

---

## Pagination

All list endpoints support pagination:

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 10,
    "totalItems": 250,
    "totalPages": 25,
    "hasNext": true,
    "hasPrevious": false
  }
}
```

---

## Rate Limiting

Headers included in response:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 94
X-RateLimit-Reset: 1708096200
```

---

## Webhook Events (Future)

System akan support webhooks untuk events:
- `booking.created`
- `booking.cancelled`
- `room.maintenance_started`
- `room.maintenance_ended`
- `booking.reminder` (30 min before)

---

## SDK & Client Libraries

- **JavaScript/TypeScript** - `@room-booking/js-sdk`
- **Python** - `room-booking-sdk`
- **Go** - `room-booking-go`

Integration example:
```typescript
import { RoomBookingClient } from '@room-booking/js-sdk';

const client = new RoomBookingClient('api_key_here');
const rooms = await client.rooms.list();
```

---

## Documentation & Testing

- **API Documentation:** Swagger/OpenAPI at `/swagger`
- **API Testing:** Postman collection available
- **WebSocket Support:** Real-time booking updates (Planned Phase 2)
