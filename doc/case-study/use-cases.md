# Use Cases

## Use Case Diagram

```
┌─────────────────────────────────────────────────┐
│         Room Booking System                     │
├─────────────────────────────────────────────────┤
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │                                          │  │
│  │    (UC1) View Available Rooms            │  │
│  │  ◆◆◆◆                                   │  │
│  │    (UC2) Search Rooms                    │  │
│  │  ◆◆◆                                    │  │
│  │    (UC3) Book Room                       │  │
│  │  ◆◆◆◆◆                                 │  │
│  │    (UC4) Cancel Booking                  │  │
│  │  ◆◆◆◆                                   │  │
│  │                                          │  │
│  │    (UC5) Manage Rooms (Admin)            │  │
│  │  ◆◆◆◆◆◆                                │  │
│  │    (UC6) View Analytics (Admin)          │  │
│  │  ◆◆◆◆                                   │  │
│  │                                          │  │
│  │    (UC7) Get Notification                │  │
│  │  ◆◆◆◆                                   │  │
│  │                                          │  │
│  └──────────────────────────────────────────┘  │
│         ▲                      ▲                │
│         │                      │                │
│  ┌──────┴──────┐         ┌─────┴────────────┐ │
│  │  Employee   │         │  Admin/Facilities│ │
│  └─────────────┘         └──────────────────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

## Detailed Use Cases

### UC1: View Available Rooms
**Primary Actor:** Employee  
**Goal:** Employee melihat daftar semua meeting rooms yang tersedia

**Preconditions:**
- Employee sudah login ke sistem
- Terdapat minimal 1 room dalam database

**Main Flow:**
1. Employee membuka halaman "Available Rooms"
2. Sistem menampilkan daftar semua rooms dengan status ketersediaan
3. Setiap room menampilkan:
   - Nama ruang
   - Kapasitas
   - Fasilitas
   - Status (available/booked)
4. Employee dapat melihat detail ruang dengan click

**Postconditions:**
- Employee dapat melihat list rooms dan memilih untuk booking

**Alternative Flow:**
- Jika tidak ada rooms tersedia: Tampilkan pesan "No rooms available"

---

### UC2: Search Rooms
**Primary Actor:** Employee  
**Goal:** Employee mencari rooms sesuai kriteria spesifik

**Preconditions:**
- Employee sudah di halaman "Available Rooms"
- Database berisi multiple rooms

**Main Flow:**
1. Employee masukkan kriteria pencarian:
   - Tanggal start
   - Tanggal end
   - Waktu mulai
   - Durasi/waktu selesai
   - Kapasitas minimal
   - Fasilitas yang dibutuhkan
2. Employee click "Search"
3. Sistem filter rooms berdasarkan kriteria
4. Tampilkan hasil search yang match

**Postconditions:**
- Employee mendapat daftar rooms yang sesuai dengan kriteria

**Validation Rules:**
- End date >= Start date
- End time > Start time
- Capacity >= 1

---

### UC3: Book Room
**Primary Actor:** Employee  
**Goal:** Employee melakukan booking room untuk meeting

**Preconditions:**
- Employee sudah identify room yang ingin di-book
- Room available untuk waktu yang dipilih
- Employee sudah login

**Main Flow:**
1. Employee click "Book Now" pada room pilihan
2. Sistem tampilkan booking form dengan:
   - Room name (read-only)
   - Date & time (pre-filled dari search)
   - Meeting title/topic
   - Estimated attendees
   - Special requirements/notes
3. Employee isi form dan click "Confirm Booking"
4. Sistem validate data:
   - Check room availability di selected time
   - Check no conflicts
5. Jika valid: Create booking record, send confirmation email
6. Tampilkan confirmation screen dengan booking details

**Postconditions:**
- Booking created dalam database
- Employee menerima confirmation email
- Room status updated menjadi "booked"

**Alternative Flows:**
- Conflict detected: Tampilkan error, suggest alternative times/rooms
- Email send failed: Tampilkan warning, booking tetap created

---

### UC4: Cancel Booking
**Primary Actor:** Employee  
**Goal:** Employee cancel booking yang sudah dibuat

**Preconditions:**
- Employee punya active booking
- Booking belum dalam status "completed"
- Cancellation allowed (> 1 jam sebelum meeting)

**Main Flow:**
1. Employee navigate ke "My Bookings"
2. Select booking yang ingin di-cancel
3. Click "Cancel Booking"
4. Tampilkan confirmation dialog
5. Employee confirm cancellation
6. Sistem update booking status menjadi "cancelled"
7. Send cancellation email

**Postconditions:**
- Booking status = "cancelled"
- Room available untuk di-book oleh user lain
- Cancellation confirmation dikirim

**Alternative Flows:**
- Cancellation denied: Tampilkan message "Cannot cancel - less than 1 hour before meeting"

---

### UC5: Manage Rooms (Admin)
**Primary Actor:** Admin/Facilities Manager  
**Goal:** Admin mengelola master data rooms

**Preconditions:**
- User punya role "Admin" atau "Facilities Manager"
- Admin sudah login

**Main Flow - Create Room:**
1. Admin click "Add New Room"
2. Fill form:
   - Room name
   - Building/Location
   - Floor
   - Capacity
   - Amenities (checkbox list)
   - Photos
3. Click "Save"
4. Sistem create room record
5. Show success message

**Main Flow - Edit Room:**
1. Admin click room dari list
2. Update relevan fields
3. Click "Save"
4. Sistem update record

**Main Flow - Delete Room:**
1. Admin click "Delete" pada room
2. Confirm deletion
3. Check untuk active bookings
4. Jika ada: Notify user atau transfer ke room lain

**Postconditions:**
- Room data updated dalam database

---

### UC6: View Analytics (Admin)
**Primary Actor:** Admin  
**Goal:** Admin melihat analytics dan reports untuk optimization

**Main Flow:**
1. Admin open "Analytics Dashboard"
2. Sistem tampilkan:
   - Total bookings (period selectable)
   - Room utilization rate per room
   - Peak hours/days
   - User booking patterns
   - Failed bookings/conflicts
   - Revenue metrics (jika applicable)
3. Admin dapat download reports atau export data

**Postconditions:**
- Admin mendapat insights untuk decision making

---

### UC7: Get Notification
**Primary Actor:** Employee/Admin  
**Goal:** User menerima notification update tentang bookings

**Trigger Events:**
1. Booking confirmation
2. Booking cancellation (dari admin)
3. Room maintenance notification
4. Meeting reminder (30 menit sebelum)
5. Booking conflict resolution

**Delivery Channels:**
- Email
- Push notification (mobile)
- In-app notification

**Example Flow:**
1. Employee complete booking
2. Sistem send booking confirmation email dalam 1 menit
3. 30 menit sebelum meeting: send reminder
4. If booking cancelled: send notification

---

## Extended Use Cases

### UC8: Handle Maintenance (Admin)
- Mark room sebagai "maintenance" temporarily
- Notify users dengan active bookings
- Auto-transfer bookings ke alternative room

### UC9: Recurring Bookings
- User dapat create recurring booking (weekly, monthly)
- Define end date untuk recurring bookings
- Support complex recurrence rules

### UC10: Room Conflicts Resolution
- System detect conflicts
- Auto-suggest resolution options
- Admin dapat forcefully reassign bookings

### UC11: User Role Management
- Admin dapat assign roles ke users
- Role define permissions
- Support custom roles

---

## Use Case Prioritization

| Priority | Use Cases |
|----------|-----------|
| CRITICAL | UC1, UC2, UC3, UC4 |
| HIGH | UC5, UC6, UC7 |
| MEDIUM | UC8, UC9 |
| LOW | UC10, UC11 |

**MVP Release:** UC1-4 (User Booking Core)  
**Phase 2:** UC5-7 (Admin & Notification)  
**Phase 3:** UC8-11 (Advanced Features)
