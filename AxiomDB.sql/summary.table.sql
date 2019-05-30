CREATE TABLE summary(
"probeset_id" VARCHAR(255) NOT NULL,
"id" VARCHAR(255),
"set" NCHAR(8),
"well" NCHAR(3),
"axiom_dishqc_DQC" REAL,
"apt_geno_qc_gender" VARCHAR(20), 
"apt_probeset_genotype_gender" VARCHAR(20), 
"call_rate" REAL,
"het_rate" REAL,
"cn-probe-chrXY-ratio_gender_meanX" REAL,
"cn-probe-chrXY-ratio_gender_meanY" REAL,
"cn-probe-chrXY-ratio_gender_ratio" REAL
);

