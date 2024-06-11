-- Database dumping script
-- Author : Kwonwoo Lyu
-- Modified At : June 9, 2024
-- DB name : test_nav

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
    img_url text NOT NULL,
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
    official_code varchar(255) NULL,
    name varchar(255) NULL,
    alias varchar(255) NULL,
    max_floor int4 NULL,
    longitude float8 NULL,
    latitude float8 NULL,
    floor int4 NULL,
    description text NULL,
    room_number varchar(255) NULL,
    fk__contributions__users varchar(255) NOT NULL,
    fk__contributions__buildings varchar(255) NULL,
    fk__contributions__location_categories varchar(255) NULL
);

CREATE TABLE IF NOT EXISTS users (
    user_uuid varchar(255) PRIMARY KEY,
    user_id varchar(255) NOT NULL UNIQUE,
    user_name varchar(255) NOT NULL,
    user_password text NOT NULL,
    is_proven_user boolean NOT NULL,
    user_email varchar(255) NULL UNIQUE,
    user_status varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS prove_trials (
    trial_id varchar(255) PRIMARY KEY,
    created_at timestamptz NOT NULL,
    verify_code varchar(255) NOT NULL,
    proved_at timestamptz NULL,
    fk__prove_trials__users varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS email_schedules (
    schedule_id varchar(255) PRIMARY KEY,
    content text NOT NULL,
    send_trial_count int4 NOT NULL,
    email_addr varchar(255) NOT NULL,
    is_success boolean NOT NULL,
    fk__email_schedules__prove_trials varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS admins (
    admin_uuid varchar(255) PRIMARY KEY,
    admin_id varchar(255) NOT NULL UNIQUE,
    admin_name varchar(255) NOT NULL,
    admin_password text NOT NULL
);

CREATE TABLE IF NOT EXISTS user_saves (
    mapping_id varchar(255) PRIMARY KEY,
    fk__user_saves__users varchar(255) NOT NULL,
    fk__user_saves__buildings varchar(255) NULL,
    fk__user_saves__locations varchar(255) NULL
);

ALTER TABLE user_saves
ADD CONSTRAINT fk__user_saves__users FOREIGN KEY (fk__user_saves__users) REFERENCES "users"(user_uuid),
    ADD CONSTRAINT fk__user_saves__buildings FOREIGN KEY (fk__user_saves__buildings) REFERENCES "buildings"(building_id),
    ADD CONSTRAINT fk__user_saves__locations FOREIGN KEY (fk__user_saves__locations) REFERENCES "locations"(location_id);

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
    ADD CONSTRAINT fk__contributions__users FOREIGN KEY (fk__contributions__users) REFERENCES "users"(user_uuid),
    ADD CONSTRAINT fk__contributions__buildings FOREIGN KEY (fk__contributions__buildings) REFERENCES "buildings"(building_id),
    ADD CONSTRAINT fk__contributions__location_categories FOREIGN KEY (fk__contributions__location_categories) REFERENCES "location_categories"(category_id);


-- Default data

INSERT INTO location_categories(category_id, category_name, description) VALUES
    ('2f5d8135-cefc-4d68-bde5-2ae78a9ba65c', 'Restaurants', 'fixed category'),
    ('bffe8471-31b0-4695-9907-7bf77f0069f8', 'Convenience Stores', 'fixed category'),
    ('a8a67e35-b956-4f4b-a00d-215ed958834a', 'Cafes', 'fixed category'),
    ('b06781df-1703-4fd1-81c7-3ae8ffe97016', 'Gyms', 'fixed category'),
    ('8916ab2a-224d-41d9-89be-84b1af520fef', 'Dormitories', 'fixed category'),
    ('ff12c671-38e2-4681-bd8d-d3f6226963c3', 'Lecture Room', 'fixed category'),
    ('0969b176-d2f7-4e18-93d1-1f977222c965', 'Coworking Space', 'fixed category');

INSERT INTO users(user_uuid, user_id, user_name, user_password, is_proven_user, user_email, user_status) VALUES
    ('1ccc2669-d428-472b-904a-2b5b27ba5829', 'testuser0000', 'test user', 'f40801e575e14bb373dbcc83dde8f12768958b05b1b677152badba106ed95753', false, 'rnjsdn1003@kaist.ac.kr', 'ACTIVE');

INSERT INTO admins(admin_uuid, admin_id, admin_name, admin_password) VALUES
    ('2e52c78c-be28-491f-9c84-3762e0f18a89', 'testadmin0000', 'test admin', 'f40801e575e14bb373dbcc83dde8f12768958b05b1b677152badba106ed95753');

INSERT INTO buildings(building_id, official_code, building_name, building_alias, description, max_floor, longitude, latitude) VALUES
    ('ff1da781-9407-4432-b3ae-d05e4cacb61d', 'E11', 'Creative Learning Center', 'CLC', 'This is a main lecture building.', 5, 127.36257397095076, 36.370438849852086),
    ('5a6dcd36-4799-48ea-b68d-73b3bd3069af', 'E3-1', 'School of Computing', 'SoC', 'This is a main building of CS.', 3, 127.36462043585567, 36.36841174214053);

INSERT INTO locations(location_id, location_name, location_floor, description, room_number, fk__locations__buildings, fk__locations__location_categories) VALUES
    ('b554e3ca-3c26-461f-a2f0-06eed16b22dd', 'Cafe Pascucci', 1, 'Cafe for students in CS and EE', null, '5a6dcd36-4799-48ea-b68d-73b3bd3069af', 'a8a67e35-b956-4f4b-a00d-215ed958834a'),
    ('08aa5175-45e0-4df0-88f7-7cba1efc67ef', 'Baseball Practice Room', 1, 'Baseball practice room for CS', null, '5a6dcd36-4799-48ea-b68d-73b3bd3069af', 'b06781df-1703-4fd1-81c7-3ae8ffe97016'),
    ('158f7444-6a86-466b-9a00-7897e802d162', 'Terman Hall', 1, 'Big lecture room', '103', 'ff1da781-9407-4432-b3ae-d05e4cacb61d', 'ff12c671-38e2-4681-bd8d-d3f6226963c3');

INSERT INTO images(id, img_url, fk__images__buildings, fk__images__locations) VALUES
    ('7bea0cf1-bc6f-41e1-a74b-90512bebc3ad', 'https://i.namu.wiki/i/Ip-VMOKup2nhrsFZdIAwCTPjFcaUY3kkKqByAcpn6wAWCxo3ItFx6HTszcehJsFcDf1MthyxbFHor7xcjgOctQ.webp', 'ff1da781-9407-4432-b3ae-d05e4cacb61d', null),
    ('db81a613-1cb1-49b4-b224-901f93ceed73', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeIMSNj61fOCrCt9sR2rZj_lxOzll92598BQ&s', 'ff1da781-9407-4432-b3ae-d05e4cacb61d', null),
    ('dae3fd62-6481-44d6-8d90-7c8bf152d511', 'https://img.seoul.co.kr/img/upload/2013/01/28/SSI_20130128171143_O2.jpg', 'ff1da781-9407-4432-b3ae-d05e4cacb61d', null),
    ('9cc4f4bb-d9fe-41cc-9199-676942be78ce', 'https://fastly.4sqi.net/img/general/600x600/83962747_ulFTnNf8H0iUiGpJEA2vxf6NoMngfPkNi9WrGWoMVcc.jpg', '5a6dcd36-4799-48ea-b68d-73b3bd3069af', null),
    ('52b3cb1d-4126-4c2b-abd9-607939057bb2', 'https://cs.kaist.ac.kr/upload_files/mcontent/50/202108/610c7d326020c.jpg', '5a6dcd36-4799-48ea-b68d-73b3bd3069af', null),
    ('528ae7fa-e295-49e9-9317-424adaa2bcaa', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvwELO91nmj-QrUQgGq62wgcxv6GBh0ZFtPg&s', null, 'b554e3ca-3c26-461f-a2f0-06eed16b22dd'),
    ('b217f534-a69d-41b6-b945-d11319f16611', 'https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzA5MjJfMTYg%2FMDAxNjk1Mzg3ODQ1MzEx.DUu9-SVmtEI3ZPwPy7ksDEsic2thXtQBVC_lETuq6Scg.NjqwQrXNmFEzyag1oOVThYAO5q4aLTND8_mkEHzB6Pwg.JPEG.freedommath%2FIMG_1403.JPG', null, 'b554e3ca-3c26-461f-a2f0-06eed16b22dd'),
    ('60b9340c-b4f3-41b1-acf9-93ad614d7d3a', 'https://search.pstatic.net/common/?src=https%3A%2F%2Fpup-review-phinf.pstatic.net%2FMjAyNDAyMDJfNjMg%2FMDAxNzA2ODM1OTM1MjUz.e_SO4vEtdHSAWY7-hopY714pmwuTuCFMa_wA4jYicqYg.xJl_EB-eLRtu90HvpLDIzQleBPLfGfonOhmuwsie0_Yg.JPEG%2F20240202_092601.jpg.jpg%3Ftype%3Dw1500_60_sharpen', null, 'b554e3ca-3c26-461f-a2f0-06eed16b22dd'),
    ('84ae05aa-cbff-4462-8ecb-966f257629d4', 'https://times.kaist.ac.kr/news/photo/201210/1820_1328_3616.jpg', null, '158f7444-6a86-466b-9a00-7897e802d162'),
    ('147ab696-f2d2-451e-81d4-a992cf8a4eed', 'https://cphoto.asiae.co.kr/listimglink/1/2011101316141524909_3.jpg', null, '158f7444-6a86-466b-9a00-7897e802d162'),
    ('91eff858-eb83-4d12-a7e0-4248cad294fc', 'https://www.kaist.ac.kr/Upload/news/newsmst/20200828173707_00alaepkuzgiok5ybgfgdnkhog68re.jpg', null, '158f7444-6a86-466b-9a00-7897e802d162');