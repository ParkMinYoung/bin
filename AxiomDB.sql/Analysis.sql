.mode tabs
.headers on

create table Analysis(

"probeset_id" VARCHAR(255) NOT NULL,
"id" VARCHAR(255) NOT NULL,
"set" NCHAR(8) NOT NULL,
"well" NCHAR(3) NOT NULL,
"axiom_dishqc_DQC" REAL,
"apt_geno_qc_gender" VARCHAR(20) NOT NULL,
"apt_probeset_genotype_gender" VARCHAR(20) NOT NULL, 
"call_rate" REAL,
"het_rate" REAL,
"cn-probe-chrXY-ratio_gender_meanX" REAL,
"cn-probe-chrXY-ratio_gender_meanY" REAL,
"cn-probe-chrXY-ratio_gender_ratio" REAL,
"fluidics_date" VARCHAR(255),
"serial_num" VARCHAR(10),
"platescanGUIDF" VARCHAR(255),
"md5sum" VARCHAR(255) not null,
"flatform" VARCHAR(50) NOT NULL, 
"run_type" VARCHAR(50) NOT NULL, 
"sample_size" INTEGER,
"library" VARCHAR(50) NOT NULL,
"annotation" VARCHAR(10),
"service_id" VARCHAR(255) NOT NULL,
"pwd" VARCHAR(255) NOT NULL,
"key" VARCHAR(255) primary key, 
"timestamp" TIMESTAMP NOT NULL DEFAULT current_timestamp
);

