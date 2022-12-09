--buoi 2
use THSQL_NguyenQuangAnh_21A100100033

/*Lenh chen gia tri vao bang
insert into table_name ( col1, col2, col3,... )
values( value1, value2, value3,... )
*/
/*Lenh cap nhat thong tin cho bang
update table_name
set column1 = value1, column2 = value2,...
where condition
*/
/*Lenh xoa
delete from table_name where condition
*/
--2.1, Chen 3 ban ghi vao tblLoaiHang
go
insert into tblLoaiHang
values('LH001','Do gia dung'),
('LH002','Do tieu thu'),
('LH003','Do choi')
--2.2, Chen 5 ban ghi vao tblNhaCungCap
go

insert into tblNhaCungCap(sTenNhaCC,sTenGiaoDich,sDiaChi,sDienThoai)
values('Cong ty do choi', 'Chuyen khoan', 'Ha Noi', '0987654321'),
('Cong ty quan ao', 'Chuyen khoan', 'Ha Nam', '0987654322'),
('Cong ty gia dung', 'Chuyen khoan', 'Ha Tinh', '0987654323'),
('Cong ty my pham', 'Chuyen khoan', 'Bac Ninh', '0987654324'),
('Cong ty moi gioi bat dong san', 'Chuyen khoan', 'Thanh Hoa', '0987654325')

--2.3, Chen 10 ban ghi vao tblMatHang
--sDonViTinh chi nhan cac gia tri: 'Hop', 'Cai', 'Chiec'
go
insert into tblMatHang(sMaHang,stenHang,fSoLuong,fGiaHang,sDonViTinh, iMaNCC, sMaLoaiHang)
values('MH001','But chi', 100, 5000, 'cai', 11, 'LH002'),
('MH002','But bi', 200, 3000, 'cai', 12, 'LH002'),
('MH003','Tay', 150, 4500, 'cai', 12, 'LH002'),
('MH004','But xoa', 50, 10000, 'cai', 12, 'LH002'),
('MH005','Lego', 100, 100000, 'hop', 11, 'LH003'),
('MH006','Hop but', 10, 250000, 'hop', 12, 'LH001'),
('MH007','Nuoc hoa', 30, 45000, 'hop', 14, 'LH002'),
('MH008','Quan ao', 80, 75000, 'chiec', 13, 'LH001'),
('MH009','Got but chi', 50, 7500, 'cai',12, 'LH001'),
('MH010','Hop but mau', 100, 20000, 'cai',11, 'LH003')

--2.4, Cap nhat so luong cho cac mat hang co don vi lai "cai" voi gia tri la 10
go
update tblMatHang set fSoLuong = 10 where sDonViTinh = 'cai'

--2.5, Chen 5 ban ghi vao bang tblKhachHang
--Yeu cau co du gioi tinh 'nam' va 'nu'
insert into tblKhachHang
values(1,'Ong A', 'Thai Binh', '0123456789', '1'),
(2,'Ong B', 'Cat Linh', '0123456788', '1'),
(3,'Ong C', 'Nghe An', '0123456787', '1'),
(4,'Ba D', 'Ha Noi', '0123456786', '0'),
(5,'Ba E', 'Bac Giang', '0123456785', '0')

--2.6
insert into tblNhanVien
values(1, 'Anh A', 'Ha Noi', '0936094129', '20031018', '20100101', 23000000, 100000, '001203007862')
insert into tblNhanVien
values(2, 'Anh B', 'Ha Noi', '0987123456', '20030904', '20180101', 23000000, 100000, '001203000001')
insert into tblNhanVien
values(3, 'Anh C', 'Thai Binh', '0989898989', '20031015', '20211015', 20000000, 100000, '001203000002')
insert into tblNhanVien
values(4, 'Anh D', 'Nghe An', '0355091274', '20030102', '20150430', 17000000, 100000, '001203000003')
insert into tblNhanVien
values(5, 'Anh E', 'Cat Linh', '0936094124', '20031012', '20190108', 15000000, 100000, '001203000004')
insert into tblNhanVien
values(6, 'Chi F', 'Co Loa', '0936094129', '20031027', '20130911', 26000000, 100000, '001203000005')
insert into tblNhanVien
values(7, 'Chi G', 'Vinh Phuc', '0936094129', '20030329', '20130110', 50000000, 100000, '001203000006')
insert into tblNhanVien
values(8, 'Chi H', 'Bac Ninh', '0936094129', '20030508', '20100805', 35000000, 100000, '001203000007')
insert into tblNhanVien
values(9, 'Chi I', 'Thai Binh', '0936094129', '20031221', '20200922', 12000000, 100000, '001203000008')
insert into tblNhanVien
values(10, 'Chi K', 'Bac Giang', '0936094129', '20030210', '20170103', 27000000, 100000, '001203000009')

--2.7, Cap nhat phu cap la 500000 cho cac nhan vien da di lam tren 5 nam
go
update tblNhanVien set fPhuCap=500000 where DATEDIFF(year, dNgayVaoLam, getdate()) > 5

--2.8, Xoa cac nhan vien co tuoi duoi 20

delete tblNhanVien where DATEDIFF(year, dNgaySinh, getdate()) < 20

--2.9, Chen 8 ban ghi vao tblDonDatHang
insert into tblDonDatHang
values(1,7,5,'20180101','20180102','Ha Noi'),
(2,1,4,'20180201','20190302','Ha Noi'),
(3,1,3,'20180301','20190102','Ha Noi'),
(4,1,2,'20180401','20190102','Ha Noi'),
(5,7,1,'20180801','20190102','Ha Noi'),
(6,5,2,'20190601','20191202','Ha Noi'),
(7,5,3,'20191201','20200102','Ha Noi'),
(8,5,4,'20191001','20220102','Ha Noi')

--2.10, Chen cac ban ghi vao bang tblChiTietDatHang (Chen cho 5 hoa don)
insert into tblChiTietDatHang
values(1,'MH001', 20000, 4, 0.1),
(1,'MH002', 12000, 4, 0.1),
(1,'MH003', 3400, 1, 0.1)

insert into tblChiTietDatHang
values(2,'MH005', 500000, 5, 0.1),
(2,'MH010', 200000, 10, 0.1),
(2,'MH004', 30000, 3, 0.1)

insert into tblChiTietDatHang
values(3,'MH008', 150000, 2, 0.1),
(3,'MH003', 9000, 2, 0.1),
(3,'MH005', 300000, 3, 0.1)

insert into tblChiTietDatHang
values(4,'MH001', 20000, 4, 0.1),
(4,'MH002', 12000, 4, 0.1),
(4,'MH003', 3400, 1, 0.1)

insert into tblChiTietDatHang
values(5,'MH001', 20000, 4, 0.1),
(5,'MH002', 12000, 4, 0.1),
(5,'MH003', 3400, 1, 0.1)

--2.11 Cap nhat muc giam gia la 10% cho cac don hang duoc lap vao thang 9 nam 2019
update tblChiTietDatHang
set fMucGiamGia = 0.1
from tblDonDatHang, tblChiTietDatHang
where tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD and month(dNgayDatHang)=9 and year(dNgayDatHang)=2019

--2.12 Chen 5 ban ghi vao bang tblDonnhaphang
insert into tblDonNhapHang
values (01, 1, '20180101'),
(02, 3, '20180202'),
(03, 5, '20190303'),
(04, 7, '20190404'),
(05, 9, '20190505')

--2.13 Chen cac ban ghi vao bang tblChiTietNhapHang(chen cho 5 hoa don - 3 mat hang moi hoa don)
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

select*from tblLoaiHang
select*from tblMatHang
select*from tblNhaCungCap
select*from tblNhanVien
select*from tblKhachHang
select*from tblDonDatHang
select*from tblChiTietDatHang
select*from tblDonNhapHang
select*from tblChiTietNhapHang