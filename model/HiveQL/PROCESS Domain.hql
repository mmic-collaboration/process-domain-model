CREATE DATABASE PROCESS_Domain;

CREATE TABLE PROCESS_Domain.Work_Master (
    `work master id` int NOT NULL,
    `product id` int NOT NULL COMMENT 'The product id of the Recipe is the unique identifier of the specific Product  that will result from following this Recipe. \n\n(Note: Product is part of the PRODUCT domain, which is to be defined as of v0.3.3 of this model)',
    `work master version` int COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `work master title` varchar(255),
    `work master code` int
);

CREATE TABLE PROCESS_Domain.Process_Event (
    `process event id` int NOT NULL,
    `process event type id` int,
    `job step id` int NOT NULL,
    `process event status` string NOT NULL,
    `process event timestamp` timestamp
);

CREATE TABLE PROCESS_Domain.Deviation (
    `deviation id` int NOT NULL,
    `test result id` int NOT NULL,
    `product batch id` int NOT NULL,
    `deviation description` varchar(255),
    `deviation severity` string NOT NULL
);

CREATE TABLE PROCESS_Domain.Process_Event_Type (
    `process event type id` int NOT NULL,
    `process event type name` string NOT NULL,
    `process event type description` varchar(255)
);

CREATE TABLE PROCESS_Domain.Job_Step (
    `job step id` int NOT NULL,
    `job step procedure id` int NOT NULL,
    `job id` int NOT NULL,
    `product batch id` int NOT NULL,
    `station id` varchar(255),
    `work master id` int NOT NULL,
    `job step code` int,
    `unit process start timestamp` timestamp NOT NULL COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `unit process end timestamp` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.'
);

CREATE TABLE PROCESS_Domain.Product_Batch (
    `product batch id` int NOT NULL,
    `product batch work order id` int,
    `product batch product id` int,
    `product batch timestamp` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `product batch number` varchar(255) COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `batch report uri` varchar(255)
);

CREATE TABLE PROCESS_Domain.Job (
    `job id` int NOT NULL,
    `work master id` int NOT NULL,
    `job run code` int,
    `job start date-time` timestamp NOT NULL COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `job end date-time` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `physical assets` array < map < string,
    string > >,
    personnel array < map < string,
    string > >,
    `material lots` array < map < string,
    string > >,
    equipment array < map < string,
    string > >,
    `job steps` array < map < string,
    string > >
);

CREATE TABLE PROCESS_Domain.Job_Response (
    `job response id` int NOT NULL,
    `job order id` int NOT NULL,
    `work request id` int,
    `work schedule id` int NOT NULL
);

CREATE TABLE PROCESS_Domain.Deviation_Assessment (
    `deviation assessment id` int NOT NULL,
    `deviation id` int NOT NULL,
    `deviation assessed by id` int,
    `deviation assessment summary` varchar(255),
    `deviation assessment outcome` string,
    `assessment completed status` boolean
);

CREATE TABLE PROCESS_Domain.Job_Order (
    `job order id` int,
    `job id` int,
    `work request id` int,
    `work schedule id` int NOT NULL
);

CREATE TABLE PROCESS_Domain.Work_Request (
    `work request id` int NOT NULL,
    `work schedule id` int NOT NULL
);

CREATE TABLE PROCESS_Domain.Work_Schedule (`work schedule id` int NOT NULL);

CREATE TABLE PROCESS_Domain.Test_Specification_Type (
    `test specification type id` int NOT NULL,
    `test specification type summary` varchar(255),
    `test specification type name` string
);

CREATE TABLE PROCESS_Domain.Test_Result (
    `test result id` int NOT NULL,
    `result description` varchar(255),
    `test date` int NOT NULL,
    result struct < new_column: string > NOT NULL,
    `result unit of measure` struct < new_column: string > NOT NULL,
    expiration timestamp NOT NULL
);

CREATE TABLE PROCESS_Domain.Job_Step_Procedure (
    `job step procedure id` int NOT NULL,
    `work master id` int NOT NULL,
    `job step procedure title` varchar(255)
);

CREATE TABLE PROCESS_Domain.Job_Step_Response_Specification (
    `job step response specification id` int NOT NULL,
    `job step procedure id` int NOT NULL,
    `job step title` varchar(255),
    `work master code` int,
    `test specification type id` int NOT NULL
);

CREATE TABLE PROCESS_Domain.Batch_Release_Test_Specification (
    `batch release test specification id` int NOT NULL,
    `test specification type id` int NOT NULL,
    `work master id` int NOT NULL,
    `product batch id` int NOT NULL,
    `batch release test specification summary` varchar(255),
    `batch release release test specification function` string NOT NULL,
    `release condition rule arguments` array < varchar(255) >
);

CREATE TABLE PROCESS_Domain.Batch_Release_Test (
    `batch release test result id` int NOT NULL,
    `batch release test specification id` int NOT NULL,
    `result description` varchar(255),
    `batch release test result id copy` int NOT NULL,
    `test result id` int NOT NULL
);

USE PROCESS_Domain;

ALTER TABLE
    Process Event
ADD
    CONSTRAINT `fk Process Event.unit process id to Unit Process.unit process id` FOREIGN KEY (`job step id`) REFERENCES Job Step(`job step id`);

ALTER TABLE
    Deviation
ADD
    CONSTRAINT `fk Deviation.product batch id to Product Batch.product batch id` FOREIGN KEY (`product batch id`) REFERENCES Product Batch(`product batch id`);

ALTER TABLE
    Deviation
ADD
    CONSTRAINT `fk Deviation.id to Test Result.id` FOREIGN KEY (`test result id`) REFERENCES Test Result(`test result id`);

ALTER TABLE
    Process Event Type
ADD
    CONSTRAINT `fk Process Event Type.process event type id to Process Event.process event type id` FOREIGN KEY (`process event type id`) REFERENCES Process Event(`process event type id`);

ALTER TABLE
    Job Step
ADD
    CONSTRAINT `fk Production Run.product batch id to Product Batch.product batch id` FOREIGN KEY (`product batch id`) REFERENCES Product Batch(`product batch id`);

ALTER TABLE
    Job Step
ADD
    CONSTRAINT `fk Unit Process.job id to Job.job id` FOREIGN KEY (`job id`) REFERENCES Job(`job id`);

ALTER TABLE
    Job Step
ADD
    CONSTRAINT `fk Job Step.job step procedure id to Job Step Procedure.job step procedure id` FOREIGN KEY (`job step procedure id`) REFERENCES Job Step Procedure(`job step procedure id`);

ALTER TABLE
    Job
ADD
    CONSTRAINT `fk Job.work master id to work master id.work master id` FOREIGN KEY (`work master id`) REFERENCES Work Master(`work master id`);

ALTER TABLE
    Job Response
ADD
    CONSTRAINT `fk Job Response.job id to Job.job id` FOREIGN KEY (`job order id`) REFERENCES Job(`job id`);

ALTER TABLE
    Job Response
ADD
    CONSTRAINT `fk Job Response.job response id to Job Order.job order id` FOREIGN KEY (`job response id`) REFERENCES Job Order(`job order id`);

ALTER TABLE
    Deviation Assessment
ADD
    CONSTRAINT `fk deviation(1).deviation id to deviation.deviation id` FOREIGN KEY (`deviation id`) REFERENCES Deviation(`deviation id`);

ALTER TABLE
    Job Order
ADD
    CONSTRAINT `fk Job Order.work request id to Work Request.work request id` FOREIGN KEY (`work request id`) REFERENCES Work Request(`work request id`);

ALTER TABLE
    Job Order
ADD
    CONSTRAINT `fk Job Order.job id to Job.job id` FOREIGN KEY (`job id`) REFERENCES Job(`job id`);

ALTER TABLE
    Work Request
ADD
    CONSTRAINT `fk Work Request.work schedule id to Work Schedule.work schedule id` FOREIGN KEY (`work schedule id`) REFERENCES Work Schedule(`work schedule id`);

ALTER TABLE
    Test Result
ADD
    CONSTRAINT `produces (fk Test Result.test result id to Batch Release Test.test result id)` FOREIGN KEY (`test result id`) REFERENCES Batch Release Test(`test result id`);

ALTER TABLE
    Job Step Procedure
ADD
    CONSTRAINT `fk Job Step Procedure.job step procedure id to Job Step Response Specification.job step procedure id` FOREIGN KEY (`job step procedure id`) REFERENCES Job Step Response Specification(`job step procedure id`);

ALTER TABLE
    Job Step Response Specification
ADD
    CONSTRAINT `fk Job Step Response Specification.test specification type id to Test Specification Type.test specification type id` FOREIGN KEY (`test specification type id`) REFERENCES Test Specification Type(`test specification type id`);

ALTER TABLE
    Batch Release Test Specification
ADD
    CONSTRAINT `fk Batch Release Test Specification.test specification id to Test Specification.test specification id` FOREIGN KEY (`test specification type id`) REFERENCES Test Specification Type(`test specification type id`);

ALTER TABLE
    Batch Release Test Specification
ADD
    CONSTRAINT `fk Release Condition Rule.work master id to Work Master.work master id` FOREIGN KEY (`work master id`) REFERENCES Work Master(`work master id`);

ALTER TABLE
    Batch Release Test Specification
ADD
    CONSTRAINT `fk Batch Release Test Specification.product batch id to Product Batch.product batch id` FOREIGN KEY (`product batch id`) REFERENCES Product Batch(`product batch id`);

ALTER TABLE
    Batch Release Test
ADD
    CONSTRAINT `fk Batch Release Test.batch release test specification id to Batch Release Test Specification.batch release test specification id` FOREIGN KEY (`batch release test specification id`) REFERENCES Batch Release Test Specification(`batch release test specification id`);
