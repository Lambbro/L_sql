--buoi 4:
/* Tao thu tuc
create proc proc_name
as
sql_statement
*/
--chay: exec proc_name
use THSQL_NguyenQuangAnh_21A100100033
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