-- Authors: xmrkviv00, xjaluvo00
-- Assignment no. 21: Knihovna 1 


---DROPING TABLES
DROP TABLE Reservations;
DROP TABLE Loans;
DROP TABLE Copies_table;
DROP TABLE Title_table;
DROP TABLE Users;


---CREATING TABLES
/* We decided to connect both the tables readers and staff 
   to the table users, so we can have a single table for all users
   and then we can filter them by their role. This is easier than
   having three separate tables for readers, staff and users, as we would have
   to manage the user_id shared between the three tables. Also, the ammount of attributes
   of the readers and staff tables is not enough to justify having separate tables.
   We did the same for title, book and magazine.
*/                                                                          
CREATE TABLE Users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    fname VARCHAR(35) NOT NULL,
    lname VARCHAR(35) NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) CHECK (REGEXP_LIKE(email, '^[a-zA-Z0-9\._%-]+@[a-zA-Z0-9_%-]+\.[a-zA-Z]{2,4}$')) NOT NULL,
    phone_number VARCHAR(20) CHECK (REGEXP_LIKE(phone_number, '^[0-9]{9}$')) NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    PIN VARCHAR(7) CHECK (REGEXP_LIKE(PIN, '^[0-9]{5}$')) NOT NULL,
    user_role VARCHAR(10) CHECK (user_role IN ('Reader', 'Staff')) NOT NULL,
    staff_position VARCHAR(30) CHECK (staff_position IN ('Librarian',  'CEO', 'Accountant', 'Toilet cleaner')),
    registration_date DATE,
    CONSTRAINT PK_user PRIMARY KEY (user_id)
);

      
CREATE TABLE Title_table (
    title_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    title_name VARCHAR(100) NOT NULL,
    first_release DATE,
    genre VARCHAR(30),
    title_type VARCHAR(10) CHECK (title_type IN ('Book', 'Magazine')) NOT NULL,
    author VARCHAR(50),
    category VARCHAR(30),
    language_of_origin VARCHAR(30),
    sequence_number INTEGER,
    piece_name VARCHAR(100),
    CONSTRAINT PK_title PRIMARY KEY (title_id)
);

CREATE TABLE Reservations (
    reservation_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    time_of_reservation TIMESTAMP NOT NULL,
    title_id INTEGER,
    user_id INTEGER,
    CONSTRAINT PK_Reservations PRIMARY KEY (reservation_id),
    CONSTRAINT FK_Reservations_title_id FOREIGN KEY (title_id) REFERENCES Title_table ON DELETE CASCADE,
    CONSTRAINT FK_Reservations_user_id FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE
);

CREATE TABLE Copies_table (
    issn VARCHAR(11) CHECK (REGEXP_LIKE(issn, '^[0-9]{4}-[0-9]{4}$')) NOT NULL,
    copy_language VARCHAR(30),
    publishing_house VARCHAR(50),
    release_date DATE,
    title_id INTEGER,
    CONSTRAINT PK_copies PRIMARY KEY (issn),
    CONSTRAINT FK_Copies_title_id FOREIGN KEY (title_id) REFERENCES Title_table ON DELETE CASCADE
);

CREATE TABLE Loans (
    loan_id INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    start_date DATE,
    return_date DATE,
    is_returned VARCHAR(100),
    fees INTEGER,
    user_id INTEGER,
    issn VARCHAR(11) CHECK (REGEXP_LIKE(issn, '^[0-9]{4}-[0-9]{4}$')),
    CONSTRAINT PK_loan PRIMARY KEY (loan_id),
    CONSTRAINT FK_Loans_user_id FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    CONSTRAINT FK_Loans_copy_id FOREIGN KEY (issn) REFERENCES Copies_table ON DELETE CASCADE
);


---INSERTING DATA
INSERT INTO Users (username, fname, lname, password, email, phone_number, street, city, PIN, user_role, staff_position, registration_date)
VALUES ('reader1', 'John', 'Cena', 'kjcdIDJBVDFJNB749KJDjnanvjshbdGUY768', 'r1@example.com', '123456789', 'Veveri 4', 'Brno', '12345', 'Reader', NULL, TO_DATE('2023-01-10', 'YYYY-MM-DD') );

INSERT INTO Users (username, fname, lname, password, email, phone_number, street, city, PIN, user_role, staff_position, registration_date)
VALUES ('staff1', 'Sun', 'Tzu', 'kasjdvnJNDVIN8976GCEUYAGbfu66FADVHuyf', 's1@example.com', '987654321', 'Vystaviste 15', 'Prague', '54321', 'Staff', 'Librarian', NULL);

INSERT INTO Users (username, fname, lname, password, email, phone_number, street, city, PIN, user_role, staff_position, registration_date)
VALUES ('reader2', 'Arnold', 'Schwarzenegger', 'YVhbvgyvGGYcfyvYctfyv6rjhsb&*%7675cd', 'r2@example.com', '111222333', 'Delnicka 21', 'Ostrava', '11223', 'Reader', NULL, TO_DATE('2023-02-01', 'YYYY-MM-DD') );

INSERT INTO Title_table (title_name, first_release, genre, title_type, author, category, language_of_origin, sequence_number, piece_name)
VALUES ('SQL Basics', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'Education', 'Book', 'John Doe', 'Scientific', 'English', NULL, NULL);

INSERT INTO Title_table (title_name, first_release, genre, title_type, author, category, language_of_origin, sequence_number, piece_name)
VALUES ('Tech Today', TO_DATE('2021-06-15', 'YYYY-MM-DD'), 'Technology', 'Magazine', NULL, NULL, NULL, 2, 'Issue 42');

INSERT INTO Reservations (time_of_reservation, title_id, user_id)
VALUES (TO_TIMESTAMP('2023-10-3/14:20:12', 'yyyy-mm-dd/hh24:mi:ss'), 1, 1);

INSERT INTO Reservations (time_of_reservation, title_id, user_id)
VALUES (TO_TIMESTAMP('2023-10-2/18:30:12', 'yyyy-mm-dd/hh24:mi:ss'), 2, 3);

INSERT INTO Copies_table (issn, copy_language, publishing_house, release_date, title_id)
VALUES ('1234-5678', 'English', 'Magazine Publisher Inc.', TO_DATE('2021-06-20', 'YYYY-MM-DD'), 2);

INSERT INTO Copies_table (issn, copy_language, publishing_house, release_date, title_id)
VALUES ('1343-3942', 'English', 'Super Publisher Inc.', TO_DATE('2022-09-20', 'YYYY-MM-DD'), 1);

INSERT INTO Loans (start_date, return_date, is_returned, fees, user_id, issn)
VALUES (TO_DATE('2023-03-10', 'YYYY-MM-DD') , TO_DATE('2023-03-20', 'YYYY-MM-DD') , 'No', 341, 1, '1234-5678');

INSERT INTO Loans (start_date, return_date, is_returned, fees, user_id, issn)
VALUES (TO_DATE('2023-04-10', 'YYYY-MM-DD') , TO_DATE('2023-04-20', 'YYYY-MM-DD') , 'Yes', 35, 1, '1343-3942');

---SELECT
---2 JOINED TABLES - SELECT RESERVATIONS AND WHAT TITLE IS RESERVED
SELECT r.reservation_id, r.time_of_reservation, t.title_name
FROM Reservations r
JOIN Title_table t ON r.title_id = t.title_id;

---2 JOINED TABLES - WHEN HAS A USER MADE A RESERVATION
SELECT u.fname, u.lname, r.time_of_reservation
FROM Users u
JOIN Reservations r ON u.user_id = r.user_id;

---3 JOINED TABLES - WHAT IS THE USERS LOANED COPIES PUBLISHING HOUSE, ISSN AND IS IT RETURNED 
SELECT u.fname, u.lname, c.issn, c.publishing_house, l.is_returned 
FROM Users u
JOIN Loans l ON l.user_id = u.user_id
JOIN Copies_table c ON l.issn = c.issn;

---GROUP BY - COUNT HOW MUCH FEES A PERSON HAS
SELECT u.fname, SUM(l.fees) AS fees_sum
FROM Users u
JOIN Loans l ON l.user_id = u.user_id
GROUP BY u.fname;

---GROUP BY - HOW MANY ACTIVE LOANS A PERSON HAS
SELECT u.fname, COUNT(l.loan_id) AS active_loans
FROM Users u
JOIN Loans l ON l.user_id = u.user_id
WHERE l.is_returned = 'No'
GROUP BY u.fname;

---EXISTS - USERS WHO HAVE AT LEAST ONE ACTIVE LOAN
SELECT username, fname, lname
FROM Users u
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    WHERE u.user_id = l.user_id
);

---IN - TITLES THAT HAVE ATLEAST ONE COPY
SELECT t.title_id, t.title_name, t.author
FROM Title_table t
WHERE t.title_id IN (
    SELECT c.title_id
    FROM Copies_table c
);
--------------------------------END OF FILE ----------------------------------------------------------
