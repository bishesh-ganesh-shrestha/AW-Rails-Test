# Angelswing Rails Assessment

A REST API built with Ruby on Rails for the Angelswing backend assessment.

## Tech Stack

- Ruby 3.4.9
- Rails 8.1.3
- PostgreSQL
- JWT Authentication (without Devise)
- RSpec for testing
- Docker

## API Documentation

Duplicated Postman Collection: https://documenter.getpostman.com/view/32115070/2sBXiqDTaG

## Setup and Installation

### Local Development

1. Clone the repository
```bash
   git clone https://github.com/bishesh-ganesh-shrestha/AW-Rails-Test.git
   cd AW-Rails-Test
```

2. Install dependencies
```bashhttps://github.com/bishesh-ganesh-shrestha/AW-Rails-Test.git
   bundle install
```

3. Setup database
```bash
   rails db:create db:migrate
```

4. Start the server
```bash
   rails s
```

5. API is available at `http://localhost:3000/api/v1`

### Docker Setup

1. Clone the repository
```bash
   git clone https://github.com/bishesh-ganesh-shrestha/AW-Rails-Test.git
   cd AW-Rails-Test
```

2. Setup environment variables
```bash
   cp .env.example .env
```

3. Build and run with Docker
```bash
   docker-compose up --build
```

4. Run migrations in a separate terminal
```bash
   docker-compose exec web rails db:create db:migrate
```

5. API is available at `http://localhost:3000/api/v1`

## Running Tests
```bash
bundle exec rspec
```

## API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/v1/users/signup` | ❌ | Register a new user |
| POST | `/api/v1/auth/signin` | ❌ | Sign in and get JWT token |
| GET | `/api/v1/content` | ❌ | Get all contents |
| POST | `/api/v1/contents` | ✅ | Create a content |
| PUT | `/api/v1/contents/:id` | ✅ | Update a content (owner only) |
| DELETE | `/api/v1/contents/:id` | ✅ | Delete a content (owner only) |

## Notes

- Request parameters must be in camelCase as per API specification
- Only the owner of a content can update or delete it
- Other authenticated users can only view contents
- JWT token expires in 24 hours
- The GET /content endpoint uses singular "content" as per the API specification
- Sign-up returns no response body on validation errors as per the API specification
