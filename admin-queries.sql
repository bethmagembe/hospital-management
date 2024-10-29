
CREATE TABLE IF NOT EXISTS UserActivityLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ActivityType VARCHAR(50),
    ActivityDescription TEXT,
    ActivityTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Log user activity
INSERT INTO UserActivityLog (UserID, ActivityType, ActivityDescription)
VALUES (1, 'Login', 'User logged in to the system');

-- Get recent user activity
SELECT LogID, UserID, ActivityType, ActivityDescription, ActivityTimestamp
FROM UserActivityLog
ORDER BY ActivityTimestamp DESC
LIMIT 100;

-- System-wide appointment status summary
SELECT 
    Status,
    COUNT(*) AS AppointmentCount,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Appointments) AS Percentage
FROM Appointments
GROUP BY Status;

-- Identify overbooked doctors (more than 10 appointments in a day)
SELECT 
    A.AppointmentDate,
    D.DoctorID,
    D.FirstName,
    D.LastName,
    COUNT(*) AS AppointmentCount
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
GROUP BY A.AppointmentDate, D.DoctorID, D.FirstName, D.LastName
HAVING AppointmentCount > 10
ORDER BY A.AppointmentDate, AppointmentCount DESC;

-- Find patients without recent appointments (last 6 months)
SELECT 
    P.PatientID,
    P.FirstName,
    P.LastName,
    MAX(A.AppointmentDate) AS LastAppointmentDate
FROM Patients P
LEFT JOIN Appointments A ON P.PatientID = A.PatientID
GROUP BY P.PatientID, P.FirstName, P.LastName
HAVING LastAppointmentDate IS NULL OR LastAppointmentDate < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY LastAppointmentDate;

-- Database size and table statistics
SELECT 
    table_name AS `Table`,
    round(((data_length + index_length) / 1024 / 1024), 2) AS `Size (MB)`
FROM information_schema.TABLES
WHERE table_schema = DATABASE()
ORDER BY (data_length + index_length) DESC;
