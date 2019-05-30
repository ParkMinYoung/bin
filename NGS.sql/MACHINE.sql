.mode tabs
.headers on

CREATE TABLE MACHINE(
"sampleID" VARCHAR(25),
"platform" VARCHAR(20),
"Application" VARCHAR(20),
"machineID" VARCHAR(20),
"Read_order" INTEGER,
"Species" VARCHAR(100),
"specific_species" VARCHAR(255),
"index_seq" VARCHAR(50),
"lane" INTEGER,
"cycle" VARCHAR(25),
"service_ID" VARCHAR(255) NOT NULL,
"service_ID_E" VARCHAR(255) NOT NULL,
"yield" INTEGER,
"read_count" INTEGER,
"Q30" REAL,
"Mean_quality" REAL,
"md5sum" VARCHAR(255) not null,
"merge_info" VARCHAR(10),
"key" VARCHAR(255) primary key, 
"timestamp" TIMESTAMP NOT NULL DEFAULT current_timestamp
);
