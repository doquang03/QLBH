IF OBJECT_ID('dbo.PSP_LayTenColumnChiTietNhapHang') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_LayTenColumnChiTietNhapHang;
    END;
GO	
CREATE PROC [dbo].[PSP_LayTenColumnChiTietNhapHang]
AS
    SELECT DISTINCT
            a.name
    FROM    sys.all_columns a
            JOIN sys.tables b ON a.object_id = b.object_id
    WHERE   b.name = 'phieuNhap'
            OR b.name = 'ChiTietPhieuNhap'
            OR b.name = 'sanpham';
GO 
IF OBJECT_ID('dbo.PSP_NhapHang_XoaPhieuNhapThepMaPhieu') IS NOT NULL
    BEGIN
        DROP PROC dbo.PSP_NhapHang_XoaPhieuNhapThepMaPhieu;
    END;
GO	
CREATE PROC PSP_NhapHang_XoaPhieuNhapThepMaPhieu @MaPhieuNhap CHAR(13)
AS
    SET XACT_ABORT ON;
    BEGIN TRAN;
    DECLARE @MaSanPham INT;
    DECLARE _ChiTietPhieuNhap_Cur CURSOR FAST_FORWARD
    FOR
        SELECT  MaSanPham
        FROM    dbo.ChiTietPhieuNhap
        WHERE   MaPhieuNhap = @MaPhieuNhap;
 
    OPEN _ChiTietPhieuNhap_Cur;
    FETCH NEXT FROM _ChiTietPhieuNhap_Cur INTO @MaSanPham; 
    WHILE @@FETCH_STATUS = 0
        BEGIN
            DELETE  dbo.ChiTietPhieuNhap
            WHERE   MaSanPham = @MaSanPham
                    AND MaPhieuNhap = @MaPhieuNhap;
            FETCH NEXT FROM _ChiTietPhieuNhap_Cur INTO @MaSanPham;
        END;
    CLOSE _ChiTietPhieuNhap_Cur;
    DEALLOCATE _ChiTietPhieuNhap_Cur;
    
    DELETE  dbo.PhieuNhap
    WHERE   MaPhieuNhap = @MaPhieuNhap;
    
    COMMIT;
