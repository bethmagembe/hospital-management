-- Schedule a new appointment
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime)
VALUES (1, 1, '2024-11-01', '14:30:00');

-- Get available time slots for a doctor on a specific date
SELECT TIME_FORMAT(MAKETIME(HOUR(t.slot), MINUTE(t.slot), 0), '%H:%i') AS AvailableSlot
FROM (
    SELECT ADDTIME('09:00:00', (t4.i*2 + t3.i*1 + t2.i*0.5 + t1.i*0.25) * 10000) slot
    FROM (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t1,
         (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t2,
         (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t3,
         (SELECT 0 i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4
) t
WHERE t.slot BETWEEN '09:00:00' AND '17:00:00'
  AND t.slot NOT IN (
    SELECT AppointmentTime
    FROM Appointments
    WHERE DoctorID = 1 AND AppointmentDate = '2024-11-01'
  )
ORDER BY t.slot;

-- Cancel an appointment
UPDATE Appointments
SET Status = 'Cancelled'
WHERE AppointmentID = 1;

-- Reschedule an appointment
UPDATE Appointments
SET AppointmentDate = '2024-11-02', AppointmentTime = '15:00:00'
WHERE AppointmentID = 1;

-- List all appointments for a specific day
SELECT A.AppointmentID, A.AppointmentTime, A.Status,
       P.FirstName AS PatientFirstName, P.LastName AS PatientLastName,
       D.FirstName AS DoctorFirstName, D.LastName AS DoctorLastName
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.AppointmentDate = '2024-11-01'
ORDER BY A.AppointmentTime;
