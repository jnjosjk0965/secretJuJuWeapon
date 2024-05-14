DROP DATABASE IF EXISTS test2;
CREATE DATABASE test2;
USE test2;

CREATE TABLE LECTURENAME (
    lecture_code INT(7) NOT NULL,
    lecture_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(lecture_code)
);

CREATE TABLE CURRICULUM (
    curriculum_code INT NOT NULL,
    curriculum_name VARCHAR(20) UNIQUE NOT NULL,
    division VARCHAR(20) NOT NULL,
    department VARCHAR(20) NOT NULL,
    PRIMARY KEY(curriculum_code)
);

CREATE TABLE LECTURE (
    class_code CHAR(2) NOT NULL,
    lecture_code INT(7) NOT NULL,
    curriculum_code INT NOT NULL,
    room VARCHAR(7) NOT NULL,
    unit TINYINT NOT NULL,
    class_time TINYINT NOT NULL,
    pro_name VARCHAR(10) NULL,
    grade TINYINT NOT NULL,
    course_classification CHAR(2) NOT NULL,
    FOREIGN KEY (lecture_code) REFERENCES LECTURENAME(lecture_code),
    FOREIGN KEY (curriculum_code) REFERENCES CURRICULUM(curriculum_code),
    PRIMARY KEY(class_code, lecture_code)
);

CREATE TABLE LECTURE_INTRODUCTION (
    class_code CHAR(2) NOT NULL,
    lecture_code INT(7) NOT NULL,
    lecture_introduction VARCHAR(255) NOT NULL,
    FOREIGN KEY (class_code, lecture_code) REFERENCES LECTURE(class_code, lecture_code),
    PRIMARY KEY(class_code, lecture_code)
);

CREATE TABLE TEMPORARY_VERIFY (
    temp_email VARCHAR(50) NOT NULL,
    verify_code INT NOT NULL,
    send_time DATETIME NOT NULL,
    PRIMARY KEY(temp_email)
);

CREATE TABLE DOMAIN_LIST (
    college_code INT NOT NULL,
    college_name VARCHAR(255) NOT NULL,
    domain VARCHAR(20) NOT NULL,
    PRIMARY KEY(college_code)
);

CREATE TABLE PRIVACY (
    id INT NOT NULL,
    email VARCHAR(100) UNIQUE,
    sns_email VARCHAR(100) UNIQUE,
    college_code INT NOT NULL,
    grade TINYINT NOT NULL,
    user_point INT NOT NULL DEFAULT 0,
    signin_date DATETIME NOT NULL,
    last_date DATETIME NOT NULL,
    last_ip INT UNSIGNED NOT NULL,
    account_status BOOLEAN NOT NULL,
    FOREIGN KEY (college_code) REFERENCES DOMAIN_LIST(college_code),
    PRIMARY KEY(id)
);

CREATE TABLE VERIFY_LIST (
    email VARCHAR(50) NOT NULL,
    id INT NOT NULL,
    college_code INT NOT NULL,
    update_time DATETIME NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    FOREIGN KEY (college_code) REFERENCES DOMAIN_LIST(college_code),
    PRIMARY KEY(email)
);

CREATE TABLE LOGIN_TOKEN (
    token_id SERIAL NOT NULL,
    id INT NOT NULL,
    access_token VARCHAR(255) NOT NULL,
    refresh_token VARCHAR(255) NOT NULL,
    create_date DATETIME NOT NULL,
    expiration_date DATETIME NOT NULL,
    token_state BOOLEAN NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    PRIMARY KEY (token_id)
);

CREATE TABLE LECTURE_COMMENT (
    class_code VARCHAR(2) NOT NULL,
    lecture_code INT NOT NULL,
    id INT NOT NULL,
    lecture_comment VARCHAR(150) NOT NULL,
    last_update DATETIME NOT NULL,
    FOREIGN KEY (class_code, lecture_code) REFERENCES LECTURE(class_code, lecture_code),
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    PRIMARY KEY (class_code, lecture_code)
);

CREATE TABLE SCHEDULE_DATA (
    schedule_key BIGINT NOT NULL,
    id INT NOT NULL,
    src VARCHAR(255) NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    PRIMARY KEY(schedule_key)
);

CREATE TABLE FRIENDSHIP (
    id INT NOT NULL,
    friend_id INT NOT NULL,
    friendship_status TINYINT NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    FOREIGN KEY (friend_id) REFERENCES PRIVACY(id),
    PRIMARY KEY(id, friend_id)
);

CREATE TABLE POINT_DATA (
    id INT NOT NULL,
    point_amount INT NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    PRIMARY KEY(id)
);

CREATE TABLE PROMOTION (
    promo_key INT NOT NULL,
    id INT NOT NULL,
    img_src VARCHAR(255) NULL,
    hyperlink VARCHAR(255) NULL,
    write_time DATETIME NOT NULL,
    active_time DATETIME NOT NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    PRIMARY KEY (promo_key)
);

CREATE TABLE CATEGORY (
    category_code TINYINT NOT NULL,
    category_name VARCHAR(20) NOT NULL,
    PRIMARY KEY(category_code)
);

CREATE TABLE POST (
    post_key BIGINT UNSIGNED NOT NULL,
    id INT NOT NULL,
    category_code TINYINT NOT NULL,
    post_content TEXT NOT NULL,
    write_time DATETIME NOT NULL,
    update_time DATETIME NULL,
    like_count MEDIUMINT NOT NULL DEFAULT 0,
    attached_file VARCHAR(255) NULL,
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    FOREIGN KEY (category_code) REFERENCES CATEGORY(category_code),
    PRIMARY KEY (post_key)
);

CREATE TABLE COMMENT_DATA (
    comment_key BIGINT UNSIGNED NOT NULL,
    post_key BIGINT UNSIGNED NOT NULL,
    id INT NOT NULL,
    category_code TINYINT NOT NULL,
    write_time DATETIME NOT NULL,
    update_time DATETIME NULL,
    like_count MEDIUMINT NOT NULL DEFAULT 0,
    FOREIGN KEY (post_key) REFERENCES POST(post_key),
    FOREIGN KEY (id) REFERENCES PRIVACY(id),
    FOREIGN KEY (category_code) REFERENCES CATEGORY(category_code),
    PRIMARY KEY(comment_key)
);

CREATE TABLE CHAT (
    message_id BIGINT UNSIGNED NOT NULL,
    send_id INT NOT NULL,
    receive_id INT NOT NULL,
    send_time DATETIME NOT NULL,
    FOREIGN KEY (send_id) REFERENCES PRIVACY(id),
    FOREIGN KEY (receive_id) REFERENCES PRIVACY(id),
    PRIMARY KEY(message_id)
);

