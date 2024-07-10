# Laravel E-commerce Server

This is a Laravel-based e-commerce project designed to demonstrate the backend of our e-commerce application.

## Introduction

the e-commerce server provides apis to be used by the mobile application for data manipulation.

## Features

- Authentication

- post, put, delete, get products

- get reviews for certain product, post review for a product from verified buyer.

- post order, put orders, get user order, get order request.

- get orders history.

- input validation

## Installation

### Prerequisites

- PHP>=7.0

- Composer

- MySql

### Steps

1. Install PHP dependencies:
```
composer
```
2. Migrate the database:
```
php artisan migrate:refresh
```
3. Run the server:
```
php artisan serve
```

### Postman Collection

To make API testing easier, a Postman collection is provided.

1. Download the Postman collection JSON file from [here](./apd.postman_collection.json).
2. Open Postman.
3. Click on Import in the top left corner.
4. Select the downloaded JSON file and import it.

The collection includes pre-configured requests for all API endpoints of this project.

## Database

### Entities and Relationships

1. Users

- id (Primary Key)
- name
- email
- password
- credit_card_number
- credit_card_pass
- created_at
- updated_at

2. Personal Access Tokens

- id (Primary Key)
- tokenable_type
- tokenable_id
- name
- token
- abilities
- last_used_at
- created_at
- updated_at

Relationship: tokenable_type and tokenable_id form a polymorphic relationship with other tables.

3. Products

- id (Primary Key)
- user_id (Foreign Key referencing users.id)
- title
- description
- image
- price
- count
- created_at
- updated_at

4. Reviews

- id (Primary Key)
- user_id (Foreign Key referencing users.id)
- product_id (Foreign Key referencing products.id)
- comment
- created_at
- updated_at

5. Orders

- id (Primary Key)
- user_id (Foreign Key referencing users.id)
- product_id (Foreign Key referencing products.id)
- number
- product_name

6. feedback

- total
- status
- created_at
- updated_at


### ER Diagram Description

- Users Table is the central entity.

- Products Table has a one-to-many relationship with Users (a user can have many products).

- Reviews Table has many-to-one relationships with both Users and Products (a user can review many products and a product can have many reviews).

- Orders Table has many-to-one relationships with both Users and Products (a user can place many orders and a product can appear in many orders).

- Personal Access Tokens Table uses a polymorphic relationship (tokenable_type and tokenable_id) to link to other tables dynamically.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request.
