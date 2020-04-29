//
//  TempDataOfWebservice.swift
//  TickTok User
//
//  Created by Excelent iMac on 08/01/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import Foundation

//[{
//    message = "Your booking request has been confirmed";
//    }]
/*
onAcceptBookLaterBookingRequestNotification() is [{
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
            CompanyTax = "";
            CreatedDate = "2018-01-08T05:45:27.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 20;
            DropOffLat = "23.0523843";
            DropOffLon = "72.5337182";
            DropTime = "";
            DropoffLocation = "Memnagar, Ahmedabad, Gujarat, India";
            FlightNumber = Mahdi;
            GrandTotal = "";
            Id = 74;
            ModelId = 6;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "us and";
            OnTheWay = 1;
            PaidToDriver = 0;
            PassengerContact = 0755464548;
            PassengerEmail = "";
            PassengerId = 36;
            PassengerName = Allu;
            PassengerType = other;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-01-08T00:00:00.000Z";
            PickupDateTime = "2018-01-08T19:00:00.000Z";
            PickupLat = "23.0724024";
            PickupLng = "72.5167156";
            PickupLocation = "#106 Sundaram Arcade Opp.Shukan Mall Science City Road SCIENCE CITY Sola Ahmedabad Gujarat 380060 India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Status = accepted;
            SubDispatcherId = 0;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            TripDistance = "3.3";
            TripDuration = 540;
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    CarInfo =     (
        {
            Color = Black;
            Company = Tata;
            CompanyId = 1;
            Description = "";
            DriverId = 20;
            Id = 759;
            RegistrationCertificate = "images/driver/20/CarRegistrationCertificate";
            RegistrationCertificateExpire = "2018-01-11T00:00:00.000Z";
            VehicleImage = "images/driver/20/VehicleImage";
            VehicleInsuranceCertificate = "images/driver/20/VehicleInsuranceCertificate";
            VehicleInsuranceCertificateExpire = "2017-12-20T00:00:00.000Z";
            VehicleModel = 4;
            VehicleRegistrationNo = "Gj1 1234";
        }
    );
    Details =     (
        {
            AdminAmount = "";
            BookingCharge = "";
            BookingType = "";
            ByDriverAmount = "";
            ByDriverId = 0;
            CardId = 0;
            CompanyAmount = "";
            CompanyId = 1;
            CompanyTax = "";
            CreatedDate = "2018-01-08T05:45:27.000Z";
            Discount = "";
            DistanceFare = "";
            DriverId = 20;
            DropOffLat = "23.0523843";
            DropOffLon = "72.5337182";
            DropTime = "";
            DropoffLocation = "Memnagar, Ahmedabad, Gujarat, India";
            FlightNumber = Mahdi;
            GrandTotal = "";
            Id = 74;
            ModelId = 6;
            NightFare = "";
            NightFareApplicable = 0;
            Notes = "us and";
            OnTheWay = 1;
            PaidToDriver = 0;
            PassengerContact = 0755464548;
            PassengerEmail = "";
            PassengerId = 36;
            PassengerName = Allu;
            PassengerType = other;
            PaymentStatus = "";
            PaymentType = cash;
            PickupDate = "2018-01-08T00:00:00.000Z";
            PickupDateTime = "2018-01-08T19:00:00.000Z";
            PickupLat = "23.0724024";
            PickupLng = "72.5167156";
            PickupLocation = "#106 Sundaram Arcade Opp.Shukan Mall Science City Road SCIENCE CITY Sola Ahmedabad Gujarat 380060 India";
            PickupTime = "";
            PromoCode = "";
            Reason = "";
            Status = accepted;
            SubDispatcherId = 0;
            SubTotal = "";
            Tax = "";
            TollFee = "";
            TransactionId = "";
            TripDistance = "3.3";
            TripDuration = 540;
            TripFare = "";
            WaitingTime = "";
            WaitingTimeCost = "";
        }
    );
    DriverInfo =     (
        {
            ABN = 3456mj;
            AccreditationCertificate = "images/driver/20/AccreditationCertificate";
            AccreditationCertificateExpire = "2018-12-22T00:00:00.000Z";
            Address = iscon;
            Availability = 0;
            BSB = Tt5;
            BankAcNo = 9632536986325369;
            BankHolderName = Aradhana;
            BankName = Kotak;
            City = Ahmedabad;
            CompanyId = 1;
            Country = India;
            DCNumber = 123456;
            Description = "";
            DeviceType = 2;
            DispatcherId = 0;
            DriverDuty = 1;
            DriverLicense = "images/driver/20/DriverLicence";
            DriverLicenseExpire = "2017-11-25T00:00:00.000Z";
            Email = "aradhana@excellentwebworld.info";
            Fullname = arru;
            Gender = Female;
            Id = 20;
            Image = "images/driver/20/DriverImage1";
            Lat = "23.072741";
            Lng = "72.516356";
            MobileNo = 9638527419;
            Password = e10adc3949ba59abbe56e057f20f883e;
            ProfileComplete = 1;
            QRCode = "images/qrcode/jsbS2dDmzpxnZWtfhqCXnK0=.png";
            ReferralCode = tktc20Arr;
            State = 1;
            Status = 1;
            SubUrb = iscon;
            Token = "fWbqzDmz8xs:APA91bHcOxcTJc5va9-MJ6H2H6Z3NjTF0Dy1M4KVFa-s-xHcQ_lMMf428KP0gS6tDf0UZhJR5L7ZR-V_KGged_pKRLORRoqqt-_lrr42CiBWM9DrjOxoH1R7-Wf7697aDQlC7IhgEVBM";
            ZipCode = 1232;
        }
    );
    message = "Your driver is on the way.";
    type = Notification;
}]

*/
/*
{
    AdminAmount = "";
    BookingCharge = "";
    BookingType = "Book Now";
    ByDriverAmount = "";
    ByDriverId = 0;
    CarDetails =     {
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
    };
    CardId = 0;
    CompanyAmount = "";
    CompanyId = 1;
    CreatedDate = "2018/05/28 12/09";
    Discount = "";
    DistanceFare = "";
    DriverId = 70;
    DriverName = "rahul patel";
    DropOffLat = "23.02627485022037";
    DropOffLon = "72.58191671222448";
    DropTime = "";
    DropoffLocation = "1354 Relief Rd, Ahmedabad, Ahmedabad";
    FlightNumber = "";
    GrandTotal = "";
    HistoryType = onGoing;
    Id = 7979;
    Model = "Tuk Tuk";
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
    PickupLat = "23.07082215763308";
    PickupLng = "72.51659922301769";
    PickupLocation = "35 Sola Gam Rd, Ahmedabad, Ahmedabad";
    PickupTime = 1527489630;
    PromoCode = "";
    Reason = "";
    Special = 0;
    SpecialExtraCharge = 0;
    Status = traveling;
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

*/
