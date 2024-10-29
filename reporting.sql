-- Monthly appointment statistics
SELECT 
    DATE_FORMAT(AppointmentDate, '%Y-%m') AS Month,
    COUNT(*) AS TotalAppointments,
    COUNT(CASE WHEN Status = 'Completed' THEN 1 END) AS CompletedAppointments,
    COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledAppointments
FROM Appointments
GROUP BY Month
ORDER BY Month DESC;

-- Doctor performance report
SELECT 
    D.DoctorID,
    D.FirstName,
    D.LastName,
    D.Specialization,
    COUNT(A.AppointmentID) AS TotalAppointments,
    AVG(B.Amount) AS AverageRevenue
FROM Doctors D
LEFT JOIN Appointments A ON D.DoctorID = A.DoctorID
LEFT JOIN Billing B ON A.AppointmentID = B.AppointmentID
WHERE A.AppointmentDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 6 MONTH) AND CURDATE()
GROUP BY D.DoctorID, D.FirstName, D.LastName, D.Specialization
ORDER BY TotalAppointments DESC;

-- Patient demographics report
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) < 18 THEN 'Under 18'
        WHEN TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) BETWEEN 18 AND 30 THEN '18-30'
        WHEN TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) BETWEEN 31 AND 50 THEN '31-50'
        WHEN TIMESTAMPDIFF(YEAR, DateOfBirth, CURDATE()) BETWEEN 51 AND 70 THEN '51-70'
        ELSE 'Over 70'
    END AS AgeGroup,
    Gender,
    COUNT(*) AS PatientCount
FROM Patients
GROUP BY AgeGroup, Gender
ORDER BY AgeGroup, Gender;

-- Most common diagnoses
SELECT 
    Diagnosis,
    COUNT(*) AS Occurrences
FROM MedicalRecords
GROUP BY Diagnosis
ORDER BY Occurrences DESC
LIMIT 10;

-- Revenue by specialization
SELECT 
    D.Specialization,
    SUM(B.Amount) AS TotalRevenue,
    AVG(B.Amount) AS AverageRevenue
FROM Doctors D
JOIN Appointments A ON D.DoctorID = A.DoctorID
JOIN Billing B ON A.AppointmentID = B.AppointmentID
WHERE B.PaymentStatus = 'Paid'
GROUP BY D.Specialization
ORDER BY TotalRevenue DESC;
