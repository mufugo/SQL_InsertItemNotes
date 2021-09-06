# SQL_InsertItemNotes
Bu sorguda yapılan işlemler kısaca, aranan değer tabloda yok ise kayıt atıyor, eğer tabloda kayıt var ise kayıt güncelliyor.

Örneğin, ItemNotes tablosunda bulunan açıklama alanı boş ise, ItemDesc tablosunda bulunan ve ItemNotes alanında bulunmayan ürünleri tespit edip kayıt atıyor. Ya da ürün ItemNotes alanında var ancak Açıklama alanı boş ise, mevcut ürün kaydını güncelliyor.

EN;

In short, the operations performed in this query throw a record if the sought value does not exist in the table, and update the record if there is a record in the table.

For example, if the description field in the ItemNotes table is empty, it detects the products that are in the ItemDesc table but not in the ItemNotes field, and records them. Or, if the item exists in the ItemNotes field but the Description field is empty, it updates the existing item record.
