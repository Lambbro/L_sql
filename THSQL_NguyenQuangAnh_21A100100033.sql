--Buoi 1 -> 5--
create database THSQL_NguyenQuangAnh_21A100100033

use THSQL_NguyenQuangAnh_21A100100033

go
create table tblLoaiHang(
	sMaLoaiHang varchar(10) not null,
	sTenLoaiHang varchar(30) not null
)
go 
alter table tblLoaiHang
add constraint PK_tblLoaiHang
Primary key(sMaLoaiHang)

go
create table tblNhaCungCap(
	iMaNCC int IDENTITY(1,1) not null,
	sTenNhaCC nvarchar(50),
	sTenGiaoDich nvarchar(50),
	sDiaChi nvarchar(50),
	sDienThoai varchar(12)
	constraint PK_tblNhaCungCap
	Primary key (iMaNCC)
)
go 
create table tblMatHang(
	sMaHang varchar(10) not null,
	stenHang nvarchar(30),
	iMaNCC int,
	sMaLoaiHang varchar(10),
	fSoLuong float,
	sDonViTinh varchar(10),
	fGiaHang float
)
alter table tblMatHang
add constraint PK_tblMatHang
Primary key (sMaHang),
constraint FK_tblMatHang_tblLoaiHang
Foreign key (sMaLoaiHang)
References tblLoaiHang(sMaLoaiHang),
Foreign key(iMaNCC)
References tblNhaCungCap(iMaNCC)

--1.b

go 
create table tblKhachHang(
	iMaKH int not null,
	sTenKH nvarchar(30),
	sDiaChi nvarchar(50),
	sDienThoai varchar(12)
)
go 
create table tblNhanVien(
	iMaNV int not null,
	sTenNV nvarchar(30),
	sDiaChi nvarchar(50),
	sDienThoai varchar(12),
	dNgaySinh date,
	dNgayVaoLam date,
	fLuongPhuCap float,
	fPhuCap float
)
--1.c
go
alter table tblNhanVien
add sCMND varchar(20) unique
--1.d
go
alter table tblKhachHang
add constraint PK_KhachHang
Primary key(iMaKH)
go
alter table tblNhanVien 
add constraint PK_NhanVien
Primary key (iMaNV)
--1.e
go 
alter table tblNhanVien
add check (datediff(year,dNgaySinh,dNgayVaoLam)<>-1)
go

--1.g

go 
create index index_TenHang
on dbo.tblMatHang(stenHang)
-- 2
--1.2.a
go
create table tblDonNhapHang(
	iSoHD int not null,
	iMaNV int not null,
	dNgayNhapHang dateTime
)
go 
create table tblChiTietNhapHang(
	iSoHD int not null,
	fGiaNhap float,
	fSoLuongNhap float
)
--1.2.b
go 
alter table tblDonNhapHang
add constraint PK_tblDonNhapHang
Primary key(iSoHD),
constraint FK_tblDonNhapHang_tblNhanVien
foreign key(iMaNV)
references tblNhanVien(iMaNV)
--Them sMaHang
go 
alter table tblChiTietNhapHang
add sMaHang varchar(10) not null
go
alter table tblChiTietNhapHang
add constraint PK_tblChiTietNhapHang
Primary key(iSoHD, sMaHang),
constraint FK_tblChiTietNhapHang_tblMatHang
foreign key(sMaHang)
references tblMatHang(sMaHang),
constraint FK_tblChiTietNhapHang_tblDonNhapHang
foreign key(iSoHD)
references tblDonNhapHang(iSoHD)
--1.2.c
go
alter table tblChiTietNhapHang
add check (fGiaNhap>0), check (fSoLuongNhap>0)
--3
--1.3.a
go 
alter table tblKhachHang
add bGioiTinh bit
--1.3.b
go
create table tblDonDatHang(
	iSoHD int not null,
	iMaNV int,
	iMaKH int,
	dNgayDatHang datetime default getdate(),
	dNgayGiaoHang datetime not null,
	sDiaChiGiaHang nvarchar(50)
	constraint PK_tblDonDatHang
	primary key (iSoHD),
	check (dNgayGiaoHang>=dNgayDatHang),
	check (dNgayDatHang<=getdate())
)
--1.3.c,d
go
alter table tblDonDatHang
add constraint FK_tblDonDatHang_tblKhachHang
foreign key (iMaKH)
references tblKhachHang(iMaKH),
constraint FK_tblDonDatHang_tblNhanVien
foreign key(iMaNV)
references tblNhanVien(iMaNV)
--4
--1.4.a
go
create table tblChiTietDatHang(
	iSoHD int,
	sMaHang varchar(20),
	fGiaBan float,
	fSoLuongMua float,
	fMucGiamGia float
)
--1.4.b
go
alter table tblChiTietDatHang
alter column sMaHang varchar(10)
--1.4c,d
go 
alter table tblChiTietDatHang
alter column iSoHD int not null
go 
alter table tblChiTietDatHang
alter column sMaHang varchar(10)  not null
go 
alter table tblChiTietDatHang
add constraint FK_tblChiTietDatHang_tblMatHang
foreign key (sMaHang)
references tblMatHang(sMaHang),
constraint FK_tblChiTietDatHang_tblDonDatHang
foreign key (iSoHD)
references tblDonDatHang(iSoHD),
constraint PK_btlChiTietDatHang
primary key (sMaHang, iSoHD)
--1.4.e
go
alter table tblChiTietDatHang
add check (fGiaBan>0), check (fSoLuongMua>0), check (fMucGiamGia>0)

--buoi 2
use THSQL_NguyenQuangAnh_21A100100033
go
--2.1, Chen 3 ban ghi vao tblLoaiHang
go
insert into tblLoaiHang
values('LH001','Do gia dung')
insert into tblLoaiHang
values('LH002','Do tieu thu')
insert into tblLoaiHang
values('LH003','Do choi')

delete from tblLoaiHang
where sMaLoaiHang = 'LH003'

--2.2, Chen 5 ban ghi vao tblNhaCungCap
go

insert into tblNhaCungCap(sTenNhaCC,sTenGiaoDich,sDiaChi,sDienThoai)
values('Cong ty do choi', 'Chuyen khoan', 'Ha Noi', '0987654321')
insert into tblNhaCungCap
values('Cong ty quan ao', 'Chuyen khoan', 'Ha Nam', '0987654322')
insert into tblNhaCungCap
values('Cong ty gia dung', 'Chuyen khoan', 'Ha Tinh', '0987654323')
insert into tblNhaCungCap
values('Cong ty my pham', 'Chuyen khoan', 'Bac Ninh', '0987654324')
insert into tblNhaCungCap
values('Cong ty moi gioi bat dong san', 'Chuyen khoan', 'Thanh Hoa', '0987654325')

select * from tblNhaCungCap

delete from tblNhaCungCap
where sTenGiaoDich = 'Chuyen khoan'
--2.3, Chen 10 ban ghi vao tblMatHang
go
--sDonViTinh chi nhan cac gia tri: 'Hop', 'Cai', 'Chiec'

select * from tblNhaCungCap
select * from tblLoaiHang

insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH001','But chi', 100, 5000, 'cai', 11, 'LH002')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH002','But bi', 200, 3000, 'cai', 12, 'LH002')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH003','Tay', 150, 4500, 'cai', 12, 'LH002')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH004','But xoa', 50, 10000, 'cai', 12, 'LH002')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH005','Lego', 100, 100000, 'hop', 11, 'LH003')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH006','Hop but', 10, 250000, 'hop', 12, 'LH001')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH007','Nuoc hoa', 30, 45000, 'hop', 14, 'LH002')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH008','Quan ao', 80, 75000, 'chiec', 13, 'LH001')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH009','Got but chi', 50, 7500, 'cai',12, 'LH001')
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH010','Oto Hotwheel', 100, 20000, 'cai',11, 'LH003')

delete from tblMatHang
where sDonViTinh = 'hop'
--2.4
go
select * from tblMatHang
go
update tblMatHang set fSoLuong = 10 where sDonViTinh = 'cai'

--2.5
insert into tblKhachHang
values(1,'Pham Nam', 'Thai Binh', '0123456789', '1')
insert into tblKhachHang
values(2,'Huy Quyen', 'Cat Linh', '0123456788', '1')
insert into tblKhachHang
values(3,'Hoang Nv', 'Nghe An', '0123456787', '1')
insert into tblKhachHang
values(4,'Anh Ngoc', 'Lien Ha', '0123456786', '0')
insert into tblKhachHang
values(5,'Khanh Huyen', 'Bac Giang', '0123456785', '0')

--2.6
insert into tblNhanVien
values(1, 'Nguyen Quang Anh', 'Ha Noi', '0936094129', '20031018', '20100101', 23000000, 100000, '001203007862')
insert into tblNhanVien
values(2, 'Nguyen Anh Ngoc', 'Lien Ha', '0987123456', '20030904', '20180101', 23000000, 100000, '001203000001')
insert into tblNhanVien
values(3, 'Pham Hai Nam', 'Thai Binh', '0989898989', '20031015', '20211015', 20000000, 100000, '001203000002')
insert into tblNhanVien
values(4, 'Nguyen Viet Hoang', 'Nghe An', '0355091274', '20030102', '20150430', 17000000, 100000, '001203000003')
insert into tblNhanVien
values(5, 'Nguyen Huy Quyen', 'Cat Linh', '0936094124', '20031012', '20190108', 15000000, 100000, '001203000004')
insert into tblNhanVien
values(6, 'Le Van Quang Huy', 'Co Loa', '0936094129', '20031027', '20130911', 26000000, 100000, '001203000005')
insert into tblNhanVien
values(7, 'Ngo Chi Viet', 'Vinh Phuc', '0936094129', '20030329', '20130110', 50000000, 100000, '001203000006')
insert into tblNhanVien
values(8, 'Nguyen Thi Doan Trang', 'Bac Ninh', '0936094129', '20030508', '20100805', 35000000, 100000, '001203000007')
insert into tblNhanVien
values(9, 'Tran Minh Tam', 'Thai Binh', '0936094129', '20031221', '20200922', 12000000, 100000, '001203000008')
insert into tblNhanVien
values(10, 'Than Khanh Huyen', 'Bac Giang', '0936094129', '20030210', '20170103', 27000000, 100000, '001203000009')

select*from tblNhanVien

delete tblNhanVien where iMaNV = '3'
--2.7
go
update tblNhanVien set fPhuCap=500000 where DATEDIFF(year, dNgayVaoLam, getdate()) > 5

--2.8
update tblNhanVien set dNgaySinh='19951018' where iMaNV = 9
delete tblNhanVien where DATEDIFF(year, dNgaySinh, getdate()) < 20

--2.9
insert into tblDonDatHang
values(1,7,5,'20180101','20180102','Ha Noi')
insert into tblDonDatHang
values(2,1,4,'20180201','20190302','Ha Noi')
insert into tblDonDatHang
values(3,1,3,'20180301','20190102','Ha Noi')
insert into tblDonDatHang
values(4,1,2,'20180401','20190102','Ha Noi')
insert into tblDonDatHang
values(5,7,1,'20180801','20190102','Ha Noi')
insert into tblDonDatHang
values(6,5,2,'20190601','20191202','Ha Noi')
insert into tblDonDatHang
values(7,5,3,'20191201','20200102','Ha Noi')
insert into tblDonDatHang
values(8,5,4,'20191001','20220102','Ha Noi')

select * from tblDonDatHang

--2.10
insert into tblChiTietDatHang
values(1,'MH001', 20000, 4, 0.1)
insert into tblChiTietDatHang
values(1,'MH002', 12000, 4, 0.1)
insert into tblChiTietDatHang
values(1,'MH003', 3400, 1, 0.1)

insert into tblChiTietDatHang
values(2,'MH005', 500000, 5, 0.1)
insert into tblChiTietDatHang
values(2,'MH010', 200000, 10, 0.1)
insert into tblChiTietDatHang
values(2,'MH004', 30000, 3, 0.1)

insert into tblChiTietDatHang
values(3,'MH008', 150000, 2, 0.1)
insert into tblChiTietDatHang
values(3,'MH003', 9000, 2, 0.1)
insert into tblChiTietDatHang
values(3,'MH005', 300000, 3, 0.1)

insert into tblChiTietDatHang
values(4,'MH001', 20000, 4, 0.1)
insert into tblChiTietDatHang
values(4,'MH002', 12000, 4, 0.1)
insert into tblChiTietDatHang
values(4,'MH003', 3400, 1, 0.1)

insert into tblChiTietDatHang
values(5,'MH001', 20000, 4, 0.1)
insert into tblChiTietDatHang
values(5,'MH002', 12000, 4, 0.1)
insert into tblChiTietDatHang
values(5,'MH003', 3400, 1, 0.1)

--2.11 Cap nhat muc giam gia la 10% cho cac don hang duoc lap vao thang 9 nam 2019
update tblChiTietDatHang
set fMucGiamGia = 0.1
from tblDonDatHang, tblChiTietDatHang
where tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD and month(dNgayDatHang)>=9 and year(dNgayDatHang)=2019

--2.12 Chen 5 ban ghi vao bang tblDonnhaphang
insert into tblDonNhapHang
values (01, 1, '20210101')
insert into tblDonNhapHang
values (02, 3, '20210102')
insert into tblDonNhapHang
values (03, 5, '20220103')
insert into tblDonNhapHang
values (04, 7, '20220104'),
(05, 9, '20220105')

--2.13 Chen cac ban ghi vao bang tblChiTietNhapHang(chen cho 5 hoa don-3 mat hang moi hoa don)
insert into tblChiTietNhapHang
values(01, 3000, 5, 'MH001'),
(01, 2000, 10, 'MH002'),
(01, 3000, 6, 'MH003'),
(02, 7000, 7, 'MH004'),
(02, 60000, 8, 'MH005'),
(02, 150000, 9, 'MH006'),
(03, 30000, 10, 'MH007'),
(03, 50000, 1, 'MH008'),
(03, 6000, 2, 'MH009'),
(04, 2500, 3, 'MH001'),
(04, 1000, 4, 'MH002'),
(04, 3000, 5, 'MH003'),
(05, 7500, 6, 'MH004'),
(05, 30000, 7, 'MH005'),
(05, 170000, 8, 'MH006')

select*from tblDonNhapHang
select*from tblLoaiHang
select*from tblNhaCungCap
select*from tblMatHang
select*from tblKhachHang
select*from tblNhanVien
select*from tblDonDatHang
select*from tblChiTietDatHang

--buoi 3
--3.1: Cho danh sach cac Khach hang nam o "Ha Noi"
select *
from tblKhachHang
where bGioiTinh = 1 and sDiaChi = 'Thai Binh'
--Ha Noi -> Thai Binh

--3.2: Cho danh sach ten cac nhan vien da di lam duoc >10 nam va luong tren 10 trieu
select iMaNV, sTenNV
from tblNhanVien
where DATEDIFF(year, dNgayVaoLam, getdate())>10 and fLuongPhuCap > 10000000

--3.3: Cho biet ten mat hang cua nha cung cap 'X'
select sMaHang, sTenHang
from tblMatHang, tblNhaCungCap
where tblMatHang.iMaNCC = tblNhaCungCap.iMaNCC and tblNhaCungCap.sTenNhaCC = 'Cong ty do choi'
--X -> Cong ty do choi

select * from tblNhaCungCap

--3.4: Tinh tong so  tien da ban hang trong nam 2021
select sum((fGiaBan*fSoLuongMua)*(1-fMucGiamGia)) as [Tong tien da ban]
from tblChiTietDatHang, tblDonDatHang
where tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD and year(dNgayDatHang)='2018'
--2021 -> 2018

--3.5: Cho biet ten cac mat hang ban duoc trong nam 2021
select stenHang
from tblMatHang, tblChiTietDatHang, tblDonDatHang
where tblMatHang.sMaHang = tblChiTietDatHang.sMaHang and tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD and year(dNgayDatHang)='2021'
group by stenHang

--3.6: Cho biet ten cac met hang khong ban duoc trong nam 2021
select stenHang
from tblMatHang, tblChiTietDatHang, tblDonDatHang
where tblMatHang.sMaHang = tblChiTietDatHang.sMaHang and tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD and not year(dNgayDatHang)='2021'
group by stenHang

--3.7: Cho biet trong nam 2021, nhung mat hang nao chi mua dung 1 lan
select stenHang
from tblMatHang, tblChiTietDatHang, tblDonDatHang
where tblMatHang.sMaHang = tblChiTietDatHang.sMaHang and tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD and year(dNgayDatHang)='2018'
group by tblMatHang.stenHang
having count(tblChiTietDatHang.iSoHD)=1
--2021 -> 2018
--3.8: Thong ke tong hop theo tung don dat hang, gom: so don dat hang, ngay dat hang, tong so tien, tong so mat hang - vvTongHopDonDat_MSV
alter view vvTongHopDonDat_21A100100033 as
select tblDonDatHang.iSoHD,
	count(tblChiTietDatHang.iSoHD) as [So don dat hang],
	sum((tblChiTietDatHang.fGiaBan*tblChiTietDatHang.fSoLuongMua)*(1-tblChiTietDatHang.fMucGiamGia)) as [Tong so tien],
	count(tblMatHang.sMaHang) as [Tong so mat hang]
from tblChiTietDatHang, tblDonDatHang, tblMatHang
where tblChiTietDatHang.iSoHD=tblDonDatHang.iSoHD and tblChiTietDatHang.sMaHang=tblMatHang.sMaHang
group by tblDonDatHang.iSoHD

select * from vvTongHopDonDat_21A100100033

--3.9: Liet ke cac nhan vien co phu cap -> vvNVPhuCap_MSV
create view vvNVPhuCap_21A100100033 as
select * from tblNhanVien
where not tblNhanVien.fPhuCap=0

select * from vvNVPhuCap_21A100100033

--3.10: Cho biet so luong va tong tien da ban cua tung mat hang trong nam 2021 -> vvTKeMatHangBan2021_MSV
create view vvTKeMatHang2021_21A100100033 as
select MH.stenHang as [Ten hang],
	sum(CTDH.fSoLuongMua) as [So luong],
	sum((CTDH.fGiaBan*CTDH.fSoLuongMua)*(1-CTDH.fMucGiamGia)) as [Tong tien]
from tblChiTietDatHang CTDH, tblDonDatHang DDH, tblMatHang MH
where CTDH.iSoHD=DDH.iSoHD and CTDH.sMaHang=MH.sMaHang and year(DDH.dNgayDatHang)='2018'
group by MH.stenHang
--2021 -> 2018
select * from vvTKeMatHang2021_21A100100033

--3.11: Cho biet ten mat hang da ban duoc > 15tr tien hang trong nam 2021 -> vvTKeMatHangBan2021_15tr_MSV
create view vvTKeMatHangBan2021_15tr_21A100100033 as
select MH.stenHang as [Ten hang],
	sum((CTDH.fGiaBan*CTDH.fSoLuongMua)*(1-CTDH.fMucGiamGia)) as [Tong tien]
from tblChiTietDatHang CTDH, tblDonDatHang DDH, tblMatHang MH
where CTDH.iSoHD=DDH.iSoHD and CTDH.sMaHang=MH.sMaHang and year(DDH.dNgayDatHang)='2018'
group by MH.stenHang
having sum((CTDH.fGiaBan*CTDH.fSoLuongMua)*(1-CTDH.fMucGiamGia))>150000

select * from vvTKeMatHangBan2021_15tr_21A100100033
--2021 -> 2018
--15tr -> 150k

--buoi 4:
/* Tao thu tuc
create proc proc_name
as
sql_statement
*/
--chay: exec proc_name
--4.1: tao thu tuc chen them mot Khach hang moi (ktra dieu kien)
create proc them_KhachHang 
	@MaKH int,
	@TenKH nvarchar(30),
	@DiaChi nvarchar(50),
	@DienThoai varchar(12),
	@GioiTinh bit
as 
if exists (select * from tblKhachHang
where iMaKH = @MaKH)
	print ('Khach hang da ton tai');
else
begin 
	insert into tblKhachHang
	values (@MaKH, @TenKH, @DiaChi, @DienThoai, @GioiTinh)
end
--thuc thi lenh
exec  them_KhachHang
	@MaKH = 6,
	@TenKH = 'Quang Anh',
	@DiaChi = 'Ha Noi',
	@DienThoai = '0936094129',
	@GioiTinh = 1
--thuc thi lenh cach 2
exec them_KhachHang 6, 'Quang Anh', 'Ha Noi', '0936094129', 1
--check lai bang khach hang
select * from tblKhachHang

--4.2: Tao thu tuc chen them 1 Mat hang moi (ktra dieu kien)
create proc them_MatHang
	@MaHang varchar(10),
	@TenHang nvarchar(30),
	@MaNCC int,
	@MaLoaiHang varchar(10),
	@SoLuong float,
	@DonViTinh nvarchar(10),
	@GiaHang float
as
if exists (select * from tblMatHang where sMaHang = @MaHang)
	print ('Da ton tai mat hang')
else
begin
	insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
	values(@MaHang,@TenHang,@SoLuong,@GiaHang,@DonViTinh,@MaNCC,@MaLoaiHang)
end
--thuc thi lenh
exec them_MatHang 'MH011', 'Son', 10, 350000, 'cai', 14,'LH002'
--check lai bang mat hang
select * from tblMatHang

--4.3: Tao thu tuc chen them 1 Chi tiet dat hang moi (ktra dieu kien)
create proc them_ChiTietDatHang
	@SoHD int,
	@MaHang varchar(20),
	@GiaBan float,
	@SoLuongMua float,
	@MucGiamGia float
as
if exists (select * from tblChiTietDatHang where iSoHD = @SoHD)
print ('Da ton tai don dat hang nay')
else
begin
	insert into tblChiTietDatHang
	values (@SoHD, @MaHang,@GiaBan,@SoLuongMua,@MucGiamGia)
end
--thuc thi lenh
exec them_ChiTietDatHang 6, 'MH011', 400000, 5, 0.1
--check lai bang
select * from tblChiTietDatHang order by iSoHD

--4.4: Tao thu tuc cho danh sach cac mat hang cua mot loai hang nao do theo Ten Loai Hang
create proc dsMatHang_tenLoaiHang @TenLoaiHang varchar(30)
as
begin
	select MH.stenHang as [Ten mat hang],
		MH.fGiaHang as [Gia hang],
		MH.fSoLuong as [So luong],
		MH.sDonViTinh as [Don vi tinh],
		MH.iMaNCC as [Ma nha cung cap]
	from tblLoaiHang LH, tblMatHang MH 
	where sTenLoaiHang = @TenLoaiHang and LH.sMaLoaiHang = MH.sMaLoaiHang
end
--thuc thi lenh
exec dsMatHang_tenLoaiHang 'Do gia dung'

--4.5: Tao thu tuc cho danh sach cac mat hang duoc ban trong nam nao do voi nam la tham so truyen vao
create proc dsMatHang_banTrongNam @nam int
as
begin
	select MH.stenHang as [Ten mat hang],
		MH.fGiaHang as [Gia hang],
		MH.fSoLuong as [So luong],
		MH.sDonViTinh as [Don vi tinh],
		MH.iMaNCC as [Ma nha cung cap]
	from tblMatHang MH, tblDonDatHang DDH, tblChiTietDatHang CTDH
	where year(dNgayGiaoHang) = @nam and MH.sMaHang = CTDH.sMaHang and DDH.iSoHD = CTDH.iSoHD
end
--thuc thi lenh
exec dsMatHang_banTrongNam 2019

--4.6: Tao thu tuc tang luong x1.5 cho cac nhan vien da ban hang voi so luong hang nhieu hon so luong hang duoc truyen vao voi so luong hang la tham so truyen vao
alter view nv_soLuongBan as
select NV.iManV, sum(CTDH.fSoLuongMua) as [soLuongMua]
from tblNhanVien NV 
inner join tblDonDatHang DDH on NV.iMaNV = DDH.iMaNV
inner join tblChiTietDatHang CTDH on DDH.iSoHD = CTDH.iSoHD
group by NV.iMaNV

select * from nv_soLuongBan

alter proc tangLuongNV_theoSLBanHang @SoLuongHang float
as
begin
	update tblNhanVien set fLuongPhuCap = fLuongPhuCap * 1.5
	from tblNhanVien NV, nv_soLuongBan vvSLBan
	where vvSLBan.soLuongMua > @SoLuongHang and NV.iMaNV = vvSLBan.iMaNV
end
--giam luong
alter proc giamLuongNV_theoSLBanHang @SoLuongHang int
as
begin
	update tblNhanVien set fLuongPhuCap = fLuongPhuCap * 2 / 3
	from tblNhanVien NV, nv_soLuongBan vvSLBan
	where vvSLBan.soLuongMua <= @SoLuongHang and NV.iMaNV = vvSLBan.iMaNV
end

select * from tblNhanVien as NV
inner join tblDonDatHang DDH on NV.iMaNV = DDH.iMaNV
	inner join tblChiTietDatHang CTDH on DDH.iSoHD = CTDH.iSoHD
--thuc thi lenh
exec tangLuongNV_theoSLBanHang 17
exec giamLuongNV_theoSLBanHang 17

select * from tblNhanVien
select * from tblDonDatHang
select * from tblChiTietDatHang

/*4.7: Tao thu tuc cho biet ten cac thong tin gom:
[ten mat hang, so luong, don gia, thanh tien]
cua cac mat hang trong mot hoa don nao do theo ma hoa don*/
create proc dsMatHang_maHoaDon @MaHoaDon int
as
begin
	select MH.sTenHang as [Ten mat hang],
	MH.fSoLuong as [So luong],
	MH.fGiaHang as [Don gia],
	MH.fSoLuong*MH.fGiaHang as [Thanh tien]
	from tblMatHang MH inner join tblChiTietDatHang CTDH on MH.sMaHang = CTDH.sMaHang
	where CTDH.iSoHD = @MaHoaDon
end
--thuc thi lenh
exec dsMatHang_maHoaDon 3

--4.8: Tao thu tuc cho biet ten khach hang da mua hang trong mot thang, mot nam nao do
create proc tenKhachHang_thangNam @thang int, @nam int
as
begin
	select KH.sTenKH as [Ten khach hang],
	@thang as [Thang], @nam as [Nam]
	from tblKhachHang KH inner join tblDonDatHang DDH on KH.iMaKH = DDH.iMaKH
	where month(dNgayGiaoHang) = @thang and year(dNgayGiaoHang) = @nam
end
--thuc thi lenh
exec tenKhachHang_thangNam 1, 2022
--check lai
select * from tblDonDatHang

/*4.9: Tao thu tuc cho biet
[Ten, tong so luong da ban, tong tien da ban] cua 1 mat hang trong mot nam nao do*/
--tao view mat hang
create view vvMatHang_daBan as
select MH.stenHang as [TenHang],
	sum(CTDH.fSoLuongMua) as [SoLuongMua],
	sum(CTDH.fGiaBan*CTDH.fSoLuongMua*(1-CTDH.fMucGiamGia)) as [TongTien],
	DDH.dNgayGiaoHang as [NgayDat]
from tblMatHang MH, tblChiTietDatHang CTDH, tblDonDatHang DDH
where MH.sMaHang = CTDH.sMaHang and DDH.iSoHD = CTDH.iSoHD
group by MH.stenHang, DDH.dNgayGiaoHang
--check view
select * from vvMatHang_daBan
select * from tblDonDatHang
select * from tblChiTietDatHang
order by iSoHD
--tao thu tuc
create proc matHang_nam @nam int
as
begin
	select MH.TenHang as [Ten hang],
		MH.SoLuongMua as [Tong so luong da ban],
		MH.TongTien as [Tong tien da ban]
	from vvMatHang_daBan MH
	where year(MH.NgayDat) = @nam
end
--thuc thi lenh
exec matHang_nam 2019

--4.10: Tao thu tuc cho ten cac khach hang da den mua hang voi so tien lon hon mot so nao do va trong mot nam nao do
--tao thu tuc
create proc tenKH_tongTien_nam @TongTien float, @Nam int
as
begin
	select KH.sTenKH as [TenKH],
		sum(CTDH.fGiaBan*CTDH.fSoLuongMua*(1-CTDH.fMucGiamGia)) as [TongTien],
		DDH.dNgayDatHang as [NgayMua]
	from tblKhachHang KH, tblDonDatHang DDH, tblChiTietDatHang CTDH
	where KH.iMaKH = DDH.iMaKH and DDH.iSoHD = CTDH.iSoHD
	group by KH.sTenKH, DDH.dNgayDatHang
	having sum(CTDH.fGiaBan*CTDH.fSoLuongMua*(1-CTDH.fMucGiamGia)) > @TongTien and year(DDH.dNgayDatHang) = @Nam
end
--thuc thi lenh
exec tenKH_tongTien_nam 100000, 2019