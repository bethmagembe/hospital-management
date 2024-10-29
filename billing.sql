-- Generate a new bill
INSERT INTO Billing (PatientID, AppointmentID, Amount)
VALUES (1, 1, 150.00);

-- Update payment status
UPDATE Billing
SET PaymentStatus = 'Paid'
WHERE BillID = 1;

-- Get unpaid bills for a patient
SELECT B.BillID, B.Amount, B.CreatedAt, A.AppointmentDate, D.FirstName AS DoctorFirstName, D.LastName AS DoctorLastName
FROM Billing B
JOIN Appointments A ON B.AppointmentID = A.AppointmentID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE B.PatientID = 1 AND B.PaymentStatus = 'Unpaid'
ORDER BY B.CreatedAt DESC;

-- Calculate total revenue for the current month
SELECT SUM(Amount) AS TotalRevenue
FROM Billing
WHERE YEAR(CreatedAt) = YEAR(CURDATE()) AND MONTH(CreatedAt) = MONTH(CURDATE()) AND PaymentStatus = 'Paid';

-- Get top 5 patients by total billing amount
SELECT P.PatientID, P.FirstName, P.LastName, SUM(B.Amount) AS TotalBilled
FROM Patients P
JOIN Billing B ON P.PatientID = B.PatientID
GROUP BY P.PatientID, P.FirstName, P.LastName
ORDER BY TotalBilled DESC
LIMIT 5;
