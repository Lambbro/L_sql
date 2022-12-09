--1.a
create database ThucHanhSQL
on 
(
 name = ThucHanhSQL_NguyenVietHoang__2110A104,
 filename = 'd:\SQL\ThucHanhSQL_NguyenVietHoang__2110A104.mdf'

)
use ThucHanhSQL
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
add check (datediff(year,dNgaySinh,dNgayLamViec)>=18)
--1.g
go
alter table tblMatHang
add sDonViTinh varchar(10)
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
--Xong Buoi 1--
--Buoi 2--
--2.1
--2.1.a
go
Insert into tblLoaiHang
values('LH011','shirt')
Insert into tblLoaiHang
values('LH012','trousers')
Insert into tblLoaiHang
values('LH013','shoes')
--2.1.b.c
go
Insert  tblNhaCungCap(sTenNhaCC,sTenGiaoDich,sDiaChi,sDienThoai)
values(N'Nhà Sản Xuất Việt','VCB',N'Hà Nội','0398291882')
Insert  tblNhaCungCap(sTenNhaCC,sTenGiaoDich,sDiaChi,sDienThoai)
values(N'Nhà Cái Việt','TCB',N'Hà Nội','3498291882')
Insert  tblNhaCungCap(sTenNhaCC,sTenGiaoDich,sDiaChi,sDienThoai)
values(N'Nhà Thương ệt','MBB',N'Hà Nội','0334291882')


go
Insert into tblMatHang
values('MH001','Clothes',1,'LH011',200,30000,'vnd')
Insert into tblMatHang
values('MH002','Clothes',2,'LH013',300,25000,'vnd')
Insert into tblMatHang
values('MH003','Clothes',3,'LH012',189,35000,'vnd')
--2.1.d
go
delete tblMatHang
where fSoLuong=0
--2.1.e
go
alter table tblNhanVien
alter column dNgaySinh datetime
go
alter table tblNhanVien
alter column dNgayVaoLam datetime
go
Insert into tblNhanVien(iMaNV,sTenNV,sDiaChi,sDienThoai,dNgaySinh,dNgayVaoLam,fLuongPhuCap,fPhuCap,sCMND)
values(100,N'Nguyễn văn A',N'Hà Nội','0290999293','20010312','20210312',9000000,1000000,'01039230943')
Insert into tblNhanVien(iMaNV,sTenNV,sDiaChi,sDienThoai,dNgaySinh,dNgayVaoLam,fLuongPhuCap,fPhuCap,sCMND)
values(102,N'Nguyễn Dào',N'Hà Nội','0223999321','20020302','20110312',9500000,1500000,'01039555943')
Insert into tblNhanVien(iMaNV,sTenNV,sDiaChi,sDienThoai,dNgaySinh,dNgayVaoLam,fLuongPhuCap,fPhuCap,sCMND)
values(103,N'Nguyễn ThịA',N'Hà Nội','0295634293','20020428','20160405',9000000,1000000,'01033238843')
go
select*from tblNhanVien
update tblNhanVien set fPhuCap=fPhuCap+(fPhuCap*0.1)
where (year(getdate())-year(dNgayVaoLam))>=5
--2.2.a
go
insert into tblKhachHang
values(1,N'Nguyễn Văn Tèo',N'TP HCM', '0387287332',1)
insert into tblKhachHang
values(2,N'Nguyễn Thị èo',N'TP HCM', '0238943232',0)
insert into tblKhachHang
values(3,N'Nguyễn Thị Đậu',N'Hà Nội','0428772991',0)
--2.2b
go 
insert into tblDonDatHang
values(10,100,1,'20220422','20220428',N'Hà Nội')
insert into tblDonDatHang
values(11,102,2,'20210924','20210928',N'Hà Nội')
insert into tblDonDatHang
values(12,103,3,'20210924','20210928',N'Hà Nội')
/*2.2c. Thực hiện với mỗi đơn đặt hàng trong bảng tblDonDatHang cho phép
thêm các chi tiết đơn đặt hàng tương ứng, mỗi đơn đặt hàng có ít nhất 02
mặt hàng được thêm */
go
insert into tblChiTietDatHang
values(10,'MH001',30000,10,0.15)
insert into tblChiTietDatHang
values(10,'MH003',45000,25,0.17)
insert into tblChiTietDatHang
values(11,'MH001',33000,30,0.21)
insert into tblChiTietDatHang
values(11,'MH002',17000,45,0.11)
insert into tblChiTietDatHang
values(12,'MH003',23000,35,0.19)
insert into tblChiTietDatHang
values(12,'MH002',27000,30,0.25)
-- 2.2d. Thực hiện cho phép mức giảm giá là 10% cho các mặt hàng bán trong tháng 7 năm 2016
go
select * from tblDonDatHang
update tblMatHang 
set fGiaHang=fGiaHang-fGiaHang*0.1 from tblDonDatHang 
where(MONTH(dNgayDatHang)=7 and year(dNgayDatHang)=2016)
--2.2.e. Thực hiện xóa các chi tiết hóa đơn đặt hàng của hóa đơn có mã đơn đặt hàng do sinh viên tự xác định
go
delete tblDonDatHang where iSoHD=0
-- 2.3
-- 2.3.a
go
insert into tblDonDatHang
values(13,103,1,'20210623','20210702',N'Hà Nội')
insert into tblDonDatHang
values(14,102,1,'20210629','20210711',N'Hà Nội')
insert into tblDonDatHang
values(15,102,1,'20210615','20210710',N'Hà Nội')
go 
insert into tblChiTietDatHang
values(15,'MH001',5000,20,0.25)
--2.3.b
go
insert into tblLoaiHang
values('LH014',N'Thoi trang')
insert into tblLoaiHang
values('LH015',N'Cham soc suc khoe')
--2.3.c
go 
insert into tblMatHang
values('MH005',N'Quần jean',1,'LH014',10,25000,N'vnđ')
insert into tblMatHang
values('MH006',N'Áo jean',1,'LH014',10,25000,N'vnđ')
insert into tblMatHang
values('MH007',N'Áo thun',1,'LH014',10,25000,N'vnđ')
insert into tblMatHang
values('MH008',N'Quần kaki',1,'LH014',10,25000,N'vnđ')
insert into tblMatHang
values('MH009',N'Quần dan',1,'LH014',10,25000,N'vnđ')
insert into tblMatHang(sMaHang,stenHang,sMaLoaiHang,fSoLuong,fGiaHang,sDonViTinh)
values('MH015',N'Quần áo','LH014',10,25000,N'vnđ')
--2.3.d
go 
insert into tblDonDatHang
values(21,103,1,'20210623','20210702',N'Hà Nội')
insert into tblDonDatHang
values(22,102,2,'20210623','20210702',N'Hà Nội')
insert into tblDonDatHang
values(23,102,3,'20210623','20210702',N'Hà Nội')
-- thêm chi tiết đặt hàng
go
insert into tblChiTietDatHang
values(21,'MH008',20000,19,0.27)
insert into tblChiTietDatHang
values(23,'MH007',20000,19,0.27)
insert into tblChiTietDatHang
values(21,'MH007',20000,19,0.27)
insert into tblChiTietDatHang
values(22,'MH006',20000,19,0.27)
--2.3.e
go
update tblMatHang 
set fGiaHang=(fGiaHang-fGiaHang*0.05)
where sMaLoaiHang!='LH014'
--2.3.f
go
delete from tblLoaiHang
where sTenLoaiHang=N'Cham soc suc khoe'
--
