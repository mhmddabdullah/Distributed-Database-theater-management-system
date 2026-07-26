Theater Management System — Database Design & Implementation

A full relational database design and implementation for a multi-branch theater (cinema) management system, covering movie scheduling, seat/booking management, payments, staff, snacks, and customer feedback — implemented across both SQL Server and Oracle.

Overview:
The system models a multi-theater cinema chain: each theater has multiple halls, each hall has individually typed seats, movies are scheduled into shows, customers book seats and pay for them, staff are assigned roles, and theaters track snack inventory and maintenance requests. The project has two implementation tracks:

SQL Server: normalized relational schema with a replication demonstration (publisher/subscriber setup, snapshot replication) simulating a multi-branch (MAIN / REMOTE) theater chain sharing data.
Oracle (PL/SQL): an object-relational database (ORDB) implementation using Oracle object types with inheritance (e.g. person_type → customer_type / employee_type → manager_type, cashier_type, technician_type, janitor_type), plus cursors, stored procedures, and functions for booking and payment logic.
Schema Design

The schema covers 14+ entities:
Theater / Hall / Seat — physical structure: theater branches, screening halls, individually typed/priced seats
Movie / Show — film catalog and scheduled screenings per hall
Customer / Booking / Booking_Seat / Payment — the booking pipeline, with Booking_Seat as a junction table handling the many-to-many relationship between bookings and seats
Employee / Role / User_Account — staff, role-based permissions, and system login accounts
Distributor / Movie_Distributor — many-to-many movie distribution relationships
Feedback — customer ratings and comments
Maintenance_Request — facility/equipment issue tracking, assigned to employees
Snack / Snack_Order / Snack_Order_Item — theater concessions inventory and itemized order tracking
SQL Server: Replication Demo

Simulates a two-branch theater chain (MAIN — Cairo Grand Cinema, REMOTE — Alex Sea View Cinema) using SQL Server replication: registered servers, publication/subscription setup, and snapshot replication, so that branch-level data (theaters, halls, customers) stays synchronized across the simulated distributed system.

Oracle: Object-Relational Implementation
Type hierarchy with inheritance: person_type as a base object type, extended by customer_type and employee_type, with employee_type further specialized into manager_type, cashier_type, technician_type, and janitor_type — modeling role-specific attributes (e.g. OfficeNumber for managers, RegisterNum for cashiers) through Oracle's UNDER inheritance syntax.
Cursors: explicit cursors for iterating bookings and seat assignments (c_booking, c_seat)
Procedures: proc_create_booking, proc_add_seat_to_booking, proc_recalc_booking_total, proc_record_payment
Functions: fn_booking_total, fn_customer_level, fn_hall_seat_count, fn_is_vip_show, fn_paid_amount
Packages: booking operations grouped into a package exposing create_booking, add_seat, recalc_total, and booking_total as a unified interface
Tech Stack

SQL Server (T-SQL, replication), Oracle Database (PL/SQL, object types, cursors, procedures, functions, packages)

How to Run:
--------------------------------------------------------------------
SQL Server:
Run sql-server/schema.sql to create the database and tables
Run the branch data scripts to populate sample data
Run sql-server/queries.sql to verify the setup

Oracle:
Run oracle/theater_plsql.sql in SQL*Plus or SQL Developer to create the object types, tables, cursors, procedures, and functions
Use the included procedures (e.g. proc_create_booking) to exercise the booking workflow


