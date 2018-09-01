# postgres-init

Sample PostgreSQL database + some example queries.

## Prereq - PostgreSQL Setup

### OSX

1. Install [Postgres.app](https://postgresapp.com/).
2. Set up a new server (using whatever version of postgres it defaults to).

### Everyone else

1. Follow instructions [here](https://www.postgresql.org/download/).

## Setting up samples

1. Clone this repo.
2. Open a terminal window to the clone location.
3. Run `psql`.
   
   (provide proper arguments for a database if your setup method didn't provide one. You may need to run `sudo -u postgres psql` on some systems instead).
4. In the psql prompt, type `\i init.sql`. You're all set! Find some queries below and play with them.

## Example queries

### List all students

```sql
select id, first_name, last_name, age from students;
```

(or, without specifying fields)

```sql
select * from students;
```

### List all students, sorting from youngest to oldest
```sql
select first_name, last_name, age from students order by age asc;
```

### List all students that are at least 10 years old, but less than 20
```sql
select first_name, last_name, age from students where age >= 10 and age <20;
```

### List all students that are over 10 years old in alphabetical order (by last name)
```sql
select last_name, first_name, age from students where age > 10 order by last_name asc;
```

### Look up a class by code
```sql
select name from classes where code = 'CH-104';
```

### Look up all classes with codes starting with "CH"
```sql
select code, name from classes where code like 'CH-%';
```

### Look up all CS and HU classes
```sql
select code, name from classes where code like 'CH-%' or code like 'HU-%';
```

### List the professors for each section
```sql
select sec.class, prof.last_name from
    sections sec inner join professors prof on sec.professor = prof.id;
```

### List the professors and course name for each section, sorted by class code
```sql
select sec.class, cls.name, prof.last_name from
    sections sec inner join professors prof on sec.professor = prof.id
        inner join classes cls on sec.class = cls.code
    order by cls.code asc;
```

### List the classes Hermione is taking, with the professors, sorted by class code
```sql
select sec.class, cls.name, prof.last_name from
    sections sec inner join professors prof on sec.professor = prof.id
        inner join classes cls on sec.class = cls.code
        inner join section_students ss on sec.id = ss.section
        inner join students stu on ss.student = stu.id
    where stu.first_name = 'Hermione'
    order by cls.code asc;
```

### List all of the students taking "Intro to Herbal Remedies", in alphabetical order by last name
```sql
select stu.last_name, stu.first_name from
    students stu inner join section_students ss on ss.student = stu.id
        inner join sections sec on ss.section = sec.id
    where sec.class = 'CH-105'
    order by stu.last_name asc;
```

### List the number of students
```sql
select count(id) from students;
```

### List the number of sections of each class
```sql
select cls.code, count(sec.id) from
    classes cls inner join sections sec on cls.code = sec.class
    group by cls.code;
```

### List the number of sections of each class, including classes with no sections available
```sql
select cls.code, count(sec.id) from
    classes cls left join sections sec on cls.code = sec.class
    group by cls.code;
```

### List the number of students in each section
```sql
select sec.class, prof.last_name, count(ss.student) from
    sections sec inner join professors prof on sec.professor = prof.id
        inner join section_students ss on sec.id = ss.section
    group by sec.id, prof.last_name
    order by sec.class asc;
```

Rewritten with a subquery:

```sql
select sec.class, prof.last_name, sq.student_count from
    sections sec inner join professors prof on sec.professor = prof.id
        inner join (select sec.id as sec_id, count(ss.student) as student_count from
            sections sec inner join section_students ss on sec.id = ss.section
            group by sec.id) sq on sq.sec_id = sec.id
    order by sec.class asc;
```

### List the total number of students signed up for classes with each professor (it's a popularity contest)

```sql
select prof.last_name, sum(sq.student_count) from
    sections sec inner join professors prof on sec.professor = prof.id
        inner join (select sec.id as sec_id, count(ss.student) as student_count from
            sections sec inner join section_students ss on sec.id = ss.section
            group by sec.id) sq on sq.sec_id = sec.id
    group by prof.id;
```

### Find the number of classes each student is signed up for, sorted from most to least

```sql
select stu.last_name, stu.first_name, count(ss.section) from
    students stu left join section_students ss on stu.id = ss.student
    group by stu.id
    order by count(ss.section) desc;
```

### Find only those bad students who haven't signed up for any classes

```sql
select stu.last_name, stu.first_name from
    students stu left join section_students ss on stu.id = ss.student
    group by stu.id
    having count(ss.section) = 0;
```

### `TODO`

* Queries with assigments
* Grade totalling
* Missing assignments
* Signing students up for more sections
* Enrolling new students

## Resetting

If you make any changes or accidentally destroy some data, and want to set it up again fresh: in your psql prompt, just run `\i init.sql` again.
