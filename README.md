# README

# Payroll App

A Ruby on Rails application to manage employee payroll, generate monthly payslips as PDFs, and send them via email. It supports two roles: **Admin** and **Employee** with secure authentication.

## Features

- Admin and Employee authentication using Devise
- Employee profile management
- Admin dashboard to view all employees and generate payslips
- Monthly PDF payslip generation using Prawn
- Email delivery of payslips using ActionMailer
- Background job processing with Sidekiq & Redis
- Secure role-based access control

## Tech Stack

- **Ruby on Rails** (v7+)
- **PostgreSQL** (default DB)
- **Devise** – for authentication
- **Prawn** – for PDF generation
- **Sidekiq** – for background job processing
- **Redis** – job queue backend
- **ActionMailer** – for sending emails


