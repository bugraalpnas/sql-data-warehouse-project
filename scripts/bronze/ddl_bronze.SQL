CREATE or ALTER proc bronze.load_proc
AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME

	BEGIN TRY
		PRINT('===============================');
		PRINT('Loading Bronze Layer');
		PRINT('-------------------------------')
		PRINT('Loading CRM Tables')
		PRINT('-------------------------------')
		/*
		IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
			DROP TABLE bronze.crm_cust_info
		*/

		SET @start_time = GETDATE()
		CREATE TABLE bronze.crm_cust_info
		(
			cst_id int,
			cst_key nvarchar(MAX),
			cst_firstname nvarchar(MAX),
			cst_lastname nvarchar(MAX),
			cst_marital_status nvarchar(MAX),
			cst_gndr nvarchar(MAX),
			cst_create_date DATE
		)
		SET @end_time = GETDATE()
		PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS nvarchar) + ' seconds'

		CREATE TABLE bronze.prd_info
		(
			prd_id int,
			prd_key nvarchar(MAX),
			prd_nm nvarchar(MAX),
			prd_cost int,
			prd_line nvarchar(MAX),
			prd_start_dt DATE,
			prd_end_dt DAte
		)

		CREATE TABLE bronze.sales_details
		(
			sls_ord_num nvarchar(MAX),
			sls_prd_key nvarchar(MAX),
			sls_cust_id int,
			sls_order_dt nvarchar(MAX),
			sls_ship_dt nvarchar(MAX),
			sls_due_dt nvarchar(MAX),
			sls_sales int,
			sls_quantity int,
			sls_price int
		)

		PRINT('-------------------------------')
		PRINT('Loading ERP Tables')
		PRINT('-------------------------------')

		CREATE TABLE bronze.erp_cust_az12
		(
			CID nvarchar(MAX),
			BDATE DATE,
			GEN nvarchar(MAX)
		)

		CREATE TABLE bronze.erp_loc_a101	
		(
			CID nvarchar(MAX),
			CNTRY nvarchar(MAX)
		)

		CREATE TABLE bronze.erp_px_cat_g1v2	
		(
			ID nvarchar(MAX),
			CAT nvarchar(MAX),
			SUBCAT nvarchar(MAX),
			MAINTENANCE nvarchar(MAX)
		)

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)


		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)
		--TRUNCATE TABLE bronze.erp_px_cat_g1v2 // Tablonun içini boşaltıyor
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\HUAWEI\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK 
		)
	END TRY
	BEGIN CATCH
		PRINT('=======================')
		PRINT 'Error Message' + ERROR_MESAGE()
	END CATCH
END

