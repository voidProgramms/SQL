use lessons;
GO

CREATE TABLE MPT(
  ID_MPT INT PRIMARY KEY IDENTITY(1,1),
  AddressMPT varchar(30) NOT NULL,
  Title varchar(50)
);
GO

CREATE TABLE Students(
  ID_Students int primary key identity(1,1),
  FirstName  varchar(20) NOT NULL, 
  LastName varchar(20),
  MPT_ID int NOT NULL,
  FOREIGN KEY (MPT_ID) REFERENCES MPT (ID_MPT)
);
GO

ALTER TABLE MPT 
ADD Course varchar(10);

ALTER TABLE MPT
ALTER COLUMN Course INT NOT NULL 

ALTER TABLE MPT
ADD CONSTRAINT CN_Course CHECK (Course > 0); 

ALTER TABLE MPT 
ADD CONSTRAINT UQ_Course UNIQUE (Course);

ALTER TABLE MPT
DROP CONSTRAINT UQ_Course; 

ALTER TABLE MPT
DROP CONSTRAINT CN_Course;

ALTER TABLE MPT
DROP COLUMN ID_MPT;

ALTER TABLE Students
DROP CONSTRAINT FK__Students__MPT_ID__4BAC3F29;

ALTER TABLE MPT
DROP CONSTRAINT PK__MPT__276DAFCE0CECE635;

ALTER TABLE MPT
ADD ID_MPT INT NOT NULL;

ALTER TABLE MPT
ADD CONSTRAINT PK_MPT PRIMARY KEY (ID_MPT);

ALTER TABLE Students
ADD FOREIGN KEY (MPT_ID) REFERENCES MPT (ID_MPT);

EXEC sp_rename 'Students', 'NewStudents';

EXEC sp_rename 'NewStudents.LastName', 'NewLastName', 'COLUMN';

DROP TABLE MPT
DROP TABLE NewStudents
-------------------------------------------------------------------------------------------------------
CREATE TABLE Teachers(
  ID_Teacher INT PRIMARY KEY IDENTITY(1,1),
  Surname VARCHAR(30) NOT NULL,
  FirstName VARCHAR(30) NOT NULL, 
  MiddleName VARCHAR(30)
);
GO

CREATE TABLE Students(
  ID_Student INT PRIMARY KEY IDENTITY(1,1),
  Surname VARCHAR(30) NOT NULL,
  FirstName VARCHAR(30) NOT NULL, 
  MiddleName VARCHAR(30),
  Age INT NOT NULL
);
GO

CREATE TABLE Courses(
  ID_COURSE INT PRIMARY KEY IDENTITY(1,1),
  Title VARCHAR(30) NOT NULL,
  DescriptionCourse TEXT,
  Teacher_ID INT NOT NULL,
  FOREIGN KEY(Teacher_ID) REFERENCES Teachers(ID_Teacher)
);
GO

CREATE TABLE StudentsCourses(
  ID_StudentsCourses INT PRIMARY KEY IDENTITY(1,1),
  Student_ID INT NOT NULL,
  Course_ID INT NOT NULL,
  FOREIGN KEY (Student_ID) REFERENCES Students(ID_Student)
);
GO

  CREATE TABLE StudentCards(
  ID_StudentCard INT PRIMARY KEY IDENTITY(1,1),
  Number INT NOT NULL UNIQUE, 
  DateStudentCard DATE, 
  YearStudentCards INT NOT NULL,
  FOREIGN KEY (ID_StudentCard) REFERENCES Students(ID_Student)
 );
  GO

  CREATE TABLE StudentCardsTwo(
  ID_StudentCard INT PRIMARY KEY IDENTITY(1,1),
  Number INT NOT NULL UNIQUE, 
  DateStudentCard DATE, 
  YearStudentCards INT NOT NULL,
  Student_ID INT NOT NULL UNIQUE,
  FOREIGN KEY (Student_ID) REFERENCES Students(ID_Student)
 );
  GO

  INSERT INTO Teachers(Surname, FirstName, MiddleName)
  VALUES
  ('Скорогудаева', 'София', 'Алексеевна');

  SELECT * FROM Teachers;

  INSERT INTO Teachers(Surname, FirstName, MiddleName)
  VALUES
  ('Мысев', 'Дмитрий', NULL);

  INSERT INTO Teachers(Surname, FirstName, MiddleName)
  VALUES
  ('Артамонова', 'Татьяна', 'Дмитриевна'),
  ('Парамонова', 'Елизавета', 'Михайлова');
  
  SELECT  FirstName FROM Teachers;
  SELECT FirstName, Surname FROM Teachers;

  SELECT * FROM Teachers
  Where ID_Teacher = 2;

  SELECT * FROM Teachers 
  WHERE FirstName = 'София';

DELETE FROM Teachers
WHERE ID_Teacher = 6;

DELETE FROM Teachers
WHERE FirstName = 'Дмитрий';

UPDATE Teachers 
SET FirstName = 'Ева'

UPDATE Teachers 
SET FirstName = 'Анна'
WHERE ID_Teacher = 7;

INSERT INTO Courses(Title, Teacher_ID)
VALUES 
('c#', 5);

SELECT * FROM Courses;

INSERT INTO Students (Surname, FirstName, MiddleName, Age)
VALUES
('Пахтусов', 'Андрей', 'Александрович', 17),
('Петров', 'Пётр', 'Петрович', 19),
('Турунцев', 'Леонид', 'Сергеевич', 17);

SELECT * FROM Students;

INSERT INTO StudentsCourses (Student_ID, Course_ID)
VALUES
(1,1),
(2,1),
(3,1);

SELECT * FROM StudentsCourses;

INSERT INTO StudentCards(Number, DateStudentCard, YearStudentCards)
VALUES
(40688, '12.12.2003', 2006)


SELECT * FROM StudentCards

INSERT INTO StudentCardsTwo(Number, DateStudentCard, YearStudentCards, Student_ID)
VALUES
(40688, '12.12.2003', 2006, 5)

SELECT * FROM Teachers; 
SELECT * FROM Courses;

SELECT Courses.Title, Teachers.Surname, Teachers.FirstName FROM Courses
INNER JOIN Teachers ON Courses.Teacher_ID = Teachers.ID_Teacher;

ALTER TABLE Courses
ALTER COLUMN Teacher_ID INT NULL;

INSERT INTO Courses(Title)
VALUES
('ОПБД'),
('Python');

SELECT * FROM Courses

SELECT COURSES.Title, Teachers.Surname, Teachers.FirstName
FROM Courses
LEFT JOIN  Teachers ON
	Courses.Teacher_ID = Teachers.ID_Teacher;

SELECT Courses.Title, Teachers.Surname, Teachers.FirstName
FROM Courses
RIGHT JOIN Teachers ON
	Courses.Teacher_ID = Teachers.ID_Teacher;