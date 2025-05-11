--PHẦN BÀI TẬP CÁ NHÂN
--- HOÀNG ĐỨC HIẾU:
--Câu 1: Liệt kê khách hàng đã ký từ 1 hợp đồng trở lên và tổng chi phí các hợp đồng đó từ 100 nghìn trở lên
SELECT KH.MAKH, KH.TenKH, COUNT(HD.SoHD) AS SoHopDong, SUM(HD.TongChiPhi) AS TongChiPhi
FROM KHACHHANG KH
JOIN HOPDONG HD ON KH.MAKH = HD.MAKH
GROUP BY KH.MAKH, KH.TenKH
HAVING COUNT(HD.SoHD) >= 1 AND SUM(HD.TongChiPhi) >= 100000;

--Câu 2: Tìm các thành phố có ghế lại và tổng thời gian ở lại của các lịch trình (từ bảng LICHTRINH) vượt quá 1 ngày
SELECT TP.TenTP, COUNT(LT.MALT) AS SoLichTrinh, SUM(TP.TGianOLai) AS TongThoiGianOLai
FROM LICHTRINH LT
JOIN THANHPHO TP ON LT.MATP = TP.MATP
WHERE TP.CoGheLai = 1
GROUP BY TP.TenTP
HAVING SUM(TP.TGianOLai) >= 1;

--Câu 3: Tìm các loại bữa ăn có đơn giá cao hơn mức trung bình và có từ 5 khẩu phần trở lên
SELECT LoaiBuaAn, SoKhauPhan, DonGia
FROM BUAAN
WHERE DonGia > (
    SELECT AVG(DonGia) FROM BUAAN
) AND SoKhauPhan >= 5;

--Câu 4: Liệt kê các lịch trình có điểm đến là thành phố tên 'Đà Nẵng'
SELECT LT.MALT, TP.TenTP, LT.NgayGioDen, LT.NgayGioDi
FROM LICHTRINH LT
JOIN THANHPHO TP ON LT.MATP = TP.MATP
WHERE TP.TenTP = N'Đà Nẵng';

--Câu 5: Liệt kê thông tin các lịch trình đi qua thành phố có tên bắt đầu bằng chữ 'H' và khách sạn có trên 3 phòng đôi
SELECT LT.MALT, TP.TenTP, KS.TenKS, LT.NgayGioDen, LT.NgayGioDi
FROM LICHTRINH LT
JOIN THANHPHO TP ON LT.MATP = TP.MATP
JOIN KHACHSAN KS ON LT.MAKS = KS.MAKS
WHERE TP.TenTP LIKE N'H%' AND KS.SoPhongDoi > 3;

--- TRẦN THỊ HẢI MY:
 --Câu 1: Lấy thông tin hợp đồng, khách hàng và bữa ăn tương ứng
SELECT HD.SoHD, KH.TenKH, BA.LoaiBuaAn, BA.DonGia
FROM HOPDONG HD
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
JOIN BUAAN BA ON HD.SoHD = BA.SoHD;
--Câu 2: Cập nhật đơn giá các bữa ăn có số khẩu phần > 10: tăng 10%
UPDATE BUAAN
SET DonGia = DonGia * 1.10
WHERE SoKhauPhan > 10;

--Câu 3: Xóa các bữa ăn có đơn giá dưới mức trung bình
DELETE FROM BUAAN
WHERE DonGia < (
    SELECT AVG(DonGia) FROM BUAAN
);

--Câu 4: Tổng số ngày ở lại theo từng thành phố có thời gian ở lại > 2
SELECT TenTP, SUM(TGianOLai) AS TongNgay
FROM THANHPHO
GROUP BY TenTP
HAVING SUM(TGianOLai) > 2;

--Câu 5: Lấy tên khách hàng có chi phí hợp đồng cao nhất
SELECT TenKH
FROM KHACHHANG
WHERE MAKH = (
    SELECT TOP 1 MAKH
    FROM HOPDONG
    ORDER BY TongChiPhi DESC
);
--- LỮ THỊ KIỂU OANH:
--Câu 1: Liệt kê tất cả hợp đồng kèm tên khách hàng và tổng chi phí
SELECT 
    HD.SoHD,
    KH.TenKH,
    HD.TongSoNguoi,
    HD.TongChiPhi
FROM HOPDONG HD
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH;
--Câu 2: Cập nhật số trẻ em trong hợp đồng 'HD01' thành 3
UPDATE HOPDONG
SET SoTreEm = 3
WHERE SoHD = 'HD01';

--Câu 3: Xóa khách hàng không có hợp đồng nào (nếu có)
DELETE FROM KHACHHANG
WHERE MAKH NOT IN (SELECT MAKH FROM HOPDONG);

--Câu 4: Tìm tên khách sạn mà đoàn khách trong hợp đồng có tổng số người lớn nhất đã ở
SELECT KS.TenKS
FROM LICHTRINH LT
JOIN KHACHSAN KS ON LT.MAKS = KS.MAKS
WHERE LT.SoHD = (
    SELECT TOP 1 SoHD
    FROM HOPDONG
    ORDER BY TongSoNguoi DESC
);

--Câu 5: Liệt kê các thành phố có tổng thời gian ở lại nhiều hơn 2 ngày trong lịch trình
SELECT TP.TenTP, SUM(TP.TGianOLai) AS TongThoiGianOLai
FROM LICHTRINH LT
JOIN THANHPHO TP ON LT.MATP = TP.MATP
GROUP BY TP.TenTP
HAVING SUM(TP.TGianOLai) > 2;

--- ĐẶNG THỊ THÙY TRANG:
--1. Liệt kê các tour có ghé qua thành phố nhiều hơn hoặc bằng 1 địa điểm tham quan
SELECT H.SoHD, TP.TenTP, COUNT(DISTINCT DTP.MADTQ) AS SoDiemThamQuan
FROM HOPDONG H
JOIN LICHTRINH L ON H.SoHD = L.SoHD
JOIN THANHPHO TP ON L.MATP = TP.MATP
JOIN DIEMTHAMQUAN DTP ON L.MADTQ = DTP.MADTQ
GROUP BY H.SoHD, TP.TenTP
HAVING COUNT(DISTINCT DTP.MADTQ) >= 1;

 
--2. Tính tổng chi phí ăn uống của từng hợp đồng
SELECT H.SoHD, SUM(BA.DonGia * BA.SoKhauPhan) AS TongTienAn
FROM HOPDONG H
JOIN BUAAN BA ON H.SoHD = BA.SoHD
GROUP BY H.SoHD;
 
--3. Liệt kê tên thành phố và tổng thời gian dừng chân tại các điểm tham quan thuộc thành phố đó
SELECT TP.TenTP, SUM(DTP.TGianDungChan) AS TongThoiGianDungChan
FROM THANHPHO TP
JOIN LICHTRINH L ON TP.MATP = L.MATP
JOIN DIEMTHAMQUAN DTP ON L.MADTQ = DTP.MADTQ
GROUP BY TP.TenTP;

--4. Cho biết mã phương tiện và tổng số loại vé máy bay được sử dụng
SELECT PT.MAPT, COUNT(HVMB.MAHVB) AS TongSoHangVe
FROM PHUONGTIEN PT
JOIN HANGVEMAYBAY HVMB
ON PT.MAPT = HVMB.MAPT
GROUP BY PT.MAPT;

--5. Liệt kê các lịch trình có điểm tham quan có giá vé người lớn trên 200.000
SELECT DISTINCT L.MALT, DTP.TenDTQ, DTP.DonGiaNguoiLon
FROM LICHTRINH L
JOIN DIEMTHAMQUAN DTP ON L.MADTQ = DTP.MADTQ
WHERE DTP.DonGiaNguoiLon > 200000;

--- NGUYỄN TRỌNG TRÍ:
--Câu 1: Liệt kê thông tin khách hàng và các thành phố họ đã đi qua:
SELECT KH.TenKH, TP.TenTP, HD.SoHD
FROM KHACHHANG KH
JOIN HOPDONG HD ON KH.MAKH = HD.MAKH
JOIN LICHTRINH LT ON HD.SoHD = LT.SoHD
JOIN THANHPHO TP ON LT.MATP = TP.MATP;

--Câu 2: Cập nhật SoTreEm = 0 cho các hợp đồng của khách hàng ở TP có TGianOLai > 2:
UPDATE HOPDONG
SET SoTreEm = 0
WHERE SoHD IN (
    SELECT LT.SoHD
    FROM LICHTRINH LT
    JOIN THANHPHO TP ON LT.MATP = TP.MATP
    WHERE TP.TGianOLai > 2
);

--Câu 3: Xóa các bữa ăn thuộc hợp đồng có chi phí dưới 5 triệu và loại bữa là "Bữa Sáng":
DELETE FROM BUAAN
WHERE SoHD IN (
    SELECT SoHD FROM HOPDONG WHERE TongChiPhi < 5000000
)
AND LoaiBuaAn = 'Bữa Sáng';

--Câu 4: Liệt kê khách hàng có tổng chi phí hợp đồng lớn hơn chi phí trung bình tất cả hợp đồng:
SELECT KH.TenKH, HD.TongChiPhi
FROM KHACHHANG KH
JOIN HOPDONG HD ON KH.MAKH = HD.MAKH
WHERE HD.TongChiPhi > (
    SELECT AVG(TongChiPhi) FROM HOPDONG
);

--Câu 5: Tính tổng chi phí hợp đồng và số hợp đồng theo từng khách hàng, chỉ hiển thị khách có tổng chi phí > 100000
SELECT KH.TenKH, COUNT(HD.SoHD) AS SoHopDong, SUM(HD.TongChiPhi) AS TongChiPhi
FROM KHACHHANG KH
JOIN HOPDONG HD ON KH.MAKH = HD.MAKH
GROUP BY KH.TenKH
HAVING SUM(HD.TongChiPhi) > 100000;