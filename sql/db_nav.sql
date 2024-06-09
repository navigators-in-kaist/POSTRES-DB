-- Database dumping script
-- Author : Kwonwoo Lyu
-- Modified At : June 9, 2024

CREATE TABLE IF NOT EXISTS buildings (
    building_id varchar(255) PRIMARY KEY,
    official_code varchar(255) NOT NULl UNIQUE,
    building_name varchar(255) NOT NULL,
    building_alias varchar(255) NULL,
    description text NOT NULL,
    max_floor int4 NOT NULL,
    longitude float8 NOT NULL,
    latitude float8 NOT NULL
);

CREATE TABLE IF NOT EXISTS locations (
    location_id varchar(255) PRIMARY KEY,
    location_name varchar(255) NOT NULL,
    location_floor int4 NOT NULL,
    description text NOT NULL,
    room_number varchar(255) NULL,
    fk__locations__buildings varchar(255) NOT NULL,
    fk__locations__location_categories varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS location_categories (
    category_id varchar(255) PRIMARY KEY,
    category_name varchar(255) NOT NULL,
    description text NOT NULL
);

CREATE TABLE IF NOT EXISTS images (
    id varchar(255) PRIMARY KEY,
    img_url varchar(255) NOT NULL,
    fk__images__buildings varchar(255) NULL,
    fk__images__locations varchar(255) NULL
);

CREATE TABLE IF NOT EXISTS search_histories (
    history_id varchar(255) NOT NULL,
    created_at timestamptz NOT NULL,
    fk__search_histories__buildings varchar(255) NULL,
    fk__search_histories__locations varchar(255) NULL,
    fk__search_histories__users varchar(255) NOT NULl
);

CREATE TABLE IF NOT EXISTS contributions (
    contribution_id varchar(255) PRIMARY KEY,
    contribution_type varchar(255) NOT NULL,
    contribution_status varchar(255) NOT NULL,
    created_at timestamptz NOT NULL,
    approved_at timestamptz NULL,
    fk__contributions__users varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    user_uuid varchar(255) PRIMARY KEY,
    user_id varchar(255) NOT NULL UNIQUE,
    user_password text NOT NULL,
    is_proven_user boolean NOT NULL,
    user_email varchar(255) NOT NULL,
    user_status varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS prove_trials (
    trial_id varchar(255) PRIMARY KEY,
    created_at timestamptz NOT NULL,
    verify_code varchar(255) NOT NULL,
    proved_at timestamptz NOT NULL,
    fk__prove_trials__users varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS email_schedules (
    schedule_id varchar(255) PRIMARY KEY,
    content text NOT NULL,
    send_trial_count int4 NOT NULL,
    is_success boolean NOT NULL,
    fk__email_schedules__prove_trials varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS admins (
    admin_uuid varchar(255) PRIMARY KEY,
    admin_id varchar(255) NOT NULL UNIQUE,
    admin_name varchar(255) NOT NULL,
    admin_password text NOT NULL
);

ALTER TABLE email_schedules
    ADD CONSTRAINT fk__email_schedules__prove_trials FOREIGN KEY (fk__email_schedules__prove_trials) REFERENCES "prove_trials"(trial_id);

ALTER TABLE prove_trials
    ADD CONSTRAINT fk__prove_trials__users FOREIGN KEY (fk__prove_trials__users) REFERENCES "users"(user_uuid);

ALTER TABLE locations
    ADD CONSTRAINT fk__locations__buildings FOREIGN KEY (fk__locations__buildings) REFERENCES "buildings"(building_id),
    ADD CONSTRAINT fk__locations__location_categories FOREIGN KEY (fk__locations__location_categories) REFERENCES "location_categories"(category_id);

ALTER TABLE images
    ADD CONSTRAINT fk__images__buildings FOREIGN KEY (fk__images__buildings) REFERENCES "buildings"(building_id),
    ADD CONSTRAINT fk__images__locations FOREIGN KEY (fk__images__locations) REFERENCES "locations"(location_id);

ALTER TABLE search_histories
    ADD CONSTRAINT fk__search_histories__buildings FOREIGN KEY (fk__search_histories__buildings) REFERENCES "buildings"(building_id),
    ADD CONSTRAINT fk__search_histories__locations FOREIGN KEY (fk__search_histories__locations) REFERENCES "locations"(location_id),
    ADD CONSTRAINT fk__search_histories__users FOREIGN KEY (fk__search_histories__users) REFERENCES "users"(user_uuid);

ALTER TABLE contributions
    ADD CONSTRAINT fk__contributions__users FOREIGN KEY (fk__contributions__users) REFERENCES "users"(user_uuid);

