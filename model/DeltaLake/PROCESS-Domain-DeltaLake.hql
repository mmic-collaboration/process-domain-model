CREATE SCHEMA IF NOT EXISTS `PROCESS_Domain`;

CREATE TABLE `PROCESS_Domain`.`Work_Master` (
    `work_master_id` int NOT NULL PRIMARY KEY,
    `product_id` int NOT NULL COMMENT 'The product id of the Recipe is the unique identifier of the specific Product  that will result from following this Recipe. \n\n(Note: Product is part of the PRODUCT domain, which is to be defined as of v0.3.3 of this model)',
    `work_master_version` int COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `work_master_title` string,
    `work_master_code` int
);

CREATE TABLE `PROCESS_Domain`.`Process_Event` (
    `process_event_id` int NOT NULL PRIMARY KEY,
    `process_event_type_id` int,
    `job_step_id` int NOT NULL,
    `process_event_status` string NOT NULL,
    `process_event_timestamp` timestamp
);

CREATE TABLE `PROCESS_Domain`.Deviation (
    `deviation_id` int NOT NULL PRIMARY KEY,
    `test_result_id` int NOT NULL,
    `product_batch_id` int NOT NULL,
    `deviation_description` string,
    `deviation_severity` string NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Process_Event_Type` (
    `process_event_type_id` int NOT NULL PRIMARY KEY,
    `process_event_type_name` string NOT NULL,
    `process_event_type_description` string
);

CREATE TABLE `PROCESS_Domain`.`Job_Step` (
    `job_step_id` int NOT NULL PRIMARY KEY,
    `job_step_procedure_id` int NOT NULL,
    `job_id` int NOT NULL,
    `product_batch_id` int NOT NULL,
    `station_id` string,
    `work_master_id` int NOT NULL,
    `job_step_code` int,
    `unit_process_start_timestamp` timestamp NOT NULL COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `unit_process_end_timestamp` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.'
);

CREATE TABLE `PROCESS_Domain`.`Product_Batch` (
    `product_batch_id` int NOT NULL PRIMARY KEY,
    `product_batch_work_order_id` int,
    `product_batch_product_id` int,
    `product_batch_timestamp` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `product_batch_number` string COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `batch_report_uri` string
);

CREATE TABLE `PROCESS_Domain`.`Batch_Release_Test` (
    `batch_release_test_result_id` int NOT NULL PRIMARY KEY,
    `batch_release_test_specification_id` int NOT NULL,
    `result_description` string,
    `batch_release_test_result_id_copy` int NOT NULL,
    `test_result_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Batch_Release_Test_Specification` (
    `batch_release_test_specification_id` int NOT NULL PRIMARY KEY,
    `test_specification_type_id` int NOT NULL,
    `work_master_id` int NOT NULL,
    `product_batch_id` int NOT NULL,
    `batch_release_test_specification_summary` string,
    `batch_release_release_test_specification_function` string NOT NULL
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.`release_condition_rule_arguments` (
    id int NOT NULL PRIMARY KEY,
    `batch_release_test_specification_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Deviation_Assessment` (
    `deviation_assessment_id` int NOT NULL PRIMARY KEY,
    `deviation_id` int NOT NULL,
    `deviation_assessed_by_id` int,
    `deviation_assessment_summary` string,
    `deviation_assessment_outcome` string,
    `assessment_completed_status` boolean
);

CREATE TABLE `PROCESS_Domain`.Job (
    `job_id` int NOT NULL PRIMARY KEY,
    `work_master_id` int NOT NULL,
    `job_run_code` int,
    `job_start_date-time` timestamp NOT NULL COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `job_end_date-time` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.'
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.`physical_assets` (
    id int NOT NULL PRIMARY KEY,
    `job_id` int NOT NULL
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.personnel (
    id int NOT NULL PRIMARY KEY,
    `job_id` int NOT NULL
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.`material_lots` (
    id int NOT NULL PRIMARY KEY,
    `job_id` int NOT NULL
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.equipment (
    id int NOT NULL PRIMARY KEY,
    `job_id` int NOT NULL
);

CREATE TABLE IF NOT EXISTS `PROCESS_Domain`.`job_steps` (
    id int NOT NULL PRIMARY KEY,
    `job_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Job_Order` (
    `job_order_id` int,
    `job_id` int,
    `work_request_id` int,
    `work_schedule_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Job_Response` (
    `job_response_id` int NOT NULL PRIMARY KEY,
    `job_order_id` int NOT NULL,
    `work_request_id` int,
    `work_schedule_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Job_Step_Procedure` (
    `job_step_procedure_id` int NOT NULL PRIMARY KEY,
    `work_master_id` int NOT NULL,
    `job_step_procedure_title` string
);

CREATE TABLE `PROCESS_Domain`.`Job_Step_Response_Specification` (
    `job_step_response_specification_id` int NOT NULL PRIMARY KEY,
    `job_step_procedure_id` int NOT NULL,
    `job_step_title` string,
    `work_master_code` int,
    `test_specification_type_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Work_Request` (
    `work_request_id` int NOT NULL PRIMARY KEY,
    `work_schedule_id` int NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Work_Schedule` (
    `work_schedule_id` int NOT NULL PRIMARY KEY
);

ALTER TABLE `PROCESS_Domain`.Process_Event_Type
ADD CONSTRAINT `fk_Process_Event_Type_process_event_type_id_to_Process_Event_process_event_type_id` FOREIGN KEY (`process event type id`) REFERENCES `PROCESS_Domain`.Process_Event(`process event type id`);

ALTER TABLE `PROCESS_Domain`.Job_Step
ADD CONSTRAINT `fk_Production_Run_product_batch_id_to_Product_Batch_product_batch_id` FOREIGN KEY (`product batch id`) REFERENCES `PROCESS_Domain`.Product_Batch(`product batch id`);

ALTER TABLE `PROCESS_Domain`.release_condition_rule_arguments
ADD CONSTRAINT `fk_Batch_Release_Test_Specification_batch_release_test_specification_id_to_release_condition_rule_arguments_batch_release_test_specification_id` FOREIGN KEY (`batch release test specification id`) REFERENCES `PROCESS_Domain`.Batch_Release_Test_Specification(`batch release test specification id`);

ALTER TABLE `PROCESS_Domain`.physical_assets
ADD CONSTRAINT `fk_Job_job_id_to_physical_assets_job_id` FOREIGN KEY (`job id`) REFERENCES `PROCESS_Domain`.Job(`job id`);

ALTER TABLE `PROCESS_Domain`.personnel
ADD CONSTRAINT `fk_Job_job_id_to_personnel_job_id` FOREIGN KEY (`job id`) REFERENCES `PROCESS_Domain`.Job(`job id`);

ALTER TABLE `PROCESS_Domain`.material_lots
ADD CONSTRAINT `fk_Job_job_id_to_material_lots_job_id` FOREIGN KEY (`job id`) REFERENCES `PROCESS_Domain`.Job(`job id`);

ALTER TABLE `PROCESS_Domain`.equipment
ADD CONSTRAINT `fk_Job_job_id_to_equipment_job_id` FOREIGN KEY (`job id`) REFERENCES `PROCESS_Domain`.Job(`job id`);

ALTER TABLE `PROCESS_Domain`.job_steps
ADD CONSTRAINT `fk_Job_job_id_to_job_steps_job_id` FOREIGN KEY (`job id`) REFERENCES `PROCESS_Domain`.Job(`job id`);

