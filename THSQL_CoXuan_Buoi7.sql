--THSQL Buoi 7
/* Tao tai khoan dang nhap
create login login_name with password 'password'
*/
/* Tao user cho tai khoan day
create user user_name for login login_name with default_schema = database_name
*/
/* Cap quyen cho user 
grant (select, insert, update, delete, execute,...) on tbl_name to user_name 
*/
use QuanLyPhiChungChu
go
--Cau 1:
/* Tao nhom nguoi dung "QuanTri" va "NhanVien" */
create role QuanTri
create role NhanVien
go

--Cau2:
/* Trong nhom nguoi dung "QuanTri" tao cac nguoi dung lan luot: admin1, admin2 */
create login admin1 with password = '123456'
create user admin1 for login admin1 with default_schema = QuanLyPhiChungChu
alter role QuanTri add member admin1
go
create login admin2 with password = '123456'
create user admin2 for login admin2 with default_schema = QuanLyPhiChungChu
alter role QuanTri add member admin2
go
--Cau3:
/* Trong nhom nguoi dung "NhanVien" tao cac nguoi dung lan luot: user1, user2, user3 */
create login user1 with password = '123456'
create user user1 for login user1 with default_schema = QuanLyPhiChungChu
alter role NhanVien add member user1
go
create login user2 with password = '123456'
create user user2 for login user2 with default_schema = QuanLyPhiChungChu
alter role NhanVien add member user2
go
create login user3 with password = '123456'
create user user3 for login user3 with default_schema = QuanLyPhiChungChu
alter role NhanVien add member user3
go

--Cau4:
/* Tu phan quyen cho cac nguoi dung admin1, admin2, user1, user2, user3 thuc hien cac thao tac quyen khac nhau 
trong cac View, cac Proc hoan thien o cac buoi thuc hanh truoc */
grant exec on p_cudanNopPhi to admin1
grant exec on p_cudanNopPhi to admin2
grant exec on p_cudanNopPhi to user1
grant exec on p_cudanNopPhi to user2
grant exec on p_cudanNopPhi to user3