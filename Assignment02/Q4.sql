USE mydb;

CREATE TABLE AddressTable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20)
);

INSERT INTO AddressTable (address, city, state, pincode) VALUES
('12 MG Road', 'Bengaluru', 'Karnataka', '560001'),
('221B Baker Street', 'Mumbai', 'Maharashtra', '400001'),
('Chandni Chowk', 'Delhi', 'Delhi', '110006'),
('Salt Lake Sector V', 'Kolkata', 'West Bengal', '700091'),
('Dwaraka Sector 10', 'New Delhi', 'Delhi', '110075'),
('Gachibowli', 'Hyderabad', 'Telangana', '500032'),
('Anna Salai', 'Chennai', 'Tamil Nadu', '600002'),
('Shivaji Nagar', 'Pune', 'Maharashtra', '411005'),
('Infocity', 'Gandhinagar', 'Gujarat', '382007'),
('Boring Road', 'Patna', 'Bihar', '800001');

DELIMITER //

CREATE FUNCTION ExtractAddresses(keyword VARCHAR(100))
RETURNS TEXT
BEGIN
    DECLARE result TEXT;
    SET result = '';
    SELECT GROUP_CONCAT(address SEPARATOR '; ')
    INTO result
    FROM AddressTable
    WHERE address LIKE CONCAT('%', keyword, '%')
       OR city LIKE CONCAT('%', keyword, '%')
       OR state LIKE CONCAT('%', keyword, '%')
       OR pincode LIKE CONCAT('%', keyword, '%');

    RETURN result;
END;
//

DELIMITER ;

SELECT ExtractAddresses('New') AS AddressesContainingKeyword;
SELECT ExtractAddresses('Maha') AS AddressesContainingKeyword;

DELIMITER //

CREATE FUNCTION CountWordsInField(fieldName VARCHAR(50), id INT)
RETURNS INT
BEGIN
    DECLARE fieldValue TEXT;
    DECLARE wordCount INT;

    SET fieldValue = CASE 
        WHEN fieldName = 'address' THEN (SELECT address FROM AddressTable WHERE AddressTable.id = id)
        WHEN fieldName = 'city' THEN (SELECT city FROM AddressTable WHERE AddressTable.id = id)
        WHEN fieldName = 'state' THEN (SELECT state FROM AddressTable WHERE AddressTable.id = id)
        WHEN fieldName = 'pincode' THEN (SELECT pincode FROM AddressTable WHERE AddressTable.id = id)
        ELSE NULL
    END;
    SET wordCount = LENGTH(fieldValue) - LENGTH(REPLACE(fieldValue, ' ', '')) + 1;

    RETURN wordCount;
END;
//

DELIMITER ;


SELECT CountWordsInField('address', 1) AS WordCountForAddress;
SELECT 
    id,
    address,
    CountWordsInField('address', id) AS WordCountForAddress,
    CountWordsInField('city', id) AS WordCountForCity,
    CountWordsInField('state', id) AS WordCountForState
FROM AddressTable;




