-- Лабораторна робота №1, варіант 24
-- Методи AnalaizerClass: IsDelimeter, IsOperator
-- MS SQL Server / LocalDB. Запуск: SSMS або  sqlcmd -S "(localdb)\MSSQLLocalDB" -i CalcTestsDb.sql
IF DB_ID(N'CalcTestsDb') IS NULL
    CREATE DATABASE CalcTestsDb;
GO
USE CalcTestsDb;
GO
IF OBJECT_ID(N'dbo.IsOperatorTests') IS NOT NULL DROP TABLE dbo.IsOperatorTests;
IF OBJECT_ID(N'dbo.IsDelimeterTests') IS NOT NULL DROP TABLE dbo.IsDelimeterTests;
GO
-- Вхід IsOperator(string s). Input зберігається як NVARCHAR (порожній рядок і пропуски зберігаються як є)
CREATE TABLE dbo.IsOperatorTests (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Input       NVARCHAR(10) NOT NULL,
    Expected    BIT          NOT NULL,
    Description NVARCHAR(200) NOT NULL
);
-- Вхід IsDelimeter(char c). Символ задається кодом (CharCode), щоб уникнути проблем з пропусками/керуючими символами
CREATE TABLE dbo.IsDelimeterTests (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    CharCode    INT          NOT NULL,
    Expected    BIT          NOT NULL,
    Description NVARCHAR(200) NOT NULL
);
GO
INSERT INTO dbo.IsOperatorTests (Input, Expected, Description) VALUES
(N'+', 1, N'Бінарний плюс'),
(N'-', 1, N'Бінарний мінус'),
(N'*', 1, N'Множення'),
(N'/', 1, N'Ділення'),
(N'%', 1, N'Остача (mod у коді = %)'),
(N'(', 1, N'Відкриваюча дужка'),
(N')', 1, N'Закриваюча дужка'),
(N'p', 1, N'Унарний плюс'),
(N'm', 1, N'Унарний мінус'),
(N'a', 0, N'Літера'),
(N'1', 0, N'Цифра'),
(N'0', 0, N'Нуль'),
(N' ', 0, N'Пропуск'),
(N'^', 0, N'Невідомий символ ^'),
(N'=', 0, N'Знак ='),
(N'P', 0, N'Велика P (регістр)'),
(N'M', 0, N'Велика M (регістр)'),
(N'.', 0, N'Крапка'),
(N'×', 0, N'Символ множення U+00D7'),
(N'÷', 0, N'Символ ділення U+00F7'),
(N'', 0, N'Порожній рядок'),
(N'++', 0, N'Два оператори'),
(N'()', 0, N'Дві дужки'),
(N'mod', 0, N'Слово mod (за специфікацією 4.3.4, у коді не підтримується)'),
(N'12', 0, N'Число з двох цифр'),
(N'+ ', 0, N'Оператор з пропуском після'),
(N' +', 0, N'Оператор з пропуском перед');
GO
INSERT INTO dbo.IsDelimeterTests (CharCode, Expected, Description) VALUES
(32, 1, N'Пропуск'),
(9, 0, N'Табуляція'),
(10, 0, N'LF'),
(13, 0, N'CR'),
(160, 0, N'Нерозривний пропуск U+00A0'),
(8195, 0, N'Em space U+2003'),
(0, 0, N'Нуль-символ'),
(48, 0, N'Цифра 0'),
(97, 0, N'Літера a'),
(65, 0, N'Літера A'),
(43, 0, N'Плюс'),
(40, 0, N'Дужка'),
(44, 0, N'Кома'),
(95, 0, N'Підкреслення');
GO
SELECT COUNT(*) AS IsOperatorRows FROM dbo.IsOperatorTests;
SELECT COUNT(*) AS IsDelimeterRows FROM dbo.IsDelimeterTests;