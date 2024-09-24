-- Reset privileges first:
revoke all privileges
  on all tables in schema ${flyway:defaultSchema}
  from ${app_user};

revoke all privileges
  on all sequences in schema ${flyway:defaultSchema}
  from ${app_user};

-- Assign permissions to the role:
grant usage on schema ${flyway:defaultSchema} to ${app_user};

grant select, insert, update (expires_at, permissions)
  on session_jwt
  to ${app_user};

grant select, insert, update (session_jwt_id, error_info)
  on session_auth
  to ${app_user};

grant select, insert, update (name, name_en, description, description_en, clinical, sector, active, updated_at, updated_by)
  on organisation
  to ${app_user};

grant select, insert, update (email, description, description_en, permissions, since, until, active, updated_at, updated_by)
  on organisation_member
  to ${app_user};
