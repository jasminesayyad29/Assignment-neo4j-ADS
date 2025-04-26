use mydb;

CREATE TABLE ObjectTable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

DELIMITER //

CREATE FUNCTION countNoOfWords(inputName VARCHAR(50)) 
RETURNS INT
BEGIN
    DECLARE wordCount INT;
    DECLARE lengthwithoutspaces INT;
    SET lengthwithoutspaces = LENGTH(REPLACE(inputName, ' ', ''));
    SET wordCount = LENGTH(inputName) - lengthwithoutspaces + 1;
    RETURN wordCount;
END;
//

DELIMITER ;

INSERT INTO ObjectTable (name) VALUES 
('Jasmine Imtiyaj Sayyad'),
('Alice in Wonderland Enjoying Life!'),
('Hello World from MySQL');

SELECT id, name, countNoOfWords(name) AS WordCount FROM ObjectTable;


select * from ObjectTable;
