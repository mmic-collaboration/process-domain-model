CREATE SCHEMA IF NOT EXISTS `PROCESS_Domain`;

CREATE TABLE `PROCESS_Domain`.Recipe (
    `receipe_id` int NOT NULL PRIMARY KEY,
    `product_id` int NOT NULL COMMENT 'The product id of the Recipe is the unique identifier of the specific Product  that will result from following this Recipe. \n\n(Note: Product is part of the PRODUCT domain, which is to be defined as of v0.3.3 of this model)',
    `recipe_version` int COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `recipe_title` string,
    `recipe_code` int
);

CREATE TABLE `PROCESS_Domain`.`Process_Event` (
    `process_event_id` int NOT NULL PRIMARY KEY,
    `process_event_type_id` int,
    `recipe_id` int,
    `process_event_status` string NOT NULL,
    `process_event_timestamp` timestamp
);

CREATE TABLE `PROCESS_Domain`.`Process_Response` (
    `process_response_id` int NOT NULL PRIMARY KEY,
    `process_event_id` int NOT NULL,
    `event_acknowledged_by_person_id` int COMMENT 'The event acknowledge by person id is the unique identifier of the person who has acknowledged this Process Event.',
    `event_acknowledged_timestamp` timestamp
);

CREATE TABLE `PROCESS_Domain`.`Manufacturing_Process_Person` (
    `manufacturing_process_person_id` int NOT NULL PRIMARY KEY,
    `manufacturing_process_person_name` string COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `manufacturing_process_person_role` string
);

CREATE TABLE `PROCESS_Domain`.`Deviation_Rule` (
    `deviation_rule_id` int NOT NULL PRIMARY KEY,
    `process_event_type_id` int NOT NULL,
    `deviation_rule_summary` string
);

CREATE TABLE `PROCESS_Domain`.Deviation (
    `deviation_id` int NOT NULL PRIMARY KEY,
    `product_batch_id` int NOT NULL PRIMARY KEY,
    `deviation_rule_id` int,
    `process_event_id` int NOT NULL,
    `deviation_headline` string,
    `deviation_severity` string NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Process_Event_Type` (
    `process_event_type_id` int NOT NULL PRIMARY KEY,
    `process_event_type_name` string NOT NULL,
    `process_event_type_description` string
);

CREATE TABLE `PROCESS_Domain`.`Deviation_Assessment` (
    `deviation_assessed_by_id` int NOT NULL PRIMARY KEY,
    `deviation_id` int NOT NULL,
    `deviation_assessment_summary` string,
    `deviation_assessment_outcome` string NOT NULL
);

CREATE TABLE `PROCESS_Domain`.`Production_Run` (
    `production_run_id` int NOT NULL PRIMARY KEY,
    `product_batch_id` int NOT NULL,
    `recipe_id` int NOT NULL,
    `production_run_code` int,
    `production_run_start_date-time` timestamp NOT NULL COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.',
    `production_run_end_date-time` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.'
);

CREATE TABLE `PROCESS_Domain`.`Product_Batch` (
    `product_batch_id` int NOT NULL PRIMARY KEY,
    `product_batch_work_order_id` int,
    `product_batch_date-time` timestamp COMMENT 'This is the version of the recipe.  In SCADA this is a single integer that increments with each revision.'
);

ALTER TABLE `PROCESS_Domain`.Process_Response
ADD CONSTRAINT `fk_Process_Event_Node_process_event_id_to_Process_Event_process_event_id` FOREIGN KEY (`process event id`) REFERENCES `PROCESS_Domain`.Process_Event(`process event id`);

ALTER TABLE `PROCESS_Domain`.Process_Response
ADD CONSTRAINT `fk_Process_Event_Response_process_event_response_user_id_to_process_user_process_user_id` FOREIGN KEY (`event acknowledged by person id`) REFERENCES `PROCESS_Domain`.Manufacturing_Process_Person(`manufacturing process person id`);

ALTER TABLE `PROCESS_Domain`.Process_Event_Type
ADD CONSTRAINT `fk_Process_Event_Type_process_event_type_id_to_Process_Event_process_event_type_id` FOREIGN KEY (`process event type id`) REFERENCES `PROCESS_Domain`.Process_Event(`process event type id`);

ALTER TABLE `PROCESS_Domain`.Deviation
ADD CONSTRAINT `fk_Alarm_Process_Event_process_event_id_to_Process_Event_process_event_id` FOREIGN KEY (`process event id`) REFERENCES `PROCESS_Domain`.Process_Event(`process event id`);

ALTER TABLE `PROCESS_Domain`.Deviation_Rule
ADD CONSTRAINT `fk_deviation_rule_process_event_type_id_to_Process_Event_Type_process_event_type_id` FOREIGN KEY (`process event type id`) REFERENCES `PROCESS_Domain`.Process_Event_Type(`process event type id`);

ALTER TABLE `PROCESS_Domain`.Deviation_Assessment
ADD CONSTRAINT `fk_deviation(1)_deviation_id_to_deviation_deviation_id` FOREIGN KEY (`deviation id`) REFERENCES `PROCESS_Domain`.Deviation(`deviation id`);

ALTER TABLE `PROCESS_Domain`.Deviation
ADD CONSTRAINT `fk_Deviation_deviation_rule_id_to_Deviation_Rule_deviation_rule_id` FOREIGN KEY (`deviation rule id`) REFERENCES `PROCESS_Domain`.Deviation_Rule(`deviation rule id`);

ALTER TABLE `PROCESS_Domain`.Process_Event
ADD CONSTRAINT `fk_Sensor_Event_sensor_id_to_Sensor_sensor_id` FOREIGN KEY (`recipe id`) REFERENCES `PROCESS_Domain`.Recipe(`receipe id`);

ALTER TABLE `PROCESS_Domain`.Production_Run
ADD CONSTRAINT `fk_Sensor_Event_sensor_id_to_Sensor_sensor_id` FOREIGN KEY (`recipe id`) REFERENCES `PROCESS_Domain`.Recipe(`receipe id`);

ALTER TABLE `PROCESS_Domain`.Deviation
ADD CONSTRAINT `fk_Deviation_product_batch_id_to_Product_Batch_product_batch_id` FOREIGN KEY (`product batch id`) REFERENCES `PROCESS_Domain`.Product_Batch(`product batch id`);

ALTER TABLE `PROCESS_Domain`.Production_Run
ADD CONSTRAINT `fk_Production_Run_product_batch_id_to_Product_Batch_product_batch_id` FOREIGN KEY (`product batch id`) REFERENCES `PROCESS_Domain`.Product_Batch(`product batch id`);

ALTER TABLE `PROCESS_Domain`.Recipe
ADD CONSTRAINT `fk_Production_Run_product_batch_id_to_Product_Batch_product_batch_id` FOREIGN KEY (`product id`) REFERENCES `PROCESS_Domain`.Product_Batch(`product batch id`);

