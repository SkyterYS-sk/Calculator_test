using System;
using System.Reflection;
using AnalaizerClassLibrary;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Calculator.Tests
{
    /// <summary>
    /// Модульні тести (варіант 24): AnalaizerClass.IsDelimeter та AnalaizerClass.IsOperator.
    /// Обидва методи private, тому викликаються через рефлексію.
    /// Тестові дані беруться з MS SQL Server (БД CalcTestsDb, скрипт CalcTestsDb.sql).
    /// </summary>
    [TestClass]
    public class AnalaizerClassTests
    {
        // Рядок підключення. За потреби змініть сервер (наприклад ".\\SQLEXPRESS").
        private const string ConnectionString =
            @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=CalcTestsDb;Integrated Security=True";

        private const string Provider = "System.Data.SqlClient";

        private static MethodInfo _isOperator;
        private static MethodInfo _isDelimeter;

        public TestContext TestContext { get; set; }

        [ClassInitialize]
        public static void ClassInit(TestContext context)
        {
            const BindingFlags flags = BindingFlags.NonPublic | BindingFlags.Static;
            Type t = typeof(AnalaizerClass);
            _isOperator = t.GetMethod("IsOperator", flags);
            _isDelimeter = t.GetMethod("IsDelimeter", flags);

            Assert.IsNotNull(_isOperator, "Метод IsOperator не знайдено");
            Assert.IsNotNull(_isDelimeter, "Метод IsDelimeter не знайдено");
        }

        // ---------------- IsOperator ----------------

        [TestMethod]
        [DataSource(Provider, ConnectionString, "IsOperatorTests", DataAccessMethod.Sequential)]
        public void IsOperator_FromDatabase()
        {
            string input = (string)TestContext.DataRow["Input"];
            bool expected = Convert.ToBoolean(TestContext.DataRow["Expected"]);
            string description = (string)TestContext.DataRow["Description"];

            bool actual = (bool)_isOperator.Invoke(null, new object[] { input });

            Assert.AreEqual(expected, actual,
                $"IsOperator(\"{input}\") [{description}]");
        }

        [TestMethod]
        public void IsOperator_Null_ThrowsNullReferenceException()
        {
            try
            {
                _isOperator.Invoke(null, new object[] { null });
                Assert.Fail("Очікувався NullReferenceException");
            }
            catch (TargetInvocationException ex)
            {
                Assert.IsInstanceOfType(ex.InnerException, typeof(NullReferenceException));
            }
        }

        // ---------------- IsDelimeter ----------------

        [TestMethod]
        [DataSource(Provider, ConnectionString, "IsDelimeterTests", DataAccessMethod.Sequential)]
        public void IsDelimeter_FromDatabase()
        {
            char input = (char)Convert.ToInt32(TestContext.DataRow["CharCode"]);
            bool expected = Convert.ToBoolean(TestContext.DataRow["Expected"]);
            string description = (string)TestContext.DataRow["Description"];

            bool actual = (bool)_isDelimeter.Invoke(null, new object[] { input });

            Assert.AreEqual(expected, actual,
                $"IsDelimeter(U+{(int)input:X4}) [{description}]");
        }
    }
}
