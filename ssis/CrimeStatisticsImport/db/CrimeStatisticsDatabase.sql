CREATE DATABASE CrimeStatistics;

GO

USE CrimeStatistics;


CREATE TABLE dbo.ImportHistory
(
 ImportHistoryId		INT IDENTITY(1,1)	NOT NULL,
 [FileName]				NVARCHAR(200)		NULL,
 FileStatus				NVARCHAR(30)		NOT NULL CONSTRAINT ck_ImportHistory_FileStatus CHECK(FileStatus IN ('In Progress', 'Failed', 'Completed')),
 DateStarted			DATETIME			NOT NULL CONSTRAINT df_ImportHistory_DateProcessed DEFAULT (GETDATE()),
 DateCompleted			DATETIME			NULL,
 NumberValidRows		INT					NOT NULL CONSTRAINT df_ImportHistory_NumberValidRows DEFAULT (0),
 NumberInvalidRows		INT					NOT NULL CONSTRAINT df_ImportHistory_NumberInvalidRows DEFAULT(0),
 CONSTRAINT df_ImportHistory PRIMARY KEY CLUSTERED (ImportHistoryId)
);

GO

CREATE PROCEDURE dbo.InsertImportHistory
(
 @FileName			NVARCHAR(200),
 @FileStatus		NVARCHAR(30),
 @ImportHistoryId	INT OUTPUT
)
AS
BEGIN;

SET NOCOUNT ON;

BEGIN TRY;

    BEGIN TRANSACTION;

        INSERT INTO dbo.ImportHistory 
	        ([FileName], FileStatus)
        VALUES
	        (@FileName, @FileStatus);

        SELECT @ImportHistoryId = SCOPE_IDENTITY();

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH;

	IF (@@TRANCOUNT > 0)
	 BEGIN;
		ROLLBACK TRANSACTION;
	 END;

	THROW;

END CATCH;

SET NOCOUNT OFF;

END;

GO

CREATE PROCEDURE dbo.UpdateImportHistory
(
 @ImportHistoryId	INT,
 @FileStatus		NVARCHAR(30),
 @NumberValidRows	INT = 0,
 @NumberInvalidRows	INT = 0
)
AS
BEGIN;

SET NOCOUNT ON;

BEGIN TRY;

	UPDATE dbo.ImportHistory
		SET FileStatus			= @FileStatus,
			DateCompleted		= GETDATE(),
			NumberValidRows		= @NumberValidRows,
			NumberInvalidRows	= @NumberInvalidRows
	WHERE ImportHistoryId = @ImportHistoryId;

END TRY
BEGIN CATCH;

	IF (@@TRANCOUNT > 0)
	 BEGIN;
		ROLLBACK TRANSACTION;
	 END;

	THROW;

END CATCH;

SET NOCOUNT OFF;

END;

GO

CREATE TABLE dbo.StreetCrime
(
 StreetCrimeId			INT IDENTITY(1,1)	NOT NULL,
 ImportHistoryId		INT					NOT NULL,
 RowNumber				INT					NOT NULL,
 [Month]				TINYINT				NOT NULL,
 [Year]					SMALLINT			NOT NULL,
 ReportedBy				NVARCHAR(2000)		NOT NULL,
 FallsWithin			NVARCHAR(2000)		NOT NULL,
 Latitude				FLOAT				NULL,
 Longitude				FLOAT				NULL,
 [Location]				NVARCHAR(2000)		NULL,
 AreaCode				NVARCHAR(200)		NULL,
 AreaName				NVARCHAR(2000)		NULL,
 CrimeType				NVARCHAR(2000)		NULL,
 LastOutcomeCategory	NVARCHAR(2000)		NOT NULL,
 Context				NVARCHAR(2000)		NULL,
 CONSTRAINT pk_StreetCrime PRIMARY KEY (StreetCrimeId)
);

GO

CREATE TABLE dbo.StreetCrimeException
(
 StreetCrimeExceptionId	INT IDENTITY(1,1)	NOT NULL,
 ImportHistoryId		INT					NOT NULL,
 RowNumber				INT					NOT NULL,
 [Month]				TINYINT				NOT NULL,
 [Year]					SMALLINT			NOT NULL,
 ReportedBy				NVARCHAR(2000)		NOT NULL,
 FallsWithin			NVARCHAR(2000)		NOT NULL,
 Latitude				FLOAT				NULL,
 Longitude				FLOAT				NULL,
 [Location]				NVARCHAR(2000)		NULL,
 AreaCode				NVARCHAR(200)		NULL,
 AreaName				NVARCHAR(2000)		NULL,
 CrimeType				NVARCHAR(2000)		NULL,
 LastOutcomeCategory	NVARCHAR(2000)		NULL,
 Context				NVARCHAR(2000)		NULL,
 CONSTRAINT pk_StreetCrimeException PRIMARY KEY (StreetCrimeExceptionId)
)

ALTER TABLE dbo.StreetCrime
	ADD CONSTRAINT fk_StreetCrime_ImportHistory
		FOREIGN KEY (ImportHistoryId)
		REFERENCES dbo.ImportHistory (ImportHistoryId)
		ON UPDATE NO ACTION
		ON DELETE NO ACTION;

ALTER TABLE dbo.StreetCrimeException
	ADD CONSTRAINT fk_StreetCrimeException_ImportHistory
		FOREIGN KEY (ImportHistoryId)
		REFERENCES dbo.ImportHistory (ImportHistoryId)
		ON UPDATE NO ACTION
		ON DELETE NO ACTION;

