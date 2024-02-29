CREATE TABLE teachers(
  ID_Teacher SERIAL PRIMARY KEY,
  surname VARCHAR(30) NOT NULL,
  firstName VARCHAR(30) NOT NULL,
  middleName VARCHAR(30)
);

CREATE TABLE students(
  ID_STUDENT SERIAL CONSTRAINT PK_STUDENT PRIMARY KEY,
  surname VARCHAR(30) NOT NULL,
  firstName VARCHAR(30) NOT NULL,
  middleName VARCHAR(30),
  age INT NOT NULL
);

CREATE TABLE courses(
  ID_Course SERIAL PRIMARY KEY,
  title VARCHAR(30) NOT NULL,
  description TEXT,
  teacher_ID INT REFERENCES teachers(ID_Teacher)
);

CREATE TABLE studentsCourses (
  ID_StudentsCourse SERIAL PRIMARY KEY,
  student_ID INT NOT NULL REFERENCES students(ID_STUDENT),
  course_ID INT NOT NULL REFERENCES courses(ID_Course)
);

CREATE TABLE studentCard(
  ID_StudentCard SERIAL PRIMARY KEY,
  numberCard INT NOT NULL
);

ALTER TABLE teachers
ADD mpt VARCHAR(30);

ALTER TABLE teachers
ALTER COLUMN mpt SET DATA TYPE INT USING mpt::INT; 

ALTER TABLE teachers
ALTER COLUMN mpt SET NOT NULL;

ALTER TABLE teachers RENAME TO prepodsss;

ALTER TABLE prepodsss RENAME COLUMN mpt TO mptsss;
alter table prepodsss
alter column middleName set not null;
alter table prepodsss
alter column mpt drop not null
alter table courses
drop column teacher_ID
alter table courses
add column teacher_ID INT references prepodsss(ID_teacher)


insert into prepodsss (surname, firstName, middleName)
values 
('Скорогудаева','Софилисевна',''),
('парамонова','Елизавета','Михайловна'),
('Мысев','Дмитрий','Владимирович'),
('Серяк','Даниил','Владимирович');


insert into students (surname, firstName, middleName, age)
values 
('Лавров' ,'Максим','Дмитриевич',17),
('Савкова','Кира','Дмитриевна',17),
('Пушкин','Илья','Александрович',17),
('Биктимиров','Руслан','Олегович',3);

select * from students

select surname from students where firstName ='Помогите'

update prepodsss set firstName = 'Андрей' where ID_Teacher = 2

delete from prepodsss where ID_Teacher = 5;

alter table courses
alter column teacher_ID drop not null;

insert into courses(title, teacher_ID)
values ('c#', 4), ('БД', null), ('python', 7);

alter table studentsCourses
alter column student_ID drop not null;

alter table studentsCourses
alter column course_ID drop not null

insert into studentsCourses(student_ID, course_ID)
values (1, 13), (null, 14), (3, null), (2, 15);

select students.firstname, students.surname, courses.title
from studentsCourses
inner join students on studentsCourses.student_ID = students.ID_STUDENT
inner join courses on studentsCourses.course_ID = courses.ID_Course

select students.firstname, students.surname, courses.title
from studentsCourses
right join students on studentsCourses.student_ID = students.ID_STUDENT
right join courses on studentsCourses.course_ID = courses.ID_Course

select students.firstname, students.surname, courses.title
from studentsCourses
full join students on studentsCourses.student_ID = students.ID_STUDENT
full join courses on studentsCourses.course_ID = courses.ID_Course




