//
//  TempData.swift
//  TickTok User
//
//  Created by Excellent Webworld on 03/11/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import Foundation

 // Accept Request by Driver
/*
func Accept Request by Driver()
{
    [{
        BookingInfo =     (
            {
                AdminAmount = "";
                BookingCharge = "";
                BookingType = "";
                ByDriverAmount = "";
                ByDriverId = 0;
                CardId = 0;
                CompanyAmount = "";
                CreatedDate = "2017-12-07T11:05:18.000Z";
                Discount = "";
                DistanceFare = "";
                DriverId = 21;
                DropOffLat = "23.030513";
                DropOffLon = "72.5075401";
                DropTime = "";
                DropoffLocation = "Near Rajpath Club, SG Highway, Bodakdev, Ahmedabad, Gujarat 380054, India";
                GrandTotal = "";
                Id = 182;
                ModelId = 1;
                NightFare = "";
                NightFareApplicable = 0;
                Notes = "";
                PassengerContact = "";
                PassengerEmail = "";
                PassengerId = 44;
                PassengerName = "";
                PaymentStatus = "";
                PaymentType = "";
                PickupLat = "23.0734427";
                PickupLng = "72.5170918";
                PickupLocation = "35, Sola Gam Rd, Sola, Ahmedabad, Gujarat 380060, India";
                PickupTime = "";
                PromoCode = "";
                Reason = "";
                Status = accepted;
                SubTotal = "";
                Tax = "";
                TollFee = "";
                TransactionId = "";
                TripDistance = "";
                TripDuration = "";
                TripFare = "";
                WaitingTime = "";
                WaitingTimeCost = "";
            }
        );
        CarInfo =     (
            {
                Color = Black;
                Company = Hummer;
                CompanyId = 1;
                Description = "";
                DriverId = 21;
                Id = 659;
                RegistrationCertificate = "images/driver/21/image5.jpeg";
                RegistrationCertificateExpire = "2017-12-04T00:00:00.000Z";
                VehicleImage = "images/driver/21/image1.jpeg";
                VehicleInsuranceCertificate = "images/driver/21/image4.jpeg";
                VehicleInsuranceCertificateExpire = "2017-12-04T00:00:00.000Z";
                VehicleModel = 4;
                VehicleRegistrationNo = "GJ-01-B-9999";
            }
        );
        Details =     (
            {
                BookingId = 182;
                BookingType = BookNow;
                Distance = "0.125931449550502";
                DriverId = 21;
                Lat = "23.0734427";
                Long = "72.5170918";
                PassengerId = 44;
                Status = 2;
                UpdateTime = 1512624918;
                UpdatedDate = "2017-12-07 05:35:18";
                "_id" = 5a28d316f2e81b701909cf0f;
            }
        );
        DriverInfo =     (
            {
                ABN = 1234556;
                AccreditationCertificate = "images/driver/21/image2.jpeg";
                AccreditationCertificateExpire = "2017-12-04T00:00:00.000Z";
                Address = Prahladnagar;
                Availability = 1;
                BSB = qwerty;
                BankAcNo = 12345678900987;
                BankHolderName = Bhavesh;
                BankName = HDFC;
                City = Ahmedabad;
                CompanyId = 1;
                Country = India;
                DCNumber = "";
                DispatcherId = 0;
                DriverDuty = 1;
                DriverLicense = "images/driver/21/image.jpeg";
                DriverLicenseExpire = "2017-11-21T00:00:00.000Z";
                Email = "bhavesh@excellentwebworld.info";
                Fullname = "Bhavesh developer";
                Gender = Male;
                Id = 21;
                Image = "images/driver/21/image10037.png";
                Lat = "23.07290128000603";
                Lng = "72.51691108496337";
                MobileNo = 9876543210;
                Password = 25d55ad283aa400af464c76d713c07ad;
                ProfileComplete = 1;
                QRCode = "images/qrcode/jsbS2dDmzpxpaWlfiJyVnKQ=.png";
                ReferralCode = tktc21Bha;
                State = Gujarat;
                Status = 1;
                SubUrb = Ahm;
                ZipCode = 123456;
            }
        );
        message = "Your booking request has been confirmed";
        type = Notification;
        }]
}
*/

//-------------------------------------------------------------
// MARK: - Get Estimate Fare Response
//-------------------------------------------------------------

/*
{
    "estimate_fare" =     (
        {
            "base_fare" = 25;
            "booking_fee" = 2;
            duration = 8;
            id = 1;
            km = "4.2";
            name = "Business Class";
            "per_km_charge" = 0;
            total = "27.2";
            "trip_fare" = 25;
    },
        {
            "base_fare" = "20.2";
            "booking_fee" = 2;
            duration = 8;
            id = 2;
            km = "4.2";
            name = Disability;
            "per_km_charge" = "2.75";
            total = 31;
            "trip_fare" = 29;
    },
        {
            "base_fare" = "4.2";
            "booking_fee" = 2;
            duration = 8;
            id = 3;
            km = "4.2";
            name = Taxi;
            "per_km_charge" = "1.62";
            total = "11.384";
            "trip_fare" = "9.384";
    },
        {
            "base_fare" = 35;
            "booking_fee" = 2;
            duration = 8;
            id = 4;
            km = "4.2";
            name = "First Class";
            "per_km_charge" = 0;
            total = "37.2";
            "trip_fare" = 35;
    },
        {
            "base_fare" = 40;
            "booking_fee" = 2;
            duration = 8;
            id = 5;
            km = "4.2";
            name = "LUX-VAN";
            "per_km_charge" = 0;
            total = 42;
            "trip_fare" = 40;
    },
        {
            "base_fare" = 5;
            "booking_fee" = 2;
            duration = 8;
            id = 6;
            km = "4.2";
            name = Economy;
            "per_km_charge" = "0.5";
            total = "7.6";
            "trip_fare" = "5.6";
    }
    );
    status = 1;
}

*/
/*
(
    {
        AbovePerKmCharge = "1.85";
        BaseFare = 20;
        BelowAndAboveKmLimit = 21;
        BelowPerKmCharge = "1.90";
        BookingFee = 2;
        CancellationFee = 10;
        Capacity = 4;
        CategoryId = 1;
        Description = "Caprice, Genesis, Lexus, Mercedes E, BMW 5 Series, VW Touareg, Audi A6, Chrysler 300C. etc";
        Id = 1;
        Image = "http://54.206.55.185/web/images/model/BUSINESS_12.png";
        Lat = "23.072664";
        Lng = "72.516199";
        MinKm = 3;
        MinuteFare = "0.45";
        Name = "Business Class";
        NightCharge = 10;
        NightChargeApplicable = 1;
        NightTimeFrom = "23:00:00";
        NightTimeTo = "05:00:00";
        Sort = 2;
        SpecialEventSurcharge = 5;
        SpecialEventTimeFrom = "18:00:00";
        SpecialEventTimeTo = "23:59:59";
        Status = 1;
        WaitingTimePerMinuteCharge = 1;
        carCount = 2;
},
    {
        AbovePerKmCharge = "2.75";
        BaseFare = "20.2";
        BelowAndAboveKmLimit = 25;
        BelowPerKmCharge = "2.75";
        BookingFee = 2;
        CancellationFee = 10;
        Capacity = 12;
        CategoryId = 1;
        Description = "(fitted with wheelchair access)";
        Id = 2;
        Image = "http://54.206.55.185/web/images/model/DISABILITY_15.png";
        Lat = "23.072664";
        Lng = "72.516199";
        MinKm = 1;
        MinuteFare = "0.92";
        Name = Disability;
        NightCharge = "11.22";
        NightChargeApplicable = 1;
        NightTimeFrom = "17:00:00";
        NightTimeTo = "09:00:00";
        Sort = 6;
        SpecialEventSurcharge = "3.75";
        SpecialEventTimeFrom = "18:00:00";
        SpecialEventTimeTo = "23:59:59";
        Status = 1;
        WaitingTimePerMinuteCharge = 1;
        carCount = 1;
}
)
 */

/*

AcceptBooking data is [{
    BookingInfo =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CreatedDate = "2018-05-25T12:59:18.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 70;
            DropOffLat = "23.03051289906712";
            DropOffLon = "72.50754006206989";
            DropTime = "";
            DropoffLocation = "SG Road Bodakdev, GJ, Ahmedabad";
            FlightNumber = "";
            GrandTotal = "";
            Id = 7627;
            ModelId = 5;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "";
            PaidToDriver = 0;
            PassengerContact = "";
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "";
            PaymentStatus = "";
            PaymentType = cash;
            PickupLat = "23.07001398702818";
            PickupLng = "72.51621801406145";
            PickupLocation = "119 Anurag Bunglow Road, Ahmedabad, Ahmedabad";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Special = 0;
            SpecialExtraCharge = 0;
            Status = accepted;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            Trash = 0;
            TripDistance = "";
            TripDuration = "";
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    CarInfo =     (
        {
            Color = "";
            Company = jdjdhdh;
            CompanyId = 1;
            Description = "";
            DriverId = 70;
            Id = 197;
            RegistrationCertificate = "images/driver/70/image.jpeg";
            RegistrationCertificateExpire = "0000-00-00";
            VehicleImage = "images/driver/70/image2.jpeg";
            VehicleInsuranceCertificate = "images/driver/70/image1.jpeg";
            VehicleInsuranceCertificateExpire = "0000-00-00";
            VehicleModel = 5;
            VehicleRegistrationNo = jshshs;
        }
    );
    Details =     (
        {
            BookingId = 7627;
            BookingType = BookNow;
            Distance = 980;
            DriverId = 70;
            Lat = "23.070013987028";
            Long = "72.516218014061";
            PassengerId = 8;
            Status = 2;
            UpdateTime = 1527233358;
            UpdatedDate = "2018-05-25 07:29:18";
            "_id" = 5b07bb4ec1f9f1194482ba79;
        }
    );
    DriverInfo =     (
        {
            ABN = "";
            AccreditationCertificate = "images/driver/70/image5.jpeg";
            AccreditationCertificateExpire = "0000-00-00";
            Address = hahshs;
            Availability = 1;
            BSB = shsh;
            BankAcNo = 7477474;
            BankHolderName = rahil;
            BankName = hshah;
            City = "";
            CompanyId = 1;
            Country = "";
            DCNumber = "";
            DOB = "1990-03-15T00:00:00.000Z";
            Description = "";
            DeviceType = 1;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/70/image4.jpeg";
            DriverLicenseExpire = "0000-00-00";
            Email = "rahul.b.bit@gmail.com";
            Fullname = "rahul patel";
            Gender = Male;
            Id = 70;
            Image = "images/driver/70/0b8ace3f9004dd57fbb80f7e596763fa.png";
            Lat = "23.072699134255576";
            Lng = "72.51637077057804";
            MobileNo = 9904439228;
            Password = 25d55ad283aa400af464c76d713c07ad;
            ProfileComplete = 1;
            QRCode = "images/qrcode/jsbS2dDmzpxqYmdeh6KVnaw=.png";
            ReferralCode = pkng70rah;
            SmartPhone = 1;
            State = "";
            Status = 1;
            SubUrb = "";
            Token = "dDEEbNx7xuo:APA91bFNGAE3dWPeBxwn63lHf8xpQx7o-PxUjCVBRmx_2Xo0hcn4N9kiVNBxcZGQorPk1QNRuhGCcZermxEdueZA9XfkwRVhwvBFhba6hMJXjLlASutGtuRZNqmDmtccAqmirbY5JpyW";
            Trash = 0;
            ZipCode = 48484545;
        }
    );
    ModelInfo =     (
        {
            AbovePerKmCharge = 30;
            BaseFare = 60;
            BelowAndAboveKmLimit = 1000;
            BelowPerKmCharge = 33;
            BookingFee = 0;
            CancellationFee = 25;
            Capacity = 3;
            CategoryId = 1;
            Commission = 5;
            Description = "Smoking is Prohibited in PicknGo";
            Id = 5;
            Image = "images/model/Tuk_Tuk1.jpg";
            MinKm = 1;
            MinuteFare = 0;
            Name = "Tuk Tuk";
            NightCharge = 15;
            NightChargeApplicable = 1;
            NightTimeFrom = "22:00:00";
            NightTimeTo = "06:59:00";
            Sort = 1;
            SpecialEventSurcharge = 0;
            SpecialEventTimeFrom = "17:00:00";
            SpecialEventTimeTo = "18:59:59";
            SpecialExtraCharge = 60;
            Status = 1;
            WaitingTimePerMinuteCharge = "3.50";
        }
    );
    message = "Your booking request has been confirmed";
    type = Notification;
}]

*/
/*
onBookingDetailsAfterCompletedTrip() is [{
    BookingType = BookLater;
    Info =     (
        {
            AdminAmount = "3.14";
            BookingCharge = 0;
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "59.66";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-05-28T18:36:15.000Z";
            Discount = 0;
            DistanceFare = "0.00";
            DriverId = 9;
            DropOffLat = "23.0271224";
            DropOffLon = "72.5084742";
            DropTime = "";
            DropoffLocation = "BRTS Bus Stop Pandurang Shastri Athavale Marg, Ahmedabad, Ahmedabad";
            FlightNumber = "";
            GrandTotal = "62.80";
            Id = 533;
            ModelId = 5;
            NightFare = 0;
            NightFareApplicable = 0;
            Notes = "";
            OnTheWay = 1;
            PaidToDriver = 0;
            PassengerContact = 1122334455;
            PassengerEmail = "";
            PassengerId = 8;
            PassengerName = "Vishal Dabhi";
            PassengerType = myself;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-05-28T00:00:00.000Z";
            PickupDateTime = "2018-05-28T19:06:06.000Z";
            PickupLat = "23.0691958";
            PickupLng = "72.5112124";
            PickupLocation = "Sola, Ahmedabad, Gujarat 380060, India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Status = completed;
            SubDispatcherId = 0;
            SubTotal = "62.80";
            Tax = "0.00";
            TollFee = 0;
            TransactionId = "";
            Trash = 0;
            TripDistance = 9;
            TripDuration = 1080;
            TripFare = 60;
            WaitingTime = 48;
            WaitingTimeCost = "2.80";
        }
    );
    PassengerType = myself;
    UpdatedBal = "-715";
}]
*/


// Get Estimate Fare
/*
[{
    "estimate_fare" =     (
        {
            "base_fare" = 210;
            "booking_fee" = 0;
            duration = 0;
            id = 1;
            km = "8.800000000000001";
            name = Executive;
            "per_km_charge" = 64;
            "share_ride" = 0;
            sort = 4;
            total = "581.2";
            "trip_fare" = "581.2";
    },
        {
            "base_fare" = 140;
            "booking_fee" = 0;
            duration = 0;
            id = 2;
            km = "8.800000000000001";
            name = "Mini Car";
            "per_km_charge" = 45;
            "share_ride" = 1;
            sort = 3;
            total = "312.2";
            "trip_fare" = 446;
    },
        {
            "base_fare" = 1000;
            "booking_fee" = 0;
            duration = 0;
            id = 3;
            km = "8.800000000000001";
            name = VAN;
            "per_km_charge" = 0;
            "share_ride" = 0;
            sort = 5;
            total = 1000;
            "trip_fare" = 1000;
    },
        {
            "base_fare" = 140;
            "booking_fee" = 0;
            duration = 1;
            id = 4;
            km = "8.800000000000001";
            name = Nano;
            "per_km_charge" = 40;
            "share_ride" = 1;
            sort = 2;
            total = "288.4";
            "trip_fare" = 412;
    },
        {
            "base_fare" = 60;
            "booking_fee" = 0;
            duration = 1;
            id = 5;
            km = "8.800000000000001";
            name = "Tuk Tuk";
            "per_km_charge" = 33;
            "share_ride" = 1;
            sort = 1;
            total = "222.18";
            "trip_fare" = "317.4";
    },
        {
            "base_fare" = 6000;
            "booking_fee" = 200;
            duration = 0;
            id = 6;
            km = "8.800000000000001";
            name = "Breakdown Services";
            "per_km_charge" = 0;
            "share_ride" = 0;
            sort = 7;
            total = 6200;
            "trip_fare" = 6000;
    },
        {
            "base_fare" = 5000;
            "booking_fee" = 2;
            duration = 0;
            id = 7;
            km = "8.800000000000001";
            name = Bus;
            "per_km_charge" = "0.80";
            "share_ride" = 0;
            sort = 6;
            total = "5006.64";
            "trip_fare" = "5004.64";
    }
    );
    status = 1;
}]
*/
