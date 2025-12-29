# Mangalore School MS - Functional Documentation

**Version:** 1.0.0  
**Last Updated:** December 29, 2025

---

## Table of Contents
1. [Overview](#overview)
2. [User Roles](#user-roles)
3. [Authentication](#authentication)
4. [Dashboard](#dashboard)
5. [Student Management](#student-management)
6. [Teacher Management](#teacher-management)
7. [Parent Management](#parent-management)
8. [Class Management](#class-management)
9. [Section Management](#section-management)
10. [Subject Management](#subject-management)
11. [Fees Management](#fees-management)
12. [Timetable](#timetable)
13. [Notifications](#notifications)
14. [Profile Settings](#profile-settings)

---

## Overview

**Mangalore School MS** is a mobile application for school management. It provides role-based access for administrators, teachers, students, and parents to manage various aspects of school operations.

---

## User Roles

| Role | Description |
|------|-------------|
| **SUPER_ADMIN** | Full system access across all schools |
| **ADMIN** | School-level administrative access |
| **TEACHER** | Teaching, student management, and grading access |
| **STUDENT** | View own records, fees, timetable |
| **PARENT** | View children's records, fees, notifications |

---

## Authentication

### Login
- Email and password authentication
- "Remember Me" option for persistent login
- FCM device token registration for push notifications
- Role-based routing to appropriate dashboard

### Logout
- Unregisters device from push notifications
- Clears all stored credentials
- Redirects to login screen

---

## Dashboard

Role-specific dashboards display relevant information:

### Admin Dashboard
- **Total Students** count
- **Total Teachers** count
- **Active Classes** count
- **Monthly Revenue** summary
- **Weekly Attendance** overview
- **Financial Overview** (pending fees, collections)
- **Grade Distribution** charts

### Teacher Dashboard
- Class statistics
- Student overview
- Quick actions

### Student Dashboard
- Personal information
- Quick access to fees and timetable

### Parent Dashboard
- Children overview
- Quick access to notifications

---

## Student Management

### Student List
**Access:** SUPER_ADMIN, ADMIN, TEACHER

- View all students in the school
- Search by name
- Filter by class/section
- Navigate to student details

### Student Details
- Personal information (name, email, phone)
- Class and section assignment
- Parent information
- Fees overview

### Create/Edit Student
**Access:** SUPER_ADMIN, ADMIN

Fields:
- First Name, Middle Name, Last Name
- Email, Password (for new students)
- Phone, Address
- Class and Section selection
- Parent selection (from existing parents)

---

## Teacher Management

### Teacher List
**Access:** SUPER_ADMIN, ADMIN

- View all teachers
- Search by name
- Navigate to teacher details

### Teacher Details
- Personal information
- Assigned subjects
- Class assignments

### Create/Edit Teacher
**Access:** SUPER_ADMIN, ADMIN

Fields:
- First Name, Middle Name, Last Name
- Email, Password (for new teachers)
- Phone, Address

---

## Parent Management

### Parent List
**Access:** SUPER_ADMIN, ADMIN, TEACHER

- View all parents
- Search by name
- Navigate to parent details

### Parent Details
- Personal information
- WhatsApp settings
- Associated children list

### Create/Edit Parent
**Access:** SUPER_ADMIN, ADMIN

Fields:
- First Name, Middle Name, Last Name
- Email, Password (for new parents)
- Phone, Address
- WhatsApp Number
- WhatsApp Opt-in toggle

---

## Class Management

### Class List
**Access:** SUPER_ADMIN, ADMIN, TEACHER

- View all classes
- Navigate to class details

### Class Details
- Class name and code
- Sections in this class
- Students enrolled

### Create/Edit Class
**Access:** SUPER_ADMIN, ADMIN

Fields:
- Class Name
- Class Code
- School selection

---

## Section Management

### Section List
**Access:** SUPER_ADMIN, ADMIN, TEACHER

- View all sections
- Navigate to section details

### Section Details
- Section name
- Associated classes
- Students in section

### Create/Edit Section
**Access:** SUPER_ADMIN, ADMIN

Fields:
- Section Name
- Class selection (multiple classes supported)

---

## Subject Management

### Subject List
**Access:** SUPER_ADMIN, ADMIN, TEACHER

- View all subjects
- Navigate to subject details

### Subject Details
- Subject name and code

### Create/Edit Subject
**Access:** SUPER_ADMIN, ADMIN

Fields:
- Subject Name
- Subject Code

---

## Fees Management

### Fees Overview
**Access:** SUPER_ADMIN, ADMIN, STUDENT, PARENT

- View fee invoices
- Filter by status (Paid, Pending, Overdue)
- Payment history

### Fee Details
- Invoice breakdown
- Payment schedule
- Payment history
- Outstanding balance

**Payment Modes:** CASH, ONLINE, CHEQUE

---

## Timetable

**Access:** All roles

### Features
- **Day tabs** (Monday - Saturday)
- **Period-wise slots** showing:
  - Subject name
  - Time range
  - Teacher name
  - Class/Section

### Role-based views
- **Teachers:** See their teaching schedule
- **Students:** See their class schedule
- **Admins:** See all schedules

---

## Notifications

**Access:** PARENT

### Features
- **Notification list** with unread/read status
- **Pull-to-refresh**
- **Mark as read** on tap
- **Mark all as read** button
- **Type-based icons** (Attendance, Fees, Exams, Messages)
- **Pagination** with load more

### Notification Types
- Attendance updates
- Fee reminders
- Exam announcements
- General messages

---

## Profile Settings

**Access:** All roles

### View Information (Read-only)
- First Name
- Middle Name
- Last Name
- Email
- Role

### Editable Fields
- Phone
- Address

### Parent-only Fields
- WhatsApp Number
- WhatsApp Notifications toggle (opt-in/opt-out)

---

## Navigation

### Drawer Menu
All screens are accessible via the side drawer menu. Menu items are filtered based on user role.

| Menu Item | Roles |
|-----------|-------|
| Dashboard | All |
| My Children | PARENT |
| My Classes | ADMIN, TEACHER |
| Students | ADMIN, TEACHER |
| Parents | ADMIN, TEACHER |
| Teachers | ADMIN |
| Subjects | ADMIN, TEACHER |
| Classes | ADMIN, TEACHER |
| Sections | ADMIN, TEACHER |
| Fees | ADMIN, STUDENT, PARENT |
| Timetable | All |
| Notifications | PARENT |
| Settings | All |
| Sign Out | All |

---

## Push Notifications

### Device Registration
- Automatically registered on login
- FCM token stored and sent to backend
- Platform detection (iOS/Android)

### Unregistration
- Automatically unregistered on logout
- Token removed from backend

---

## Technical Features

### Security
- JWT-based authentication
- Secure token storage
- Automatic token refresh
- RBAC (Role-Based Access Control)

### Offline Support
- Secure local storage for credentials
- Network error handling with retry

### UI/UX
- Material Design 3
- Animations with flutter_animate
- Pull-to-refresh on list screens
- Search and filter capabilities
- Loading states and empty states

---

**End of Documentation**
