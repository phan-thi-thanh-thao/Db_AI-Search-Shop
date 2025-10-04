@echo off
echo =================================
echo KIỂM TRA DATABASE AI FASHION SHOP
echo =================================

echo.
echo 1. Khởi động containers...
docker-compose up -d

echo.
echo 2. Chờ database khởi động (10 giây)...
timeout /t 10 /nobreak > nul

echo.
echo 3. Kiểm tra containers đang chạy...
docker ps --filter "name=ai_fashion"

echo.
echo 4. Kiểm tra logs database...
docker logs ai_fashion_db --tail 10

echo.
echo 5. Test kết nối database...
python check_database.py

echo.
echo 6. Kết nối trực tiếp database (tùy chọn)...
echo Chạy lệnh: docker exec -it ai_fashion_db psql -U postgres -d ai_fashion_shop
echo.
pause