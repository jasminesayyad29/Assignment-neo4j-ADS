use mydb;

CREATE TABLE course_table (
    course_id VARCHAR(10),
    description VARCHAR(255)
);

ALTER TABLE course_table
ADD PRIMARY KEY (course_id);

INSERT INTO course_table (course_id, description) VALUES 
('CS101', 'Introduction to Computer Science'),
('CS102', 'Data Structures and Algorithms'),
('CS108', 'Clouding Computing'),
('CS103', 'Database Systems');

select * from course_table;


