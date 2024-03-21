CREATE DATABASE PROCESS_Domain_LDM_Lab_Extension;

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Test_Result (
    `lab test result id` int NOT NULL,
    `test result id` int NOT NULL,
    `lab test id` int NOT NULL,
    `lab test result` string NOT NULL,
    `lab test result timestamp` timestamp,
    result struct < new_column: string >,
    expiration timestamp,
    `result unit of measure` struct < new_column: string >
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Test (
    `lab test id` int NOT NULL,
    `lab test result timestamp` timestamp
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Sample (
    `lab sample id` int NOT NULL,
    `lab product batch id` int
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Product_Batch (
    `lab product batch id` int NOT NULL,
    `product batch id` int NOT NULL,
    `batch sample taken timestamp` timestamp
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Job_Order (
    `lab job order id` int PRIMARY KEY DISABLE,
    `job order id` int
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Sample_Test (
    `lab sample test id` int NOT NULL,
    `lab test id` int NOT NULL,
    `lab sample id` int NOT NULL,
    `lab test sample timestamp` timestamp
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Job_Order_Sample (
    `lab job order sample id` int NOT NULL,
    `lab job order id` int NOT NULL,
    `lab sample id` int NOT NULL
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Job_Response (
    `lab job response id` int NOT NULL,
    `job response id` int NOT NULL,
    `lab job order id` int NOT NULL
);

CREATE TABLE PROCESS_Domain_LDM_Lab_Extension.Lab_Test_Failure (
    `lab test result id` int NOT NULL,
    `deviation id` int NOT NULL
);

USE PROCESS_Domain_LDM_Lab_Extension;

ALTER TABLE
    Lab Test Result
ADD
    CONSTRAINT `fk Lab Test Result.lab test id to Lab Test.lab test id` FOREIGN KEY (`lab test id`) REFERENCES Lab Test(`lab test id`);

ALTER TABLE
    Lab Test Result
ADD
    CONSTRAINT `fk Lab Test Result.test result id to Test Result.test result id` FOREIGN KEY (`test result id`) REFERENCES ();

ALTER TABLE
    Lab Sample
ADD
    CONSTRAINT `fk Lab Sample.lab product batch id to Lab Product Batch.lab product batch id` FOREIGN KEY (`lab product batch id`) REFERENCES Lab Product Batch(`lab product batch id`);

ALTER TABLE
    Lab Product Batch
ADD
    CONSTRAINT `fk Lab Product Batch.product batch id to Product Batch.product batch id` FOREIGN KEY (`product batch id`) REFERENCES ();

ALTER TABLE
    Lab Job Order
ADD
    CONSTRAINT `fk Lab Job Order.job order id to Job Order.job order id` FOREIGN KEY (`job order id`) REFERENCES ();

ALTER TABLE
    Lab Sample Test
ADD
    CONSTRAINT `fk Lab Sample Test.lab test id to Lab Test.lab test id` FOREIGN KEY (`lab test id`) REFERENCES Lab Test(`lab test id`);

ALTER TABLE
    Lab Sample Test
ADD
    CONSTRAINT `fk Lab Sample Test.lab sample id to Lab Sample.lab sample id` FOREIGN KEY (`lab sample id`) REFERENCES Lab Sample(`lab sample id`);

ALTER TABLE
    Lab Job Order Sample
ADD
    CONSTRAINT `fk Lab Sample Test(1).lab sample id to Lab Sample.lab sample id` FOREIGN KEY (`lab sample id`) REFERENCES Lab Sample(`lab sample id`);

ALTER TABLE
    Lab Job Order Sample
ADD
    CONSTRAINT `fk Lab Job Order Sample.lab job order id to Lab Job Order.lab job order id` FOREIGN KEY (`lab job order id`) REFERENCES Lab Job Order(`lab job order id`);

ALTER TABLE
    Lab Job Response
ADD
    CONSTRAINT `fk Lab Job Response.lab job order id to Lab Job Order.lab job order id` FOREIGN KEY (`lab job order id`) REFERENCES Lab Job Order(`lab job order id`);

ALTER TABLE
    Lab Job Response
ADD
    CONSTRAINT `fk Lab Job Response.job response id to Job Response.job response id` FOREIGN KEY (`job response id`) REFERENCES ();

ALTER TABLE
    Lab Test Failure
ADD
    CONSTRAINT `fk Lab Test Failure.lab test result id to Lab Test Result.lab test result id` FOREIGN KEY (`lab test result id`) REFERENCES Lab Test Result(`lab test result id`);

ALTER TABLE
    Lab Test Failure
ADD
    CONSTRAINT `fk Lab Test Failure.deviation id to Deviation.deviation id` FOREIGN KEY (`deviation id`) REFERENCES ();
