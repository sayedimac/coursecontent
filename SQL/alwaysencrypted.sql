/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PersonID]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[City]
      ,[IdNumber]
  FROM [dbo].[Persons]