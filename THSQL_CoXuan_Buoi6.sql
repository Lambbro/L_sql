create database QuanLyPhiChungChu
go
use QuanLyPhiChungChu
go
--Cau 1:
/* Tao CSDL "QuanLyPhiChungChu" voi cac bang nhu hinh minh hoa o tren, dam bao rang buoc ve khoa chinh va tham chieu */

--Bang cu dan

/* Lenh tao bang: 
create table + table_name 
(
	column_name + type + constraint,
	column_name + type + constraint,
	column_name + type + constraint
)
*/

/* Chinh sua bang:
alter table + table_name + add + ...
*/
create table tblCuDan
(
	sMaCuDan nvarchar(10) primary key,
	sTenCuDan varchar(20),
	sDienThoai nvarchar(12),
	sTienPhong varchar(20),
	fDienTich float,
	fTongTienDaNop float,
	iSoThangDaNop int
)
go
--Bang hoa don
create table tblHoaDon
(
	sSoHoaDon nvarchar(10) primary key,
	dNgayLap datetime,
	iThang int,
	iNam int,
	sMaCuDan nvarchar(10) constraint FK_HD_CD foreign key references tblCuDan(sMaCuDan)
)
go
--Bang chi tiet hoa don
create table tblChiTietHoaDon
(
	sSoHoaDon nvarchar(10) constraint FK_CTHD_HD foreign key references tblHoaDon(sSoHoaDon),
	sMaDichVu nvarchar(10) constraint FK_CTHD_DV foreign key references tblDichVu(sMaDichVu),
	iSoLuong int,
	primary key(sSoHoaDon, sMaDichVu)
)
go
--Bang dich vu
create table tblDichVu
(
	sMaDichVu nvarchar(10) primary key,
	sTenDichVu varchar(20),
	sDonViTinh varchar(10),
	fDonGia float
)
go
--Cau 2:
/* Tao trigger sao cho moi khi chen them mot hoa don moi thi Tong so thang da nop iSoThangDaNop phi cua tung cu dan tang len tuong ung */
/* Lenh tao trigger:
create trigger + trigger_name + on + table_name
[instead of / for / after] + [insert/update/delete]
as
begin
	...
end
*/
/* 3 cach lam trigger
C1: Tao view ho tro thong tin can co de lam trigger
C2: Tao cac bien can co de lam trigger
C3: Dung subquery (Ko nen)
*/
create trigger trg_ThangNop_CD on tblHoaDon
for insert
as
begin
	declare @thang int, @nam int, @maCD nvarchar(10)
	select @thang = iThang, @nam = iNam, @maCD = sMaCuDan from inserted

	update tblCuDan
	set iSoThangDaNop = iSoThangDaNop + @thang + @nam*12
	from tblCuDan
	where sMaCuDan = @maCD
end
go
--Cau 3:
/* Tao trigger sao cho moi khi chen mot chi tiet hoa don moi thi tong tien da nop cua tung cu dan fTongTienDaNop cua cu dan tang len tuong ung voi so luong dich vu ma cu dan su dung */
create trigger trg_TongTienNop_CD on tblHoaDon
for insert
as
begin
	update tblCuDan
	set fTongTienDaNop = fTongTienDaNop + (
		select CTHD.iSoLuong*DV.fDonGia
		from inserted, tblChiTietHoaDon CTHD, tblDichVu DV
		where tblCuDan.sMaCuDan = inserted.sMaCuDan
			and CTHD.sSoHoaDon = inserted.sSoHoaDon
			and CTHD.sMaDichVu = DV.sMaDichVu)
	from inserted, tblChiTietHoaDon CTHD, tblDichVu DV
		where tblCuDan.sMaCuDan = inserted.sMaCuDan
			and CTHD.sSoHoaDon = inserted.sSoHoaDon
			and CTHD.sMaDichVu = DV.sMaDichVu
end
go
--Cau 4:
/* Chen it nhat 2 dong vao tblDichVu, tblCuDan va tblHoaDon
Chen mot so dong vao bang tblChiTietHoaDon */
/* Lenh chen them thong tin vao bang
insert into + table_name
values (column1, column2, ...)
*/
--Them vao bang dich vu
insert into tblDichVu
values ('DV001', 'Hang thuong', 'Hang', 1000)
insert into tblDichVu
values ('DV002', 'Hang sang', 'Hang', 5000)
--Them vao bang cu dan
insert into tblCuDan
values ('CD001','Nguyen Van A', '0987654321', 'P01', 20, 20000, 5)
insert into tblCuDan
values ('CD002', 'Nguyen Thi B', '0123456789', 'P02', 15, 18000, 7)
--Them vao bang hoa don
insert into tblHoaDon
values ('HD001', '20210101', 10, 1, 'CD001')
insert into tblHoaDon
values ('HD002', '20220101', 10, 0, 'CD002')
--Them vao bang chi tiet hoa don
insert into tblChiTietHoaDon
values ('HD001', 'DV002', 2)
--Check bang
select * from tblCuDan
select * from tblHoaDon
select * from tblChiTietHoaDon
select * from tblDichVu

--Cau 5:
/* Tao thu tuc cho danh sach ten cac cu dan da nop phi cua mot thang - mot nam nao do */
/* Lenh tao thu tuc:
create proc + proc_name + variables
as
begin
	...
end
-- Thuc hien thu tuc
exec proc+name + vars
*/
create proc p_cudanNopPhi @thang int, @nam int
as
begin
	select sTenCuDan from tblCuDan CD inner join tblHoaDon HD on CD.sMaCuDan = HD.sMaCuDan
	where @thang = month(HD.dNgayLap) and @nam = year(HD.dNgayLap)
end
--Chay proc
exec p_cudanNopPhi 1, 2021