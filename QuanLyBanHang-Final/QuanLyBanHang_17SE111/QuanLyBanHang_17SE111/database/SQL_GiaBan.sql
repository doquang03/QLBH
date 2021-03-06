--Thủ tục lấy danh sách giá bán của spham
use DatabaseBanHang

Go
create proc PSH_LayDanhSachGiaBan 
as
	select ROW_NUMBER() OVER (ORDER BY(SELECT a.MaSanPham) ) AS STT, a.MaSanPham, b.TenSanPham, b.DonGiaBinhQuan, a.GiaBanHienHanh, c.TenDonViTinh  
	from dbo.GiaBan a JOIN dbo.SanPham b ON b.MaSanPham = a.MaSanPham Join dbo.DonViTinh c  on c.MaDonViTinh = b.MaDonViTinh
	where a.IsDelete = 0
	
	OrDER By a.MaSanPham
	
Go
create proc PSH_Giaban_DoiGiaBan
	 @MaSanPham int,
		@GiaBanHienHanh int,
		@NgayApDung datetime
	as
	Set XACT_ABORT ON
	Begin Tran
	Declare @MaGiaBan int
	Set @MaGiaBan = (Select MaGiaBan from dbo.GiaBan where MaSanPham = @MaSanPham and IsDelete = 0)
		update dbo.GiaBan
		set IsDelete = 1
		where MaGiaBan = @MaGiaBan
		
		insert into GiaBan(MaSanPham, GiaBanHienHanh, NgayApDung, IsDelete)
		values (@MaSanPham, @GiaBanHienHanh, @GiaBanHienHanh, 0 )
	Commit