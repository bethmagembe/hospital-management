-- Add a new doctor
INSERT INTO Doctors (FirstName, LastName, Specialization, ContactNumber, Email)
VALUES ('Jane', 'Smith', 'Cardiology', '123-456-7890', 'jane.smith@hospital.com');

-- Update doctor information
UPDATE Doctors
SET ContactNumber = '987-654-3210', Email = 'jane.smith.new@hospital.com'
WHERE DoctorID = 1;

-- Get doctor's schedule for a specific day
SELECT A.AppointmentID, A.AppointmentTime, P.FirstName AS PatientFirstName, P.LastName AS PatientLastName
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
WHERE A.DoctorID = 1 AND A.AppointmentDate = '2024-11-01'
ORDER BY A.AppointmentTime;

-- Calculate doctor's appointment load for the current month
SELECT D.DoctorID, D.FirstName, D.LastName, COUNT(A.AppointmentID) AS AppointmentCount
FROM Doctors D
LEFT JOIN Appointments A ON D.DoctorID = A.DoctorID
WHERE YEAR(A.AppointmentDate) = YEAR(CURDATE()) AND MONTH(A.AppointmentDate) = MONTH(CURDATE())
GROUP BY D.DoctorID, D.FirstName, D.LastName
ORDER BY AppointmentCount DESC;

-- Find doctors with a specific specialization
SELECT DoctorID, FirstName, LastName, ContactNumber, Email
FROM Doctors
WHERE Specialization = 'Cardiology';
