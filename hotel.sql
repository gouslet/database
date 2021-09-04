CREATE TABLE IF NOT EXISTS `Hotel`(
    `hotel_no` INT(11) AUTO_INCREMENT PRIMARY key,
    `hotel_name` VARCHAR(60),
    `city` VARCHAR(60)
);
CREATE TABLE IF NOT EXISTS `Room`(
    `room_no` INT(11) AUTO_INCREMENT,
    `hotel_no` INT(11),
    type VARCHAR(11),
    `price` INT(11),
    PRIMARY KEY(`room_no`,`hotel_no`),
    constraint `hotel_room`
    FOREIGN KEY fk_hotel(`hotel_no`)
    REFERENCES Hotel(`hotel_no`)
);
CREATE TABLE IF NOT EXISTS `Booking`(
    `hotel_no` INT(11),
    `guest_no` INT(11),
    `date_from` DATE NOT NULL,
    `date_to` DATE NOT NULL,
    `room_no` INT(11),
    PRIMARY KEY(`hotel_no`,`guest_no`,`room_no`),
    constraint `booking_hotel`
    FOREIGN KEY fk_hotel(`hotel_no`)
    REFERENCES Hotel(`hotel_no`),
    constraint `booking_guest`
    FOREIGN KEY fk_guest(`guest_no`)
    REFERENCES Guest(`guest_no`),
    constraint `booking_room`
    FOREIGN KEY fk_room(`room_no`)
    REFERENCES Room(`room_no`)
);
CREATE TABLE IF NOT EXISTS Guest(
    `guest_no` INT(11) AUTO_INCREMENT PRIMARY key,
    `guest_name` VARCHAR(20),
    `guest_address` VARCHAR(60)
);