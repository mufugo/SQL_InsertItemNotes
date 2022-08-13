--CREATE PROC SP_InsertItemNotes
--AS

/* 

Author: Furkan GOKDEMIR
Created Date: 6.09.2021 - 16:00
Last Update Date: 6.09.2021 - 17:30

Description;

Burada yapılan işlem, eğer ürünün not kısmı boş ise, ürünün adını not alanına getirir.

Eğer ürünün not alanında herhangi bir şey yazıyorsa, güncelleme yada ekleme yapmaz.

EN;
The action done here brings the name of the product to the note field if the note section of the product is empty.

If anything is written in the note field of the product, it will not update or add.

*/


DECLARE @ItemSAY INT 
DECLARE @sira INT
DECLARE @kayit INT
DECLARE @ItemDesc NVARCHAR(MAX)
DECLARE @ItemCode NVARCHAR(MAX)

SET @sira = 1 --Sıra atlamaması için her zaman 1'den başlıyor EN: It always starts from 1 so it doesn't skip rows.
SET @kayit = 0
SET @ItemSAY = (SELECT COUNT(*) FROM cdItemDesc WHERE ItemTypeCode = 1 AND CreatedUserName != 'sa') 



WHILE(@ItemSAY>=@sira)
	BEGIN
    SET @ItemCode = (SELECT ItemCode FROM (SELECT ROW_NUMBER() OVER(ORDER BY ItemCode)AS sira, * FROM cdItemDesc WHERE ItemTypeCode = 1 AND CreatedUserName != 'sa')AS Items WHERE sira = @sira)
    SET @ItemDesc = (SELECT ItemDescription FROM (SELECT ROW_NUMBER() OVER(ORDER BY ItemCode)AS sira, * FROM cdItemDesc WHERE ItemTypeCode = 1 AND CreatedUserName != 'sa')AS Items WHERE sira = @sira)
	
    /* Yukarıda yazdığım select sayesinde, @sira değişkeni kaçıncı satırda ise o satırı döndürüp tek satır kayıt almasını sağlıyor. 
    İçerideki SELECT düzenlendikten sonra çalıştırılarak yapılan işlem daha iyi anlamlandırılır. (WHERE alanında bulunan @sira manuel değer verilmesi gerekir.) */ 
    /* 
    Thanks to the select I wrote above, the @sira variable returns the row on whichever row it is and allows it to record a single row.
    The operation made by running the SELECT inside after editing is better understood. (The @sira in the WHERE field must be given a manual value.)
    */
		
    SET @kayit = (SELECT COUNT(*) FROM prItemNotes WHERE ItemCode = @ItemCode) --Yukarıda belirlediğim @ItemCode değişkeni ile burada kaç kayıt olduğunu sorguladım. EN: I queried how many records there are here with the @ItemCode variable I set above.
		IF(@kayit=0) --Eğer @ItemCode prItemNotes tablosunda yoksa EN: If @ItemCode is not in the prItemNotes table
			BEGIN
			INSERT INTO prItemNotes VALUES ('1',@ItemCode,'TR','{\rtf1\ansi\ansicpg1254\deff0\deflang1055{\fonttbl{\f0\fnil\fcharset162 Tahoma;}}  \viewkind4\uc1\pard\f0\fs17 '+@ItemDesc+'\par  }',@ItemDesc,'01   ADMIN',GETDATE(), '01   ADMIN', GETDATE(), NEWID())
			PRINT @ItemCode + ' tabloda bulunmadığı için ekledim.' --Kendime bir açıklama.
			END
		ELSE
		BEGIN
			IF(@kayit!=0) -- Eğer @ItemCode prItemNotes tablosunda varsa EN: If @ItemCode exists in the prItemNotes table
				BEGIN
					SET @kayit = (SELECT COUNT(*) FROM prItemNotes WHERE CONVERT(NVARCHAR(MAX), ItemCode) = @ItemCode AND CONVERT(NVARCHAR(MAX), PlainText) = '') --Burada ayrıca PlainText(Notes) alanının boş olduğunu kontrol ettim. EN: Here I also checked that the PlainText(Notes) field is empty.
					IF (@kayit=1) -- @ItemCode var ve PlainText alanı boş ise EN: If @ItemCode exists and PlainText field is empty
					BEGIN
						UPDATE prItemNotes SET Notes = '{\rtf1\ansi\ansicpg1254\deff0\deflang1055{\fonttbl{\f0\fnil\fcharset162 Tahoma;}}  \viewkind4\uc1\pard\f0\fs17 '+@ItemDesc+'\par  }', PlainText = @ItemDesc WHERE ItemCode = @ItemCode
						PRINT @ItemCode + ' tabloda vardı ve PlainText tablosu boştu, kaydı güncelledim.' --Kendime bir açıklama.
					END
				END
		END
		SET @sira = @sira+1
	END
	PRINT 'Eklenecek ya da güncellenecek daha fazla kayıt bulunamadı.' --Hiçbir kayıt değiştirilmez ise dönecek mesaj EN: If no record is changed, the message will return.
