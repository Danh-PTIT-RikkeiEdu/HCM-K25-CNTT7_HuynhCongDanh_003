create database Bookings_Hotel;
use Bookings_Hotel;

-- Phan 1: 
-- Bang khach hang
-- 1.1 Them bang
-- Bang Khach hang
create table Guests (
	guest_id int primary key auto_increment,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null unique,
    lotalty_points int check(lotalty_points >= 0) default 0
);

-- Bang ho so khach hang
create table Guest_Profiles (
	profile_id int primary key auto_increment,
    guest_id int,
    address varchar(255) not null,
    birthday date not null,
    national_id int not null unique,
    foreign key (guest_id) references Guests(guest_id)
);

-- Bang phong cua khach san
create table Rooms (
	room_id int primary key auto_increment,
    room_name varchar(20) not null,
    room_type varchar(20) not null,
    price_per_night decimal(12, 0) check(price_per_night > 0) not null,
    room_status varchar(50) not null
);

-- Bang dat phong khach san
create table Bookings (
	booking_id int primary key auto_increment,
    guest_id int,
    room_id int,
    check_in_date datetime not null,
    check_out_date datetime not null,
    total_charge decimal(12, 0) check(total_charge > 0),
    booking_status varchar(50) not null,
	foreign key (guest_id) references Guests(guest_id),
    foreign key (room_id) references Rooms(room_id),
    constraint check_in_out check(check_out_date > check_in_date)
);

-- Bang nhat ky cac phong
create table Room_Log (
	log_id int primary key auto_increment,
	room_id int,
    action_type varchar(50) not null,
    change_note varchar(255) not null,
    logged_at datetime default current_timestamp,
    foreign key (room_id) references Rooms(room_id)
);

-- 1.2 DML
-- Them du lieu bang khach hang
insert into Guests (full_name, email, phone, lotalty_points)
values
	('Nguyen Van A', 'anv@gmail.com', '901234567', 150),
    ('Tran Thi B', 'btt@gmail.com', '912345678', 500),
    ('Le Van C', 'cle@yahoo.com', '922334455', 0),
    ('Pham Minh D', 'dpham@hotmail.com', '9334455566', 1000),
    ('Hoang Van E', 'ehoang@gmail.com', '944556677', 20);
	
-- Them du lieu bang ho so khach hang
insert into Guest_Profiles (profile_id, guest_id, address, birthday, national_id)
values
	(101, 1, '123 Le Loi, Q1, HCM', '1990-05-15', 12345),
    (102, 2, '456 Nguyen Hue, Q1, HCM', '1985-10-20', 23456),
    (103, 3, '789 Phan Chu Trinh, Da Nang', '1995-12-01', 34567),
    (104, 4, '101 Hoang Hoa Tham, Ha Noi', '1988-03-25', 45678),
    (105, 5, '202 Tran Hung Dao, Can Tho', '2000-07-10', 56789);
    
-- Them du lieu cho bang phong khach san
insert into Rooms (room_name, room_type, price_per_night, room_status)
values
	('Room 101', 'Standard', 100000, 'Available'),
    ('Room 102', 'Deluxe', 5000000, 'Occupied'),
    ('Room 103', 'Suite', 300000, 'Available'),
    ('Room 104', 'Standard', 200000, 'Occupied'),
    ('Room 105', 'Deluxe', 2000000, 'Maintenance');
    
-- Them du lieu cho bang dat lich
insert into Bookings (booking_id, guest_id, check_in_date, check_out_date, total_charge, booking_status, room_id)
values
	(1001, 1, '2023-11-15 10:30', '2023-11-18 12:00', 300000, 'Completed', 1),
	(1002, 2, '2023-12-01 14:20', '2023-12-04 12:00', 20000000, 'Completed', 2),
	(1003, 1, '2021-01-10 09:15', '2021-01-11 12:00', 5000000, 'Pending', 2),
	(1004, 3, '2023-05-20 16:45', '2023-05-22 12:00', 900000, 'Cancelled', 3),
	(1005, 4, '2024-01-18 11:00', '2024-01-20 12:00', 8000000, 'Completed', 4);
    
-- Them du lieu Bang nhat ky cac phong
insert into Room_Log (room_id, action_type, change_note, logged_at)
values
	(1, 'Check-in', 'Guest checked in', '2023-10-01 08:00'),
    (1, 'Check-out', 'Guest checked out', '2023-11-15 10:35'),
    (4, 'Maintenance', 'Room reported as damaged', '2023-11-20 15:00'),
    (2, 'Check-in', 'New guest arrival', '2023-11-25 09:00'),
    (3, 'Maintenance', 'Schedule maintenance', '2023-12-01 13:00');

-- cong 200 diem khach hang duoi @gmail.com
set SQL_SAFE_UPDATES = 0;
update Guests
set lotalty_points = lotalty_points + 200
where email like '%@gmail.com';
set SQL_SAFE_UPDATES = 1;

-- xoa nhat ky phong trc 2023-11-10
set SQL_SAFE_UPDATES = 0;
delete from Room_Log
where logged_at < '2023-11-10';
set SQL_SAFE_UPDATES = 1;


-- Phan 2:
-- 1
select room_name, price_per_night, room_status from Rooms
where 
	price_per_night > 1000000 or 
	room_status = 'Maintenance' or 
	room_type = 'Suite';
    
-- 2
select full_name, email from Guests
where 
email like '%@gmail.com' and 
lotalty_points >= 50 and
lotalty_points <= 300;

-- 3
select * from Bookings
order by total_charge desc
limit 3 offset 0;


-- Phan 3:
-- 1
select full_name, national_id, booking_id, check_in_date, total_charge 
from Guests g
inner join Guest_Profiles gp on gp.guest_id = g.guest_id
inner join Bookings b on b.guest_id = g.guest_id;

-- 2
select full_name, sum(b.total_charge) as all_payment from Guests g
inner join Bookings b on b.guest_id = g.guest_id
where booking_status = 'Completed'
group by g.full_name
having sum(b.total_charge) > 20000000;
-- Dữ liệu mẫu chỉ có đơn đặt phòng thành công là 20tr
-- Nên > 20tr sẽ ko hiện ra dữ liệu
-- Thầy/Cô có thể thay đổi giá tiền xuống sẽ hiện ra dữ liệu cần tìm ạ

-- 3 
select * from Rooms
where room_id = (
	select room_id from Bookings 
    where booking_status = 'Completed' 
    order by total_charge desc
    limit 1);


-- Phan 4
-- 1
create index idx_booking_status_cgh
on Bookings (booking_status, check_in_date);

-- 2
drop view if exists vw_guest_booking_status;

create view vw_guest_booking_status as
select 
	s.full_name, 
	count(b.guest_id) as total_bookings, 
	sum(b.total_charge) as total_payment
from Guests s
inner join Bookings b on b.guest_id = s.guest_id
where booking_status = 'Pending' or  booking_status = 'Completed'
group by full_name;

select * from vw_guest_booking_status;


-- Phan 5:
-- 1
delimiter //
	
	create trigger trg_after_update_booking_status 
    after update on Bookings
    for each row
    
    begin 
		if new.booking_status = 'Completed' then
			insert into Room_Log (room_id, action_type, change_note, logged_at)
            values 
				(old.room_id, 'Check-out', 'Booking Completed', now());
        end if;
    end //

delimiter ;

-- 2
delimiter //
	
	create trigger trg_update_lotalty_points
    after update on Bookings
    for each row
    
    begin 
		if new.booking_status = 'Completed' then
			update Guests 
            set lotalty_points = lotalty_points + (total_charge / 1000000 * 2)
            where guest_id = old.guest_id;
        end if;
    end //

delimiter ;


-- Phan 6
-- 1
drop procedure if exists sp_get_room_status;
delimiter //
	
	create procedure sp_get_room_status 
		(in p_room_id int, out p_message text)
    
    begin 
		declare v_room_status varchar(50);
        select room_status into v_room_status from Rooms
        where room_id = p_room_id;
        
		if v_room_status = 'Available' then
			set p_message = 'Phòng trống';
		elseif v_room_status = 'Occupied' then
			set p_message = 'Đang có khách';
		elseif v_room_status = 'Maintenance' then
			set p_message = 'Bảo trì';
		end if;
    end //

delimiter ;

call sp_get_room_status(2, @p_message);
select  @p_message;

-- 2
drop procedure if exists sp_cancel_booking;
delimiter //
	
	create procedure sp_cancel_booking 
		(p_booking_id int)
    
    begin 
		declare v_room_id int;
        select Rooms.room_id into v_room_id from Bookings 
        inner join Rooms on rooms.room_id = bookings.room_id
        where 
			Rooms.room_id = bookings.room_id and 
            p_booking_id = bookings.booking_id;
        
		
		start transaction;
			update Bookings 
            set booking_status = 'Cancelled'
            where p_booking_id = booking_id;
            
            update Rooms 
            set room_status = 'Available'
            where v_room_id;
            
			insert into Room_Log (room_id, action_type, change_note, logged_at)
			values
				(v_room_id, 'Cancelled', 'Cancelled', now());
	
        commit;
    end //

delimiter ;

