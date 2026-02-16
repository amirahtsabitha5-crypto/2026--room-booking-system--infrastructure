# System Architecture

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐          ┌──────────────┐                    │
│  │  Web (React) │          │  Mobile      │                    │
│  │  Browser     │          │  (Flutter)   │                    │
│  └──────┬───────┘          └──────┬───────┘                    │
│         │                         │                            │
└─────────┼─────────────────────────┼────────────────────────────┘
          │                         │
      HTTPS/API Request         HTTPS/API Request
          │                         │
┌─────────┼─────────────────────────┼────────────────────────────┐
│         │     API GATEWAY LAYER   │                            │
│         └─────────────┬───────────┘                            │
└─────────────────────────┼───────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
┌─────────▼──────┐ ┌────▼────────┐ ┌──▼──────────┐
│  LOAD          │ │  RATE       │ │  CACHE      │
│  BALANCER      │ │  LIMITER    │ │  LAYER      │
│  (Nginx)       │ │  (Redis)    │ │  (Redis)    │
└─────────┬──────┘ └────┬────────┘ └──┬──────────┘
          │             │             │
          └─────────────┼─────────────┘
                        │
┌───────────────────────▼────────────────────────────────────────┐
│              APPLICATION LAYER (.NET API)                      │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  Rooms       │  │  Bookings    │  │  Auth        │       │
│  │  Controller  │  │  Controller  │  │  Controller  │       │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│         │                 │                 │               │
│  ┌──────▼──────┐  ┌────────▼────────┐  ┌───▼─────────┐     │
│  │  Room       │  │  Booking       │  │  Auth      │      │
│  │  Service    │  │  Service       │  │  Service   │      │
│  └──────┬──────┘  └────────┬────────┘  └───┬────────┘      │
│         │                 │                 │               │
│  ┌──────▼──────────────────▼─────────────────▼──────┐       │
│  │      Repository Pattern / Data Access Layer     │       │
│  └──────┬──────────────────────────────────────────┘       │
│         │                                                  │
└─────────┼──────────────────────────────────────────────────┘
          │
┌─────────▼──────────────────────────────────────────────────────┐
│              DATA LAYER (PostgreSQL)                           │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────┐  ┌──────────┐  ┌────────────┐              │
│  │  Users      │  │  Rooms   │  │  Bookings  │              │
│  │  Table      │  │  Table   │  │  Table     │              │
│  └─────────────┘  └──────────┘  └────────────┘              │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Primary DB       │  Read Replica  │  Backup DB    │   │
│  │  (Write)          │  (Read)        │  (DR)         │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
└───────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              EXTERNAL SERVICES                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌─────────────┐    ┌─────────────┐      │
│  │  Email       │    │  Push       │    │  File       │      │
│  │  Service     │    │  Notification   │ Storage     │      │
│  │  (SendGrid)  │    │  Service    │    │  (S3/Azure) │      │
│  └──────────────┘    └─────────────┘    └─────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend Web** | React 18 + TypeScript | Modern, component-based UI |
| **Frontend Mobile** | Flutter | Cross-platform mobile (iOS/Android) |
| **Backend** | .NET 10 / C# | High-performance API |
| **Database** | PostgreSQL 15 | Reliable relational database |
| **Caching** | Redis | Performance optimization |
| **Load Balancing** | Nginx | Request distribution |
| **API Documentation** | Swagger/OpenAPI | API specification |
| **Authentication** | JWT | Stateless authentication |
| **Version Control** | Git | Code management |
| **CI/CD** | GitHub Actions | Automated deployment |
| **Containerization** | Docker | Consistent environment |
| **Orchestration** | Kubernetes/Docker Compose | Container management |
| **Monitoring** | ELK Stack / Prometheus | Performance monitoring |
| **Backup** | PostgreSQL WAL | Data backup & recovery |

## Data Models

### Room Entity
```
Room
├── Id (Primary Key)
├── Name
├── Location
├── Capacity
├── Amenities (JSON)
├── Status (active/maintenance/archived)
├── PhotoUrl
├── CreatedAt
└── UpdatedAt
```

### Booking Entity
```
Booking
├── Id (Primary Key)
├── RoomId (Foreign Key)
├── UserId (Foreign Key)
├── StartTime
├── EndTime
├── Title
├── Description
├── AttendeeCount
├── Status (pending/confirmed/cancelled/completed)
├── CreatedAt
├── UpdatedAt
└── StatusHistory
```

### User Entity
```
User
├── Id (Primary Key)
├── Email
├── PasswordHash
├── FirstName
├── LastName
├── Role (employee/admin/facilities_manager)
├── Department
├── IsActive
├── LastLogin
├── CreatedAt
└── UpdatedAt
```

## API Architecture

### RESTful Endpoints Structure
```
/api/v1/
├── /rooms
│  ├── GET    /                 (List rooms)
│  ├── GET    /{id}             (Get room details)
│  ├── POST   /                 (Create room - Admin)
│  ├── PUT    /{id}             (Update room - Admin)
│  └── DELETE /{id}             (Delete room - Admin)
│
├── /bookings
│  ├── GET    /                 (List bookings - own/all)
│  ├── GET    /{id}             (Get booking details)
│  ├── POST   /                 (Create booking)
│  ├── PUT    /{id}             (Update booking)
│  ├── DELETE /{id}             (Cancel booking)
│  └── GET    /{id}/history     (Get booking history)
│
├── /auth
│  ├── POST   /login            (User login)
│  ├── POST   /register         (User registration)
│  ├── POST   /refresh-token    (Refresh JWT)
│  └── POST   /logout           (User logout)
│
└── /analytics
   ├── GET    /room/{id}/stats  (Room statistics)
   ├── GET    /bookings/summary (Booking summary)
   └── GET    /reports          (Generate reports)
```

## Security Architecture

### Authentication & Authorization
- JWT tokens dengan 24 jam expiration
- Refresh token untuk persistent sessions  
- Role-based access control (RBAC)
- Token blacklist untuk logout

### Data Protection
- SSL/TLS encryption in transit
- Bcrypt password hashing
- PostgreSQL built-in encryption at rest
- Sensitive data masking in logs

### API Security
- CORS whitelist configuration
- Rate limiting per user/IP
- Request validation & sanitization
- SQL injection prevention (parameterized queries)
- CSRF token untuk state-changing operations

## Deployment Architecture

```
┌─────────────────────────────────────────────────────┐
│           Development Environment                   │
├─────────────────────────────────────────────────────┤
│  Docker Compose dengan 3 services:                  │
│  - Backend (.NET)                                   │
│  - Frontend (React dev server)                      │
│  - PostgreSQL Database                              │
│  - Redis Cache                                      │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│        Production Environment (Cloud/K8s)           │
├─────────────────────────────────────────────────────┤
│  Kubernetes Cluster:                                │
│  - Backend pods (scaled)                            │
│  - Frontend pods (CDN + nginx)                      │
│  - PostgreSQL managed service                       │
│  - Redis cluster                                    │
│  - Ingress controller                               │
│  - Auto-scaling based on metrics                    │
└─────────────────────────────────────────────────────┘
```

## Scalability Considerations

1. **Horizontal Scaling**
   - Stateless API servers (multiple replicas)
   - Load balanced requests
   - Database read replicas

2. **Caching Strategy**
   - Redis untuk frequently accessed data
   - Browser caching untuk static assets
   - CDN untuk global distribution

3. **Database Optimization**
   - Proper indexing
   - Connection pooling
   - Query optimization
   - Partitioning untuk large tables

4. **Monitoring & Observability**
   - Application performance monitoring
   - Database query analysis
   - Error tracking (Sentry)
   - Log aggregation (ELK)

## Disaster Recovery

- Automated daily backups
- Point-in-time recovery capability
- Multi-region deployment ready
- RTO: <1 hour, RPO: <15 minutes
