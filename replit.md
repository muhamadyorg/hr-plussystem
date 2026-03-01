# HR Management System

## Overview
Full-featured HR management and attendance tracking system with Hikvision camera integration and Telegram bot notifications. Backend is written in Go, frontend is React (Vite).

## Architecture
- **Backend**: Go (net/http) in `goserver/` package, entry point `main.go`
- **Frontend**: React + Vite + shadcn/ui in `client/` directory, built to `dist/public/`
- **Database**: PostgreSQL via `DATABASE_URL`
- **Session**: Cookie-based sessions stored in PostgreSQL `session` table

## Go Backend Files
- `main.go` - Entry point, server setup, static file serving
- `goserver/database.go` - DB connection, table creation
- `goserver/models.go` - All data models and request/response types
- `goserver/storage.go` - Database CRUD operations
- `goserver/routes.go` - HTTP handlers for all API endpoints
- `goserver/session.go` - Cookie session management
- `goserver/hikvision.go` - Hikvision camera integration (sync, test, events)
- `goserver/telegram.go` - Telegram bot (polling, notifications)
- `goserver/seed.go` - Seed data (sudo/admin users, groups, employees)

## Frontend Pages
- Login, Dashboard, Employees, Employee Detail, Groups, Attendance, Sudo Panel, Admin Settings

## Key Features
- Auth with bcrypt + PostgreSQL sessions
- Role-based access: sudo (full), admin (group-restricted)
- Employee & Group CRUD
- Attendance tracking (manual + Hikvision camera events)
- Hikvision camera sync (add/remove employees to camera)
- Telegram bot notifications (attendance alerts, stats commands)
- Uzbekistan timezone (UTC+5) for all time operations

## Build & Run
```
go build -buildvcs=false -o hr-server . && ./hr-server
```
Frontend must be pre-built: `npx vite build` outputs to `dist/public/`

## Default Credentials
- sudo / sudo123 (super admin)
- admin / admin123 (admin)

## Dependencies
- Go: golang.org/x/crypto, github.com/lib/pq
- Frontend: React, Vite, shadcn/ui, TanStack Query, wouter
