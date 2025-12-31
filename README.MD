🌐 Core DBMS Concepts
📂 Fundamental Ideas
Database: Organized collection of related data, stored for easy access and management.

DBMS: Software that enables defining, creating, maintaining, and controlling access to databases.

Data Models: Frameworks for structuring data (e.g., hierarchical, network, relational, object-oriented).

Schemas: Logical design of the database, describing tables, relationships, and constraints.

Data Independence: Ability to change schema at one level without affecting higher levels (logical vs. physical independence).

🏛 Architecture
Three-level architecture:

External level: User views.

Conceptual level: Logical structure of the database.

Internal level: Physical storage details.

Ensures abstraction and flexibility.

🧩 Modeling
Entity-Relationship (E-R) Model: Represents real-world entities, attributes, and relationships.

Relational Model: Organizes data into tables (relations) with rows (tuples) and columns (attributes).

🔧 Operations
Data Definition: Creating/modifying structures (tables, indexes).

Data Manipulation: Inserting, updating, deleting, querying data.

SQL: Standard language for interacting with relational databases


📂 Types of Attributes
Attributes are the columns in a table that describe properties of an entity. They can be classified as:

Simple Attribute: Cannot be divided further. Example: Name, Age.

Composite Attribute: Can be broken down into smaller parts. Example: FullName → FirstName + LastName.

Derived Attribute: Value can be derived from other attributes. Example: Age derived from DateOfBirth.

Multi-valued Attribute: Can hold multiple values for a single entity. Example: PhoneNumbers.

Key Attribute: Uniquely identifies an entity. Example: Roll_No in a student table.

Stored Attribute: Directly stored in the database (not derived). Example: Salary.

🔑 Types of Keys
Keys are special attributes (or sets of attributes) used to identify records and enforce constraints.

Primary Key: Uniquely identifies each record in a table. Cannot be NULL.

Candidate Key: Attributes that can potentially serve as a primary key.

Super Key: Any set of attributes that uniquely identifies a record (may include extra attributes).

Alternate Key: Candidate keys not chosen as the primary key.

Foreign Key: Attribute in one table that refers to the primary key in another table, establishing relationships.

Composite Key: Combination of two or more attributes that uniquely identify a record.

Unique Key: Ensures uniqueness of values in a column, but unlike primary key, it can allow NULL values.

🔗 Joins
Definition: Joins combine rows from two or more tables based on related columns.

Types:

Inner Join: Returns rows with matching values in both tables.

Left Outer Join: All rows from left table + matched rows from right.

Right Outer Join: All rows from right table + matched rows from left.

Full Outer Join: All rows when there is a match in either table.

Example: Joining Student and Course tables on Course_ID to see which student is enrolled in which course.

Joins allow multi-table queries and richer insights.

👓 Views
Definition: Views are virtual tables created by saving a query. They don’t store data themselves, but present results dynamically.

Syntax:

sql
CREATE VIEW student_courses AS
SELECT s.name, c.course_name
FROM student s JOIN course c ON s.course_id = c.course_id;
Use Cases:

Simplify complex queries.

Provide customized access to data.

Enhance security by restricting columns visible to users.

Views act as reusable query abstractions.


⚡ Triggers
Definition: Triggers are procedures that automatically execute in response to specific events (INSERT, UPDATE, DELETE) on a table.

Example:

sql
CREATE TRIGGER log_update
AFTER UPDATE ON student
FOR EACH ROW
INSERT INTO audit_log VALUES (OLD.name, NEW.name, CURRENT_TIMESTAMP);
Use Cases:

Enforce business rules.

Maintain audit logs.

Automatically update related tables.

Triggers make databases “active” by reacting to changes.

