use healthcare26;
show tables;
select * from doctor;
select * from treatment;
select * from visit;
select * from `lab test`;
select * from Patient;

#............KPIS.................#
Select
#...Total Patients.....#
      Concat(Round((Select count(*) from Patient)/1000.0,0),'K') as Total_Patients,
#...Total Doctors.....#      
      Concat(Round((Select count(*) from Doctor)/1000.0,0),'K') as Total_Doctors,
#...Total Visits.....#
      Concat(Round((Select count(*) from Visit)/1000.0,0),'K') as Total_Visit,
#...Avg Patient Age.....#
      Round((select Avg(Timestampdiff(Year,str_to_date(trim(dateofbirth), '%d-%m-%Y'), curdate())) 
      from Patient where str_to_date(trim(dateofbirth), '%d-%m-%Y') is not null),1)
      as Avg_Patient_Age,
#....Avg Treatment Cost....#
      concat('₹',format((Select avg(`Treatment cost`) from treatment),0))as avg_treatment_cost,
#...Avg % abnormal Reports.....#
      round((Select sum(case when `Test Result`='abnormal' then 1 else 0 end)*100/nullif(count(*),0) from `lab test`),2) as `avg % abnormal reports`; 
      

#.............Top 5 Diagnosis per visit ...............#
select diagnosis,count(*) as diagnosis_count from visit group by diagnosis order by diagnosis_Count desc limit 5;

#.............Total lab test Conducted...............#
select concat(round(count(*)/1000,0),'L') as Total_lab_Test_Conducted from `lab test`;

#.............Follow-Up Required...............#
select round(sum(case when lower(`Follow Up Required`)='Yes' then 1 else 0 end)*100.0/nullif(count(*),0),2)as  follow_up_require from visit;

#.............Doctors Workload by no.of.visit...............#
select d.`doctor name`, count(v.`visit id`) as Total_Visits from doctor d
join visit v on d.`doctor id`=v.`doctor id`
group by d.`doctor name`
order by Total_Visits desc
Limit 10;


        
