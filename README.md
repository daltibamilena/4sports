# 4sports

## Instalation
We are using docker, so you`ll need docker and docker-compose.

After clonning the repository, run

``` docker-compose build ```

So after all you can run:
``` docker-compose up -d```

Then you`ll need to create database:
``` docker-compose run web rails db:create ```

Run the migrations: 
``` docker-compose run web rails db:migrate ```

Run seeds (important to generate user with admin role):
``` docker-compose run web rails db:seed ```

By default the application is running on port :3000

Admin default login:

```email: admin@example.com  password: 123456```

## Tests

To run tests: 
``` docker -compose run web bundle exec rspec spec ``` 
