-- Creates user for the application and set the default schema:

create user ${app_user} password '${app_pass}';

alter role ${app_user} set search_path = ${flyway:defaultSchema};
