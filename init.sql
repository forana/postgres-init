\echo -------------------------------
\echo | Clearing out any old tables
\echo -------------------------------

drop table if exists assignment_grades;
drop table if exists assignments;
drop table if exists section_students;
drop table if exists sections;
drop table if exists classes;
drop table if exists professors;
drop table if exists students;

\echo -------------------------------
\echo | Creating tables
\echo -------------------------------

-- A student has a unique numeric ID, first name, last name, and age.
create table students (
    id         int primary key,
    first_name text,
    last_name  text,
    age        int
);

-- A professor has a unique numeric ID, first name, and last name.
-- It's impolite to ask how old they are, after all.
create table professors (
    id         int primary key,
    first_name text,
    last_name  text
);

-- A class has a unique code (like 'CS-101') and a name.
create table classes (
    code text primary key,
    name text
);

-- A section has a unique numeric id, a class code (the class that's
-- being taught in this section), and a professor.
create table sections (
    id        int primary key,
    class     text references classes(code),
    professor int references professors(id)
);

-- A section has students signed up for it.
create table section_students (
    section int references sections(id),
    student int references students(id)
);

-- A section has assignments, which have a numeric id, name, and and
-- decimal point value (maxiumum possible).
create table assignments (
    id      int primary key,
    name    text,
    points  decimal
);

-- An assignment has a different grade for each student, represented
-- by the number of points earned.
create table assignment_grades (
    student    int references students(id),
    assignment int references assignments(id),
    points     decimal
);

\echo -------------------------------
\echo | Inserting data
\echo -------------------------------

insert into students (id, first_name, last_name, age) values
    (1,  'John', 'Smith', 10),
    (2,  'Harry', 'Potter', 11),
    (3,  'Ronald', 'Weasley', 11),
    (4,  'Hermione', 'Granger', 11),
    (5,  'Neville', 'Longbottom', 11),
    (6,  'Tom', 'Riddle', 12),
    (7,  'Linus', 'Torvalds', 17),
    (8,  'Tom', 'Anderson', 16),
    (9,  'Mark', 'Zuckerberg', 16),
    (10, 'Arthur', 'Read', 10),
    (11, 'Steven', 'Universe', 14),
    (12, 'Gary', 'Oak', 12),
    (13, 'Bilbo', 'Baggins', 111),
    (14, 'Frodo', 'Baggins', 34),
    (15, 'Tom', 'Underhill', 34),
    (16, 'Harold', 'Cat', 8),
    (17, 'Chevy', 'Cat', 8),
    (18, 'Tater', 'Tot', 4),
    (19, 'Microsoft', 'Bob', 23),
    (20, 'Bob', 'Burger', 35);

insert into professors (id, first_name, last_name) values
    (1, 'Severus', 'Snape'),
    (2, 'William', 'Gates'),
    (3, 'Pink', 'Pearl'),
    (4, 'Grant', 'Kirkhope');

insert into classes (code, name) values
    ('CH-104', 'Intro to Potions'),
    ('CH-105', 'Intro to Herbal Remedies'),
    ('CS-201', 'Data Structures'),
    ('CS-202', 'Advanced Red-Black Trees'),
    ('AN-101', 'Not Pooping in the House'),
    ('HU-108', 'Public Speaking'),
    ('HU-109', 'How to Apologize'),
    ('CS-384', 'Squarewave Composition'),
    ('LS-301', 'Native Wildlife Cataloging and Photography'),
    ('AR-107', 'Intro to Videography'),
    ('HW-357', 'Fencing'),
    ('HU-102', 'Composition');

insert into sections (id, class, professor) values
    (1,  'CH-104', 1),
    (2,  'CH-105', 1),
    (3,  'CS-201', 2),
    (4,  'CS-201', 3),
    (5,  'CS-202', 2),
    (6,  'AN-101', 3),
    (7,  'HU-109', 3),
    (8,  'HU-109', 1),
    (9,  'HU-109', 2),
    (10, 'CS-384', 4),
    (11, 'LS-301', 3),
    (12, 'AR-107', 2),
    (13, 'HW-357', 3),
    (14, 'HU-102', 1),
    (15, 'HU-102', 2);

insert into section_students (section, student) values
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 13),
    (2, 14),
    (2, 15),
    (2, 20),
    (3, 8),
    (3, 9),
    (3, 7),
    (3, 19),
    (4, 4),
    (6, 7),
    (6, 16),
    (6, 17),
    (6, 18),
    (7, 18),
    (7, 20),
    (8, 7),
    (8, 19),
    (10, 12),
    (10, 19),
    (11, 11),
    (11, 12),
    (11, 14),
    (11, 15),
    (11, 16),
    (12, 10),
    (12, 11),
    (12, 12),
    (12, 20),
    (13, 5),
    (13, 11),
    (13, 20), -- this could be an episode, I swear
    (14, 4),
    (14, 10),
    (14, 12),
    (14, 13),
    (15, 7);

\echo -------------------------------
\echo | All done!
\echo -------------------------------