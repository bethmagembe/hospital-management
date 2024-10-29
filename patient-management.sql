-- Add a new patient
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, ContactNumber, Email, Address)
VALUES ('John', 'Doe', '1990-05-15', 'Male', '123-456-7890', 'john.doe@email.com', '123 Main St, City, Country');

-- Update patient information
UPDATE Patients
SET ContactNumber = '987-654-3210', Email = 'john.new@email.com'
WHERE PatientID = 1;

-- Search for patients by name
SELECT * FROM Patients
WHERE FirstName LIKE '%John%' OR LastName LIKE '%Doe%';

-- Get patient's appointment history
SELECT A.AppointmentID, A.AppointmentDate, A.AppointmentTime, A.Status, D.FirstName AS DoctorFirstName, D.LastName AS DoctorLastName
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.PatientID = 1
ORDER BY A.AppointmentDate DESC, A.AppointmentTime DESC;

-- Get patient's medical records
SELECT MR.RecordID, MR.Diagnosis, MR.Prescription, MR.Notes, MR.CreatedAt,
       D.FirstName AS DoctorFirstName, D.LastName AS DoctorLastName
FROM MedicalRecords MR
JOIN Doctors D ON MR.DoctorID = D.DoctorID
WHERE MR.PatientID = 1
ORDER BY MR.CreatedAt DESC;
