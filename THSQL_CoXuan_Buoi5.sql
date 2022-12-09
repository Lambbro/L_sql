--Buoi 5: Trigger
/* Tao trigger
create trigger [trigger_name] on [table_name]
[before|after|for] {insert|update|delete} as
trigger_statements
*/

--5.1: 
/* Them cot iTSDaBan (mac dinh = 0) vao bang tblMatHang
Tao trigger sao cho moi khi ban mot mat hang nao do thi tong so luong cua mat hang da ban do duoc tang len tuong ung voi so luong duoc nhap vao*/

--Them cot
go
alter table tblMatHang add iTSDaBan int default(0) with values
go
--Cap nhat toan bo mat hang da ban truoc do
update tblMatHang
set iTSDaBan = 
	(select sum(fSoLuongMua) from tblChiTietDatHang CTDH inner join tblDonDatHang DDH on DDH.iSoHD = CTDH.iSoHD
	where CTDH.sMaHang = tblMatHang.sMaHang
	group by sMaHang)
go
--Reset iTSDaBan
update tblMatHang set iTSDaBan = 0
go
--Tao trigger
create trigger trg_TongSLBan on tblChiTietDatHang
after insert, update
as
begin
	update tblMatHang
	set iTSDaBan = iTSDaBan + (
		select fSoLuongMua 
		from inserted
		where sMaHang = tblMatHang.sMaHang)
	from tblMatHang inner join inserted on tblMatHang.sMaHang = inserted.sMaHang
end
go
--Xoa trigger
drop trigger trg_TongSLBan
go
--Check bang
select * from tblMatHang
select * from tblChiTietDatHang order by iSoHD
go
insert into tblChiTietDatHang
values(5,'MH011', 20000, 10, 0.1)
go

--5.2
/* Tao trigger sao cho don gia ban cua mot mat hang nao do phai dam bao lon hon gia cua mat hang do hien tai */
create trigger trg_checkGiaBan on tblChiTietDatHang
for insert , update 
as
begin
	declare @giaNhap float
	declare @giaBan float

	select @giaNhap = tblMatHang.fGiaHang from tblMatHang inner join inserted on tblMatHang.sMaHang = inserted.sMaHang
	select @giaBan = fGiaBan from inserted

	if @giaNhap > @giaBan
	begin
		print 'Stink'
		rollback transaction
	end
end
go
--Check
select * from tblMatHang
select * from tblChiTietNhapHang order by sMaHang
select * from tblChiTietDatHang order by sMaHang
go

--5.3:
/* Them cot fTongTienHang (float, mac dinh = 0) vao bang tblKhachHang
Tao trigger sao cho gia tri fTongTienHang tu dong tang len moi khi khach hang thuc hien mua mot mat hang tuong ung */
--Cap nhat
alter table tblKhachHang add fTongTienHang float default(0) with values
go
--Update gia tri san co
update tblKhachHang 
set fTongTienHang = CT.sum
from (select KH.iMaKH, sum(fSoLuongMua * fGiaBan*(1-fMucGiamGia)) 'sum'
	from tblChiTietDatHang CTDH
	inner join tblDonDatHang DDH on CTDH.iSoHD = DDH.iSoHD
	inner join tblKhachHang KH on DDH.iMaKH = KH.iMaKH
	group by KH.iMaKH ) CT
where tblKhachHang.iMaKH = CT.iMaKH
go
/*update tblKhachHang 
set fTongTienHang = 
	(select sum(fSoLuongMua * fGiaBan*(1-fMucGiamGia))
	from tblChiTietDatHang CTDH
	inner join tblDonDatHang DDH on CTDH.iSoHD = DDH.iSoHD
	where iMaKH = DDH.iMaKH
	group by iMaKH)*/

update tblKhachHang
set fTongTienHang= fTongTienHang + CTDH.fSoLuongMua*CTDH.fGiaBan*(1-CTDH.fMucGiamGia)
from tblKhachHang KH,tblChiTietDatHang CTDH, tblDonDatHang DDH
where KH.iMaKH=DDH.iMaKH and CTDH.iSoHD=DDH.iSoHD
go
--Tao trigger
create trigger trg_TuDongTangKHKhiThem on tblChiTietDatHang
for insert
as
begin
	update tblKhachHang
	set tblKhachHang.fTongTienHang = tblKhachHang.fTongTienHang + (
		select sum(fGiaBan*fSoLuongMua*(1-fMucGiamGia)) 
		from inserted inner join tblDonDatHang DDH on DDH.iSoHD = inserted.iSoHD
		inner join tblKhachHang KH on KH.iMaKH = DDH.iMaKH)
	from tblDonDatHang DDH, inserted
	where tblKhachHang.iMaKH = DDH.iMaKH and DDH.iSoHD = inserted.iSoHD
end
go
--Them 1 CTHD
insert into tblChiTietDatHang
values(3,'MH002', 3000, 4, 0.1)
go
--Check bang
select * from tblKhachHang
select * from tblChiTietDatHang order by iSoHD
select * from tblDonDatHang
go
--5.4:
/* Them cot fTongTienHang (float) vao bang tblDonDatHang
Tao trigger sao cho gia tri cua fTongTienHang tu dong tang len moi khi them mot mat hang khach dat mua trong don dat hang tuong ung */
--Them cot
alter table tblDonDatHang add fTongTienHang float default(0) with values
go
--Them gia tri vao cot
update tblDonDatHang
set tblDonDatHang.fTongTienHang = tblDonDatHang.fTongTienHang + CTDH.fSoLuongMua*CTDH.fGiaBan*(1-CTDH.fMucGiamGia)
from tblChiTietDatHang CTDH
where tblDonDatHang.iSoHD = CTDH.iSoHD
update tblDonDatHang set tblDonDatHang.fTongTienHang =  0
go
--Tao trigger
alter trigger trg_TuDongTangDDHKhiThem on tblChiTietDatHang
for insert
as
begin
	update tblDonDatHang
	set tblDonDatHang.fTongTienHang = tblDonDatHang.fTongTienHang + (
		select sum(fSoLuongMua * fGiaBan * (1-fMucGiamGia))
		from inserted
		where inserted.iSoHD = tblDonDatHang.iSoHD)
	from inserted
	where tblDonDatHang.iSoHD = inserted.iSoHD
end
go
--Test
insert into tblChiTietDatHang
values(3,'MH004', 10000, 10, 0.1)
go
--Check bang
select tblChiTietDatHang.iSoHD, tblChiTietDatHang.sMaHang, tblChiTietDatHang. fGiaBan, tblDonDatHang.fTongTienHang
from tblChiTietDatHang inner join tblDonDatHang on tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD order by tblDonDatHang.iSoHD
select iSoHD, fTongTienHang from tblDonDatHang
--5.5:
/* Tao trigger sao cho moi khi xoa mot dong trong bang tblChiTietDatHang thi cac gia tri fTongTienHang tong bang tblKhachHang, fTongTienHang trong ban tblDonDatHang, iTSDaBan trong tblMatHang duoc giam tuong ung */
create trigger trg_GiamKhiXoa on tblChiTietDatHang
for delete
as
begin
	--Update trong bang don dat hang
	update tblDonDatHang 
	set tblDonDatHang.fTongTienHang = tblDonDatHang.fTongTienHang - (
		select fSoLuongMua * fGiaBan * (1-fMucGiamGia)
		from deleted where deleted.iSoHD = tblDonDatHang.iSoHD)
	from deleted where deleted.iSoHD = tblDonDatHang.iSoHD
	--Update trong bang khach hang
	update tblKhachHang
	set tblKhachHang.fTongTienHang = tblKhachHang.fTongTienHang - (
		select fSoLuongMua * fGiaBan * (1-fMucGiamGia)
		from deleted, tblDonDatHang, tblKhachHang
		where tblDonDatHang.iMaKH = tblKhachHang.iMaKH and tblDonDatHang.iSoHD = deleted.iSoHD)
	from tblDonDatHang, deleted
	where tblKhachHang.iMaKH = tblDonDatHang.iMaKH and tblDonDatHang.iSoHD = deleted.iSoHD
end