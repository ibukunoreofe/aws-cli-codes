-- At this stage, these tables should not exist:
drop table if exists session_auth;
drop table if exists session_jwt;

--

create table session_jwt (
  id           varchar(100),
  client_ip    varchar(50)  not null,
  client_agent varchar(200),
  access_token text         not null,
  issued_by    varchar(100) not null,
  token_id     varchar(100) not null,
  username     varchar(100) not null,
  full_name    varchar(50)  not null,
  given_name   varchar(20)  not null,
  family_name  varchar(20)  not null,
  email        varchar(50),
  locale       varchar(2)   not null,
  created_at   timestamptz  not null default current_timestamp,
  expires_at   timestamptz  not null,
  permissions  jsonb,
  constraint session_jwt_pk primary key (id)
);

comment on table session_jwt is 'Active and past JWT-based user-sessions';
comment on column session_jwt.id is 'The generated session identifier';
comment on column session_jwt.client_ip is 'The IP-address (v4 or v6) of the client';
comment on column session_jwt.client_agent is 'The User-Agent of the client';
comment on column session_jwt.access_token is 'The original access-token as JWT (encoded)';
comment on column session_jwt.token_id is 'The ID value extracted from the JWT';
comment on column session_jwt.username is 'The username value extracted from the JWT';
comment on column session_jwt.full_name is 'The full-name value extracted from the JWT';
comment on column session_jwt.given_name is 'The given-name value extracted from the JWT';
comment on column session_jwt.family_name is 'The family-name value extracted from the JWT';
comment on column session_jwt.email is 'The email value extracted from the JWT';
comment on column session_jwt.locale is 'The 2-letter locale value extracted from the JWT (defaults to "et")';
comment on column session_jwt.created_at is 'The timestamp when this row was added';
comment on column session_jwt.expires_at is 'The timestamp when this session expires (updatable by the application)';
comment on column session_jwt.permissions is 'Permissions information encoded in JSON format (updatable by the application)';

--

create table session_auth (
  id             varchar(20),
  client_ip      varchar(50)  not null,
  client_agent   varchar(200),
  auth_state     varchar(50)  not null,
  continue_to    varchar(100) not null,
  created_at     timestamptz  not null default current_timestamp,
  session_jwt_id varchar(100),
  error_info     text,
  constraint session_auth_pk primary key (id),
  constraint session_auth_fk_session_jwt
    foreign key (session_jwt_id) references session_jwt
);

comment on table session_auth is 'Temporary authentication cookie information';
comment on column session_auth.id is 'The generated cookie value';
comment on column session_auth.client_ip is 'The IP-address (v4 or v6) of the client';
comment on column session_auth.client_agent is 'The User-Agent of the client';
comment on column session_auth.auth_state is 'The generated "state" parameter value';
comment on column session_auth.continue_to is 'The resolved continue-to address (absolute path)';
comment on column session_auth.created_at is 'The timestamp when this row was added';
comment on column session_auth.session_jwt_id is 'The issued JWT if login is completed successfully';
comment on column session_auth.error_info is 'Authentication error reported by the application';
