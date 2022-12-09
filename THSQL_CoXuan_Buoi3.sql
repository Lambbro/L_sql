--buoi 3
/* Hien thi danh sach
SELECT column1, column2,... 
FROM table_name
WHERE conditions
*/
/* Tao view
CREATE VIEW view_name AS
SELECT column1, column2,... 
FROM table_name
WHERE conditions
*/
/*
SELECT column1, column2,... 
FROM table_name
WHERE conditions
GROUP BY column (group by column nao thi phai select column day)
HAVING groupBy_condition
*/
use THSQL_NguyenQuangAnh_21A100100033
--3.1: Cho danh sach cac Khach hang nam o "Ha Noi"
select *
from tblKhachHang
where bGioiTinh = 1 and sDiaChi = 'Thai Binh'
--Ha Noi -> Thai Binh

--3.2: Cho danh sach ten cac nhan vien da di lam duoc >10 nam va luong tren 10 trieu
select iMaNV, sTenNV
from tblNhanVien
where datediff(year, dNgayVaoLam, getdate())>10 and fLuongPhuCap > 10000000

--3.3: Cho biet ten mat hang cua nha cung cap 'X'
select sMaHang, sTenHang
from tblMatHang MH, tblNhaCungCap NCC
where MH.iMaNCC = NCC.iMaNCC and NCC.sTenNhaCC = 'Cong ty do choi'
--X -> Cong ty do choi

select * from tblNhaCungCap

--3.4: Tinh tong so  tien da ban hang trong nam 2021
select sum((fGiaBan*fSoLuongMua)*(1-fMucGiamGia)) as [Tong tien da ban 2018]
from tblChiTietDatHang CTDH, tblDonDatHang DDH
where CTDH.iSoHD = DDH.iSoHD and year(dNgayDatHang)='2018'
--2021 -> 2018

--3.5: Cho biet ten cac mat hang ban duoc trong nam 2021
select stenHang
from tblMatHang MH, tblChiTietDatHang CTDH, tblDonDatHang DDH
where MH.sMaHang = CTDH.sMaHang and CTDH.iSoHD=DDH.iSoHD and year(dNgayDatHang)='2021'
group by stenHang

--3.6: Cho biet ten cac mat hang khong ban duoc trong nam 2021
select stenHang
from tblMatHang MH, tblChiTietDatHang CTDH, tblDonDatHang DDH
where MH.sMaHang = CTDH.sMaHang and CTDH.iSoHD=DDH.iSoHD and stenHang not in
	(select  stenHang
	from tblMatHang MH, tblChiTietDatHang CTDH, tblDonDatHang DDH
	where MH.sMaHang = CTDH.sMaHang and CTDH.iSoHD=DDH.iSoHD and year(dNgayDatHang)='2021')
group by stenHang

select*from tblDonDatHang
select*from tblMatHang
select*from tblChiTietDatHang

--3.7: Cho biet trong nam 2021, nhung mat hang nao chi mua dung 1 lan
select stenHang
from tblMatHang MH, tblChiTietDatHang CTDH, tblDonDatHang DDH
where MH.sMaHang = CTDH.sMaHang and CTDH.iSoHD=DDH.iSoHD and year(dNgayDatHang)='2018'
group by MH.stenHang
having count(CTDH.iSoHD)=1
--2021 -> 2018
--3.8: Thong ke tong hop theo tung don dat hang, gom: so don dat hang, ngay dat hang, tong so tien, tong so mat hang - vvTongHopDonDat_MSV
alter view vvTongHopDonDat_21A100100033 as
select DDH.iSoHD,
	sum((CTDH.fGiaBan*CTDH.fSoLuongMua)*(1-CTDH.fMucGiamGia)) as [Tong so tien],
	count(MH.sMaHang) as [Tong so mat hang]
from tblChiTietDatHang CTDH, tblDonDatHang DDH, tblMatHang MH
where CTDH.iSoHD=DDH.iSoHD and CTDH.sMaHang=MH.sMaHang
group by DDH.iSoHD

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