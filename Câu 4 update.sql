--4. Tự suy nghĩ ra mỗi thành viên 2 câu hỏi truy vấn (không trùng nhau) và giải đáp bằng lệnh SQL 
--1. Truy vấn kết nối nhiều bảng: Liệt kê tên khách hàng, tên thành phố và tên khách sạn trong mỗi lịch trình của họ
SELECT KH.TenKH, TP.TenTP, KS.TenKS
FROM HOPDONG HD
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
JOIN LICHTRINH LT ON HD.SoHD = LT.SoHD
JOIN THANHPHO TP ON LT.MATP = TP.MATP
JOIN KHACHSAN KS ON LT.MAKS = KS.MAKS;
--2.Truy vấn kết nối nhiều bảng: Liệt kê mã hợp đồng, tên khách hàng, tên điểm tham quan và thời gian dừng chân
SELECT HD.SoHD, KH.TenKH, DTQ.TenDTQ, DTQ.TGianDungChan
FROM HOPDONG HD
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
JOIN LICHTRINH LT ON HD.SoHD = LT.SoHD
JOIN DIEMTHAMQUAN DTQ ON LT.MADTQ = DTQ.MADTQ;
--3. Câu lệnh UPDATE: Cập nhật loại khách sạn của "Khách Sạn D" thành "4 Sao"
UPDATE KHACHSAN
SET LoaiKS = '4 Sao'
WHERE TenKS = 'Khách Sạn D';
--4.Câu lệnh UPDATE: Cập nhật địa chỉ khách hàng "Nguyễn Văn A" thành "TP. HCM"
UPDATE KHACHHANG
SET DiaChi = 'TP.HCM'
WHERE TenKH = 'Nguyen Van A';
--5. Câu lệnh DELETE: Xóa điểm tham quan có tên là "Chợ Bến Thành"
DELETE FROM DiemThamQuan
WHERE TenDTQ = 'Chợ Bến Thành';
--6. Câu lệnh DELETE: Xóa khách hàng có số điện thoại là '0912345678'
DELETE FROM KhachHang
WHERE SDT = '0912345678';
--7.Truy vấn GROUP BY: Tính tổng chi phí theo từng mã khách hàng
SELECT KH.TenKH, SUM(HD.TongChiPhi) AS TongChiPhi
FROM HOPDONG HD
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
GROUP BY KH.TenKH;
--8. Truy vấn GROUP BY: Đếm số lượng khách sạn theo từng thành phố
SELECT TP.TenTP, COUNT(DISTINCT KS.MAKS) AS SoLuongKhachSan
FROM LICHTRINH LT
JOIN KHACHSAN KS ON LT.MAKS = KS.MAKS
JOIN THANHPHO TP ON LT.MATP = TP.MATP
GROUP BY TP.TenTP;
--9. Subquery: Liệt kê tên khách hàng đã ký hợp đồng có tổng chi phí lớn hơn 15 triệu
SELECT TenKH
FROM KHACHHANG
WHERE MaKH IN (
    SELECT MaKH
    FROM HOPDONG
    WHERE TongChiPhi > 15000000
);
--10.Subquery: Liệt kê tên khách sạn nằm trong các lịch trình có điểm tham quan là "Phú Quốc"
SELECT TenKS
FROM KHACHSAN
WHERE MAKS IN (
    SELECT MAKS
    FROM LICHTRINH LT
    JOIN DIEMTHAMQUAN DTQ ON LT.MADTQ = DTQ.MADTQ
    WHERE DTQ.TenDTQ = 'Phú Quốc'
);
--11.Truy vấn bất kỳ: Liệt kê tên các khách hàng có hợp đồng khởi hành sau ngày 12/05/2025
SELECT DISTINCT KH.TenKH
FROM KHACHHANG KH
JOIN HOPDONG HD ON KH.MAKH = HD.MAKH
WHERE HD.NgayGioKhoiHanh > '2025-05-12';
--12.Truy vấn bất kỳ: Liệt kê tên các điểm tham quan có đơn giá người lớn trên 200,000 VNĐ
SELECT TenDTQ, DonGiaNguoiLon
FROM DIEMTHAMQUAN
WHERE DonGiaNguoiLon > 200000;




