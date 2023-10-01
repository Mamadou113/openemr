--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
CREATE TABLE `billing` (
  `id` int(11) NOT NULL auto_increment,
  `date` datetime default NULL,
  `code_type` varchar(15) default NULL,
  `code` varchar(20) default NULL,
  `pid` bigint(20) default NULL,
  `provider_id` int(11) default NULL,
  `user` int(11) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(1) default NULL,
  `encounter` int(11) default NULL,
  `code_text` longtext,
  `billed` tinyint(1) default NULL,
  `activity` tinyint(1) default NULL,
  `payer_id` int(11) default NULL,
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_date` datetime default NULL,
  `process_date` datetime default NULL,
  `process_file` varchar(255) default NULL,
  `modifier` varchar(12) default NULL,
  `units` int(11) default NULL,
  `fee` decimal(12,2) default NULL,
  `justify` varchar(255) default NULL,
  `target` varchar(30) default NULL,
  `x12_partner_id` int(11) default NULL,
  `ndc_info` varchar(255) default NULL,
  `notecodes` varchar(25) NOT NULL default '',
  `external_id` VARCHAR(20) DEFAULT NULL,
  `pricelevel` varchar(31) default '',
  `revenue_code` varchar(6) NOT NULL default '' COMMENT 'Item revenue code',
  `chargecat` varchar(31) default '' COMMENT 'Charge category or customer',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------
--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL default '0',
  `uuid` binary(16) DEFAULT NULL,
  `type` enum('file_url','blob','web_url') default NULL,
  `size` int(11) default NULL,
  `date` datetime default NULL,
  `date_expires` datetime default NULL,
  `url` varchar(255) default NULL,
  `thumb_url` varchar(255) default NULL,
  `mimetype` varchar(255) default NULL,
  `pages` int(11) default NULL,
  `owner` int(11) default NULL,
  `revision` timestamp NOT NULL,
  `foreign_id` bigint(20) default NULL,
  `docdate` date default NULL,
  `hash` varchar(255) DEFAULT NULL,
  `list_id` bigint(20) NOT NULL default '0',
  `name` varchar(255) DEFAULT NULL,
  `drive_uuid` binary(16) DEFAULT NULL,
  `couch_docid` VARCHAR(100) DEFAULT NULL,
  `couch_revid` VARCHAR(100) DEFAULT NULL,
  `storagemethod` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '0->Harddisk,1->CouchDB',
  `path_depth` TINYINT DEFAULT '1' COMMENT 'Depth of path to use in url to find document. Not applicable for CouchDB.',
  `imported` TINYINT DEFAULT 0 NULL COMMENT 'Parsing status for CCR/CCD/CCDA importing',
  `encounter_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Encounter id if tagged',
  `encounter_check` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'If encounter is created while tagging',
  `audit_master_approval_status` TINYINT NOT NULL DEFAULT 1 COMMENT 'approval_status from audit_master table',
  `audit_master_id` int(11) default NULL,
  `documentationOf` varchar(255) DEFAULT NULL,
  `encrypted` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '0->No,1->Yes',
  `document_data` MEDIUMTEXT,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `foreign_reference_id` bigint(20) default NULL,
  `foreign_reference_table` VARCHAR(40) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `drive_uuid` (`drive_uuid`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `revision` (`revision`),
  KEY `foreign_id` (`foreign_id`),
  KEY `foreign_reference` (`foreign_reference_id`, `foreign_reference_table`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB;


-- --------------------------------------------------------

--
-- Table structure for table `drug_inventory`
--

DROP TABLE IF EXISTS `drug_inventory`;
CREATE TABLE `drug_inventory` (
  `inventory_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `lot_number` varchar(20) default NULL,
  `expiration` date default NULL,
  `manufacturer` varchar(255) default NULL,
  `on_hand` int(11) NOT NULL default '0',
  `warehouse_id` varchar(31) NOT NULL DEFAULT '',
  `vendor_id` bigint(20) NOT NULL DEFAULT 0,
  `last_notify` date NULL,
  `destroy_date` date default NULL,
  `destroy_method` varchar(255) default NULL,
  `destroy_witness` varchar(255) default NULL,
  `destroy_notes` varchar(255) default NULL,
  PRIMARY KEY  (`inventory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `drug_sales`
--

DROP TABLE IF EXISTS `drug_sales`;
CREATE TABLE `drug_sales` (
  `sale_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL default '0',
  `pid` bigint(20) NOT NULL default '0',
  `encounter` int(11) NOT NULL default '0',
  `user` varchar(255) default NULL,
  `sale_date` date NOT NULL,
  `quantity` int(11) NOT NULL default '0',
  `fee` decimal(12,2) NOT NULL default '0.00',
  `billed` tinyint(1) NOT NULL default '0' COMMENT 'indicates if the sale is posted to accounting',
  `xfer_inventory_id` int(11) NOT NULL DEFAULT 0,
  `distributor_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'references users.id',
  `notes` varchar(255) NOT NULL DEFAULT '',
  `bill_date` datetime default NULL,
  `pricelevel` varchar(31) default '',
  `selector` varchar(255) default '' comment 'references drug_templates.selector',
  `trans_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=sale, 2=purchase, 3=return, 4=transfer, 5=adjustment',
  `chargecat` varchar(31) default '',
  PRIMARY KEY  (`sale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `drugs`
--

DROP TABLE IF EXISTS `drugs`;
CREATE TABLE `drugs` (
  `drug_id` int(11) NOT NULL auto_increment,
  `uuid` binary(16) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `ndc_number` varchar(20) NOT NULL DEFAULT '',
  `on_order` int(11) NOT NULL default '0',
  `reorder_point` float NOT NULL DEFAULT 0.0,
  `max_level` float NOT NULL DEFAULT 0.0,
  `last_notify` date NULL,
  `reactions` text,
  `form` varchar(31) NOT NULL default '0',
  `size` varchar(25) NOT NULL default '',
  `unit` varchar(31) NOT NULL default '0',
  `route` varchar(31) NOT NULL default '0',
  `substitute` int(11) NOT NULL default '0',
  `related_code` varchar(255) NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  `active` TINYINT(1) DEFAULT 1 COMMENT '0 = inactive, 1 = active',
  `allow_combining` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = allow filling an order from multiple lots',
  `allow_multiple`  tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = allow multiple lots at one warehouse',
  `drug_code` varchar(25) NULL,
  `consumable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = will not show on the fee sheet',
  `dispensable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 = pharmacy elsewhere, 1 = dispensed here',
  PRIMARY KEY  (`drug_id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `employer_data`
--

DROP TABLE IF EXISTS `employer_data`;
CREATE TABLE `employer_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `street` varchar(255) default NULL,
  `street_line_2` TINYTEXT,
  `postal_code` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility` (
  `id` int(11) NOT NULL auto_increment,
  `uuid` binary(16) DEFAULT NULL,
  `name` varchar(255) default NULL,
  `phone` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `street` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(50) default NULL,
  `postal_code` varchar(11) default NULL,
  `country_code` varchar(30) NOT NULL default '',
  `federal_ein` varchar(15) default NULL,
  `website` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `service_location` tinyint(1) NOT NULL default '1',
  `billing_location` tinyint(1) NOT NULL default '1',
  `accepts_assignment` tinyint(1) NOT NULL default '1',
  `pos_code` tinyint(4) default NULL,
  `x12_sender_id` varchar(25) default NULL,
  `attn` varchar(65) default NULL,
  `domain_identifier` varchar(60) default NULL,
  `facility_npi` varchar(15) default NULL,
  `facility_taxonomy` varchar(15) default NULL,
  `tax_id_type` VARCHAR(31) NOT NULL DEFAULT '',
  `color` VARCHAR(7) NOT NULL DEFAULT '',
  `primary_business_entity` INT(10) NOT NULL DEFAULT '1' COMMENT '0-Not Set as business entity 1-Set as business entity',
  `facility_code` VARCHAR(31) default NULL,
  `extra_validation` tinyint(1) NOT NULL DEFAULT '1',
  `mail_street` varchar(30) default NULL,
  `mail_street2` varchar(30) default NULL,
  `mail_city` varchar(50) default NULL,
  `mail_state` varchar(3) default NULL,
  `mail_zip` varchar(10) default NULL,
  `oid` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'HIEs CCDA and FHIR an OID is required/wanted',
  `iban` varchar(50) default NULL,
  `info` TEXT,
  `weno_id` VARCHAR(10) DEFAULT NULL,
  `inactive` tinyint(1) NOT NULL DEFAULT '0',
  UNIQUE KEY `uuid` (`uuid`),
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4;


-- --------------------------------------------------------

--
-- Table structure for table `history_data`
--

DROP TABLE IF EXISTS `history_data`;
CREATE TABLE `history_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `uuid` binary(16) DEFAULT NULL,
  `coffee` longtext,
  `tobacco` longtext,
  `alcohol` longtext,
  `sleep_patterns` longtext,
  `exercise_patterns` longtext,
  `seatbelt_use` longtext,
  `counseling` longtext,
  `hazardous_activities` longtext,
  `recreational_drugs` longtext,
  `last_breast_exam` varchar(255) default NULL,
  `last_mammogram` varchar(255) default NULL,
  `last_gynocological_exam` varchar(255) default NULL,
  `last_rectal_exam` varchar(255) default NULL,
  `last_prostate_exam` varchar(255) default NULL,
  `last_physical_exam` varchar(255) default NULL,
  `last_sigmoidoscopy_colonoscopy` varchar(255) default NULL,
  `last_ecg` varchar(255) default NULL,
  `last_cardiac_echo` varchar(255) default NULL,
  `last_retinal` varchar(255) default NULL,
  `last_fluvax` varchar(255) default NULL,
  `last_pneuvax` varchar(255) default NULL,
  `last_ldl` varchar(255) default NULL,
  `last_hemoglobin` varchar(255) default NULL,
  `last_psa` varchar(255) default NULL,
  `last_exam_results` varchar(255) default NULL,
  `history_mother` longtext,
  `dc_mother` text,
  `history_father` longtext,
  `dc_father`  text,
  `history_siblings` longtext,
  `dc_siblings` text,
  `history_offspring` longtext,
  `dc_offspring` text,
  `history_spouse` longtext,
  `dc_spouse` text,
  `relatives_cancer` longtext,
  `relatives_tuberculosis` longtext,
  `relatives_diabetes` longtext,
  `relatives_high_blood_pressure` longtext,
  `relatives_heart_problems` longtext,
  `relatives_stroke` longtext,
  `relatives_epilepsy` longtext,
  `relatives_mental_illness` longtext,
  `relatives_suicide` longtext,
  `cataract_surgery` datetime default NULL,
  `tonsillectomy` datetime default NULL,
  `cholecystestomy` datetime default NULL,
  `heart_surgery` datetime default NULL,
  `hysterectomy` datetime default NULL,
  `hernia_repair` datetime default NULL,
  `hip_replacement` datetime default NULL,
  `knee_replacement` datetime default NULL,
  `appendectomy` datetime default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  `name_1` varchar(255) default NULL,
  `value_1` varchar(255) default NULL,
  `name_2` varchar(255) default NULL,
  `value_2` varchar(255) default NULL,
  `additional_history` text,
  `exams` text,
  `usertext11` TEXT,
  `usertext12` varchar(255) NOT NULL DEFAULT '',
  `usertext13` varchar(255) NOT NULL DEFAULT '',
  `usertext14` varchar(255) NOT NULL DEFAULT '',
  `usertext15` varchar(255) NOT NULL DEFAULT '',
  `usertext16` varchar(255) NOT NULL DEFAULT '',
  `usertext17` varchar(255) NOT NULL DEFAULT '',
  `usertext18` varchar(255) NOT NULL DEFAULT '',
  `usertext19` varchar(255) NOT NULL DEFAULT '',
  `usertext20` varchar(255) NOT NULL DEFAULT '',
  `usertext21` varchar(255) NOT NULL DEFAULT '',
  `usertext22` varchar(255) NOT NULL DEFAULT '',
  `usertext23` varchar(255) NOT NULL DEFAULT '',
  `usertext24` varchar(255) NOT NULL DEFAULT '',
  `usertext25` varchar(255) NOT NULL DEFAULT '',
  `usertext26` varchar(255) NOT NULL DEFAULT '',
  `usertext27` varchar(255) NOT NULL DEFAULT '',
  `usertext28` varchar(255) NOT NULL DEFAULT '',
  `usertext29` varchar(255) NOT NULL DEFAULT '',
  `usertext30` varchar(255) NOT NULL DEFAULT '',
  `userdate11` date DEFAULT NULL,
  `userdate12` date DEFAULT NULL,
  `userdate13` date DEFAULT NULL,
  `userdate14` date DEFAULT NULL,
  `userdate15` date DEFAULT NULL,
  `userarea11` text,
  `userarea12` text,
  `created_by` BIGINT(20) DEFAULT NULL COMMENT 'users.id the user that first created this record',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `patient_data`
--

DROP TABLE IF EXISTS `patient_data`;
CREATE TABLE `patient_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `uuid` binary(16) DEFAULT NULL,
  `title` varchar(255) NOT NULL default '',
  `language` varchar(255) NOT NULL default '',
  `financial` varchar(255) NOT NULL default '',
  `fname` varchar(255) NOT NULL default '',
  `lname` varchar(255) NOT NULL default '',
  `mname` varchar(255) NOT NULL default '',
  `DOB` date default NULL,
  `street` varchar(255) NOT NULL default '',
  `postal_code` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `country_code` varchar(255) NOT NULL default '',
  `drivers_license` varchar(255) NOT NULL default '',
  `ss` varchar(255) NOT NULL default '',
  `occupation` longtext,
  `phone_home` varchar(255) NOT NULL default '',
  `phone_biz` varchar(255) NOT NULL default '',
  `phone_contact` varchar(255) NOT NULL default '',
  `phone_cell` varchar(255) NOT NULL default '',
  `pharmacy_id` int(11) NOT NULL default '0',
  `status` varchar(255) NOT NULL default '',
  `contact_relationship` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  `sex` varchar(255) NOT NULL default '',
  `referrer` varchar(255) NOT NULL default '',
  `referrerID` varchar(255) NOT NULL default '',
  `providerID` int(11) default NULL,
  `ref_providerID` int(11) default NULL,
  `email` varchar(255) NOT NULL default '',
  `email_direct` varchar(255) NOT NULL default '',
  `ethnoracial` varchar(255) NOT NULL default '',
  `race` varchar(255) NOT NULL default '',
  `ethnicity` varchar(255) NOT NULL default '',
  `religion` varchar(40) NOT NULL default '',
  `interpretter` varchar(255) NOT NULL default '',
  `migrantseasonal` varchar(255) NOT NULL default '',
  `family_size` varchar(255) NOT NULL default '',
  `monthly_income` varchar(255) NOT NULL default '',
  `billing_note` text,
  `homeless` varchar(255) NOT NULL default '',
  `financial_review` datetime default NULL,
  `pubpid` varchar(255) NOT NULL default '',
  `pid` bigint(20) NOT NULL default '0',
  `genericname1` varchar(255) NOT NULL default '',
  `genericval1` varchar(255) NOT NULL default '',
  `genericname2` varchar(255) NOT NULL default '',
  `genericval2` varchar(255) NOT NULL default '',
  `hipaa_mail` varchar(3) NOT NULL default '',
  `hipaa_voice` varchar(3) NOT NULL default '',
  `hipaa_notice` varchar(3) NOT NULL default '',
  `hipaa_message` varchar(20) NOT NULL default '',
  `hipaa_allowsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `hipaa_allowemail` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `squad` varchar(32) NOT NULL default '',
  `fitness` int(11) NOT NULL default '0',
  `referral_source` varchar(30) NOT NULL default '',
  `usertext1` varchar(255) NOT NULL DEFAULT '',
  `usertext2` varchar(255) NOT NULL DEFAULT '',
  `usertext3` varchar(255) NOT NULL DEFAULT '',
  `usertext4` varchar(255) NOT NULL DEFAULT '',
  `usertext5` varchar(255) NOT NULL DEFAULT '',
  `usertext6` varchar(255) NOT NULL DEFAULT '',
  `usertext7` varchar(255) NOT NULL DEFAULT '',
  `usertext8` varchar(255) NOT NULL DEFAULT '',
  `userlist1` varchar(255) NOT NULL DEFAULT '',
  `userlist2` varchar(255) NOT NULL DEFAULT '',
  `userlist3` varchar(255) NOT NULL DEFAULT '',
  `userlist4` varchar(255) NOT NULL DEFAULT '',
  `userlist5` varchar(255) NOT NULL DEFAULT '',
  `userlist6` varchar(255) NOT NULL DEFAULT '',
  `userlist7` varchar(255) NOT NULL DEFAULT '',
  `pricelevel` varchar(255) NOT NULL default 'standard',
  `regdate`     DATETIME DEFAULT NULL COMMENT 'Registration Date',
  `contrastart` date DEFAULT NULL COMMENT 'Date contraceptives initially used',
  `completed_ad` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `ad_reviewed` date DEFAULT NULL,
  `vfc` varchar(255) NOT NULL DEFAULT '',
  `mothersname` varchar(255) NOT NULL DEFAULT '',
  `guardiansname` TEXT,
  `allow_imm_reg_use` varchar(255) NOT NULL DEFAULT '',
  `allow_imm_info_share` varchar(255) NOT NULL DEFAULT '',
  `allow_health_info_ex` varchar(255) NOT NULL DEFAULT '',
  `allow_patient_portal` varchar(31) NOT NULL DEFAULT '',
  `deceased_date` datetime default NULL,
  `deceased_reason` varchar(255) NOT NULL default '',
  `soap_import_status` TINYINT(4) DEFAULT NULL COMMENT '1-Prescription Press 2-Prescription Import 3-Allergy Press 4-Allergy Import',
  `cmsportal_login` varchar(60) NOT NULL default '',
  `care_team_provider` TEXT,
  `care_team_facility` TEXT,
  `care_team_status` TEXT,
  `county` varchar(40) NOT NULL default '',
  `industry` TEXT,
  `imm_reg_status` TEXT,
  `imm_reg_stat_effdate` TEXT,
  `publicity_code` TEXT,
  `publ_code_eff_date` TEXT,
  `protect_indicator` TEXT,
  `prot_indi_effdate` TEXT,
  `guardianrelationship` TEXT,
  `guardiansex` TEXT,
  `guardianaddress` TEXT,
  `guardiancity` TEXT,
  `guardianstate` TEXT,
  `guardianpostalcode` TEXT,
  `guardiancountry` TEXT,
  `guardianphone` TEXT,
  `guardianworkphone` TEXT,
  `guardianemail` TEXT,
  `sexual_orientation` TEXT,
  `gender_identity` TEXT,
  `birth_fname` TEXT,
  `birth_lname` TEXT,
  `birth_mname` TEXT,
  `dupscore` INT NOT NULL default -9,
  `name_history` TINYTEXT,
  `suffix` TINYTEXT,
  `street_line_2` TINYTEXT,
  `patient_groups` TEXT,
  `prevent_portal_apps` TEXT,
  `provider_since_date` TINYTEXT,
  `created_by` BIGINT(20) DEFAULT NULL COMMENT 'users.id the user that first created this record',
  `updated_by` BIGINT(20) DEFAULT NULL COMMENT 'users.id the user that last modified this record',
  `preferred_name` TINYTEXT,
  UNIQUE KEY `pid` (`pid`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1;
-- --------------------------------------------------------

--
-- Table structure for table `patient_history` that is a dependent table on `patient_data`
DROP TABLE IF EXISTS `patient_history`;
CREATE TABLE `patient_history` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT
    , `uuid` BINARY(16) NULL
    , `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , `care_team_provider` TEXT
    , `care_team_facility` TEXT
    , `pid` BIGINT(20) NOT NULL
    , `history_type_key` varchar(36) DEFAULT NULL
    , `previous_name_prefix` TEXT
    , `previous_name_first` TEXT
    , `previous_name_middle` TEXT
    , `previous_name_last` TEXT
    , `previous_name_suffix` TEXT
    , `previous_name_enddate` date DEFAULT NULL
    ,`created_by` BIGINT(20) DEFAULT NULL COMMENT 'users.id the user that first created this record'
    , PRIMARY KEY (`id`)
    , UNIQUE `uuid` (`uuid`)
    , KEY `pid_idx` (`pid`)
) ENGINE = InnoDB;